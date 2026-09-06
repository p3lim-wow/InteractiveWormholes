local _, addon = ...

local providers = {}
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
	provider.pins:Release(self)
end

function pinMixin:OnEnter(...)
	local provider = pinProviders[self]
	if provider.OnPinEnter then
		xpcall(provider.OnPinEnter, geterrorhandler(), provider, self, ...)
	end
end

function pinMixin:OnLeave(...)
	local provider = pinProviders[self]
	if provider.OnPinLeave then
		xpcall(provider.OnPinLeave, geterrorhandler(), provider, self, ...)
	end
end

function pinMixin:OnMouseDown(button)
	local provider = pinProviders[self]
	if provider.OnPinClick then
		xpcall(provider.OnPinClick, geterrorhandler(), provider, self, button, true)
	end
end

function pinMixin:OnMouseUp(button)
	local provider = pinProviders[self]
	if provider.OnPinClick then
		xpcall(provider.OnPinClick, geterrorhandler(), provider, self, button, false)
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

	providers[pinProviders[pin]].positions[pin] = nil

	addon:ReleaseArrow(pin)
end

local function updatePins()
	if not WorldMapFrame or not WorldMapFrame:IsShown() then
		return
	end

	local canvasZoom = WorldMapFrame:GetCanvasZoomPercent()
	local canvasScaleFactor = 1 / WorldMapFrame:GetCanvasScale()

	for _, data in next, providers do
		if data.pins:GetNumActive() > 0 then
			local overlayWidth, overlayHeight = data.overlay:GetSize()
			local scale = canvasScaleFactor * Lerp(data.pinScale, data.pinScale + data.zoomMultiplier, Saturate(canvasZoom))

			for pin in data.pins:EnumerateActive() do
				local x, y = unpack(data.positions[pin])
				local posX = (overlayWidth * x) / scale
				local posY = (overlayHeight * y) / scale

				pin:SetScale(scale)
				pin:SetPoint('CENTER', data.overlay, 'TOPLEFT', posX, -posY)
			end
		end
	end
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

	local provider = providers[self]
	local pin = provider.pins:Acquire()
	pin:Show()

	provider.positions[pin] = {x, y}

	return pin
end

function providerMixin:SetPinScale(pinScale, zoomMultiplier)
	providers[self].pinScale = pinScale or 1
	providers[self].zoomMultiplier = zoomMultiplier or 0.2

	updatePins()
end

function providerMixin:EnumeratePins()
	return providers[self].pins:EnumerateActive()
end

local function refreshProviders()
	for provider, data in next, providers do
		local pool = data.pins
		pool:ReleaseAll()

		if provider.OnRefresh then
			xpcall(provider.OnRefresh, geterrorhandler(), provider)
		end
	end
end

local function updateMapShow()
	refreshProviders()
	updatePins()
end

local function updateMapHide()
	for provider, data in next, providers do
		data.pins:ReleaseAll()

		if provider.OnMapHide then
			xpcall(provider.OnMapHide, geterrorhandler(), provider)
		end
	end
end

function addon:CreatePinProvider(frameStrata, frameLevel, ...)
	local provider = CreateFromMixins(providerMixin, ...)

	local overlay = CreateFrame('Frame', nil, WorldMapFrame:GetCanvas())
	overlay:SetAllPoints()
	overlay:EnableMouse(false)
	overlay:SetFrameStrata(frameStrata or 'HIGH')
	overlay:SetFrameLevel(frameLevel or 1)

	if table.count(providers) == 0 then
		-- these two hook are sufficient for acquire/release logic
		hooksecurefunc(WorldMapFrame, 'RefreshAll', refreshProviders)
		hooksecurefunc(WorldMapFrame, 'OnMapChanged', refreshProviders)

		-- this hook is needed to correctly set pin position and scale
		hooksecurefunc(WorldMapFrame, 'OnCanvasScaleChanged', updatePins)

		-- OnMapChanged doesn't trigger if the map was already open on the map,
		-- we'll need to force an update of the active providers, and since the
		-- canvas stays the same OnCanvasScaleChanged doesn't change so we'll need
		-- to update pin sizes too
		addon:RegisterEvent('WORLD_MAP_OPEN', updateMapShow)

		WorldMapFrame:HookScript('OnHide', updateMapHide)
	end

	providers[provider] = {
		pins = CreateObjectPool(GenerateClosure(createPin, provider, overlay), resetPin),
		overlay = overlay,
		positions = {},
		pinScale = 1,
		zoomMultiplier = 0.2,
	}

	return provider
end

function addon:RemovePinProvider(provider)
	providers[provider].pins:ReleaseAll()
	providers[provider] = nil
end
