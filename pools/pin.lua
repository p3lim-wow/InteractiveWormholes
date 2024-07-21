local _, addon = ...

local pinMixin = CreateFromMixins(MapCanvasPinMixin)
function pinMixin:SetPosition(srcMapID, x, y)
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

function pinMixin:SetPassThroughButtons()
	-- https://github.com/Stanzilla/WoWUIBugs/issues/453
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

function addon:CreatePinPool(mixin)
	return CreateUnsecuredObjectPool(GenerateClosure(createPin, mixin), releasePin)
end
