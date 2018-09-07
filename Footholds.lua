local addonName, ns = ...
local L = ns.L

local HBD = LibStub('HereBeDragons-2.0')
local HBDP = LibStub('HereBeDragons-Pins-2.0')

local faction = UnitFactionGroup('player')
local factionInfo, destinations
if(faction == 'Horde') then
	factionInfo = {
		npc = 135690, -- Dread-Admiral Tattersail
		continent = 876,
		size = 40,
		atlas = 'bfa-landingbutton-horde-up',
		highlight = 'bfa-landingbutton-horde-diamondhighlight',
	}

	destinations = {
		-- Kul Tiras zones
		[HBD:GetLocalizedMap(896)] = {x = 0.2061, y = 0.4569, zone = 896}, -- Drustvar
		[HBD:GetLocalizedMap(942)] = {x = 0.5198, y = 0.2449, zone = 942}, -- Stormsong Valley
		[HBD:GetLocalizedMap(895)] = {x = 0.8820, y = 0.5116, zone = 895}, -- Tiragarde Sound
	}
elseif(faction == 'Alliance') then
	factionInfo = {
		npc = 135681, -- Grand Admiral Jes-Tereth
		continent = 875,
		size = 40,
		atlas = 'bfa-landingbutton-alliance-up',
		highlight = 'bfa-landingbutton-alliance-shieldhighlight',
	}

	destinations = {
		-- Zandalar zones
		[HBD:GetLocalizedMap(862)] = {x = 0.4068, y = 0.7085, zone = 862}, -- Zuldazar
		[HBD:GetLocalizedMap(863)] = {x = 0.6196, y = 0.4020, zone = 863}, -- Nazmir
		[HBD:GetLocalizedMap(864)] = {x = 0.3560, y = 0.3317, zone = 864}, -- Vol'dun
	}
else
	-- no point loading for pandas
	return
end

hooksecurefunc(ns.Handler, 'GOSSIP_SHOW', function(self)
	if(IsShiftKeyDown()) then
		 -- temporary disable
		return
	end

	local npcID = self:GetNPCID()
	if(factionInfo.npc == npcID) then
		self:Enable(factionInfo.continent)

		for index = 1, GetNumGossipOptions() do
			local text = select((index * 2) - 1, GetGossipOptions())
			for zoneName, data in next, destinations do
				if(text:match(zoneName)) then
					local Marker = self:GetMarker()
					Marker:SetID(index)
					Marker:SetNormalAtlas(factionInfo.atlas)
					Marker:SetHighlightAtlas(factionInfo.highlight, true)
					Marker:SetSize(factionInfo.size)

					if(text:match('FF0000FF')) then
						Marker:MarkQuest()
					end

					HBDP:AddWorldMapIconMap(self, Marker, data.zone, data.x, data.y, HBD_PINS_WORLDMAP_SHOW_CONTINENT)
					break
				end
			end
		end
	end
end)
