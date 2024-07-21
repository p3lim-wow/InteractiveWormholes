local _, addon = ...

-- Warfront Footholds (Horde)
addon.data[48348] = { -- Drustvar
	mapID = 896,
	x = 0.2061,
	y = 0.4569,
	atlas = 'bfa-landingbutton-horde-up',
	atlasSize = 40,
	highlightAtlas = 'bfa-landingbutton-horde-diamondhighlight',
	highlightAdd = true,
}
addon.data[48349] = { -- Stormsong Valley
	mapID = 942,
	x = 0.5198,
	y = 0.2449,
	atlas = 'bfa-landingbutton-horde-up',
	atlasSize = 40,
	highlightAtlas = 'bfa-landingbutton-horde-diamondhighlight',
	highlightAdd = true,
}
addon.data[48350] = { -- Tiragarde Sound
	mapID = 895,
	x = 0.8820,
	y = 0.5116,
	atlas = 'bfa-landingbutton-horde-up',
	atlasSize = 40,
	highlightAtlas = 'bfa-landingbutton-horde-diamondhighlight',
	highlightAdd = true,
}
addon.data[48352] = { -- Darkshore (campaign)
	mapID = 62, -- Darkshore (it's really a phased version with mapID 1333)
	x = 0.4751, -- actually 0.5452
	y = 0.1973, -- actually 0.2081
	atlas = 'quest-campaign-available',
	atlasSize = 32,
	highlightAtlas = 'quest-campaign-available',
	highlightAdd = true,
	tooltipMap = 62,
}
-- TODO: horde foothold campaign quests

-- Warfront Footholds (Alliance)
addon.data[48171] = { -- Zuldazar
	mapID = 862,
	x = 0.4068,
	y = 0.7085,
	atlas = 'bfa-landingbutton-alliance-up',
	atlasSize = 40,
	highlightAtlas = 'bfa-landingbutton-alliance-shieldhighlight',
	highlightAdd = true,
	tooltipMap = 862,
}
addon.data[48170] = { -- Nazmir
	mapID = 863,
	x = 0.6196,
	y = 0.4020,
	atlas = 'bfa-landingbutton-alliance-up',
	atlasSize = 40,
	highlightAtlas = 'bfa-landingbutton-alliance-shieldhighlight',
	highlightAdd = true,
	tooltipMap = 863,
}
addon.data[48169] = { -- Vol'dun
	mapID = 864,
	x = 0.3560,
	y = 0.3317,
	atlas = 'bfa-landingbutton-alliance-up',
	atlasSize = 40,
	highlightAtlas = 'bfa-landingbutton-alliance-shieldhighlight',
	highlightAdd = true,
	tooltipMap = 864,
}
addon.data[48168] = { -- Zuldazar foothold campaign quest
	mapID = 862,
	x = 0.8022,
	y = 0.5523,
	atlas = 'quest-campaign-available',
	atlasSize = 32,
	highlightAtlas = 'quest-campaign-available',
	highlightAdd = true,
	tooltipQuest = 51308, -- "Zuldazar Foothold"
}
addon.data[48164] = { -- Nazmir foothold campaign quest
	mapID = 863,
	x = 0.5372,
	y = 0.3421,
	atlas = 'quest-campaign-available',
	atlasSize = 32,
	highlightAtlas = 'quest-campaign-available',
	highlightAdd = true,
	tooltipQuest = 51088, -- "Heart of Darkness"
}
addon.data[48162] = { -- Vol'dun foothold campaign quest
	mapID = 864,
	x = 0.3286,
	y = 0.3490,
	atlas = 'quest-campaign-available',
	atlasSize = 32,
	highlightAtlas = 'quest-campaign-available',
	highlightAdd = true,
	tooltipQuest = 51283, -- "Voyage to the West"
}
addon.data[48172] = { -- return to Boralus at the end of Vol'dun foothold campaign chain
	mapID = 1161, -- Boralus, Tiragarde Sound
	x = 0.7002,
	y = 0.2708,
	atlas = 'quest-campaign-available',
	atlasSize = 32,
	highlightAtlas = 'quest-campaign-available',
	highlightAdd = true,
	tooltipQuest = 51969, -- "Return to Boralus"
}
