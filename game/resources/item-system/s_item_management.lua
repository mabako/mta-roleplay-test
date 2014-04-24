mysql = exports.mysql

--[[
x loadItems(obj) -- loads all items (caching)
x sendItems(obj, to) -- sends the items to the player
x clearItems(obj) -- clears all items from the player

x giveItem(obj, itemID, itemValue, nosqlupdate) -- gives an item
x takeItem(obj, itemID, itemValue = nil) -- takes the item, or if nil/false, the first one with the same item ID
x takeItemFromSlot(obj, slot, nosqlupdate) -- ...
x updateItemValue(obj, slot, itemValue) -- updates the object's item value

x moveItem(from, to, slot) -- moves an item from any inventory to another (was on from's specified slot before, true if successful, internally only updates the owner in the DB and modifies the arrays

x hasItem(obj, itemID, itemValue = nil ) -- returns true if the player has that item
x hasSpaceForItem(obj, itemID, itemValue) -- returns true if you can put more stuff in
x countItems(obj, itemID, itemValue) -- counts how often a player has that item

x getItems(obj) -- returns an array of all items in { slot = { itemID, itemValue } } table
x getCarriedWeight(obj) -- returns the current weight an element carries
x getMaxWeight(obj) -- returns the maximum weight the element is capable holding of

x deleteAll(itemID, itemValue) -- deletes all instances of that item
]]--

local saveditems = {}
local subscribers = {}

-- util function for sendItems
local function itemconv( arr )
	local brr = { }
	for k, v in ipairs( arr ) do
		brr[k] = {v[1], tostring(v[2]), tostring(v[3])}
	end
	return toJSON(brr)
end

-- send items to a player
local function sendItems( element, to, noload )
	if not noload then
		loadItems( element )
	end
	triggerClientEvent( to, "recieveItems", element, itemconv( saveditems[ element ] ) )
end

-- notify all subscribers on inventory change
local function notify( element, noload )
	if subscribers[ element ] then
		for subscriber in pairs( subscribers[ element ] ) do
			sendItems( element, subscriber, noload )
		end
	end
end

-- Free Items Table as neccessary
local function destroyInventory( )
	saveditems[source] = nil
	notify( source )
	
	
	-- clear subscriptions
	for key, value in pairs( subscribers ) do
		if value[ source ] then
			value[ source ] = nil
		end
	end
	
	subscribers[source] = nil
end

addEventHandler( "onElementDestroy", getRootElement(), destroyInventory )
addEventHandler( "onPlayerQuit", getRootElement(), destroyInventory )
addEventHandler( "savePlayer", getRootElement(),
	function( reason )
		if reason == "Change Character" then
			destroyInventory()
		end
	end
)

-- subscribe from inventory changes
local function subscribeChanges( element )
	sendItems( element, source )
	subscribers[ element ][ source ] = true
end

addEvent( "subscribeToInventoryChanges", true )
addEventHandler( "subscribeToInventoryChanges", getRootElement(), subscribeChanges )

-- Send items without subscription
local function sendCurrentInventory( element )
	sendItems( element, source )
end

addEvent( "sendCurrentInventory", true )
addEventHandler( "sendCurrentInventory", getRootElement(), sendCurrentInventory )

-- remove from inventory changes list
local function unsubscribeChanges( element )
	subscribers[ element ][ source ] = nil
	triggerClientEvent( source, "recieveItems", element )
end

addEvent( "unsubscribeFromInventoryChanges", true )
addEventHandler( "unsubscribeFromInventoryChanges", getRootElement(), subscribeChanges )

-- returns the 'owner' column content
local function getID(element)
	if getElementType(element) == "player" then -- Player
		return getElementData(element, "dbid")
	elseif getElementType(element) == "vehicle" then -- Vehicle
		return getElementData(element, "dbid")
	elseif getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("item-world")) then -- World Item
		return getElementData(element, "id")
	elseif getElementType(element) == "object" then -- Safe
		return getElementDimension(element)
	else
		return 0
	end
end

function getElementID(element)
	return getID(element)
end

-- returns the 'type' column content
local function getType(element)
	if getElementType(element) == "player" then -- Player
		return 1
	elseif getElementType(element) == "vehicle" then -- Vehicle
		return 2
	elseif getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("item-world")) then -- World Item
		return 3
	elseif getElementType(element) == "object" then -- Safe
		return 4
	else
		return 255
	end
end

-- loads all items for that element
function loadItems( element, force )
	if not isElement( element ) then
		return false, "No element"
	elseif not getID( element ) then
		return false, "Invalid Element ID"
	elseif force or not saveditems[ element ] then
		saveditems[ element ] = {}
		--notify( element )
		local result = mysql:query( "SELECT * FROM items WHERE type = " .. getType( element ) .. " AND owner = " .. getID( element ) .. " ORDER BY `index` ASC" )
		if result then
			local count = 0
			repeat
				row = mysql:fetch_assoc(result)
				if row then
					count = count + 1
					saveditems[element][count] = { tonumber( row.itemID ), tonumber( row.itemValue ) or row.itemValue, tonumber( row.index ) }
				end
			until not row
			mysql:free_result(result)
			
			if not subscribers[ element ] then
				subscribers[ element ] = {}
				if getElementType( element ) == "player" then
					subscribers[ element ][ element ] = true
				end
			end
			notify( element, true )
			if (getElementType(element) == 'player') then
				triggerEvent("updateLocalGuns", element)
			end
			return true
		else
			notify( element, true )
			return false, "MySQL-Error"
		end
	else
		return true
	end
end

-- load items for all logged in players on resource start
function itemResourceStarted( )
	if getID( source ) then
		loadItems( source )
	end
end
addEvent( "itemResourceStarted", true )
addEventHandler( "itemResourceStarted", getRootElement( ), itemResourceStarted )

-- clear all items for an element
function clearItems( element, onlyifnosqlones )
	if saveditems[element] then
		if onlyifnosqlones and #saveditems[element] > 0 then
			return false
		else
			while #saveditems[ element ] > 0 do
				takeItemFromSlot( element, 1 )
			end
			
			saveditems[ element ] = nil
			notify( element, true )

			source = element
			destroyInventory()
			if (getElementType(element) == 'player') then
				triggerEvent("updateLocalGuns", element)
			end
		end
	end
	return true
end

-- gives an item to an element
function giveItem( element, itemID, itemValue, itemIndex )
	local success, error = loadItems( element )
	if success then
		if not hasSpaceForItem( element, itemID, itemValue ) then
			return false, "Inventory is Full"
		end
		
		if not itemIndex then
			local result = mysql:query("INSERT INTO items (type, owner, itemID, itemValue) VALUES (" .. getType( element ) .. "," .. getID( element ) .. "," .. itemID .. ",'" .. mysql:escape_string(itemValue) .. "')" )
			if result then
				itemIndex = mysql:insert_id( )
				mysql:free_result( result )
			else
				mysql:free_result( result )
				return false, "MySQL Error"
			end
		end
		
		saveditems[element][ #saveditems[element] + 1 ] = { itemID, itemValue, itemIndex }
		notify( element, true )
		if (getElementType(element) == 'player') then
			if tonumber(itemID) == 115 or tonumber(itemID) == 116 and (getElementType(element) == 'player') then
				triggerEvent("updateLocalGuns", element)
			end
		end
		return true
	else
		return false, "loadItems error: " .. error
	end
end

-- takes an item from the element
function takeItem(element, itemID, itemValue)
	local success, error = loadItems( element )
	if success then
		local success, slot = hasItem(element, itemID, itemValue)
		if success then
			takeItemFromSlot(element, slot)
			if (tonumber(itemID) == 115 or tonumber(itemID) == 116) and (getElementType(element) == 'player')  then
				triggerEvent("updateLocalGuns", element)
			end
			return true
		else
			return false, "Element doesn't have this item"
		end
	else
		return false, "loadItems error: " .. error
	end
end

-- permanently removes an item from an element
function takeItemFromSlot(element, slot, nosqlupdate)
	local success, error = loadItems( element )
	if success then
		if saveditems[element][slot] then
			local itemID = saveditems[element][slot][1]
			local itemValue = saveditems[element][slot][2]
			local index = saveditems[element][slot][3]
			
			local success = true
			if not nosqlupdate then
				local result = mysql:query_free( "DELETE FROM items WHERE `index` = " .. index .. " LIMIT 1" )
				if not result then
					success = false
				end
			end
			
			if success then
				-- shift following items from id to id-1 items
				table.remove( saveditems[element], slot )
				notify( element )
				if (tonumber(itemID) == 115 or tonumber(itemID) == 116) and (getElementType(element) == 'player')  then
					triggerEvent("updateLocalGuns", element)
				end
				return true
			end
			return false, "Slot does not exist."
		end
	else
		return false, "loadItems error: " .. error
	end
end

-- updates the item value
function updateItemValue(element, slot, itemValue)
	local success, error = loadItems( element )
	if success then
		if saveditems[element][slot] then
			local itemValue = tonumber(itemValue) or tostring(itemValue)
			if itemValue then
				local itemIndex = saveditems[element][slot][3]
				local result = mysql:query_free( "UPDATE items SET `itemValue` = '" .. mysql:escape_string( tostring( itemValue ) ) .. "' WHERE `index` = " .. itemIndex )
				if result then
					saveditems[element][slot][2] = itemValue
					notify( element )
					return true
				else
					return false, "MySQL-Query failed."
				end
			else
				return false, "Invalid ItemValue"
			end
		else
			return false, "Slot does not exist."
		end
	else
		return false, "loadItems error: " .. error
	end
end


-- moves an item from any element to another element
function moveItem2(from, to, slot)
	moveItem(from, to, slot)
end

function moveItem(from, to, slot)
	local success, error = loadItems( from )
	if success then
		local success, error = loadItems( to )
		if success then
			if saveditems[from] and saveditems[from][slot] then
				if hasSpaceForItem(to, saveditems[from][slot][1], saveditems[from][slot][2]) then
					local itemIndex = saveditems[from][slot][3]
					if itemIndex then
						local itemID = saveditems[from][slot][1]
						if itemID == 48 or itemID == 60 or itemID == 103 then
							return false, "This Item cannot be moved"
						else
							local query = mysql:query_free( "UPDATE items SET type = " .. getType(to) .. ", owner = " .. getID(to) .. " WHERE `index` = " .. itemIndex )
							if query then
								
								local itemValue = saveditems[from][slot][2]
								
								takeItemFromSlot(from, slot, true)
								giveItem(to, itemID, itemValue, itemIndex)
								
								return true
							else
								return false, "MySQL-Query failed."
							end
						end
					else
						return false, "Item does not exist."
					end
				else
					return false, "Target does not have Space for Item."
				end
			else
				return false, "Slot does not exist."
			end
		else
			return false, "loadItems(to) error: " .. error
		end
	else
		return false, "loadItems(from) error: " .. error
	end
end

-- checks if the element has that specific item
function hasItem(element, itemID, itemValue)
	local success, error = loadItems( element )
	if success then
		for key, value in pairs(saveditems[element]) do
			if value[1] == itemID and ( not itemValue or itemValue == value[2] ) then
				return true, key, value[2], value[3]
			end
		end
		return false
	else
		return false, "loadItems error: " .. error
	end
end

-- checks if the element has space for adding a new item
function hasSpaceForItem(element, itemID, itemValue)
	local success, error = loadItems( element )
	if success then
		return getCarriedWeight(element) + getItemWeight(itemID, itemValue or 1) <= getMaxWeight(element)
	else
		return false, "loadItems error: " .. error
	end
end

-- count all instances of that object
function countItems( element, itemID, itemValue )
	local success, error = loadItems( element )
	if success then
		local count = 0
		for key, value in pairs(saveditems[element]) do
			if value[1] == itemID and ( not itemValue or itemValue == value[2] ) then
				count = count + 1
			end
		end
		return count
	else
		return 0, "loadItems error: " .. error
	end
end

-- returns a list of all items of that element
function getItems(element)
	loadItems( element )
	return saveditems[element]
end


-- returns the current weight an element carries
function getCarriedWeight(element)
	local success, error = getItems( element )
	if success then
		local weight = 0
		for key, value in ipairs(saveditems[element]) do
			weight = weight + getItemWeight(value[1], value[2])
		end
		return weight
	else
		return 1000000, "loadItems error: " .. error -- Obviously too large to pick anything further up :o Yet if it fails that might even be good since we assume "if not loaded, can't happen"
	end
end	

-- returns the number of available item slots for that element
local function isTruck( element )
	if getElementType( element ) == "Trailer" then
		return true
	end
	local model = getElementModel( element )
	return model == 498 or model == 609 or model == 499 or model == 524 or model == 455 or model == 414 or model == 443 or model == 456
end	
	
local function isSUV( element )
	local model = getElementModel( element )
	return model == 482 or model == 440 or model == 418 or model == 413 or model == 400 or model == 489 or model == 579 or model == 459 or model == 582
end

function getMaxWeight(element)
	if getElementType( element ) == "player" then
		if hasItem(element, 48) then
			return 20
		else
			return 10
		end
	elseif getElementType( element ) == "vehicle" then
		if getID( element ) < 0 then
			return -1
		elseif getVehicleType( element ) == "BMX" then
			return 5
		elseif getVehicleType( element ) == "Bike" then
			return 10
		elseif isSUV( element ) then
			return 50
		elseif isTruck( element ) then
			return 70
		else
			return 20
		end
	elseif getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("item-world")) then -- World Item
		return getElementModel(element) == 2147 and 50 or getElementModel(element) == 3761 and 100 or 10
	else
		return 20
	end
end

-- delete all instances of an item
function deleteAll( itemID, itemValue )
	if itemID then
		-- make sure it's erased from the db
		if itemValue then
			mysql:query_free("DELETE FROM items WHERE itemID = " .. itemID .. " AND itemValue = '" .. mysql:escape_string( tostring( itemValue ) ) .. "'" ) 
			mysql:query_free("DELETE FROM worlditems WHERE itemid = " .. itemID .. " AND itemvalue = '" .. mysql:escape_string( tostring( itemValue ) ) .. "'" ) 
			
			-- delete from all items
			for key, value in pairs( getElementsByType( "object", getResourceRootElement( ) ) ) do
				if isElement( value ) then
					if getElementData( value, "itemID" ) == itemID and getElementData( value, "itemValue" ) == itemValue then
						destroyElement( value )
					end
				end
			end
		else
			mysql:query_free("DELETE FROM items WHERE itemID = " .. itemID )
			mysql:query_free("DELETE FROM worlditems WHERE itemid = " .. itemID )
			
			-- delete from all items
			for key, value in pairs( getElementsByType( "object", getResourceRootElement( ) ) ) do
				if isElement( value ) then
					if getElementData( value, "itemID" ) == itemID then
						destroyElement( value )
					end
				end
			end
		end
		
		-- delete from all storages
		for value in pairs( saveditems ) do
			if isElement( value ) then
				while exports.global:hasItem( value, itemID, itemValue ) do
					exports.global:takeItem( value, itemID, itemValue )
				end
			end
		end
		
		return true
	else
		return false
	end
end

--

addCommandHandler( "fixinventory", 
	function( element )
		sendItems( element, element )
		if (getElementType(element) == 'player') then
			triggerEvent("updateLocalGuns", element)
		end
	end
)