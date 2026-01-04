local addonName, addon = ...

local button = addon:CreateButton('Button', addonName .. 'Dungeon', UIParent, 'SecureActionButtonTemplate,SecureHandlerAttributeTemplate,SecureHandlerEnterLeaveTemplate')
button:Hide()
button:SetFrameStrata('TOOLTIP')
button:SetPropagateMouseMotion(true)
button:SetAttribute('shift-type1', 'spell')

-- set attribute to trigger EnterLeave driver
button:HookScript('OnShow', function(self)
	self:SetAttribute('_entered', true)
end)
button:HookScript('OnHide', function(self)
	addon:DeferMethod(self, 'SetAttribute', '_entered', false)
end)

-- use EnterLeave to securely deactivate when the mouse leaves the item
button:SetAttribute('_onleave', 'self:ClearAllPoints();self:Hide()')

-- use attribute driver to securely deactivate when the modifier key is released
button:SetAttribute('_onattributechanged', [[
	if name == 'visibility' and value == 'hide' and self:IsShown() then
		self:ClearAllPoints()
		self:Hide()
	end
]])

local instanceSpellID
button:HookScript('OnShow', function(self)
	local owner = GameTooltip:GetOwner()
	if not owner then
		return
	end

	local left, bottom, width, height = owner:GetScaledRect()
	local scaleMultiplier = 1 / UIParent:GetScale()

	self:ClearAllPoints()
	self:SetPoint('BOTTOMLEFT', left * scaleMultiplier, bottom * scaleMultiplier)
	self:SetSize(width * scaleMultiplier, height * scaleMultiplier)

	self:SetAttribute('spell', instanceSpellID)
end)

RegisterAttributeDriver(button, 'visibility', '[mod:shift] show; hide')

function addon:MODIFIER_STATE_CHANGED(key, down)
	if key == 'LSHIFT' or key == 'RSHIFT' then
		if down and instanceSpellID and not InCombatLockdown() then
			button:Show()
		end
	end
end

local function getKnownSpellIDByInstanceID(instanceID)
	if not instanceID then
		return
	end

	local spellID = addon.dungeons[instanceID]
	if not spellID then
		return
	end

	if type(spellID) == 'table' then
		for id in next, spellID do
			if C_SpellBook.IsSpellKnown(id) then
				return id
			end
		end
	elseif C_SpellBook.IsSpellKnown(spellID) then
		return spellID
	end
end

local function onEnter(pin)
	local inCombat = InCombatLockdown()

	local spellID = getKnownSpellIDByInstanceID(pin.journalInstanceID)
	if spellID then
		local cooldownInfo = C_Spell.GetSpellCooldown(spellID)
		local cooldownRemaining = cooldownInfo and cooldownInfo.duration > 0 and (cooldownInfo.duration - (GetTime() - cooldownInfo.startTime)) or 0

		if inCombat or cooldownRemaining > 0 then
			GameTooltip:AddLine(addon.L['<Shift Click to Teleport>'], 0.5, 0.5, 0.5)
		else
			GameTooltip:AddLine(addon.L['<Shift Click to Teleport>'], 0.1, 1, 0.1)
		end

		local spellInfo = C_Spell.GetSpellInfo(spellID)
		GameTooltip:AddLine(' ') -- blank line
		GameTooltip:AddLine(string.format('|T%s:20:20|t %s', spellInfo.iconID, spellInfo.name), 1, 1, 1)
		GameTooltip:AddDoubleLine(SPELL_CAST_TIME_SEC:format(spellInfo.castTime / 1000), SPELL_RECAST_TIME_HOURS:format(8), 1, 1, 1, 1, 1, 1)

		if cooldownRemaining > 0 then
			if cooldownRemaining > 3600 then
				GameTooltip:AddLine(ITEM_COOLDOWN_TIME_HOURS:format(cooldownRemaining / 3600), 1, 0.125, 0.125)
			elseif cooldownRemaining > 60 then
				GameTooltip:AddLine(ITEM_COOLDOWN_TIME_MIN:format(cooldownRemaining / 60), 1, 0.125, 0.125)
			else
				GameTooltip:AddLine(ITEM_COOLDOWN_TIME_SEC:format(cooldownRemaining), 1, 0.125, 0.125)
			end
		end

		-- TODO: this has caching issues
		GameTooltip:AddLine(C_Spell.GetSpellDescription(spellID))

		if inCombat then
			GameTooltip:AddLine(' ') -- blank line
			GameTooltip:AddLine(ERR_NOT_IN_COMBAT, 1, 0.125, 0.125)
		end

		GameTooltip:Show()

		if not inCombat and cooldownRemaining == 0 then
			instanceSpellID = spellID

			if IsShiftKeyDown() then
				button:Show()
			end
		end
	end
end

local function onLeave()
	instanceSpellID = nil
end

local pins = {}
hooksecurefunc(WorldMapFrame, 'AcquirePin', function(self, pinTemplate)
	if pinTemplate == 'DungeonEntrancePinTemplate' then
		for pin in self.pinPools[pinTemplate]:EnumerateActive() do
			if not pins[pin] then
				pins[pin] = true

				pin:HookScript('OnEnter', onEnter)
				pin:HookScript('OnLeave', onLeave)
			end
		end
	end
end)
