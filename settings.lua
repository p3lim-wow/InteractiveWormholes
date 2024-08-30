local _, addon = ...
local L = addon.L

local function formatPercentage(value)
	return PERCENTAGE_STRING:format(math.floor((value * 100) + 0.5))
end

addon:RegisterSettings('InteractiveWormholesDB', {
	{
		key = 'changeMap',
		type = 'toggle',
		title = L['Change maps'],
		tooltip = L['Change to the most appropriate map.\n\n|cffff0000Warning:|r This will cause taint!'],
		default = false,
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
		tooltip = L['Use the normal world map for taxi'],
		default = false,
		new = true,
	},
})

addon:RegisterSettingsSlash('/interactivewormholes', '/iw')
