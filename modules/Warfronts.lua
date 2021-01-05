local addon = select(2, ...)
local L = addon.L

local npcData = {
	[127068] = { -- Flightgineer Krazzle (Arathi, Horde)
		mapID = 943,
		source = {x = 0.5112, y = 0.4696},
		destinations = {
			[L['Ar\'gorok']]          = {x = 0.6020, y = 0.2237},
			[L['Hatchet Ridge']]      = {x = 0.4539, y = 0.2213},
			[L['Drywhisker Mine']]    = {x = 0.6997, y = 0.3329},
			[L['Newstead']]           = {x = 0.4056, y = 0.4074},
			[L['Circle of Elements']] = {x = 0.6831, y = 0.4755},
		}
	},
	[132005] = { -- Grayson Bell (Arathi, Alliance)
	 	mapID = 1044,
		source = {x = 0.5112, y = 0.4709},
		destinations = {
			[L['Stromgarde Keep']]    = {x = 0.4583, y = 0.8517},
			[L['Highlands Mill']]     = {x = 0.3577, y = 0.5733},
			[L['Galson\'s Lode']]     = {x = 0.6276, y = 0.6951},
			[L['Newstead']]           = {x = 0.4069, y = 0.4068},
			[L['Circle of Elements']] = {x = 0.6852, y = 0.4893},
		}
	},
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
			[L['Bashal\'Aran']]       = {x = 0.5086, y = 0.5491},
			[L['Gloomtide Strand']]   = {x = 0.4669, y = 0.4768},
			[L['Cinderfall Grove']]   = {x = 0.5632, y = 0.4407},
			[L['Lor\'danel Landing']] = {x = 0.5434, y = 0.2252},
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

		return true
	end
end)
