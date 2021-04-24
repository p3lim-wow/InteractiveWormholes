if(GetLocale() ~= 'frFR') then return end
local L = select(2, ...).L('frFR')

--- general strings
-- L['Click to travel'] = '' -- MISSING TRANSLATION
-- L['You will end up in one of multiple locations within this zone!'] = '' -- MISSING TRANSLATION
-- L['The rocket might not land exactly where you\'d expect, nor take the path exactly as shown.'] = '' -- MISSING TRANSLATION
L['Not Discovered'] = TAXI_PATH_UNREACHABLE
L['You are here'] = TAXINODEYOUAREHERE

--- Subzones missing in LibBabble-SubZone
L['Throne of Flame'] = 'Le Trône des Flammes'
L['Fel Pits'] = 'Les Gangrefosses'
-- L['Blackrock Foundry Overlook'] = '' -- MISSING TRANSLATION
-- L['Stormgarde Keep'] = '' -- MISSING TRANSLATION
-- L['Gloomtide Strand'] = '' -- MISSING TRANSLATION
-- L['Cinderfall Grove'] = '' -- MISSING TRANSLATION
-- L['Lor\'danel Landing'] = '' -- MISSING TRANSLATION
-- L['Northern Rocketway Terminus'] = '' -- MISSING TRANSLATION
-- L['Gallywix Rocketway Exchange'] = '' -- MISSING TRANSLATION

--- Dalaran Sewer Portals
-- L['Sewer Guard Station'] = 'poste de garde des égouts' -- UNCONFIRMED TRANSLATION
-- L['Black Market'] = 'marché noir' -- UNCONFIRMED TRANSLATION
-- L['Inn Entrance'] = 'entrée de l\'auberge' -- UNCONFIRMED TRANSLATION
-- L['Alchemists\' Lair'] = 'antre des alchimistes' -- UNCONFIRMED TRANSLATION
-- L['Abandoned Shack'] = 'cabane abandonnée' -- UNCONFIRMED TRANSLATION
-- L['Rear Entrance'] = 'porte de derrière' -- UNCONFIRMED TRANSLATION
