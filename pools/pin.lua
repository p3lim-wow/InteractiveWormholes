local addonName, addon = ...

local pinMixin = CreateFromMixins(MapCanvasPinMixin)
function pinMixin:SetPosition(srcMapID, x, y) -- override
	local scale = addon:GetOption('mapScale')
	self:SetScalingLimits(1, scale, scale + addon:GetOption('zoomFactor'))

	-- translate position if it's on a different map than the current one
	local dstMapID = self:GetMap():GetMapID()
	if srcMapID ~= dstMapID then
		local continentID, continentPos = C_Map.GetWorldPosFromMapPos(srcMapID, CreateVector2D(x, y))
		local _, dstMapPos = C_Map.GetMapPosFromWorldPos(continentID, continentPos, dstMapID)
		if dstMapPos then
			x, y = dstMapPos:GetXY()
		else
			return
		end
	end

	if x and y then
		MapCanvasPinMixin.SetPosition(self, x, y) -- super
		return true
	end
end

do
	-- workaround for SetPassThroughButtons being restricted in combat
	-- https://github.com/Stanzilla/WoWUIBugs/issues/453
	local dummy = CreateFrame('Frame')
	dummy:SetScript('OnEvent', function(self, event)
		if self.queue and self.queue:size() > 0 then
			for object, button in next, self.queue do
				addon:AddPassthroughButtons(object, button)
			end
			self.queue:wipe()
			self:UnregisterEvent(event)
		end
	end)

	local function addPassthroughButtons(object, button)
		if InCombatLockdown() then
			if not dummy.queue then
				dummy.queue = addon.T{}
			end

			dummy.queue[object] = button

			if not dummy:IsEventRegistered('PLAYER_REGEN_ENABLED') then
				dummy:RegisterEvent('PLAYER_REGEN_ENABLED')
			end
		elseif object then
			dummy.SetPassThroughButtons(object, button)
		end
	end

	function pinMixin:SetPassThroughButtons() -- override
		addPassthroughButtons(self, 'RightButton')
	end
end

function pinMixin:SetIconAtlas(atlas)
	self.Icon:SetAtlas(atlas)
end

function pinMixin:SetHighlightAtlas(atlas)
	self.IconHighlight:SetAtlas(atlas)
end

function pinMixin:SetHighlightBlendMode(mode)
	self.IconHighlight:SetBlendMode(mode)
end

function pinMixin:AttachArrow()
	self.arrow = addon:AttachArrow(self)
end

local function createPin(mixin)
	local pin = Mixin(CreateFrame('Button', nil, WorldMapFrame:GetCanvas()), pinMixin)
	pin:UseFrameLevelType('PIN_FRAME_LEVEL_TOPMOST')

	local Icon = pin:CreateTexture(nil, 'BACKGROUND')
	Icon:SetAllPoints()
	pin.Icon = Icon

	local IconHighlight = pin:CreateTexture(nil, 'HIGHLIGHT')
	IconHighlight:SetAllPoints()
	IconHighlight:SetBlendMode('ADD')
	pin.IconHighlight = IconHighlight

	local QuestIcon = pin:CreateTexture(nil, 'OVERLAY')
	QuestIcon:SetPoint('LEFT')

	if mixin then
		Mixin(pin, mixin)
	end

	return pin
end

local function releasePin(_, pin)
	pin:ClearAllPoints()
	pin:Hide()

	pin.Icon:SetAllPoints()
	pin.IconHighlight:SetAllPoints()
	pin.IconHighlight:SetBlendMode('ADD')

	if pin.OnRelease then
		pin:OnRelease()
	end
end

function addon:CreatePinPool(name, mixin)
	local templateName = addonName .. name:gsub('^%l', string.upper) .. 'PinTemplate'
	local pool = CreateUnsecuredRegionPoolInstance(templateName)
	pool.createFunc = GenerateClosure(createPin, mixin)
	pool.resetFunc = releasePin
	return templateName, pool
end
