local addonName, L = ...

local HBD = LibStub('HereBeDragons-1.0')
local HBDP = LibStub('HereBeDragons-Pins-1.0')

local wormholes = {
	[35646] = { -- Wormhole Generator: Northrend
		{zone = 486, x = 0.5178, y = 0.4503}, -- Borean Tundra
		{zone = 491, x = 0.5853, y = 0.4863}, -- Howling Fjord
		{zone = 493, x = 0.4921, y = 0.3962}, -- Sholozar Basin
		{zone = 492, x = 0.6287, y = 0.2692}, -- Icecrown
		{zone = 495, x = 0.4390, y = 0.2580}, -- Storm Peaks
		accurate = true,
		continent = 485,
	},
	[81205] = { -- Wormhole Centrifuge
		{zone = 948, x = 0.52, y = 0.33}, -- "A jagged landscape" (Spires of Arak)
		{zone = 946, x = 0.58, y = 0.65}, -- "A reddish-orange forest" (Talador)
		{zone = 947, x = 0.49, y = 0.52}, -- "Shadows..." (Shadowmoon Valley)
		{zone = 950, x = 0.73, y = 0.54}, -- "Grassy plains" (Nagrand)
		{zone = 949, x = 0.53, y = 0.61}, -- "Primal forest" (Gorgrond)
		{zone = 941, x = 0.59, y = 0.49}, -- "Lava and snow" (Frostfire Ridge)
		inaccurate = true,
		continent = 962,
	},
	[101462] = { -- Reaves (with Wormhole Generator module)
		{zone = 1015, x = 0.47, y = 0.49}, -- Azsuna
		{zone = 1018, x = 0.56, y = 0.66}, -- Val'sharah
		{zone = 1024, x = 0.45, y = 0.56}, -- Highmountain
		{zone = 1017, x = 0.53, y = 0.53}, -- Stormheim
		{zone = 1033, x = 0.42, y = 0.67}, -- Suramar
		inaccurate = true,
		continent = 1007,
	},
}

local Overlay = CreateFrame('Frame', addonName .. 'MapFrame', WorldMapButton)
Overlay:SetAllPoints()
Overlay:SetFrameLevel(2000)

local function MarkerClick(self)
	SelectGossipOption(self:GetID())
end

local function MarkerEnter(self)
	self.Texture:Hide()
	self.Highlight:Show()

	WorldMapTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	WorldMapTooltip:AddLine(self.name or L['Click to travel'], 1, 1, 1)

	if(self.inaccurate) then
		WorldMapTooltip:AddLine('\n' .. L['You will end up in one of multiple locations within this zone.'], 1, 0, 0, true)
	elseif(self.accurate) then
		WorldMapTooltip:AddLine('\n' .. L['This is an accurate wormhole!'], 0, 1, 0, true)
	end

	WorldMapTooltip:Show()
end

local function MarkerLeave(self)
	self.Texture:Show()
	self.Highlight:Hide()

	WorldMapUnit_OnLeave(self)
end

local function MarkerAnimation(self)
	self.up = not self.up

	if(self.up) then
		self.Arrow:SetPoint('BOTTOM', self.Marker, 'TOP', 0, 10)
		self.Bounce:SetSmoothing('OUT')
	else
		self.Arrow:SetPoint('BOTTOM', self.Marker, 'TOP', 0, 0)
		self.Bounce:SetSmoothing('IN')
	end

	self.Bounce:SetOffset(0, self.up and -10 or 10)
	self:Play()
end

local markers = {}
local function CreateMarker(index)
	if(markers[index]) then
		return markers[index]
	end

	local Marker = CreateFrame('Button', nil, Overlay)
	Marker:SetScript('OnClick', MarkerClick)
	Marker:SetScript('OnEnter', MarkerEnter)
	Marker:SetScript('OnLeave', MarkerLeave)
	Marker:SetID(index)

	local Texture = Marker:CreateTexture(nil, 'BACKGROUND')
	Texture:SetAllPoints()
	Marker.Texture = Texture

	local Highlight = Marker:CreateTexture(nil, 'BACKGROUND')
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
	Bounce:SetDuration(1/2)
	Bounce:SetSmoothing('IN')

	Animation.Marker = Marker
	Animation.Arrow = Arrow
	Animation.Bounce = Bounce
	Animation:Play()

	markers[index] = Marker
	return Marker
end

function Overlay:SetMarker(index, atlas, highlightAtlas, size)
	if(not size) then
		size = select(2, GetAtlasInfo(atlas))
	end

	local Marker = CreateMarker(index)
	-- Marker:SetSize(size * 1.2, size * 1.2)
	Marker:SetSize(size, size)
	Marker.Arrow:SetSize(size, size)

	Marker.Texture:SetAtlas(atlas)
	Marker.Texture:Show()

	Marker.Highlight:SetAtlas(highlightAtlas)
	Marker.Highlight:Hide()

	return Marker
end

local reavesPage = 0
Overlay:RegisterEvent('GOSSIP_SHOW')
Overlay:SetScript('OnEvent', function(self, event)
	if(event == 'GOSSIP_SHOW') then
		if(IsShiftKeyDown()) then
			-- For manual operation/debugging
			return
		end

		local npcID = tonumber(string.match(UnitGUID('npc') or '', '%w+%-.-%-.-%-.-%-.-%-(.-)%-'))
		if(npcID == 101462) then
			-- Reaves needs special handling, since the wormholes are under a
			-- sub-dialogue.
			self:RegisterEvent('GOSSIP_CLOSED')

			reavesPage = reavesPage + 1
			if(reavesPage < 2) then
				return
			end
		end

		local data = wormholes[npcID]
		if(data) then
			self:Enable(data.continent)

			for index = 1, GetNumGossipOptions() do
				local location = data[index]
				local Marker = self:SetMarker(index, 'MagePortalAlliance', 'MagePortalHorde')
				Marker.name = HBD:GetLocalizedMap(location.zone)
				Marker.accurate = data.accurate
				Marker.inaccurate = data.inaccurate

				HBDP:AddWorldMapIconMF(self, Marker, location.zone, 0, location.x, location.y)
			end
		end
	else
		self:Disable()
		HBDP:RemoveAllWorldMapIcons(self)

		reavesPage = 0
	end
end)

function Overlay:Enable(continent)
	self:RegisterEvent('GOSSIP_CLOSED')
	GossipFrame:UnregisterEvent('GOSSIP_CLOSED')
	GossipFrame:SetScript('OnHide', nil)
	HideUIPanel(GossipFrame)

	if(not WorldMapFrame:IsShown()) then
		ToggleWorldMap()
	end

	SetMapByID(continent)
end

local gossipHide = GossipFrame:GetScript('OnHide')
function Overlay:Disable()
	self:UnregisterEvent('GOSSIP_CLOSED')
	GossipFrame:RegisterEvent('GOSSIP_CLOSED')
	GossipFrame:SetScript('OnHide', gossipHide)

	if(WorldMapFrame:IsShown()) then
		ToggleWorldMap()
	end
end

WorldMapFrame:HookScript('OnHide', function()
	if(Overlay:IsEventRegistered('GOSSIP_CLOSED')) then
		CloseGossip()
	end
end)
