local addon = select(2, ...)
local L = addon.L

local continents = {
	{
		name = L['Eastern Kingdoms'],
		locations = {
			{zone=27,  x=0.6129, y=0.3718,              name = L['Ironforge']},
			{zone=84,  x=0.6333, y=0.3734,              name = L['Stormwind']},
			{zone=17,  x=0.6197, y=0.1280, quest=53594, name = L['Nethergarde Keep']}, -- Blasted Lands
			{zone=26,  x=0.1353, y=0.4680, quest=53585, name = L['Aerie Peak']}, -- The Hinterlands
			{zone=35,  x=0.3330, y=0.2480, quest=53587, name = L['The Masonary']}, -- Black Rock Mountains
			{zone=35,  x=0.5093, y=0.1607,              name = L['Shadowforge City']},
--			{zone=1186, x=0.6144, y=0.2435,             name = L['Shadowforge City']}, -- actual location
		}
	},
	{
		name = L['Kalimdor'],
		locations = {
			{zone=78,  x=0.5288, y=0.5576, quest=53591, name = L['Fire Plume Ridge']}, -- Un'Goro Crater
			{zone=198, x=0.5718, y=0.7711, quest=53601, name = L['Throne of Flame']}, -- Mount Hyjal
			{zone=199, x=0.3911, y=0.0930, quest=53600, name = L['The Great Divide']}, -- Southern Barrens
		}
	},
	{
		name = L['Outland'],
		locations = {
			{zone=100, x=0.5309, y=0.6487, quest=53592, name = L['Honor Hold']},
			{zone=104, x=0.5077, y=0.3530, quest=53599, name = L['Fel Pits']}, -- Shadowmoon Valley
			{zone=105, x=0.7242, y=0.1764, quest=53597, name = L['Skald']}, -- Blade's Edge Mountains
		}
	},
	{
		name = L['Northrend'],
		locations = {
			{zone=118, x=0.7697, y=0.1866, quest=53586, name = L['Argent Tournament Grounds']}, -- Icecrown
			{zone=115, x=0.4535, y=0.4992, quest=53596, name = L['Ruby Dragonshrine']}, -- Dragonblight
		}
	},
	{
		name = L['Pandaria'],
		locations = {
			{zone=379, x=0.5768, y=0.6281, quest=53595, name = L['One Keg']}, -- Kun-Lai Summit
			{zone=376, x=0.3151, y=0.7359, quest=53598, name = L['Stormstout Brewery']}, -- Valley of the Four Winds
		}
	},
	{
		name = L['Draenor'],
		locations = {
			{zone=543, x=0.4669, y=0.3876, quest=53588, name = L['Blackrock Foundry Overlook']}, -- Gorgrond
			{zone=550, x=0.6575, y=0.0825, quest=53590, name = L['Elemental Plateau']}, -- Nagrand
		}
	},
	{
		name = L['Broken Isles'],
		locations = {
			{zone=650, x=0.4466, y=0.7290, quest=53593, name = L['Neltharion\'s Vault']}, -- Highmountain
			{zone=646, x=0.7169, y=0.4799, quest=53589, name = L['Broken Shore']},
		}
	},
}

local selectedLocationIndex
local function onClick(self)
	if self:IsEnabled() then
		-- we're clicking a location to go there, store the location index for later, since this
		-- is stored on the marker itself
		selectedLocationIndex = self.locationIndex

		-- when we click, we'll select the gossip option based on the continent index of the marker,
		-- which will trigger GOSSIP_SHOW again, where we'll select the actual location gossip
		addon:SelectGossipIndex(self.continentIndex)
	end
end

local function showCondition(self, npcID)
	return npcID == 143925 -- Dark Iron Mole Machine
end

addon:Add(showCondition, function(self)
	if selectedLocationIndex then
		-- the location has been clicked, and by this point, the continent gossip option has
		-- been clicked, we'll need to finish the interaction by clicking the location within
		addon:SelectGossipIndex(selectedLocationIndex)

		-- we'll also need to reset everything so we get the map again next time
		selectedLocationIndex = nil

		-- and don't continue with the map logic
		return
	end

	self:SetMapID(947) -- Azeroth

	local continentIndex = 1
	for _, continent in next, continents do
		local locationIndex = 0
		for _, location in next, continent.locations do
			local Marker = self:NewMarker()
			Marker:SetTitle(location.name)
			Marker:SetScript('OnClick', onClick)
			Marker:SetNormalAtlas('MagePortalAlliance')
			Marker:SetHighlightAtlas('MagePortalHorde')

			local zoneName = self:GetMapName(location.zone)
			if(location.quest and not C_QuestLog.IsQuestFlaggedCompleted(location.quest)) then
				zoneName = zoneName .. '\n\n|cffff0000' .. L['Not Discovered']

				Marker:DisableArrow()
				Marker:Disable()
			else
				-- this location is known, increment the known locations for this continent
				locationIndex = locationIndex + 1
			end

			-- store the continent and location indices on the marker for the click operations
			Marker.continentIndex = continentIndex
			Marker.locationIndex = locationIndex

			Marker:SetDescription(zoneName)
			Marker:Pin(location.zone, location.x, location.y, nil, true)
		end

		if locationIndex > 0 then
			-- this continent had known locations, increment the continent index for the next set
			continentIndex = continentIndex + 1
		end
	end
end)
