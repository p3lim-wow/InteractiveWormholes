local _, addon = ...
local L = addon.L

local HBDP = LibStub('HereBeDragons-Pins-2.0')

local Parent = CreateFrame('Frame')
local Line = Parent:CreateLine(nil, 'OVERLAY')
Line:SetNonBlocking(true)
Line:SetAtlas('_UI-Taxi-Line-horizontal')
Line:SetThickness(32)

local function OnClick(self)
	if(self:IsEnabled()) then
		addon:SelectGossipIndex(self:GetID())
	end
end

local tooltip = WorldMapTooltip or GameTooltip
local function OnEnter(self)
	if(self.source) then
		Line:SetParent(self)
		Line:SetStartPoint('CENTER', self.source)
		Line:SetEndPoint('CENTER', self)
		Line:Show()
	end

	tooltip:SetOwner(self, 'ANCHOR_RIGHT')
	tooltip:AddLine(self.title or L['Click to travel'], 1, 1, 1)

	if(self.description) then
		tooltip:AddLine(self.description, nil, nil, nil, true)
	end

	tooltip:Show()
end

local function OnLeave(self)
	Line:Hide()
	tooltip:Hide()
end

local function OnAnimate(self)
	self.up = not self.up

	self.Arrow:SetPoint('BOTTOM', self.Marker, 'TOP', 0, self.up and 10 or 0)
	self.Bounce:SetSmoothing(self.up and 'OUT' or 'IN')
	self.Bounce:SetOffset(0, self.up and -10 or 10)
	self:Play()
end

local markerMixin = {}
--[[ Marker:Pin(_mapID, x, y[, showContinent][, showWorld]_)
Adds the Marker to the world map.

* `mapID`         - the map ID of the zone to display the Marker in _(integer)_
* `x`             - the x-axis coordinate to place the Marker _(float)_
* `y`             - the y-axis coordinate to place the Marker _(float)_
* `showContinent` - show the Marker on the relative Continent for the zone _(boolean)_
   * _optional, defaults to `false`_
* `showWorld`     - show the Marker on the World map _(boolean)_
   * _optional, defaults to `false`_
--]]
function markerMixin:Pin(mapID, x, y, showContinent, showWorld)
	local flag
	if(showWorld) then
		flag = HBD_PINS_WORLDMAP_SHOW_WORLD
	elseif(showContinent) then
		flag = HBD_PINS_WORLDMAP_SHOW_CONTINENT
	end

	HBDP:AddWorldMapIconMap(Parent, self, mapID, x, y, flag, 'PIN_FRAME_LEVEL_TOPMOST')
end

--[[ Marker:SetTitle(_title_)
Sets the tooltip title shown when hovering the Marker.

* `title` - Any valid string _(string)_
--]]
function markerMixin:SetTitle(title)
	self.title = title
end

--[[ Marker:GetTitle()
Returns the tooltip title shown when hovering the Marker.
--]]
function markerMixin:GetTitle()
	return self.title
end

--[[ Marker:SetDescription(_desc_)
Sets the tooltip text shown when hovering the Marker.

* `desc` - Any valid string _(string)_
--]]
function markerMixin:SetDescription(desc)
	self.description = desc
end

--[[ Marker:GetDescription()
Returns the tooltip text shown when hovering the Marker.
--]]
function markerMixin:GetDescription()
	return self.description
end

--[[ Marker:SetNormalAtlas(_atlas_)
Sets the normal atlas texture displayed on the Marker.

* `atlas` - Any valid atlas name _(string)_
--]]
function markerMixin:SetNormalAtlas(atlas)
	self.Texture:SetAtlas(atlas)
end

--[[ Marker:SetHighlightAtlas(_atlas[, add]_)
Sets the atlas texture displayed when hovering the the Marker.

* `atlas` - Any valid atlas name _(string)_
* `add`   - Wether to use addative blending or not _(boolean)_
   * _optional, defaults to `false`_
--]]
function markerMixin:SetHighlightAtlas(atlas, add)
	self.Highlight:SetAtlas(atlas)
	self.Highlight:SetBlendMode(add and 'ADD' or 'BLEND')
end

--[[ Marker:SetSize(_width[, height]_)
Sets the size of the Marker.

* `width`  - The width of the Marker (integer)
* `height` - The height of the Marker (integer)
   * _optional, uses the `width` if not defined_
--]]
function markerMixin:SetSize(width, height)
	self:SetWidth(width)
	self:SetHeight(height or width)
	self.Arrow:SetSize(width, width)
end

--[[ Marker:MarkQuest()
Calling this method will show a quest indicator on the Marker.
--]]
function markerMixin:MarkQuest()
	self.Quest:Show()
end

--[[ Marker:SetSource(_Marker_)
Sets the source Marker used to draw lines _from_.  
This is typically used for taxi-esque markers.

* `Marker` - The parent Marker to treat as a source _(Marker)_
--]]
function markerMixin:SetSource(Marker)
	self.source = Marker
	-- Marker:UseFrameLevelType('PIN_FRAME_LEVEL_FLIGHT_POINT')
end

--[[ Marker:DisableArrow()
Disables the bouncing arrow above the Marker.
--]]
function markerMixin:DisableArrow()
	self.Arrow:Hide()
end

--[[ Marker:Disable()
Disables the Marker and desatures its texture/atlas.
--]]
function markerMixin:Disable()
	self.Texture:SetDesaturated(true)
	self.disabled = true
end

--[[ Marker:Enable()
Enables the Marker and re-saturates its texture/atlas.
--]]
function markerMixin:Enable()
	self.Texture:SetDesaturated(false)
	self.disabled = false
end

--[[ Marker:IsEnabled()
Returns `true` or `false` whether the Marker is enabled or not.
--]]
function markerMixin:IsEnabled()
	return not self.disabled
end

--[[ Marker:SetID(_id_)
Sets the ID of the Marker, used to select the gossip option when the Marker is clicked.  
See [addon:GetLines()](Addon#getlines).

* `id` - The ID/index of a gossip options _(integer)_
--]]

addon.private = {} -- this gets removed in addon.lua once used
function addon.private.createMarker()
	local Marker = CreateFrame('Button')
	Marker:SetScript('OnClick', OnClick)
	Marker:SetScript('OnEnter', OnEnter)
	Marker:SetScript('OnLeave', OnLeave)

	local Texture = Marker:CreateTexture(nil, 'BACKGROUND')
	Texture:SetAllPoints()
	Marker.Texture = Texture

	local Highlight = Marker:CreateTexture(nil, 'HIGHLIGHT')
	Highlight:SetAllPoints()
	Marker.Highlight = Highlight

	local Quest = Marker:CreateTexture(nil, 'OVERLAY')
	Quest:SetPoint('CENTER')
	Quest:SetSize(20, 20)
	Quest:SetAtlas('QuestNormal')
	Quest:Hide()
	Marker.Quest = Quest

	local Arrow = Marker:CreateTexture(nil, 'OVERLAY')
	Arrow:SetPoint('BOTTOM', Marker, 'TOP')
	Arrow:SetTexture([[Interface\Minimap\Minimap-DeadArrow]])
	Arrow:SetTexCoord(0, 1, 1, 0)
	Marker.Arrow = Arrow

	local Animation = Arrow:CreateAnimationGroup()
	Animation:SetScript('OnFinished', OnAnimate)

	local Bounce = Animation:CreateAnimation('Translation')
	Bounce:SetOffset(0, 10)
	Bounce:SetDuration(0.5)
	Bounce:SetSmoothing('IN')

	Animation.Marker = Marker
	Animation.Arrow = Arrow
	Animation.Bounce = Bounce
	Animation:Play()

	Mixin(Marker, markerMixin)

	return Marker
end

function addon.private.resetMarker(_, Marker)
	Marker.title = nil
	Marker.description = nil
	Marker.source = nil
	Marker.disabled = false

	Marker:SetID(0)
	Marker:SetSize(24)
	Marker:SetScript('OnClick', OnClick)
	Marker:SetScript('OnEnter', OnEnter)
	Marker:SetScript('OnLeave', OnLeave)
	Marker.Texture:SetDesaturated(false)
	Marker.Quest:Hide()
	Marker.Arrow:Show()

	HBDP:RemoveWorldMapIcon(Parent, Marker)
end
