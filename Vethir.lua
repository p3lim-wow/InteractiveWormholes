local addonName, ns = ...
local L = ns.L

local HBDP = LibStub('HereBeDragons-Pins-2.0')

local STORMHEIM = 634
local destinations = {
	{x = 0.45, y = 0.77, name = L['Galebroken Path'], natlas = 'Taxi_Frame_Gray', hatlas = 'Taxi_Frame_Yellow', size = 24},
	{x = 0.43, y = 0.82, name = L['Thorignir Refuge'], natlas = 'Taxi_Frame_Gray', hatlas = 'Taxi_Frame_Yellow', size = 24},
	{x = 0.41, y = 0.80, name = L['Thorim\'s Peak'], natlas = 'Taxi_Frame_Gray', hatlas = 'Taxi_Frame_Yellow', size = 24},
	{x = 0.43, y = 0.67, name = L['Cry More Thunder!'], natlas = 'ShipMissionIcon-Combat-Map', hatlas = 'ShipMissionIcon-Combat-Map', size = 40},
}

local PlayerMarker = CreateFrame('Frame')
PlayerMarker:SetSize(1, 1)

hooksecurefunc(ns.Handler, 'GOSSIP_SHOW', function(self)
	if(IsShiftKeyDown()) then
		 -- temporary disable
		return
	end

	local npcID = self:GetNPCID()
	if(npcID == 108685) then
		self:Enable(STORMHEIM)

		local x, y = C_Map.GetPlayerMapPosition(STORMHEIM, 'player'):GetXY()
		HBDP:AddWorldMapIconMap(self, PlayerMarker, STORMHEIM, x, y)

		for index = 1, GetNumGossipOptions() do
			local loc = destinations[index]

			local Marker = self:GetMarker()
			Marker:SetID(index)
			Marker:SetNormalAtlas(loc.natlas)
			Marker:SetHighlightAtlas(loc.hatlas)
			Marker:SetSize(loc.size)
			Marker:SetName(loc.name)
			Marker:SetSource(index ~= 4 and PlayerMarker)

			HBDP:AddWorldMapIconMap(self, Marker, STORMHEIM, loc.x, loc.y)
		end
	end
end)
