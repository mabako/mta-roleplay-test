function findGrant(thePlayer, grantID, fetchAll)
	local allPackages = fetchAll and fetchAllPackages( ) or fetchAvailablePackages( thePlayer )
	if allPackages then
		for pIndex, packageDetails in ipairs(allPackages) do
			if ( tonumber( packageDetails["grantID"] ) == tonumber( grantID ) ) then
				return packageDetails
			end
		end
	end
end

addEvent("duty:request", true)
function dutyRequest(grantID, itemTable, skinID)
	local thePlayer = client

	-- Fetch the factionPackage
	local foundPackage = findGrant(thePlayer, grantID)
	
	if foundPackage and canPlayerUseDutyPackage(thePlayer, foundPackage) then
		-- We've got an auth for the package
		
		-- Now we check the contents
		for itemIndexID, itemTableContent in ipairs(itemTable) do
			local found = false
			
			for aItemIndexID, aItemTableContent in ipairs(foundPackage["items"]) do
				if aItemTableContent[1] == itemTableContent[1] and aItemTableContent[2] == itemTableContent[2] then
					found = true
				end
			end
			
			if not found then
				outputChatBox("Error.", thePlayer)
				return false
			end
		end
		
		for itemIndexID, itemTableContent in ipairs(itemTable) do
			if itemTableContent[1] > 0 then -- its a real item
				exports.global:giveItem(thePlayer, itemTableContent[1], itemTableContent[2]) 
			else -- Its a weapon :O!
				if itemTableContent[1] == -100 then
					setPedArmor(thePlayer, itemTableContent[2])
				else
					local hasAmmo = true
					local characterDatabaseID = getElementData(thePlayer, "account:character:id")
					local gtaWeaponID = tonumber(itemTableContent[1]) - tonumber(itemTableContent[1]) - tonumber(itemTableContent[1])
					local weaponSerial = exports.global:createWeaponSerial(2, characterDatabaseID)
					exports.global:giveItem(thePlayer, 115, gtaWeaponID ..":".. weaponSerial ..":" .. getWeaponNameFromID ( gtaWeaponID ) .. " (D)"  ) 
					
					local gtaweaponcap = exports.weaponcap:getGTACap(gtaWeaponID)
					local packsToGive = math.ceil( tonumber(itemTableContent[2]) / gtaweaponcap)
					
					if (getSlotFromWeapon ( gtaWeaponID ) < 2) then
						hasAmmo = false
					elseif ( getSlotFromWeapon ( gtaWeaponID ) == 9) then -- Spraycan, Fire Extinguisher, Camera
						hasAmmo = false
					end

					if packsToGive > 0 and hasAmmo then
						for i=1,packsToGive do 
							exports.global:giveItem(thePlayer, 116, gtaWeaponID ..":".. gtaweaponcap ..":Ammopack for " .. getWeaponNameFromID ( gtaWeaponID ) .. " (D)"  ) 
						end
					end
					
					
				end
			end
		end
		
		if skinID and tonumber(skinID) then
			setElementModel(thePlayer, skinID)
		end
		
		triggerClientEvent(thePlayer, "onPlayerDuty", thePlayer, true)
		triggerEvent("onPlayerDuty", thePlayer, true)
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "duty", grantID, false)
		exports.mysql:query_free( "UPDATE characters SET skin = '" .. exports.mysql:escape_string(getElementModel( thePlayer )) .. "', duty = '" .. exports.mysql:escape_string(getElementData( thePlayer, "duty" ) or 0 ) .. "' WHERE id = '" .. exports.mysql:escape_string(getElementData( thePlayer, "dbid" )).."'" )	

	end
	return false
end
addEventHandler("duty:request", getRootElement(), dutyRequest)

addEvent("duty:offduty", true)

function dutyOffduty()
	local thePlayer = client or source
	local grantID = getElementData(thePlayer, "duty") or 0
	if grantID > 0 then
		setPedArmor(thePlayer, 0)
		local correction = 0
		outputDebugString("A1")
		local items = exports['item-system']:getItems( thePlayer ) -- [] [1] = itemID [2] = itemValue
		for itemSlot, itemCheck in ipairs(items) do
			if (itemCheck[1] == 115) then -- Weapon
				local itemCheckExplode = exports.global:explode(":", itemCheck[2])
				local serialNumberCheck = exports.global:retrieveWeaponDetails(itemCheckExplode[2])
				if (tonumber(serialNumberCheck[2]) == 2) then -- /duty spawned
					exports['item-system']:takeItemFromSlot(thePlayer, itemSlot - correction, false)
					correction = correction + 1
				end
			elseif (itemCheck[1] == 116) then
				local checkString = string.sub(itemCheck[2], -4)
				if checkString == " (D)" then -- duty given weapon
					exports['item-system']:takeItemFromSlot(thePlayer, itemSlot - correction, false)
					correction = correction + 1
				end
			end
		end
		
		-- remove duty items
		local foundPackage = findGrant(thePlayer, grantID, true)
		if foundPackage then
			for itemIndexID, itemTableContent in ipairs(foundPackage.items) do
				if itemTableContent[1] > 0 then -- its a real item
					exports.global:takeItem(thePlayer, itemTableContent[1], itemTableContent[2]) 
				end
			end
		end
		
		local casualskin = getElementData(thePlayer, "casualskin")
		setElementModel(thePlayer, casualskin)
		exports.mysql:query_free( "UPDATE characters SET skin = '" .. exports.mysql:escape_string(getElementModel( thePlayer )) .. "', duty = '0' WHERE id = '" .. exports.mysql:escape_string(getElementData( thePlayer, "dbid" )).."'" )	
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "duty", 0, false)
		triggerClientEvent(thePlayer, "onPlayerDuty", thePlayer, false)
		triggerEvent("onPlayerDuty", thePlayer, false)
	end
end
addEventHandler("duty:offduty", getRootElement(), dutyOffduty)
