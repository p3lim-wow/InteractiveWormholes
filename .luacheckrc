std = 'lua51'

quiet = 1 -- suppress report output for files without warnings

-- see https://luacheck.readthedocs.io/en/stable/warnings.html#list-of-warnings
-- and https://luacheck.readthedocs.io/en/stable/cli.html#patterns
ignore = {
	'122', -- overriding object methods
	'212/self', -- unused argument self
	'212/event', -- unused argument event
	'212/unit', -- unused argument unit
	'312/event', -- unused value of argument event
	'312/unit', -- unused value of argument unit
	'431', -- shadowing an upvalue
	'631', -- line is too long
}

read_globals = {
	table = {fields = {'wipe'}},

	-- FrameXML objects
	'EncounterJournal',
	'EncounterJournalInstanceSelect',
	'GameTooltip',
	'GossipFrame',
	'GossipFrameSharedMixin',
	'MapCanvasDataProviderMixin',
	'MapCanvasPinMixin',
	'UIParent',
	'WorldMapFrame',

	-- FrameXML functions
	'CreateFromMixins',
	'CreateObjectPool',
	'CreateVector2D',
	'FramePool_Hide',
	'FramePool_HideAndClearAnchors',
	'GameTooltip_Hide',
	'Mixin',
	'QuestUtils_GetQuestName',
	'tContains',

	-- C namespaces
	'C_GossipInfo',
	'C_Map',

	-- API
	'CreateFrame',
	'EJ_GetInstanceInfo',
	'GetLocale',
	'InCombatLockdown',
	'IsShiftKeyDown',
	'IsSpellKnown',
	'UnitFactionGroup',
	'hooksecurefunc',
	'securecall',

	-- external
	'LibStub',
	'HBD_PINS_WORLDMAP_SHOW_WORLD',
}
