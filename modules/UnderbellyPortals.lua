local addon = select(2, ...)
local L = addon.L

local UNDERBELLY = 628
local destinations = {
	[L['Sewer Guard Station']] = {x = 0.685, y = 0.570},
	[L['Black Market']]        = {x = 0.700, y = 0.167},
	[L['Inn Entrance']]        = {x = 0.673, y = 0.691},
	[L['Alchemists\' Lair']]   = {x = 0.781, y = 0.796},
	[L['Abandoned Shack']]     = {x = 0.425, y = 0.516},
	[L['Rear Entrance']]       = {x = 0.307, y = 0.467},
}

addon:Add(function(self)
	local npcID = self:GetNPCID()
	if(npcID >= 107779 and npcID <= 107784) then
		self:SetMapID(UNDERBELLY)

		for index, line in next, self:GetLines() do
			local loc = destinations[line]
			if(loc) then
				local Marker = self:NewMarker()
				Marker:SetID(index)
				Marker:SetTitle(line)
				Marker:SetNormalAtlas('MagePortalAlliance')
				Marker:SetHighlightAtlas('MagePortalHorde')

				Marker:Pin(UNDERBELLY, loc.x, loc.y)
			end
		end

		return true
	end
end)
