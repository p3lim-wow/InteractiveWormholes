local _, addon = ...

function addon:TranslatePosition(mapID, x, y, destinationMapID)
	local continentID, continentPos = C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(x, y))
	local _, pos = C_Map.GetMapPosFromWorldPos(continentID, continentPos, destinationMapID)
	return pos
end
