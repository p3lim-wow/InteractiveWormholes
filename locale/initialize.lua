local _, ns = ...
ns.L = {}

local lbsz = LibStub('LibBabble-SubZone-3.0'):GetUnstrictLookupTable()

local localizations = {}
local locale = GetLocale()

setmetatable(ns.L, {
	__call = function(_, newLocale)
		localizations[newLocale] = {}
		return localizations[newLocale]
	end,
	__index = function(_, key)
		local localeTable = localizations[locale]
		return lbsz[key] or (localeTable and localeTable[key]) or tostring(key)
	end
})
