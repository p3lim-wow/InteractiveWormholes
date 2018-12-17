local addonName, ns = ...
local L = ns.L

local HBDP = LibStub('HereBeDragons-Pins-2.0')

local DARKSHORE = 1203
local destinations = {
	[L['Send me to Bashal\'Aran.']]        = {x = 0.507, y = 0.549},
	[L['Send me to Gloomtide Strand.']]    = {x = 0.467, y = 0.477},
	[L['Send me to Cinderfall Grove.']]    = {x = 0.563, y = 0.441},
}

hooksecurefunc(ns.Handler, 'GOSSIP_SHOW', function(self)
	if(IsShiftKeyDown()) then
		 -- temporary disable
		return
	end

	local npcID = self:GetNPCID()
	if (npcID == 145743) then
		self:Enable(DARKSHORE)

		for index = 1, GetNumGossipOptions() do
			local text = select((index * 2) - 1, GetGossipOptions())
			local loc = destinations[text]
			if(loc) then
				local Marker = self:GetMarker()
				Marker:SetID(index)
				Marker:SetNormalAtlas('Taxi_Frame_Gray')
				Marker:SetHighlightAtlas('Taxi_Frame_Yellow')
				Marker:SetSize(24)
				Marker:SetName(text)

				HBDP:AddWorldMapIconMap(self, Marker, DARKSHORE, loc.x, loc.y)
			end
		end
	end
end)