local _, addon = ...

local paused = false
function addon:MODIFIER_STATE_CHANGED(key, isPressed)
	if key:sub(2) == addon:GetOption('modifier') then
		if addon:GetOption('modifierReverse') then
			paused = isPressed ~= 1
		else
			paused = isPressed == 1
		end
	end
end

addon:RegisterOptionCallback('modifierReverse', function(value)
	-- TODO: consider keys being down while the setting is changed
	paused = value
end)

function addon:IsPaused()
	return paused
end
