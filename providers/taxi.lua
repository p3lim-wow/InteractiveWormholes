local _, addon = ...

local INSTANCE_USE_WORLD_MAP = {
	[2093] = true, -- The Nokhud Offensive
}

local hasChanged
local enabled

local taxiPinMixin = {} -- fork FlightMap_FlightPointPinMixin for methods we need
function taxiPinMixin:OnClick(...)
	FlightMap_FlightPointPinMixin.OnClick(self, ...)
end

function taxiPinMixin:OnMouseEnter()
	FlightMap_FlightPointPinMixin.OnMouseEnter(self)
end

function taxiPinMixin:OnMouseLeave()
	FlightMap_FlightPointPinMixin.OnMouseLeave(self)
end

function taxiPinMixin:UpdatePinSize(...)
	if self.textureKit == 'FlightMaster_Cave' then
		-- they are just in the way, and there are existing POIs for them
		self:SetSize(1, 1)
	else
		FlightMap_FlightPointPinMixin.UpdatePinSize(self, ...)
	end
end

function taxiPinMixin:SetFlightPathStyle(...)
	FlightMap_FlightPointPinMixin.SetFlightPathStyle(self, ...)
end

function taxiPinMixin:SetNudgeSourceRadius()
end

function taxiPinMixin:SetNudgeSourceMagnitude()
end

-- local taxiProvider = CreateFromMixins(MapCanvasDataProviderMixin)
local taxiProvider = addon:CreateProvider('taxi', taxiPinMixin)
function addon:TAXIMAP_OPENED()
	if not enabled then
		return
	end

	if InCombatLockdown() then
		-- player can't take a flight in combat anyways, so we bail here to avoid taints
		-- https://github.com/Stanzilla/WoWUIBugs/issues/440
		UIErrorsFrame:AddExternalErrorMessage(ERR_NOT_IN_COMBAT)
		CloseTaxiMap()
	elseif IsInInstance() and not INSTANCE_USE_WORLD_MAP[C_Map.GetBestMapForUnit('player') or 0] then
		-- use stock flight map in dungeons unless specifically handled
		ShowUIPanel(FlightMapFrame)
	else
		taxiProvider:RefreshAllData()
	end
end

function addon:TAXIMAP_CLOSED()
	if not enabled then
		return
	end

	HideUIPanel(FlightMapFrame)
	HideUIPanel(WorldMapFrame)
	hasChanged = false
end

function taxiProvider:OnAdded(...)
	MapCanvasDataProviderMixin.OnAdded(self, ...) -- super

	-- table to hold pin/index association for route lines
	self.taxiIndexPin = {}

	-- force load FlightMap addon so we can use its template and mixins
	-- TODO: don't do this if we can get around it
	C_AddOns.LoadAddOn('Blizzard_FlightMap')

	-- disable default taxi maps becau
	UIParent:UnregisterEvent('TAXIMAP_OPENED')
	TaxiFrame:UnregisterAllEvents()
	FlightMapFrame:UnregisterAllEvents() -- won't need to do this if we don't use FlightMap addon
end

function taxiProvider:OnRemoved(...)
	MapCanvasDataProviderMixin.OnRemoved(self, ...) -- super

	-- register default events
	UIParent:RegisterEvent('TAXIMAP_OPENED')

	if TaxiFrame then
		TaxiFrame:RegisterEvent('TAXIMAP_CLOSED')
	end

	if FlightMapFrame then
		FlightMapFrame:RegisterEvent('TAXIMAP_CLOSED')
	end
end

function taxiProvider:OnRefresh()
	if not WorldMapFrame:IsShown() then
		ShowUIPanel(WorldMapFrame)
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
	if addon:GetOption('changeMap') and not hasChanged then
		WorldMapFrame:SetMapID(commonMapID)
		hasChanged = true
	end
end

function taxiProvider:OnHide()
	if C_PlayerInteractionManager.IsInteractingWithNpcOfType(Enum.PlayerInteractionType.TaxiNode) then
		CloseTaxiMap()
		self:RestoreBlizzard()
		self:RemoveAllData()
	end
end

function taxiProvider:OnRelease(hadPins)
	if hadPins then
		addon:ReleaseArrows()
		addon:ReleaseLines()
		table.wipe(self.taxiIndexPin)
	end
end

function taxiProvider:AddPin(info)
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

function taxiProvider:HighlightRouteToPin(pin)
	-- pretty much copy/pasted from FlightMap_FlightPathDataProviderMixin.HighlightRouteToPin,
	-- except using our own line pool and line thickness logic
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

function taxiProvider:RemoveRouteToPin()
	addon:ReleaseLines()

	-- reset pin state
	for _, pin in next, self.taxiIndexPin do
		pin:SetShown(pin.taxiNodeData.state ~= Enum.FlightPathState.Unreachable)
	end
end

do
	local ShouldMapShowTaxiNodes = C_TaxiMap.ShouldMapShowTaxiNodes
	function taxiProvider:DisableBlizzard()
		-- TODO: I'd rather control the POI template, but it refreshes by itself
		C_TaxiMap.ShouldMapShowTaxiNodes = function() end
	end

	function taxiProvider:RestoreBlizzard()
		-- restore API
		C_TaxiMap.ShouldMapShowTaxiNodes = ShouldMapShowTaxiNodes
	end
end

addon:RegisterOptionCallback('taxi', function(value)
	enabled = value

	if enabled then
		WorldMapFrame:AddDataProvider(taxiProvider)

		-- WorldFlightMap does pretty much the same thing, but is outdated and broken, and the author is not
		-- responding to my pull requests to fix it, so we disable it to prevent collisions
		if C_AddOns.DoesAddOnExist('WorldFlightMap') and C_AddOns.IsAddOnLoadable('WorldFlightMap') then
			C_AddOns.DisableAddOn('WorldFlightMap')
		end
	else
		WorldMapFrame:RemoveDataProvider(taxiProvider)
	end
end)
