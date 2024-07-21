local _, addon = ...

-- renders arrows on the cosmic map when there are destinations available in a world

local COSMIC_MAP_ID = 946
local COSMIC_ARROW_COORDINATES = {
	-- these are coordinates just above each world in the cosmic map
	[947] = CreateVector2D(0.5126, 0.2516), -- Azeroth
	[101] = CreateVector2D(0.2023, 0.5726), -- Outland
	[572] = CreateVector2D(0.8357, 0.4216), -- Draenor
	[1550] = CreateVector2D(0.1796, 0.0837), -- Shadowlands
}

local cosmicArrowsProvider = addon:CreateProvider('cosmic')
function cosmicArrowsProvider:OnAdded(...)
	MapCanvasDataProviderMixin.OnAdded(self, ...) -- super

	-- create buffer
	addon.activeCosmicWorlds = {}
end

function cosmicArrowsProvider:OnRelease(hadPins)
	if hadPins then
		addon:ReleaseArrows()
	end
end

function cosmicArrowsProvider:OnRefresh()
	local mapID = self:GetMap():GetMapID()
	if mapID == COSMIC_MAP_ID then
		-- iterate through the already defined worlds where destinations exist
		for _, worldMapID in next, addon.activeCosmicWorlds do
			local pin = self:AcquirePin()
			pin:SetSize(0.001, 0.001) -- make it so small it's invisible
			pin:SetPosition(COSMIC_MAP_ID, COSMIC_ARROW_COORDINATES[worldMapID]:GetXY())
			pin:AttachArrow()
		end
	end

	addon:SyncArrows()
end

WorldMapFrame:AddDataProvider(cosmicArrowsProvider)
