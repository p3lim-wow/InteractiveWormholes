local addonName, ns = ...
local L = ns.L

local HBDP = LibStub('HereBeDragons-Pins-2.0')

local UNDERBELLY = 628
local destinations = {
	{x = 0.69, y = 0.57, name = L['Sewer Guard Station']},
	{x = 0.69, y = 0.17, name = L['Black Market']},
	{x = 0.67, y = 0.70, name = L['Inn Entrance']},
	{x = 0.78, y = 0.80, name = L['Alchemists\' Lair']},
	{x = 0.43, y = 0.52, name = L['Abandoned Shack']},
	{x = 0.306, y = 0.467, name = L['Rear Entrance']}
}

local PlayerMarker = CreateFrame('Frame')
PlayerMarker:SetSize(1, 1)

hooksecurefunc(ns.Handler, 'GOSSIP_SHOW', function(self)
	if(IsShiftKeyDown()) then
		 -- temporary disable
		return
	end

	local npcID = self:GetNPCID()
	if (npcID >= 107779) and (npcID <= 107784) then
		-- 107779 = Sewer Guard Station
		-- 107780 = Black Market
		-- 107781 = Inn Entrance
		-- 107782 = Alchemists' Lair
		-- 107783 = Abandoned Shack
		-- 107784 = Rear Entrance
		self:Enable(UNDERBELLY)

		local x, y = C_Map.GetPlayerMapPosition(UNDERBELLY, 'player'):GetXY()
		HBDP:AddWorldMapIconMap(self, PlayerMarker, UNDERBELLY, x, y)

		for index = 1, GetNumGossipOptions() do
			local text = select((index * 2) - 1, GetGossipOptions())
			for i=1, table.getn(destinations) do
				if(text:match(destinations[i].name)) then
					local Marker = self:GetMarker()
					Marker:SetID(index)
					Marker:SetNormalAtlas('spell_arcane_portaldalarancrater')
					Marker:SetHighlightAtlas('spell_arcane_portaldalaran')
					Marker:SetSize(24)
					Marker:SetName(destinations[i].name)

					HBDP:AddWorldMapIconMap(self, Marker, UNDERBELLY, destinations[i].x, destinations[i].y)
					break
				end --if
			end --for
		end
	end
end)
