local _, addon = ...

-- Sky-Captain Cableclamp (Siren Isle <-> Dornogal)
addon.data[125352] = {
	mapID = 2369, -- Siren Isle
	x = 0.5974,
	y = 0.5338,
	tooltipMap = 2369,
	forceMapID = 2248, -- Isle of Dorn
	displayExtra = {
		{
			-- translate from Isle of Dorn to Siren Isle
			mapID = 2248, -- Isle of Dorn
			x = 0.1762,
			y = 0.1890,
			tooltipMap = 2369,
		}
	}
}
addon.data[125349] = {
	mapID = 2339, -- Dornogal
	x = 0.7238,
	y = 0.0535,
	tooltipMap = 2339,
	-- the position of the destination in Dornogal is hard to notice, so let's zoom out
	forceMapID = 2248, -- Isle of Dorn
}
addon.ignoreOption[131547] = true
addon.ignoreOption[131550] = true

-- Mole Machine Transport (Siren Isle <-> Ringing Deeps)
addon.data[125350] = {
	mapID = 2214, -- The Ringing Deeps
	x = 0.4622,
	y = 0.3031,
	tooltipMap = 2214,
}
addon.data[125351] = {
	mapID = 2369, -- Siren Isle
	x = 0.6782,
	y = 0.3929,
	tooltipMap = 2369,
}

-- Father Winter's Helper (during Feast of Winter Veil)
addon.data[131324] = { -- alliance version
	mapID = 25, -- Hillsbrad Foothills
	x = 0.4584,
	y = 0.4300,
	tooltipMap = 25,
}
addon.data[131325] = addon.data[131324] -- horde version

-- Undermine <-> The Ringing Deeps
addon.data[125433] = {
	mapID = 2214, -- The Ringing Deeps
	x = 0.7277,
	y = 0.7324,
	tooltipMap = 2214,
	skippableCinematic = true,
}
addon.data[125434] = {
	mapID = 2346, -- Undermine
	x = 0.1758,
	y = 0.5097,
	tooltipMap = 2346,
	skippableCinematic = true,
	displayExtra = {
		{
			mapID = 2274, -- Khaz Algar
			x = 0.7609,
			y = 0.7575,
			tooltipMap = 2346,
		}
	}
}

-- Undermine <-> Zuldazar
addon.data[125409] = {
	mapID = 862, -- Zuldazar
	x = 0.2248,
	y = 0.5416,
	tooltipMap = 862, -- TODO: change for "Kaja'Coast" area name
	skippableCinematic = true,
}
addon.data[125410] = addon.data[125409]

addon.data[125429] = {
	mapID = 2346, -- Undermine
	x = 0.1893,
	y = 0.5178,
	tooltipMap = 2346,
	skippableCinematic = true,
	displayExtra = {
		{
			mapID = 2274, -- Khaz Algar
			x = 0.7609,
			y = 0.7575,
			tooltipMap = 2346,
		}
	}
}

-- Dazar'alor <-> Mechagon for Horde
addon.data[50479] = {
	mapID = 1462, -- Mechagon
	x = 0.7573,
	y = 0.2132,
	tooltipMap = 1462,
}
addon.data[50481] = {
	mapID = 1165, -- Dazar'alor
	x = 0.4175,
	y = 0.8743,
	tooltipMap = 1165,
}

-- Voidstorm Teleport Pad
addon.data[136703] = { -- The Approach
	mapID = 2529, -- The Voidspire
	x = 0.2840,
	y = 0.8454,
	tooltipArea = 16829,
	atlas = 'FlightMaster_Argus-Taxi_Frame_Gray',
	atlasWidth = 40,
	atlasHeight = 35,
	highlightAtlas = 'FlightMaster_Argus-Taxi_Frame_Yellow',
	forceMapID = 2529,
}
addon.data[136702] = { -- Devouring Stronghold
	mapID = 2529, -- The Voidspire
	x = 0.4269,
	y = 0.6375,
	tooltipArea = 16825,
	atlas = 'FlightMaster_Argus-Taxi_Frame_Gray',
	atlasWidth = 40,
	atlasHeight = 35,
	highlightAtlas = 'FlightMaster_Argus-Taxi_Frame_Yellow',
	forceMapID = 2529,
}
addon.data[136701] = { -- Base of the Voidspire
	mapID = 2529, -- The Voidspire
	x = 0.5781,
	y = 0.4216,
	tooltipArea = 16340,
	atlas = 'FlightMaster_Argus-Taxi_Frame_Gray',
	atlasWidth = 40,
	atlasHeight = 35,
	highlightAtlas = 'FlightMaster_Argus-Taxi_Frame_Yellow',
	forceMapID = 2529,
}
addon.data[136706] = { -- Lightblinded Vanguard
	mapID = 2529, -- The Voidspire
	x = 0.7330,
	y = 0.2075,
	tooltipEncounter = 2737,
	atlas = 'FlightMaster_Argus-Taxi_Frame_Gray',
	atlasWidth = 40,
	atlasHeight = 35,
	highlightAtlas = 'FlightMaster_Argus-Taxi_Frame_Yellow',
	forceMapID = 2529,
}
addon.data[136705] = { -- Crown of the Cosmos
	mapID = 2530,
	x = 0.2649,
	y = 0.6497,
	tooltipArea = 16828,
	atlas = 'FlightMaster_Argus-Taxi_Frame_Gray',
	atlasWidth = 40,
	atlasHeight = 35,
	highlightAtlas = 'FlightMaster_Argus-Taxi_Frame_Yellow',
	forceMapID = 2529,
	displayExtra = {
		{
			mapID = 2529, -- The Voidspire
			x = 0.6692,
			y = 0.2972,
			atlas = 'FlightMaster_Argus-Taxi_Frame_Gray',
			atlasWidth = 40,
			atlasHeight = 35,
			highlightAtlas = 'FlightMaster_Argus-Taxi_Frame_Yellow',
		}
	}
}

-- Naigtal Lightforged Beacon
addon.data[140132] = { -- Teleport to Silvermoon.
	mapID = 2393, -- Silvermoon City
	x = 0.4793,
	y = 0.4808,
	tooltipMap = 2393,
}
addon.data[140133] = { -- Teleport to the Voidstorm.
	mapID = 2405, -- Voidstorm
	x = 0.5155,
	y = 0.7107,
	tooltipMap = 2405,
	displayExtra = {
		{
			mapID = 2537, -- Quel'Thalas
			x = 0.5385,
			y = 0.2582,
		}
	},
}

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
	noArrow = true,
}
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
addon.data[141753] = CreateFromMixins(addon.data[141707], {
	-- Amani Foothold -> Eastern Amani Outpost during the quest "Into the Vaults of Atal'Utek"
	isQuest = true,
})
addon.data[141737] = CreateFromMixins(addon.data[141705], {
	-- Eastern Amani Outpost -> Northern Amani Bulwark during the quest "Into the Vaults of Atal'Utek"
	isQuest = true,
})
addon.data[141760] = CreateFromMixins(addon.data[141712], {
	-- Northern Amani Bulwark -> Amani Foothold during the quest "Into the Vaults of Atal'Utek"
	isQuest = true,
})
addon.data[141935] = CreateFromMixins(addon.data[141703], {
	-- stealth option @ Eastern Amani Outpost during the quest "Into the Vaults of Atal'Utek"
	isQuest = true,
})

-- special node used to add source pins for taxi destinations
addon.data[0] = {
	atlas = 'Taxi_Frame_Green',
	atlasSize = 28,
	tooltip = _G.TAXINODEYOUAREHERE, -- "You are here"
	noArrow = true,
	isTaxiSource = true,
}
