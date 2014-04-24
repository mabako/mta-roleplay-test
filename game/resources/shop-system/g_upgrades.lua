local spoilerPrice = 8000
local hoodPrice = 2700
local sideskirtPrice = 5000
local roofPrice = 2500
local lightPrice = 1500
local wheelPrice = 4500
local exhaustPrice = 2000
local bullbarPrice = 3000
local bumperPrice = 3000
vehicle_upgrades = {
	{ "Pro", spoilerPrice }, -- TRANSFENDER
	{ "Win", spoilerPrice },
	{ "Drag", spoilerPrice },
	{ "Alpha", spoilerPrice },
	{ "Champ Scoop", hoodPrice },
	{ "Fury Scoop", hoodPrice },
	{ "Roof Scoop", roofPrice },
	{ "Right Sideskirt", sideskirtPrice },
	--{ "5x Nitro", 10000 }, -- NOS
	--{ "2x Nitro", 6000 },
	--{ "10x Nitro", 20000 },
	false,
	false,
	false,
	{ "Race Scoop", hoodPrice }, -- TRANSFENDER
	{ "Worx Scoop", hoodPrice },
	{ "Round Fog", lightPrice },
	{ "Champ", spoilerPrice },
	{ "Race", spoilerPrice },
	{ "Worx", spoilerPrice },
	{ "Left Sideskirt", sideskirtPrice },
	{ "Upswept", exhaustPrice },
	{ "Twin", exhaustPrice },
	{ "Large", exhaustPrice },
	{ "Medium", exhaustPrice },
	{ "Small", exhaustPrice },
	{ "Fury", spoilerPrice },
	{ "Square Fog", lightPrice },
	{ "Offroad", wheelPrice },
	{ "Right Alien Sideskirt", sideskirtPrice }, -- SULTAN
	{ "Left Alien Sideskirt", sideskirtPrice },
	{ "Alien", exhaustPrice },
	{ "X-Flow", exhaustPrice },
	{ "Left X-Flow Sideskirt", sideskirtPrice },
	{ "Right X-Flow Sideskirt", sideskirtPrice },
	{ "Alien Roof Vent", roofPrice },
	{ "X-Flow Roof Vent", roofPrice },
	{ "Alien", exhaustPrice }, -- ELEGY
	{ "X-Flow Roof Vent", roofPrice },
	{ "Right Alien Sideskirt", sideskirtPrice },
	{ "X-Flow", exhaustPrice },
	{ "Alien Roof Vent", roofPrice },
	{ "Left X-Flow Sideskirt", sideskirtPrice },
	{ "Left Alien Sideskirt", sideskirtPrice },
	{ "Right X-Flow Sideskirt", sideskirtPrice },
	{ "Right Chrome Sideskirt", sideskirtPrice }, -- BROADWAY
	{ "Slamin", exhaustPrice },
	{ "Chrome", exhaustPrice },
	{ "X-Flow", exhaustPrice }, -- FLASH
	{ "Alien", exhaustPrice },
	{ "Right Alien Sideskirt", sideskirtPrice },
	{ "Right X-Flow Sideskirt", sideskirtPrice },
	{ "Alien", spoilerPrice },
	{ "X-Flow", spoilerPrice },
	{ "Left Alien Sideskirt", sideskirtPrice },
	{ "Left X-Flow Sideskirt", sideskirtPrice },
	{ "X-Flow", roofPrice },
	{ "Alien", roofPrice },
	{ "Alien", roofPrice }, -- STRATUM
	{ "Right Alien Sideskirt", sideskirtPrice },
	{ "Right X-Flow Sideskirt", sideskirtPrice },
	{ "Alien", spoilerPrice },
	{ "X-Flow", exhaustPrice },
	{ "X-Flow", spoilerPrice },
	{ "X-Flow", roofPrice },
	{ "Left Alien Sideskirt", sideskirtPrice },
	{ "Left X-Flow Sideskirt", sideskirtPrice },
	{ "Alien", exhaustPrice },
	{ "Alien", exhaustPrice }, -- JESTER
	{ "X-Flow", exhaustPrice },
	{ "Alien", roofPrice },
	{ "X-Flow", roofPrice },
	{ "Right Alien Sideskirt", sideskirtPrice },
	{ "Right X-Flow Sideskirt", sideskirtPrice },
	{ "Left Alien Sideskirt", sideskirtPrice },
	{ "Left X-Flow Sideskirt", sideskirtPrice },
	{ "Shadow", wheelPrice }, -- MOST CARS (WHEELS)
	{ "Mega", wheelPrice },
	{ "Rimshine", wheelPrice },
	{ "Wires", wheelPrice },
	{ "Classic", wheelPrice },
	{ "Twist", wheelPrice },
	{ "Cutter", wheelPrice },
	{ "Switch", wheelPrice },
	{ "Grove", wheelPrice },
	{ "Import", wheelPrice },
	{ "Dollar", wheelPrice },
	{ "Trance", wheelPrice },
	{ "Atomic", wheelPrice },
	{ "Stereo", 1000 },
	{ "Hydraulics", 2200 },
	{ "Alien", roofPrice }, -- URANUS
	{ "X-Flow", exhaustPrice },
	{ "Right Alien Sideskirt", sideskirtPrice },
	{ "X-Flow", roofPrice },
	{ "Alien", exhaustPrice },
	{ "Right X-Flow Sideskirt", sideskirtPrice },
	{ "Left Alien Sideskirt", sideskirtPrice },
	{ "Left X-Flow Sideskirt", sideskirtPrice },
	{ "Ahab", wheelPrice }, -- MOST CARS(WHEELS)
	{ "Virtual", wheelPrice },
	{ "Access", wheelPrice },
	{ "Left Chrome Sideskirt", sideskirtPrice }, -- BROADWAY
	{ "Chrome Grill", 4000 }, -- REMINGTON
	{ "Left Chrome Flames Sideskirt", sideskirtPrice },
	{ "Left Chrome Strip Sideskirt", sideskirtPrice }, -- SAVANNA
	{ "Covertible", roofPrice }, -- BLADE
	{ "Chrome", exhaustPrice },
	{ "Slamin", exhaustPrice },
	{ "Right Chrome Arches", sideskirtPrice }, -- REMINGTON
	{ "Left Chrome Strip Sideskirt", sideskirtPrice }, -- BLADE
	{ "Right Chrome Strip Sideskirt", sideskirtPrice },
	{ "Chrome", bullbarPrice }, -- SLAMVAN
	{ "Slamin", bullbarPrice },
	false,
	false, 
	{ "Chrome", exhaustPrice },
	{ "Slamin", exhaustPrice },
	{ "Chrome", bullbarPrice },
	{ "Slamin", bullbarPrice },
	{ "Chrome", bumperPrice },
	{ "Right Chrome Trim Sideskirt", sideskirtPrice },
	{ "Right Wheelcovers Sideskirt", sideskirtPrice },
	{ "Left Chrome Trim Sideskirt", sideskirtPrice },
	{ "Left Wheelcovers Sideskirt", sideskirtPrice },
	{ "Right Chrome Flames Sideskirt", sideskirtPrice }, -- REMINGTON
	{ "Bullbar Chrome Bars", bullbarPrice },
	{ "Left Chrome Arches Sideskirt", sideskirtPrice },
	{ "Bullbar Chrome Lights", bullbarPrice },
	{ "Chrome Exhaust", exhaustPrice },
	{ "Slamin Exhaust", exhaustPrice },
	{ "Vinyl Hardtop", roofPrice }, -- BLADE
	{ "Chrome", exhaustPrice }, -- SAVANNA
	{ "Hardtop", roofPrice },
	{ "Softtop", roofPrice },
	{ "Slamin", exhaustPrice },
	{ "Right Chrom Strip Sideskirt", sideskirtPrice },
	{ "Right Chrom Strip Sideskirt", sideskirtPrice }, -- TORNADO
	{ "Slamin", exhaustPrice },
	{ "Chrome", exhaustPrice },
	{ "Left Chrome Strip Sideskirt", sideskirtPrice },
	{ "Alien", spoilerPrice }, -- SULTAN
	{ "X-Flow", spoilerPrice },
	{ "X-Flow", bumperPrice },
	{ "Alien", bumperPrice },
	{ "Left Oval Vents", 500 }, -- CERTAIN TRANSFENDER CARS
	{ "Right Oval Vents", 500 },
	{ "Left Square Vents", 500 },
	{ "Right Square Vents", 500 },
	{ "X-Flow", spoilerPrice }, -- ELEGY
	{ "Alien", spoilerPrice },
	{ "X-Flow", bumperPrice },
	{ "Alien", bumperPrice },
	{ "Alien", bumperPrice }, -- FLASH
	{ "X-Flow", bumperPrice },
	{ "X-Flow", bumperPrice },
	{ "Alien", bumperPrice },
	{ "Alien", bumperPrice }, -- STRATUM
	{ "Alien", bumperPrice },
	{ "X-Flow", bumperPrice },
	{ "X-Flow", bumperPrice },
	{ "X-Flow", spoilerPrice }, -- JESTER
	{ "Alien", bumperPrice },
	{ "Alien", bumperPrice },
	{ "X-Flow", bumperPrice },
	{ "Alien", spoilerPrice },
	{ "X-Flow", spoilerPrice }, -- URANUS
	{ "Alien", spoilerPrice },
	{ "X-Flow", bumperPrice },
	{ "Alien", bumperPrice },
	{ "X-Flow", bumperPrice },
	{ "Alien", bumperPrice },
	{ "Alien", bumperPrice }, -- SULTAN
	{ "X-Flow", bumperPrice },
	{ "Alien", bumperPrice }, -- ELEGY
	{ "X-Flow", bumperPrice },
	{ "X-Flow", bumperPrice }, -- JESTER
	{ "Chrome", bumperPrice }, -- BROADWAY
	{ "Slamin", bumperPrice },
	{ "Chrome", bumperPrice },
	{ "Slamin", bumperPrice },
	{ "Slamin", bumperPrice }, -- REMINGTON
	{ "Chrome", bumperPrice },
	{ "Chrome", bumperPrice },
	{ "Slamin", bumperPrice }, -- BLADE
	{ "Chrome", bumperPrice },
	{ "Slamin", bumperPrice },
	{ "Chrome", bumperPrice },
	{ "Slamin", bumperPrice }, -- REMINGTON
	{ "Slamin", bumperPrice }, -- SAVANNA
	{ "Chrome", bumperPrice },
	{ "Slamin", bumperPrice },
	{ "Chrome", bumperPrice },
	{ "Slamin", bumperPrice }, -- TORNADO
	{ "Chrome", bumperPrice },
	{ "Chrome", bumperPrice },
	{ "Slamin", bumperPrice }
}
