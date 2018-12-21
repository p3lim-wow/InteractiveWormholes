local addon = select(2, ...)
local L = addon.L

local HBD = LibStub('HereBeDragons-2.0')
local npcData = {
	[148565] = { -- Avery Nightwing (Darkshore, Horde)
		mapID = 1203,
		source = {x = 0.4861, y = 0.3447},
		destinations = {
			[L['Bashal\'Aran']]       = {x = 0.4956, y = 0.5587},
			[L['Gloomtide Strand']]   = {x = 0.4669, y = 0.4768},
			[L['Cinderfall Grove']]   = {x = 0.5632, y = 0.4407},
			[L['Lor\'danel Landing']] = {x = 0.5434, y = 0.2252},
		}
	},
	[145743] = { -- Fidelio Featherleaf (Darkshore, Alliance)
		mapID = 1203,
		source = {x = 0.4861, y = 0.3447},
		destinations = {
			[L['Bashal\'Aran']]     = {x = 0.4956, y = 0.5487},
			[L['Gloomtide Strand']] = {x = 0.4669, y = 0.4768},
			[L['Cinderfall Grove']] = {x = 0.5632, y = 0.4407},
		}
	},
}

addon:Add(function(self)
	local npcID = self:GetNPCID()
	local data = npcData[npcID]
	if(data) then
		local mapID = data.mapID
		self:SetMapID(mapID)

		local Source = self:NewMarker()
		Source:SetTitle(L['You are here'])
		Source:SetNormalAtlas('Taxi_Frame_Green')
		Source:SetHighlightAtlas('Taxi_Frame_Green')
		Source:SetSize(24)
		Source:DisableArrow()
		Source:Pin(mapID, data.source.x, data.source.y)

		for index, line in next, self:GetLines() do
			for name, loc in next, data.destinations do
				if(line:match(name)) then
					local Marker = self:NewMarker()
					Marker:SetID(index)
					Marker:SetTitle(name)
					Marker:SetNormalAtlas('Taxi_Frame_Gray')
					Marker:SetHighlightAtlas('Taxi_Frame_Yellow')
					Marker:SetSize(20)
					Marker:SetSource(Source)

					Marker:Pin(mapID, loc.x, loc.y)
				end
			end
		end
	end
end)
