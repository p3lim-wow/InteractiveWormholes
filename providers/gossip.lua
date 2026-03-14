local _, addon = ...

-- upvalue API because we disable it
local C_GossipInfo_CloseGossip = C_GossipInfo.CloseGossip

local stagedGossipOptionID

local function HandleCinematicSkip()
	if CanCancelScene() then
		CancelScene()
	end

	return true
end

local provider = {}
provider.data = addon:T()

function provider:OnPinClick(button, down)
	if button == 'LeftButton' and not down then
		local gossipOptionID = self:GetID()
		if gossipOptionID then
			local data = addon.data[gossipOptionID]
			if data.parent then
				stagedGossipOptionID = gossipOptionID
				C_GossipInfo.SelectOption(data.parent)
			elseif gossipOptionID > 0 then
				if data.skippableCinematic and addon:GetOption('skipCinematic') then
					addon:RegisterEvent('CINEMATIC_START', HandleCinematicSkip)
				end

				C_GossipInfo.SelectOption(gossipOptionID)
			end
		end
	end
end

function provider:OnPinEnter()
	local gossipOptionID = self:GetID()
	if gossipOptionID then
		local data = addon.data[gossipOptionID]
		local tooltip = addon:GetTooltip(self, 'ANCHOR_RIGHT')

		if data.tooltipQuests then
			for _, questID in next, data.tooltipQuests do
				if C_QuestLog.IsOnQuest(questID) then
					C_QuestLog.RequestLoadQuestByID(questID) -- trigger cache
					tooltip:AddLine(C_QuestLog.GetTitleForQuestID(questID))
					break
				end
			end
		elseif data.tooltipQuest then
			C_QuestLog.RequestLoadQuestByID(data.tooltipQuest) -- trigger cache
			tooltip:AddLine(C_QuestLog.GetTitleForQuestID(data.tooltipQuest))
		elseif data.tooltipArea then
			tooltip:AddLine(C_Map.GetAreaInfo(data.tooltipArea)) -- from AreaTable.db2
		elseif data.tooltipMap then
			local mapInfo = C_Map.GetMapInfo(data.tooltipMap)
			tooltip:AddLine(mapInfo.name)
		elseif data.tooltip then
			if type(data.tooltip) == 'function' then
				tooltip:AddLine(data.tooltip())
			else
				tooltip:AddLine(data.tooltip)
			end
		else
			tooltip:AddLine(data.name) -- from gossipInfo
		end

		tooltip:Show()

		if data.isTaxi then
			-- add lines to fake a route
			if data.taxiSourceIndex then
				-- enumerate all pins and sort them by their taxi index
				-- TODO: make this logic smarter than just linear routes?
				local taxiIndexPins = {}
				for activePin in self.owner:EnumeratePins() do
					local activePinData = addon.data[activePin:GetID()]
					if activePinData.taxiIndex then
						taxiIndexPins[activePinData.taxiIndex] = activePin
					else
						taxiIndexPins[data.taxiSourceIndex] = activePin
					end
				end

				local curIndex = data.taxiIndex
				while curIndex ~= data.taxiSourceIndex do
					-- set line source to the current pin
					local startPin = taxiIndexPins[curIndex]

					-- update pointer to the next pin
					if curIndex > data.taxiSourceIndex then
						curIndex = curIndex - 1
					else
						curIndex = curIndex + 1
					end

					-- set line destination to the next pin
					local endPin = taxiIndexPins[curIndex]
					addon:AttachLine(startPin, endPin)
				end
			else
				-- just pin it to the source pin
				for activePin in self.owner:EnumeratePins() do
					local activePinData = addon.data[activePin:GetID()]
					if activePinData.isTaxiSource then
						addon:AttachLine(activePin, self)
						break
					end
				end
			end
		end
	end
end

function provider:OnPinLeave()
	addon:HideTooltip()
	addon:ReleaseLines()
end

function provider:OnPinCreate(gossipInfo)
	local data = gossipInfo.data

	-- inject name, used as a fallback for tooltips
	data.name = gossipInfo.name

	local mapID, x, y
	if data.isTaxiSource then
		mapID = C_Map.GetBestMapForUnit('player') or -1
		x, y = C_Map.GetPlayerMapPosition(mapID, 'player'):GetXY()
	else
		mapID = data.mapID
		x = data.x
		y = data.y
	end

	if mapID and x and y then
		self:SetID(gossipInfo.gossipOptionID or 0)

		if data.isTaxi then
			self:SetSize(20, 20)
			self:SetNormalAtlas('Taxi_Frame_Gray')
			self:SetHighlightAtlas('Taxi_Frame_Yellow', 'BLEND')
		elseif data.isQuest or (gossipInfo.flags and FlagsUtil.IsSet(gossipInfo.flags, Enum.GossipOptionRecFlags.QuestLabelPrepend)) then
			self:SetSize(32, 32)
			self:SetNormalAtlas('quest-campaign-available')
			self:SetHighlightAtlas('quest-campaign-available', 'BLEND')
		else
			self:SetWidth(data.atlasWidth or data.atlasSize or 24)
			self:SetHeight(data.atlasHeight or data.atlasSize or 24)
			self:SetNormalAtlas(data.atlas or 'MagePortalAlliance')
			self:SetHighlightAtlas(data.highlightAtlas or data.atlas or 'MagePortalHorde', data.highlightAdd and 'ADD' or 'BLEND')
		end

		if not data.noArrow then
			addon:AttachArrow(self)
		end

		return mapID, x, y
	end
end

function provider:OnMapHide()
	C_GossipInfo_CloseGossip()
end

addon:AddProvider(provider)

-- event handling

local function InjectData(gossipInfo, data)
	local hasTaxiData = false
	if data.children then
		for _, gossipOptionID in next, data.children do
			local childData = addon.data[gossipOptionID]
			if childData then
				gossipInfo.gossipOptionID = gossipOptionID
				if InjectData(gossipInfo, childData) then
					hasTaxiData = true
				end
			end
		end
	else
		if data.displayExtra then
			for _, extraData in next, data.displayExtra do
				if InjectData(gossipInfo, extraData) then
					hasTaxiData = true
				end
			end
		end

		local shouldShow = true
		if data.disabledOnQuests then
			for _, questID in next, data.disabledOnQuests do
				if C_QuestLog.IsOnQuest(questID) then
					shouldShow = false
					break
				end
			end
		end

		if shouldShow then
			provider.data:insert(Mixin({
				data = data,
			}, gossipInfo))

			addon:SetActiveMap(data.mapID)

			if data.isTaxi then
				hasTaxiData = true
			end
		end
	end

	return hasTaxiData
end

local unknown = addon:T()
local unknownWarned = {}

function addon:GOSSIP_SHOW()
	if stagedGossipOptionID then
		C_GossipInfo.SelectOption(stagedGossipOptionID)
		stagedGossipOptionID = nil
		return
	end

	if addon:IsPaused() then
		return
	end

	if C_PlayerInteractionManager.IsInteractingWithNpcOfType(Enum.PlayerInteractionType.TaxiNode) then
		return
	end

	if InCombatLockdown() then
		-- UIErrorsFrame:AddExternalErrorMessage(ERR_NOT_IN_COMBAT)
		return
	end

	local options = C_GossipInfo.GetOptions()
	if not options or #options == 0 then
		return
	end

	unknown:wipe()

	local hasTaxiData
	for _, gossipInfo in next, options do
		local gossipOptionID = gossipInfo.gossipOptionID
		if gossipOptionID then
			local data = addon.data[gossipOptionID]
			if data then
				hasTaxiData = InjectData(gossipInfo, data)
			elseif not addon.ignoreOption[gossipOptionID] and not unknownWarned[gossipOptionID] then
				unknown:insert(gossipInfo)
			end
		end
	end

	if #provider.data == 0 then
		addon:ResetActiveMaps()
		return
	elseif #provider.data == 1 and addon:GetOption('selectSingle') then
		local gossipOptionID = provider.data[1].gossipOptionID
		local data = addon.data[gossipOptionID]

		if data.skippableCinematic and addon:GetOption('skipCinematic') then
			addon:RegisterEvent('CINEMATIC_START', HandleCinematicSkip)
		end

		C_GossipInfo.SelectOption(gossipOptionID)
		return
	end

	if hasTaxiData then
		-- add a fake pin used to show the taxi source (i.e. where the player is standing)
		provider.data:insert({
			data = addon.data[0]
		})
	end

	if #unknown > 0 then
		addon:Print('There are more options not shown on the map:')
		for _, gossipInfo in next, unknown do
			unknownWarned[gossipInfo.gossipOptionID] = true
			addon:Printf('- %d, "%s"', gossipInfo.gossipOptionID, gossipInfo.name)
		end
		addon:Print('Please report this at |cff71d5ffhttps://p3l.im/wormhole|r')
		addon:Printf('Hold SHIFT while interacting to this %s to see them.', UnitIsGameObject('npc') and 'object' or 'npc')
	end

	-- check if we have a forced map
	local forcedMapID
	for _, gossipInfo in next, provider.data do
		if gossipInfo.data.forceMapID then
			forcedMapID = gossipInfo.data.forceMapID
			break
		end
	end

	-- I'd rather control the gossip OnHide, but resetting that will taint the map for some reason,
	-- and we need to prevent it from closing the gossip interaction before we take over
	C_GossipInfo.CloseGossip = function() end

	C_Map.OpenWorldMap(forcedMapID or addon:GetCommonMap())
end

function addon:GOSSIP_CLOSED()
	if WorldMapFrame:IsShown() then
		HideUIPanel(WorldMapFrame)
	end

	stagedGossipOptionID = nil

	provider.data:wipe()

	if addon:IsEventRegistered('CINEMATIC_START', HandleCinematicSkip) then
		addon:UnregisterEvent('CINEMATIC_START', HandleCinematicSkip)
	end

	-- restore API
	C_GossipInfo.CloseGossip = C_GossipInfo_CloseGossip
end

