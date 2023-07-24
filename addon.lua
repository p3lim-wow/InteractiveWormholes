local _, addon = ...

local HBD = LibStub('HereBeDragons-2.0')

addon.activeMaps = {}
addon.activeCosmicWorlds = {}

function addon:ShowMap()
	if not WorldMapFrame:IsShown() and not InCombatLockdown() then
		-- never attempt to toggle the map while in combat
		securecall('ShowUIPanel', WorldMapFrame)
	end

	-- if there is a common parent map for all pins then change the map to it
	local commonMapID, activeCosmicWorlds = self:GetCommonMap(self.activeMaps)
	if commonMapID then
		-- show arrows on active cosmic worlds (if any)
		for mapID in next, activeCosmicWorlds or {} do
			table.insert(self.activeCosmicWorlds, mapID)
		end

		-- change to a map
		WorldMapFrame:SetMapID(commonMapID)
	end
end

do
	-- API cache
	local MAP_PARENT = setmetatable({}, {
		__index = function(self, mapID)
			local mapInfo = C_Map.GetMapInfo(mapID)
			if mapInfo and mapInfo.parentMapID and mapInfo.parentMapID ~= 0 then
				rawset(self, mapID, mapInfo.parentMapID)
				return mapInfo.parentMapID
			end
		end
	})

	local function getMapAncestry(mapID, ancestry)
		-- recurse through parent maps and build a table from Cosmic inward of children
		local parentMapID = MAP_PARENT[mapID]
		if parentMapID then
			return getMapAncestry(parentMapID, {
				[parentMapID] = ancestry or {
					[mapID] = {}
				}
			})
		else
			return ancestry
		end
	end

	local function mergeTables(t1, t2)
		-- recurse through tables and merge them
		for k, v in next, t2 do
			if type(t1[k] or false) == 'table' then
				mergeTables(t1[k], t2[k])
			else
				t1[k] = v
			end
		end
		return t1
	end

	function addon:GetCommonMap(maps)
		-- returns the common parent map for the maps provided
		-- this logic is a bit wasteful with tables, but it's never called in combat and takes less
		-- than a frame to compute, so we're fine with that
		if #maps == 1 then
			-- there's only one map
			return maps[1]
		end

		-- build a table of map ancestries, where the outermost table is the Cosmic map, and the
		-- innermost table is each map in the provided table
		local ancestry = {}
		for _, mapID in next, maps do
			-- merge this map ancestry with all others
			ancestry = mergeTables(ancestry, getMapAncestry(mapID))
		end

		-- iterate through the full ancestry table until we find a parent map that has either
		-- multiple or no children
		local commonParentMapID
		local parentAncestry = ancestry
		repeat
			commonParentMapID, parentAncestry = next(parentAncestry)
		until addon:tsize(parentAncestry) ~= 1

		return commonParentMapID, ancestry[946]
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
			self.stagedGossipOptionID = nil
			return
		end

		if gossipInfo.gossipOptionID and gossipInfo.gossipOptionID > 0 then
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
	end

	if self.isActive then
		-- prevent GossipFrame hiding from closing gossip API
		GossipFrame:SetScript('OnHide', nil)

		-- if there are any options not handled while we're active we'll need to inform the player
		if #unusedOptions > 0 then
			-- TODO: improve this
			self:Print('There are more options not shown on the map:')
			for index, gossipInfo in next, unusedOptions do
				self:Printf('- %d: %d (%s)', index, gossipInfo.gossipOptionID, gossipInfo.name)
			end
			self:Print('Please report this at https://github.com/p3lim-wow/InteractiveWormholes/issues')
		end

		-- if if there are options considered to be taxi destinations then show a source pin on the
		-- player as a point for lines to render from
		if self.hasTaxiPins then
			self:AddSourcePin()
		end

		-- show the world map, which will figure out by itself which map to display
		self:ShowMap()
	end
end

function addon:Reset()
	if not InCombatLockdown() and WorldMapFrame:IsShown() then
		-- never attempt to toggle the map while in combat
		securecall('HideUIPanel', WorldMapFrame)
	end

	self.isActive = false
	self.hasTaxiPins = false
	self.sourcePin = nil
	self.stagedGossipOptionID = nil

	addon.pinPool:ReleaseAll()
	table.wipe(addon.activeMaps)
	table.wipe(addon.activeCosmicWorlds)

	-- restore GossipFrame functionality
	GossipFrame:SetScript('OnHide', GossipFrameSharedMixin.OnHide)
end

function addon:GOSSIP_SHOW()
	self:HandleGossip()
end

function addon:GOSSIP_CLOSED()
	if self.isActive and not self.stagedGossipOptionID then
		self:Reset()
	end
end

WorldMapFrame:HookScript('OnHide', function()
	if addon.isActive and not addon.stagedGossipOptionID then
		C_GossipInfo.CloseGossip()
	end
end)
