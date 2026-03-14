local addonName, addon = ...

-- upvalue API because we disable it
local C_TaxiMap_ShouldMapShowTaxiNodes = C_TaxiMap.ShouldMapShowTaxiNodes

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

local provider = {}
provider.data = addon:T()

function provider:OnPinClick(button, down)
	if button == 'LeftButton' and not down then
		TakeTaxiNode(self:GetID())
	end
end

function provider:OnPinEnter()
	local taxiNodeSlotIndex = self:GetID()
	local taxiNodeInfo = provider.data[taxiNodeSlotIndex]

	local tooltip = addon:GetTooltip(self, 'ANCHOR_RIGHT')
	tooltip:AddLine(taxiNodeInfo.name)

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
		self.Texture:SetAtlas(taxiNodeInfo.atlasFormat:format('Taxi_Frame_Yellow'))

		-- route lines, ripped (mostly) from FlightMap_FlightPathDataProviderMixin.HighlightRouteToPin
		for routeIndex = 1, GetNumRoutes(taxiNodeSlotIndex) do
			local sourceNodeInfo = provider.data[TaxiGetNodeSlot(taxiNodeSlotIndex, routeIndex, true)]
			local destinationNodeInfo = provider.data[TaxiGetNodeSlot(taxiNodeSlotIndex, routeIndex, false)]
			if sourceNodeInfo and destinationNodeInfo and not sourceNodeInfo.isMapLayerTransition then
				local sourcePin = self.provider:GetPinByID(sourceNodeInfo.slotIndex)
				local destinationPin = self.provider:GetPinByID(destinationNodeInfo.slotIndex)

				addon:AttachLine(sourcePin, destinationPin)

				-- force show all pins in the route, even if they're undiscovered
				sourcePin:Show()
				destinationPin:Show()
			end
		end
	elseif taxiNodeInfo.state == Enum.FlightPathState.Unreachable and not taxiNodeInfo.isMapLayerTransition then
		tooltip:AddLine(TAXI_PATH_UNREACHABLE, RED_FONT_COLOR:GetRGB())
	end

	tooltip:Show()
end

function provider:OnPinLeave()
	addon:HideTooltip()
	addon:ReleaseLines()

	-- ripped from FlightMap_FlightPointPinMixin.OnMouseLeave
	local taxiNodeInfo = provider.data[self:GetID()]
	if taxiNodeInfo.state == Enum.FlightPathState.Reachable and taxiNodeInfo.atlasFormat then
		if taxiNodeInfo.useSpecialIcon then
			self.Texture:SetAtlas(taxiNodeInfo.atlasFormat:format('Taxi_Frame_Special'))
		else
			self.Texture:SetAtlas(taxiNodeInfo.atlasFormat:format('Taxi_Frame_Gray'))
		end
	end

	-- reset pin visibility
	for pin in self.provider:EnumeratePins() do
		local info = provider.data[pin:GetID()]
		pin:SetShown(info.state ~= Enum.FlightPathState.Unreachable or info.isMapLayerTransition)
	end
end

function provider:OnPinCreate(taxiNodeInfo)
	if taxiNodeInfo.state == Enum.FlightPathState.Unreachable then
		-- ignore unreachable pins
		return
	end

	self:SetID(taxiNodeInfo.slotIndex)

	-- only show pins if part of a route or a layer transition point
	self:SetShown(taxiNodeInfo.state ~= Enum.FlightPathState.Unreachable or taxiNodeInfo.isMapLayerTransition)

	-- size logic ripped (mostly) from FlightMap_FlightPointPinMixin.UpdatePinSize
	if taxiNodeInfo.textureKit == 'FlightMaster_Cave' then
		-- Zereth Mortis cave flight system,
		-- they are just in the way, and there are existing POIs for them
		self:SetSize(1, 1)
	elseif taxiNodeInfo.textureKit == 'FlightMaster_VindicaarArgus' or taxiNodeInfo.textureKit == 'FlightMaster_VindicaarStygianWake' or taxiNodeInfo.textureKit == 'FlightMaster_VindicaarMacAree' then
		self:SetSize(39, 42)
	elseif taxiNodeInfo.textureKit == 'FlightMaster_Argus' then
		self:SetSize(34, 28)
	elseif taxiNodeInfo.textureKit == 'FlightMaster_Bastion' then
		if taxiNodeInfo.state == Enum.FlightPathState.Current then
			self:SetSize(26, 26)
		elseif taxiNodeInfo.state == Enum.FlightPathState.Reachable or taxiNodeInfo.state == Enum.FlightPathState.Unreachable then
			self:SetSize(24, 24)
		end
	elseif taxiNodeInfo.textureKit == 'FlightMaster_Ferry' then
		if taxiNodeInfo.state == Enum.FlightPathState.Current then
			self:SetSize(36, 24)
		elseif taxiNodeInfo.state == Enum.FlightPathState.Reachable or taxiNodeInfo.state == Enum.FlightPathState.Unreachable then
			self:SetSize(28, 19)
		end
	elseif taxiNodeInfo.isMapLayerTransition then
		self:SetSize(20, 20)
	else
		-- extra handling for obelisk system in Zereth Mortis so we can use atlas
		local widthMultiplier = 1
		if taxiNodeInfo.textureKit == 'FlightMaster_ProgenitorObelisk' then
			widthMultiplier = 0.5
		end

		if taxiNodeInfo.state == Enum.FlightPathState.Current then
			self:SetSize(28 * widthMultiplier, 28)
		elseif taxiNodeInfo.state == Enum.FlightPathState.Reachable then
			self:SetSize(20 * widthMultiplier, 20)
		elseif taxiNodeInfo.state == Enum.FlightPathState.Unreachable then
			self:SetSize(14 * widthMultiplier, 14)
		end
	end

	-- texture logic ripped (mostly) from FlightMap_FlightPointPinMixin.SetFlightPathStyle
	local atlasFormat = '%s'
	if taxiNodeInfo.textureKit then
		atlasFormat = taxiNodeInfo.textureKit .. '-%s'
	end

	if taxiNodeInfo.isMapLayerTransition then
		self.Texture:SetAtlas(atlasFormat:format('Taxi_Frame_Gray'))
		self.Highlight:SetAtlas(atlasFormat:format('Taxi_Frame_Gray'))
		self.Highlight:SetBlendMode('ADD')
	elseif taxiNodeInfo.state == Enum.FlightPathState.Current then
		self.Texture:SetAtlas(atlasFormat:format('Taxi_Frame_Green'))
		self.Highlight:SetAtlas(atlasFormat:format('Taxi_Frame_Gray'))
		self.Highlight:SetBlendMode('ADD')
	elseif taxiNodeInfo.state == Enum.FlightPathState.Unreachable then
		self.Texture:SetAtlas(atlasFormat:format('UI-Taxi-Icon-Nub'))
		self.Highlight:SetAtlas(atlasFormat:format('UI-Taxi-Icon-Nub'))
		self.Highlight:SetBlendMode('ADD')
	elseif taxiNodeInfo.state == Enum.FlightPathState.Reachable then
		if taxiNodeInfo.useSpecialIcon then
			self.Texture:SetAtlas(atlasFormat:format('Taxi_Frame_Special'))
		else
			self.Texture:SetAtlas(atlasFormat:format('Taxi_Frame_Gray'))
		end

		self.Highlight:SetAtlas(atlasFormat:format('Taxi_Frame_Gray'))
		self.Highlight:SetBlendMode('ADD')
	end

	-- inject the format so we don't have to keep re-defining it
	taxiNodeInfo.atlasFormat = atlasFormat

	-- render current path lower so we can more easily click others close to it
	if taxiNodeInfo.state == Enum.FlightPathState.Current then
		self:Lower()
	end

	-- attach arrows to reachable nodes
	if taxiNodeInfo.state ~= Enum.FlightPathState.Unreachable and taxiNodeInfo.textureKit ~= 'FlightMaster_ProgenitorObelisk' then
		addon:AttachArrow(self)
	end

	return WorldMapFrame:GetMapID(), taxiNodeInfo.position:GetXY()
end

function provider:OnRefresh()
	provider.data:wipe()

	for _, taxiNodeInfo in next, C_TaxiMap.GetAllTaxiNodes(WorldMapFrame:GetMapID()) do
		provider.data[taxiNodeInfo.slotIndex] = taxiNodeInfo
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
	C_TaxiMap.ShouldMapShowTaxiNodes = function() end

	-- compare the taxi map ID with the player's current map ID
	local mapID = C_Map.GetBestMapForUnit('player') or 0
	local mapInfo = C_Map.GetMapInfo(mapID)
	local taxiMapInfo = C_Map.GetMapInfo(GetTaxiMapID())
	if mapInfo.name ~= taxiMapInfo.name then
		-- the taxi system expects a different map, let's zoom out until we find it
		while mapInfo.name ~= taxiMapInfo.name and mapInfo.parentMapID ~= 0 do
			mapInfo = C_Map.GetMapInfo(mapInfo.parentMapID)
		end

		if mapInfo.name == taxiMapInfo.name then
			-- we found the equivalent to the taxi map, lets use it
			mapID = mapInfo.mapID
		end
	end

	C_Map.OpenWorldMap(mapID)
end

local function OnTaxiClosed()
	if WorldMapFrame:IsShown() then
		HideUIPanel(WorldMapFrame)
	end

	provider.data:wipe()

	-- restore API
	C_TaxiMap.ShouldMapShowTaxiNodes = C_TaxiMap_ShouldMapShowTaxiNodes
end

local function Enable()
	-- disable default taxi maps
	UIParent:UnregisterEvent('TAXIMAP_OPENED')
	if TaxiFrame then
		TaxiFrame:UnregisterAllEvents()
	end

	-- register our events
	if not addon:IsEventRegistered('TAXIMAP_OPENED', OnTaxiOpened) then
		addon:RegisterEvent('TAXIMAP_OPENED', OnTaxiOpened)
		addon:RegisterEvent('TAXIMAP_CLOSED', OnTaxiClosed)
	end

	-- enable pin provider
	addon:AddProvider(provider)
end

local function Disable()
	-- re-register default events
	UIParent:RegisterEvent('TAXIMAP_OPENED')
	if TaxiFrame then
		TaxiFrame:RegisterEvent('TAXIMAP_CLOSED')
	end

	-- unregister our events
	addon:UnregisterEvent('TAXIMAP_OPENED', OnTaxiOpened)
	addon:UnregisterEvent('TAXIMAP_CLOSED', OnTaxiClosed)

	-- disable pin provider
	addon:RemoveProvider(provider)
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
