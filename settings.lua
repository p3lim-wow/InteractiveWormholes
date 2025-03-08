local _, addon = ...
local L = addon.L

local function formatPercentage(value)
	return PERCENTAGE_STRING:format(math.floor((value * 100) + 0.5))
end

local settings = {
	{
		key = 'changeMap', -- TODO: remove
		type = 'toggle',
		title = L['Change maps'],
		tooltip = L['Change to the most appropriate map'] .. '\n\n|cffff0000' .. L['This will cause taint!'] .. '|r',
		default = false,
	},
	{
		key = 'modifier',
		type = 'menu',
		title = L['Modifier'],
		tooltip = L['Hold this button to prevent the map from opening automatically'],
		default = 'SHIFT',
		options = {
			{value='ALT', label=ALT_KEY},
			{value='CTRL', label=CTRL_KEY},
			{value='SHIFT', label=SHIFT_KEY},
		},
	},
	{
		key = 'modifierReverse',
		type = 'toggle',
		title = L['Reverse modifier'],
		tooltip = L['This will not open the map unless the button is held'],
		default = false,
		parent = 'modifier',
	},
	{
		key = 'mapScale',
		type = 'slider',
		title = L['Map pin scale'],
		tooltip = L['The scale of pins on the map'],
		default = 1.0,
		minValue = 0.5,
		maxValue = 2.0,
		valueStep = 0.01,
		valueFormat = formatPercentage,
	},
	{
		key = 'zoomFactor',
		type = 'slider',
		title = L['Pin size zoom factor'],
		tooltip = L['How much extra scale to apply when map is zoomed'],
		default = 0.2,
		minValue = 0,
		maxValue = 1,
		valueStep = 0.01,
		valueFormat = formatPercentage,
	},
	{
		key = 'taxi',
		type = 'toggle',
		title = L['Taxi world map'],
		tooltip = L['Use the normal world map for taxi.\nThis ignores the modifier option.'],
		default = false,
	},
}

addon:RegisterSettings('InteractiveWormholesDB', settings)
addon:RegisterSettingsSlash('/interactivewormholes', '/iw')
addon:RegisterMapSettings('InteractiveWormholesDB', settings)
