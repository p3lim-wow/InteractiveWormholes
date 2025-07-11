local _, addon = ...

local hasTaxiPins, isActive, hasChanged
local unknownWarned = {}

local function skipCinematic()
	if CanCancelScene() then
		CancelScene()
	end

	return true
end

local gossipPinMixin = {}
function gossipPinMixin:OnMouseUpAction(button, upInside)
	if button ~= 'LeftButton' or not upInside then
		return
	end

	if self.info.parent then
		addon.stagedGossipOptionID = self:GetID()
		C_GossipInfo.SelectOption(self.info.parent)
	elseif self:GetID() and self:GetID() > 0 then
		if self.info.skipCinematic and addon:GetOption('skipCinematic') then
			addon:RegisterEvent('CINEMATIC_START', skipCinematic)
		end

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

local gossipProviderMixin = {}
function gossipProviderMixin:OnAdded()
	self:RegisterEvent('GOSSIP_SHOW')
	self:RegisterEvent('GOSSIP_CLOSED')
end

function gossipProviderMixin:OnRemoved()
	self:UnregisterEvent('GOSSIP_SHOW')
	self:UnregisterEvent('GOSSIP_CLOSED')
end

function gossipProviderMixin:OnEvent(event)
	if event == 'GOSSIP_SHOW' then
		if C_PlayerInteractionManager.IsInteractingWithNpcOfType(Enum.PlayerInteractionType.TaxiNode) then
			return
		end

		if addon.stagedGossipOptionID then
			if not InCombatLockdown() then
				HideUIPanel(WorldMapFrame) -- hide the map early for smoothness
			end

			C_GossipInfo.SelectOption(addon.stagedGossipOptionID)
			addon.stagedGossipOptionID = nil
		elseif addon:ShouldShowMap() then
			self:RefreshAllData()
		end
	elseif event == 'GOSSIP_CLOSED' then
		if not isActive then
			return
		end
		isActive = false
		hasChanged = false

		self:RestoreBlizzard()
		self:RemoveAllData()

		if WorldMapFrame:IsShown() then
			HideUIPanel(WorldMapFrame)
		end
	end
end

function gossipProviderMixin:OnRefresh()
	local numOptions = 0
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
						numOptions = numOptions + 1

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
				numOptions = numOptions + 1
			end

			if data.displayExtra then
				for _, extraData in next, data.displayExtra do
					self:AddPin(extraData, gossipInfo)
				end
			end
		elseif not unknownWarned[gossipInfo.gossipOptionID] then
			if not addon.ignoreOption[gossipInfo.gossipOptionID] then
				table.insert(unknownOptions, gossipInfo)
			end
		end
	end

	if numOptions == 1 and addon:GetOption('selectSingle') then
		for pin in self:EnumeratePins() do -- luacheck: ignore 512
			if pin.info.skipCinematic and addon:GetOption('skipCinematic') then
				addon:RegisterEvent('CINEMATIC_START', skipCinematic)
			end

			C_GossipInfo.SelectOption(pin:GetID())
			return
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
			C_Map.OpenWorldMap()
		end

		local commonMapID = addon:GetCommonMap()
		if commonMapID and not hasChanged then
			C_Map.OpenWorldMap(commonMapID)
			hasChanged = true
		end
	end
end

function gossipProviderMixin:AddPin(info, gossipInfo)
	if info.requiredQuest and not C_QuestLog.IsQuestFlaggedCompleted(info.requiredQuest) then
		return
	end

	local pin = self:AcquirePin()
	pin:SetID(gossipInfo.gossipOptionID)
	pin.owner = self
	pin.info = info
	pin.info.gossipName = gossipInfo.name -- used as tooltip fallback

	isActive = true

	-- flag the map for ancestry
	addon:FlagMap(info.forceMapID or info.mapID)

	if not pin:SetPosition(info.mapID, info.x, info.y) then
		pin:Hide()
		return
	end

	if info.isTaxi then
		pin:SetSize(20, 20)
		pin:SetIconAtlas('Taxi_Frame_Gray')
		pin:SetHighlightAtlas('Taxi_Frame_Yellow')

		hasTaxiPins = true
	elseif (gossipInfo and gossipInfo.flags and FlagsUtil.IsSet(gossipInfo.flags, Enum.GossipOptionRecFlags.QuestLabelPrepend)) or info.isQuest then
		pin:SetSize(32, 32)
		pin:SetIconAtlas('quest-campaign-available')
		pin:SetHighlightAtlas('quest-campaign-available')
	else
		pin:SetSize(info.atlasWidth or info.atlasSize or 24, info.atlasHeight or info.atlasSize or 24)
		pin:SetIconAtlas(info.atlas or 'MagePortalAlliance')
		pin:SetHighlightAtlas(info.highlightAtlas or info.atlas or 'MagePortalHorde')
		pin:SetHighlightBlendMode(info.highlightAdd and 'ADD' or 'BLEND')
	end

	if not info.noArrow then
		pin:AttachArrow()
	end
end

function gossipProviderMixin:AddSourcePin()
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

function gossipProviderMixin:HighlightRouteToPin(pin)
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

function gossipProviderMixin:OnRelease(hadPins)
	if hadPins then
		addon:ReleaseArrows()
		addon:ReleaseLines()
		hasTaxiPins = false
	end
end

function gossipProviderMixin:OnHide()
	if isActive and not addon.stagedGossipOptionID then
		C_GossipInfo.CloseGossip()
	end
end

local function isHandledExternally()
	return addon:IsAddOnEnabled('DialogueUI')
end

function gossipProviderMixin:DisableBlizzard()
	if isHandledExternally() then
		return
	end

	GossipFrame:SetScript('OnHide', nil)
	CustomGossipFrameManager:UnregisterAllEvents()
end

function gossipProviderMixin:RestoreBlizzard()
	if isHandledExternally() then
		return
	end

	GossipFrame:SetScript('OnHide', GossipFrameSharedMixin.OnHide)
	for _, event in next, CUSTOM_GOSSIP_FRAME_EVENTS do
		CustomGossipFrameManager:RegisterEvent(event)
	end
end

addon:CreateProvider('gossip', gossipProviderMixin, gossipPinMixin)
