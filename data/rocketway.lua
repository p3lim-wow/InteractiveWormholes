local _, addon = ...

-- Azshara Rocketway
addon.data[39596] = { -- Orgrimmar Rocketway Exchange
	mapID = 76, -- Azshara
	x = 0.2950,
	y = 0.6595,
	-- tooltipArea = 4830,
	isTaxi = true,
	taxiIndex = 4,
	taxiSourceIndex = 5, -- Southern Rocketway Terminus
}
addon.data[39597] = { -- Gallywix Rocketway Exchange
	mapID = 76, -- Azshara
	x = 0.2579,
	y = 0.4962,
	-- tooltip = addon.L['Gallywix Rocketway Exchange'], -- no data in AreaTable :(
	isTaxi = true,
	taxiIndex = 3,
	taxiSourceIndex = 5, -- Southern Rocketway Terminus
}
addon.data[39598] = { -- Northern Rocketway Exchange
	mapID = 76, -- Azshara
	x = 0.4248,
	y = 0.2478,
	-- tooltipArea = 4825,
	isTaxi = true,
	taxiIndex = 2,
	taxiSourceIndex = 5, -- Southern Rocketway Terminus
}
addon.data[39599] = { -- Northern Rocketway Terminus
	mapID = 76, -- Azshara
	x = 0.6638,
	y = 0.2082,
	-- tooltip = addon.L['Northern Rocketway Terminus'], -- no data in AreaTable :(
	isTaxi = true,
	taxiIndex = 1,
	taxiSourceIndex = 5, -- Southern Rocketway Terminus
}
addon.data[39570] = { -- Southern Rocketway Terminus
	mapID = 76, -- Azshara
	x = 0.5078,
	y = 0.7403,
	-- tooltipArea = 4828,
	isTaxi = true,
	taxiIndex = 5,
	taxiSourceIndex = 4, -- Orgrimmar Rocketway Exchange
}

addon.data[39571] = { -- Gallywix Rocketway Exchange
	mapID = addon.data[39597].mapID,
	x = addon.data[39597].x,
	y = addon.data[39597].y,
	-- tooltip = addon.data[39597].tooltip,
	isTaxi = true,
	taxiIndex = addon.data[39597].taxiIndex,
	taxiSourceIndex = 4, -- Orgrimmar Rocketway Exchange
}
addon.data[39572] = { -- Northern Rocketway Exchange
	mapID = addon.data[39598].mapID,
	x = addon.data[39598].x,
	y = addon.data[39598].y,
	-- tooltip = addon.data[39598].tooltip,
	isTaxi = true,
	taxiIndex = addon.data[39598].taxiIndex,
	taxiSourceIndex = 4, -- Orgrimmar Rocketway Exchange
}
addon.data[39573] = { -- Northern Rocketway Terminus
	mapID = addon.data[39599].mapID,
	x = addon.data[39599].x,
	y = addon.data[39599].y,
	-- tooltip = addon.data[39599].tooltip,
	isTaxi = true,
	taxiIndex = addon.data[39599].taxiIndex,
	taxiSourceIndex = 4, -- Orgrimmar Rocketway Exchange
}
addon.data[38780] = { -- Orgrimmar Rocketway Exchange
	mapID = addon.data[39596].mapID,
	x = addon.data[39596].x,
	y = addon.data[39596].y,
	-- tooltip = addon.data[39596].tooltip,
	isTaxi = true,
	taxiIndex = addon.data[39596].taxiIndex,
	taxiSourceIndex = 3, -- Gallywix Rocketway Exchange
}
addon.data[38781] = { -- Northern Rocketway Exchange
	mapID = addon.data[39598].mapID,
	x = addon.data[39598].x,
	y = addon.data[39598].y,
	-- tooltip = addon.data[39598].tooltip,
	isTaxi = true,
	taxiIndex = addon.data[39598].taxiIndex,
	taxiSourceIndex = 3, -- Gallywix Rocketway Exchange
}
addon.data[38782] = { -- Southern Rocketway Terminus
	mapID = addon.data[39570].mapID,
	x = addon.data[39570].x,
	y = addon.data[39570].y,
	-- tooltip = addon.data[39570].tooltip,
	isTaxi = true,
	taxiIndex = addon.data[39570].taxiIndex,
	taxiSourceIndex = 3, -- Gallywix Rocketway Exchange
}
addon.data[38783] = { -- Northern Rocketway Terminus
	mapID = addon.data[39599].mapID,
	x = addon.data[39599].x,
	y = addon.data[39599].y,
	-- tooltip = addon.data[39599].tooltip,
	isTaxi = true,
	taxiIndex = addon.data[39599].taxiIndex,
	taxiSourceIndex = 3, -- Gallywix Rocketway Exchange
}
addon.data[38784] = { -- Northern Rocketway Terminus
	mapID = addon.data[39599].mapID,
	x = addon.data[39599].x,
	y = addon.data[39599].y,
	-- tooltip = addon.data[39599].tooltip,
	isTaxi = true,
	taxiIndex = addon.data[39599].taxiIndex,
	taxiSourceIndex = 2, -- Northern Rocketway Exchange
}
addon.data[38785] = { -- Gallywix Rocketway Exchange
	mapID = addon.data[39597].mapID,
	x = addon.data[39597].x,
	y = addon.data[39597].y,
	-- tooltip = addon.data[39597].tooltip,
	isTaxi = true,
	taxiIndex = addon.data[39597].taxiIndex,
	taxiSourceIndex = 2, -- Northern Rocketway Exchange
}
addon.data[38786] = { -- Orgrimmar Rocketway Exchange
	mapID = addon.data[39596].mapID,
	x = addon.data[39596].x,
	y = addon.data[39596].y,
	-- tooltip = addon.data[39596].tooltip,
	isTaxi = true,
	taxiIndex = addon.data[39596].taxiIndex,
	taxiSourceIndex = 2, -- Northern Rocketway Exchange
}
addon.data[38787] = { -- Southern Rocketway Terminus
	mapID = addon.data[39570].mapID,
	x = addon.data[39570].x,
	y = addon.data[39570].y,
	-- tooltip = addon.data[39570].tooltip,
	isTaxi = true,
	taxiIndex = addon.data[39570].taxiIndex,
	taxiSourceIndex = 2, -- Northern Rocketway Exchange
}
addon.data[38815] = { -- Northern Rocketway Exchange
	mapID = addon.data[39598].mapID,
	x = addon.data[39598].x,
	y = addon.data[39598].y,
	-- tooltip = addon.data[39598].tooltip,
	isTaxi = true,
	taxiIndex = addon.data[39598].taxiIndex,
	taxiSourceIndex = 1, -- Northern Rocketway Terminus
}
addon.data[38816] = { -- Gallywix Rocketway Exchange
	mapID = addon.data[39597].mapID,
	x = addon.data[39597].x,
	y = addon.data[39597].y,
	-- tooltip = addon.data[39597].tooltip,
	isTaxi = true,
	taxiIndex = addon.data[39597].taxiIndex,
	taxiSourceIndex = 1, -- Northern Rocketway Terminus
}
addon.data[38817] = { -- Orgrimmar Rocketway Exchange
	mapID = addon.data[39596].mapID,
	x = addon.data[39596].x,
	y = addon.data[39596].y,
	-- tooltip = addon.data[39596].tooltip,
	isTaxi = true,
	taxiIndex = addon.data[39596].taxiIndex,
	taxiSourceIndex = 1, -- Northern Rocketway Terminus
}
addon.data[38818] = { -- Southern Rocketway Terminus
	mapID = addon.data[39570].mapID,
	x = addon.data[39570].x,
	y = addon.data[39570].y,
	-- tooltip = addon.data[39570].tooltip,
	isTaxi = true,
	taxiIndex = addon.data[39570].taxiIndex,
	taxiSourceIndex = 1, -- Northern Rocketway Terminus
}
