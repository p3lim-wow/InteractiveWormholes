local _, addon = ...

local FACTION = UnitFactionGroup('player')

-- Silas' Stone of Transportation
-- all the destinations are flight masters, so we can get info with C_TaxiMap.GetTaxiNodesForMap
addon.data[50777] = { -- Diretusk Hollow (Horde)
	mapID = 942, -- Stormsong Valley
	x = 0.5426,
	y = 0.4925,
}
addon.data[50779] = { -- Hillcrest Pasture (Horde)
	mapID = 942, -- Stormsong Valley
	x = 0.5273,
	y = 0.8024,
}
addon.data[50780] = { -- Ironmaul Overlook (Horde)
	mapID = 942, -- Stormsong Valley
	x = 0.7592,
	y = 0.6409,
}
addon.data[50783] = { -- Seeker's Vista
	mapID = 942, -- Stormsong Valley
	x = 0.4007,
	y = 0.3726,
}
addon.data[50784] = { -- Stonetusk Watch (Horde)
	mapID = 942, -- Stormsong Valley
	x = 0.3885,
	y = 0.6676,
}
addon.data[50787] = { -- Windfall Cavern (Horde)
	mapID = 942, -- Stormsong Valley
	x = 0.6083,
	y = 0.2719,
}
addon.data[50785] = { -- Tidecross (Alliance)
	mapID = 942, -- Stormsong Valley
	x = 0.6552,
	y = 0.4799,
}
addon.data[50781] = { -- Mildenhall Meadery (Alliance)
	mapID = 942, -- Stormsong Valley
	x = 0.6854,
	y = 0.6508,
}
addon.data[50776] = { -- Deadwash (Alliance)
	mapID = 942, -- Stormsong Valley
	x = 0.4278,
	y = 0.5739,
}
addon.data[50778] = { -- Fort Daelin (Alliance)
	mapID = 942, -- Stormsong Valley
	x = 0.3428,
	y = 0.4732,
}
addon.data[50775] = { -- Brennadam (Alliance)
	mapID = 942, -- Stormsong Valley
	x = 0.5968,
	y = 0.7049,
}
addon.data[50782] = { -- Millstone Hamlet (Alliance)
	mapID = 942, -- Stormsong Valley
	x = 0.3081,
	y = 0.6654,
}
addon.data[50763] = { -- Castaway Point
	mapID = 895, -- Tiragarde Sound
	x = 0.8639,
	y = 0.8091,
}
addon.data[50769] = { -- Stonefist Watch (Horde)
	mapID = 895, -- Tiragarde Sound
	x = 0.5319,
	y = 0.6312,
}
addon.data[50773] = { -- Waning Glacier (Horde)
	mapID = 895, -- Tiragarde Sound
	x = 0.3967,
	y = 0.1847,
}
addon.data[50774] = { -- Wolf's Den (Horde)
	mapID = 895, -- Tiragarde Sound
	x = 0.6203,
	y = 0.1353,
}
addon.data[50765] = { -- Kennings Lodge (Alliance)
	mapID = 895, -- Tiragarde Sound
	x = 0.7663,
	y = 0.6541,
}
addon.data[50767] = { -- Outrigger Post (Alliance)
	mapID = 895, -- Tiragarde Sound
	x = 0.3557,
	y = 0.2487,
}
addon.data[50762] = { -- Bridgeport (Alliance)
	mapID = 895, -- Tiragarde Sound
	x = 0.7577,
	y = 0.4865,
}
addon.data[50764] = { -- Hatherford (Alliance)
	mapID = 895, -- Tiragarde Sound
	x = 0.6691,
	y = 0.2312,
}
addon.data[50766] = { -- Norwington Estate (Alliance)
	mapID = 895, -- Tiragarde Sound
	x = 0.5287,
	y = 0.2876,
}
addon.data[50771] = { -- Tradewinds Market (Alliance)
	mapID = 895, -- Tiragarde Sound
	x = 0.7358,
	y = 0.2342,
}
addon.data[50772] = { -- Vigil Hill (Alliance)
	mapID = 895, -- Tiragarde Sound
	x = 0.5770,
	y = 0.6154,
}
addon.data[50698] = { -- Anyport
	mapID = 896, -- Drustvar
	x = 0.1917,
	y = 0.4331,
}
addon.data[50704] = { -- Mudfisher Cove (Horde)
	mapID = 896, -- Drustvar
	x = 0.6211,
	y = 0.1688,
}
addon.data[50705] = { -- Swiftwind Post (Horde)
	mapID = 896, -- Drustvar
	x = 0.6641,
	y = 0.5923,
}
addon.data[50700] = { -- Falconhurst (Alliance)
	mapID = 896, -- Drustvar
	x = 0.2698,
	y = 0.7232,
}
addon.data[50702] = { -- Hangman's Point (Alliance)
	mapID = 896, -- Drustvar
	x = 0.7105,
	y = 0.4082,
}
addon.data[50706] = { -- Timbered Strand (Alliance)
	-- aka "Fletcher's Hollow"
	mapID = 896, -- Drustvar
	x = 0.7017,
	y = 0.6040,
}
addon.data[50699] = { -- Arom's Stand (Alliance)
	mapID = 896, -- Drustvar
	x = 0.3815,
	y = 0.5247,
}
addon.data[50708] = { -- Watchman's Rise (Alliance)
	mapID = 896, -- Drustvar
	x = 0.3182,
	y = 0.3044,
}
addon.data[50707] = { -- Trader's Camp (Alliance)
	-- aka "Barbthorn Ridge"
	mapID = 896, -- Drustvar
	x = 0.6263,
	y = 0.2388,
}

addon.data[50701] = { -- Fallhaven (Alliance)
	mapID = 896, -- Drustvar
	x = 0.5512,
	y = 0.3479,
}
addon.data[50669] = { -- Atal'Dazar (Horde)
	mapID = 862, -- Zuldazar
	x = 0.4612,
	y = 0.3578,
}
addon.data[50670] = { -- Atal'Gral
	mapID = 862, -- Zuldazar
	x = FACTION == 'Horde' and 0.8004 or 0.7996,
	y = FACTION == 'Horde' and 0.4149 or 0.4145,
}
addon.data[50672] = { -- Garden of the Loa (Horde)
	mapID = 862, -- Zuldazar
	x = 0.4971,
	y = 0.2628,
}
addon.data[50673] = { -- Isle of Fangs (Horde)
	mapID = 862, -- Zuldazar
	x = 0.5442,
	y = 0.8701,
}
addon.data[50674] = { -- Nesingwary's Trek
	-- aka "Nesingwary's Gameland"
	mapID = 862, -- Zuldazar
	x = 0.6623,
	y = 0.1767,
}
addon.data[50675] = { -- Port of Zandalar (Horde)
	mapID = 862, -- Zuldazar
	x = 0.5866,
	y = 0.5902,
}
addon.data[50676] = { -- Scaletrader Post
	mapID = 862, -- Zuldazar
	x = 0.7078,
	y = 0.2959,
}
addon.data[50677] = { -- Seeker's Outpost
	mapID = 862, -- Zuldazar
	x = 0.7044,
	y = 0.6527,
}
addon.data[50678] = { -- Temple of the Prophet (Horde)
	mapID = 862, -- Zuldazar
	x = 0.4974,
	y = 0.4452,
}
addon.data[50679] = { -- The Great Seal (Horde)
	mapID = 862, -- Zuldazar
	x = 0.5852,
	y = 0.4280,
}
addon.data[50680] = { -- The Mugambala (Horde)
	mapID = 862, -- Zuldazar
	x = 0.5333,
	y = 0.5723,
}
addon.data[50681] = { -- Warbeast Kraal (Horde)
	mapID = 862, -- Zuldazar
	x = 0.6723,
	y = 0.4299,
}
addon.data[50682] = { -- Xibala (Horde)
	mapID = 862, -- Zuldazar
	x = 0.4483,
	y = 0.7217,
}
addon.data[50684] = { -- Zeb'ahari (Horde)
	mapID = 862, -- Zuldazar
	x = 0.7732,
	y = 0.1536,
}
addon.data[50671] = { -- Castaway Encampment (Alliance)
	mapID = 862, -- Zuldazar
	x = 0.7765,
	y = 0.5453,
}

addon.data[50683] = { -- Xibala (Alliance)
	mapID = 862, -- Zuldazar
	x = 0.4483,
	y = 0.7217,
}
addon.data[50686] = { -- Gloom Hollow (Horde)
	mapID = 863, -- Nazmir
	x = 0.6712,
	y = 0.4338,
}
addon.data[50688] = { -- Zo'bal Ruins (Horde)
	mapID = 863, -- Nazmir
	x = 0.4016,
	y = 0.4286,
}
addon.data[50689] = { -- Zul'jan Ruins (Horde)
	mapID = 863, -- Nazmir
	x = 0.3893,
	y = 0.7806,
}
addon.data[50685] = { -- Fort Victory (Alliance)
	mapID = 863, -- Nazmir
	x = 0.6225,
	y = 0.4133,
}
addon.data[50687] = { -- Redfield's Watch (Alliance)
	mapID = 863, -- Nazmir
	x = 0.5086,
	y = 0.2078,
}
addon.data[50691] = { -- Sanctuary of the Devoted
	mapID = 864, -- Vol'dun
	x = 0.2763,
	y = 0.5041,
}
addon.data[50692] = { -- Scorched Sands Outpost (Horde)
	mapID = 864, -- Vol'dun
	x = 0.4389,
	y = 0.7601,
}
addon.data[50694] = { -- Temple of Akunda (Horde)
	mapID = 864, -- Vol'dun
	x = 0.5372,
	y = 0.8924,
}
addon.data[50695] = { -- Tortaka Refuge
	mapID = 864, -- Vol'dun
	x = 0.6184,
	y = 0.2167,
}
addon.data[50696] = { -- Vorrik's Sanctum (Horde)
	mapID = 864, -- Vol'dun
	x = 0.4726,
	y = 0.3517,
}
addon.data[50697] = { -- Vulpera Hideout (Horde)
	-- aka "Vulpera Hideaway"
	mapID = 864, -- Vol'dun
	x = 0.5696,
	y = 0.4937,
}
