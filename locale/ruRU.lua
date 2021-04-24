if(GetLocale() ~= 'ruRU') then return end
local L = select(2, ...).L('ruRU')

--- general strings
-- L['Click to travel'] = '' -- MISSING TRANSLATION
-- L['You will end up in one of multiple locations within this zone!'] = '' -- MISSING TRANSLATION
-- L['The rocket might not land exactly where you\'d expect, nor take the path exactly as shown.'] = '' -- MISSING TRANSLATION
L['Not Discovered'] = TAXI_PATH_UNREACHABLE
L['You are here'] = TAXINODEYOUAREHERE

--- Subzones missing in LibBabble-SubZone
L['Throne of Flame'] = 'Трон Пламени'
L['Fel Pits'] = 'Ямы Скверны'
-- L['Blackrock Foundry Overlook'] = '' -- MISSING TRANSLATION
-- L['Stormgarde Keep'] = '' -- MISSING TRANSLATION
-- L['Gloomtide Strand'] = '' -- MISSING TRANSLATION
-- L['Cinderfall Grove'] = '' -- MISSING TRANSLATION
-- L['Lor\'danel Landing'] = '' -- MISSING TRANSLATION
-- L['Northern Rocketway Terminus'] = '' -- MISSING TRANSLATION
-- L['Gallywix Rocketway Exchange'] = '' -- MISSING TRANSLATION

--- Dalaran Sewer Portals
-- L['Sewer Guard Station'] = 'пост стража канализации' -- UNCONFIRMED TRANSLATION
-- L['Black Market'] = 'черный рынок' -- UNCONFIRMED TRANSLATION
-- L['Inn Entrance'] = 'вход в таверну' -- UNCONFIRMED TRANSLATION
-- L['Alchemists\' Lair'] = 'логово алхимика' -- UNCONFIRMED TRANSLATION
-- L['Abandoned Shack'] = 'заброшенная лачуга' -- UNCONFIRMED TRANSLATION
-- L['Rear Entrance'] = 'черный ход' -- UNCONFIRMED TRANSLATION
