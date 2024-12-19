local _, addon = ...

-- Sky-Captain Cableclamp (Siren Isle <-> Dornogal)
addon.data[125352] = {
	mapID = 2369, -- Siren Isle
	x = 0.5974,
	y = 0.5338,
	tooltipMap = 2369,
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
