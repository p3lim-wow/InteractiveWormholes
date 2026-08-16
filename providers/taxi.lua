local addonName, addon = ...

-- upvalue API because we disable it
-- local C_TaxiMap_ShouldMapShowTaxiNodes = C_TaxiMap.ShouldMapShowTaxiNodes

local ShouldUseInstanceMap; do
	-- most instances should use the default map UI, but there are some where it doesn't matter
	local INSTANCE_USE_WORLD_MAP = {
		[2093] = true, -- The Nokhud Offensive
	}

	function ShouldUseInstanceMap()
		if GetTaxiMapID() == 994 then
			-- use taxi map on Argus because the map is a mess there
			return true
		end

		local inInstance, instanceType = IsInInstance()
		if inInstance and instanceType ~= 'neighborhood' then
			return not INSTANCE_USE_WORLD_MAP[C_Map.GetBestMapForUnit('player') or 0]
		end
	end
end

local provider = addon:CreatePinProvider()
local taxiData = addon:T()

function provider:OnPinClick(pin, button, down)
	if button == 'LeftButton' and not down and not taxiData[pin:GetID()].isMapLayerTransition then
		TakeTaxiNode(pin:GetID())
	end
end

function provider:OnPinEnter(pin)
	local taxiNodeSlotIndex = pin:GetID()
	local taxiNodeInfo = taxiData[taxiNodeSlotIndex]

	local tooltip = addon:GetTooltip(pin, 'ANCHOR_RIGHT')
	tooltip:AddLine(taxiNodeInfo.name)

	local vias, source
	if taxiNodeInfo.state == Enum.FlightPathState.Current then
		tooltip:AddLine(TAXINODEYOUAREHERE, 1, 1, 1)
	elseif taxiNodeInfo.state == Enum.FlightPathState.Reachable then
		local cost = TaxiNodeCost(taxiNodeSlotIndex)
		if cost > 0 then
			tooltip:AddLine(GetMoneyString(cost), WHITE_FONT_COLOR:GetRGB())
		elseif taxiNodeInfo.specialIconCostString then
			if taxiNodeInfo.useSpecialIcon then
				tooltip:AddLine(taxiNodeInfo.specialIconCostString, 1, 1, 1)
			else
				tooltip:AddLine(taxiNodeInfo.specialIconCostString, RED_FONT_COLOR:GetRGB())
			end
		end

		-- highlight
		pin:SetNormalAtlas(taxiNodeInfo.atlasFormat:format('Taxi_Frame_Yellow'))

		-- track vias
		local numRoutes = GetNumRoutes(taxiNodeSlotIndex)
		if numRoutes > 1 then
			vias = {}
		end

		-- route lines, ripped (mostly) from FlightMap_FlightPathDataProviderMixin.HighlightRouteToPin
		for routeIndex = 1, numRoutes do
			local sourceNodeInfo = taxiData[TaxiGetNodeSlot(taxiNodeSlotIndex, routeIndex, true)]
			local destinationNodeInfo = taxiData[TaxiGetNodeSlot(taxiNodeSlotIndex, routeIndex, false)]

			if not source then
				source = sourceNodeInfo
			end

			if sourceNodeInfo ~= nil and destinationNodeInfo ~= nil then
				local sourcePin = self:GetPinByID(sourceNodeInfo.slotIndex)
				local destinationPin = self:GetPinByID(destinationNodeInfo.slotIndex)

				if vias and routeIndex > 1 then
					table.insert(vias, sourceNodeInfo.name)
				end

				if sourcePin then
					-- force show all pins in the route, even if they're undiscovered
					sourcePin:Show()
					destinationPin:Show()

					addon:AttachLine(sourcePin, destinationPin)
				end
			end
		end
	elseif taxiNodeInfo.state == Enum.FlightPathState.Unreachable and not taxiNodeInfo.isMapLayerTransition then
		tooltip:AddLine(TAXI_PATH_UNREACHABLE, RED_FONT_COLOR:GetRGB())
	end

	if vias then
		tooltip:AddLine(' ')
		for i, name in next, vias do
			tooltip:AddLine(i .. '. ' .. name, 2/3, 2/3, 2/3, false)
		end
	end

	if source and InFlight then
		local sourceDestinations
		if InFlight.noFactionsZoneNodes[taxiNodeInfo.nodeID] then
			sourceDestinations = InFlight.db.global.FactionlessZones[source.nodeID]
		else
			sourceDestinations = InFlight.db.global[(UnitFactionGroup('player'))][source.nodeID]
		end

		if sourceDestinations and sourceDestinations[taxiNodeInfo.nodeID] then
			local time = addon:FormatTime(sourceDestinations[taxiNodeInfo.nodeID])
			tooltip:AddLine(' ')
			tooltip:AddLine('|A:activities-clock-standard:0:0:0:0|a ' .. time, 1, 1, 1)
		end
	elseif source and TaxiTimerAPI then
		local flightInfo = TaxiTimerAPI.GetFlightInfo(taxiNodeInfo.slotIndex)
		if flightInfo then
			local time = addon:FormatTime(flightInfo.distance / flightInfo.speed)
			tooltip:AddLine(' ')
			tooltip:AddLine('|A:activities-clock-standard:0:0:0:0|a ' .. time, 1, 1, 1)
		end
	end

	if IsShiftKeyDown() then
		tooltip:AddLine(taxiNodeInfo.nodeID)
	end

	tooltip:Show()
end

function provider:OnPinLeave(pin)
	addon:HideTooltip()
	addon:ReleaseLines()

	-- ripped from FlightMap_FlightPointPinMixin.OnMouseLeave
	local taxiNodeInfo = taxiData[pin:GetID()]
	if taxiNodeInfo.state == Enum.FlightPathState.Reachable and taxiNodeInfo.atlasFormat then
		if taxiNodeInfo.useSpecialIcon then
			pin:SetNormalAtlas(taxiNodeInfo.atlasFormat:format('Taxi_Frame_Special'))
		else
			pin:SetNormalAtlas(taxiNodeInfo.atlasFormat:format('Taxi_Frame_Gray'))
		end
	end

	-- reset pin visibility
	for enumeratedPin in provider:EnumeratePins() do
		local info = taxiData[enumeratedPin:GetID()]
		enumeratedPin:SetShown(info.state ~= Enum.FlightPathState.Unreachable or info.isMapLayerTransition)
	end
end

function provider:GetPinByID(id)
	for pin in self:EnumeratePins() do
		if pin:GetID() == id then
			return pin
		end
	end
end

local function updatePin(pin)
	local taxiNodeInfo = taxiData[pin:GetID()]

	-- only show pins if part of a route or a layer transition point
	pin:SetShown(taxiNodeInfo.state ~= Enum.FlightPathState.Unreachable or taxiNodeInfo.isMapLayerTransition)

	-- size logic ripped (mostly) from FlightMap_FlightPointPinMixin.UpdatePinSize
	if taxiNodeInfo.isMapLayerTransition then
		pin:Lower() -- don't render transitions above real destinations
		pin:SetSize(20, 20)
	elseif taxiNodeInfo.textureKit == 'FlightMaster_VindicaarArgus' or taxiNodeInfo.textureKit == 'FlightMaster_VindicaarStygianWake' or taxiNodeInfo.textureKit == 'FlightMaster_VindicaarMacAree' then
		pin:SetSize(39, 42)
	elseif taxiNodeInfo.textureKit == 'FlightMaster_Argus' then
		pin:SetSize(34, 28)
	elseif taxiNodeInfo.textureKit == 'FlightMaster_Bastion' then
		if taxiNodeInfo.state == Enum.FlightPathState.Current then
			pin:SetSize(26, 26)
		elseif taxiNodeInfo.state == Enum.FlightPathState.Reachable or taxiNodeInfo.state == Enum.FlightPathState.Unreachable then
			pin:SetSize(24, 24)
		end
	elseif taxiNodeInfo.textureKit == 'FlightMaster_Ferry' then
		if taxiNodeInfo.state == Enum.FlightPathState.Current then
			pin:SetSize(36, 24)
		elseif taxiNodeInfo.state == Enum.FlightPathState.Reachable or taxiNodeInfo.state == Enum.FlightPathState.Unreachable then
			pin:SetSize(28, 19)
		end
	else
		-- extra handling for obelisk system in Zereth Mortis so we can use atlas
		local widthMultiplier = 1
		if taxiNodeInfo.textureKit == 'FlightMaster_ProgenitorObelisk' then
			widthMultiplier = 0.5
		end

		if taxiNodeInfo.state == Enum.FlightPathState.Current then
			pin:SetSize(28 * widthMultiplier, 28)
		elseif taxiNodeInfo.state == Enum.FlightPathState.Reachable then
			pin:SetSize(20 * widthMultiplier, 20)
		elseif taxiNodeInfo.state == Enum.FlightPathState.Unreachable then
			pin:SetSize(14 * widthMultiplier, 14)
		end
	end

	-- texture logic ripped (mostly) from FlightMap_FlightPointPinMixin.SetFlightPathStyle
	local atlasFormat = '%s'
	if taxiNodeInfo.textureKit then
		atlasFormat = taxiNodeInfo.textureKit .. '-%s'
	end

	if taxiNodeInfo.isMapLayerTransition then
		pin:SetNormalAtlas(atlasFormat:format('Taxi_Frame_Gray'))
		pin:SetHighlightAtlas(atlasFormat:format('Taxi_Frame_Gray'), 'ADD')
	elseif taxiNodeInfo.state == Enum.FlightPathState.Current then
		pin:SetNormalAtlas(atlasFormat:format('Taxi_Frame_Green'))
		pin:SetHighlightAtlas(atlasFormat:format('Taxi_Frame_Gray'), 'ADD')
	elseif taxiNodeInfo.state == Enum.FlightPathState.Unreachable then
		pin:SetNormalAtlas(atlasFormat:format('UI-Taxi-Icon-Nub'))
		pin:SetHighlightAtlas(atlasFormat:format('UI-Taxi-Icon-Nub'), 'ADD')
	elseif taxiNodeInfo.state == Enum.FlightPathState.Reachable then
		if taxiNodeInfo.useSpecialIcon then
			pin:SetNormalAtlas(atlasFormat:format('Taxi_Frame_Special'))
		else
			pin:SetNormalAtlas(atlasFormat:format('Taxi_Frame_Gray'))
		end

		pin:SetHighlightAtlas(atlasFormat:format('Taxi_Frame_Gray'), 'ADD')
	end

	-- inject the format so we don't have to keep re-defining it
	taxiNodeInfo.atlasFormat = atlasFormat

	-- render current path lower so we can more easily click others close to it
	if taxiNodeInfo.state == Enum.FlightPathState.Current then
		pin:Lower()
	end

	-- attach arrows to reachable nodes
	if taxiNodeInfo.state ~= Enum.FlightPathState.Unreachable and taxiNodeInfo.textureKit ~= 'FlightMaster_ProgenitorObelisk' then
		addon:AttachArrow(pin)
	end
end

function provider:OnRefresh()
	for slotIndex, taxiNodeInfo in next, taxiData do
		local pin = self:AddPin(taxiNodeInfo.mapID, taxiNodeInfo.position:GetXY())
		if pin then
			pin:SetID(slotIndex)
			updatePin(pin)
		end

		local displayExtra = taxiNodeInfo.displayExtra
		if displayExtra then
			pin = self:AddPin(displayExtra.mapID, displayExtra.x, displayExtra.y)
			if pin then
				pin:SetID(slotIndex)
				updatePin(pin)
			end
		end
	end
end

function provider:OnMapHide()
	CloseTaxiMap()
end

local function OnTaxiOpened()
	if InCombatLockdown() then
		-- player can't take a flight in combat anyways, so we bail here
		CloseTaxiMap()
		UIErrorsFrame:AddExternalErrorMessage(ERR_NOT_IN_COMBAT)
		return
	end

	if ShouldUseInstanceMap() then
		-- use stock flight map in dungeons unless specifically handled
		if C_AddOns.LoadAddOn('Blizzard_FlightMap') and FlightMapFrame then
			ShowUIPanel(FlightMapFrame)
		end

		return
	end

	-- I'd rather control the POI template, but it refreshes by itself, so we have to do this
	-- to hide POI pins that would otherwise overlap (and nudge) the taxi pins
	-- C_TaxiMap.ShouldMapShowTaxiNodes = function() end

	-- use the nearest continent as the source for taxi nodes
	local mapID = addon:GetPlayerMapID()
	local mapInfo = C_Map.GetMapInfo(mapID)
	while mapInfo.mapType > Enum.UIMapType.Continent do
		mapID = mapInfo.parentMapID
		mapInfo = C_Map.GetMapInfo(mapID)
	end

	-- gather taxi nodes from that map
	for _, zoneInfo in next, C_Map.GetMapChildrenInfo(mapID, Enum.UIMapType.Zone, true) do
		for _, taxiNodeInfo in next, C_TaxiMap.GetAllTaxiNodes(zoneInfo.mapID) do
			if not taxiData[taxiNodeInfo.slotIndex] then
				taxiNodeInfo.mapID = zoneInfo.mapID
				taxiNodeInfo.displayExtra = addon.taxi[taxiNodeInfo.nodeID]
				taxiData[taxiNodeInfo.slotIndex] = taxiNodeInfo
			end
		end
	end

	if addon:GetOption('taxiContinent') then
		C_Map.OpenWorldMap(mapID)
	else
		C_Map.OpenWorldMap()
	end
end

local function OnTaxiClosed()
	if WorldMapFrame:IsShown() then
		HideUIPanel(WorldMapFrame)
	end

	taxiData:wipe()

	-- restore API
	-- C_TaxiMap.ShouldMapShowTaxiNodes = C_TaxiMap_ShouldMapShowTaxiNodes
end

local function Enable()
	-- disable default taxi maps
	GameEvent.UnregisterInternalEvent('TAXIMAP_OPENED')

	if TaxiFrame then
		TaxiFrame:UnregisterAllEvents()
	end

	-- register our events
	if not addon:IsEventRegistered('TAXIMAP_OPENED', OnTaxiOpened) then
		addon:RegisterEvent('TAXIMAP_OPENED', OnTaxiOpened)
		addon:RegisterEvent('TAXIMAP_CLOSED', OnTaxiClosed)
	end
end

local function Disable()
	-- re-register default events
	GameEvent.RegisterInternalEvent('TAXIMAP_OPENED', GenerateClosure(GameEvent.HandleTaxiMapOpened)) -- potential taint?

	if TaxiFrame then
		TaxiFrame:RegisterEvent('TAXIMAP_CLOSED')
	end

	-- unregister our events
	addon:UnregisterEvent('TAXIMAP_OPENED', OnTaxiOpened)
	addon:UnregisterEvent('TAXIMAP_CLOSED', OnTaxiClosed)
end

-- onboarding
addon:RegisterOptionCallback('taxi', function(value)
	if value then
		Enable()

		-- WorldFlightMap does pretty much the same thing, but is outdated and broken, and the author is not
		-- responding to my pull requests to fix it, so we disable it to prevent collisions
		if C_AddOns.DoesAddOnExist('WorldFlightMap') and C_AddOns.IsAddOnLoadable('WorldFlightMap') then
			C_AddOns.DisableAddOn('WorldFlightMap')
		end
	else
		Disable()
	end
end)

addon:HookAddOn('Blizzard_FlightMap', function()
	if InteractiveWormholesDB.taxiPrompted then
		return
	end

	FlightMapFrame:HookScript('OnShow', function()
		if not InteractiveWormholesDB.taxiPrompted and not ShouldUseInstanceMap() then
			-- don't prompt again
			InteractiveWormholesDB.taxiPrompted = true

			-- on-demand prompt
			StaticPopupDialogs[addonName] = {
				text = addon.L['Would you like to use the World Map instead for Taxi services?'],
				button1 = YES,
				button2 = NO,
				OnAccept = function()
					addon:SetOption('taxi', true)

					-- prevent the taxi interaction from ending until we've rendered our data
					FlightMapFrame:SetScript('OnHide', nil)

					-- force refresh
					OnTaxiOpened()

					-- once we've rendered we re-enable the script handler
					FlightMapFrame:SetScript('OnHide', FlightMapMixin.OnHide)
				end,
				hideOnEscape = true,
				timeout = 0,
			}

			StaticPopup_Show(addonName)
		end
	end)
end)
