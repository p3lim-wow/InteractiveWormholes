local _, addon = ...

local hasTaxiPins, isActive, hasChanged
local unknownWarned = {}

local gossipPinMixin = {}
function gossipPinMixin:OnClick()
	if self.info.parent then
		addon.stagedGossipOptionID = self:GetID()
		C_GossipInfo.SelectOption(self.info.parent)
	elseif self:GetID() and self:GetID() > 0 then
		C_GossipInfo.SelectOption(self:GetID())
	end
end

function gossipPinMixin:OnMouseEnter()
	GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')

	if self.info.tooltipQuest then
		C_QuestLog.RequestLoadQuestByID(self.info.tooltipQuest) -- trigger cache
		GameTooltip:AddLine(C_QuestLog.GetTitleForQuestID(self.info.tooltipQuest))
	elseif self.info.tooltipArea then
		GameTooltip:AddLine(C_Map.GetAreaInfo(self.info.tooltipArea)) -- from AreaTable.db2
	elseif self.info.tooltipMap then
		local mapInfo = C_Map.GetMapInfo(self.info.tooltipMap or self.info.mapID)
		GameTooltip:AddLine(mapInfo.name)
	elseif self.info.tooltip then
		if type(self.info.tooltip) == 'function' then
			GameTooltip:AddLine(self.info.tooltip())
		else
			GameTooltip:AddLine(self.info.tooltip)
		end
	else
		GameTooltip:AddLine(self.info.gossipName)
	end

	if not self.info.noArrow then
		GameTooltip:AddLine('|A:NPE_LeftClick:18:18|a' .. TUTORIAL_TITLE35, 1, 1, 1)
	end

	GameTooltip:Show()

	if self.info.isTaxi then
		self.owner:HighlightRouteToPin(self)
	end
end

function gossipPinMixin:OnMouseLeave()
	GameTooltip:Hide()
	addon:ReleaseLines()
end

local gossipProvider = addon:CreateProvider('gossip', gossipPinMixin)
function addon:GOSSIP_SHOW()
	if IsShiftKeyDown() or C_PlayerInteractionManager.IsInteractingWithNpcOfType(Enum.PlayerInteractionType.TaxiNode) then
		return
	end

	if addon.stagedGossipOptionID then
		if not InCombatLockdown() then
			HideUIPanel(WorldMapFrame) -- hide the map early for smoothness
		end

		C_GossipInfo.SelectOption(addon.stagedGossipOptionID)
		addon.stagedGossipOptionID = nil
	else
		gossipProvider:RefreshAllData()
	end
end

function addon:GOSSIP_CLOSED()
	if not isActive then
		return
	end
	isActive = false
	hasChanged = false

	gossipProvider:RestoreBlizzard()
	gossipProvider:RemoveAllData()

	HideUIPanel(WorldMapFrame)
end

function gossipProvider:OnRefresh()
	local unknownOptions = {}
	for _, gossipInfo in next, C_GossipInfo.GetOptions() do
		local data = addon.data[gossipInfo.gossipOptionID]
		if data then
			if data.children then
				for _, childGossipOptionID in next, data.children do
					local childData = addon.data[childGossipOptionID]
					if childData then
						self:AddPin(childData, {
							gossipOptionID = childGossipOptionID,
						})

						if childData.displayExtra then
							for _, extraData in next, childData.displayExtra do
								self:AddPin(extraData, {
									gossipOptionID = childGossipOptionID,
								})
							end
						end
					end
				end
			else
				self:AddPin(data, gossipInfo)
			end

			if data.displayExtra then
				for _, extraData in next, data.displayExtra do
					self:AddPin(extraData, gossipInfo)
				end
			end
		elseif not unknownWarned[gossipInfo.gossipOptionID] then
			table.insert(unknownOptions, gossipInfo)
		end
	end

	if isActive then
		if InCombatLockdown() then
			UIErrorsFrame:AddExternalErrorMessage(ERR_NOT_IN_COMBAT)
			return
		end

		self:DisableBlizzard()
		addon:SyncArrows()
		self:AddSourcePin()

		if #unknownOptions > 0 then
			addon:Print('There are more options not shown on the map:')
			for _, gossipInfo in next, unknownOptions do
				unknownWarned[gossipInfo.gossipOptionID] = true
				addon:Printf('- %d, "%s"', gossipInfo.gossipOptionID, gossipInfo.name)
			end
			addon:Print('Please report this at |cff71d5ffhttps://p3l.im/wormhole|r')
			addon:Printf('Hold SHIFT while interacting to this %s to see them.', UnitIsGameObject('npc') and 'object' or 'npc')
		end

		if not WorldMapFrame:IsShown() then
			ShowUIPanel(WorldMapFrame)
		end

		-- we want to show the "common" map among the options, but this will taint the UI,
		-- so we'll add it as an option users can choose to enable
		local commonMapID = addon:GetCommonMap()
		if addon:GetOption('changeMap') and not hasChanged then
			WorldMapFrame:SetMapID(commonMapID)
			hasChanged = true
		end
	end
end

function gossipProvider:AddPin(info, gossipInfo)
	if info.requiredQuest and not C_QuestLog.IsQuestFlaggedCompleted(info.requiredQuest) then
		return
	end

	local pin = self:AcquirePin()
	pin:SetID(gossipInfo.gossipOptionID)
	pin.owner = self

	isActive = true

	-- flag the map for ancestry
	addon:FlagMap(info.mapID)

	if not pin:SetPosition(info.mapID, info.x, info.y) then
		pin:Hide()
		return
	end

	if info.isTaxi then
		pin:SetSize(20, 20)
		pin:SetIconAtlas('Taxi_Frame_Gray')
		pin:SetHighlightAtlas('Taxi_Frame_Yellow')

		hasTaxiPins = true
	elseif gossipInfo and gossipInfo.flags and FlagsUtil.IsSet(gossipInfo.flags, Enum.GossipOptionRecFlags.QuestLabelPrepend) then -- info.isQuest
		pin:SetSize(32, 32)
		pin:SetIconAtlas('quest-campaign-available')
		pin:SetHighlightAtlas('quest-campaign-available')
	else
		pin:SetSize(info.atlasWidth or info.atlasSize or 24, info.atlasHeight or info.atlasSize or 24)
		pin:SetIconAtlas(info.atlas or 'MagePortalAlliance')
		pin:SetHighlightAtlas(info.highlightAtlas or info.atlas or 'MagePortalHorde')
		pin:SetHighlightBlendMode(info.highlightAdd and 'ADD' or 'BLEND')
	end

	pin.info = info
	pin.info.gossipName = gossipInfo.name -- used as tooltip fallback

	if not info.noArrow then
		pin:AttachArrow()
	end
end

function gossipProvider:AddSourcePin()
	if not hasTaxiPins then
		return
	end

	local data = {}
	data.atlas = 'Taxi_Frame_Green'
	data.atlasSize = 28
	data.tooltip = _G.TAXINODEYOUAREHERE -- "You are here"
	data.mapID = C_Map.GetBestMapForUnit('player')
	data.x, data.y = C_Map.GetPlayerMapPosition(data.mapID, 'player'):GetXY()
	data.noArrow = true
	self:AddPin(data, {
		gossipOptionID = 0,
	})
end

function gossipProvider:HighlightRouteToPin(pin)
	local thickness = 1 / self:GetMap():GetCanvasScale() * 35
	if pin.info.taxiSourceIndex then
		-- enumerate all pins and sort them by their taxi index
		-- TODO: make this logic smarter than just linear routes?
		local taxiIndexPins = {}

		for activePin in self:EnumeratePins() do
			if activePin.info.taxiIndex then
				taxiIndexPins[activePin.info.taxiIndex] = activePin
			else
				taxiIndexPins[pin.info.taxiSourceIndex] = activePin
			end
		end

		local curIndex = pin.info.taxiIndex
		while curIndex ~= pin.info.taxiSourceIndex do
			-- set line source to the current pin
			local startPin = taxiIndexPins[curIndex]

			-- update pointer to the next pin
			if curIndex > pin.info.taxiSourceIndex then
				curIndex = curIndex - 1
			else
				curIndex = curIndex + 1
			end

			-- set line destination to the next pin
			local endPin = taxiIndexPins[curIndex]
			addon:AttachLine(startPin, endPin, thickness)
		end
	else
		-- just pin it to the source pin
		for activePin in self:EnumeratePins() do
			if activePin.info.noArrow then
				addon:AttachLine(activePin, pin, thickness)
				break
			end
		end
	end
end

function gossipProvider:OnRelease(hadPins)
	if hadPins then
		addon:ReleaseArrows()
		addon:ReleaseLines()
		hasTaxiPins = false
	end
end

function gossipProvider:OnHide()
	if isActive and not addon.stagedGossipOptionID then
		C_GossipInfo.CloseGossip()
	end
end

local function isHandledExternally()
	return addon:IsAddOnEnabled('DialogueUI')
end

function gossipProvider:DisableBlizzard()
	if isHandledExternally() then
		return
	end

	GossipFrame:SetScript('OnHide', nil)
	CustomGossipFrameManager:UnregisterAllEvents()
end

function gossipProvider:RestoreBlizzard()
	if isHandledExternally() then
		return
	end

	GossipFrame:SetScript('OnHide', GossipFrameSharedMixin.OnHide)
	for _, event in next, CUSTOM_GOSSIP_FRAME_EVENTS do
		CustomGossipFrameManager:RegisterEvent(event)
	end
end
