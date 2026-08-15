local _, addon = ...

-- Amani Windcaller @ Vaults of Atal'Utek
addon.data[141707] = { -- Amani Foothold -> Eastern Amani Outpost
	mapID = 2509, -- Vaults of Atal'Utek
	x = 0.5432,
	y = 0.3926,
	tooltipArea = 17730, -- Eastern Amani Outpost
	isTaxi = true,
}
addon.data[141706] = { -- Amani Foothold -> Venomous Abyss
	mapID = 2509, -- Vaults of Atal'Utek
	x = 0.4849,
	y = 0.2700,
	tooltipArea = 16915, -- The Venomous Abyss
	isTaxi = true,
}
addon.data[141705] = { -- Amani Foothold -> Northern Amani Bulwark
	mapID = 2509, -- Vaults of Atal'Utek
	x = 0.4159,
	y = 0.2339,
	tooltipArea = 17729, -- Northern Amani Bulwark
	isTaxi = true,
}
addon.data[141704] = { -- Amani Foothold -> Underbelly
	mapID = 2509, -- Vaults of Atal'Utek
	x = 0.4561,
	y = 0.1166,
	tooltipArea = 16990, -- The Underbelly
	isTaxi = true,
}
addon.data[141712] = { -- Eastern Amani Outpost -> Amani Foothold
	mapID = 2509, -- Vaults of Atal'Utek
	x = 0.4992,
	y = 0.6187,
	tooltipArea = 17650, -- Amani Foothold
	isTaxi = true,
}
addon.data[141703] = { -- stealth option @ Amani Foothold
	mapID = 2509, -- Vaults of Atal'Utek
	x = 0.2000,
	y = 0.6500,
	atlas = 'BfAMission-Icon-Stealth',
	atlasWidth = 80,
	atlasHeight = 80,
	highlightAdd = true,
	noArrow = true,
}

-- the gossip options are not re-used
addon.data[141711] = addon.data[141706] -- Eastern Amani Outpost -> Venomous Abyss
addon.data[141710] = addon.data[141705] -- Eastern Amani Outpost -> Northern Amani Bulwark
addon.data[141709] = addon.data[141704] -- Eastern Amani Outpost -> Underbelly
addon.data[141722] = addon.data[141712] -- Northern Amani Bulwark -> Amani Foothold
addon.data[141721] = addon.data[141707] -- Northern Amani Bulwark -> Eastern Amani Outpost
addon.data[141720] = addon.data[141706] -- Northern Amani Bulwark -> Venomous Abyss
addon.data[141719] = addon.data[141704] -- Northern Amani Bulwark -> Underbelly
addon.data[141717] = addon.data[141712] -- Venomous Abyss -> Amani Foothold
addon.data[141716] = addon.data[141707] -- Venomous Abyss -> Eastern Amani Outpost
addon.data[141715] = addon.data[141705] -- Venomous Abyss -> Northern Amani Bulwark
addon.data[141714] = addon.data[141704] -- Venomous Abyss -> Underbelly
addon.data[141727] = addon.data[141712] -- Underbelly -> Amani Foothold
addon.data[141726] = addon.data[141707] -- Underbelly -> Eastern Amani Outpost
addon.data[141725] = addon.data[141706] -- Underbelly -> Venomous Abyss
addon.data[141724] = addon.data[141705] -- Underbelly -> Northern Amani Bulwark
addon.data[141708] = addon.data[141703] -- stealth option @ Eastern Amani Outpost
addon.data[141718] = addon.data[141703] -- stealth option @ Northern Amani Bulwark
addon.data[141713] = addon.data[141703] -- stealth option @ Venomous Abyss
addon.data[141723] = addon.data[141703] -- stealth option @ Underbelly

-- special destination handling during the quest "Into the Vaults of Atal'Utek",
-- which have their own unique gossip IDs
addon.data[141753] = CreateFromMixins(addon.data[141707], {
	-- Amani Foothold -> Eastern Amani Outpost
	isQuest = true,
})
addon.data[141737] = CreateFromMixins(addon.data[141705], {
	-- Eastern Amani Outpost -> Northern Amani Bulwark
	isQuest = true,
})
addon.data[141760] = CreateFromMixins(addon.data[141712], {
	-- Northern Amani Bulwark -> Amani Foothold
	isQuest = true,
})
addon.data[141935] = CreateFromMixins(addon.data[141703], {
	-- stealth option @ Eastern Amani Outpost
	isQuest = true,
	noArrow = false,
	size = 50,
})
