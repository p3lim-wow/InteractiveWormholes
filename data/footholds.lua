local _, addon = ...

local campaign = {
	atlas = 'quest-campaign-available',
	atlasSize = 32,
	highlightAtlas = 'quest-campaign-available',
	highlightAdd = true,
}


-- Warfront Footholds (Horde)
local hordeLanding = {
	atlas = 'bfa-landingbutton-horde-up',
	atlasSize = 40,
	highlightAtlas = 'bfa-landingbutton-horde-diamondhighlight',
	highlightAdd = true,
}
local hordeBase = Mixin({
	mapID = 862, -- Zuldazar
	x = 0.5840,
	y = 0.6250,
	tooltipMap = 862,
	-- TODO: consider a ship/boat atlas if there is one
}, hordeLanding)
local hordeFootholdTiragarde = Mixin({
	mapID = 895,
	x = 0.8820,
	y = 0.5116,
	tooltipMap = 895,
}, hordeLanding)
local hordeFootholdStormsong = Mixin({
	mapID = 942,
	x = 0.5198,
	y = 0.2449,
	tooltipMap = 942,
}, hordeLanding)
local hordeFootholdDrustvar = Mixin({
	mapID = 896,
	x = 0.2061,
	y = 0.4569,
	tooltipMap = 896,
}, hordeLanding)

addon.data[48350] = Mixin({
	disabledOnQuests = addon.T{}
}, hordeFootholdTiragarde)
addon.data[48794] = hordeBase -- Tiragarde Sound -> Zuldazar

addon.data[48349] = Mixin({
	disabledOnQuests = addon.T{}
}, hordeFootholdStormsong)
addon.data[49160] = hordeBase -- Stormsong Valley -> Zuldazar

addon.data[48348] = Mixin({
	disabledOnQuests = addon.T{}
}, hordeFootholdDrustvar)
addon.data[48793] = hordeBase -- Drustvar -> Zuldazar

-- Horde War Campaign (in order, first 3 are player choices)
addon.data[48345] = Mixin({
	tooltipQuest = 51421, -- "Shiver Me Timbers"
}, hordeFootholdTiragarde, campaign)
addon.data[48350].disabledOnQuests:insert(addon.data[48345].tooltipQuest) -- TODO: verify if needed
addon.data[48343] = Mixin({
	-- this gossipID is re-used by multiple quests
	tooltipQuests = {
		51532, -- "Storming In"
		57198, -- "Sense of Obligation"
	}
}, hordeFootholdStormsong, campaign)
addon.data[48349].disabledOnQuests:merge(addon.data[48343].tooltipQuests) -- TODO: verify if needed
addon.data[48342] = Mixin({
	-- this gossipID is re-used by multiple quests
	tooltipQuests = {
		51340, -- "Drustvar Ho!"
		51784, -- "A Stroll Through a Cemetery"
	}
}, hordeFootholdDrustvar, campaign)
addon.data[48348].disabledOnQuests:merge(addon.data[48342].tooltipQuests) -- TODO: verify if needed
addon.data[48346] = Mixin({
	-- this gossipID is re-used by multiple quests
	tooltipQuests = {
		51589, -- "Breaking Kul Tiran Will"
		52183, -- "When a Plan Comes Together"
		53852, -- "Azerite Denied"
		54121, -- "Breaking Out Ashvane"
		55124, -- "Righting Wrongs"
	}
}, hordeFootholdTiragarde, campaign)
addon.data[48350].disabledOnQuests:merge(addon.data[48346].tooltipQuests) -- TODO: verify if needed
-- next part (questID 51784) re-uses gossipID 48342, see above
addon.data[48344] = Mixin({
	tooltipQuest = 51797, -- "Tracking Tidesages"
}, hordeFootholdStormsong, campaign)
addon.data[48349].disabledOnQuests:insert(addon.data[48344].tooltipQuest) -- TODO: verify if needed
addon.data[48347] = Mixin({
	mapID = 1157, -- The Great Sea
	x = 0.4085,
	y = 0.6745,
	tooltipQuest = 52764, -- "Journey to the Middle of Nowhere"
	displayExtra = {
		Mixin({
			-- The Great Sea map used for this quest isn't translatable to any map, so
			-- we'll have to estimate the destination ourselves
			mapID = 947, -- Azeroth
			x = 0.7127,
			y = 0.6728,
			tooltipQuest = 52764,
		}, campaign)
	}
}, campaign)
addon.data[49000] = hordeBase -- The Great Sea -> Zuldazar
-- next part (questID 52183) re-uses gossipID 48346, see above
-- next part (questID 53852) re-uses gossipID 48346, see above
-- next part (questID 54121) re-uses gossipID 48346, see above
addon.data[48352] = Mixin({
	mapID = 62, -- Darkshore (it's really a phased version with mapID 1333)
	x = 0.4751, -- actually 0.5452
	y = 0.1973, -- actually 0.2081
	tooltipQuest = 54042, -- "Trouble in Darkshore"
}, campaign) -- not really a campaign quest but w/e
-- next part (questID 55124) re-uses gossipID 48346, see above
-- next part (questID 57198) re-uses gossipID 48343, see above
-- TODO: missing teleport to Razer Hill at some point in the 8.2.5 campaign, questID 56496 "The Eve of Battle"



-- Warfront Footholds (Alliance)
local allianceLanding = {
	atlas = 'bfa-landingbutton-alliance-up',
	atlasSize = 40,
	highlightAtlas = 'bfa-landingbutton-alliance-shieldhighlight',
	highlightAdd = true,
}
local allianceBase = Mixin({
	mapID = 1161, -- Boralus, Tiragarde Sound
	x = 0.7002,
	y = 0.2708,
	tooltipMap = 1161,
	-- TODO: consider a ship/boat atlas if there is one
}, allianceLanding)
local allianceFootholdZuldazar = Mixin({
	mapID = 862,
	x = 0.4068,
	y = 0.7085,
	tooltipMap = 862,
}, allianceLanding)
local allianceFootholdNazmir = Mixin({
	mapID = 863,
	x = 0.6196,
	y = 0.4020,
	tooltipMap = 863,
}, allianceLanding)
local allianceFootholdVoldun = Mixin({
	mapID = 864,
	x = 0.3560,
	y = 0.3317,
	tooltipMap = 864,
}, allianceLanding)

addon.data[48171] = Mixin({
	disabledOnQuests = addon.T{}
}, allianceFootholdZuldazar)
addon.data[49161] = allianceBase -- Zuldazar -> Boralus

addon.data[48170] = Mixin({
	disabledOnQuests = addon.T{}
}, allianceFootholdNazmir)
addon.data[48827] = allianceBase -- Nazmir -> Boralus

addon.data[48169] = Mixin({
	disabledOnQuests = addon.T{}
}, allianceFootholdVoldun)
addon.data[48172] = allianceBase -- Vol'dun -> Boralus

-- Alliance War Campaign (in order, first 3 are player choices)
addon.data[48168] = Mixin({
	tooltipQuest = 51308, -- "Zuldazar Foothold"
	x = 0.8022, -- different destination during this quest
	y = 0.5523,
}, allianceFootholdZuldazar, campaign)
addon.data[48171].disabledOnQuests:insert(addon.data[48168].tooltipQuest) -- TODO: verify if needed
addon.data[48164] = Mixin({
	tooltipQuest = 51088, -- "Heart of Darkness"
	-- different destination coords during this quest, but it's close enough
}, allianceFootholdNazmir, campaign)
addon.data[48170].disabledOnQuests:insert(addon.data[48164].tooltipQuest) -- TODO: verify if needed
addon.data[48162] = Mixin({
	tooltipQuest = 51283, -- "Voyage to the West"
	-- different destination coords during this quest, but it's close enough
}, allianceFootholdVoldun, campaign)
addon.data[48169].disabledOnQuests:insert(addon.data[48162].tooltipQuest) -- TODO: verify if needed
addon.data[48163] = Mixin({
	tooltipQuest = 52026, -- "Overseas Assassination"
}, allianceFootholdVoldun, campaign)
addon.data[48169].disabledOnQuests:insert(addon.data[48163].tooltipQuest) -- TODO: verify if needed
addon.data[48165] = Mixin({
	-- this gossipID is re-used by multiple quests
	tooltipQuests = {
		52147, -- "Crippling the Horde"
		54303, -- "The March to Nazmir"
	}
}, allianceFootholdNazmir, campaign)
addon.data[48170].disabledOnQuests:insert(52147) -- TODO: verify if needed
-- addon.data[48170].disabledOnQuests:insert(54303) -- not needed
addon.data[48167] = Mixin({
	tooltipQuest = 52173, -- "The Void Elves Stand Ready"
}, allianceFootholdZuldazar, campaign)
addon.data[48171].disabledOnQuests:insert(addon.data[48167].tooltipQuest) -- TODO: verify if needed
addon.data[48166] = Mixin({
	-- this gossipID is re-used by multiple quests
	tooltipQuests = {
		52473, -- "Bringing Down the Fleet"
		54192, -- "Sensitive Intel"
		54171, -- "The Abyssal Scepter"
	}
}, allianceFootholdZuldazar, campaign)
-- addon.data[48171].disabledOnQuests:merge(addon.data[48166].tooltipQuests) -- not needed
-- next part (questID 54192) re-uses gossipID 48166, see above
-- next part (questID 54171) re-uses gossipID 48166, see above
-- next part (questID 54303) re-uses gossipID 48165, see above
addon.data[48910] = Mixin({
	mapID = 70, -- Dustwallow Marsh
	x = 0.6982,
	y = 0.4146,
	tooltipQuest = 55045, -- "My Brother's Keeper"
}, campaign)
addon.data[50022] = allianceBase -- Dustwallow Marsh -> Boralus
addon.data[49745] = Mixin({
	mapID = 1, -- Durotar
	x = 0.5262,
	y = 0.4328,
	tooltipQuest = 56494, -- "The Eve of Battle"
}, campaign)
