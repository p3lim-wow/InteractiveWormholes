if GetLocale() ~= 'esMX' then return end
local L = select(2, ...).L('esMX')

--- general strings
-- L['Click to travel'] = '' -- MISSING TRANSLATION
L['You are here'] = _G.TAXINODEYOUAREHERE -- already available from globalstrings
-- L['Shift+click to teleport'] = '' -- MISSING TRANSLATION

-- tooltips
L['Galebroken Path'] = 'Ruta Destruida por el Huracán' -- AreaTable.db2, id=7611
L['Thorignir Refuge'] = 'Refugio de Thorignir' -- AreaTable.db2, id=8267
L['Thorim\'s Peak'] = 'Cumbre de Thorim' -- AreaTable.db2, id=7612

L['Orgrimmar Rocketway Exchange'] = 'Intercambiador de la Cohetepista de Orgrimmar' -- AreaTable.db2, id=4830
-- L['Gallywix Rocketway Exchange'] = '' -- MISSING TRANSLATION
L['Northern Rocketway Exchange'] = 'Intercambiador de la Cohetepista del Norte' -- AreaTable.db2, id=4825
-- L['Northern Rocketway Terminus'] = '' -- MISSING TRANSLATION
L['Southern Rocketway Terminus'] = 'Terminal de la Cohetepista del Sur' -- AreaTable.db2, id=4828

L['The Masonary'] = 'El Masón' -- WMOAreaTable.db2, id=15548
L['Shadowforge City'] = 'Ciudad Forjatiniebla' -- WMOAreaTable.db2, id=26748
