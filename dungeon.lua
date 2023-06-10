local addonName, addon = ...

local currentParent, currentSpell
local teleport = addon:CreateButton('Button', addonName .. 'DungeonTeleport', UIParent, 'SecureActionButtonTemplate')
teleport:Hide()
teleport:SetFrameLevel(9999) -- make sure we render high
teleport:SetAttribute('type', 'spell')
teleport:RegisterEvent('MODIFIER_STATE_CHANGED', function(self)
	if currentSpell and not InCombatLockdown() then
		if IsShiftKeyDown() and not self:IsShown() then
			self:SetAttribute('spell', currentSpell)
			self:SetParent(currentParent)
			self:SetAllPoints(currentParent)
			self:Show()
		elseif not IsShiftKeyDown() then
			self:Hide()
		end
	end
end)

teleport:SetScript('OnEnter', function(self)
	if currentParent then
		currentParent:GetScript('OnEnter')(currentParent)
	end
end)

teleport:SetScript('OnLeave', GameTooltip_Hide)
teleport:HookScript('OnLeave', function(self)
	addon:Defer(self, 'Hide', self)
end)

teleport:SetScript('OnHide', function(self)
	addon:Defer(self, 'SetAttribute', self, 'spell', nil)
	addon:Defer(self, 'SetParent', self, UIParent) -- try to prevent any kind of taint
	currentParent = nil
	currentSpell = nil

	if teleport:GetHighlightTexture() then
		teleport:GetHighlightTexture():SetAlpha(0)
	end
end)

local function onEnter(self)
	local dungeonID = self.journalInstanceID or self.instanceID
	local spellID = addon.data.dungeonTeleportSpells[dungeonID]

	if spellID and IsSpellKnown(spellID) then
		GameTooltip:SetOwner(self, 'ANCHOR_TOPRIGHT')
		GameTooltip:SetText((EJ_GetInstanceInfo(dungeonID)))
		GameTooltip:AddLine(addon.L['Shift+%s to teleport']:format('|A:NPE_LeftClick:18:18|a'), 1, 1, 1)
		-- want to use fancy texture for shift, but gotta make it ourselves
		-- GameTooltip:AddLine('|A:newplayertutorial-icon-key:18:40|a|A:NPE_LeftClick:18:18|a to teleport', 1, 1, 1)

		if InCombatLockdown() then
			GameTooltip:AddLine(' ')
			GameTooltip:AddLine(_G.ERR_NOT_IN_COMBAT, 1, 0, 0)
			GameTooltip:Show()
		else
			currentSpell = spellID
			currentParent = self

			GameTooltip:Show()

			if IsShiftKeyDown() then
				teleport:TriggerEvent('MODIFIER_STATE_CHANGED')
			end

			if self.instanceID then
				teleport:GetHighlightTexture():SetAlpha(1)
			end
		end
	end
end

-- hook dungeon entrance map pins
hooksecurefunc(WorldMapFrame, 'AcquirePin', function(self, pinTemplate)
	if pinTemplate == 'DungeonEntrancePinTemplate' then
		for pin in self:EnumeratePinsByTemplate(pinTemplate) do
			if not pin.hooked then
				pin.hooked = true
				pin:HookScript('OnEnter', onEnter)
				pin:HookScript('OnLeave', GameTooltip_Hide)
			end
		end
	end
end)

-- hook encounter journal dungeon list
addon:HookAddOn('Blizzard_EncounterJournal', function()
	hooksecurefunc('EncounterJournal_ListInstances', function()
		for _, frame in next, EncounterJournalInstanceSelect.ScrollBox:GetFrames() do
			if not frame.hooked then
				frame.hooked = true
				frame:HookScript('OnEnter', onEnter)
				frame:HookScript('OnLeave', GameTooltip_Hide)
			end
		end
	end)

	EncounterJournal:HookScript('OnHide', function()
		currentSpell = nil
	end)

	-- simulate highlight
	local highlight = teleport:CreateTexture(nil, nil, 'UI-EJ-DungeonButton-Highlight')
	highlight:SetAllPoints()
	highlight:SetAlpha(0)
	teleport:SetHighlightTexture(highlight, 'BLEND')
end)
