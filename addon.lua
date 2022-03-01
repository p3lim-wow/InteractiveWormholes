local addonName, addon = ...

-- we store the original CloseGossip API because we have to override it to prevent the gossiping
-- from ending when we open up the map, and the alternative (disabling what's calling CloseGossip)
-- will taint during combat
local CloseGossip = C_GossipInfo.CloseGossip

local moduleCallbacks, hideCallbacks
local markerPool = CreateObjectPool(addon.private.createMarker, addon.private.resetMarker)
addon.private = nil -- it's called private for a reason

local function getActiveModuleCallback()
	for _, callbacks in next, moduleCallbacks do
		if callbacks.showCondition(addon, addon:GetNPCID()) then
			return callbacks.moduleCallback
		end
	end
end

local HBD = LibStub('HereBeDragons-2.0')
local Handler = CreateFrame('Frame')

-- create a button that will be shown in the gossip frame whenever we're in combat
-- to let the player open the map manually
local MapButton = CreateFrame('Button', addonName .. 'MapButton', GossipFrame, 'SecureActionButtonTemplate')
MapButton:SetSize(48, 32)
MapButton:SetPoint('TOPRIGHT', 0, -26)
MapButton:SetAttribute('type', 'macro')
MapButton:SetAttribute('macrotext', '/click QuestLogMicroButton')
MapButton:SetAlpha(0)
MapButton:HookScript('PreClick', function()
	-- we'll need to prevent the gossip from being closed before we show the map with the secure
	-- macro, then trigger the callback after the map has been shown
	C_GossipInfo.CloseGossip = nop -- possibly destructive for other addons
end)
MapButton:HookScript('PostClick', function()
	local moduleCallback = getActiveModuleCallback()
	if moduleCallback then
		moduleCallback(addon, addon:GetNPCID())
	end
end)

local Texture = MapButton:CreateTexture('$parentTexture', 'ARTWORK')
Texture:SetPoint('RIGHT')
Texture:SetSize(48, 32)
Texture:SetTexture([[Interface\QuestFrame\UI-QuestMap_Button]])
Texture:SetTexCoord(0.125, 0.875, 0, 0.5)

local Highlight = MapButton:CreateTexture('$parentHighlight', 'HIGHLIGHT')
Highlight:SetPoint('RIGHT', -7, 0)
Highlight:SetSize(32, 25)
Highlight:SetTexture([[Interface\Buttons\ButtonHilight-Square]])
Highlight:SetBlendMode('ADD')

--[[ addon:Add(_showCallback_, _markerCallback_)
Adds callbacks that will be triggered when interacting with an NPC that has gossip options.  
The _`showCondition`_ must return true for when the addon should activate its logic.  
The _`moduleCallback`_ will be run to when the map is shown while the show condition is true.

This is merely the event `GOSSIP_SHOW` with some pre-processing.

* `showCondition`
   * signature:
      * `self`  - the [addon](Addon) namespace
      * `npcID` - ID of the interacting object (e.g. NPC)
* `moduleCallback`
   * signature:
      * `self`  - the [addon](Addon) namespace
      * `npcID` - ID of the interacting object (e.g. NPC)
--]]
function addon:Add(showCondition, moduleCallback)
	if not moduleCallbacks then
		moduleCallbacks = {}
	end

	table.insert(moduleCallbacks, {
		showCondition = showCondition,
		moduleCallback = moduleCallback,
	})
end

--[[ addon:Remove(_callback_)
Adds a new callback that will be triggered when ending the interaction with an NPC that has gossip options.

This is merely the event `GOSSIP_CLOSED` with some pre-processing.

* `callback` - function that will be called when ending interaction with a gossip NPC _(function)_
   * signature:
      * `self` - the [addon](Addon) namespace
--]]
function addon:Remove(callback)
	if not hideCallbacks then
		hideCallbacks = {}
	end

	table.insert(hideCallbacks, callback)
end

--[[ addon:RemoveAll()
Removes all markers on the map.
--]]
function addon:RemoveAll()
	if markerPool then
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
	C_GossipInfo.CloseGossip = nop -- possibly destructive for other addons

	if not WorldMapFrame:IsShown() and not InCombatLockdown() then
		ToggleWorldMap()
	end

	WorldMapFrame:SetMapID(mapID)
end

--[[ addon:GetMapID()
Returns the map ID of the zone that should be displayed, if any.
--]]
function addon:GetMapID()
	return self.mapID
end

--[[ addon:IsActive()
Returns `true`/`false` if the map is rendering markers.
--]]
function addon:IsActive()
	return Handler:IsEventRegistered('GOSSIP_CLOSED')
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

--[[ addon:GetNumLines()
Returns the number of gossip options the currently interacted NPC has to offer.  
--]]
function addon:GetNumLines()
	return C_GossipInfo.GetNumOptions()
end

--[[ addon:SelectGossipLine(_text_)
An alternative to [SelectGossipOption]() that selects the line by text instead of index.  
Returns true/false if the option exists and was clicked.

* `text` - Full or partial text of a gossip line.
--]]
function addon:SelectGossipLine(text)
	for index, line in next, addon:GetLines() do
		if line:match(text) then
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

Handler:RegisterEvent('GOSSIP_SHOW')
Handler:SetScript('OnEvent', function(self, event)
	if event == 'GOSSIP_SHOW' then
		local moduleCallback = getActiveModuleCallback()
		if moduleCallback then
			table.wipe(lines)

			for _, info in next, C_GossipInfo.GetOptions() do
				table.insert(lines, info.name)
			end

			if IsShiftKeyDown() or InCombatLockdown() then
				-- show the map button in the gossip whenever the user is in combat or holds shift
				MapButton:SetAlpha(1)
			else
				moduleCallback(addon, addon:GetNPCID())
			end
		end
	elseif event == 'GOSSIP_CLOSED' then
		self:UnregisterEvent(event)
		C_GossipInfo.CloseGossip = CloseGossip

		if not InCombatLockdown() and WorldMapFrame:IsShown() then
			ToggleWorldMap()
		end

		addon:RemoveAll()
		MapButton:SetAlpha(0)
	end
end)

WorldMapFrame:HookScript('OnHide', function()
	if addon:IsActive() then
		CloseGossip()
	end
end)
