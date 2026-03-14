local _, addon = ...

local COSMIC_MAP_ID = 946
local COSMIC_ARROW_COORDINATES = {
	-- these are coordinates just above each world in the cosmic map
	[947] = CreateVector2D(0.5126, 0.2516), -- Azeroth
	[101] = CreateVector2D(0.2023, 0.5726), -- Outland
	[572] = CreateVector2D(0.8357, 0.4216), -- Draenor
	[1550] = CreateVector2D(0.1796, 0.0837), -- Shadowlands
}

local provider = {}
provider.data = addon:T()

function provider:OnPinCreate(cosmicWorldMapID)
	self:SetSize(0.0001, 0.0001) -- make it so small it's invisible
	addon:AttachArrow(self)

	return COSMIC_MAP_ID, COSMIC_ARROW_COORDINATES[cosmicWorldMapID]:GetXY()
end

function provider:OnRefresh()
	provider.data:wipe()

	if WorldMapFrame:GetMapID() == COSMIC_MAP_ID then
		local cosmicWorldMapIDs = addon:GetCosmicWorldsActive()
		if cosmicWorldMapIDs then
			for _, mapID in next, cosmicWorldMapIDs do
				provider.data:insert(mapID)
			end
		end
	end
end

addon:AddProvider(provider)
