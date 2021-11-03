local addon = select(2, ...)
local L = addon.L

local MAW = 1543
local destinations = {
	[L['The Tremaculum']]   = {x = 0.3419, y = 0.1473},
	[L['The Beastwarrens']] = {x = 0.5342, y = 0.6364},
	[L['Perdition Hold']]   = {x = 0.3394, y = 0.5678},
	[L['Desmotaeron']]      = {x = 0.6889, y = 0.3680},
}

local function showCondition(self, npcID)
	return npcID == 172925 -- Animaflow Teleporter
end

addon:Add(showCondition, function(self)
	self:SetMapID(MAW)

	local Source = self:NewMarker()
	Source:SetTitle(L['You are here'])
	Source:SetNormalAtlas('Taxi_Frame_Green')
	Source:SetHighlightAtlas('Taxi_Frame_Green')
	Source:SetSize(24)
	Source:DisableArrow()
	Source:Pin(MAW, 0.4829, 0.4144)

	for index, line in next, self:GetLines() do
		for name, loc in next, destinations do
			if line:match(name) then
				local Marker = self:NewMarker()
				Marker:SetID(index)
				Marker:SetTitle(name)
				Marker:SetNormalAtlas('Taxi_Frame_Gray')
				Marker:SetHighlightAtlas('Taxi_Frame_Yellow')
				Marker:SetSize(24)
				Marker:SetSource(Source)

				Marker:Pin(MAW, loc.x, loc.y, true)
			end
		end
	end
end)
