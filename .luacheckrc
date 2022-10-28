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
	'WorldMapFrame',
	'GameTooltip',
	'GossipFrame',
	'GossipFrameMixin',
	'GossipFrameSharedMixin',
	'EventRegistry',
	'MapCanvasDataProviderMixin',
	'MapCanvasPinMixin',

	-- FrameXML functions
	'ToggleWorldMap',
	'tContains',
	'Mixin',
	'CreateFromMixins',
	'CreateObjectPool',
	'CreateVector2D',
	'FramePool_Hide',
	'FramePool_HideAndClearAnchors',
	'QuestUtils_GetQuestName',

	-- C namespaces
	'C_GossipInfo',
	'C_Map',

	-- API
	'CreateFrame',
	'InCombatLockdown',
	'IsShiftKeyDown',
	'GetLocale',

	-- external
	'LibStub',
	'HBD_PINS_WORLDMAP_SHOW_WORLD',
}
