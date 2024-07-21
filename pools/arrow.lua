local _, addon = ...

local arrowMixin = {}
function arrowMixin:OnFinished()
	self.animateUp = not self.animateUp

	if self.animateUp then
		self.Arrow:SetPoint('BOTTOM', self.Arrow:GetParent(), 'TOP', 0, 10)
		self.transition:SetSmoothing('OUT')
		self.transition:SetOffset(0, -10)
	else
		self.Arrow:SetPoint('BOTTOM', self.Arrow:GetParent(), 'TOP', 0, 0)
		self.transition:SetSmoothing('IN')
		self.transition:SetOffset(0, 10)
	end

	self:Play()
end

function arrowMixin:Restart()
	self.animation:Pause()
	self.animation.animateUp = true
	self.OnFinished(self.animation)
	self.animation:Restart()
end

local arrowPool = CreateUnsecuredObjectPool(function()
	local Arrow = Mixin(WorldMapFrame:CreateTexture(nil, 'OVERLAY'), arrowMixin)
	Arrow:SetTexture([[Interface\Minimap\Minimap-DeadArrow]])
	Arrow:SetTexCoord(0, 1, 1, 0)
	Arrow:SetScale(0.7)

	local animation = Arrow:CreateAnimationGroup()
	animation:SetScript('OnFinished', Arrow.OnFinished)
	Arrow.animation = animation

	local transition = animation:CreateAnimation('Translation')
	transition:SetOffset(0, 10)
	transition:SetDuration(0.5)
	transition:SetSmoothing('IN')

	animation.Arrow = Arrow
	animation.transition = transition
	animation:Play()

	return Arrow
end, function(_, Arrow)
	Arrow:Hide()
	Arrow:ClearAllPoints()
end)

function addon:AttachArrow(pin)
	local Arrow = arrowPool:Acquire()
	Arrow:SetParent(pin)
	Arrow:SetPoint('BOTTOM', pin, 'TOP')
	Arrow:Show()
end

function addon:ReleaseArrows()
	arrowPool:ReleaseAll()
end

function addon:SyncArrows()
	-- TODO: hide if 30+ pins are visible on the map at the same time?
	for Arrow in arrowPool:EnumerateActive() do
		Arrow:Restart()
	end
end
