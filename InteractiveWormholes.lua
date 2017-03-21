local _, L = ...

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
		atlas = 'MagePortalAlliance',
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
		atlas = 'MagePortalAlliance',
	},
	[108685] = { -- Vethir in Stormheim
		{zone = 1017, x = 0.45, y = 0.77, name = L['Galebroken Path'], arrowOnly = true},
		{zone = 1017, x = 0.43, y = 0.82, name = L['Thorignir Refuge'], arrowOnly = true},
		{zone = 1017, x = 0.41, y = 0.80, name = L['Thorim\'s Peak'], arrowOnly = true},
		{zone = 1017, x = 0.43, y = 0.67, name = L['Assault on Hrydshal'], atlas = 'ShipMissionIcon-Combat-Map', size = 40},
		continent = 1017,
	},
}

local function MarkerClick(self)
	SelectGossipOption(self:GetID())
end

local function MarkerEnter(self)
	self.Texture:SetDesaturated(true)

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
	self.Texture:SetDesaturated(false)
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

local function HideTexture(self)
	self.Texture:ClearAllPoints()
	self.Texture:SetPoint('BOTTOM', 0, self:GetHeight() / 3)
	self.Texture:SetTexture([[Interface\Minimap\Minimap-DeadArrow]])
	self.Texture:SetTexCoord(0, 1, 1, 0)
	self.Arrow:Hide()
end

local function ShowTexture(self)
	self.Texture:SetAllPoints()
	self.Texture:SetAtlas(self.atlas)
	self.Arrow:Show()
end

local markers = {}
local function CreateMarker(index, atlas, size)
	if(markers[index]) then
		return markers[index]
	end

	if(not size) then
		size = select(2, GetAtlasInfo(atlas or 'MagePortalAlliance'))
	end

	local Marker = CreateFrame('Button', nil, WorldMapButton)
	Marker:SetSize(size * 1.2, size * 1.2)
	Marker:SetScript('OnClick', MarkerClick)
	Marker:SetScript('OnEnter', MarkerEnter)
	Marker:SetScript('OnLeave', MarkerLeave)
	Marker:SetID(index)
	Marker.atlas = atlas or 'MagePortalAlliance'

	local Texture = Marker:CreateTexture(nil, 'BACKGROUND')
	Texture:SetAllPoints()
	Texture:SetAtlas(atlas or 'MagePortalAlliance')
	Marker.Texture = Texture

	local Arrow = Marker:CreateTexture(nil, 'OVERLAY')
	Arrow:SetPoint('BOTTOM', Marker, 'TOP')
	Arrow:SetSize(size, size)
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

	Marker.HideTexture = HideTexture
	Marker.ShowTexture = ShowTexture

	markers[index] = Marker
	return Marker
end

local gossipHide = GossipFrame:GetScript('OnHide')

local Handler = CreateFrame('Frame')
Handler:RegisterEvent('GOSSIP_SHOW')
Handler:SetScript('OnEvent', function(self, event)
	if(event == 'GOSSIP_SHOW') then
		if(IsShiftKeyDown()) then
			-- For manual operation/debugging
			return
		end

		local npcID = tonumber(string.match(UnitGUID('npc') or '', '%w+%-.-%-.-%-.-%-.-%-(.-)%-'))
		local data = wormholes[npcID]
		if(data) then
			self:RegisterEvent('GOSSIP_CLOSED')
			GossipFrame:UnregisterEvent('GOSSIP_CLOSED')
			GossipFrame:SetScript('OnHide', nil)
			HideUIPanel(GossipFrame)

			if(not WorldMapFrame:IsShown()) then
				ToggleWorldMap()
			end

			SetMapByID(data.continent)

			for index = 1, GetNumGossipOptions() do
				local location = data[index]
				local Marker = CreateMarker(index, location.atlas or data.atlas, location.size or data.size)
				Marker.accurate = data.accurate
				Marker.inaccurate = data.inaccurate
				Marker.name = location.name or HBD:GetLocalizedMap(location.zone)

				if(location.arrowOnly or data.arrowOnly) then
					Marker:HideTexture()
				else
					Marker:ShowTexture()
				end

				HBDP:AddWorldMapIconMF(self, Marker, location.zone, 0, location.x, location.y)
			end
		end
	else
		self:UnregisterEvent(event)
		GossipFrame:RegisterEvent(event)
		GossipFrame:SetScript('OnHide', gossipHide)

		if(WorldMapFrame:IsShown()) then
			ToggleWorldMap()
		end

		HBDP:RemoveAllWorldMapIcons(self)
	end
end)

WorldMapFrame:HookScript('OnHide', function()
	if(Handler:IsEventRegistered('GOSSIP_CLOSED')) then
		CloseGossip()
	end
end)
