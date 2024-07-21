local _, addon = ...

-- Stormflight (Warrior Order Hall)
addon.data[44733] = { -- Dalaran
	mapID = 627,
	x = 0.7246,
	y = 0.4594,
	tooltipMap = 627,
}
addon.data[44734] = { -- Stormheim
	mapID = 634,
	x = 0.6034,
	y = 0.5106,
	tooltipMap = 634,
}
addon.data[44735] = { -- Azsuna
	mapID = 630,
	x = 0.4749,
	y = 0.2755,
	tooltipMap = 630,
}
addon.data[44736] = { -- Val'sharah
	mapID = 641,
	x = 0.5462,
	y = 0.7313,
	tooltipMap = 641,
}
addon.data[44737] = { -- Highmountain
	mapID = 750, -- Thunder Totem
	x = 0.3853,
	y = 0.4554,
	tooltipMap = 650, -- Highmountain
}
addon.data[44738] = { -- Suramar
	mapID = 680,
	x = 0.3381,
	y = 0.4940,
	tooltipMap = 680,
}
addon.data[44739] = { -- Broken Shore
	mapID = 646,
	x = 0.4427,
	y = 0.6299,
	tooltipMap = 646,
}
addon.data[44742] = { -- Arms artifact quest
	mapID = 18, -- Tirisfal Glades, Eastern Kingdom
	x = 0.1764,
	y = 0.6752,
	isQuest = true, -- TODO: check if it has flags
	tooltipQuest = 41105, -- "The Sword of Kings"
}
addon.data[44731] = { -- Fury artifact quest
	mapID = 634, -- Stormheim
	x = 0.6259,
	y = 0.4644,
	isQuest = true, -- TODO: check if it has flags
	tooltipQuest = 40043, -- "The Hunter of Heroes"
}
addon.data[44732] = { -- campaign
	mapID = 120, -- Storm Peaks
	x = 0.4119,
	y = 0.1034,
	isQuest = true, -- TODO: check if it has flags
	tooltipQuest = 43090, -- "Ulduar's Oath"
}
addon.data[44740] = { -- campaign
	mapID = 649, -- Helheim (in Stormheim)
	x = 0.3544,
	y = 0.3067,
	isQuest = true, -- TODO: check if it has flags
	tooltipQuest = 44849, -- "Recruitment Drive"
	displayExtra = {
		{
			-- translate from Helheim to Stormheim, so we'll have to do it manually
			mapID = 634, -- Stormheim
			x = 0.7298,
			y = 0.4096,
			isQuest = true,
			tooltipQuest = 44849,
		}
	}
}
addon.data[44741] = { -- campaign
	mapID = 646, -- Broken Shore
	x = 0.6963,
	y = 0.3558,
	isQuest = true, -- TODO: check if it has flags
	tooltipQuest = 44889, -- "Resource Management"
}
