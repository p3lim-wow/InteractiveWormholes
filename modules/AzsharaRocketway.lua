local addon = select(2, ...)
local L = addon.L
local HBD = LibStub('HereBeDragons-2.0')

local AZSHARA = 76
local ROCKET_JOCKEY = 43217
local WARNING = L['The rocket might not land exactly where you\'d expect, nor take the path exactly as shown.']

local destinations = {
	[L['Northern Rocketway Terminus']]  = {x = 0.6638, y = 0.2082, index = 1},
	[L['Northern Rocketway Exchange']]  = {x = 0.4248, y = 0.2478, index = 2},
	[L['Gallywix Rocketway Exchange']]  = {x = 0.2579, y = 0.4962, index = 3},
	[L['Orgrimmar Rocketway Exchange']] = {x = 0.2950, y = 0.6595, index = 4},
	[L['Southern Rocketway Terminus']]  = {x = 0.5078, y = 0.7403, index = 5},
}

addon:Add(function(self)
	if self:GetNPCID() ~= ROCKET_JOCKEY then
		return
	end

	self:SetMapID(AZSHARA)

	local Source = self:NewMarker()
	Source:SetTitle(L['You are here'])
	Source:SetNormalAtlas('Taxi_Frame_Green')
	Source:SetHighlightAtlas('Taxi_Frame_Green')
	Source:SetSize(24)

	-- figure out which rocketway location the player is at
	local sourceLocation, shortestPath
	local playerX, playerY = HBD:GetPlayerZonePosition()
	for _, dest in next, destinations do
		local distance = HBD:GetZoneDistance(AZSHARA, playerX, playerY, AZSHARA, dest.x, dest.y)
		if distance < (shortestPath or math.huge) then
			shortestPath = distance
			sourceLocation = dest
		end
	end

	Source:Pin(AZSHARA, sourceLocation.x, sourceLocation.y)

	local markers = {} -- used to set source
	for index, line in next, self:GetLines() do
		for name, dest in next, destinations do
			if line:match(name) then
				local Marker = self:NewMarker()
				Marker:SetID(index)
				Marker:SetTitle(name)
				Marker:SetDescription(WARNING)
				Marker:SetNormalAtlas('Taxi_Frame_Gray')
				Marker:SetHighlightAtlas('Taxi_Frame_Yellow')
				Marker:SetSize(24)
				Marker:Pin(AZSHARA, dest.x, dest.y, true)

				markers[dest.index] = Marker
			end
		end
	end

	-- once the markers have been rendered we can calculate and set their sources
	for index, Marker in next, markers do
		if index > sourceLocation.index then
			if sourceLocation.index == (index - 1) then
				Marker:SetSource(Source, true)
			else
				Marker:SetSource(markers[index - 1], true)
			end
		elseif index < sourceLocation.index then
			if sourceLocation.index == (index + 1) then
				Marker:SetSource(Source, true)
			else
				Marker:SetSource(markers[index + 1], true)
			end
		end
	end

	return true
end)
