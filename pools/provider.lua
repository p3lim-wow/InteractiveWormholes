local addonName, addon = ...

local providerMixin = {}
function providerMixin:GetPinTemplate()
	return self.pinTemplate
end

function providerMixin:SetPinTemplate(pinTemplate)
	self.pinTemplate = addonName .. '_' .. pinTemplate
end

function providerMixin:AcquirePin()
	return self:GetMap():AcquirePin(self:GetPinTemplate())
end

function providerMixin:EnumeratePins()
	return self:GetMap():EnumeratePinsByTemplate(self:GetPinTemplate())
end

function providerMixin:HasPins()
	return self:GetNumPins() > 0
end

function providerMixin:GetNumPins()
	return self:GetMap():GetNumActivePinsByTemplate(self:GetPinTemplate())
end

function providerMixin:RefreshAllData(...)
	self:RemoveAllData()

	if self.OnRefresh then
		self:OnRefresh(...)
	end
end

function providerMixin:RemoveAllData()
	local numPins = self:GetNumPins()
	self:GetMap():RemoveAllPinsByTemplate(self:GetPinTemplate())

	if self.OnRelease then
		self:OnRelease(numPins and numPins > 0)
	end
end

-- can't use provider event handler because errors get consumed

function addon:CreateProvider(kind, mixin)
	local provider = CreateFromMixins(MapCanvasDataProviderMixin, providerMixin)
	provider:SetPinTemplate(kind)

	WorldMapFrame:AddDataProvider(provider)
	WorldMapFrame.pinPools[provider:GetPinTemplate()] = addon:CreatePinPool(mixin)

	return provider
end
