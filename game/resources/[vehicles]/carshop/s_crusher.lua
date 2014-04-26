-- reverse carshop

local mysql = exports.mysql

local cOutsideCol = createColPolygon(
	2202.83984375, -1933.951171875, -- dummy
	2202.83984375, -1933.951171875,
	2179.6533203125, -1954.2529296875,
	2155.4404296875, -1961.2080078125,
	2155.005859375, -1985.037109375,
	2203.0625, -2030.513671875,
	2210.8671875, -2022.7060546875,
	2203.1962890625, -2004.3505859375)

local function showInformation(thePlayer, matching)
	if isElement(thePlayer) and matching and getElementType(thePlayer) == "player" then
		outputChatBox("Welcome to the Iron Monger!", thePlayer, 0, 255, 0)
		outputChatBox("We'd be pleased to crush your car - Head over to the ramp for more information.", thePlayer, 255, 194, 14)
	end
end
addEventHandler( "onColShapeHit", cOutsideCol, showInformation)

local function resetPrice(theVehicle, matching)
	if isElement(theVehicle) and matching and getElementType(theVehicle) == "vehicle" then
		if getElementData(theVehicle, "crushing") then
			exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "crushing")
			
			local thePlayer = getVehicleOccupant(theVehicle)
			if thePlayer then
				outputChatBox("Come back when you've thought about it!", thePlayer, 255, 194, 14)
			end
		end
	end
end
addEventHandler( "onColShapeLeave", cOutsideCol, resetPrice)
--

local vehiclecount = { }
local function countVehicles( )
	vehiclecount = {}
	for key, value in pairs( getElementsByType( "vehicle" ) ) do
		if isElement( value ) then
			local model = getElementModel( value )
			if vehiclecount[ model ] then
				vehiclecount[ model ] = vehiclecount[ model ] + 1
			else
				vehiclecount[ model ] = 1
			end
		end
	end
end

local function getVehiclePrice(theVehicle)
	local model = getElementModel(theVehicle)
	for k, v in ipairs(shops) do
		local veek = v["prices"]
		for key, value in ipairs(veek) do
			if getVehicleModelFromName(value[1]) == model then
				return math.ceil(tonumber( value[2] or 0 + ( vehiclecount[ model ] * 600 )) / 300) * 100 -- 1/3 of the price, round to $100
				--return value[2] -- 100%
			end
		end
	end
	return 0
end

--

local cRampDown = createColSphere(2189.283203125, -1979.375, 13.552169799805, 3)
local pRampDown = createPickup(2189.283203125, -1979.375, 13.552169799805, 3, 1239)

local function showMoreInformation(thePlayer, matching)
	if isElement(thePlayer) and matching and getElementType(thePlayer) == "player" then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle and getVehicleOccupant(theVehicle) == thePlayer then -- player is driver
			if getElementData(theVehicle, "owner") == getElementData(thePlayer, "dbid") then
				local price = getVehiclePrice(theVehicle)
				if getElementData(theVehicle, "requires.vehpos") then
					outputChatBox("I'm busy at the moment, come back later.", thePlayer, 255, 0, 0)
				elseif price == 0 then
					outputChatBox("This " .. getVehicleName(theVehicle) .. " ain't worth anything.", thePlayer, 255, 0, 0 )
					outputChatBox("(( Contact an admin to sell your special vehicle. ))", thePlayer, 255, 194, 14)
				else
					if getElementData(theVehicle, "crushing") then
						outputChatBox("My Price still stands - $" .. exports.global:formatMoney(getElementData(theVehicle, "crushing")) .. " for it.", thePlayer, 0, 255, 0)
					else
						outputChatBox("Hey, nice " .. getVehicleName(theVehicle) .. ", I could give you $" .. exports.global:formatMoney(price) .. " for it, alright?", thePlayer, 0, 255, 0)
						setElementData(theVehicle, "crushing", price, false)
					end
					outputChatBox("(( Drive the " .. getVehicleName(theVehicle) .. " up the ramp to crush it. ))", thePlayer, 255, 194, 14)
					outputChatBox("(( This will permanently delete your vehicle. ))", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("Got the Registration for that? Sorry, Bro', can't touch it then.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Come back when you've got a car to crush!", thePlayer, 255, 0, 0)
		end
	end
end
addEventHandler( "onColShapeHit", cRampDown, showMoreInformation)

--

local cRampUp = createColSphere(2176.4501953125, -1979.5419921875, 17.062156677246, 3)
local pRampUp = createPickup(2176.4501953125, -1979.5419921875, 17.062156677246, 3, 1274)

local function crushCar(thePlayer, matching)
	if isElement(thePlayer) and matching and getElementType(thePlayer) == "player" then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle and getVehicleOccupant(theVehicle) == thePlayer then -- player is driver
			if getElementData(theVehicle, "owner") == getElementData(thePlayer, "dbid") then
				local price = getElementData(theVehicle, "crushing")
				if price and price > 0 then
					local dbid = getElementData(theVehicle, "dbid")
					
					local result = mysql:query_free( "DELETE FROM vehicles WHERE id = " .. mysql:escape_string(dbid) )
					if result then
						exports.global:giveMoney(thePlayer, price)
						call( getResourceFromName( "item-system" ), "deleteAll", 3, dbid )
						call( getResourceFromName( "item-system" ), "clearItems", theVehicle )
						outputChatBox("You crushed your " .. getVehicleName(theVehicle) .. " for $" .. exports.global:formatMoney(price) .. ".", thePlayer, 0, 255, 0)
						
						exports.global:sendMessageToAdmins("Removing vehicle #" .. dbid .. " (Crushed by " .. getPlayerName(thePlayer) .. ").")
						
						exports.logs:dbLog(thePlayer, 6, (theVehicle), "CRUSHERDELETED ".. price)
						destroyElement(theVehicle)
					else
						outputChatBox("Error 9004 - Report on Forums.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addEventHandler( "onColShapeHit", cRampUp, crushCar)