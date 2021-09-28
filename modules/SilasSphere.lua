local addon = select(2, ...)
local L = addon.L

-- this item gives the player the option to go to any of the flight points in the current zone,
-- so we just piggyback onto the flight point API, it's accurate enough for our purposes

local inconsistencies = {
	-- it's not blizzard code without some faults
	['Seekers\' Vista'] = 'Seekers Vista', -- Stormsong Valley
}

local function showCondition(self, npcID)
	return npcID == 151566 -- Oculus of Transportation
end

-- local page = 0
addon:Add(showCondition, function(self)
	if self:GetNumLines() == 1 then
		-- TODO: describe what's happening here
		self:SelectGossipIndex(1)
		return
	end

	local mapID = C_Map.GetBestMapForUnit('player')
	self:SetMapID(mapID)

	for index, line in next, self:GetLines() do
		for _, nodeInfo in next, C_TaxiMap.GetTaxiNodesForMap(mapID) do
			if nodeInfo.name:match(inconsistencies[line] or line) then
				local Marker = self:NewMarker()
				Marker:SetID(index)
				Marker:SetTitle(line)
				Marker:SetNormalAtlas('MagePortalAlliance')
				Marker:SetHighlightAtlas('MagePortalHorde')
				Marker:Pin(mapID, nodeInfo.position.x, nodeInfo.position.y, true)
			end
		end
	end
end)
