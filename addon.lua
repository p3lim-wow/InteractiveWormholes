local _, addon = ...

local HBD = LibStub('HereBeDragons-2.0')

addon.activeMaps = {}
addon.activeCosmicWorlds = {}

function addon:ShowMap()
	if not WorldMapFrame:IsShown() and not InCombatLockdown() then
		-- never attempt to toggle the map while in combat
		ToggleWorldMap() -- POSSIBLE TAINT
	end

	-- get the common parent map of all pins
	local commonMapID, mapAncestries = self:GetCommonMap()

	-- we want to show hints on the cosmic map when there are destinations
	-- available in worlds within, so we store the world map IDs for each one
	for _, mapAncestry in next, mapAncestries do
		if not tContains(self.activeCosmicWorlds, mapAncestry[2]) then
			table.insert(self.activeCosmicWorlds, mapAncestry[2])
		end
	end

	-- change to a map
	WorldMapFrame:SetMapID(commonMapID) -- POSSIBLE TAINT
end

do
	local function traverseMapAncestry(t, mapID, sourceMapID)
		-- find the parent map
		local parentMapID = HBD.mapData[mapID].parent
		if parentMapID then
			-- parent map exists, prepend it to the table then recurse
			table.insert(t[sourceMapID], 1, parentMapID)
			traverseMapAncestry(t, parentMapID, sourceMapID)
		end
	end

	function addon:GetCommonMap()
		-- if there is only one map then we don't need to do anything
		if #self.activeMaps == 1 then
			return self.activeMaps[1]
		end

		-- iterate through all active maps and traverse through their ancestry,
		-- each map ancestry is sorted by closest to cosmos to furthest from
		local mapAncestries = {}
		for _, mapID in next, self.activeMaps do
			mapAncestries[mapID] = {mapID}
			traverseMapAncestry(mapAncestries, mapID, mapID)
		end

		-- get the first map of the traversed ancestries
		local firstMapID, firstMapAncestry = next(mapAncestries)

		-- traverse the first map ancestry
		for index, mapID in next, firstMapAncestry do
			-- traverse all the other map ancestries after the first one
			for _, mapAncestry in next, mapAncestries, firstMapID do
				-- check if the mapID at the same index as the first ancestry matches this one
				if mapAncestry[index] ~= mapID then
					-- if they don't match, the mapID with the previous index is the most common one
					return mapAncestry[index - 1], mapAncestries
				end
			end
		end

		-- if it gets to here a map was not found
		-- TODO: consider throwing an error
	end
end

function addon:HandleGossip()
	-- if not self.stagedGossipOptionID then
	-- 	self:Reset() -- there are edge cases, like when interacting with two wormholes
	-- end

	-- never activate if the player is in combat or the shift key is held down
	if IsShiftKeyDown() or InCombatLockdown() then
		return
	end

	-- we'll track any option that is not being used while active, to let the player know if
	-- they might miss out on an option not supported by the addon
	local unusedOptions = {}

	-- iterate through the options
	for _, gossipInfo in next, C_GossipInfo.GetOptions() do
		-- if the option is part of the staging system (e.g. Mole Machine) then select the staged
		-- option and bail out, also preventing the default gossip UI from activating
		if self.stagedGossipOptionID == gossipInfo.gossipOptionID then
			C_GossipInfo.SelectOption(self.stagedGossipOptionID)
			return true
		end

		-- check if we support the option
		local info = self.data[gossipInfo.gossipOptionID]
		if info then
			-- there is a supported option, we'll take over the gossip interaction
			self.isActive = true

			-- check if the option has known children (e.g. the sub-menus for Mole Machine), if so
			-- we'll show them instead of this option
			if info.children then
				for _, childGossipOptionID in next, info.children do
					local childInfo = self.data[childGossipOptionID]
					if childInfo then
						self:AddPin(childInfo, childGossipOptionID)
					end
				end
			else
				self:AddPin(info, gossipInfo.gossipOptionID, gossipInfo.name)
			end

			if info.displayExtra then
				for _, extraInfo in next, info.displayExtra do
					self:AddPin(extraInfo, gossipInfo.gossipOptionID, gossipInfo.name)
				end
			end
		else
			-- the option is not handled, track it
			table.insert(unusedOptions, gossipInfo)
		end
	end

	if self.isActive then
		-- if there are any options not handled while we're active we'll need to inform the player
		if #unusedOptions > 0 then
			-- TODO: improve this
			print('There are other options not shown on the map:')
			for index, gossipInfo in next, unusedOptions do
				print(string.format('- %d: %d (%s)', index, gossipInfo.gossipOptionID, gossipInfo.name))
			end
			print('Please report this at https://github.com/p3lim-wow/InteractiveWormholes/issues')
		end

		-- if if there are options considered to be taxi destinations then show a source pin on the
		-- player as a point for lines to render from
		if self.hasTaxiPins then
			self:AddSourcePin()
		end

		-- show the world map, which will figure out by itself which map to display
		self:ShowMap()
		return true
	end
end

function addon:Reset()
	if not InCombatLockdown() and WorldMapFrame:IsShown() then
		-- never attempt to toggle the map while in combat
		ToggleWorldMap() -- POSSIBLE TAINT
	end

	self.isActive = false
	self.hasTaxiPins = false
	self.sourcePin = nil
	self.stagedGossipOptionID = nil

	addon.pinPool:ReleaseAll()
	table.wipe(addon.activeMaps)
	table.wipe(addon.activeCosmicWorlds)
end

-- we'll need to override GossipFrame's own methods to prevent it from running if we are
-- TODO: figure out if there is any way to deal with this better
function GossipFrame.HandleShow(...) -- POSSIBLE TAINT
	if not addon:HandleGossip() then
		GossipFrameMixin.HandleShow(...) -- POSSIBLE TAINT
	end
end

GossipFrame:SetScript('OnHide', function(...) -- POSSIBLE TAINT
	if not addon.isActive then
		GossipFrameSharedMixin.OnHide(...) -- POSSIBLE TAINT
	end
end)

-- add reset methods of our own
EventRegistry:RegisterFrameEventAndCallback('GOSSIP_CLOSED', function()
	if addon.isActive then
		addon:Reset()
	end
end)

WorldMapFrame:HookScript('OnHide', function()
	if addon.isActive then
		C_GossipInfo.CloseGossip()
	end
end)

-- TODO: map button in gossip
