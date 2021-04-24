if(GetLocale() ~= 'koKR') then return end
local L = select(2, ...).L('koKR')

--- general strings
-- L['Click to travel'] = '' -- MISSING TRANSLATION
-- L['You will end up in one of multiple locations within this zone!'] = '' -- MISSING TRANSLATION
-- L['The rocket might not land exactly where you\'d expect, nor take the path exactly as shown.'] = '' -- MISSING TRANSLATION
L['Not Discovered'] = TAXI_PATH_UNREACHABLE
L['You are here'] = TAXINODEYOUAREHERE

--- Subzones missing in LibBabble-SubZone
L['Throne of Flame'] = '불꽃의 왕좌'
L['Fel Pits'] = '지옥의 구덩이'
-- L['Blackrock Foundry Overlook'] = '' -- MISSING TRANSLATION
-- L['Stormgarde Keep'] = '' -- MISSING TRANSLATION
-- L['Gloomtide Strand'] = '' -- MISSING TRANSLATION
-- L['Cinderfall Grove'] = '' -- MISSING TRANSLATION
-- L['Lor\'danel Landing'] = '' -- MISSING TRANSLATION
-- L['Northern Rocketway Terminus'] = '' -- MISSING TRANSLATION
-- L['Gallywix Rocketway Exchange'] = '' -- MISSING TRANSLATION

--- Dalaran Sewer Portals
-- L['Sewer Guard Station'] = '하수구 경비초소' -- UNCONFIRMED TRANSLATION
-- L['Black Market'] = '암시장' -- UNCONFIRMED TRANSLATION
-- L['Inn Entrance'] = '여관 입구' -- UNCONFIRMED TRANSLATION
-- L['Alchemists\' Lair'] = '연금술사의 방' -- UNCONFIRMED TRANSLATION
-- L['Abandoned Shack'] = '버려진 집' -- UNCONFIRMED TRANSLATION
-- L['Rear Entrance'] = '후문' -- UNCONFIRMED TRANSLATION
