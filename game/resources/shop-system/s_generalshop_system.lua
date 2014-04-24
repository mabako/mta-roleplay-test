mysql = exports.mysql
local useShopsWithNoItems = false

-- respawn dead npcs after two minute
addEventHandler("onPedWasted", getResourceRootElement(),
	function()
		setTimer(
			function( source )
				local x,y,z = getElementPosition(source)
				local rotation = getElementData(source, "rotation")
				local interior = getElementInterior(source)
				local dimension = getElementDimension(source)
				local dbid = getElementData(source, "dbid")
				local shoptype = getElementData(source, "shoptype")
				local skin = getElementModel(source)
				
				destroyElement(source)
				createShopKeeper(x,y,z,interior,dimension,dbid,shoptype,rotation,skin)
			end,
			120000, 1, source
		)
	end
)

local skins = { { 211, 217 }, { 179 }, false, { 178 }, { 82 }, { 80, 81 }, { 28, 29 }, { 169 }, { 171, 172 }, { 142 }, { 171 }, { 171, 172 }, {71}, { 50 } }

function createShopKeeper(x,y,z,interior,dimension,id,shoptype,rotation, skin)
	if not g_shops[shoptype] then
		outputDebugString("Trying to locate shop #" .. id .. " with invalid shoptype " .. shoptype)
		return
	end
	
	if not skin then
		skin = 0
		
		if shoptype == 3 then
			skin = 168
			-- needs differences for burgershot etc
			if interior == 5 then
				skin = 155
			elseif interior == 9 then
				skin = 167
			elseif interior == 10 then
				skin = 205
			end
			-- interior 17 = donut shop
		else
			-- clothes, interior 5 = victim
			-- clothes, interior 15 = binco
			-- clothes, interior 18 = zip
			skin = skins[shoptype][math.random( 1, #skins[shoptype] )]
		end
	end
	
	local ped = createPed(skin, x, y, z)
	setPedRotation(ped, rotation)
	setElementDimension(ped, dimension)
	setElementInterior(ped, interior)
	exports.pool:allocateElement(ped)
	exports['anticheat-system']:changeProtectedElementDataEx(ped, "shopkeeper", true)
	setElementFrozen(ped, true)
	
	exports['anticheat-system']:changeProtectedElementDataEx(ped, "dbid", id, false)
	exports['anticheat-system']:changeProtectedElementDataEx(ped, "type", "shop", false)
	exports['anticheat-system']:changeProtectedElementDataEx(ped, "shoptype", shoptype, false)
	exports['anticheat-system']:changeProtectedElementDataEx(ped, "rotation", rotation, false)
end

function createGeneralshop(thePlayer, commandName, shoptype, skin)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local shoptype = tonumber(shoptype)
		if shoptype and g_shops[shoptype] then
			local skin = tonumber(skin)
			if skin then
				local ped = createPed(skin, 0, 0, 3)
				if not ped then
					outputChatBox("Invalid Skin.", thePlayer, 255, 0, 0)
					return
				else
					destroyElement(ped)
				end
			else
				skin = -1
			end
			local x, y, z = getElementPosition(thePlayer)
			local dimension = getElementDimension(thePlayer)
			local interior = getElementInterior(thePlayer)
			local rotation = math.ceil(getPedRotation(thePlayer) / 30)*30
			
			local id = mysql:query_insert_free("INSERT INTO shops SET x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .. "', z='" .. mysql:escape_string(z) .. "', dimension='" .. mysql:escape_string(dimension) .. "', interior='" .. mysql:escape_string(interior) .. "', shoptype='" .. mysql:escape_string(shoptype) .. "', rotation='" .. mysql:escape_string(rotation) .. "',skin=".. mysql:escape_string(skin))
			
			if (id) then
				createShopKeeper(x,y,z,interior,dimension,id,tonumber(shoptype),rotation,skin ~= -1 and skin)
				outputChatBox("General shop created with ID #" .. id .. " and type "..shoptype..".", thePlayer, 0, 255, 0)
				exports.logs:logMessage("[/makeshop] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." did make shop id " .. id .. " with type " .. shoptype, 4)
			else
				outputChatBox("Error creating shop.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("SYNTAX: /" .. commandName .. " [shop type] [optional skin]", thePlayer, 255, 194, 14)
			for k, v in ipairs(g_shops) do
				outputChatBox("TYPE " .. k .. " = " .. v.name, thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("makeshop", createGeneralshop, false, false)

function getNearbyGeneralshops(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby shops:", thePlayer, 255, 126, 0)
		local count = 0
		
		local dimension = getElementDimension(thePlayer)
		
		for k, thePed in ipairs(exports.pool:getPoolElementsByType("ped")) do
			local pedType = getElementData(thePed, "type")
			if (pedType) then
				if (pedType=="shop") then
					local x, y = getElementPosition(thePed)
					local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
					local cdimension = getElementDimension(thePed)
					if (distance<=10) and (dimension==cdimension) then
						local dbid = getElementData(thePed, "dbid")
						local shoptype = getElementData(thePed, "shoptype")
						outputChatBox("   Shop with ID " .. dbid .. " and type "..shoptype..".", thePlayer, 255, 126, 0)
						count = count + 1
					end
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyshops", getNearbyGeneralshops, false, false)

function deleteGeneralShop(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local counter = 0
			
			for k, thePed in ipairs(exports.pool:getPoolElementsByType("ped")) do
				local pedType = getElementData(thePed, "type")
				if (pedType) then
					if (pedType=="shop") then
						local dbid = getElementData(thePed, "dbid")
						if (tonumber(id)==dbid) then
							destroyElement(thePed)
							mysql:query_free("DELETE FROM shops WHERE id='" .. mysql:escape_string(dbid) .. "' LIMIT 1")
							outputChatBox("Deleted shop with ID #" .. id .. ".", thePlayer, 0, 255, 0)
							counter = counter + 1
						end
					end
				end
			end
			
			if (counter==0) then
				outputChatBox("No shops with such an ID exists.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delshop", deleteGeneralShop, false, false)

function loadAllGeneralshops(res)
	local result = mysql:query("SELECT id, x, y, z, dimension, interior, shoptype, rotation, skin FROM shops")
	
	while true do
		local row = exports.mysql:fetch_assoc(result)
		if not (row) then
			break
		end
		
		local id = tonumber(row["id"])
		local x = tonumber(row["x"])
		local y = tonumber(row["y"])
		local z = tonumber(row["z"])
			
		local dimension = tonumber(row["dimension"])
		local interior = tonumber(row["interior"])
		local shoptype = tonumber(row["shoptype"])
		
		local rotation = tonumber(row["rotation"])
		local skin = tonumber(row["skin"])
			
		createShopKeeper(x,y,z,interior,dimension,id,shoptype,rotation,skin ~= -1 and skin)
	end
	mysql:free_result(result)
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllGeneralshops)

-- end of loading shops, this be store keeper thing below --
local function getDiscount( player, shoptype )
	local discount = 1
	if shoptype == 7 and tonumber( getElementData( player, "faction" ) ) == 125 then
		discount = discount * 0.5
	elseif shoptype == 14 and tonumber( getElementData( player, "faction" ) ) == 30 then
		discount = discount * 0.5
	end
	
	if exports.donators:hasPlayerPerk( player, 8 ) then
		discount = discount * 0.8
	end
	return discount
end

function clickStoreKeeper()
	local shoptype = getElementData(source, "shoptype")
	
	local race, gender = nil, nil
	if(shoptype == 5) then -- if its a clothes shop, we also need the players race
		gender = getElementData(client,"gender")
		race = getElementData(client,"race")
	end
	
	-- perk 8 = 20% discount in shops
	triggerClientEvent(client, "showGeneralshopUI", source, shoptype, race, gender, getDiscount(client, shoptype))
end
addEvent("shop:keeper", true)
addEventHandler("shop:keeper", getResourceRootElement(), clickStoreKeeper)


function calcSupplyCosts(thePlayer, itemID, isWeapon, supplyCost)
	if not isweapon and id ~= 68 then
		if exports.donators:hasPlayerPerk(thePlayer, 8) then
			return math.ceil( 0.8 * supplyCost )
		end
	end
	return supplyCost
end

function getInteriorOwner( dimension )
	if dimension == 0 then
		return nil, nil
	end
	
	local dbid, theEntrance, theExit, interiorType, interiorElement = exports["interior-system"]:findProperty(source)
	interiorStatus = getElementData(interiorElement, "status")
	local owner = interiorStatus[4]
	
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		local id = getElementData(value, "dbid")
		if (id==owner) then
			return owner, value
		end
	end
	return owner, nil -- no player found
end

-- source = the ped clicked
-- client = the player
-- this has no code for the out-of-date lottery.
addEvent("shop:buy", true)
addEventHandler( "shop:buy", resourceRoot, function( index )
	local shoptype = getElementData( source, "shoptype")
	local error = "S-" .. tostring( shoptype ) .. "-" .. tostring( getElementData( source, "dbid") )

	local shop = g_shops[ shoptype or -1 ]
	_G['shop'] = shop
	if not shop then
		outputChatBox("Error " .. error .. "-NE, report at bugs.mta.vg.", client, 255, 0, 0 )
		return
	end
	
	local race, gender = getElementData( client, "gender" ), getElementData( client, "race" )
	updateItems( shoptype, race, gender ) -- should modify /shop/ too, as shop is a reference to g_shops[type].
	
	-- fetch the selected item
	local item = getItemFromIndex( shoptype, index )
	if not item then
		outputChatBox("Error " .. error .. "-NEI-" .. index .. ", report at bugs.mta.vg.", client, 255, 0, 0 )
		return
	end
	
	-- random old checks. Why do we limit everyone to have one backpack again?
	if item.itemID == 48 and exports.global:hasItem( client, 48 ) then
		outputChatBox( "You already have one " .. item.name .. " and it's unique.", client, 255, 0, 0 )
		return
	end
	
	-- check for monies
	local price = math.ceil( getDiscount( client, shoptype ) * item.price )
	if not exports.global:hasMoney( client, price ) then
		outputChatBox( "You lack the money to buy this " .. item.name .. ".", client, 255, 0, 0 )
		return
	end
	
	
	
	-- @@ -- 
	-- do some item-specific stuff, such as assigning a serial.
	-- @@ -- 
	local itemID, itemValue = item.itemID, item.itemValue or 1
	if itemID == 2 then
		local attempts = 0
		while true do
			-- generate a larger phone number if we're totally out of numbers and/or too lazy to perform more than 20+ checks.
			attempts = attempts + 1
			itemValue = math.random(311111, attempts < 20 and 899999 or 8999999)
			
			local mysqlQ = mysql:query("SELECT `phonenumber` FROM `phone_settings` WHERE `phonenumber` = '" .. itemValue .. "'")
			if mysql:num_rows(mysqlQ) == 0 then
				mysql:free_result(mysqlQ)
				break
			end
			mysql:free_result(mysqlQ)
		end
	elseif itemID == 115 or itemID == 116 then -- now here's the trick. If item.license is set, it checks for a gun license, if item.ammo is set it gives as much ammo
		if item.license and getElementData( client, "license.gun" ) ~= 1 then
			outputChatBox( "You lack a weapon license.", client, 255, 0, 0 )
			return
		else
			if itemID == 115 then
				local serial = "1"
				if item.license then -- licensed weapon, thus needs a serial
					local characterDatabaseID = getElementData(client, "account:character:id")
					serial = exports.global:createWeaponSerial( 3, characterDatabaseID, characterDatabaseID )
				end
				itemValue = itemValue .. ":" .. serial .. ":" .. getWeaponNameFromID( itemValue )
			elseif itemID == 116 then
				itemValue = itemValue .. ":" .. ( item.ammo or exports.weaponcap:getGTACap( itemValue ) or 1 ) .. ":" .. getWeaponNameFromID( itemValue )
			end
		end
	end
	
	
	
	-- at this time le weapon stuff should be done, we're doing some magic with supplies now - namely, high item weight * 3.5 = supplies.
	-- Or supplies = item.supplies if any; this should prolly be done for electronics stuff
	local dimension = getElementDimension( source )
	local suppliesToTake = 0
	if dimension > 0 then -- is even in any interior
		-- check for any owner. unowned shops don't care for supplies.
		local ownerID, ownerPlayer = getInteriorOwner( dimension )
		if ownerID == 0 then
			-- calculate the supplies amount
			suppliesToTake = item.supplies or math.ceil( 3.5 * exports['item-system']:getItemWeight( itemID, itemValue ) )
			if not suppliesToTake then
				outputChatBox( "Error " .. error .. "-SE-I" .. index .. "-" .. tostring( suppliesToTake ) )
				return
			end
			
			-- get the current supply count and check for enough supplies
			local result = mysql:query_fetch_assoc("SELECT supplies FROM interiors WHERE id=" .. mysql:escape_string(dimension) .. " LIMIT 1")
			actualSupplies = tonumber(result["supplies"])
			
			if suppliesToTake > actualSupplies then
				outputChatBox( "This item is out of stock.", client, 255, 0, 0 )
				return
			elseif ownerPlayer and actualSupplies - suppliesToTake < 10 then -- low on supplies, just give a warning and continue
				outputChatBox( "Supplies in your business #" .. dimension .. " are low. Fill 'em up.", ownerPlayer, 255, 194, 14 )
			end
		end
	end
	
	-- We did not do ANYTHING until here. That better never changes (I'd hate to roll back)
	-- in stock, let's give it
	if exports.global:giveItem( client, itemID, itemValue ) then
		exports.global:takeMoney( client, price ) -- this is assumed not to fail as we checked with :hasMoney before.
		
		-- and now for what happens after buying?
		outputChatBox( "You bought this " .. item.name .. " for $" .. exports.global:formatMoney( price ) .. ".", client, 0, 255, 0 )
		
		-- take the outstanding supplies
		if suppliesToTake > 0 then
			mysql:query_free("UPDATE interiors SET supplies = supplies - " .. mysql:escape_string(suppliesToTake) .. " WHERE id = " .. mysql:escape_string(dimension))
		end
		
		
		
		-- some post-buying things, item-specific
		if itemID == 2 then
			mysql:query_free("INSERT INTO `phone_settings` (`phonenumber`, `boughtby`) VALUES ('"..tostring(itemValue).."', '"..mysql:escape_string(tostring(getElementData(client, "account:character:id") or 0)).."')")
			outputChatBox("Your number is #" .. itemValue .. ".", client, 255, 194, 14 )
		elseif itemID == 16 and item.fitting then -- it's a skin, so set it.
			setElementModel( client, itemValue )
			mysql:query_free("UPDATE characters SET skin = " .. mysql:escape_string( itemValue ) .. " WHERE id = " .. mysql:escape_string(getElementData( client, "dbid" )) )
			if exports['anticheat-system']:changeProtectedElementDataEx( client, "casualskin", itemValue, false ) then
				mysql:query_free("UPDATE characters SET casualskin = " .. mysql:escape_string( itemValue ) .. " WHERE id = " .. mysql:escape_string(getElementData(client, "dbid")) )
			end
		elseif itemID == 114 then -- vehicle mods
			outputChatBox("To add this item to any vehicle, go into a garage and double-click the item while sitting inside.", client, 255, 194, 14 )
		elseif itemID == 115 then -- log weapon purchases
			exports.logs:dbLog( client, 36, client, "bought WEAPON - " .. itemValue )
			
			local govMoney = math.floor( price / 2 )
			exports.global:giveMoney(getTeamFromName("Government of Los Santos"), govMoney)
			price = price - govMoney -- you'd obviously get less if the gov asks for percentage.
		elseif itemID == 116 then -- log weapon purchases
			exports.logs:dbLog( client, 36, client, "bought AMMO - " .. itemValue )
			
			local govMoney = math.floor( price / 2 )
			exports.global:giveMoney(getTeamFromName("Government of Los Santos"), govMoney)
			price = price - govMoney -- you'd obviously get less if the gov asks for percentage.
		end
		
		
		
		-- What's left undone? Giving shop owner money!
		if price > 0 and dimension > 0 then
			local ownerID, ownerPlayer = getInteriorOwner( dimension )
			if ownerID > 0 then -- someone even owns it
				if ownerPlayer then
					local profits = getElementData(ownerPlayer, "businessprofit")
					exports['anticheat-system']:changeProtectedElementDataEx(ownerPlayer, "businessprofit", profits + price, false)
				else
					mysql:query_free( "UPDATE characters SET bankmoney=bankmoney + " .. mysql:escape_string(price) .. " WHERE id = " .. mysql:escape_string(ownerID) .. " LIMIT 1")
				end
			end
		end
	else
		outputChatBox( "You do not have enough space to carry this " .. item.name .. ".", client, 255, 0, 0 )
	end
end )

-- TADA. End of buying items.

globalSupplies = 0

function updateGlobalSupplies(value)
	globalSupplies = globalSupplies + value
	mysql:query_free("UPDATE settings SET value='" .. mysql:escape_string(tostring(globalSupplies)) .. "' WHERE name='globalsupplies'")
end
addEvent("updateGlobalSupplies", true)
addEventHandler("updateGlobalSupplies", getRootElement(), updateGlobalSupplies)

function checkSupplies(thePlayer)
	local dbid, entrance, exit, inttype,interiorElement = exports['interior-system']:findProperty( thePlayer )
	
	if (dbid==0) then
		outputChatBox("You are not in a business.", thePlayer, 255, 0, 0)
	else
		local interiorStatus = getElementData(interiorElement, "status")
		local owner = interiorStatus[4]
		
		if (tonumber(owner)==getElementData(thePlayer, "dbid") or exports.global:hasItem(thePlayer, 4, dbid) or exports.global:hasItem(thePlayer, 5, dbid)) and (inttype==1) then
			local query = mysql:query_fetch_assoc("SELECT supplies FROM interiors WHERE id='" .. mysql:escape_string(dbid) .. "' LIMIT 1")
			local supplies = query["supplies"]
			outputChatBox("This business has " .. supplies .. " supplies.", thePlayer, 255, 194, 14)
		else
			outputChatBox("You are not in a business or do you do own the business.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("checksupplies", checkSupplies, false, false)

		--triggerEvent("shop:handleSupplies", source, element, slot, event)
		--triggerClientEvent( source, event or "finishItemMove", source )

addEvent("shop:handleSupplies", true)
function handleSupplies(element, slot, event, worldItem)
	local id, itemID, itemValue, item = nil
	
	if worldItem then
		id = getElementData( worldItem, "id" )
		itemID = getElementData( worldItem, "itemID" )
		itemValue = getElementData( worldItem, "itemValue" )
	end	

	if slot ~= -1 then
		item = exports['item-system']:getItems( source )[ slot ]
	end
	
	if (item and item [1] ~= 121) and (itemID and itemID ~= 121) then
		outputChatBox("You cannot use this item for restocking, sorry.", source, 255,0,0)
		triggerClientEvent( source, event or "finishItemMove", source )
		return
	end
	
	local dbid, entrance, exit, inttype,interiorElement = exports['interior-system']:findProperty( source )
	if (dbid==0) then
		outputChatBox("You are not in a business.", source, 255, 0, 0)
		triggerClientEvent( source, event or "finishItemMove", source )
		return
	end
	
	local interiorStatus = getElementData(interiorElement, "status")
	local owner = interiorStatus[4]
	if not (inttype==1) then -- ((tonumber(owner)==getElementData(source, "dbid") or exports.global:hasItem(source, 4, dbid) or exports.global:hasItem(source, 5, dbid)) and (inttype==1)) then
		outputChatBox("You are not in a business or do you do own the business.", source, 255, 0, 0)
		triggerClientEvent( source, event or "finishItemMove", source )
		return
	end
	
	amount = item and tonumber(item[2]) or itemValue and tonumber(itemValue) or 0
	if not amount or amount < 1 then
		outputChatBox("This item is not compatible, please contact an admin.", source, 255, 0, 0)
		triggerClientEvent( source, event or "finishItemMove", source )
		return
	end
	
	local result = mysql:query_free("UPDATE interiors SET supplies= supplies + " .. mysql:escape_string(amount) .. " where id='" .. mysql:escape_string(dbid) .. "'")
	if result then
		
		if slot == -1 and worldItem and id and isElement(worldItem) then
			outputChatBox("You've added ".. amount .." supplies to this business.", source, 0, 240, 0)
			
			mysql:query_free("DELETE FROM worlditems WHERE id='" .. id .. "'")
			destroyElement(worldItem)
		else
			outputChatBox("You've added ".. amount .." supplies to this business.", source, 0, 240, 0)
			exports['item-system']:takeItemFromSlot( source, slot )
		end
		triggerClientEvent( source, event or "finishItemMove", source )
		return
	end
	
	return false
end
addEventHandler("shop:handleSupplies", getRootElement(), handleSupplies)

function resStart()
	local result = mysql:query_fetch_assoc("SELECT value FROM settings WHERE name='globalsupplies' LIMIT 1")
	globalSupplies = tonumber(result["value"])
end
addEventHandler("onResourceStart", getResourceRootElement(), resStart)