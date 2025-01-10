local _, addon = ...

local COSMIC_MAP_ID = 946

local activeMaps = addon:T()
function addon:FlagMap(mapID)
	if not activeMaps:contains(mapID) then
		activeMaps:insert(mapID)
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
		local ancestry = addon:T()
		for _, mapID in next, activeMaps do
			-- merge this map ancestry with all others
			ancestry:merge(getMapAncestry(mapID))
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
				addon.activeCosmicWorlds:insert(mapID)
			end
		end

		return commonParentMapID
	end
end

WorldMapFrame:HookScript('OnHide', function()
	activeMaps:wipe()

	if addon.activeCosmicWorlds then
		addon.activeCosmicWorlds:wipe()
	end
end)
