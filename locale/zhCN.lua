if(GetLocale() ~= 'zhCN') then return end
local L = select(2, ...).L('zhCN')

--- general strings
-- L['Click to travel'] = '' -- MISSING TRANSLATION
-- L['You will end up in one of multiple locations within this zone!'] = '' -- MISSING TRANSLATION
L['Not Discovered'] = TAXI_PATH_UNREACHABLE
L['You are here'] = TAXINODEYOUAREHERE

--- Subzones missing in LibBabble-SubZone
L['Throne of Flame'] = '烈焰王座'
L['Fel Pits'] = '魔能熔池'
-- L['Blackrock Foundry Overlook'] = '' -- MISSING TRANSLATION
-- L['Stormgarde Keep'] = '' -- MISSING TRANSLATION
-- L['Gloomtide Strand'] = '' -- MISSING TRANSLATION
-- L['Cinderfall Grove'] = '' -- MISSING TRANSLATION
-- L['Lor\'danel Landing'] = '' -- MISSING TRANSLATION

--- Dalaran Sewer Portals
-- L['Sewer Guard Station'] = '下水道卫兵岗哨' -- UNCONFIRMED TRANSLATION
-- L['Black Market'] = '黑市' -- UNCONFIRMED TRANSLATION
-- L['Inn Entrance'] = '旅店入口' -- UNCONFIRMED TRANSLATION
-- L['Alchemists\' Lair'] = '炼金师之巢' -- UNCONFIRMED TRANSLATION
-- L['Abandoned Shack'] = '废弃小屋' -- UNCONFIRMED TRANSLATION
-- L['Rear Entrance'] = '后门' -- UNCONFIRMED TRANSLATION
