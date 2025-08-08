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
	'InteractiveWormholes',

	-- mutating globals
	'InteractiveWormholesDB',
	'StaticPopupDialogs',
}

read_globals = {
	table = {fields = {'wipe'}},

	-- FrameXML objects
	'CustomGossipFrameManager',
	'FlagsUtil',
	'FlightMapFrame',
	'FlightMapMixin',
	'GameTooltip',
	'GossipFrame',
	'GossipFrameSharedMixin',
	'MapCanvasDataProviderMixin',
	'MapCanvasPinMixin',
	'TaxiFrame',
	'UIErrorsFrame',
	'UIParent',
	'WorldMapFrame',

	-- FrameXML constants
	'Enum',
	'CUSTOM_GOSSIP_FRAME_EVENTS',

	-- FrameXML functions
	'CreateFromMixins',
	'CreateUnsecuredObjectPool',
	'CreateVector2D',
	'GameTooltip_AddErrorLine',
	'GameTooltip_AddHighlightLine',
	'GameTooltip_AddNormalLine',
	'GameTooltip_Hide',
	'GenerateClosure',
	'HideUIPanel',
	'RegisterAttributeDriver',
	'SetTooltipMoney',
	'ShowUIPanel',
	'StaticPopup_Show',
	'Mixin',

	-- GlobalStrings
	'ALT_KEY',
	'CTRL_KEY',
	'DUNGEON_FLOOR_BLACKROCKDEPTHS2',
	'ERR_NOT_IN_COMBAT',
	'ITEM_COOLDOWN_TIME_HOURS',
	'ITEM_COOLDOWN_TIME_MIN',
	'ITEM_COOLDOWN_TIME_SEC',
	'PERCENTAGE_STRING',
	'SHIFT_KEY',
	'SPELL_CAST_TIME_SEC',
	'SPELL_RECAST_TIME_HOURS',
	'TAXINODEYOUAREHERE',
	'TAXI_PATH_UNREACHABLE',
	'TUTORIAL_TITLE35',
	'YES',
	'NO',

	-- namespaces
	'C_AddOns',
	'C_GossipInfo',
	'C_Map',
	'C_PlayerInteractionManager',
	'C_QuestLog',
	'C_Spell',
	'C_SpellBook',
	'C_TaxiMap',

	-- API
	'CanCancelScene',
	'CancelScene',
	'CloseTaxiMap',
	'CreateFrame',
	'GetNumRoutes',
	'GetTime',
	'InCombatLockdown',
	'IsInInstance',
	'IsPlayerSpell',
	'IsShiftKeyDown',
	'TakeTaxiNode',
	'TaxiGetNodeSlot',
	'TaxiNodeCost',
	'UnitFactionGroup',
	'UnitIsGameObject',
	'hooksecurefunc',
}
