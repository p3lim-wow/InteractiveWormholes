if(GetLocale() ~= 'itIT') then return end
local L = select(2, ...).L('itIT')

--- general strings
-- L['Click to travel'] = '' -- MISSING TRANSLATION
-- L['You will end up in one of multiple locations within this zone!'] = '' -- MISSING TRANSLATION
L['Not Discovered'] = TAXI_PATH_UNREACHABLE
L['You are here'] = TAXINODEYOUAREHERE

--- Subzones missing in LibBabble-SubZone
L['Throne of Flame'] = 'Trono delle Fiamme'
L['Fel Pits'] = 'Fosse Vili'
-- L['Blackrock Foundry Overlook'] = '' -- MISSING TRANSLATION
-- L['Stormgarde Keep'] = '' -- MISSING TRANSLATION
-- L['Gloomtide Strand'] = '' -- MISSING TRANSLATION
-- L['Cinderfall Grove'] = '' -- MISSING TRANSLATION
-- L['Lor\'danel Landing'] = '' -- MISSING TRANSLATION

--- Dalaran Sewer Portals
-- L['Sewer Guard Station'] = 'Stazione di Guardia dei Sotterranei' -- UNCONFIRMED TRANSLATION
-- L['Black Market'] = 'Mercato Nero' -- UNCONFIRMED TRANSLATION
-- L['Inn Entrance'] = 'Entrata della Locanda' -- UNCONFIRMED TRANSLATION
-- L['Alchemists\' Lair'] = 'Antro degli Alchimisti' -- UNCONFIRMED TRANSLATION
-- L['Abandoned Shack'] = 'Capanno Abbandonato' -- UNCONFIRMED TRANSLATION
-- L['Rear Entrance'] = 'Entrata Posteriore' -- UNCONFIRMED TRANSLATION
