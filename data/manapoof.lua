local _, addon = ...

-- Manapoof (Pet Battle Dungeon teleport)
addon.data[47007] = {
	mapID = 11, -- Wailing Caverns
	x = 0.2288,
	y = 0.8242,
	tooltipMap = 11, -- Wailing Caverns
}
addon.data[47008] = { -- Deadmines
	-- this one is offset so it doesn't collide with the dungeon pin
	mapID = 52, -- Westfall
	x = 0.4050, -- actual x: 0.4142
	y = 0.6850, -- actual y: 0.7121
	tooltipMap = 291, -- Deadmines
}
addon.data[47009] = {
	mapID = 30, -- New Tinkertown
	x = 0.3193,
	y = 0.7169,
	tooltipMap = 226, -- Gnomeregan
}
addon.data[47010] = { -- Stratholme (back entrance)
	mapID = 23, -- Eastern Plaguelands
	x = 0.4323,
	y = 0.1996,
	tooltipMap = 317, -- Stratholme
}
addon.data[47011] = { -- Blackrock Depths
	mapID = 35, -- Blackrock Mountain
	x = 0.3352,
	y = 0.2389,
	tooltipMap = 242, -- Blackrock Depths
}
