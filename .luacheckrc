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

globals = {
	-- exposed globals
	'InteractiveWormholes'
}

read_globals = {
	table = {fields = {'wipe'}},

	-- FrameXML objects
	'CustomGossipFrameManager',
	'FlagsUtil',
	'FlightMap_FlightPointPinMixin', -- taxi
	'FlightMapFrame', -- taxi
	'GameTooltip',
	'GossipFrame',
	'GossipFrameSharedMixin',
	'MapCanvasDataProviderMixin',
	'MapCanvasPinMixin',
	'TaxiFrame', -- taxi
	'UIErrorsFrame',
	'UIParent', -- taxi
	'WorldMapFrame',

	-- FrameXML constants
	'Enum',
	'CUSTOM_GOSSIP_FRAME_EVENTS',

	-- FrameXML functions
	'CreateFromMixins',
	'CreateUnsecuredObjectPool',
	'CreateVector2D',
	'GenerateClosure',
	'HideUIPanel',
	'ShowUIPanel',
	'Mixin',
	'tContains',

	-- GlobalStrings
	'ERR_NOT_IN_COMBAT',
	'PERCENTAGE_STRING',
	'TUTORIAL_TITLE35',

	-- namespaces
	'C_AddOns', -- taxi
	'C_GossipInfo',
	'C_Map',
	'C_PlayerInteractionManager',
	'C_QuestLog',
	'C_TaxiMap', -- taxi

	-- API
	'CloseTaxiMap', -- taxi
	'CreateFrame',
	'GetNumRoutes', -- taxi
	'InCombatLockdown',
	'IsInInstance', -- taxi
	'IsShiftKeyDown',
	'TaxiGetNodeSlot', -- taxi
	'UnitFactionGroup',
	'UnitIsGameObject',
}
