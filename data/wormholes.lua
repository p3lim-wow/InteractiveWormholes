local _, addon = ...

-- Wormhole Generator: Northrend
addon.data[38054] = { -- Borean Tundra
	mapID = 114,
	x = 0.5178,
	y = 0.4503,
}
addon.data[38055] = { -- Howling Fjord
	mapID = 117,
	x = 0.5853,
	y = 0.4863,
}
addon.data[38056] = { -- Sholozar Basin
	mapID = 119,
	x = 0.4921,
	y = 0.3962,
}
addon.data[38057] = { -- Icecrown
	mapID = 118,
	x = 0.6287,
	y = 0.2692,
}
addon.data[38058] = { -- Storm Peaks
	mapID = 120,
	x = 0.4390,
	y = 0.2580,
}
addon.data[38059] = { -- Underground...
	mapID = 125, -- Dalaran, Crystalsong Forest
	x = 0.4786,
	y = 0.3239,
	atlas = 'VignetteLootElite',
	highlightAdd = true,
}

-- Reaves (with Wormhole Generator module)
addon.data[46325] = { -- Azsuna
	mapID = 630,
	x = 0.47,
	y = 0.49,
}
addon.data[46326] = { -- Val'sharah
	mapID = 641,
	x = 0.56,
	y = 0.66,
}
addon.data[46327] = { -- Highmountain
	mapID = 650,
	x = 0.45,
	y = 0.56,
}
addon.data[46328] = { -- Stormheim
	mapID = 634,
	x = 0.53,
	y = 0.53,
}
addon.data[46329] = { -- Suramar
	mapID = 680,
	x = 0.42,
	y = 0.67,
}

-- Wormhole Centrifuge (Draenor)
addon.data[42586] = { -- "A jagged landscape"
	mapID = 542, -- Spires of Arak, Draenor
	x = 0.52,
	y = 0.33,
	tooltipMap = 542,
}
addon.data[42587] = { -- "A reddish-orange forest"
	mapID = 535, -- Talador, Draenor
	x = 0.58,
	y = 0.65,
	tooltipMap = 535,
}
addon.data[42588] = { -- "Shadows..."
	mapID = 539, -- Shadowmoon Valley, Draenor
	x = 0.49,
	y = 0.52,
	tooltipMap = 539,
}
addon.data[42589] = { -- "Grassy plains"
	mapID = 552, -- Nagrand, Draenor
	x = 0.73,
	y = 0.54,
	tooltipMap = 552,
}
addon.data[42590] = { -- "Primal forest"
	mapID = 543, -- Gorgrond, Draenor
	x = 0.53,
	y = 0.61,
	tooltipMap = 543,
}
addon.data[42591] = { -- "Lava and snow"
	mapID = 525, -- Frostfire Ridge, Draenor
	x = 0.59,
	y = 0.49,
	tooltipMap = 525,
}

-- Wormhole Generator: Shadowlands
addon.data[51934] = { -- Oribos, The Eternal City
	mapID = 1670,
	x = 0.5208,
	y = 0.2613,
	tooltipMap = 1670,
}
addon.data[51935] = { -- Bastion, Home of the Kyrian
	mapID = 1533,
	x = 0.5185,
	y = 0.8776,
	tooltipMap = 1533,
}
addon.data[51936] = { -- Maldraxxus, Citadel of the Necrolords
	mapID = 1536,
	x = 0.4244,
	y = 0.4399,
	tooltipMap = 1536,
}
addon.data[51937] = { -- Ardenweald, Forest of the Night Fae
	mapID = 1565,
	x = 0.5442,
	y = 0.6032,
	tooltipMap = 1565,
}
addon.data[51938] = { -- Revendreth, Court of the Venthyr
	mapID = 1525,
	x = 0.3750,
	y = 0.7655,
	tooltipMap = 1525,
}
addon.data[51939] = { -- The Maw, Wasteland of the Damned
	mapID = 1543,
	x = 0.2245,
	y = 0.2815,
	tooltipMap = 1543,
}
addon.data[51941] = { -- Korthia, City of Secrets
	mapID = 1961,
	x = 0.6240,
	y = 0.2458,
	tooltipMap = 1961,
}
addon.data[51942] = { -- Zereth Mortis, Enlightened Haven
	mapID = 1970,
	x = 0.4552,
	y = 0.5528,
	tooltipMap = 1970,
	displayExtra = {
		{
			-- HBD doesn't translate from ZM to Shadowlands, so we'll have to do it manually
			mapID = 1550, -- Shadowlands
			x = 0.8565,
			y = 0.8016,
			tooltipMap = 1970,
		}
	}
}

-- Wyrmhole Generator
addon.data[63907] = { -- "Carelessly leap into the portal, you daredevil"
	mapID = 1978,
	x = 0.25,
	y = 0.25,
	-- tooltipMap = 1978,
	atlas = 'lootroll-toast-icon-need-up',
	highlightAtlas = 'lootroll-toast-icon-need-highlight',
}
addon.data[63911] = { -- Waking Shores (random location)
	mapID = 2022,
	x = 0.56,
	y = 0.50,
	tooltipMap = 2022,
}
addon.data[63910] = { -- Ohn'ahran Plains (random location)
	mapID = 2023,
	x = 0.56,
	y = 0.52,
	tooltipMap = 2023,
}
addon.data[63909] = { -- Azure Span (random location)
	mapID = 2024,
	x = 0.58,
	y = 0.38,
	tooltipMap = 2024,
}
addon.data[63908] = { -- Thaldraszus (random location)
	mapID = 2025,
	x = 0.49,
	y = 0.61,
	tooltipMap = 2025,
}
addon.data[108016] = { -- Forbidden Reach (random location)
	mapID = 2151,
	x = 0.51,
	y = 0.47,
	tooltipMap = 2151,
}
addon.data[109715] = { -- Zaralek Cavern (random location)
	mapID = 2133,
	x = 0.46,
	y = 0.51,
	tooltipMap = 2133,
	displayExtra = {
		{
			-- translate from ZC to Dragon Isles, so we'll have to do it manually
			mapID = 1978, -- Dragon Isles
			x = 0.8697,
			y = 0.8124,
			tooltipMap = 2133,
		}
	}
}
addon.data[114080] = { -- Emerald Dream (random location)
	mapID = 2200,
	x = 0.51,
	y = 0.43,
	tooltipMap = 2200,
	displayExtra = {
		{
			-- translate from ED to Dragon Isles, so we'll have to do it manually (ish)
			mapID = 1978, -- Dragon Isles
			x = 0.24,
			y = 0.57,
			tooltipMap = 2200,
		}
	}
}

-- Wormhole Generator: Khaz Algar
addon.data[122358] = { -- Azj-Kahet
	mapID = 2255,
	x = 0.5074,
	y = 0.5387,
	tooltipMap = 2255,
}
addon.data[122359] = { -- Hallowfall
	mapID = 2215,
	x = 0.5636,
	y = 0.4770,
	tooltipMap = 2215,
}
addon.data[122360] = { -- Ringing Deeps
	mapID = 2214,
	x = 0.5010,
	y = 0.4491,
	tooltipMap = 2214,
}
addon.data[122361] = { -- Isle of Dorn
	mapID = 2248,
	x = 0.5170,
	y = 0.5470,
	tooltipMap = 2248,
}
addon.data[122362] = { -- "Carelessly leap into the portal, you daredevil"
	mapID = 2274, -- Khaz Algar
	x = 0.7465,
	y = 0.4993,
	atlas = 'lootroll-toast-icon-need-up',
	highlightAtlas = 'lootroll-toast-icon-need-highlight',
}
