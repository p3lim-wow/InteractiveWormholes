local _, addon = ...

local function animationCycle(animation)
	animation.animateUp = not animation.animateUp

	if animation.animateUp then
		animation.arrow:SetPoint('BOTTOM', animation.arrow:GetParent(), 'TOP', 0, 10)
		animation.transition:SetSmoothing('OUT')
		animation.transition:SetOffset(0, -10)
	else
		animation.arrow:SetPoint('BOTTOM', animation.arrow:GetParent(), 'TOP', 0, 0)
		animation.transition:SetSmoothing('IN')
		animation.transition:SetOffset(0, 10)
	end

	animation:Play()
end

addon.arrowPool = CreateObjectPool(function()
	local arrow = WorldMapFrame:CreateTexture(nil, 'OVERLAY')
	arrow:SetTexture([[Interface\Minimap\Minimap-DeadArrow]])
	arrow:SetTexCoord(0, 1, 1, 0)

	local animation = arrow:CreateAnimationGroup()
	animation:SetScript('OnFinished', animationCycle)

	local transition = animation:CreateAnimation('Translation')
	transition:SetOffset(0, 10)
	transition:SetDuration(0.5)
	transition:SetSmoothing('IN')

	animation.arrow = arrow
	animation.transition = transition
	animation:Play()

	return arrow
end)
