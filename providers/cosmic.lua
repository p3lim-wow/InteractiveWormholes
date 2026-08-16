local _, addon = ...

local COSMIC_MAP_ID = 946
local COSMIC_ARROW_COORDINATES = {
	-- these are coordinates just above each world in the cosmic map
	[947] = CreateVector2D(0.5126, 0.2516), -- Azeroth
	[101] = CreateVector2D(0.2023, 0.5726), -- Outland
	[572] = CreateVector2D(0.8357, 0.4216), -- Draenor
	[1550] = CreateVector2D(0.1796, 0.0837), -- Shadowlands
}

local provider = addon:CreatePinProvider()
function provider:OnRefresh()

	if WorldMapFrame:GetMapID() == COSMIC_MAP_ID then
		local cosmicWorldMapIDs = addon:GetCosmicWorldsActive()
		if cosmicWorldMapIDs then
			for _, mapID in next, cosmicWorldMapIDs do
				local pin = self:AddPin(mapID, COSMIC_ARROW_COORDINATES[mapID]:GetXY())
				pin:SetSize(0.0001, 0.0001)
				addon:AttachArrow(pin)
			end
		end
	end
end
