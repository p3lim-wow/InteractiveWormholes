local _, addon = ...

local HBD = LibStub('HereBeDragons-2.0')

local showCallbacks, hideCallbacks
local markerPool = CreateObjectPool(addon.private.createMarker, addon.private.resetMarker)
addon.private = nil -- it's called private for a reason

local Handler = CreateFrame('Frame')
--[[ addon:Add(_callback_)
Adds a new callback that will be triggered when interacting with an NPC that has gossip options.

This is merely the event `GOSSIP_SHOW` with some pre-processing.

* `callback` - function that will be called when interacting with a gossip NPC _(function)_
   * signature:
      * `self` - the [addon](Addon) namespace
--]]
function addon:Add(callback)
	if(not showCallbacks) then
		showCallbacks = {}
	end

	table.insert(showCallbacks, callback)
end

--[[ addon:Remove(_callback_)
Adds a new callback that will be triggered when ending the interaction with an NPC that has gossip options.

This is merely the event `GOSSIP_CLOSED` with some pre-processing.

* `callback` - function that will be called when ending interaction with a gossip NPC _(function)_
   * signature:
      * `self` - the [addon](Addon) namespace
--]]
function addon:Remove(callback)
	if(not hideCallbacks) then
		hideCallbacks = {}
	end

	table.insert(hideCallbacks, callback)
end

--[[ addon:RemoveAll()
Removes all markers on the map.
--]]
function addon:RemoveAll()
	if(markerPool) then
		markerPool:ReleaseAll()
	end

	if hideCallbacks then
		for _, callback in next, hideCallbacks do
			callback(addon)
		end
	end
end

--[[ addon:NewMarker()
Creates and returns a new [Marker](Marker).
--]]
function addon:NewMarker()
	return markerPool:Acquire()
end

--[[ addon:SetMapID(_mapID_)
Opens up the world map to the desired zone by map ID.

* `mapID` - the map ID of the zone to display _(integer)_
--]]
function addon:SetMapID(mapID)
	Handler:RegisterEvent('GOSSIP_CLOSED')
	CustomGossipFrameManager:SetScript('OnEvent', nil)
	GossipFrame:SetScript('OnHide', nil)

	-- OpenWorldMap(mapID) -- doesn't work properly for whatever reason
	if(not WorldMapFrame:IsShown()) then
		ToggleWorldMap()
	end

	WorldMapFrame:SetMapID(mapID)
end

--[[ addon:GetNPCID()
Returns the currently interacted NPC's ID.
--]]
function addon:GetNPCID()
	return tonumber(string.match(UnitGUID('npc') or '', '%w+%-.-%-.-%-.-%-.-%-(.-)%-')) or 0
end

--[[ addon:GetMapName(_mapID_)
Returns the localized name for the given map by ID.

Just a shorthand for HereBeDragons' `GetLocalizedMap` method.

* `mapID` - the map ID of the zone to display _(integer)_
--]]
function addon:GetMapName(mapID)
	return HBD:GetLocalizedMap(mapID)
end

local lines = {}
--[[ addon:GetLines()
Returns a key/value pair table of all gossip options the currently interacted NPC has to offer.

The _key_ is the gossip option's index (used for [Marker:SetID()](Marker#setid)).  
The _value_ is the gossip option's raw text.
--]]
function addon:GetLines()
	-- populated during GOSSIP_SHOW in the event handler
	return lines
end

--[[ addon:SelectGossipLine(_text_)
An alternative to [SelectGossipOption]() that selects the line by text instead of index.  
Returns true/false if the option exists and was clicked.

* `text` - Full or partial text of a gossip line.
--]]
function addon:SelectGossipLine(text)
	for index, line in next, addon:GetLines() do
		if(line:match(text)) then
			addon:SelectGossipIndex(index)
			return true
		end
	end
end

--[[ addon:SelectGossipIndex(_index_)
A wrapper for [SelectGossipOption]().

* `index` - Index of a gossip option.
--]]
function addon:SelectGossipIndex(index)
	-- TODO: verify that the option exists first
	C_GossipInfo.SelectOption(index)
end

local origGossipHide = GossipFrame:GetScript('OnHide')
Handler:RegisterEvent('GOSSIP_SHOW')
Handler:SetScript('OnEvent', function(self, event, ...)
	if(event == 'GOSSIP_SHOW') then
		if(IsShiftKeyDown()) then
			-- bail out in case the user wants to access the original gossip menu
			return
		end

		table.wipe(lines)

		for _, info in next, C_GossipInfo.GetOptions() do
			table.insert(lines, info.name)
		end

		for _, callback in next, showCallbacks do
			callback(addon)
		end
	elseif(event == 'GOSSIP_CLOSED') then
		self:UnregisterEvent(event)
		CustomGossipFrameManager:SetScript('OnEvent', CustomGossipManagerMixin.OnEvent)
		GossipFrame:SetScript('OnHide', origGossipHide)

		if(WorldMapFrame:IsShown()) then
			ToggleWorldMap()
		end

		addon:RemoveAll()
	end
end)

WorldMapFrame:HookScript('OnHide', function()
	if(Handler:IsEventRegistered('GOSSIP_CLOSED')) then
		C_GossipInfo.CloseGossip()
	end
end)
