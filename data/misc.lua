local _, addon = ...

-- Sky-Captain Cableclamp (Siren Isle <-> Dornogal)
addon.data[125352] = {
	mapID = 2369, -- Siren Isle
	x = 0.5974,
	y = 0.5338,
	tooltipMap = 2369,
	displayExtra = {
		{
			mapID = 2248, -- Isle of Dorn
			x = 0.1762,
			y = 0.1890,
			tooltipMap = 2369,
		}
	}
}
addon.data[125349] = {
	-- mapID = 2339, -- Dornogal
	-- x = 0.7238,
	-- y = 0.0535,
	mapID = 2248, -- Isle of Dorn
	x = 0.5518,
	y = 0.3364,
	tooltipMap = 2339,
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
}
addon.data[125434] = {
	mapID = 2346, -- Undermine
	x = 0.1758,
	y = 0.5097,
	tooltipMap = 2346,
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
}
addon.data[125410] = addon.data[125409]

addon.data[125429] = {
	mapID = 2346, -- Undermine
	x = 0.1893,
	y = 0.5178,
	tooltipMap = 2346,
	displayExtra = {
		{
			mapID = 2274, -- Khaz Algar
			x = 0.7609,
			y = 0.7575,
			tooltipMap = 2346,
		}
	}
}
