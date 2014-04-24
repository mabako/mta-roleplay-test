-- Item protection
function isProtected(player, item)
	local protected = getElementData(item, "protected")
	local team = getPlayerTeam(player)
	if not protected or (team and getElementData(team, "id") == protected) then
		return false
	end
	return true
end
function canPickup(player, item)
	if isWatchingTV(player) then
		return false
	elseif isProtected(player, item) then
		if getElementDimension(item) > 0 and (hasItem(player, 4, getElementDimension(item)) or hasItem(player, 5, getElementDimension(item))) then
			return true
		end
		return false
	end
	return true
end

function protectItem(faction)
	if getElementParent(getElementParent(source)) ~= getResourceRootElement(getResourceFromName("item-world")) then
		return
	end
	
	if type(faction) == "number" and exports.global:isPlayerAdmin(client) then
		local protected = getElementData(source, "protected")
		local out = 0
		if protected then
			exports['anticheat-system']:changeProtectedElementDataEx(source, "protected", false, false)
			outputChatBox("Unset", client, 0, 255, 0)
			out = 0
		else
			exports['anticheat-system']:changeProtectedElementDataEx(source, "protected", faction, false)
			outputChatBox("Set to " .. faction .. " - if you want a different faction, /itemprotect [faction id or -100]", client, 255, 0, 0)
			out = faction
		end
		result = mysql:query_free("UPDATE worlditems SET protected = " .. faction .. " WHERE id = " .. getElementData( source, "id" ) )
	end
end
addEvent("protectItem", true)
addEventHandler("protectItem", root, protectItem)


-- This is simply to MANAGE world items. Not to create them.
local badges = getBadges()
local masks = getMasks()

function dropItem(itemID, x, y, z, ammo, keepammo)
	if isWatchingTV(source) then
		return
	end
	
	if isPedDead(source) or getElementData(source, "injuriedanimation") then return end
	
	local interior = getElementInterior(source)
	local dimension = getElementDimension(source)
	
	local rz2 = getPedRotation(source)
	if not ammo then
		local itemSlot = itemID
		local itemID, itemValue = unpack( getItems( source )[ itemSlot ] )
		
		local weaponBlock = false
		if ( itemID == 115) then -- Weapons
			local itemCheckExplode = exports.global:explode(":", itemValue)
			-- itemCheckExplode: [1] = gta weapon id, [2] = serial number, [3] = weapon name
			local weaponDetails = exports.global:retrieveWeaponDetails( itemCheckExplode[2]  )
			if (tonumber(weaponDetails[2]) and tonumber(weaponDetails[2]) == 2)  then -- /duty
				outputChatBox("You cannot drop your duty gun, sorry.", source, 255, 0, 0)
				weaponBlock = true
			end
		elseif ( itemID == 116) then -- Ammo
			local ammoDetails = exports.global:explode( ":", itemValue  )
			local checkString = string.sub(ammoDetails[3], -4)
			if (checkString == " (D)")  then -- /duty
				outputChatBox("You cannot drop your duty gun ammo, sorry.", source, 255, 0, 0)
				weaponBlock = true
			end
		end
		
		if itemID == 60 then
			outputChatBox( "This Item can't be dropped.", source )
		elseif ( itemID == 81 or itemID == 103 ) and dimension == 0 then
			outputChatBox( "You need to drop this item in an interior.", source )
		elseif (weaponBlock) then
			-- Do nothing
		else
			if not (hasItem(source, itemID)) then
				local haxStr = getPlayerName(thePlayer) .. " ".. getPlayerIP(thePlayer) .." tried to duplicate item " ..tostring(itemID) .." C0x0000003[BETA]"
				outputDebugString(haxStr)
				exports.logs:logMessage(haxStr, 32)
				exports.global:sendMessageToAdmins("AdmWrn: " .. haxStr)		
			end
			if itemID == 48 and countItems( source, 48 ) == 1 then
				if getCarriedWeight( source ) > 10 - getItemWeight( 48, 1 ) then
					return
				end
			end
			local insert = mysql:query("INSERT INTO worlditems SET itemid='" .. itemID .. "', itemvalue='" .. mysql:escape_string( itemValue) .. "', creationdate = NOW(), x = " .. x .. ", y = " .. y .. ", z= " .. z .. ", dimension = " .. dimension .. ", interior = " .. interior .. ", rz = " .. rz2 .. ", creator=" .. getElementData(source, "dbid"))
			if insert then
				local id = mysql:insert_id()
				mysql:free_result(insert)
				
				outputChatBox("You dropped a " .. getItemName( itemID, itemValue ) .. ".", source, 255, 194, 14)

				-- Animation
				exports.global:applyAnimation(source, "CARRY", "putdwn", 500, false, false, true)
				toggleAllControls( source, true, true, true )
				triggerClientEvent(source, "onClientPlayerWeaponCheck", source)
				-- Create Object
				local modelid = getItemModel(tonumber(itemID), itemValue)
				
				local rx, ry, rz, zoffset = getItemRotInfo(itemID)
				local obj = exports['item-world']:createItem(id, itemID, itemValue, modelid, x, y, z + zoffset - 0.05, rx, ry, rz+rz2)
				exports.pool:allocateElement(obj)
				
				setElementInterior(obj, interior)
				setElementDimension(obj, dimension)
				
				if (itemID==76) then
					moveObject(obj, 200, x, y, z + zoffset, 90, 0, 0)
				else
					moveObject(obj, 200, x, y, z + zoffset)
				end
				
				exports['anticheat-system']:changeProtectedElementDataEx(obj, "creator", getElementData(source, "dbid"), false)
				
				takeItemFromSlot( source, itemSlot )
				
				exports.logs:logMessage( getElementData(source, "account:username").."\\"..getPlayerName(source) .. " -> ~World #" .. getElementID(obj) .. " - " .. getItemName( itemID ) .. " - " .. itemValue, 17)
				
				doItemGiveawayChecks(source, itemID)
				
				exports.global:sendLocalMeAction(source, "dropped a " .. getItemName( itemID, itemValue ) .. ".")
			end
		end
	else
		if tonumber(getElementData(source, "duty")) > 0 then
			outputChatBox("You can't drop your weapons while being on duty.", source, 255, 0, 0)
		elseif tonumber(getElementData(source, "job")) == 4 and itemID == 41 then
			outputChatBox("You can't drop this spray can.", source, 255, 0, 0)
		else
		
			
			if ammo <= 0 then
				return
			end
			
			local totalAmmoPosessed = exports.global:getWeaponCount(source, itemID) 
			if (totalAmmoPosessed < ammo) then
				local haxStr = getPlayerName(thePlayer) .. " ".. getPlayerIP(thePlayer) .." tried to duplicate weapon " .. tokenweapon .. " with " .. ammo .." ammo C0x0000003[BETA]"
				outputDebugString(haxStr)
				exports.logs:logMessage(haxStr, 32)
				exports.global:sendMessageToAdmins("AdmWrn: " .. haxStr)		
			end
			
			outputChatBox("You dropped a " .. ( getWeaponNameFromID( itemID ) or "Body Armor" ) .. ".", source, 255, 194, 14)
			
			-- Animation
			exports.global:applyAnimation(source, "CARRY", "putdwn", 500, false, false, true)
			toggleAllControls( source, true, true, true )
			triggerClientEvent(source, "onClientPlayerWeaponCheck", source)	
			if itemID == 100 then
				z = z + 0.1
				setPedArmor(source, 0)
			end
			
			local query = mysql:query("INSERT INTO worlditems SET itemid=" .. -itemID .. ", itemvalue=" .. ammo .. ", creationdate=NOW(), x=" .. x .. ", y=" .. y .. ", z=" .. z+0.1 .. ", dimension=" .. dimension .. ", interior=" .. interior .. ", rz = " .. rz2 .. ", creator=" .. getElementData(source, "dbid"))
			if query then
				local id = mysql:insert_id()
				mysql:free_result(query)
				
				exports.global:takeWeapon(source, itemID)
				if keepammo then
					exports.global:giveWeapon(source, itemID, keepammo)
				end
				
				local modelid = 2969
				-- MODEL ID
				if (itemID==100) then
					modelid = 1242
				elseif (itemID==42) then
					modelid = 2690
				else
					modelid = weaponmodels[itemID]
				end
				
				local obj = exports['item-world']:createItem(id, -itemID, ammo, modelid, x, y, z - 0.4, 75, -10, rz2)
				exports.pool:allocateElement(obj)
				
				setElementInterior(obj, interior)
				setElementDimension(obj, dimension)
				
				moveObject(obj, 200, x, y, z+0.1)
				
				exports['anticheat-system']:changeProtectedElementDataEx(obj, "creator", getElementData(source, "dbid"), false)
				
				exports.global:sendLocalMeAction(source, "dropped a " .. getItemName( -itemID ) .. ".")
				
				triggerClientEvent(source, "saveGuns", source, getPlayerName(source))
				
				exports.logs:logMessage( getElementData(source, "account:username").."\\"..getPlayerName(source) .. " -> ~World #" .. getElementID(obj) .. " - " .. getItemName( -itemID ) .. " - " .. ammo, 17)
			end
		end
	end
	triggerClientEvent( source, "finishItemDrop", source )
end
addEvent("dropItem", true)
addEventHandler("dropItem", getRootElement(), dropItem)

function doItemGiveawayChecks(source, itemID)
	local mask = masks[itemID]
	if mask and getElementData(source, mask[1]) and not hasItem(source, itemID) then
		exports.global:sendLocalMeAction(source, mask[3] .. ".")
		exports['anticheat-system']:changeProtectedElementDataEx(source, mask[1])
	end
	
	-- Clothes
	if itemID == 16 and not hasItem(source, 16, getPedSkin(source)) then
		local gender = getElementData(source,"gender")
		local race = getElementData(source,"race")
		local result = mysql:query_fetch_assoc("SELECT skincolor, gender FROM characters WHERE id='" .. getElementData(source, "dbid") .. "' LIMIT 1")
		local skincolor = tonumber(result["skincolor"])
		local gender = tonumber(result["gender"])
		
		if (gender==0) then -- MALE
			if (skincolor==0) then -- BLACK
				setElementModel(source, 80)
			elseif (skincolor==1 or skincolor==2) then -- WHITE
				setElementModel(source, 252)
			end
		elseif (gender==1) then -- FEMALE
			if (skincolor==0) then -- BLACK
				setElementModel(source, 139)
			elseif (skincolor==1) then -- WHITE
				setElementModel(source, 138)
			elseif (skincolor==2) then -- ASIAN
				setElementModel(source, 140)
			end
		end
		exports.mysql:query_free( "UPDATE characters SET skin = '" .. exports.mysql:escape_string(getElementModel(source)) .. "' WHERE id = '" .. exports.mysql:escape_string(getElementData( source, "dbid" )).."'" )
	end
	
	-- Badges
	local badge = badges[itemID]
	if badge and getElementData(source, badge[1]) and not hasItem(source, itemID, removeOOC(getElementData(source, badge[1]))) then
		exports.global:sendLocalMeAction(source, "removes a " .. badge[2] .. ".")
		exports['anticheat-system']:changeProtectedElementDataEx(source, badge[1])
		exports.global:updateNametagColor(source)
	end
	
	-- Riot Shield
	if itemID == 76 and shields[source] and not hasItem(source, 76) then
		destroyElement(shields[source])
		shields[source] = nil
	end
	
	-- MP3-player
	if itemID == 19 and not hasItem(source, itemID) then
		triggerClientEvent(source, "realism:mp3:off", source)
	end
end

local function moveItem(item, x, y, z)
	if isWatchingTV(source) then
		return
	end
	
	local id = getElementData(item, "id")
	if not ( z ) then
		destroyElement(item)
		exports.mysql:query_free("DELETE FROM worlditems WHERE id = " .. exports.mysql:escape_string(id))
		return
	end
	
	local itemID = getElementData(item, "itemID")
	if not canPickup(source, item) then
		outputChatBox("You can not move this item. Contact an admin via F2.", source, 255, 0, 0)
		return
	end
	
	-- fridges and shelves can't be moved
	if not exports.global:isPlayerAdmin(source) and (itemID == 81 or itemID == 103) then
		return
	end
	
	-- check if no-one is standing on the item (should be cancelled client-side), but just in case
	for key, value in ipairs(getElementsByType("player")) do
		if getPedContactElement(value) == item then
			return
		end
	end
	
	local result = mysql:query_free("UPDATE worlditems SET x = " .. x .. ", y = " .. y .. ", z = " .. z .. " WHERE id = " .. getElementData( item, "id" ) )
	if result then
		if itemID > 0 then
			local rx, ry, rz, zoffset = getItemRotInfo(itemID)
			z = z + zoffset
		elseif itemID == 100 then
			z = z + 0.1
		end
		setElementPosition(item, x, y, z)
	end
end
addEvent("moveItem", true)
addEventHandler("moveItem", getRootElement(), moveItem)

local function rotateItem(item, rz)
	if not exports.global:isPlayerAdmin(source) then
		return
	end
	
	local id = getElementData(item, "id")
	if not rz then
		destroyElement(item)
		exports.mysql:query_free("DELETE FROM worlditems WHERE id = " .. exports.mysql:escape_string(id))
		return
	end
	
	local rx, ry, rzx = getElementRotation(item)
	rz = rz + rzx
	local result = mysql:query_free("UPDATE worlditems SET rz = " .. rz .. " WHERE id = " .. exports.mysql:escape_string(id) )
	if result then
		setElementRotation(item, rx, ry, rz)
	end
end
addEvent("rotateItem", true)
addEventHandler("rotateItem", getRootElement(), rotateItem)

function pickupItem(object, leftammo)
	if not isElement(object) then
		return
	end
	
	local x, y, z = getElementPosition(source)
	local ox, oy, oz = getElementPosition(object)
	
	if (getDistanceBetweenPoints3D(x, y, z, ox, oy, oz)<10) then
		
		-- Inventory Tooltip
		if (getResourceFromName("tooltips-system"))then
			triggerClientEvent(source,"tooltips:showHelp",source,14)
		end
		
		-- Animation
		
		local id = getElementData(object, "id")
		
		local itemID = getElementData(object, "itemID")
		if not canPickup(source, object) then
			outputChatBox("You can not pick up this item. Contact an admin via F2.", source, 255, 0, 0)
			return
		end
		local itemValue = getElementData(object, "itemValue") or 1
		exports.global:applyAnimation(source, "CARRY", "liftup", 600, false, true, true)
		if itemID > 0 then
			mysql:query_free("DELETE FROM worlditems WHERE id='" .. id .. "'")
			
			giveItem(source, itemID, itemValue)
			
			while #getItems(object) > 0 do
				moveItem2(object, source, 1)
				--outputChatBox("Moved something, atleast tried to")
			end
			
			exports.logs:logMessage( "~World #" .. getElementID(object) .. "->" .. getElementData(source, "account:username").."\\"..getPlayerName(source) .. " - " .. getItemName( itemID ) .. " - " .. itemValue, 17)
			
			destroyElement(object)
		elseif itemID == -100 then
			mysql:query_free( "DELETE FROM worlditems WHERE id='" .. id .. "'")
			exports.logs:logMessage( "~World #" .. getElementID(object) .. "->" .. getElementData(source, "account:username").."\\"..getPlayerName(source) .. " - " .. getItemName( itemID ) .. " - " .. itemValue, 17)
			destroyElement(object)
			
			setPedArmor(source, itemValue)
		else
			exports.logs:logMessage( "~World #" .. getElementID(object) .. "->" .. getElementData(source, "account:username").."\\"..getPlayerName(source) .. " - " .. getItemName( itemID ) .. " - " .. itemValue, 17)
			if leftammo and itemValue > leftammo then
				itemValue = itemValue - leftammo
				exports['anticheat-system']:changeProtectedElementDataEx(object, "itemValue", itemValue)
				
				mysql:query_free("UPDATE worlditems SET itemvalue=" .. itemValue .. " WHERE id=" .. id)
				
				itemValue = leftammo
			else
				mysql:query_free("DELETE FROM worlditems WHERE id='" .. id .. "'")
				destroyElement(object)
			end
			exports.global:giveWeapon(source, -itemID, itemValue, true)
		end
		outputChatBox("You picked up a " .. getItemName( itemID, itemValue ) .. ".", source, 255, 194, 14)
		exports.global:sendLocalMeAction(source, "bends over and picks up a " .. getItemName( itemID, itemValue ) .. ".")
		triggerClientEvent(source, "item:updateclient", source)
	else
		outputDebugString("Distance between Player and Pickup too large")
	end
end
addEvent("pickupItem", true)
addEventHandler("pickupItem", getRootElement(), pickupItem)

function getNearbyItems(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Items:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theObject in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("item-world")))) do
			local dbid = getElementData(theObject, "id")
			
			if dbid then
				local x, y, z = getElementPosition(theObject)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				
				if distance <= 10 and getElementDimension(theObject) == getElementDimension(thePlayer) and getElementInterior(theObject) == getElementInterior(thePlayer) then
					outputChatBox("   #" .. dbid .. (getElementData(theObject, "protected") and ("(" .. getElementData(theObject, "protected").. ")") or "") .. " by " .. ( exports['cache']:getCharacterName( getElementData(theObject, "creator"), true ) or "?" ) .. " - " .. ( getItemName( getElementData(theObject, "itemID") ) or "?" ) .. "(" .. getElementData(theObject, "itemID") .. "): " .. tostring( getElementData(theObject, "itemValue") or 1 ), thePlayer, 255, 126, 0)
					count = count + 1
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyitems", getNearbyItems, false, false)

function delItem(thePlayer, commandName, targetID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetID) then
			outputChatBox("SYNTAX: " .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local object = nil
			targetID = tonumber( targetID )
			
			for key, value in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("item-world")))) do
				local dbid = getElementData(value, "id")
				if dbid and dbid == targetID then
					object = value
					break
				end
			end
			
			if object then
				local id = getElementData(object, "id")
				local result = mysql:query_free("DELETE FROM worlditems WHERE id='" .. id .. "'")
						
				outputChatBox("Item #" .. id .. " deleted.", thePlayer)
				destroyElement(object)
			else
				outputChatBox("Invalid item ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delitem", delItem, false, false)

function getNearbyItems(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Items:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theObject in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("item-world")))) do
			local dbid = getElementData(theObject, "id")
			
			if dbid then
				local x, y, z = getElementPosition(theObject)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				
				if distance <= 10 and getElementDimension(theObject) == getElementDimension(thePlayer) and getElementInterior(theObject) == getElementInterior(thePlayer) then
					local id = getElementData(theObject, "id")
					mysql:query_free("DELETE FROM worlditems WHERE id='" .. id .. "'")
					destroyElement(theObject)
					count = count + 1
				end
			end
		end
		
		outputChatBox( count .. " Items deleted.", thePlayer, 255, 126, 0)
	end
end
addCommandHandler("delnearbyitems", getNearbyItems, false, false)
