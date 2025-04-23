local _, addon = ...

local pinMixin = {}
function pinMixin:OnLoad()
	self:UseFrameLevelType('PIN_FRAME_LEVEL_TOPMOST')

	local NormalTexture = self:CreateTexture(nil, 'BACKGROUND')
	NormalTexture:SetAllPoints()
	self:SetNormalTexture(NormalTexture)

	local HighlightTexture = self:CreateTexture(nil, 'OVERLAY')
	HighlightTexture:SetAllPoints()
	HighlightTexture:SetBlendMode('ADD')
	self:SetHighlightTexture(HighlightTexture)

	local QuestIcon = self:CreateTexture(nil, 'OVERLAY')
	QuestIcon:SetPoint('LEFT')
end

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

function pinMixin:SetIconAtlas(atlas)
	self:GetNormalTexture():SetAtlas(atlas)
end

function pinMixin:SetHighlightAtlas(atlas)
	self:GetHighlightTexture():SetAtlas(atlas)
end

function pinMixin:SetHighlightBlendMode(mode)
	self:GetHighlightTexture():SetBlendMode(mode)
end

function pinMixin:AttachArrow()
	self.arrow = addon:AttachArrow(self)
end

function pinMixin:OnRelease()
	self:GetNormalTexture():SetAllPoints()
	self:GetHighlightTexture():SetAllPoints()
	self:GetHighlightTexture():SetBlendMode('ADD')
end


local providerMixin = {}
function providerMixin:RefreshAllData(...)
	self:RemoveAllData()

	if self.OnRefresh then
		self:OnRefresh(...)
	end
end

function providerMixin:RemoveAllData()
	local numPins = self:GetNumPins()
	self:RemoveAllPins()

	if self.OnRelease then
		self:OnRelease(numPins and numPins > 0)
	end
end

function addon:CreateProvider(kind, providerMix, pinMix)
	providerMix = CreateFromMixins(providerMixin, providerMix or {})
	pinMix = CreateFromMixins(pinMixin, pinMix or {})
	return addon:AddMapPinProvider(kind:gsub('^%l', string.upper), providerMix, pinMix)
end
