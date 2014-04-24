local rc = 10
local bmx = 0
local bike = 15
local low = 25
local offroad = 35
local sport = 100
local van = 50
local bus = 75
local truck = 200
local boat = 300 -- except dinghy
local heli = 500
local plane = 750
local race = 75
local vehicleTaxes = {
	offroad, low, sport, truck, low, low, 1000, truck, truck, 200, -- dumper, stretch
	low, sport, low, van, van, sport, truck, heli, van, low,
	low, low, low, van, low, 1000, low, truck, van, sport, -- hunter
	boat, bus, 1000, truck, offroad, van, low, bus, low, low, -- rhino
	van, rc, low, truck, 500, low, boat, heli, bike, 0, -- monster, tram
	van, sport, boat, boat, boat, truck, van, 10, low, van, -- caddie
	plane, bike, bike, bike, rc, rc, low, low, bike, heli,
	van, bike, boat, 20, low, low, plane, sport, low, low, -- dinghy
	sport, bmx, van, van, boat, 10, 75, heli, heli, offroad, -- baggage, dozer
	offroad, low, low, boat, low, offroad, low, heli, van, van,
	low, rc, low, low, low, offroad, sport, low, van, bmx,
	bmx, plane, plane, plane, truck, truck, low, low, low, plane,
	plane * 10, bike, bike, bike, truck, van, low, low, truck, low, -- hydra
	10, 20, offroad, low, low, low, low, 0, 0, offroad, -- forklift, tractor, 2x train
	low, sport, low, van, truck, low, low, low, rc, low,
	low, low, van, plane, van, low, 500, 500, race, race, -- 2x monster
	race, low, race, heli, rc, low, low, low, offroad, 0, -- train trailer
	0, 10, 10, offroad, 15, low, low, 3*plane, truck, low,-- train trailer, kart, mower, sweeper, at400
	low, bike, van, low, van, low, bike, race, van, low,
	0, van, 2*plane, plane, rc, boat, low, low, low, offroad, -- train trailer, andromeda
	low, truck, race, sport, low, low, low, low, low, van,
	low, low
}


local mysql = exports.mysql

function carshop_updateVehicles( forceUpdate )
	local blocking = { }
	
	for key, value in ipairs( getElementsByType( "player" ) ) do
		local x, y, z = getElementPosition( value )
		table.insert(blocking, { x, y, z, getElementInterior( value ), getElementDimension( value ), true } )
	end
	
	for key, value in ipairs( getElementsByType( "vehicle" ) ) do
		local x, y, z = getElementPosition( value )
		table.insert(blocking, { x, y, z, getElementInterior( value ), getElementDimension( value ), false } )
	end
	
	for key, value in ipairs( shops ) do
		if #value["spawnpoints"] > 0 and #value["prices"] > 0 then
			local canPopulate = true
			for k, v in ipairs( blocking ) do
				if (v[6]) then
					if (value["blippoint"][4] == v[4] and value["blippoint"][5] == v[5]) then
						if getDistanceBetweenPoints3D( value["blippoint"][1], value["blippoint"][2], value["blippoint"][3], v[1], v[2], v[3] ) < 150 then
							canPopulate = false
							break
						end
					end
				end
			end
			
			if  forceUpdate then
				canPopulate = true
			end
			
			if canPopulate then
				for k, v in ipairs( value["spawnpoints"] ) do
					local data = value["prices"][ math.random( 1, #value["prices"] ) ]
					if v["vehicle"] and isElement( v["vehicle"] ) and data then
						respawnVehicle( v["vehicle"] )
						
						local model = getVehicleModelFromName(data[1]) or tonumber(data[1])
						if getElementModel(v.vehicle) == model or setElementModel(v.vehicle, model) then
							local color1, color2 = getRandomVehicleColor(v.vehicle)
							if color1 then
								setVehicleColor( v.vehicle, color1, color2 or color1, color1, color2 or color1 )
							end
							exports['anticheat-system']:changeProtectedElementDataEx(v["vehicle"], "carshop:cost", data[2], false)
							exports['anticheat-system']:changeProtectedElementDataEx(v["vehicle"], "carshop:taxcost", 2*(vehicleTaxes[getVehicleModelFromName(data[1])-399] or 25), false)
							setElementFrozen(v["vehicle"], false)
							setVehicleVariant(v.vehicle, exports['vehicle-system']:getRandomVariant(getElementModel(v.vehicle)))
							setTimer(setElementFrozen, 1000, 1, v["vehicle"], true)
						else
							outputDebugString("Carshop: Failed to spawn a "..data[1])
						end
					else
						local canPopulate2 = true
						for _, va in ipairs( blocking ) do
							if (v[4] == va[4] and v[5] == va[5]) then
								local distance = getDistanceBetweenPoints3D( v[1], v[2], v[3], va[1], va[2], va[3] )
								if distance < 4 then
									canPopulate2 = false
									break
								end
							end
						end

						if canPopulate2 then
							
							local vehicle = createVehicle( getVehicleModelFromName(data[1]) or tonumber(data[1]), v[1], v[2], v[3], v[4], v[5], v[6]  )
							if not vehicle then
								outputDebugString("failed to swawna "..data[1])
								--next
							else
								setElementInterior(vehicle, v[4])
								setElementDimension(vehicle, v[5])
								setVehicleLocked( vehicle, true )
								setTimer(setElementFrozen, 1000, 1, vehicle, true )
								setVehicleDamageProof( vehicle, true )
								setVehicleVariant(vehicle, exports['vehicle-system']:getRandomVariant(getElementModel(vehicle)))
								v["vehicle"] = vehicle

								local x = v[1] - ( ( math.cos ( math.rad (  v[6] ) ) ) * 1.5 )
								local y = v[2] - ( ( math.sin ( math.rad (  v[6] ) ) ) * 1.5 )
								local tempPickup = createPickup(x, y, v[3], 3, 1239)
								exports['anticheat-system']:changeProtectedElementDataEx(tempPickup, "carshop:parentCar", v["vehicle"], false)
								exports['anticheat-system']:changeProtectedElementDataEx(v["vehicle"], "carshop:cost", data[2], false)
								exports['anticheat-system']:changeProtectedElementDataEx(v["vehicle"], "carshop", true, false)
								exports['anticheat-system']:changeProtectedElementDataEx(v["vehicle"], "carshop:childPickup", tempPickup, false)
								exports['anticheat-system']:changeProtectedElementDataEx(v["vehicle"], "carshop:taxcost", 2*(vehicleTaxes[getVehicleModelFromName(data[1])-399] or 25), false)
								
								--[[ Second hand: future use
								exports['anticheat-system']:changeProtectedElementDataEx(v["vehicle"], "carshop:secondhand", data[3], false])
								if (data[3]) then
									
								end
								--]]
							end
						end
					end
				end
			else
				for k, v in ipairs( value["spawnpoints"] ) do
					if v["vehicle"] and isElement( v["vehicle"] ) then
						respawnVehicle( v["vehicle"] )
					end
				end
			end
		end
	end
end

function carshop_pickupUse(thePlayer)
	local parentCar = getElementData(source, "carshop:parentCar")
	if parentCar and isElement(parentCar) then
		local costCar = getElementData(parentCar, "carshop:cost")
		local costTax = getElementData(parentCar, "carshop:taxcost")
		if costCar and costTax then
			triggerClientEvent(thePlayer, "carshop:showInfo", parentCar, costCar, costTax)
		end
		cancelEvent()
	end
end
addEventHandler("onPickupHit", getResourceRootElement(), carshop_pickupUse)

function carshop_Initalize( )
	carshop_updateVehicles( true )	
	setTimer( carshop_updateVehicles, 120000, 0, false )
end
addEventHandler( "onResourceStart", getResourceRootElement(), carshop_Initalize)

function carshop_blockEnterVehicle(thePlayer)
	local isCarShop = getElementData(source, "carshop")
	if (isCarShop) then
		local costCar = getElementData(source, "carshop:cost")
		
		local payByCash = true
		local payByBank = true
		
		if not exports.global:hasMoney(thePlayer, costCar) or costCar == 0 then
			payByCash = false
		end
		
		local money = getElementData(thePlayer, "bankmoney") - costCar
		if money < 0 or costCar == 0 then
			payByBank = false
		end
		
		triggerClientEvent(thePlayer, "carshop:buyCar", source, costCar, payByCash, payByBank)
	end
	cancelEvent()
end
addEventHandler( "onVehicleEnter", getResourceRootElement(), carshop_blockEnterVehicle)
addEventHandler( "onVehicleStartEnter", getResourceRootElement(), carshop_blockEnterVehicle)

function carshop_buyVehicle(paymentMethod)
	if client then
		if getElementData(client, "license.car") == 1 then
			local isCarshopVehicle = getElementData(source, "carshop")
			if (isCarshopVehicle) then
			
				if not exports.global:canPlayerBuyVehicle(client) then
					outputChatBox("You have already reached the maximum number of vehicles", client, 0, 255, 0)
					return
				end
			
				local costCar = getElementData(source, "carshop:cost")
				if (paymentMethod == "cash") then
					if not exports.global:hasMoney(client, costCar) or costCar == 0 then
						outputChatBox("You don't have enough money on hand for this pal..", client, 0, 255, 0)
						return
					else
						exports.global:takeMoney(client, costCar)
					end
				elseif (paymentMethod == "bank") then
					local money = getElementData(client, "bankmoney") - costCar
					if money < 0 or costCar == 0 then
						outputChatBox("You don't have enough money in your bank account for this pal..", client, 0, 255, 0)
					else
						exports['anticheat-system']:changeProtectedElementDataEx(client, "bankmoney", money, false)
						mysql:query_free("UPDATE characters SET bankmoney=" .. mysql:escape_string((tonumber(money) or 0)) .. " WHERE id=" .. mysql:escape_string(getElementData( client, "dbid" )))
					end
				else
					outputChatBox("No.", client, 0, 255, 0)
					return
				end
				
				local dbid = getElementData(client, "account:character:id")
				local modelID = getElementModel(source)
				local x, y, z = getElementPosition(source)
				local rx, ry, rz = getElementRotation(source)
				local col = { getVehicleColor(source) }
				local color1 = toJSON( {col[1], col[2], col[3]} )
				local color2 = toJSON( {col[4], col[5], col[6]} )
				local color3 = toJSON( {col[7], col[8], col[9]} )
				local color4 = toJSON( {col[10], col[11], col[12]} )
				local letter1 = string.char(math.random(65,90))
				local letter2 = string.char(math.random(65,90))
				local var1, var2 = getVehicleVariant(source)
				local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
				local locked = 1
					
				local insertid = mysql:query_insert_free("INSERT INTO vehicles SET model='" .. mysql:escape_string(modelID) .. "', x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .. "', z='" .. mysql:escape_string(z) .. "', rotx='" .. mysql:escape_string(rx) .. "', roty='" .. mysql:escape_string(ry) .. "', rotz='" .. mysql:escape_string(rz) .. "', color1='" .. mysql:escape_string(color1) .. "', color2='" .. mysql:escape_string(color2) .. "', color3='" .. mysql:escape_string(color3) .. "', color4='" .. mysql:escape_string(color4) .. "', faction='-1', owner='" .. mysql:escape_string(dbid) .. "', plate='" .. mysql:escape_string(plate) .. "', currx='" .. mysql:escape_string(x) .. "', curry='" .. mysql:escape_string(y) .. "', currz='" .. mysql:escape_string(z) .. "', currrx='0', currry='0', currrz='" .. mysql:escape_string(rz) .. "', locked='" .. mysql:escape_string(locked) .. "',variant1="..var1..",variant2="..var2)
				
				if (insertid) then
					exports.logs:dbLog(client, 6, "ve"..tostring(insertid), "BOUGHTNEWCAR ".. costCar)
					call( getResourceFromName( "item-system" ), "deleteAll", 3, insertid )
					exports.global:giveItem( client, 3, insertid )		
					local tempPickup = getElementData(source,"carshop:childPickup")
					if (isElement(tempPickup)) then
						destroyElement(tempPickup)
					end
					destroyElement(source)					
					exports['vehicle-system']:reloadVehicle(insertid)
					outputChatBox("Congratulations, you just bought a vehicle!", client)
					outputChatBox("Make sure to /park it at the respawnspot you want within an hour,", client)
					outputChatBox("otherwise the vehicle will get deleted, non-recoverable.", client)
				end
			end
		else
			outputChatBox("You need a drivers license in order to buy a vehicle.", client, 255, 0, 0)
			return
		end
	end
end
addEvent("carshop:buyCar", true)
addEventHandler("carshop:buyCar", getRootElement(), carshop_buyVehicle)

local vehicleColors
function getRandomVehicleColor( vehicle )
	if not vehicleColors then
		vehicleColors = { }
		local file = fileOpen( "vehiclecolors.conf", true )
		while not fileIsEOF( file ) do
			local line = fileReadLine( file )
			if #line > 0 and line:sub( 1, 1 ) ~= "#" then
				local model = tonumber( gettok( line, 1, string.byte(' ') ) )
				if not vehicleColors[ model ] then
					vehicleColors[ model ] = { }
				end
				vehicleColors[ model ][ #vehicleColors[ model ] + 1 ] = {
					tonumber( gettok( line, 2, string.byte(' ') ) ),
					tonumber( gettok( line, 3, string.byte(' ') ) ) or nil,
				}
			end
		end
		fileClose( file )
	end
	
	local colors = vehicleColors[ getElementModel( vehicle ) ]
	if colors then
		return unpack( colors[ math.random( 1, #colors ) ] )
	end
end

function fileReadLine( file )
	local buffer = ""
	local tmp
	repeat
		tmp = fileRead( file, 1 ) or nil
		if tmp and tmp ~= "\r" and tmp ~= "\n" then
			buffer = buffer .. tmp
		end
	until not tmp or tmp == "\n" or tmp == ""
	
	return buffer
end

function isForSale(vehicle)
	if type(vehicle) == "number" then
	elseif type(vehicle) == "string" then
		vehicle = tonumber(vehicle)
	elseif isElement(vehicle) and getElementType(vehicle) == "vehicle" then
		vehicle = getElementModel(vehicle)
	else
		return false
	end
	for _, shop in ipairs(shops) do
		for _, data in ipairs(shop.prices) do
			if getVehicleModelFromName(data[1]) == vehicle then
				return true
			end
		end
	end
	return false
end

-- verify all shop vehicles exist
addEventHandler("onResourceStart", getResourceRootElement( getThisResource( ) ),
	function( )
		for _, shop in ipairs(shops) do
			for _, data in ipairs(shop.prices) do
				local model = getVehicleModelFromName(data[1]) or tonumber(data[1])
				if not model or not getVehicleNameFromModel( model ) then
					outputDebugString( "Carshop: Invalid Car: " .. data[1] )
				end
			end
		end
	end
)

function carGrid( thePlayer )
	if exports.global:isPlayerAdmin(thePlayer) then
		triggerClientEvent(thePlayer, "carshop:cargrid", thePlayer, shops)
	end
end
addCommandHandler("listcarprices", carGrid)