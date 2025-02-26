local _, addon = ...

-- expose a namespace
InteractiveWormholes = {}

-- expose an API for other addons to use to check if we're active
function InteractiveWormholes:IsActive()
	if not addon:ShouldShowMap() or InCombatLockdown() then
		-- we'll never be active if the user holds shift or if the player is in combat
		return false
	end

	if addon.stagedGossipOptionID ~= nil then
		-- there's a staged option, we're still active
		return true
	end

	for _, gossipInfo in next, C_GossipInfo.GetOptions() do
		if addon.data[gossipInfo.gossipOptionID or 0] then
			-- there's an option we manage, we're active
			return true
		end
	end

	return false
end
