local addon = select(2, ...)
local L = addon.L

local BROKENISLES = 619
local destinations = {
	[L['Dalaran']] 			= {zone = 627, x = 0.7246, y = 0.4594},
	[L['Stormheim']] 		= {zone = 634, x = 0.6034, y = 0.5106},
	[L['Azsuna']] 			= {zone = 630, x = 0.4749, y = 0.2755},
	[L['Val\'sharah']] 		= {zone = 641, x = 0.5462, y = 0.7313},
	[L['Highmountain']] 	= {zone = 750, x = 0.3853, y = 0.4554},
	[L['Suramar']] 			= {zone = 680, x = 0.3381, y = 0.4940},
	[L['Broken Shore']] 	= {zone = 646, x = 0.4427, y = 0.6299},
}

addon:Add(function(self)
	local npcID = self:GetNPCID()
	if(npcID == 96679) then
		self:SetMapID(BROKENISLES)

		for index, line in next, self:GetLines() do
			for name, loc in next, destinations do
				if(line:match(name)) then
					local Marker = self:NewMarker()
					Marker:SetID(index)
					Marker:SetTitle(name)
					Marker:SetNormalAtlas('Taxi_Frame_Gray')
					Marker:SetHighlightAtlas('Taxi_Frame_Yellow')
					Marker:SetSize(24)

					Marker:Pin(loc.zone, loc.x, loc.y, true)
				end
			end
		end
	end
end)
