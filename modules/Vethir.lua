local addon = select(2, ...)
local L = addon.L

local STORMHEIM = 634
local destinations = {
	[L['Galebroken Path']]   = {x = 0.45, y = 0.77},
	[L['Thorignir Refuge']]  = {x = 0.43, y = 0.82},
	[L['Thorim\'s Peak']]    = {x = 0.41, y = 0.80},
	[L['Hrydshal']] = {x = 0.43, y = 0.67, atlas = 'ShipMissionIcon-Combat-Map', size = 40},
}

addon:Add(function(self)
	local npcID = self:GetNPCID()
	if(npcID == 108685) then
		self:SetMapID(STORMHEIM)

		local Source = self:NewMarker()
		Source:SetTitle(L['You are here'])
		Source:SetNormalAtlas('Taxi_Frame_Green')
		Source:SetHighlightAtlas('Taxi_Frame_Green')
		Source:SetSize(24)
		Source:DisableArrow()
		Source:Pin(STORMHEIM, 0.4467, 0.5950)

		for index, line in next, self:GetLines() do
			for name, loc in next, destinations do
				if(line:match(name)) then
					local Marker = self:NewMarker()
					Marker:SetID(index)
					Marker:SetTitle(name)
					Marker:SetNormalAtlas(loc.atlas or 'Taxi_Frame_Gray')
					Marker:SetHighlightAtlas(loc.atlas or 'Taxi_Frame_Yellow')
					Marker:SetSize(loc.size or 20)

					if(not loc.atlas) then
						-- all options except for the world quest "Cry More Thunder!"
						Marker:SetSource(Source)
					end

					Marker:Pin(STORMHEIM, loc.x, loc.y)
				end
			end
		end
	end
end)
