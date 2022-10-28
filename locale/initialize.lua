local _, addon = ...
addon.L = {}

local localizations = {}
local locale = GetLocale()

setmetatable(addon.L, {
	__call = function(_, newLocale)
		localizations[newLocale] = {}
		return localizations[newLocale]
	end,
	__index = function(_, key)
		local localeTable = localizations[locale]
		return localeTable and localeTable[key] or tostring(key)
	end
})

-- already available from globalstrings
addon.L['You are here'] = _G.TAXINODEYOUAREHERE
