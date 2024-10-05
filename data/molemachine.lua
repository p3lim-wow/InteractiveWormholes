local _, addon = ...

-- Mole Machine
-- this one is treated a little differently; the continents reference the destinations
-- in their sub-dialogs, and when they are clicked they will stage themselves and click the
-- continent (parent) gossip option, then the zone (sub-dialogue) will be automatically selected
addon.data[49322] = { -- Eastern Kingdoms
	children = {
		49331, -- Ironforge
		49332, -- Stormwind
		49333, -- Nethergarde Keep (Blasted Lands)
		49334, -- Aerie Peak (The Hinterlands)
		49335, -- The Masonary (Black Rock Mountains)
		49336, -- Shadowforge City (Black Rock Mountains)
	}
}
addon.data[49323] = { -- Kalimdor
	children = {
		49337, -- Fire Plume Ridge (Un'Goro Crater)
		49338, -- Throne of Flame (Mount Hyjal)
		49339, -- The Great Divide (Southern Barrens)
	}
}
addon.data[49324] = { -- Outland
	children = {
		49340, -- Honor Hold (Hellfire Peninsula)
		49341, -- Fel Pits (Shadowmoon Valley)
		49342, -- Skald (Blade's Edge Mountains)
	}
}
addon.data[49325] = { -- Northrend
	children = {
		49343, -- Argent Tournament Grounds (Icecrown)
		49344, -- Ruby Dragonshrine (Dragonblight)
	}
}
addon.data[49326] = { -- Pandaria
	children = {
		49345, -- One Keg (Kun-Lai Summit)
		49346, -- Stormstout Brewery (Valley of the Four Winds)
	}
}
addon.data[49327] = { -- Draenor
	children = {
		49347, -- Blackrock Foundry Overlook (Gorgrond)
		49348, -- Elemental Plateau (Nagrand)
	}
}
addon.data[49328] = { -- Broken Isles
	children = {
		49349, -- Neltharion's Vault (Highmountain)
		49350, -- Broken Shore
	}
}
addon.data[49330] = { -- Zandalar
	children = {
		125453, -- Xibala Incursion (Zuldazar)
		125454, -- Zalamar Invasion (Nazmir)
	}
}
addon.data[49329] = { -- Kul Tiras
	children = {
		125456, -- Wailing Tideways (Tiragarde Sound)
		125455, -- Tidebreak Summit (Stormsong Valley)
	}
}
addon.data[125452] = { -- Shadowlands
	children = {
		125460, -- Valley of a Thousand Legs (Maldraxxus)
		125459, -- Scorched Crypt (Revendreth)
		125458, -- The Eternal Forge (Bastion)
		125457, -- Soryn's Meadow (Ardenweald)
	}
}
addon.data[125451] = { -- Dragon Isles
	children = {
		125463, -- The Slagmire (The Waking Shores)
		125462, -- Vakthros Summit (The Azure Span)
		125461, -- Obsidian Rest (Zaralek Caverns)
	}
}
addon.data[49331] = { -- Ironforge
	mapID = 27,
	x = 0.6129,
	y = 0.3718,
	parent = 49322,
	tooltipMap = 27,
}
addon.data[49332] = { -- Stormwind
	mapID = 84,
	x = 0.6333,
	y = 0.3734,
	parent = 49322,
	tooltipMap = 84,
}
addon.data[49333] = { -- Nethergarde Keep (Blasted Lands)
	mapID = 17,
	x = 0.6197,
	y = 0.1280,
	parent = 49322,
	tooltipMap = 17,
	requiredQuest = 53594,
}
addon.data[49334] = { -- Aerie Peak (The Hinterlands)
	mapID = 26,
	x = 0.1353,
	y = 0.4680,
	parent = 49322,
	tooltipMap = 26,
	requiredQuest = 53585,
}
addon.data[49335] = { -- The Masonary (Black Rock Mountains)
	mapID = 35,
	x = 0.3330,
	y = 0.2480,
	parent = 49322,
	tooltipMap = 35,
	requiredQuest = 53587,
}
addon.data[49336] = { -- Shadowforge City
	-- this one is instanced, so we use a approximated location instead
	mapID = 35, -- actual mapID: 1186
	x = 0.7752, -- actual x: 0.6144
	y = 0.4186, -- actual y: 0.2435
	parent = 49322,
	tooltip = addon.L['Shadowforge City'],
}
addon.data[49337] = { -- Fire Plume Ridge (Un'Goro Crater)
	mapID = 78,
	x = 0.5288,
	y = 0.5576,
	parent = 49323,
	tooltipMap = 78,
	requiredQuest = 53591,
}
addon.data[49338] = { -- Throne of Flame (Mount Hyjal)
	mapID = 198,
	x = 0.5718,
	y = 0.7711,
	parent = 49323,
	tooltipMap = 198,
	requiredQuest = 53601,
}
addon.data[49339] = { -- The Great Divide (Southern Barrens)
	mapID = 199,
	x = 0.3911,
	y = 0.0930,
	parent = 49323,
	tooltipMap = 199,
	requiredQuest = 53600,
}
addon.data[49340] = { -- Honor Hold (Hellfire Peninsula)
	mapID = 100,
	x = 0.5309,
	y = 0.6487,
	parent = 49324,
	tooltipMap = 100,
	requiredQuest = 53592,
}
addon.data[49341] = { -- Fel Pits (Shadowmoon Valley)
	mapID = 104,
	x = 0.5077,
	y = 0.3530,
	parent = 49324,
	tooltipMap = 104,
	requiredQuest = 53599,
}
addon.data[49342] = { -- Skald (Blade's Edge Mountains)
	mapID = 105,
	x = 0.7242,
	y = 0.1764,
	parent = 49324,
	tooltipMap = 105,
	requiredQuest = 53597,
}
addon.data[49343] = { -- Argent Tournament Grounds (Icecrown)
	mapID = 118,
	x = 0.7697,
	y = 0.1866,
	parent = 49325,
	tooltipMap = 118,
	requiredQuest = 53586,
}
addon.data[49344] = { -- Ruby Dragonshrine (Dragonblight)
	mapID = 115,
	x = 0.4535,
	y = 0.4992,
	parent = 49325,
	tooltipMap = 115,
	requiredQuest = 53596,
}
addon.data[49345] = { -- One Keg (Kun-Lai Summit)
	mapID = 379,
	x = 0.5768,
	y = 0.6281,
	parent = 49326,
	tooltipMap = 379,
	requiredQuest = 53595,
}
addon.data[49346] = { -- Stormstout Brewery (Valley of the Four Winds)
	mapID = 376,
	x = 0.3151,
	y = 0.7359,
	parent = 49326,
	tooltipMap = 376,
	requiredQuest = 53598,
}
addon.data[49347] = { -- Blackrock Foundry Overlook (Gorgrond)
	mapID = 543,
	x = 0.4669,
	y = 0.3876,
	parent = 49327,
	tooltipMap = 543,
	requiredQuest = 53588,
}
addon.data[49348] = { -- Elemental Plateau (Nagrand)
	mapID = 550,
	x = 0.6575,
	y = 0.0825,
	parent = 49327,
	tooltipMap = 550,
	requiredQuest = 53590,
}
addon.data[49349] = { -- Neltharion's Vault (Highmountain)
	mapID = 650,
	x = 0.4466,
	y = 0.7290,
	parent = 49328,
	tooltipMap = 650,
	requiredQuest = 53593,
}
addon.data[49350] = { -- Broken Shore
	mapID = 646,
	x = 0.7169,
	y = 0.4799,
	parent = 49328,
	tooltipMap = 646,
	requiredQuest = 53589,
}
addon.data[125454] = { -- Zalamar Invasion (Nazmir)
	mapID = 863,
	x = 0.3434,
	y = 0.4515,
	parent = 49330,
	tooltipMap = 863,
	requiredQuest = 80099,
}
addon.data[125453] = { -- Xibala Incursion (Zuldazar)
	mapID = 862,
	x = 0.3824,
	y = 0.7238,
	parent = 49330,
	tooltipMap = 862,
	requiredQuest = 80100,
}
addon.data[125456] = { -- Wailing Tideways (Tiragarde Sound)
	mapID = 895,
	x = 0.8822,
	y = 0.7153,
	parent = 49329,
	tooltipMap = 895,
	requiredQuest = 80101,
}
addon.data[125455] = { -- Tidebreak Summit (Stormsong Valley)
	mapID = 942,
	x = 0.6421,
	y = 0.2944,
	parent = 49329,
	tooltipMap = 942,
	requiredQuest = 80102,
}

addon.data[125460] = { -- Valley of a Thousand Legs (Maldraxxus)
	mapID = 1536,
	x = 0.5349,
	y = 0.5979,
	parent = 125452,
	tooltipMap = 1536,
	requiredQuest = 80103,
}
addon.data[125459] = { -- Scorched Crypt (Revendreth)
	mapID = 1525,
	x = 0.1993,
	y = 0.3878,
	parent = 125452,
	tooltipMap = 1525,
	requiredQuest = 80104,
}
addon.data[125458] = { -- The Eternal Forge (Bastion)
	mapID = 1533,
	x = 0.5175,
	y = 0.1314,
	parent = 125452,
	tooltipMap = 1533,
	requiredQuest = 80105,
}
addon.data[125457] = { -- Soryn's Meadow (Ardenweald)
	mapID = 1565,
	x = 0.6647,
	y = 0.5055,
	parent = 125452,
	tooltipMap = 1565,
	requiredQuest = 80106,
}
addon.data[125463] = { -- The Slagmire (The Waking Shores)
	mapID = 2022,
	x = 0.3236,
	y = 0.5490,
	parent = 125451,
	tooltipMap = 2022,
	requiredQuest = 80107,
}
addon.data[125462] = { -- Vakthros Summit (The Azure Span)
	mapID = 2024,
	x = 0.8009,
	y = 0.3896,
	parent = 125451,
	tooltipMap = 2024,
	requiredQuest = 80108,
}
addon.data[125461] = { -- Obsidian Rest (Zaralek Caverns)
	mapID = 2133,
	x = 0.5273,
	y = 0.2767,
	tooltipMap = 2133,
	parent = 125451,
	requiredQuest = 80109,
	displayExtra = {
		{
			-- HBD doesn't translate from ZC to Dragon Isles, so we'll have to do it manually
			mapID = 1978, -- Dragon Isles
			x = 0.8796,
			y = 0.7802,
			tooltipMap = 2133,
		}
	}
}
