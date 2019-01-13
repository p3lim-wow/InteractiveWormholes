local _, addon = ...

local HBD = LibStub('HereBeDragons-2.0')

local showCallbacks, hideCallbacks
local markerPool = CreateObjectPool(addon.private.createMarker, addon.private.resetMarker)
addon.private = nil -- it's called private for a reason

local Handler = CreateFrame('Frame')
--[[ addon:Add(callback)
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

--[[ addon:Remove(callback)
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

--[[ addon:NewMarker()
Creates and returns a new [Marker](Marker).
--]]
function addon:NewMarker()
	return markerPool:Acquire()
end

--[[ addon:SetMapID(mapID)
Opens up the world map to the desired zone by map ID.

* `mapID` - the map ID of the zone to display _(integer)_
--]]
function addon:SetMapID(mapID)
	Handler:RegisterEvent('GOSSIP_CLOSED')
	GossipFrame:UnregisterEvent('GOSSIP_CLOSED')
	GossipFrame:SetScript('OnHide', nil)

	if(not WorldMapFrame:IsShown()) then
		ToggleWorldMap()
	end

	-- OpenWorldMap(mapID)
	WorldMapFrame:SetMapID(mapID)
end

--[[ addon:GetNPCID()
Returns the currently interacted NPC's ID.
--]]
function addon:GetNPCID()
	return tonumber(string.match(UnitGUID('npc') or '', '%w+%-.-%-.-%-.-%-.-%-(.-)%-'))
end

--[[ addon:GetMapName(_mapID_)
Returns the localized name for the given map by ID.

Just a shorthand for HereBeDragons' `GetLocalizedMap` method.
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

* `text` - The full text of a line.
--]]
function addon:SelectGossipLine(text)
	for index, line in next, addon:GetLines() do
		if(line == text) then
			SelectGossipOption(index)
			return true
		end
	end
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
		for index = 1, GetNumGossipOptions() do
			-- this indexed crap is a pain to work with, tables are much nicer
			table.insert(lines, (select((index * 2) - 1, GetGossipOptions())))
		end

		for _, callback in next, showCallbacks do
			callback(addon)
		end
	elseif(event == 'GOSSIP_CLOSED') then
		self:UnregisterEvent(event)
		GossipFrame:RegisterEvent('GOSSIP_CLOSED')
		GossipFrame:SetScript('OnHide', origGossipHide)

		if(WorldMapFrame:IsShown()) then
			ToggleWorldMap()
		end

		if(markerPool) then
			markerPool:ReleaseAll()
		end

		for _, callback in next, hideCallbacks do
			callback(addon)
		end
	end
end)

WorldMapFrame:HookScript('OnHide', function()
	if(Handler:IsEventRegistered('GOSSIP_CLOSED')) then
		CloseGossip()
	end
end)
