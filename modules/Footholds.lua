local addon = select(2, ...)
local L = addon.L

local npcData = {
	[135690] = { -- Dread-Admiral Tattersail
		mapID = 876, -- Kul Tiras
		normalAtlas = 'bfa-landingbutton-horde-up',
		highlightAtlas = 'bfa-landingbutton-horde-diamondhighlight',
		destinations = {
			[addon:GetMapName(896)] = {x = 0.2061, y = 0.4569, zone = 896}, -- Drustvar
			[addon:GetMapName(942)] = {x = 0.5198, y = 0.2449, zone = 942}, -- Stormsong Valley
			[addon:GetMapName(895)] = {x = 0.8820, y = 0.5116, zone = 895}, -- Tiragarde Sound
		}
	},
	[135681] = { -- Grand Admiral Jes-Tereth
		mapID = 875, -- Zandalar
		normalAtlas = 'bfa-landingbutton-alliance-up',
		highlightAtlas = 'bfa-landingbutton-alliance-shieldhighlight',
		destinations = {
			[addon:GetMapName(862)] = {x = 0.4068, y = 0.7085, zone = 862}, -- Zuldazar
			[addon:GetMapName(863)] = {x = 0.6196, y = 0.4020, zone = 863}, -- Nazmir
			[addon:GetMapName(864)] = {x = 0.3560, y = 0.3317, zone = 864}, -- Vol'dun
		}
	}
}

if(GetLocale() == 'ruRU') then
	-- why the hell are there two translations for "Stormsong Valley" in russian locale?
	npcData[135690].destinations['долину Штормов'] = npcData[135690].destinations[addon:GetMapName(942)]
end

local function showCondition(self, npcID)
	return not not npcData[npcID]
end

addon:Add(showCondition, function(self, npcID)
	local data = npcData[npcID]
	self:SetMapID(data.mapID)

	for index, line in next, self:GetLines() do
		for name, loc in next, data.destinations do
			if line:match(name) then
				local Marker = self:NewMarker()
				Marker:SetID(index)
				Marker:SetNormalAtlas(data.normalAtlas)
				Marker:SetHighlightAtlas(data.highlightAtlas, true)
				Marker:SetSize(40)

				if line:match('FF0000FF') then
					-- part of the text is colored blue when it's part of an active quest
					Marker:MarkQuest()
				end

				Marker:Pin(loc.zone, loc.x, loc.y, true)
			end
		end
	end
end)
