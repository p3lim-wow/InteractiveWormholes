local addonName, addon = ...

local INSTANCE_USE_WORLD_MAP = {
	[2093] = true, -- The Nokhud Offensive
}

local hasChanged
local enabled

local taxiPinMixin = {} -- fork FlightMap_FlightPointPinMixin for methods we need
function taxiPinMixin:OnPinClick(button)
	if button ~= 'LeftButton' then
		return
	end

	if not self.isMapLayerTransition then
		TakeTaxiNode(self.taxiNodeData.slotIndex)
	end
end

function taxiPinMixin:OnPinEnter()
	-- ripped from FlightMap_FlightPointPinMixin.OnMouseEnter
	GameTooltip:SetOwner(self, 'ANCHOR_PRESERVE')
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint('BOTTOMLEFT', self, 'TOPRIGHT', 0, 0)

	GameTooltip_AddNormalLine(GameTooltip, self.taxiNodeData.name, true)

	if self.taxiNodeData.state == Enum.FlightPathState.Current then
		GameTooltip_AddHighlightLine(GameTooltip, TAXINODEYOUAREHERE, true)
	elseif self.taxiNodeData.state == Enum.FlightPathState.Reachable then
		local cost = TaxiNodeCost(self.taxiNodeData.slotIndex)
		if cost > 0 then
			SetTooltipMoney(GameTooltip, cost)
		elseif self.taxiNodeData.specialIconCostString then
			if self.taxiNodeData.useSpecialIcon then
				GameTooltip_AddHighlightLine(GameTooltip, self.taxiNodeData.specialIconCostString, true)
			else
				GameTooltip_AddErrorLine(GameTooltip, self.taxiNodeData.specialIconCostString, true)
			end
		end

		self:SetNormalAtlas(self.atlasFormat:format('Taxi_Frame_Yellow'))
		self.owner:HighlightRouteToPin(self)
	elseif self.taxiNodeData.state == Enum.FlightPathState.Unreachable and not self.isMapLayerTransition then
		GameTooltip_AddErrorLine(GameTooltip, TAXI_PATH_UNREACHABLE, true)
	end

	GameTooltip:Show()
end

function taxiPinMixin:OnPinLeave()
	-- ripped from FlightMap_FlightPointPinMixin.OnMouseLeave
	if self.taxiNodeData.state == Enum.FlightPathState.Reachable then
		if self.useSpecialReachableIcon then
			self:SetNormalAtlas(self.atlasFormat:format('Taxi_Frame_Special'))
		else
			self:SetNormalAtlas(self.atlasFormat:format('Taxi_Frame_Gray'))
		end
		self.owner:RemoveRouteToPin(self)
	end
	GameTooltip_Hide()
end

function taxiPinMixin:UpdatePinSize(pinType)
	-- ripped (mostly) from FlightMap_FlightPointPinMixin.UpdatePinSize
	if self.textureKit == 'FlightMaster_Cave' then
		-- Zereth Mortis cave flight system,
		-- they are just in the way, and there are existing POIs for them
		self:SetSize(1, 1)
	elseif self.textureKit == 'FlightMaster_VindicaarArgus' or self.textureKit == 'FlightMaster_VindicaarStygianWake' or self.textureKit == 'FlightMaster_VindicaarMacAree' then
		self:SetSize(39, 42)
	elseif self.textureKit == 'FlightMaster_Argus' then
		self:SetSize(34, 28)
	elseif self.textureKit == 'FlightMaster_Bastion' then
		if pinType == Enum.FlightPathState.Current then
			self:SetSize(26, 26)
		elseif pinType == Enum.FlightPathState.Reachable or pinType == Enum.FlightPathState.Unreachable then
			self:SetSize(24, 24)
		end
	elseif self.textureKit == 'FlightMaster_Ferry' then
		if pinType == Enum.FlightPathState.Current then
			self:SetSize(36, 24)
		elseif pinType == Enum.FlightPathState.Reachable or pinType == Enum.FlightPathState.Unreachable then
			self:SetSize(28, 19)
		end
	elseif self.isMapLayerTransition then
		self:SetSize(20, 20)
	elseif pinType == Enum.FlightPathState.Current then
		self:SetSize(28, 28)
	elseif pinType == Enum.FlightPathState.Reachable then
		self:SetSize(20, 20)
	elseif pinType == Enum.FlightPathState.Unreachable then
		self:SetSize(14, 14)
	end
end

function taxiPinMixin:SetFlightPathStyle(taxiNodeType)
	-- ripped (mostly) from FlightMap_FlightPointPinMixin.SetFlightPathStyle
	if self.textureKit then
		self.atlasFormat = self.textureKit .. '-%s'
	else
		self.atlasFormat = '%s'
	end

	if self.textureKit == 'FlightMaster_ProgenitorObelisk' then
		self:SetNormalAtlas(self.atlasFormat:format())
	elseif self.isMapLayerTransition then
		self:SetNormalAtlas(self.atlasFormat:format('Taxi_Frame_Gray'))
		self:SetHighlightAtlas(self.atlasFormat:format('Taxi_Frame_Gray'))
	elseif taxiNodeType == Enum.FlightPathState.Current then
		self:SetNormalAtlas(self.atlasFormat:format('Taxi_Frame_Green'))
		self:SetHighlightAtlas(self.atlasFormat:format('Taxi_Frame_Gray'))
	elseif taxiNodeType == Enum.FlightPathState.Unreachable then
		self:SetNormalAtlas(self.atlasFormat:format('UI-Taxi-Icon-Nub'))
		self:SetHighlightAtlas(self.atlasFormat:format('UI-Taxi-Icon-Nub'))
	elseif taxiNodeType == Enum.FlightPathState.Reachable then
		if self.useSpecialReachableIcon then
			self:SetNormalAtlas(self.atlasFormat:format('Taxi_Frame_Special'))
		else
			self:SetNormalAtlas(self.atlasFormat:format('Taxi_Frame_Gray'))
		end
		self:SetHighlightAtlas(self.atlasFormat:format('Taxi_Frame_Gray'))
	end
end

-- local taxiProvider = CreateFromMixins(MapCanvasDataProviderMixin)
local taxiProviderMixin = {}
function taxiProviderMixin:OnAdded()
	-- table to hold pin/index association for route lines
	self.taxiIndexPin = {}

	-- force load FlightMap addon so we can use its template and mixins
	-- TODO: don't do this if we can get around it
	C_AddOns.LoadAddOn('Blizzard_FlightMap')

	-- disable default taxi maps becau
	UIParent:UnregisterEvent('TAXIMAP_OPENED')
	TaxiFrame:UnregisterAllEvents()
	FlightMapFrame:UnregisterAllEvents() -- won't need to do this if we don't use FlightMap addon

	-- register our events
	self:RegisterEvent('TAXIMAP_OPENED')
	self:RegisterEvent('TAXIMAP_CLOSED')
end

function taxiProviderMixin:OnRemoved()
	-- register default events
	UIParent:RegisterEvent('TAXIMAP_OPENED')

	if TaxiFrame then
		TaxiFrame:RegisterEvent('TAXIMAP_CLOSED')
	end

	if FlightMapFrame then
		FlightMapFrame:RegisterEvent('TAXIMAP_CLOSED')
	end

	-- unregister our events
	self:UnregisterEvent('TAXIMAP_OPENED')
	self:UnregisterEvent('TAXIMAP_CLOSED')
end

local function shouldUseInstanceMap()
	return IsInInstance() and not INSTANCE_USE_WORLD_MAP[C_Map.GetBestMapForUnit('player') or 0]
end

function taxiProviderMixin:OnEvent(event)
	if not enabled then
		return
	end

	if event == 'TAXIMAP_OPENED' then
		if not enabled then
			return
		end

		if InCombatLockdown() then
			-- player can't take a flight in combat anyways, so we bail here to avoid taints
			-- https://github.com/Stanzilla/WoWUIBugs/issues/440
			UIErrorsFrame:AddExternalErrorMessage(ERR_NOT_IN_COMBAT)
			CloseTaxiMap()
		elseif shouldUseInstanceMap() then
			-- use stock flight map in dungeons unless specifically handled
			ShowUIPanel(FlightMapFrame)
		else
			self:RefreshAllData()
		end
	elseif event == 'TAXIMAP_CLOSED' then
		HideUIPanel(FlightMapFrame)
		HideUIPanel(WorldMapFrame)
		hasChanged = false
	end
end

function taxiProviderMixin:OnRefresh()
	if not C_PlayerInteractionManager.IsInteractingWithNpcOfType(Enum.PlayerInteractionType.TaxiNode) then
		return
	end

	if not WorldMapFrame:IsShown() then
		C_Map.OpenWorldMap()
	end

	local taxiNodes = C_TaxiMap.GetAllTaxiNodes(self:GetMap():GetMapID())
	if #taxiNodes == 0 then
		return
	end

	self:DisableBlizzard()

	for _, taxiNodeInfo in next, taxiNodes do
		self:AddPin(taxiNodeInfo)
	end

	addon:SyncArrows()

	local commonMapID = addon:GetCommonMap()
	if commonMapID and not hasChanged then
		C_Map.OpenWorldMap(commonMapID)
		hasChanged = true
	end
end

function taxiProviderMixin:OnHide()
	if C_PlayerInteractionManager.IsInteractingWithNpcOfType(Enum.PlayerInteractionType.TaxiNode) then
		CloseTaxiMap()
		self:RestoreBlizzard()
		self:RemoveAllData()
	end
end

function taxiProviderMixin:OnRelease(hadPins)
	if hadPins then
		addon:ReleaseArrows()
		addon:ReleaseLines()
		table.wipe(self.taxiIndexPin)
	end
end

function taxiProviderMixin:AddPin(info)
	local pin = self:AcquirePin()

	-- set variables used by FlightMap_FlightPointPinTemplate
	pin.taxiNodeData = info
	pin.textureKit = info.textureKit
	pin.isMapLayerTransition = info.isMapLayerTransition
	pin.owner = self

	local mapID = self:GetMap():GetMapID()
	pin:SetPosition(self:GetMap():GetMapID(), info.position:GetXY())

	-- flag the map for ancestry
	-- TODO: this mapID is not correct at all
	addon:FlagMap(mapID)

	-- use FlightMap_FlightPointPinTemplate methods
	pin:SetFlightPathStyle(info.state)
	pin:UpdatePinSize(info.state)

	if info.textureKit == 'FlightMaster_ProgenitorObelisk' then
		-- these nodes' textures are thin and tall so halve the pin width and adjust icon position
		-- to fix their bounds, but only after UpdatePinSize has set it's own thing
		local width, height = pin:GetSize()
		pin:SetWidth(width / 2)
		pin.Icon:ClearAllPoints()
		pin.Icon:SetPoint('CENTER')
		pin.Icon:SetSize(width, height)
	elseif info.state ~= Enum.FlightPathState.Unreachable then
		-- attach arrows to all reachable nodes
		pin:AttachArrow()
	end

	if info.state == Enum.FlightPathState.Current then
		-- don't overlap destinations with source in case they're close
		pin:SetFrameLevel(pin:GetFrameLevel() - 1)
	end

	-- show pin unless it's unreachable
	pin:SetShown(info.state ~= Enum.FlightPathState.Unreachable)

	-- map pin index for routes
	self.taxiIndexPin[info.slotIndex] = pin
end

function taxiProviderMixin:HighlightRouteToPin(pin)
	-- ripped (mostly) from FlightMap_FlightPathDataProviderMixin.HighlightRouteToPin
	local thickness = 1 / self:GetMap():GetCanvasScale() * 35
	local slotIndex = pin.taxiNodeData.slotIndex
	for routeIndex = 1, GetNumRoutes(slotIndex) do
		local sourcePin = self.taxiIndexPin[TaxiGetNodeSlot(slotIndex, routeIndex, true)]
		local destinationPin = self.taxiIndexPin[TaxiGetNodeSlot(slotIndex, routeIndex, false)]
		if sourcePin and destinationPin then
			addon:AttachLine(sourcePin, destinationPin, thickness)

			-- force show all pins in the route, even if they're undiscovered
			sourcePin:Show()
			destinationPin:Show()
		end
	end
end

function taxiProviderMixin:RemoveRouteToPin()
	addon:ReleaseLines()

	-- reset pin state
	for _, pin in next, self.taxiIndexPin do
		pin:SetShown(pin.taxiNodeData.state ~= Enum.FlightPathState.Unreachable)
	end
end

do
	local ShouldMapShowTaxiNodes = C_TaxiMap.ShouldMapShowTaxiNodes
	function taxiProviderMixin:DisableBlizzard()
		-- TODO: I'd rather control the POI template, but it refreshes by itself
		C_TaxiMap.ShouldMapShowTaxiNodes = function() end
	end

	function taxiProviderMixin:RestoreBlizzard()
		-- restore API
		C_TaxiMap.ShouldMapShowTaxiNodes = ShouldMapShowTaxiNodes
	end
end

local provider
addon:RegisterOptionCallback('taxi', function(value)
	enabled = value

	if enabled then
		if not provider then
			provider = addon:CreateProvider('taxi', taxiProviderMixin, taxiPinMixin)
		else
			WorldMapFrame:AddDataProvider(provider)
		end

		-- WorldFlightMap does pretty much the same thing, but is outdated and broken, and the author is not
		-- responding to my pull requests to fix it, so we disable it to prevent collisions
		if C_AddOns.DoesAddOnExist('WorldFlightMap') and C_AddOns.IsAddOnLoadable('WorldFlightMap') then
			C_AddOns.DisableAddOn('WorldFlightMap')
		end
	elseif provider then
		WorldMapFrame:RemoveDataProvider(provider)
	end
end)

-- onboarding
addon:HookAddOn('Blizzard_FlightMap', function()
	if InteractiveWormholesDB.taxiPrompted then
		return
	end

	FlightMapFrame:HookScript('OnShow', function()
		if not InteractiveWormholesDB.taxiPrompted and not shouldUseInstanceMap() then
			InteractiveWormholesDB.taxiPrompted = true

			StaticPopupDialogs[addonName] = {
				text = addon.L['Would you like to use the World Map instead for Taxi services?'],
				button1 = YES,
				button2 = NO,
				OnAccept = function()
					addon:SetOption('taxi', true)

					if not provider then
						provider = addon:CreateProvider('taxi', taxiProviderMixin, taxiPinMixin)
					else
						WorldMapFrame:AddDataProvider(provider)
					end

					FlightMapFrame:SetScript('OnHide', nil) -- prevent the taxi interaction from ending
					provider:RefreshAllData()
					FlightMapFrame:SetScript('OnHide', FlightMapMixin.OnHide)
				end,
				hideOnEscape = true,
				timeout = 0,
			}

			StaticPopup_Show(addonName)
		end
	end)
end)
