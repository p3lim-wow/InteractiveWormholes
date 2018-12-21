local addon = select(2, ...)
local L = addon.L

local HBD = LibStub('HereBeDragons-2.0')
local npcData = {
	[135690] = { -- Dread-Admiral Tattersail
		mapID = 876, -- Kul Tiras
		normalAtlas = 'bfa-landingbutton-horde-up',
		highlightAtlas = 'bfa-landingbutton-horde-diamondhighlight',
		destinations = {
			[HBD:GetLocalizedMap(896)] = {x = 0.2061, y = 0.4569, zone = 896}, -- Drustvar
			[HBD:GetLocalizedMap(942)] = {x = 0.5198, y = 0.2449, zone = 942}, -- Stormsong Valley
			[HBD:GetLocalizedMap(895)] = {x = 0.8820, y = 0.5116, zone = 895}, -- Tiragarde Sound
		}
	},
	[135681] = { -- Grand Admiral Jes-Tereth
		mapID = 875, -- Zandalar
		normalAtlas = 'bfa-landingbutton-alliance-up',
		highlightAtlas = 'bfa-landingbutton-alliance-shieldhighlight',
		destinations = {
			[HBD:GetLocalizedMap(862)] = {x = 0.4068, y = 0.7085, zone = 862}, -- Zuldazar
			[HBD:GetLocalizedMap(863)] = {x = 0.6196, y = 0.4020, zone = 863}, -- Nazmir
			[HBD:GetLocalizedMap(864)] = {x = 0.3560, y = 0.3317, zone = 864}, -- Vol'dun
		}
	}
}

addon:Add(function(self)
	local npcID = self:GetNPCID()
	local data = npcData[npcID]
	if(data) then
		self:SetMapID(data.mapID)

		for index, line in next, self:GetLines() do
			for name, loc in next, data.destinations do
				if(line:match(name)) then
					local Marker = self:NewMarker()
					Marker:SetID(index)
					Marker:SetNormalAtlas(data.normalAtlas)
					Marker:SetHighlightAtlas(data.highlightAtlas, true)
					Marker:SetSize(40)

					if(line:match('FF0000FF')) then
						-- part of the text is colored blue when it's part of an active quest
						Marker:MarkQuest()
					end

					Marker:Pin(loc.zone, loc.x, loc.y, true)
				end
			end
		end
	end
end)
