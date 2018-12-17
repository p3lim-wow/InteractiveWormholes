local addonName, ns = ...
local L = ns.L

local HBDP = LibStub('HereBeDragons-Pins-2.0')

local npcData = {
	[145743] = { -- Fidelio Featherleaf (Darkshore, Alliance)
		mapID = 1203,
		source = {x = 0, y = 0},
		destinations = {
			[L['Bashal\'Aran']]     = {x = 0.507, y = 0.549},
			[L['Gloomtide Strand']] = {x = 0.467, y = 0.477},
			[L['Cinderfall Grove']] = {x = 0.563, y = 0.441},
		}
	},
}

local SourceMarker = CreateFrame('Frame')
SourceMarker:SetSize(1, 1)

hooksecurefunc(ns.Handler, 'GOSSIP_SHOW', function(self)
	if(IsShiftKeyDown()) then
		 -- temporary disable
		return
	end

	local npcID = self:GetNPCID()
	local data = npcData[npcID]
	if(data) then
		self:Enable(data.mapID)
		HBDP:AddWorldMapIconMap(self, SourceMarker, data.mapID, data.source.x, data.source.y)

		for index = 1, GetNumGossipOptions() do
			local text = select((index * 2) - 1, GetGossipOptions())
			for name, loc in next, data.destinations do
				if(text:match(name)) then
					local Marker = self:GetMarker()
					Marker:SetID(index)
					Marker:SetNormalAtlas('Taxi_Frame_Gray')
					Marker:SetHighlightAtlas('Taxi_Frame_Yellow')
					Marker:SetSize(24)
					Marker:SetName(name)
					Marker:SetSource(SourceMarker)

					HBDP:AddWorldMapIconMap(self, Marker, data.mapID, loc.x, loc.y)
				end
			end
		end
	end
end)
