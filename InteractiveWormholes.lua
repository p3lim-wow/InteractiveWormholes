local addonName, ns = ...
local L = ns.L

local HBD = LibStub('HereBeDragons-2.0')
local HBDP = LibStub('HereBeDragons-Pins-2.0')

local wormholes = {
	[35646] = { -- Wormhole Generator: Northrend
		{zone = 114, x = 0.5178, y = 0.4503}, -- Borean Tundra
		{zone = 117, x = 0.5853, y = 0.4863}, -- Howling Fjord
		{zone = 119, x = 0.4921, y = 0.3962}, -- Sholozar Basin
		{zone = 118, x = 0.6287, y = 0.2692}, -- Icecrown
		{zone = 120, x = 0.4390, y = 0.2580}, -- Storm Peaks
		{ -- Underground... (Dalaran, Crystalsong Forest)
			zone = 127, x = 0.3404, y = 0.3549,
			name = (GetSpellInfo(68081)),
			natlas = 'VignetteLootElite',
		},
		continent = 113, -- Northrend
	},
	[81205] = { -- Wormhole Centrifuge
		{zone = 542, x = 0.52, y = 0.33}, -- "A jagged landscape" (Spires of Arak)
		{zone = 535, x = 0.58, y = 0.65}, -- "A reddish-orange forest" (Talador)
		{zone = 539, x = 0.49, y = 0.52}, -- "Shadows..." (Shadowmoon Valley)
		{zone = 552, x = 0.73, y = 0.54}, -- "Grassy plains" (Nagrand)
		{zone = 543, x = 0.53, y = 0.61}, -- "Primal forest" (Gorgrond)
		{zone = 525, x = 0.59, y = 0.49}, -- "Lava and snow" (Frostfire Ridge)
		inaccurate = true,
		continent = 572, -- Draenor
	},
	[101462] = { -- Reaves (with Wormhole Generator module)
		{zone = 630, x = 0.47, y = 0.49}, -- Azsuna
		{zone = 641, x = 0.56, y = 0.66}, -- Val'sharah
		{zone = 650, x = 0.45, y = 0.56}, -- Highmountain
		{zone = 634, x = 0.53, y = 0.53}, -- Stormheim
		{zone = 680, x = 0.42, y = 0.67}, -- Suramar
		inaccurate = true,
		continent = 619, -- Broken Isles
	}
}

local Handler = CreateFrame('Frame')
local Line = Handler:CreateLine(nil, 'OVERLAY')
Line:SetNonBlocking(true)
Line:SetAtlas('_UI-Taxi-Line-horizontal')
Line:SetThickness(32)

local function MarkerClick(self)
	SelectGossipOption(self:GetID())
end

local function MarkerEnter(self)
	if(self.source) then
		Line:SetParent(self)
		Line:SetStartPoint('CENTER', self.source)
		Line:SetEndPoint('CENTER', self)
		Line:Show()
	end

	WorldMapTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	WorldMapTooltip:AddLine(self.name or L['Click to travel'], 1, 1, 1)

	for _, line in next, self.tooltipLines do
		local r, g, b = line.color:GetRGB()
		WorldMapTooltip:AddLine(line.text, r, g, b, true)
	end

	if(self.inaccurate) then
		WorldMapTooltip:AddLine('\n' .. L['You will end up in one of multiple locations within this zone!'], 1, 0, 0, true)
	end

	WorldMapTooltip:Show()
end

local function MarkerLeave()
	Line:Hide()
	WorldMapTooltip:Hide()
end

local function MarkerAnimation(self)
	self.up = not self.up

	self.Arrow:SetPoint('BOTTOM', self.Marker, 'TOP', 0, self.up and 10 or 0)
	self.Bounce:SetSmoothing(self.up and 'OUT' or 'IN')
	self.Bounce:SetOffset(0, self.up and -10 or 10)
	self:Play()
end

local markerMixin = {}
function markerMixin:SetNormalAtlas(atlas)
	self.Texture:SetAtlas(atlas)
end

function markerMixin:SetHighlightAtlas(atlas)
	self.Highlight:SetAtlas(atlas)
end

function markerMixin:SetSize(size)
	self:SetWidth(size)
	self:SetHeight(size)
	self.Arrow:SetSize(size, size)
end

function markerMixin:SetName(name)
	self.name = name
end

function markerMixin:SetInaccurate(inaccurate)
	self.inaccurate = inaccurate
end

function markerMixin:SetSource(marker)
	self.source = marker
end

function markerMixin:AddTooltipLine(text, color)
	table.insert(self.tooltipLines, {
		text = text,
		color = color or CreateColor(1, 1, 0)
	})
end

do
	local normalAtlas = 'MagePortalAlliance'
	local highlightAtlas = 'MagePortalHorde'
	local atlasSize = 24

	function markerMixin:Reset()
		self:SetScript('OnClick', MarkerClick)
		self:SetNormalAtlas(normalAtlas)
		self:SetHighlightAtlas(highlightAtlas)
		self:SetSize(atlasSize)
		self:SetInaccurate()
		self:SetSource()
		self:SetName()
		self:SetID(0)
		table.wipe(self.tooltipLines)
	end
end

local function CreateMarker()
	local Marker = CreateFrame('Button')
	Marker:SetScript('OnClick', MarkerClick)
	Marker:SetScript('OnEnter', MarkerEnter)
	Marker:SetScript('OnLeave', MarkerLeave)
	Marker.tooltipLines = {}

	local Texture = Marker:CreateTexture(nil, 'BACKGROUND')
	Texture:SetAllPoints()
	Marker.Texture = Texture

	local Highlight = Marker:CreateTexture(nil, 'HIGHLIGHT')
	Highlight:SetAllPoints()
	Marker.Highlight = Highlight

	local Arrow = Marker:CreateTexture(nil, 'OVERLAY')
	Arrow:SetPoint('BOTTOM', Marker, 'TOP')
	Arrow:SetTexture([[Interface\Minimap\Minimap-DeadArrow]])
	Arrow:SetTexCoord(0, 1, 1, 0)
	Marker.Arrow = Arrow

	local Animation = Arrow:CreateAnimationGroup()
	Animation:SetScript('OnFinished', MarkerAnimation)

	local Bounce = Animation:CreateAnimation('Translation')
	Bounce:SetOffset(0, 10)
	Bounce:SetDuration(0.5)
	Bounce:SetSmoothing('IN')

	Animation.Marker = Marker
	Animation.Arrow = Arrow
	Animation.Bounce = Bounce
	Animation:Play()

	Mixin(Marker, markerMixin)
	Marker:Reset()
	return Marker
end

local function ResetMarker(_, Marker)
	Marker:Reset()
end

local markerPool = CreateObjectPool(CreateMarker, ResetMarker)

function Handler:GetMarker()
	return markerPool:Acquire()
end

function Handler:ReleaseMarkers()
	markerPool:ReleaseAll()
end

function Handler:Enable(mapID)
	self:RegisterEvent('GOSSIP_CLOSED')
	GossipFrame:UnregisterEvent('GOSSIP_CLOSED')
	GossipFrame:SetScript('OnHide', nil)

	if(not WorldMapFrame:IsShown()) then
		ToggleWorldMap()
	end

	-- OpenWorldMap(mapID)
	WorldMapFrame:SetMapID(mapID)
end

local gossipHide = GossipFrame:GetScript('OnHide')
function Handler:Disable()
	self:UnregisterEvent('GOSSIP_CLOSED')
	GossipFrame:RegisterEvent('GOSSIP_CLOSED')
	GossipFrame:SetScript('OnHide', gossipHide)

	if(WorldMapFrame:IsShown()) then
		ToggleWorldMap()
	end
end

function Handler:GetNPCID()
	return tonumber(string.match(UnitGUID('npc') or '', '%w+%-.-%-.-%-.-%-.-%-(.-)%-'))
end

local page = 0
function Handler:GOSSIP_SHOW()
	if(IsShiftKeyDown()) then
		 -- temporary disable
		return
	end

	local npcID = self:GetNPCID()
	if(npcID == 101462) then
		-- Reaves need special handling, since the wormholes are under a sub-dialogue
		self:RegisterEvent('GOSSIP_CLOSED')

		page = page + 1
		if(page < 2) then
			return
		end
	end

	local data = wormholes[npcID]
	if(not data) then
		return
	end

	self:Enable(data.continent)

	for index = 1, GetNumGossipOptions() do
		local loc = data[index]

		local Marker = self:GetMarker()
		Marker:SetID(index)
		Marker:SetInaccurate(data.inaccurate)
		Marker:SetName(loc.name or HBD:GetLocalizedMap(loc.zone))

		if(loc.natlas) then
			Marker:SetNormalAtlas(loc.natlas)
		end
		if(loc.hatlas or loc.natlas) then
			Marker:SetHighlightAtlas(loc.hatlas or loc.natlas)
		end

		HBDP:AddWorldMapIconMap(self, Marker, loc.zone, loc.x, loc.y, HBD_PINS_WORLDMAP_SHOW_CONTINENT)
	end
end

function Handler:GOSSIP_CLOSED()
	self:Disable()
	self:ReleaseMarkers()
	HBDP:RemoveAllWorldMapIcons(self)
	page = 0
end

Handler:RegisterEvent('GOSSIP_SHOW')
Handler:SetScript('OnEvent', function(self, event, ...)
	self[event](self, ...)
end)

WorldMapFrame:HookScript('OnHide', function()
	if(Handler:IsEventRegistered('GOSSIP_CLOSED')) then
		CloseGossip()
	end
end)

ns.Handler = Handler
