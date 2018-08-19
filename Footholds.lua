local addonName, ns = ...
local L = ns.L

local HBDP = LibStub('HereBeDragons-Pins-2.0')

local faction = UnitFactionGroup('player')
local destinations = {
	[135690] = { -- Horde: Dread-Admiral Tattersail
		{x = 0.2061, y = 0.4569, zone = 896}, -- Drustvar
		{x = 0.5198, y = 0.2449, zone = 942}, -- Stormsong Valley
		{x = 0.8820, y = 0.5116, zone = 895}, -- Tiragarde Sound
		continent = 876,
		size = 40,
		atlas = 'bfa-landingbutton-horde-up',
		highlight = 'bfa-landingbutton-horde-diamondhighlight',
	},
	-- [] = { -- Alliance: 
	-- 	{x = 0., y = 0., zone = }, -- 
	-- 	{x = 0., y = 0., zone = }, -- 
	-- 	{x = 0., y = 0., zone = }, -- 
	-- 	continent = 875,
	-- 	size = 40,
	-- 	natlas = 'bfa-landingbutton-alliance-up',
	-- 	hatlas = 'bfa-landingbutton-alliance-shieldhighlight',
	-- }
}

hooksecurefunc(ns.Handler, 'GOSSIP_SHOW', function(self)
	if(IsShiftKeyDown()) then
		 -- temporary disable
		return
	end

	local npcID = self:GetNPCID()
	local npcDestinations = destinations[npcID]
	if(npcDestinations) then
		self:Enable(npcDestinations.continent)

		for index = 1, GetNumGossipOptions() do
			local loc = npcDestinations[index]

			local Marker = self:GetMarker()
			Marker:SetID(index)
			Marker:SetNormalAtlas(npcDestinations.atlas)
			Marker:SetHighlightAtlas(npcDestinations.highlight, true)
			Marker:SetSize(npcDestinations.size)

			HBDP:AddWorldMapIconMap(self, Marker, loc.zone, loc.x, loc.y, HBD_PINS_WORLDMAP_SHOW_CONTINENT)
		end
	end
end)
