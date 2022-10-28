local _, addon = ...
local L = addon.L

local HBD = LibStub('HereBeDragons-2.0')
local HBDP = LibStub('HereBeDragons-Pins-2.0')

local pinParent = {} -- HBDP needs some ref for the pins

local pinMixin = {}
function pinMixin:OnClick()
	if self.parentID then
		-- the pin has a parent gossip option, stage this pin's ID and select the parent instead
		addon.stagedGossipOptionID = self:GetID()
		C_GossipInfo.SelectOption(self.parentID)
	else
		C_GossipInfo.SelectOption(self:GetID())
	end
end

local function renderLines(pin)
	if pin.taxiSourceIndex then
		-- we need to set up a route between this pin and the source, with an unknown number
		-- of pins between

		-- start off by enumerating all the pins and sorting them by their taxi index
		-- TODO: this logic assumes the route is linear and won't work with a tree
		local taxiIndexPins = {}
		for activePin in addon.pinPool:EnumerateActive() do
			if activePin.taxiIndex then
				taxiIndexPins[activePin.taxiIndex] = activePin
			end
		end

		-- the source pin doesn't have a taxi index, which is why it's handled separately
		taxiIndexPins[pin.taxiSourceIndex] = addon.sourcePin

		-- loop through every index between this pins index and the source's
		local curIndex = pin.taxiIndex
		while curIndex ~= pin.taxiSourceIndex do
			-- create a new line, setting its start point to the current pin by taxi index
			local line = addon.linePool:Acquire()
			line:SetStartPoint('CENTER', taxiIndexPins[curIndex])

			-- update the taxi index pointer to the next pin's
			if curIndex > pin.taxiSourceIndex then
				curIndex = curIndex - 1
			else
				curIndex = curIndex + 1
			end

			-- set the line's end point to the next pin
			line:SetEndPoint('CENTER', taxiIndexPins[curIndex])
			line:Show()
		end
	else
		-- simple point-to-point journey
		local line = addon.linePool:Acquire()
		line:SetStartPoint('CENTER', addon.sourcePin)
		line:SetEndPoint('CENTER', pin)
		line:Show()
	end
end

function pinMixin:OnEnter()
	if self.isTaxi then
		renderLines(self)
	end

	GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	GameTooltip:AddLine(self.tooltip or L['Click to travel'])
	GameTooltip:Show()
end

function pinMixin:OnLeave()
	addon.linePool:ReleaseAll()
	GameTooltip:Hide()
end

function pinMixin:SetAtlas(atlas, width, height)
	self:GetNormalTexture():SetAtlas(atlas)

	if width then
		self:SetSize(width, height or width)
	end
end

function pinMixin:SetHighlightAtlas(atlas, addBlend)
	self:GetHighlightTexture():SetAtlas(atlas)
	self:GetHighlightTexture():SetBlendMode(addBlend and 'ADD' or 'BLEND')
end

function pinMixin:SetLocation(mapID, x, y)
	HBDP:AddWorldMapIconMap(pinParent, self, mapID, x, y, HBD_PINS_WORLDMAP_SHOW_WORLD, 'PIN_FRAME_LEVEL_TOPMOST')
end

function pinMixin:SetCurrentLocation(...) -- DONE
	local x, y, mapID = HBD:GetPlayerZonePosition()
	self:SetLocation(mapID, x, y, ...)
end

function pinMixin:SetTooltip(text)
	self.tooltip = text
end

addon.pinPool = CreateObjectPool(function()
	-- createPin
	local pin = Mixin(CreateFrame('Button'), pinMixin)
	pin:RegisterForClicks('AnyUp', 'AnyDown') -- see https://github.com/Stanzilla/WoWUIBugs/issues/268
	pin:SetScript('OnClick', pin.OnClick)
	pin:SetScript('OnEnter', pin.OnEnter)
	pin:SetScript('OnLeave', pin.OnLeave)

	pin:SetNormalTexture(pin:CreateTexture(nil, 'ARTWORK'))
	pin:GetNormalTexture():SetAllPoints()
	pin:SetHighlightTexture(pin:CreateTexture(nil, 'HIGHLIGHT'))
	pin:GetHighlightTexture():SetAllPoints()

	local arrow = addon.arrowPool:Acquire()
	arrow:SetParent(pin)
	arrow:SetPoint('BOTTOM', pin, 'TOP')
	pin.arrow = arrow

	return pin
end, function(_, pin)
	-- resetPin
	pin:SetSize(24, 24)
	pin.arrow:Show()
	pin.tooltip = nil
	pin.isTaxi = nil
	pin.taxiIndex = nil
	pin.taxiSourceIndex = nil
	HBDP:RemoveWorldMapIcon(pinParent, pin)
end)

function addon:AddPin(info, gossipID, gossipName)
	local pin = self.pinPool:Acquire()
	pin:SetID(gossipID)
	pin.parentID = info.parent

	-- append the mapID of the pin to a list of maps, used to calculate the common map between all pins
	if not tContains(self.activeMaps, info.mapID) then
		table.insert(self.activeMaps, info.mapID)
	end

	if info.isTaxi then
		self.hasTaxiPins = true
		pin.isTaxi = true
		pin.taxiIndex = info.taxiIndex
		pin.taxiSourceIndex = info.taxiSourceIndex
		pin:SetAtlas('Taxi_Frame_Gray', 20)
		pin:SetHighlightAtlas('Taxi_Frame_Yellow', true)
	elseif info.isQuest then
		pin:SetAtlas('quest-campaign-available', 32)
		pin:SetHighlightAtlas('quest-campaign-available', true)
	else
		pin:SetAtlas(info.atlas or 'MagePortalAlliance', info.atlasWidth or info.atlasSize, info.atlasHeight)
		pin:SetHighlightAtlas(info.highlightAtlas or info.atlas or 'MagePortalHorde', info.highlightAdd)
	end

	if info.tooltipQuest then
		pin:SetTooltip(QuestUtils_GetQuestName(info.tooltipQuest))
	elseif info.tooltipMap or not (info.tooltip or gossipName) then
		local mapInfo = C_Map.GetMapInfo(info.tooltipMap or info.mapID)
		pin:SetTooltip(mapInfo.name)
	else
		pin:SetTooltip(info.tooltip or gossipName)
	end

	pin:SetLocation(info.mapID, info.x, info.y)
end

function addon:AddSourcePin()
	local pin = self.pinPool:Acquire()
	pin:SetAtlas('Taxi_Frame_Green', 28)
	pin:SetHighlightAtlas('Taxi_Frame_Green', true)
	pin:SetTooltip(L['You are here'])
	pin:SetCurrentLocation()
	pin.arrow:Hide()

	self.sourcePin = pin
end
