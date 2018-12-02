local addonName, ns = ...
local L = ns.L

local HBDP = LibStub('HereBeDragons-Pins-2.0')

local UNDERBELLY = 628
local destinations = {
	[L['Sewer Guard Station']] = {x = 0.685, y = 0.570},
	[L['Black Market']]        = {x = 0.700, y = 0.167},
	[L['Inn Entrance']]        = {x = 0.673, y = 0.691},
	[L['Alchemists\' Lair']]   = {x = 0.781, y = 0.796},
	[L['Abandoned Shack']]     = {x = 0.425, y = 0.516},
	[L['Rear Entrance']]       = {x = 0.307, y = 0.467}
}

hooksecurefunc(ns.Handler, 'GOSSIP_SHOW', function(self)
	if(IsShiftKeyDown()) then
		 -- temporary disable
		return
	end

	local npcID = self:GetNPCID()
	if(npcID >= 107779 and npcID <= 107784) then
		self:Enable(UNDERBELLY)

		for index = 1, GetNumGossipOptions() do
			local text = select((index * 2) - 1, GetGossipOptions())
			local loc = destinations[text]
			if(loc) then
				local Marker = self:GetMarker()
				Marker:SetID(index)
				Marker:SetNormalAtlas('spell_arcane_portaldalarancrater')
				Marker:SetHighlightAtlas('spell_arcane_portaldalaran')
				Marker:SetSize(24)
				Marker:SetName(text)

				HBDP:AddWorldMapIconMap(self, Marker, UNDERBELLY, loc.x, loc.y)
			end
		end
	end
end)
