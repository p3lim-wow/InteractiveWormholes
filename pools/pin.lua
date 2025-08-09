local _, addon = ...

local pinMixin = {}
function pinMixin:OnLoad()
	self:UseFrameLevelType('PIN_FRAME_LEVEL_TOPMOST')

	local QuestIcon = self:CreateTexture(nil, 'OVERLAY')
	QuestIcon:SetPoint('LEFT')
end

local mapScale, zoomFactor
addon:RegisterOptionCallback('mapScale', function(value)
	mapScale = value
end)
addon:RegisterOptionCallback('zoomFactor', function(value)
	zoomFactor = value
end)

function pinMixin:RefreshVisuals()
	if self.info and self.info.ignoreScale then
		return
	end

	self:SetScalingLimits(1, mapScale, mapScale + zoomFactor)
end

function pinMixin:SetPosition(srcMapID, x, y) -- override
	self:RefreshVisuals()

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

local pinProviders = {}
function addon:CreateProvider(kind, providerMix, pinMix)
	providerMix = CreateFromMixins(providerMixin, providerMix or {})
	pinMix = CreateFromMixins(pinMixin, pinMix or {})

	local provider = addon:AddMapPinProvider(kind:gsub('^%l', string.upper), providerMix, pinMix)
	table.insert(pinProviders, provider)
	return provider
end

local function updateVisuals()
	-- update pins on changes
	if WorldMapFrame:IsShown() then
		for _, provider in next, pinProviders do
			provider:RefreshAllData()

			for pin in provider:EnumeratePins() do
				pin:RefreshVisuals()
				pin:ApplyCurrentScale()
			end
		end
	end
end

addon:RegisterOptionCallback('mapScale', updateVisuals)
addon:RegisterOptionCallback('zoomFactor', updateVisuals)
