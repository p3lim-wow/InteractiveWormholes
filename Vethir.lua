local addonName, L = ...

local HBDP = LibStub('HereBeDragons-Pins-1.0')

local destinations = {
	{x = 0.45, y = 0.77, name = L['Galebroken Path']},
	{x = 0.43, y = 0.82, name = L['Thorignir Refuge']},
	{x = 0.41, y = 0.80, name = L['Thorim\'s Peak']},
	{x = 0.43, y = 0.67, name = L['Cry More Thunder!']},
}

local Overlay = _G[addonName .. 'MapFrame']
Overlay:HookScript('OnEvent', function(self, event)
	if(event == 'GOSSIP_SHOW') then
		local npcID = tonumber(string.match(UnitGUID('npc') or '', '%w+%-.-%-.-%-.-%-.-%-(.-)%-'))
		if(npcID == 108685) then
			self:Enable(1017)

			for index = 1, GetNumGossipOptions() do
				local location = destinations[index]

				local atlas, highlightAtlas, size
				if(index == 4) then
					atlas = 'ShipMissionIcon-Combat-Map'
					highlightAtlas = atlas
					size = 40
				else
					atlas = 'Taxi_Frame_Gray'
					highlightAtlas = 'Taxi_Frame_Yellow'
					size = 24
				end

				local Marker = self:SetMarker(index, atlas, highlightAtlas, size)
				Marker.name = location.name
				Marker.accucate = nil
				Marker.inaccurate = nil

				HBDP:AddWorldMapIconMF(self, Marker, 1017, 0, location.x, location.y)
			end
		end
	end
end)
