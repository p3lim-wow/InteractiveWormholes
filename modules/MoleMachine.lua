local addon = select(2, ...)
local L = addon.L

local AZEROTH = 947
local continents = {
	[L['Eastern Kingdoms']] = {
		[L['Ironforge']]                  = {zone=27,   x=0.6129, y=0.3718},              -- Ironforge
		[L['Stormwind']]                  = {zone=84,   x=0.6333, y=0.3734},              -- Stormwind
		[L['Nethergarde Keep']]           = {zone=17,   x=0.6197, y=0.1280, quest=53594}, -- Blasted Lands
		[L['Aerie Peak']]                 = {zone=26,   x=0.1353, y=0.4680, quest=53585}, -- The Hinterlands
		[L['The Masonary']]               = {zone=35,   x=0.3330, y=0.2480, quest=53587}, -- Black Rock Mountains
		[L['Shadowforge City']]           = {zone=35,   x=0.5093, y=0.1607},              -- Shadowforge City
		-- [L['Shadowforge City']]        = {zone=1186, x=0.6144, y=0.2435},              -- Shadowforge City (actual location)
	},
	[L['Kalimdor']] = {
		[L['Fire Plume Ridge']]           = {zone=78,   x=0.5288, y=0.5576, quest=53591}, -- Un'Goro Crater
		[L['Throne of Flame']]            = {zone=198,  x=0.5718, y=0.7711, quest=53601}, -- Mount Hyjal
		[L['The Great Divide']]           = {zone=199,  x=0.3911, y=0.0930, quest=53600}, -- Southern Barrens
	},
	[L['Outland']] = {
		[L['Honor Hold']]                 = {zone=100,  x=0.5309, y=0.6487, quest=53592}, -- Honor Hold
		[L['Fel Pits']]                   = {zone=104,  x=0.5077, y=0.3530, quest=53599}, -- Shadowmoon Valley
		[L['Skald']]                      = {zone=105,  x=0.7242, y=0.1764, quest=53597}, -- Blade's Edge Mountains
	},
	[L['Northrend']] = {
		[L['Argent Tournament Grounds']]  = {zone=118,  x=0.7697, y=0.1866, quest=53586}, -- Icecrown
		[L['Ruby Dragonshrine']]          = {zone=115,  x=0.4535, y=0.4992, quest=53596}, -- Dragonblight
	},
	[L['Pandaria']] = {
		[L['One Keg']]                    = {zone=379,  x=0.5768, y=0.6281, quest=53595}, -- Kun-Lai Summit
		[L['Stormstout Brewery']]         = {zone=376,  x=0.3151, y=0.7359, quest=53598}, -- Valley of the Four Winds
	},
	[L['Draenor']] = {
		[L['Blackrock Foundry Overlook']] = {zone=543,  x=0.4669, y=0.3876, quest=53588}, -- Gorgrond
		[L['Elemental Plateau']]          = {zone=550,  x=0.6575, y=0.0825, quest=53590}, -- Nagrand
	},
	[L['Broken Isles']] = {
		[L['Neltharion\'s Vault']]        = {zone=650,  x=0.4466, y=0.7290, quest=53593}, -- Highmountain
		[L['Broken Shore']]               = {zone=646,  x=0.7169, y=0.4799, quest=53589}, -- The Broken Shore
	}
}

local location
local function OnClick(self)
	-- select the continent in the parent menu, which will trigger the callback again
	location = self:GetTitle()
	addon:SelectGossipLine(self.continent)
end

addon:Add(function(self)
	local npcID = self:GetNPCID()
	if(npcID == 143925) then
		if(location) then
			-- we've selected the continent, let's select the actual location
			addon:SelectGossipLine(location)
			location = nil
			return
		end

		self:SetMapID(AZEROTH)

		for continent, locations in next, continents do
			for name, loc in next, locations do
				local Marker = self:NewMarker()
				Marker:SetTitle(line)
				Marker:SetScript('OnClick', OnClick) -- we need custom logic to handle sub-menus
				Marker:SetNormalAtlas('MagePortalAlliance')
				Marker:SetHighlightAtlas('MagePortalHorde')
				Marker.continent = continent

				local zoneName = self:GetMapName(loc.zone)
				if(loc.quest and not IsQuestFlaggedCompleted(loc.quest)) then
					zoneName = zoneName .. '\n\n|cffff0000' .. L['Not Discovered']
				end
				Marker:SetDescription(zoneName)

				Marker:Pin(loc.zone, loc.x, loc.y, nil, true)
			end
		end
	end
end)
