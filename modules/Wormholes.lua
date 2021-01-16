local addon = select(2, ...)
local L = addon.L

local npcData = {
	[35646] = { -- Wormhole Generator: Northrend
		{zone = 114, x = 0.5178, y = 0.4503}, -- Borean Tundra
		{zone = 117, x = 0.5853, y = 0.4863}, -- Howling Fjord
		{zone = 119, x = 0.4921, y = 0.3962}, -- Sholozar Basin
		{zone = 118, x = 0.6287, y = 0.2692}, -- Icecrown
		{zone = 120, x = 0.4390, y = 0.2580}, -- Storm Peaks
		{ -- Underground... (Dalaran, Crystalsong Forest)
			zone = 127, x = 0.3404, y = 0.3549,
			name = (GetSpellInfo(68081)),
			atlas = 'VignetteLootElite',
		},
		mapID = 113, -- Northrend
	},
	[81205] = { -- Wormhole Centrifuge
		{zone = 542, x = 0.52, y = 0.33}, -- "A jagged landscape" (Spires of Arak)
		{zone = 535, x = 0.58, y = 0.65}, -- "A reddish-orange forest" (Talador)
		{zone = 539, x = 0.49, y = 0.52}, -- "Shadows..." (Shadowmoon Valley)
		{zone = 552, x = 0.73, y = 0.54}, -- "Grassy plains" (Nagrand)
		{zone = 543, x = 0.53, y = 0.61}, -- "Primal forest" (Gorgrond)
		{zone = 525, x = 0.59, y = 0.49}, -- "Lava and snow" (Frostfire Ridge)
		inaccurate = true,
		mapID = 572, -- Draenor
	},
	[101462] = { -- Reaves (with Wormhole Generator module)
		{zone = 630, x = 0.47, y = 0.49}, -- Azsuna
		{zone = 641, x = 0.56, y = 0.66}, -- Val'sharah
		{zone = 650, x = 0.45, y = 0.56}, -- Highmountain
		{zone = 634, x = 0.53, y = 0.53}, -- Stormheim
		{zone = 680, x = 0.42, y = 0.67}, -- Suramar
		inaccurate = true,
		mapID = 619, -- Broken Isles
	},
	[169501] = { -- Wormhole Generator: Shadowlands
		{zone = 1670, x = 0.5208, y = 0.2613}, -- "Oribos, The Eternal City"
		{zone = 1533, x = 0.5185, y = 0.8776}, -- "Bastion, Home of the Kyrian"
		{zone = 1536, x = 0.4244, y = 0.4399}, -- "Maldraxxus, Citadel of the Necrolords"
		{zone = 1565, x = 0.5442, y = 0.6032}, -- "Ardenweald, Forest of the Night Fae"
		{zone = 1525, x = 0.3750, y = 0.7655}, -- "Revendreth, Court of the Venthyr"
		{zone = 1543, x = 0.2245, y = 0.2815}, -- "The Maw, Wasteland of the Damned"
		mapID = 1550, -- Shadowlands
	},
}

local page = 0
addon:Add(function(self)
	local npcID = self:GetNPCID()

	if(npcID == 101462) then
		-- Reaves needs special handling, since the destinations are under a sub-dialogue
		page = page + 1
		if(page < 2) then
			return
		end
	end

	local data = npcData[npcID]
	if(data) then
		local mapID = C_Map.GetBestMapForUnit('player')
		local mapInfo = C_Map.GetMapInfo(mapID)
		if not MapUtil.IsChildMap(mapID, data.mapID) or mapInfo.mapType > Enum.UIMapType.Zone then
			-- only set the zone to the continent if we're not within a subzone of it
			mapID = data.mapID
		end

		self:SetMapID(mapID)

		for index in next, self:GetLines() do
			local loc = data[index]

			local Marker = self:NewMarker()
			Marker:SetID(index)
			Marker:SetTitle(loc.name or self:GetMapName(loc.zone))
			Marker:SetNormalAtlas(loc.atlas or 'MagePortalAlliance')
			Marker:SetHighlightAtlas(loc.atlas or 'MagePortalHorde')

			if(data.inaccurate) then
				Marker:SetDescription('\n|cffff0000' .. L['You will end up in one of multiple locations within this zone!'])
			end

			Marker:Pin(loc.zone, loc.x, loc.y, true)
		end

		return true
	end
end)

local Handler = CreateFrame('Frame')
Handler:RegisterEvent('GOSSIP_CLOSED')
Handler:SetScript('OnEvent', function()
	-- reset the Reaves page logic
	page = 0
end)
