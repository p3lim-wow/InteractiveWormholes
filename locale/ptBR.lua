if(GetLocale() ~= 'ptBR') then return end
local L = select(2, ...).L('ptBR')

--- general strings
-- L['Click to travel'] = '' -- MISSING TRANSLATION
-- L['You will end up in one of multiple locations within this zone!'] = '' -- MISSING TRANSLATION
-- L['The rocket might not land exactly where you\'d expect, nor take the path exactly as shown.'] = '' -- MISSING TRANSLATION
L['Not Discovered'] = TAXI_PATH_UNREACHABLE
L['You are here'] = TAXINODEYOUAREHERE

--- Subzones missing in LibBabble-SubZone
L['Throne of Flame'] = 'Trono das Chamas'
L['Fel Pits'] = 'Poços Fétidos'
-- L['Blackrock Foundry Overlook'] = '' -- MISSING TRANSLATION
-- L['Stormgarde Keep'] = '' -- MISSING TRANSLATION
-- L['Gloomtide Strand'] = '' -- MISSING TRANSLATION
-- L['Cinderfall Grove'] = '' -- MISSING TRANSLATION
-- L['Lor\'danel Landing'] = '' -- MISSING TRANSLATION
-- L['Northern Rocketway Terminus'] = '' -- MISSING TRANSLATION
-- L['Gallywix Rocketway Exchange'] = '' -- MISSING TRANSLATION

--- Dalaran Sewer Portals
-- L['Sewer Guard Station'] = 'Posto de Guarda dos Esgotos' -- UNCONFIRMED TRANSLATION
-- L['Black Market'] = 'Mercado Negro' -- UNCONFIRMED TRANSLATION
-- L['Inn Entrance'] = 'Entrada da Estalagem' -- UNCONFIRMED TRANSLATION
-- L['Alchemists\' Lair'] = 'Covil do Alquimista' -- UNCONFIRMED TRANSLATION
-- L['Abandoned Shack'] = 'Cabana abandonada' -- UNCONFIRMED TRANSLATION
-- L['Rear Entrance'] = 'Entrada dos Fundos' -- UNCONFIRMED TRANSLATION
