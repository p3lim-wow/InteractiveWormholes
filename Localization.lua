local _, ns = ...
local L = {}

setmetatable(L, {__index = function(L, key)
	local value = tostring(key)
	L[key] = value
	return value
end})

local locale = GetLocale()
if(locale == 'deDE') then
	-- L['Click to travel'] = '' -- MISSING!
	-- L['This is an accurate wormhole!'] = '' -- MISSING!
	-- L['You will end up in one of multiple locations within this zone.'] = '' -- MISSING!

	-- pulled from LibBabble-SubZone-3.0
	L['Galebroken Path'] = 'Der Sturmverwüstete Pfad'
	L['Thorignir Refuge'] = 'Die Zuflucht der Thorignir'
	L['Thorim\'s Peak'] = 'Das Thorimshorn'

	-- pulled from http://de.wowhead.com/quest=41950
	L['Cry More Thunder!'] = 'Noch mehr Donner des Schmerzes'
elseif(locale == 'esES') then
	-- L['Click to travel'] = '' -- MISSING!
	-- L['This is an accurate wormhole!'] = '' -- MISSING!
	-- L['You will end up in one of multiple locations within this zone.'] = '' -- MISSING!

	-- pulled from LibBabble-SubZone-3.0
	L['Galebroken Path'] = 'Sendero Rompeciclón'
	L['Thorignir Refuge'] = 'Refugio de los Thorignir'
	L['Thorim\'s Peak'] = 'Cima de Thorim'

	-- pulled from http://es.wowhead.com/quest=41950
	L['Cry More Thunder!'] = '¡Truenos y truenos!'
elseif(locale == 'esMX') then
	-- L['Click to travel'] = '' -- MISSING!
	-- L['This is an accurate wormhole!'] = '' -- MISSING!
	-- L['You will end up in one of multiple locations within this zone.'] = '' -- MISSING!

	-- pulled from LibBabble-SubZone-3.0
	L['Galebroken Path'] = 'Ruta Destruida por el Huracán'
	L['Thorignir Refuge'] = 'Refugio de Thorignir'
	L['Thorim\'s Peak'] = 'Cumbre de Thorim'

	-- L['Cry More Thunder!'] = '' -- MISSING! (wowhead doesn't have esMX)
elseif(locale == 'frFR') then
	-- L['Click to travel'] = '' -- MISSING!
	-- L['This is an accurate wormhole!'] = '' -- MISSING!
	-- L['You will end up in one of multiple locations within this zone.'] = '' -- MISSING!

	-- pulled from LibBabble-SubZone-3.0
	L['Galebroken Path'] = 'Sentier Brise-Vent'
	L['Thorignir Refuge'] = 'Refuge des Thorignirs'
	L['Thorim\'s Peak'] = 'Pic de Thorim'

	-- pulled from http://fr.wowhead.com/quest=41950
	L['Cry More Thunder!'] = 'Tonnerre ailé'
elseif(locale == 'itIT') then
	-- L['Click to travel'] = '' -- MISSING!
	-- L['This is an accurate wormhole!'] = '' -- MISSING!
	-- L['You will end up in one of multiple locations within this zone.'] = '' -- MISSING!

	-- pulled from LibBabble-SubZone-3.0
	L['Galebroken Path'] = 'Percorso Tempestoso'
	L['Thorignir Refuge'] = 'Rifugio dei Thorignir'
	L['Thorim\'s Peak'] = 'Picco di Thorim'

	-- pulled from http://it.wowhead.com/quest=41950
	L['Cry More Thunder!'] = 'Il ruggito più potente del tuono!'
elseif(locale == 'koKR') then
	-- L['Click to travel'] = '' -- MISSING!
	-- L['This is an accurate wormhole!'] = '' -- MISSING!
	-- L['You will end up in one of multiple locations within this zone.'] = '' -- MISSING!

	-- pulled from LibBabble-SubZone-3.0
	L['Galebroken Path'] = '질풍에 휩쓸린 길'
	L['Thorignir Refuge'] = '토리그니르 은거처'
	L['Thorim\'s Peak'] = '토림의 봉우리'

	-- pulled from http://ko.wowhead.com/quest=41950
	L['Cry More Thunder!'] = '더 퍼부어라!'
elseif(locale == 'ptBR') then
	-- L['Click to travel'] = '' -- MISSING!
	-- L['This is an accurate wormhole!'] = '' -- MISSING!
	-- L['You will end up in one of multiple locations within this zone.'] = '' -- MISSING!

	-- pulled from LibBabble-SubZone-3.0
	L['Galebroken Path'] = 'Trilha Arrasavento'
	L['Thorignir Refuge'] = 'Refúgio Thorignir'
	L['Thorim\'s Peak'] = 'Pico de Thorim'

	-- pulled from http://pt.wowhead.com/quest=41950
	L['Cry More Thunder!'] = 'Mais trovoadas!'
elseif(locale == 'ruRU') then
	-- L['Click to travel'] = '' -- MISSING!
	-- L['This is an accurate wormhole!'] = '' -- MISSING!
	-- L['You will end up in one of multiple locations within this zone.'] = '' -- MISSING!

	-- pulled from LibBabble-SubZone-3.0
	L['Galebroken Path'] = 'Разоренная бурей тропа'
	L['Thorignir Refuge'] = 'Приют торигниров'
	L['Thorim\'s Peak'] = 'Пик Торима'

	-- pulled from http://ru.wowhead.com/quest=41950
	L['Cry More Thunder!'] = 'И снова гром и молния!'
elseif(locale == 'zhCN') then
	-- L['Click to travel'] = '' -- MISSING!
	-- L['This is an accurate wormhole!'] = '' -- MISSING!
	-- L['You will end up in one of multiple locations within this zone.'] = '' -- MISSING!

	-- pulled from LibBabble-SubZone-3.0
	L['Galebroken Path'] = '碎风小径'
	L['Thorignir Refuge'] = '托林尼尔避难所'
	L['Thorim\'s Peak'] = '托里姆峰'

	-- L['Cry More Thunder!'] = '' -- MISSING! incorrect data on wowhead
elseif(locale == 'zhTW') then
	-- L['Click to travel'] = '' -- MISSING!
	-- L['This is an accurate wormhole!'] = '' -- MISSING!
	-- L['You will end up in one of multiple locations within this zone.'] = '' -- MISSING!

	-- pulled from LibBabble-SubZone-3.0
	L['Galebroken Path'] = '風裂小徑'
	L['Thorignir Refuge'] = '索林尼爾避難所'
	L['Thorim\'s Peak'] = '索林姆之巔'

	-- L['Cry More Thunder!'] = '' -- MISSING! incorrect data on wowhead
end

ns.L = L
