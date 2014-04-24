--[[
x hasItem(obj, itemID, itemValue = nil ) -- returns true if the player has that item
x hasSpaceForItem(obj, itemID, itemValue) -- returns true if you can put more stuff in

x getItems(obj) -- returns an array of all items in { slot = { itemID, itemValue } } table
x getCarriedWeight(obj) -- returns the current weight an element carries
x getMaxWeight(obj) -- returns the maximum weight the element is capable holding of
]]
local saveditems = {} -- client-side saved items


-- Recieve Items from the server
local function recieveItems( items )
	if items then
		-- workaround for MTA bandwith saving
		local arr = fromJSON( items )
		if arr then
			for k, v in ipairs( arr ) do
				arr[k][2] = tonumber(v[2]) or v[2]
				arr[k][3] = tonumber(v[3])
			end
			saveditems[ source ] = arr
			return
		end
	end
	saveditems[ source ] = nil
end

addEvent( "recieveItems", true )
addEventHandler( "recieveItems", getRootElement( ), recieveItems )

-- checks if the element has that specific item
function hasItem(element, itemID, itemValue)
	if not saveditems[element] then
		return false, "Unknown"
	end
	
	for key, value in pairs(saveditems[element]) do
		if value[1] == itemID and ( not itemValue or itemValue == value[2] ) then
			return true, key, value[2], value[3]
		end
	end
	return false
end

-- checks if the element has space for adding a new item
function hasSpaceForItem(element, itemID, itemValue)
	return getCarriedWeight(element) + getItemWeight(itemID, itemValue or 1) <= getMaxWeight(element)
end

-- count all instances of that object
function countItems( element, itemID, itemValue )
	if not saveditems[element] then
		return 0
	end
	
	local count = 0
	for key, value in pairs(saveditems[element]) do
		if value[1] == itemID and ( not itemValue or itemValue == value[2] ) then
			count = count + 1
		end
	end
	return count
end

-- returns a list of all items of that element
function getItems(element)
	if not saveditems[element] then
		return {}, "Unknown"
	end

	return saveditems[element]
end

-- returns the current weight an element carries
function getCarriedWeight(element)
	if not saveditems[element] then
		return 1000000, "Unknown" -- Obviously too large to pick anything further up :o Yet if it fails that might even be good since we assume "if not loaded, can't happen"
	end
	
	local weight = 0
	for key, value in ipairs(saveditems[element]) do
		weight = weight + getItemWeight(value[1], value[2])
	end
	return weight
end

-- returns the maximum weight the element is capable holding of
local function isTruck( element )
	if getElementType( element ) == "" or getElementType( element ) == "Trailer" then
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
			return 6
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

-- tell the server we're ready
addEventHandler( "onClientResourceStart", getResourceRootElement( ),
	function( )
		triggerServerEvent( "itemResourceStarted", getLocalPlayer( ) )
	end
)