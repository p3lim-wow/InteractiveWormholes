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
	-- FrameXML objects
	'FlagsUtil',
	'FlightMapFrame',
	'FlightMapMixin',
	'GossipFrame',
	'TaxiFrame',
	'UIErrorsFrame',
	'UIParent',
	'WorldMapFrame',

	-- FrameXML constants
	'DISABLED_FONT_COLOR',
	'GREEN_FONT_COLOR',
	'RED_FONT_COLOR',
	'WHITE_FONT_COLOR',

	-- FrameXML functions
	'CreateObjectPool',
	'CreateUnsecuredObjectPool',
	'CreateVector2D',
	'GenerateFlatClosure',
	'HideUIPanel',
	'Lerp',
	'RegisterAttributeDriver',
	'Saturate',
	'ShowUIPanel',
	'StaticPopup_Show',

	-- GlobalStrings
	'ALT_KEY',
	'CTRL_KEY',
	'DUNGEON_FLOOR_BLACKROCKDEPTHS2',
	'DUNGEON_POI_TOOLTIP_INSTRUCTION_LINE',
	'ERR_NOT_IN_COMBAT',
	'ITEM_COOLDOWN_TIME_HOURS',
	'ITEM_COOLDOWN_TIME_MIN',
	'ITEM_COOLDOWN_TIME_SEC',
	'NO',
	'PERCENTAGE_STRING',
	'SHIFT_KEY',
	'SPELL_CAST_TIME_SEC',
	'SPELL_RECAST_TIME_HOURS',
	'TAXINODEYOUAREHERE',
	'TAXI_PATH_UNREACHABLE',
	'YES',

	-- namespaces
	'C_AddOns',
	'C_GossipInfo',
	'C_Map',
	'C_PlayerInteractionManager',
	'C_QuestLog',
	'C_Spell',
	'C_SpellBook',
	'C_TaxiMap',
	'Enum',

	-- API
	'CanCancelScene',
	'CancelScene',
	'CloseTaxiMap',
	'CreateFrame',
	'CreateFromMixins',
	'GetMoneyString',
	'GetNumRoutes',
	'GetTaxiMapID',
	'GetTime',
	'InCombatLockdown',
	'IsInInstance',
	'IsShiftKeyDown',
	'Mixin',
	'TakeTaxiNode',
	'TaxiGetNodeSlot',
	'TaxiNodeCost',
	'UnitFactionGroup',
	'UnitIsGameObject',
	'hooksecurefunc',
}
