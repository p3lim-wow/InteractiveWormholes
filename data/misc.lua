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

-- special node used to add source pins for taxi destinations
addon.data[0] = {
	atlas = 'Taxi_Frame_Green',
	atlasSize = 28,
	tooltip = _G.TAXINODEYOUAREHERE, -- "You are here"
	noArrow = true,
	isTaxiSource = true,
}
