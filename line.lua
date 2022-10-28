local _, addon = ...

local lineParent = CreateFrame('Frame', nil, WorldMapFrame:GetCanvas())
lineParent:SetAllPoints()
lineParent:SetFrameLevel(2200) -- need to set it high so lines render above the canvas and pois

addon.linePool = CreateObjectPool(function()
	local line = lineParent:CreateLine()
	line:SetAtlas('_UI-Taxi-Line-horizontal')

	-- scale the line with the canvas
	line:SetThickness(1 / WorldMapFrame:GetCanvasScale() * 35)
	return line
end, FramePool_Hide)
