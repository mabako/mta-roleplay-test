--- clothe shop skins
blackMales = { 310, 311, 300, 301, 302, 296, 297, 268, 269, 270, 271, 272, 7, 14, 15, 16, 17, 18, 20, 21, 22, 24, 25, 28, 35, 36, 50, 51, 66, 67, 78, 79, 80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 260, 262 }
whiteMales = {305, 306, 307, 308, 309, 312, 303, 299, 291, 292, 293, 294, 295, 1, 2, 23, 26, 27, 29, 30, 32, 33, 34, 35, 36, 37, 38, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110, 111, 112, 113, 114, 115, 116, 120, 121, 122, 124, 125, 126, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 170, 171, 173, 174, 175, 177, 179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 240, 241, 242, 247, 248, 250, 252, 254, 255, 258, 259, 261, 264, 272 }
asianMales = {290, 49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 170, 186, 187, 203, 210, 227, 228, 229, 294}
blackFemales = {304, 298, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 91, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 245, 256, 304 }
whiteFemales = {12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 193, 194, 196, 197, 198, 199, 201, 205, 211, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263, 298 }
asianFemales = {38, 53, 54, 55, 56, 88, 141, 169, 178, 224, 225, 226, 263}
local fittingskins = {[0] = {[0] = blackMales, [1] = whiteMales, [2] = asianMales}, [1] = {[0] = blackFemales, [1] = whiteFemales, [2] = asianFemales}}
-- Removed 9 as a black female
-- these are all the skins
skins = { 1, 2, 268, 269, 270, 271, 272, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 7, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 66, 67, 68, 69, 72, 73, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 178, 179, 180, 181, 182, 183, 184, 185, 186, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 263, 264 }

g_shops = {
	{ -- 1
		name = "General Store",
		description = "This shop sells all kind of general purpose items.",
		image = "general.png",
		
		{
			name = "General Items",
			{ name = "Flowers", description = "A bouquet of lovely flowers.", price = 5, itemID = 115, itemValue = 14 },
--			{ name = "Phonebook", description = "A large phonebook of everyones phone numbers.", price = 30, itemID = 7 },
			{ name = "Dice", description = "A black dice with white dots, perfect for gambling.", price = 2, itemID = 10 },
			{ name = "Golf Club", description = "Perfect golf club for hitting that hole-in-one.", price = 60, itemID = 115, itemValue = 2 },
			{ name = "Baseball Bat", description = "Hit a home run with this.", price = 60, itemID = 115, itemValue = 5 },
			{ name = "Shovel", description = "Perfect tool to dig a hole.", price = 40, itemID = 115, itemValue = 6 },
			{ name = "Pool Cue", description = "For that game of pub pool.", price = 35, itemID = 115, itemValue = 7 },
			{ name = "Cane", description = "A stick has never been so classy.", price = 65, itemID = 115, itemValue = 15 },
			{ name = "Fire Extinguisher", description = "There is never one of these around when there is a fire", price = 50, itemID = 115, itemValue = 42 },
			{ name = "Spray Can", description = "Hey, you better not tag with this punk!", price = 50, itemID = 115, itemValue = 41 },
			{ name = "Parachute", description = "If you don't want to splat on the ground, you better buy one", price = 400, itemID = 115, itemValue = 46 },
			{ name = "City Guide", description = "A small city guide booklet.", price = 15, itemID = 18 },
			{ name = "Backpack", description = "A reasonably sized backpack.", price = 30, itemID = 48 },
			{ name = "Fishing Rod", description = "A 7 foot carbon steel fishing rod.", price = 300, itemID = 49 },
			{ name = "Mask", description = "A ski mask.", price = 20, itemID = 56 },
			{ name = "Fuel Can", description = "A small metal fuel canister.", price = 35, itemID = 57, itemValue = 0 },
			{ name = "First Aid Kit", description = "A small First Aid Kit", price = 15, itemID = 70, itemValue = 3 },
			{ name = "Mini Notebook", description = "An empty Notebook, enough to write 5 notes.", price = 10, itemID = 71, itemValue = 5 },
			{ name = "Notebook", description = "An empty Notebook, enough to write 50 notes.", price = 15, itemID = 71, itemValue = 50 },
			{ name = "XXL Notebook", description = "An empty Notebook, enough to write 125 notes.", price = 20, itemID = 71, itemValue = 125 },
			{ name = "Helmet", description = "A helmet commonly used by people riding bikes.", price = 100, itemID = 90 },

			{ name = "Pack of cigaretttes", description = "Things you can smoke...", price = 10, itemID = 105, itemValue = 20 },
			{ name = "Lighters", description = "To light up your addiction, a geuine Zippo!", price = 45, itemID = 107 },
			{ name = "Knife", description = "To help ya out in the kitchen.", price = 15, itemID = 115, itemValue = 4 },
			{ name = "Card Deck", description = "Want to play a game?", price = 10, itemID = 77 },
		},
		{
			name = "Consumable",
			{ name = "Sandwich", description = "A yummy sandwich with cheese.", price = 6, itemID = 8 },
			{ name = "Softdrink", description = "A can of Sprunk.", price = 3, itemID = 9 },
		}
	},
	{ -- 2
		name = "Gun and Ammo Store",
		description = "All your gun needs since 1914.",
		image = "gun.png",
		
		{
			name = "Guns and Ammo",
			{ name = "9mm Pistol", description = "A silver, 9mm handgun.", price = 850, itemID = 115, itemValue = 22, license = true },
			{ name = "9mm magazine", description = "Magazine with 17 bullets, compatible with an Colt-45 pistol.", price = 65, itemID = 116, itemValue = 22, ammo = 17, license = true },
			{ name = "Shotgun", description = "A silver shotgun.", price = 1049, itemID = 115, itemValue = 25, license = true },
			{ name = "10 Beanbag Rounds", description = "10 rounds for a discount price!.", price = 89, itemID = 116, itemValue = 25, ammo = 10, license = true },
			{ name = "Country Rifle", description = "A country rifle", price = 1599, itemID = 115, itemValue = 33, license = true },
			{ name = "Country Rifle magazine", description = "Magazine with 10 rounds for an country rifle", price = 220, itemID = 116, itemValue = 33, ammo = 10, license = true },
		}
	},
	{ -- 3
		name = "Food Store",
		description = "The least poisoned food and drinks on the planet.",
		image = "food.png",
		
		{
			name = "Food",
			{ name = "Sandwich", description = "A yummy sandwich with cheese", price = 5, itemID = 8 },
			{ name = "Taco", description = "A greasy mexican taco", price = 7, itemID = 11 },
			{ name = "Burger", description = "A double cheeseburger with bacon", price = 6, itemID = 12 },
			{ name = "Donut", description = "Hot sticky sugar covered donut", price = 3, itemID = 13 },
			{ name = "Cookie", description = "A luxury chocolate chip cookie", price = 3, itemID = 14 },
			{ name = "Hotdog", description = "Nice, tasty hotdog!", price = 5, itemID = 1 },
			{ name = "Pancake", description = "Yummy, a pancake!!", price = 2, itemID = 108 },
		},
		{
			name = "Drink",
			{ name = "Softdrink", description = "A cold can of Sprunk.", price = 5, itemID = 9 },
			{ name = "Water", description = "A bottle of mineral water.", price = 3, itemID = 15 },
		}
	},
	{ -- 4
		name = "Sex Shop",
		description = "All of the items you'll need for the perfect night in.",
		image = "sex.png",
		
		{
			name = "Sexy",
			{ name = "Long Purple Dildo", description = "A very large purple dildo", price = 20, itemID = 115, itemValue = 10 },
			{ name = "Short Tan Dildo", description = "A small tan dildo.", price = 15, itemID = 115, itemValue = 11 },
			{ name = "Vibrator", description = "A vibrator, what more needs to be said?", price = 25, itemID = 115, itemValue = 12 },
			{ name = "Flowers", description = "A bouquet of lovely flowers.", price = 5, itemID = 115, itemValue = 14 },
			{ name = "Handcuffs", description = "A metal pair of handcuffs.", price = 90, itemID = 45 },
			{ name = "Rope", description = "A long rope.", price = 15, itemID = 46 },
			{ name = "Blindfold", description = "A black blindfold.", price = 15, itemID = 66 },
		},
		{
			name = "Clothes",
			{ name = "Skin 87", description = "Sexy clothes for sexy people.", price = 55, itemID = 16, itemValue = 87 },
			{ name = "Skin 178", description = "Sexy clothes for sexy people.", price = 55, itemID = 16, itemValue = 178 },
			{ name = "Skin 244", description = "Sexy clothes for sexy people.", price = 55, itemID = 16, itemValue = 244 },
			{ name = "Skin 246", description = "Sexy clothes for sexy people.", price = 55, itemID = 16, itemValue = 246 },
			{ name = "Skin 257", description = "Sexy clothes for sexy people.", price = 55, itemID = 16, itemValue = 257 },
		}
	},
	{ -- 5
		name = "Clothes Shop",
		description = "You don't look fat in those!",
		image = "clothes.png",
		-- Items to be generated elsewhere.
		{
			name = "Clothes fitting you"
		},
		{
			name = "Others"
		}
	},
	{ -- 6
		name = "Gym",
		description = "The best place to learn about hand-to-hand combat.",
		image = "general.png",
		
		{
			name = "Fighting Styles",
			{ name = "Standard Combat for Dummies", description = "Standard everyday fighting.", price = 10, itemID = 20 },
			{ name = "Boxing for Dummies", description = "Mike Tyson, on drugs.", price = 50, itemID = 21 },
			{ name = "Kung Fu for Dummies", description = "I know kung-fu, so can you.", price = 50, itemID = 22 },
			-- item ID 23 is just a greek book, anyhow :o
			{ name = "Grab & Kick for Dummies", description = "Kick his 'ead in!", price = 50, itemID = 24 },
			{ name = "Elbows for Dummies", description = "You may look retarded, but you will kick his ass!", price = 50, itemID = 25 },
		}
	},
	{ -- 7
		name = "Magificient Supplies Inc.",
		description = "Your one and only stop for supplies.",
		image = "general.png",
		
		{
			name = "Crates o' Supplies",
			{ name = "Small box", description = "A box filled with supplies.", price = 15, itemID = 121, itemValue = 20 },
			{ name = "Medium box", description = "A box filled with supplies.", price = 35, itemID = 121, itemValue = 50 },
			{ name = "Large box", description = "A box filled with supplies.", price = 55, itemID = 121, itemValue = 100 },
			{ name = "XL Box", description = "A box filled with supplies.", price = 75, itemID = 121, itemValue = 140 },
		}
	},
	{ -- 8
		name = "Electronics Store",
		description = "The latest technology, extremely overpriced just for you.",
		image = "general.png",
		
		{
			name = "Fancy Electronics",
			{ name = "Ghettoblaster", description = "A black ghettoblaster.", price = 250, itemID = 54 },
			{ name = "Camera", description = "A small black analogue camera.", price = 75, itemID = 115, itemValue = 43 },
			{ name = "Cellphone", description = "A stylish, slim cell phone.", price = 75, itemID = 2 },
			{ name = "Radio", description = "A black radio.", price = 50, itemID = 6 },
			{ name = "Earpiece", description = "An earpiece that can be used with an radio.", price = 225, itemID = 88 },
			{ name = "Watch", description = "Telling the time was never so sexy!", price = 25, itemID = 17 },
			{ name = "MP3 Player", description = "A white, sleek looking MP3 Player. The brand reads EyePod.", price = 120, itemID = 19 },
			{ name = "Chemistry Set", description = "A small chemistry set.", price = 2000, itemID = 44 },
			{ name = "Safe", description = "A Safe to store your items in.", price = 300, itemID = 60 },
			{ name = "GPS", description = "A GPS Satnav for a car.", price = 300, itemID = 67 },
			{ name = "Portable GPS", description = "Personal global positioning device, with recent maps.", price = 800, itemID = 111 },
			{ name = "PDA", description = "A top of the range PDA to view e-mails and browse the internet.", price = 1500, itemID = 96 },
			{ name = "Portable TV", description = "A portable TV to watch the TV.", price = 750, itemID = 104 },
			{ name = "Toll Pass", description = "For your car: Automatically charges you when driving through a toll gate.", price = 400, itemID = 118 },
		}
	},
	{ -- 9
		name = "Alcohol Store",
		description = "Everything from Vodka to Beer and the other way round.",
		image = "general.png",
		
		{
			name = "Alcohol",
			{ name = "Ziebrand Beer", description = "The finest beer, imported from Holland.", price = 10, itemID = 58 },
			{ name = "Bastradov Vodka", description = "For your best friends - Bastradov Vodka.", price = 25, itemID = 62 },
			{ name = "Scottish Whiskey", description = "The Best Scottish Whiskey, now exclusively made from Haggis.", price = 15, itemID = 63 },
			{ name = "Softdrink", description = "A cold can of Sprunk.", price = 3, itemID = 9 },
		}
	},
	{ -- 10
		name = "Book Store",
		description = "New things to learn? Sound like... fun?!",
		image = "general.png",
		
		{
			name = "Books",
			{ name = "City Guide", description = "A small city guide booklet.", price = 15, itemID = 18 },
			{ name = "Los Santos Highway Code", description = "A paperback book.", price = 10, itemID = 50 },
			{ name = "Chemistry 101", description = "A hardback academic book.", price = 20, itemID = 51 },
		}
	},
	{ -- 11
		name = "Cafe",
		description = "You want some chocolate on your rim?",
		image = "food.png",
		
		{
			name = "Food",
			{ name = "Donut", description = "Hot sticky sugar covered donut", price = 3, itemID = 13 },
			{ name = "Cookie", description = "A luxuty chocolate chip cookie", price = 3, itemID = 14 },
		},
		{
			name = "Drinks",
			{ name = "Coffee", description = "A small cup of coffee.", price = 1, itemID = 83, itemValue = 2 },
			{ name = "Softdrink", description = "A cold can of Sprunk.", price = 3, itemID = 9, itemValue = 3 },
			{ name = "Water", description = "A bottle of mineral water.", price = 1, itemID = 15, itemValue = 2 },
		}	
	},
	{ -- 12
		name = "Santa's Grotto",
		description = "Ho-ho-ho, Merry Christmas.",
		image = "general.png",
		
		{
			name = "Christmas Items",
			{ name = "Christmas Present", description = "What could be inside?", price = 0, itemID = 94 },
			{ name = "Eggnog", description = "Yum Yum!", price = 0, itemID = 91 },
			{ name = "Turkey", description = "Yum Yum!", price = 0, itemID = 92 },
			{ name = "Christmas Pudding", description = "Yum Yum!", price = 0, itemID = 93 },
		}
	},
	{ -- 13
		name = "Prison Worker",
		description = "Now that looks... vaguely tasty.",
		image = "general.png",
		
		{
			name  = "Disgusting Stuff",
			{ name = "Mixed Dinner Tray", description = "Lets play the guessing game.", price = 0, itemID = 99 },
			{ name = "Small Milk Carton", description = "Lumps included!", price = 0, itemID = 100 },
			{ name = "Small Juice Carton", description = "Thirsty?", price = 0, itemID = 101 },
		}
	},
	{ -- 14
		name = "One Stop Mod Shop",
		description = "Any parts you'll ever need!",
		image = "general.png",
		
		-- items to be filled in later
		{
			name = "Vehicle Parts"
		}
	}
}

-- some initial updating once you start the resource
function loadLanguages( )
	local shop = g_shops[ 10 ]
	for i = 1, exports['language-system']:getLanguageCount() do
		local ln = exports['language-system']:getLanguageName(i)
		if ln then
			table.insert( shop[1], { name = ln .. " Dictionary", description = "A Dictionary, useful for learning " .. ln .. ".", price = 25, itemID = 69, itemValue = i } )
		end
	end
end

addEventHandler( "onResourceStart", resourceRoot, loadLanguages )
addEventHandler( "onClientResourceStart", resourceRoot, loadLanguages )

-- util

function getItemFromIndex( shop_type, index )
	local shop = g_shops[ shop_type ]
	if shop then
		for _, category in ipairs( shop ) do
			if index <= #category then
				return category[index]
			else
				index = index - #category
			end
		end
	end
end

--
local simplesmallcache = {}
function updateItems( shop_type, race, gender )
	if shop_type == 5 then -- clothes shop
		-- one simple small cache it is - prevents us from creating those tables again and again
		--[[
		local c = simplesmallcache[tostring(race) .. "|" .. tostring(gender)]
		if c then
			shop = c
			return
		end
		]]
		
		-- load the shop
		local shop = g_shops[shop_type]
		
		-- clear all items
		for _, category in ipairs(shop) do
			while #category > 0 do
				table.remove( category, i )
			end
		end
		
		-- uber complex logic to add skins
		local nat = {}
		local availableskins = fittingskins[gender][race]
		table.sort(availableskins)
		for k, v in ipairs(availableskins) do
			table.insert( shop[1], { name = "Skin " .. v, description = "MTA Skin #" .. v .. ".", price = 50, itemID = 16, itemValue = v, fitting = true } )
			nat[v] = true
		end
		
		local otherSkins = {}
		for gendr = 0, 1 do
			for rac = 0, 2 do
				if gendr ~= gender or rac ~= race then
					for k, v in pairs(fittingskins[gendr][rac]) do
						if not nat[v] then
							table.insert(otherSkins, v)
						end
					end
				end
			end
		end
		table.sort(otherSkins)
		
		for k, v in ipairs(otherSkins) do
			table.insert( shop[2], { name = "Skin " .. v, description = "MTA Skin #" .. v .." - you can NOT wear this.", price = 50, itemID = 16, itemValue = v } )
		end
		-- simplesmallcache[tostring(race) .. "|" .. tostring(gender)] = shop
	elseif shop_type == 14 then
		-- param (race)= vehicle model
		local c = simplesmallcache["vm"]
		if c then
			return
		end
		
		-- remove old data
		for _, category in ipairs(shop) do
			while #category > 0 do
				table.remove( category, i )
			end
		end
		
		for v = 1000, 1193 do
			if vehicle_upgrades[v-999] then
				local str = exports['item-system']:getItemDescription( 114, v )
				
				local p = str:find("%(")
				local vehicleName = ""
				if p then
					vehicleName = str:sub(p+1, #str-1) .. " - "
					str = str:sub(1, p-2)
				end
				table.insert( shop[1], { name = vehicleName .. ( getVehicleUpgradeSlotName(v) or "Lights" ), description = str, price = vehicle_upgrades[v-999][2], itemID = 114, itemValue = v})
			end
		end
		
		simplesmallcache["vm"] = true
	end
end
