local _, addon = ...

local COSMIC_MAP_ID = 946

local activeMaps = {}
function addon:FlagMap(mapID)
	if not tContains(activeMaps, mapID) then
		table.insert(activeMaps, mapID)
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

	function addon:GetCommonMap()
		-- returns the common parent map for the maps provided
		-- this logic is a bit wasteful with tables, but it's never called in combat and takes less
		-- than a frame to compute, so we're fine with that
		if #activeMaps == 1 then
			-- there's only one map
			return activeMaps[1]
		end

		-- build a table of map ancestries, where the outermost table is the Cosmic map, and the
		-- innermost table is each map in the provided table
		local ancestry = {}
		for _, mapID in next, activeMaps do
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

		if ancestry[COSMIC_MAP_ID] and addon.activeCosmicWorlds then
			for mapID in next, ancestry[COSMIC_MAP_ID] do
				table.insert(addon.activeCosmicWorlds, mapID)
			end
		end

		return commonParentMapID
	end
end

WorldMapFrame:HookScript('OnHide', function()
	table.wipe(activeMaps)

	if addon.activeCosmicWorlds then
		table.wipe(addon.activeCosmicWorlds)
	end
end)

-- expose a namespace
InteractiveWormholes = {}

-- expose an API for other addons to use to check if we're active
function InteractiveWormholes:IsActive()
	if IsShiftKeyDown() or InCombatLockdown() then
		-- we'll never be active if the user holds shift or if the player is in combat
		return false
	end

	if addon.stagedGossipOptionID ~= nil then
		-- there's a staged option, we're still active
		return true
	end

	for _, gossipInfo in next, C_GossipInfo.GetOptions() do
		if addon.data[gossipInfo.gossipOptionID or 0] then
			-- there's an option we manage, we're active
			return true
		end
	end

	return false
end
