local addonName, addon = ...

-- renders arrows on the cosmic map when there are destinations available in a world

local COSMIC_MAP_ID = 946
local COSMIC_ARROW_COORDINATES = {
	-- these are coordinates just above each world in the cosmic map
	[947] = CreateVector2D(0.5126, 0.2516), -- Azeroth
	[101] = CreateVector2D(0.2023, 0.5726), -- Outland
	[572] = CreateVector2D(0.8357, 0.4216), -- Draenor
	[1550] = CreateVector2D(0.1796, 0.0837), -- Shadowlands
}

-- create a map data provider that will handle arrows rendered on the cosmic map
local cosmicArrowsProvider = CreateFromMixins(MapCanvasDataProviderMixin)
function cosmicArrowsProvider:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate(addonName .. 'CosmicArrows')
end

function cosmicArrowsProvider:RefreshAllData()
	self:RemoveAllData()

	local mapID = self:GetMap():GetMapID()
	if mapID == COSMIC_MAP_ID then
		-- iterate through the already defined worlds where destinations exist
		for _, worldMapID in next, addon.activeCosmicWorlds do
			-- grab static coordinates and render the arrow using a custom pin provider
			local x, y = COSMIC_ARROW_COORDINATES[worldMapID]:GetXY()
			self:GetMap():AcquirePin(addonName .. 'CosmicArrows', x, y)
		end
	end
end

WorldMapFrame:AddDataProvider(cosmicArrowsProvider)

-- custom pin provider that does nothing but position the arrow
local cosmicArrowsPinProvider = CreateFromMixins(MapCanvasPinMixin)
function cosmicArrowsPinProvider:OnLoad()
	self:UseFrameLevelType('PIN_FRAME_LEVEL_TOPMOST')
	self:SetScalingLimits(1, 1, 1.2)
end

function cosmicArrowsPinProvider:OnAcquired(x, y)
	self:SetPosition(x, y)
end

-- create and register a pool for the arrows, we do it this way to avoid XML
WorldMapFrame.pinPools[addonName .. 'CosmicArrows'] = CreateObjectPool(function()
	-- we need to use a frame as the parent for the arrow since textures don't have frame levels
	local frame = CreateFrame('Frame')
	frame:SetSize(1, 1) -- BUG: the frame needs to have a size for its children to be rendered

	local arrow = addon.arrowPool:Acquire()
	arrow:SetParent(frame)
	arrow:SetPoint('CENTER')
	frame.arrow = arrow

	return Mixin(frame, cosmicArrowsPinProvider)
end, FramePool_HideAndClearAnchors)
