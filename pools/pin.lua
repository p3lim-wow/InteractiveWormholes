local _, addon = ...

local providerPools = {}
local providerOverlays = {}
local providerPinPosition = {}
local providerPinScale = {}
local pinProviders = {}

local pinMixin = {}
function pinMixin:SetNormalTexture(texture)
	self.Texture:SetTexture(texture)
end

function pinMixin:SetHighlightTexture(texture, blendMode)
	self.Highlight:SetTexture(texture)
	self.Highlight:SetBlendMode(blendMode or 'ADD')
end

function pinMixin:SetNormalAtlas(atlas)
	self.Texture:SetAtlas(atlas)
end

function pinMixin:SetHighlightAtlas(atlas, blendMode)
	self.Highlight:SetAtlas(atlas)
	self.Highlight:SetBlendMode(blendMode or 'ADD')
end

function pinMixin:Raise()
	self:SetFrameLevel(self:GetFrameLevel() + 1)
end

function pinMixin:Lower()
	self:SetFrameLevel(self:GetFrameLevel() - 1)
end

function pinMixin:Release()
	local provider = pinProviders[self]
	providerPools[provider]:Release(self)
end

function pinMixin:OnEnter(...)
	local provider = pinProviders[self]
	if provider.OnPinEnter then
		provider:OnPinEnter(self, ...)
	end
end

function pinMixin:OnLeave(...)
	local provider = pinProviders[self]
	if provider.OnPinLeave then
		provider:OnPinLeave(self, ...)
	end
end

function pinMixin:OnMouseDown(button)
	local provider = pinProviders[self]
	if provider.OnPinClick then
		provider:OnPinClick(self, button, true)
	end
end

function pinMixin:OnMouseUp(button)
	local provider = pinProviders[self]
	if provider.OnPinClick then
		provider:OnPinClick(self, button, false)
	end
end

local function createPin(provider, overlay)
	local pin = Mixin(CreateFrame('Frame', nil, overlay), pinMixin)
	pin:SetScript('OnEnter', pin.OnEnter)
	pin:SetScript('OnLeave', pin.OnLeave)
	pin:SetScript('OnMouseUp', pin.OnMouseUp)
	pin:SetScript('OnMouseDown', pin.OnMouseDown)

	pin.Texture = pin:CreateTexture()
	pin.Texture:SetAllPoints()

	pin.Highlight = pin:CreateTexture(nil, 'HIGHLIGHT')
	pin.Highlight:SetAllPoints()

	pinProviders[pin] = provider

	return pin
end

local function resetPin(_, pin)
	pin:ClearAllPoints()
	pin:Hide()
	pin:SetFrameLevel(5) -- this is the default
	pin:SetScale(1)

	providerPinPosition[pinProviders[pin]][pin] = nil

	addon:ReleaseArrow(pin)
end

local providerMixin = {}
function providerMixin:AddPin(mapID, x, y)
	local currentMapID = WorldMapFrame:GetMapID()
	if currentMapID ~= mapID then
		local pos = addon:TranslatePosition(mapID, x, y, currentMapID)
		if pos then
			x, y = pos:GetXY()
		else
			return
		end
	end

	if not (x and y) then
		return
	end

	local pin = providerPools[self]:Acquire()
	pin:Show()

	providerPinPosition[self][pin] = {x, y}

	return pin
end

function providerMixin:SetPinScale(pinScale, zoomMultiplier)
	providerPinScale[self] = {pinScale or 1, zoomMultiplier or 0.2}
end

function providerMixin:EnumeratePins()
	return providerPools[self]:EnumerateActive()
end

local function refreshProviders()
	for provider, pool in next, providerPools do
		pool:ReleaseAll()

		if provider.OnRefresh then
			provider:OnRefresh()
		end
	end
end

local function updatePinSizes()
	local canvasZoom = WorldMapFrame:GetCanvasZoomPercent()
	local canvasScaleFactor = 1 / WorldMapFrame:GetCanvasScale()

	for provider, pool in next, providerPools do
		if pool:GetNumActive() > 0 then
			local overlay = providerOverlays[provider]
			local overlayWidth, overlayHeight = overlay:GetSize()

			local pinScale, zoomMultiplier = unpack(providerPinScale[provider])
			local scale = canvasScaleFactor * Lerp(pinScale, pinScale + zoomMultiplier, Saturate(canvasZoom))

			for pin in pool:EnumerateActive() do
				local x, y = unpack(providerPinPosition[provider][pin])
				local posX = (overlayWidth * x) / scale
				local posY = (overlayHeight * y) / scale

				pin:SetScale(scale)
				pin:SetPoint('CENTER', overlay, 'TOPLEFT', posX, -posY)
			end
		end
	end
end

local function updateMapShow()
	refreshProviders()
	updatePinSizes()
end

local function updateMapHide()
	for provider, pool in next, providerPools do
		pool:ReleaseAll()

		if provider.OnMapHide then
			provider:OnMapHide()
		end
	end
end

function addon:CreatePinProvider(frameStrata, frameLevel, ...)
	local provider = CreateFromMixins(providerMixin, ...)
	provider:SetPinScale() -- set defaults

	local overlay = CreateFrame('Frame', nil, WorldMapFrame:GetCanvas())
	overlay:SetAllPoints()
	overlay:EnableMouse(false)
	overlay:SetFrameStrata(frameStrata or 'HIGH')
	overlay:SetFrameLevel(frameLevel or 1)

	if addon:tsize(providerPools) == 0 then

		-- these two hook are sufficient for acquire/release logic
		hooksecurefunc(WorldMapFrame, 'RefreshAll', refreshProviders)
		hooksecurefunc(WorldMapFrame, 'OnMapChanged', refreshProviders)

		-- this hook is needed to correctly set pin position and scale
		hooksecurefunc(WorldMapFrame, 'OnCanvasScaleChanged', updatePinSizes)

		-- OnMapChanged doesn't trigger if the map was already open on the map,
		-- we'll need to force an update of the active providers, and since the
		-- canvas stays the same OnCanvasScaleChanged doesn't change so we'll need
		-- to update pin sizes too
		addon:RegisterEvent('WORLD_MAP_OPEN', updateMapShow)

		WorldMapFrame:HookScript('OnHide', updateMapHide)
	end

	providerPools[provider] = CreateObjectPool(GenerateClosure(createPin, provider, overlay), resetPin)
	providerOverlays[provider] = overlay
	providerPinPosition[provider] = {}

	return provider
end

function addon:RemovePinProvider(provider)
	providerPools[provider]:ReleaseAll()
	providerPools[provider] = nil
	providerOverlays[provider] = nil
	providerPinPosition[provider] = nil
	providerPinScale[provider] = nil
end
