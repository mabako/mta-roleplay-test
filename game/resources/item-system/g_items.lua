g_items = {
	[1] = { "Hotdog", "A steamy, good looking and tasty hotdog.", 1, 2215, 205, 205, 0, 0.01, weight = 0.1 },
	[2] = { "Cellphone", "A sleek cellphone, look's like a new one too.", 7, 330, 90, 90, 0, -0.05, weight = 0.3 },
	[3] = { "Vehicle Key", "A vehicle key with a small manufacturers badge on it.", 2, 1581, 270, 270, 0, 0, weight = 0.1 },
	[4] = { "House Key", "A green house key.", 2, 1581, 270, 270, 0, 0, weight = 0.1 },
	[5] = { "Business Key", "A blue business key.", 2, 1581, 270, 270, 0, 0, weight = 0.1 },
	[6] = { "Radio", "A black radio.", 7, 330, 90, 90, 0, -0.05, weight = 0.2 },
	[7] = { "Phonebook", "A torn phonebook.", 5, 2824, 0, 0, 0, -0.01, weight = 2 },
	[8] = { "Sandwich", "A yummy sandwich with cheese.", 1, 2355, 205, 205, 0, 0.06, weight = 0.3 },
	[9] = { "Softdrink", "A can of Sprunk.", 1, 2647, 0, 0, 0, 0.12, weight = 0.2 },
	[10] = { "Dice", "A white dice with white dots.", 4, 1271, 0, 0, 0, 0.285, weight = 0.1 }, 
	[11] = { "Taco", "A greasy mexican taco.", 1, 2215, 205, 205, 0, 0.06, weight = 0.1 },
	[12] = { "Burger", "A double cheeseburger with bacon.", 1, 2703, 265, 0, 0, 0.06, weight = 0.3 },
	[13] = { "Donut", "Hot sticky sugar covered donut.", 1, 2222, 0, 0, 0, 0.07, weight = 0.2 },
	[14] = { "Cookie", "A luxury chocolate chip cookie.", 1, 2222, 0, 0, 0, 0.07, weight = 0.1 },
	[15] = { "Water", "A bottle of mineral water.", 1, 1484, -15, 30, 0, 0.2, weight = 1 },
	[16] = { "Clothes", "A set of clean clothes. (( Skin ID ##v ))", 6, 2386, 0, 0, 0, 0.1, weight = 1 },
	[17] = { "Watch", "A smart gold watch.", 6, 1271, 0, 0, 0, 0.285, weight = 0.1 },
	[19] = { "MP3 Player", "A white, sleek looking MP3 Player. The brand reads EyePod.", 7, 2886, 270, 0, 0, 0.1, weight = 0.1 },
	[20] = { "Standard Fighting for Dummies", "A book on how to do standard fighting.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[21] = { "Boxing for Dummies", "A book on how to do boxing.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[22] = { "Kung Fu for Dummies", "A book on how to do kung fu.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[23] = { "Knee Head Fighting for Dummies", "A book on how to do grab kick fighting.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[24] = { "Grab Kick Fighting for Dummies", "A book on how to do elbow fighting.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[25] = { "Elbow Fighting for Dummies", "A book on how to do elbow fighting.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[26] = { "Gas Mask", "A black gas mask, blocks out the effects of gas and flashbangs.", 6, 2386, 0, 0, 0, 0.1, weight = 0.5 },
	[27] = { "Flashbang", "A small grenade canister with FB written on the side.", 4, 343, 0, 0, 0, 0.1, weight = 0.2 },
	[28] = { "Glowstick", "A green glowstick.", 4, 343, 0, 0, 0, 0.1, weight = 0.2 },
	[29] = { "Door Ram", "A red metal door ram.", 4, 1587, 90, 0, 0, 0.05, weight = 3 },
	[30] = { "Cannabis Sativa", "Cannabis Sativa, when mixed can create some strong drugs.", 3, 1279, 0, 0, 0, 0, weight = 0.1 },
	[31] = { "Cocaine Alkaloid", "Cocaine Alkaloid, when mixed can create some strong drugs.", 3, 1279, 0, 0, 0, 0, weight = 0.1 },
	[32] = { "Lysergic Acid", "Lysergic Acid, when mixed can create some strong drugs.", 3, 1279, 0, 0, 0, 0, weight = 0.1 },
	[33] = { "Unprocessed PCP", "Unprocessed PCP, when mixed can create some strong drugs.", 3, 1279, 0, 0, 0, 0, weight = 0.1 },
	[34] = { "Cocaine", "1g of cocaine.", 3, 1575, 0, 0, 0, 0, weight = 0.1 },
	[35] = { "Drug 2", "A marijuana joint laced in cocaine.", 3, 1576, 0, 0, 0, 0, weight = 0.1 },
	[36] = { "Drug 3", "50mg of cocaine laced in lysergic acid.", 3, 1578, 0, 0, 0, -0.02, weight = 0.1 },
	[37] = { "Drug 4", "50mg of cocaine laced in phencyclidine.", 3, 1579, 0, 0, 0, 0, weight = 0.1 },
	[38] = { "Marijuana", "A marijuana joint.", 3, 3044, 0, 0, 0, 0.04, weight = 0.1 }, 
	[39] = { "Drug 6", "A marijuana joint laced in lysergic acid.", 3, 1580, 0, 0, 0, 0, weight = 0.1 },
	[40] = { "Angel Dust", "A marijuana joint laced in phencyclidine.", 3, 1575, 0, 0, 0, -0.02, weight = 0.1 },
	[41] = { "LSD", "80 micrograms of LSD.", 3, 1576, 0, 0, 0, 0, weight = 0.1 },
	[42] = { "Drug 9", "100milligrams of yellow liquid.", 3, 1577, 0, 0, 0, 0, weight = 0.1 },
	[43] = { "PCP Hydrochloride", "10mg of phencyclidine powder.", 3, 1578, 0, 0, 0, 0, weight = 0.1 },
	[44] = { "Chemistry Set", "A small chemistry set.", 4, 1210, 90, 0, 0, 0.1, weight = 3 },
	[45] = { "Handcuffs", "A pair of metal handcuffs.", 4, 2386, 0, 0, 0, 0.1, weight = 0.4 },
	[46] = { "Rope", "A long rope.", 4, 1271, 0, 0, 0, 0.285, weight = 0.3 },
	[47] = { "Handcuff Keys", "A small pair of handcuff keys.", 4, 2386, 0, 0, 0, 0.1, weight = 0.05 },
	[48] = { "Backpack", "A reasonably sized backpack.", 4, 3026, 270, 0, 0, 0, weight = 1 },
	[49] = { "Fishing Rod", "A 7 foot carbon steel fishing rod.", 4, 338, 80, 0, 0, -0.02, weight = 1.5 },
	[50] = { "Los Santos Highway Code", "The Los Santos Highway Code.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[51] = { "Chemistry 101",  "An Introduction to Useful Chemistry.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[52] = { "Police Officer's Manual", "The Police Officer's Manual.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[53] = { "Breathalizer", "A small black breathalizer.", 4, 1271, 0, 0, 0, 0.285, weight = 0.2 },
	[54] = { "Ghettoblaster", "A black Ghettoblaster.", 7, 2226, 0, 0, 0, 0, weight = 3 },
	[55] = { "Business Card", "Steven Pullman - L.V. Freight Depot, Tel: 12555", 4, 1581, 270, 270, 0, 0, weight = 0.1 },
	[56] = { "Ski Mask", "A Ski mask.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 },
	[57] = { "Fuel Can", "A small metal fuel canister.", 4, 1650, 0, 0, 0, 0.30, weight = 1 }, -- would prolly to make sense to make it heavier if filled
	[58] = { "Ziebrand Beer", "The finest beer, imported from Holland.", 1, 1520, 0, 0, 0, 0.15, weight = 1 },
	[60] = { "Safe", "A safe to store your items in.", 4, 2332, 0, 0, 0, 0, weight = 5 },
	[61] = { "Emergency Light Strobes", "An Emergency Light Strobe which you can put on you car.", 7, 2886, 270, 0, 0, 0.1, weight = 0.1 },
	[62] = { "Bastradov Vodka", "For your best friends - Bastradov Vodka.", 1, 1512, 0, 0, 0, 0.25, weight = 1 },
	[63] = { "Scottish Whiskey", "The Best Scottish Whiskey, now exclusively made from Haggis.", 1, 1512, 0, 0, 0, 0.25, weight = 1 },
	[64] = { "LSPD Badge", "A Los Santos Police Department badge.", 4, 1581, 270, 270, 0, 0, weight = 0.5 },
	[65] = { "LSES Identification", "An Los Santos Emergency Service Identification.", 4, 1581, 270, 270, 0, 0, weight = 0.3 },
	[66] = { "Blindfold", "A black blindfold.", 6, 2386, 0, 0, 0, 0.1, weight = 0.1 },
	[67] = { "GPS", "A GPS Satnav for a car.", 6, 2886, 270, 0, 0, 0.1, weight = 0.8 },
	[68] = { "Lottery Ticket", "A Los Santos Lottery ticket.", 6, 1581, 270, 270, 0, 0, weight = 0.1 },
	[69] = { "Dictionary", "A Dictionary.", 5, 2824, 0, 0, 0, -0.01, weight = 1.5 },
	[70] = { "First Aid Kit", "Saves a Life. Can be used #v times.", 4, 1240, 90, 0, 0, 0.05, weight = function(v) return v/3 end },
	[71] = { "Notebook", "A small collection of blank papers, useful for writing notes. There are #v pages left. ((/writenote))", 4, 2894, 0, 0, 0, -0.01, weight = function(v) return v*0.01 end },
	[72] = { "Note", "The note reads: #v", 4, 2894, 0, 0, 0, -0.01, weight = 0.01 },
	[73] = { "Elevator Remote", "A small remote to change an elevator's mode.", 2, 364, 0, 0, 0, 0.05, weight = 0.3 },
	[74] = { "Bomb", "What could possibly happen when you use this?", 4, 363, 270, 0, 0, 0.05, weight = 100000 },
	[75] = { "Bomb Remote", "Has a funny red button.", 4, 364, 0, 0, 0, 0.05, weight = 100000 },
	[76] = { "Riot Shield", "A heavy riot shield.", 4, 1631, -90, 0, 0, 0.1, weight = 5 },
	[77] = { "Card Deck", "A card deck to play some games.", 4,2824, 0, 0, 0, -0.01, weight = 0.1 },
	[78] = { "San Andreas Pilot Certificate", "An official permission to fly planes and helicopters.", 4, 1581, 270, 270, 0, 0, weight = 0.3 },
	[79] = { "Porn Tape", "A porn tape, #v", 4,2824, 0, 0, 0, -0.01, weight = 0.2 },
	[80] = { "Generic Item", "#v", 4, 1271, 0, 0, 0, 0.285, weight = 1 },
	[81] = { "Fridge", "A fridge to store food and drinks in.", 7, 2147, 0, 0, 0, 0, weight = 0.1 --[[Just here to look pretty, but fridges ain't available to easily buy]] },
	[82] = { "Hex Identification", "This Hex Identification has been issued to #v.", 4, 1581, 270, 270, 0, 0, weight = 0.3 },
	[83] = { "Coffee", "A small cup of Coffee.", 1, 2647, 0, 0, 0, 0.12, weight = 0.25 },
	[84] = { "Escort 9500ci Radar Detector", "Detects Police within a half mile.", 7, 330, 90, 90, 0, -0.05, weight = 1 },
	[85] = { "Emergency Siren", "An emergency siren to put in your car.", 7, 330, 90, 90, 0, -0.05, weight = 0.2 },
	[86] = { "SAN Identifcation", "A SAN Identification issued to #v.", 7, 330, 90, 90, 0, -0.05, weight = 0.3 },
	[87] = { "LS Government Badge", "A Los Santos Government Badge.", 4, 1581, 270, 270, 0, 0, weight = 0.5 },
	[88] = { "Earpiece", "A small earpiece, can be connected to a radio.", 7, 1581, 270, 270, 0, 0, weight = 0.15 },
	[89] = { "Food", "", 1, 2222, 0, 0, 0, 0.07, weight = 1 },
	[90] = { "Helmet", "Ideal for riding bikes.", 6, 2386, 0, 0, 0, 0.1, weight = 1.5 },
	[91] = { "Eggnog", "Yum Yum.", 1, 2647, 0, 0, 0, 0.1, weight = 0.5 }, --91
	[92] = { "Turkey", "Yum Yum.", 1, 2222, 0, 0, 0, 0.1, weight = 3.8 },
	[93] = { "Christmas Pudding", "Yum Yum.", 1, 2222, 0, 0, 0, 0.1, weight = 0.4 },
	[94] = { "Christmas Present", "I know you want one.", 4, 1220, 0, 0, 0, 0.1, weight = 1 },
	[95] = { "Drink", "", 1, 1484, -15, 30, 0, 0.2, weight = 1 },
	[96] = { "PDA", "A top of the range PDA to view e-mails and browse the internet.", 6, 2886, 270, 0, 0, 0.1, weight = function(v) return v == 1 and 0.2 or 1.5 end },
	[97] = { "LSES Procedures Manual", "The Los Santos Emergency Service procedures handbook.", 5, 2824, 0, 0, 0, -0.01, weight = 0.5 },
	[98] = { "Garage Remote", "A small remote to open or close a Garage.", 2, 364, 0, 0, 0, 0.05, weight = 0.3 },
	[99] = { "Mixed Dinner Tray", "Lets play the guessing game.", 1, 2355, 205, 205, 0, 0.06, weight = 0.4 },
	[100] = { "Small Milk Carton", "Lumps included!", 1, 2856, 0, 0, 0, 0, weight = 0.2 },
	[101] = { "Small Juice Carton", "Thirsty?", 1, 2647, 0, 0, 0, 0.12, weight = 0.2 },
	[102] = { "Cabbage", "For those Vegi-Lovers.", 1, 1271, 0, 0, 0, 0.1, weight = 0.4 },
	[103] = { "Shelf", "A large shelf to store stuff on", 4, 3761, -0.15, 0, 85, 1.95, weight = 0.1 },
	[104] = { "Portable TV", "A portable TV to watch TV shows with.", 6, 2886, 270, 0, 0, 0.1, weight = 1 },
	[105] = { "Pack of cigarettes", "Pack with #v cigarettes in it.", 6, 2886, 270, 0, 0, 0.1, weight = function(v) return 0.1 + v*0.03 end },
	[106] = { "Cigarette", "Something you can smoke.", 6, 2886, 270, 0, 0, 0.1, weight = 0.03 },
	[107] = { "Lighter", "It makes fire if you use it properly.", 6, 2886, 270, 0, 0, 0.1, weight = 0.05 },
	[108] = { "Pancake", "Yummy, a pancake!.", 1, 2222, 0, 0, 0, 0.07, weight = 0.5 },
	[109] = { "Fruit", "Yummy, healthy food!.", 1, 2222, 0, 0, 0, 0.07, weight = 0.35 },
	[110] = { "Vegetable", "Yummy, healthy food!.", 1, 2222, 0, 0, 0, 0.07, weight = 0.35  },
	[111] = { "Portable GPS", "A GPS, also contains recent maps.", 6, 2886, 270, 0, 0, 0.1, weight = 0.3 },
	[113] = { "Pack of Glowsticks", "Pack with #v glowsticks in it, from the brand 'Friday'.", 6, 2886, 270, 0, 0, 0.1, weight = function(v) return v * 0.2 end },
	[114] = { "Vehicle Upgrade", "#v", 4, 1271, 0, 0, 0, 0.285, weight = 1.5 },
	[115] = { "Weapon", "#v ", 8, 2886, 270, 0, 1, 0.1, 2, weight = function( v ) local weaponID = tonumber( explode(":", v)[1] ) return weaponID and weaponweights[ weaponID ] or 1 end },
	[116] = { "Ammopack", "Ammopack with #v bullets inside.", 9, 2886, 270, 1, 0, 0.1, 3, weight = function( v ) local weaponID = tonumber( explode(":", v)[1] ) local ammo = tonumber( explode(":", v)[2] ) return weaponID and ammo and ammoweights[ weaponID ] and ammoweights[ weaponID ] * ammo or 0.2 end },
	[117] = { "Ramp", "Useful for loading DFT-30s.", 4, 2886, 270, 1, 0, 0.1, 3, weight = 5 },
	[118] = { "Toll Pass", "Put it in your car, charges you every time you drive through a toll booth.", 6, 2886, 270, 0, 0, 0.1, weight = 0.3 },
	[120] = { "Scuba Gear", "Allows you to stay under-water for quite some time", 6, 1271, 0, 0, 0, 0.285, weight = 4 },
	[121] = { "Box with supplies", "Pretty large box full with supplies!", 4, 1271, 0, 0, 0, 0.285, weight = function(v) return v * 0.07 end },
	[122] = { "Briefcase", "A brown briefcase", 4, 1210, 0, 0, 0, 0.285, weight = 0.2 },
}

	-- name, description, category, model, rx, ry, rz, zoffset
	
	-- categories:
	-- 1 = Food & Drink
	-- 2 = Keys
	-- 3 = Drugs
	-- 4 = Other
	-- 5 = Books
	-- 6 = Clothing & Accessories
	-- 7 = Electronics
	-- 8 = guns
	-- 9 = bullets

weaponmodels = {
	[1]=331, [2]=333, [3]=326, [4]=335, [5]=336, [6]=337, [7]=338, [8]=339, [9]=341,
	[15]=326, [22]=346, [23]=347, [24]=348, [25]=349, [26]=350, [27]=351, [28]=352,
	[29]=353, [32]=372, [30]=355, [31]=356, [33]=357, [34]=358, [35]=359, [36]=360,
	[37]=361, [38]=362, [16]=342, [17]=343, [18]=344, [39]=363, [41]=365, [42]=366,
	[43]=367, [10]=321, [11]=322, [12]=323, [14]=325, [44]=368, [45]=369, [46]=371,
	[40]=364, [100]=373
}

-- other melee weapons?
weaponweights = {
	[22] = 1.14, [23] = 1.24, [24] = 2, [25] = 3.1, [26] = 2.1, [27] = 4.2, [28] = 3.6, [29] = 2.640, [30] = 4.3, [31] = 2.68, [32] = 3.6, [33] = 4.0, [34] = 4.3
}

ammoweights =
{
	[22] = 0.0224, [23] = 0.0224, [24] = 0.017, [25] = 0.037, [26] = 0.037, [27] = 0.037, [28] = 0.009, [29] = 0.012, [30] = 0.0165, [31] = 0.0112, [32] = 0.009, [33] = 0.0128, [34] = 0.027
}

--
-- Vehicle upgrades as names
--
vehicleupgrades = {
	"Pro Spoiler", "Win Spoiler", "Drag Spoiler", "Alpha Spoiler", "Champ Scoop Hood",
	"Fury Scoop Hood", "Roof Scoop", "Right Sideskirt", "5x Nitro", "2x Nitro",
	"10x Nitro", "Race Scoop Hood", "Worx Scoop Hood", "Round Fog Lights", "Champ Spoiler",
	"Race Spoiler", "Worx Spoiler", "Left Sideskirt", "Upswept Exhaust", "Twin Exhaust",
	"Large Exhaust", "Medium Exhaust", "Small Exhaust", "Fury Spoiler", "Square Fog Lights",
	"Offroad Wheels", "Right Alien Sideskirt (Sultan)", "Left Alien Sideskirt (Sultan)",
	"Alien Exhaust (Sultan)", "X-Flow Exhaust (Sultan)", "Left X-Flow Sideskirt (Sultan)",
	"Right X-Flow Sideskirt (Sultan)", "Alien Roof Vent (Sultan)", "X-Flow Roof Vent (Sultan)",
	"Alien Exhaust (Elegy)", "X-Flow Roof Vent (Elegy)", "Right Alien Sideskirt (Elegy)",
	"X-Flow Exhaust (Elegy)", "Alien Roof Vent (Elegy)", "Left X-Flow Sideskirt (Elegy)",
	"Left Alien Sideskirt (Elegy)", "Right X-Flow Sideskirt (Elegy)", "Right Chrome Sideskirt (Broadway)",
	"Slamin Exhaust (Chrome)", "Chrome Exhaust (Broadway)", "X-Flow Exhaust (Flash)", "Alien Exhaust (Flash)",
	"Right Alien Sideskirt (Flash)", "Right X-Flow Sideskirt (Flash)", "Alien Spoiler (Flash)",
	"X-Flow Spoiler (Flash)", "Left Alien Sideskirt (Flash)", "Left X-Flow Sideskirt (Flash)",
	"X-Flow Roof (Flash)", "Alien Roof (Flash)", "Alien Roof (Stratum)", "Right Alien Sideskirt (Stratum)",
	"Right X-Flow Sideskirt (Stratum)", "Alien Spoiler (Stratum)", "X-Flow Exhaust (Stratum)",
	"X-Flow Spoiler (Stratum)", "X-Flow Roof (Stratum)", "Left Alien Sideskirt (Stratum)",
	"Left X-Flow Sideskirt (Stratum)", "Alien Exhaust (Stratum)", "Alien Exhaust (Jester)",
	"X-FLow Exhaust (Jester)", "Alien Roof (Jester)", "X-Flow Roof (Jester)", "Right Alien Sideskirt (Jester)",
	"Right X-Flow Sideskirt (Jester)", "Left Alien Sideskirt (Jester)", "Left X-Flow Sideskirt (Jester)",
	"Shadow Wheels", "Mega Wheels", "Rimshine Wheels", "Wires Wheels", "Classic Wheels", "Twist Wheels",
	"Cutter Wheels", "Switch Wheels", "Grove Wheels", "Import Wheels", "Dollar Wheels", "Trance Wheels",
	"Atomic Wheels", "Stereo System", "Hydraulics", "Alien Roof (Uranus)", "X-Flow Exhaust (Uranus)",
	"Right Alien Sideskirt (Uranus)", "X-Flow Roof (Uranus)", "Alien Exhaust (Uranus)",
	"Right X-Flow Sideskirt (Uranus)", "Left Alien Sideskirt (Uranus)", "Left X-Flow Sideskirt (Uranus)",
	"Ahab Wheels", "Virtual Wheeels", "Access Wheels", "Left Chrome Sideskirt (Broadway)",
	"Chrome Grill (Remington)", "Left 'Chrome Flames' Sideskirt (Remington)",
	"Left 'Chrome Strip' Sideskirt (Savanna)", "Covertible (Blade)", "Chrome Exhaust (Blade)",
	"Slamin Exhaust (Blade)", "Right 'Chrome Arches' Sideskirt (Remington)",
	"Left 'Chrome Strip' Sideskirt (Blade)", "Right 'Chrome Strip' Sideskirt (Blade)",
	"Chrome Rear Bullbars (Slamvan)", "Slamin Rear Bullbars (Slamvan)", false, false, "Chrome Exhaust (Slamvan)",
	"Slamin Exhaust (Slamvan)", "Chrome Front Bullbars (Slamvan)", "Slamin Front Bullbars (Slamvan)",
	"Chrome Front Bumper (Slamvan)", "Right 'Chrome Trim' Sideskirt (Slamvan)",
	"Right 'Wheelcovers' Sideskirt (Slamvan)", "Left 'Chrome Trim' Sideskirt (Slamvan)",
	"Left 'Wheelcovers' Sideskirt (Slamvan)", "Right 'Chrome Flames' Sideskirt (Remington)",
	"Bullbar Chrome Bars (Remington)", "Left 'Chrome Arches' Sideskirt (Remington)", "Bullbar Chrome Lights (Remington)",
	"Chrome Exhaust (Remington)", "Slamin Exhaust (Remington)", "Vinyl Hardtop (Blade)", "Chrome Exhaust (Savanna)",
	"Hardtop (Savanna)", "Softtop (Savanna)", "Slamin Exhaust (Savanna)", "Right 'Chrome Strip' Sideskirt (Savanna)",
	"Right 'Chrome Strip' Sideskirt (Tornado)", "Slamin Exhaust (Tornado)", "Chrome Exhaust (Tornado)",
	"Left 'Chrome Strip' Sideskirt (Tornado)", "Alien Spoiler (Sultan)", "X-Flow Spoiler (Sultan)",
	"X-Flow Rear Bumper (Sultan)", "Alien Rear Bumper (Sultan)", "Left Oval Vents", "Right Oval Vents",
	"Left Square Vents", "Right Square Vents", "X-Flow Spoiler (Elegy)", "Alien Spoiler (Elegy)",
	"X-Flow Rear Bumper (Elegy)", "Alien Rear Bumper (Elegy)", "Alien Rear Bumper (Flash)",
	"X-Flow Rear Bumper (Flash)", "X-Flow Front Bumper (Flash)", "Alien Front Bumper (Flash)",
	"Alien Rear Bumper (Stratum)", "Alien Front Bumper (Stratum)", "X-Flow Rear Bumper (Stratum)",
	"X-Flow Front Bumper (Stratum)", "X-Flow Spoiler (Jester)", "Alien Rear Bumper (Jester)",
	"Alien Front Bumper (Jester)", "X-Flow Rear Bumper (Jester)", "Alien Spoiler (Jester)",
	"X-Flow Spoiler (Uranus)", "Alien Spoiler (Uranus)", "X-Flow Front Bumper (Uranus)",
	"Alien Front Bumper (Uranus)", "X-Flow Rear Bumper (Uranus)", "Alien Rear Bumper (Uranus)",
	"Alien Front Bumper (Sultan)", "X-Flow Front Bumper (Sultan)", "Alien Front Bumper (Elegy)",
	"X-Flow Front Bumper (Elegy)", "X-Flow Front Bumper (Jester)", "Chrome Front Bumper (Broadway)",
	"Slamin Front Bumper (Broadway)", "Chrome Rear Bumper (Broadway)", "Slamin Rear Bumper (Broadway)",
	"Slamin Rear Bumper (Remington)", "Chrome Front Bumper (Remington)", "Chrome Rear Bumper (Remington)",
	"Slamin Front Bumper (Blade)", "Chrome Front Bumper (Blade)", "Slamin Rear Bumper (Blade)",
	"Chrome Rear Bumper (Blade)", "Slamin Front Bumper (Remington)", "Slamin Rear Bumper (Savanna)",
	"Chrome Rear Bumper (Savanna)", "Slamin Front Bumper (Savanna)", "Chrome Front Bumper (Savanna)",
	"Slamin Front Bumper (Tornado)", "Chrome Front Bumper (Tornado)", "Chrome Rear Bumper (Tornado)",
	"Slamin Rear Bumper (Tornado)"
}

--
-- Badges
--

function getBadges( )
	return {
		-- [itemID] = {elementData, name, factionIDs, color, iconID}
		[64]  = { "PDbadge", 		"a Police Badge",			{[1] = true},				 	{0,100,255},	2},
		[65]  = { "ESbadge", 		"an Emergency Services ID", {[2] = "LSMS", [4] = "LSFD"},	{175,50,50},	1},
		[86]  = { "SANbadge",		"a SAN ID",					{[20] = true},					{150,150,255},	1},
		[87]  = { "GOVbadge",		"a Government Badge",		{[3] = true},					{50,150,50},	1},
		[82]  = { "HexID",			"a Hex Towing ID",			{[30] = true},					{255,99,0},		1},
	}
end

--
-- Mask Data
--
function getMasks( )
	return {
		-- [itemID] = { elementData, textWhenPuttingOn, textWhentakingOff }
		[26]  = {"gasmask",	"slips a black gas mask over their face",	"slips a black gas mask off their face"},
		[56]  = {"mask",	"slips a mask over their face",				"slips a mask off their face"},
		[90]  = {"helmet",	"puts a helmet over their head",			"takes a helmet off their head"},
		[120] = {"scuba",	"puts scuba gear on",						"takes scuba gear off"},
	}
end
