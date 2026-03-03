local _, addon = ...

local lineParent = CreateFrame('Frame', nil, WorldMapFrame:GetCanvas())
lineParent:SetAllPoints()
lineParent:SetFrameLevel(2200) -- need to set it high so lines render above the canvas and pois

local linePool = CreateUnsecuredObjectPool(function()
	local line = lineParent:CreateLine()
	line:SetAtlas('_UI-Taxi-Line-horizontal')
	return line
end, function(_, line)
	line:Hide()
end)

function addon:AttachLine(source, destination)
	local line = linePool:Acquire()
	line:SetStartPoint('CENTER', source)
	line:SetEndPoint('CENTER', destination)
	line:SetThickness(1 / WorldMapFrame:GetCanvasScale() * 35)
	line:Show()
end

function addon:ReleaseLines()
	linePool:ReleaseAll()
end
