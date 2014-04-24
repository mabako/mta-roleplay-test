function createDutyColShape(posX, posY, posZ, size, interior, dimension) 
	tempShape = createColSphere(posX, posY, posZ, size)
	--exports.pool:allocateElement(tempShape)
	setElementDimension(tempShape, dimension)
	setElementInterior(tempShape, interior)
	return tempShape
end

local policeColShapes = { }

table.insert(policeColShapes, createDutyColShape(272.53515625, 118.1806640625, 1005.2736816406, 3, 10, 1) ) -- PD Pershing square
--table.insert(policeColShapes, createColSphere( 1178.154296875, -1475.4150390625, 29.926813, 3 ) ) -- -- temporary roof for testing

local swatVehicles = { [427] = true }
	
local spdColShapes = { }
table.insert(spdColShapes, createDutyColShape( 1952.34765625, -2359.6533203125, 33.559375762939, 4, 11, 1483) ) -- SPD  duty room
--table.insert(spdColShapes, createDutyColShape( 1751.3662109375, -2523.8876953125, 15.936504364014, 6, 1, 1006) ) -- SPD  duty room
--table.insert(spdColShapes, createDutyColShape( 1772.8642578125, -2523.73828125, 15.936504364014, 6, 1, 1006) ) -- SPD  duty room

local lsesColShapes = { }
--table.insert(lsesColShapes, createDutyColShape( 867.8193359375, -1679.8251953125, -36.163124084473, 5, 1, 161) ) -- LS Hospital Duty room
table.insert(lsesColShapes, createDutyColShape( 1444.8486328125, 1400.0615234375, 11.159375190735, 6, 1, 2279) ) -- EMS County general room

local lsfdColShapes = { }
table.insert(lsfdColShapes, createDutyColShape( 2230.4912109375, -1164.0619140625, 929.00006103516, 6, 3, 10631) ) -- LSFD duty room

local courtColShapes = { }
table.insert(courtColShapes, createDutyColShape(343.2958984375, 194.7607421875, 1014.5885620117, 5, 3, 100) ) -- Court weapon room

local hexColShapes = { }
table.insert(hexColShapes, createDutyColShape(2206.3935546875, 1646.646484375, 991.11834716797, 15, 1, 1472) ) -- Hex weapon room


factionDuty = {
	{ 
		factionID = 1,
		
		packages = {
			{
				packageName = 'LSPD - CPU Duty',
				grantID = 1,
				forceSkinChange = true,
				skins = { 211, 265, 266, 267, 280, 281, 282, 283, 284, 288 },
				colShape = policeColShapes,
				items =	{
					{ -3, 1, false }, -- Nitestick
					{ -24, 50, false }, -- MPW/Deagle
					{ -25, 100, false }, -- Shotgun
					{ -29, 120, false }, -- MP5
					{ -41, 1500, false }, -- Spraycan/Pepperspray
					{ 45, 1, false }, -- Handcuffs
					{ 45, 1, 1 }, -- Handcuffs
					{ -100, 100, false }, -- Kevlar
					{ 53, 1, 1 } -- Breathalizer
				}
			}, 
			
			{
				packageName = 'LSPD - SWAT Duty',
				grantID = 2,
				forceSkinChange = true,
				skins = { 285 },
				colShape = policeColShapes,
				vehicle = swatVehicles,
				items =	{
					{ -24, 50, false }, -- MPW/Deagle
					{ -27, 20, 1 }, -- Shotgun
					{ -29, 100, false }, -- MP5
					{ -31, 200, 1 }, -- M4
					{ -34, 10, false }, -- Sniper
					{ -17, 1, 2 }, -- Tear Gas
					{ -100, 100, false }, -- Kevlar
					{ 26, 1, false }, -- Gas Mask
					{ 27, 1, 2 }, -- Flashbang
					{ 113, 5, false }, -- Pack of glowsticks
					{ 45, 1, false } -- Handcuffs
				}
			}, 
			
			{
				packageName = 'LSPD - Detective Duty',
				grantID = 3,
				forceSkinChange = false,
				colShape = policeColShapes,
				items =	{
					{ -22, 50, false }, -- Colt-45
					{ -43, 250, false }, -- Digital camera
					{ 45, 1, false }, -- Handcuffs
					{ 71, 50, false } -- Notepad
				}
			}, 	
				
			{
				packageName = 'LSPD - Cadet Duty',
				grantID = 4,
				forceSkinChange = true,
				skins = { 71, 211 },
				colShape = policeColShapes,
				items =	{
					{ -3, 50, false }, -- Nightstick
					{ -24, 35, false }, -- MPW/Deagle
					{ -41, 1200, false }, -- Pepperspray
					{ 45, 1, false }, -- Handcuffs
					{ 45, 1, false } -- Handcuffs
				}
			} 
		}
	},
	{ 
		factionID = 2,
		
		packages = {
			{
				packageName = 'LSMS - Medical',
				grantID = 8,
				forceSkinChange = true,
				skins = { 274, 275, 276 },
				colShape = lsesColShapes,
				items =	{
					{ -41, 1500, false }, -- Spraycan/Pepperspray
					{ 70, 5, false } -- First Aid Kit
				}
			}, 
		}
	},
	{ 
		factionID = 4,
		
		packages = {
			{
				packageName = 'LSFD - Firefighter',
				grantID = 9,
				forceSkinChange = true,
				colShape = lsfdColShapes,
				skins = { 277, 278, 279 },
				items =	{
					{ -42, 3000, 1 }, -- Fire Extinguisher
					{ -9, 1, 2 }, -- Chainsaw
					{ 26, 1, false }, -- Gas mask
					{ 70, 2, false } -- First Aid Kit
				}
			},
			{
				packageName = 'LSFD - Fire Inspector',
				grantID = 15,
				forceSkinChange = false,
				colShape = lsfdColShapes,
				items =	{
					{ -43, 100, false }, -- Digital camera
					{ 71, 25, false }, -- Notepad
				}
			},
			{
				packageName = 'LSFD - Search & Rescue',
				grantID = 16,
				forceSkinChange = true,
				colShape = lsfdColShapes,
				skins = { 277, 278, 279 },
				items =	{
					{ -9, 1, false }, -- Chainsaw
					{ 26, 1, false }, -- Gas mask
					{ 70, 5, false }, -- First Aid Kit
					{ 120, 1, false }, -- Scuba Gear
					{ 113, 5, false }, -- Pack of glowsticks
					{ -42, 3000, 1 }, -- Fire Extinguisher
				}
			}, 	
		}
	},
	{ 
		factionID = 30,
		
		packages = {
			{
				packageName = 'Hex - Mechanic',
				grantID = 12,
				forceSkinChange = true,
				colShape = hexColShapes,
				skins = { 50, 305 },
				items =	{
					{ -41, 1500, false }, -- Spraycan/Pepperspray
					{ 26, 1, false }, -- Gas mask
					{ 70, 2, false } -- First Aid Kit
				}
			}, 		
		}
	},
	{ 
		factionID = 36,
		
		packages = {
			{
				packageName = 'Courts - Marshalls',
				grantID = 10,
				forceSkinChange = false,
				skins = { 286 },
				colShape = courtColShapes,
				items =	{
					{ -100, 49, false }, -- 49% Armour
					{ 45, 1, false }, -- Handcuffs
					{ -23, 17, 1 }, -- Deagle
				}
			},
			{
				packageName = 'Courts - Fugitive Task Force',
				grantID = 13,
				forceSkinChange = true,
				skins = { 286 },
				colShape = courtColShapes,
				items =	{
					{ -100, 49, false }, -- 49% Armour
					{ 45, 1, false }, -- Handcuffs
					{ -23, 17, 1 }, -- Deagle
					{ -29, 100, false }, -- MP5
				}
			},	
			{
				packageName = 'Courts - Court Security',
				grantID = 14,
				forceSkinChange = true,
				skins = { 286 },
				colShape = courtColShapes,
				items =	{
					{ -100, 49, false }, -- 49% Armour
					{ 45, 1, false }, -- Handcuffs
					{ -23, 17, 1 }, -- Deagle
					{ -41, 1500, false }, -- Spraycan/Pepperspray
				}
			}				
		}
	},
	{ 
		factionID = 87,
		
		packages = {
			{
				packageName = 'SPD - CHSU Duty',
				grantID = 5,
				forceSkinChange = true,
				skins = { 211, 265, 266, 267, 280, 281, 282, 283, 284, 288 },
				colShape = spdColShapes,
				items =	{
					{ -3, 1, false }, -- Nitestick
					{ -24, 50, false }, -- MPW/Deagle
					{ -25, 100, false }, -- Shotgun
					{ -29, 120, false }, -- MP5
					{ -41, 1500, false }, -- Spraycan/Pepperspray
					{ 45, 1, false }, -- Handcuffs
					{ 45, 1, 1 }, -- Handcuffs
					{ -100, 100, false }, -- Kevlar
					{ 53, 1, 1 } -- Breathalizer
				}
			}, 
			
			
			{
				packageName = 'SPD - BCI Duty',
				grantID = 6,
				forceSkinChange = false,
				colShape = spdColShapes,
				skins = { },
				items =	{
					{ -22, 50, 1 }, -- Colt-45
					{ -24, 50, 1 }, -- Deagle
					{ -43, 250, false }, -- Digital camera
					{ 45, 1, false }, -- Handcuffs
					{ 71, 50, false }, -- Notepad
					{ -100, 49, false }, -- Kevlar
				}
			}, 		
				
			{
				packageName = 'SPD - Cadet Duty',
				grantID = 7,
				forceSkinChange = true,
				skins = { 71, 211 },
				colShape = spdColShapes,
				items =	{
					{ -3, 50, false }, -- Nightstick
					{ -24, 110, false }, -- MPW/Deagle
					{ -41, 1200, false }, -- Pepperspray
					{ -100, 100, false }, -- Kevlar
					{ 45, 1, false }, -- Handcuffs
					{ 45, 1, false } -- Handcuffs
				}
			}, 
			
			{
				packageName = 'SPD - STOP Duty',
				grantID = 11,
				forceSkinChange = true,
				skins = { 285 },
				colShape = spdColShapes,
				items =	{
					{ -3, 1, false }, -- Nightstick
					{ -24, 35, false }, -- MPW/Deagle
					{ -29, 120, 3 }, -- MP5
					{ -31, 150, 3 }, -- M4
					{ -34, 20, false }, -- Sniper
					{ -17, 1, 1 }, -- Tear Gas
					{ -17, 1, 2 }, -- Tear Gas
					{ -100, 100, false }, -- Kevlar
					{ 26, 1, false }, -- Gas Mask
					{ 27, 1, 1 }, -- Flashbang
					{ 27, 1, 2 }, -- Flashbang
					{ 113, 5, false }, -- Pack of glowsticks
					{ 45, 1, 1 } -- Handcuffs
				}
			} 
		}
	}
}

-- -------------------------- --
-- General checking functions --
-- -------------------------- --

function isPlayerInFaction(targetPlayer, factionID)
	return tonumber( getElementData(targetPlayer, "faction") ) == factionID
end

function fetchAvailablePackages( targetPlayer )
	local availablePackages = { }
	
	for index, factionTable in ipairs ( factionDuty ) do	-- Loop all the factions
		if isPlayerInFaction(targetPlayer, factionTable["factionID"]) then
			for index, factionPackage in ipairs ( factionTable["packages"] ) do -- Loop all the faction packages
				local found = false
				for index, packageColShape in ipairs ( factionPackage["colShape"] ) do -- Loop all the colshapes of the factionpackage
					if isElementWithinColShape( targetPlayer, packageColShape ) then
						found = true
						break  -- We found this package already, no need to search the other colshapes
					end
				end
				
				if factionPackage.vehicle and getPedOccupiedVehicle( targetPlayer ) and factionPackage.vehicle[ getElementModel( getPedOccupiedVehicle( targetPlayer ) ) ] then
					found = true
				end
				
				if found and canPlayerUseDutyPackage(targetPlayer, factionPackage) then
					table.insert(availablePackages, factionPackage)
				end
			end
		end
	end
	
	return availablePackages
end

function fetchAllPackages( )
	local availablePackages = { }
	
	for index, factionTable in ipairs ( factionDuty ) do	-- Loop all the factions
		table.insert(availablePackages, factionPackage)
	end
	
	return availablePackages
end

function canPlayerUseDutyPackage(targetPlayer, factionPackage)
	local playerPackagePermission = getElementData(targetPlayer, "factionPackages")
	if playerPackagePermission then
		for index, permissionID in ipairs(playerPackagePermission) do
			if (permissionID == factionPackage["grantID"]) then
				return true
			end
		end
	end
	return false
end

function getFactionPackages( factionID )
	if not factionID or not tonumber( factionID ) then
		return factionDuty
	end
	
	for index, factionTable in ipairs ( factionDuty ) do	-- Loop all the factions
		if tonumber(factionTable["factionID"]) == tonumber( factionID ) then
			return factionTable["packages"]
		end
	end
	
	return {}	
end

addEvent("onPlayerDuty", true)