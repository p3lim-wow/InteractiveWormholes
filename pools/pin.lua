local _, addon = ...

local overlay = CreateFrame('Frame', nil, WorldMapFrame:GetCanvas())
overlay:SetAllPoints()
overlay:EnableMouse(false)
overlay:SetFrameStrata('HIGH')

local pinMixin = {}
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

function pinMixin:OnEnter(...)
	if self.provider.OnPinEnter then
		self.provider.OnPinEnter(self, ...)
	end
end

function pinMixin:OnLeave(...)
	if self.provider.OnPinLeave then
		self.provider.OnPinLeave(self, ...)
	end
end

function pinMixin:OnMouseDown(button)
	if self.provider.OnPinClick then
		self.provider.OnPinClick(self, button, true)
	end
end

function pinMixin:OnMouseUp(button)
	if self.provider.OnPinClick then
		self.provider.OnPinClick(self, button, false)
	end
end

function pinMixin:SetPosition(mapID, x, y)
	local currentMapID = WorldMapFrame:GetMapID()
	if currentMapID ~= mapID then
		-- current map does not match the data, try to translate positions
		local continentID, continentPos = C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(x, y))
		local _, pos = C_Map.GetMapPosFromWorldPos(continentID, continentPos, currentMapID)
		if pos then
			x, y = pos:GetXY()
		else
			return
		end
	end

	self.x = x
	self.y = y
	return true
end

local pool = CreateObjectPool(function()
	local pin = Mixin(CreateFrame('Frame', nil, overlay), pinMixin)
	pin:SetScript('OnEnter', pin.OnEnter)
	pin:SetScript('OnLeave', pin.OnLeave)
	pin:SetScript('OnMouseUp', pin.OnMouseUp)
	pin:SetScript('OnMouseDown', pin.OnMouseDown)

	pin.Texture = pin:CreateTexture()
	pin.Texture:SetAllPoints()

	pin.Highlight = pin:CreateTexture(nil, 'HIGHLIGHT')
	pin.Highlight:SetAllPoints()

	return pin
end, function(_, pin)
	pin:ClearAllPoints()
	pin:Hide()
	pin:SetFrameLevel(5) -- this is the default
	pin:SetScale(1)

	pin.x = nil
	pin.y = nil

	addon:ReleaseArrow(pin)
end)

local providerMixin = {}
function providerMixin:RefreshData()
	if #self.data == 0 or InCombatLockdown() then
		return
	end

	for _, data in next, self.data do
		if self.OnPinCreate then
			local pin = pool:Acquire()
			pin.provider = self

			local mapID, x, y = self.OnPinCreate(pin, data)
			if mapID and pin:SetPosition(mapID, x, y) then
				pin:Show()
			else
				pool:Release(pin)
			end
		end
	end
end

function providerMixin:GetPinByID(id)
	for pin in pool:EnumerateActive() do
		if pin:GetID() == id then
			return pin
		end
	end
end

function providerMixin:EnumeratePins()
	return pool:EnumerateActive()
end

local providers = {}
function addon:AddProvider(mixin)
	if not providers[mixin] then
		providers[mixin] = CreateFromMixins(providerMixin, mixin)
	end
end

function addon:RemoveProvider(mixin)
	if providers[mixin] then
		providers[mixin] = nil
	end
end

local function updateProviders()
	for _, provider in next, providers do
		if provider.OnRefresh then
			provider:OnRefresh()
		end
	end

	pool:ReleaseAll()

	for _, provider in next, providers do
		provider:RefreshData()
	end
end

WorldMapFrame:HookScript('OnHide', function()
	pool:ReleaseAll()

	for _, provider in next, providers do
		if provider.OnMapHide then
			provider:OnMapHide()
		end
	end
end)

local pinScale, zoomFactor
local function updatePinSize()
	if pool:GetNumActive() == 0 then
		return
	end

	local canvasZoom = WorldMapFrame:GetCanvasZoomPercent()
	local canvasScaleFactor = 1 / WorldMapFrame:GetCanvasScale()
	local scale = canvasScaleFactor * Lerp(pinScale, pinScale + zoomFactor, Saturate(1 * canvasZoom))

	for pin in pool:EnumerateActive() do
		local posX = (overlay:GetWidth() * pin.x) / scale
		local posY = (overlay:GetHeight() * pin.y) / scale

		pin:SetScale(scale)
		pin:SetPoint('CENTER', overlay, 'TOPLEFT', posX, -posY)
	end
end

-- these two hook are sufficient for acquire/release logic
hooksecurefunc(WorldMapFrame, 'RefreshAll', updateProviders)
hooksecurefunc(WorldMapFrame, 'OnMapChanged', updateProviders)

-- this hook is needed to correctly set pin position and scale
hooksecurefunc(WorldMapFrame, 'OnCanvasScaleChanged', updatePinSize)

addon:RegisterOptionCallback('mapScale', function(value)
	pinScale = value
	updatePinSize()
end)

addon:RegisterOptionCallback('zoomFactor', function(value)
	zoomFactor = value
	updatePinSize()
end)
