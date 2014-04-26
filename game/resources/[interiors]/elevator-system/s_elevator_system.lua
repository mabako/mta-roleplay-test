mysql = exports.mysql

addEvent("onPlayerInteriorChange", true)

-- Defines
INTERIOR_X = 1
INTERIOR_Y = 2
INTERIOR_Z = 3
INTERIOR_INT = 4
INTERIOR_DIM = 5
INTERIOR_ANGLE = 6
INTERIOR_FEE = 7

INTERIOR_TYPE = 1
INTERIOR_DISABLED = 2
INTERIOR_LOCKED = 3
INTERIOR_OWNER = 4
INTERIOR_COST = 5
INTERIOR_SUPPLIES = 6

-- Small hack
function setElementDataEx(source, field, parameter, streamtoall, streamatall)
	exports['anticheat-system']:changeProtectedElementDataEx( source, field, parameter, streamtoall, streamatall)
end
-- End small hack


function createElevator(thePlayer, commandName, interior, dimension, ix, iy, iz)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) or (exports.donators:hasPlayerPerk(thePlayer,14) and exports.global:isPlayerFullAdmin(thePlayer)) then
		if not (interior) or not (dimension) or not (ix) or not (iy) or not (iz) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID] [Dimension ID] [X] [Y] [Z]", thePlayer, 255, 194, 14)
		else
			local x, y, z = getElementPosition(thePlayer)
			
			interior = tonumber(interior)
			dimension = tonumber(dimension)
			local interiorwithin = getElementInterior(thePlayer)
			local dimensionwithin = getElementDimension(thePlayer)
			ix = tonumber(ix)
			iy = tonumber(iy)
			iz = tonumber(iz)
			id = SmallestElevatorID()
			if id then
				local query = mysql:query_free("INSERT INTO elevators SET id='" .. mysql:escape_string(id) .. "', x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .. "', z='" .. mysql:escape_string(z) .. "', tpx='" .. mysql:escape_string(ix) .. "', tpy='" .. mysql:escape_string(iy) .. "', tpz='" .. mysql:escape_string(iz) .. "', dimensionwithin='" .. mysql:escape_string(dimensionwithin) .. "', interiorwithin='" .. mysql:escape_string(interiorwithin) .. "', dimension='" .. mysql:escape_string(dimension) .. "', interior='" .. mysql:escape_string(interior) .. "'")
				if (query) then
					--reloadOneElevator(id, true)
					loadOneElevator(id)
					outputChatBox("Elevator created with ID #" .. id .. "!", thePlayer, 0, 255, 0)
				end
			else
				outputChatBox("There was an error while creating an elevator. Try again.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("addelevator", createElevator, false, false)

function findElevator(elevatorID)
	elevatorID = tonumber(elevatorID)
	if elevatorID > 0 then
		local possibleInteriors = getElementsByType("elevator")
		for _, elevator in ipairs(possibleInteriors) do
			local eleID = getElementData(elevator, "dbid")
			if eleID == elevatorID then
				local elevatorEntrance = getElementData(elevator, "entrance")
				local elevatorExit = getElementData(elevator, "exit")
				local elevatorStatus = getElementData(elevator, "status")
				
				return elevatorID, elevatorEntrance, elevatorExit, elevatorStatus, elevator
			end
		end
	end
	return 0
end

function findElevatorElement(elevatorID)
	elevatorID = tonumber(elevatorID)
	if elevatorID > 0 then
		local possibleInteriors = getElementsByType("elevator")
		for _, elevator in ipairs(possibleInteriors) do
			local eleID = getElementData(elevator, "dbid")
			if eleID == elevatorID then
				return  elevator
			end
		end
	end
	return false
end

function reloadOneElevator(elevatorID, skipcheck)
	local dbid, entrance, exit, status, elevatorElement = findElevator( elevatorID )
	if (dbid > 0 or skipcheck)then
		local realElevatorElement = findElevatorElement(dbid)
		if not realElevatorElement then
			outputDebugString("[reloadOneElevator] Can't find element")
		end
		triggerClientEvent("deleteInteriorElement", realElevatorElement, tonumber(dbid))
		destroyElement(realElevatorElement)
		loadOneElevator(tonumber(dbid), false)
	else
		--outputDebugString("You suckx2")
		outputDebugString("Tried to reload elevator without ID.")
	end
end

function loadOneElevator(elevatorID, hasCoroutine)
	if (hasCoroutine==nil) then
		hasCoroutine = false
	end

	local row = mysql:query_fetch_assoc("SELECT id, x, y, z, tpx, tpy, tpz, dimensionwithin, interiorwithin, dimension, interior, car, disabled FROM `elevators` WHERE id = " .. elevatorID )
	if row then
		--if (hasCoroutine) then
		--	coroutine.yield()
		--end

		if row then
			for k, v in pairs( row ) do
				if v == null then
					row[k] = nil
				else
					row[k] = tonumber(v) or v
				end
			end
			
			local elevatorElement = createElement("elevator", "ele"..tostring(row.id))
			setElementDataEx(elevatorElement, "dbid", 	row.id, true)

			--												X				Y				Z				Interior				Dimension				Angle	Entree fee
			setElementDataEx(elevatorElement, "entrance", {	row.x, 			row.y, 			row.z, 			row.interiorwithin,		row.dimensionwithin,	0,		0	},	true	)
			setElementDataEx(elevatorElement, "exit", 	  {	row.tpx, 		row.tpy, 		row.tpz, 		row.interior, 			row.dimension,			0,		0	}, 	true	)
			
			--												Type 		Is diabled?
			setElementDataEx(elevatorElement, "status",  {	row.car,	row.disabled == 1 } 	, true	)
			setElementDataEx(elevatorElement, "name", 	 	row.name, true	)
			return true
		end
	end	
end

function loadAllElevators(res)
	local result = mysql:query("SELECT id FROM elevators")
	local counter = 0
	
	if (result) then
		while true do
			local row = mysql:fetch_assoc(result)
			if not row then break end
			loadOneElevator(row.id)
		end
		mysql:free_result(result)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllElevators)

function isInteriorLocked(dimension)
	local result = mysql:query_fetch_assoc("SELECT type, locked FROM `interiors` WHERE id = " .. mysql:escape_string(dimension))
	local locked = false
	if result then
		if tonumber(result["rype"]) ~= 2 and tonumber(result["locked"]) == 1 then
			locked = true
		end
	end
	return locked
end

function enterElevator(goingin)
	local pickup = source
	local player = client
	if getElementType(pickup) ~= "elevator" then
		return
	end
	
	local elevatorStatus = getElementData(pickup, "status")
	if elevatorStatus[INTERIOR_TYPE] == 3 then
		outputChatBox("You try the door handle, but it seems to be locked.", player, 255, 0,0, true)
		return
	end
	
	vehicle = getPedOccupiedVehicle( player )
	if ( ( vehicle and elevatorStatus[INTERIOR_TYPE]  ~= 0 and getVehicleOccupant( vehicle ) == player ) or not vehicle ) then
		if not vehicle and elevatorStatus[INTERIOR_TYPE]  == 2 then
			outputChatBox( "This entrance is for vehicles only.", player, 255, 0, 0 )
			return
		end
		
		if elevatorStatus[INTERIOR_DISABLED] then
			outputChatBox( "This interior is currently disabled.", player, 255, 0, 0 )
			return
		end
		
		local currentCP = nil
		local otherCP = nil
		if goingin then
			currentCP = getElementData(pickup, "entrance")
			otherCP = getElementData(pickup, "exit")
		else
			currentCP = getElementData(pickup, "exit")
			otherCP = getElementData(pickup, "entrance")
		end
				
		local locked = false
		if currentCP[INTERIOR_DIM] == 0 and otherCP[INTERIOR_DIM] ~= 0 then -- entering a house
			locked = isInteriorLocked(otherCP[INTERIOR_DIM])
		elseif currentCP[INTERIOR_DIM] ~= 0 and otherCP[INTERIOR_DIM] == 0 then -- leaving a house
			locked = isInteriorLocked(currentCP[INTERIOR_DIM])
		elseif currentCP[INTERIOR_DIM] ~= 0 and otherCP[INTERIOR_DIM] ~= 0 and currentCP[INTERIOR_DIM] ~= otherCP[INTERIOR_DIM] then -- changing between two houses
			locked = isInteriorLocked(currentCP[INTERIOR_DIM]) or isInteriorLocked(otherCP[INTERIOR_DIM])
		else -- Moving in the same dimension
			locked = false
		end
		
		if locked then
			outputChatBox("You try the door handle, but it seems to be locked.", player, 255, 0,0, true)
			return
		end
		
		-- check for entrance fee
		local dbid, entrance, exit, interiorType, interiorElement  = call( getResourceFromName( "interior-system" ), "findProperty", player, otherCP[INTERIOR_DIM] )
		if dbid > 0 then
			local interiorEntrance = getElementData(interiorElement, "entrance")
			local interiorStatus = getElementData(interiorElement, "status")
			if currentCP[INTERIOR_DIM] ~= otherCP[INTERIOR_DIM] and interiorElement then
				if getElementData( player, "adminduty" ) ~= 1 and not exports.global:hasItem( player, 5, otherCP[INTERIOR_DIM] ) then
					if interiorEntrance[INTERIOR_FEE] and interiorEntrance[INTERIOR_FEE] > 0 then
						if not exports.global:takeMoney( player, interiorEntrance[INTERIOR_FEE] ) then
							outputChatBox( "You don't have enough money with you to enter this interior.", player, 255, 0, 0 )
							return
						else
							local ownerid = interiorStatus[INTERIOR_OWNER]
							local query = mysql:query_free("UPDATE characters SET bankmoney = bankmoney + '" .. mysql:escae_string(interiorEntrance[INTERIOR_FEE]) .. "' WHERE id = '" .. mysql:escape_string(ownerid).."'" )
							if query then
								for k, v in pairs( getElementsByType( "player" ) ) do
									if isElement( v ) then
										if getElementData( v, "dbid" ) == ownerid then
											exports['anticheat-system']:changeProtectedElementDataEx( v, "businessprofit", getElementData( v, "businessprofit" ) + interiorEntrance[INTERIOR_FEE], false )
											break
										end
									end
								end
							else
								outputChatBox( "Error 9019 - Report on Forums.", player, 255, 0, 0 )
							end
						end
					end
				end
			end
		else
			dbid, entrance, exit, interiorType, interiorElement  = call( getResourceFromName( "interior-system" ), "findProperty", player, currentCP[INTERIOR_DIM] )
		end
		
		if vehicle then
			exports['anticheat-system']:changeProtectedElementDataEx(vehicle, "health", getElementHealth(vehicle), false)
			for i = 0, getVehicleMaxPassengers( vehicle ) do
				local p = getVehicleOccupant( vehicle )
				if p then
					triggerClientEvent( p, "CantFallOffBike", p )
				end
			end
		else
		end

		if vehicle then
			setTimer(warpVehicleIntoInteriorfunction, 500, 1, vehicle, otherCP[INTERIOR_INT], otherCP[INTERIOR_DIM], 2, otherCP[INTERIOR_X],otherCP[INTERIOR_Y],otherCP[INTERIOR_Z],currentCP,otherCP)	
		elseif isElement(player) then
			triggerClientEvent(player, "setPlayerInsideInterior", interiorElement or getRootElement(), otherCP, interiorElement  or getRootElement())
		end
	end
end
addEvent("elevator:enter", true)
addEventHandler("elevator:enter", getRootElement(), enterElevator)

function warpVehicleIntoInteriorfunction(vehicle, interior, dimension, offset, x,y,z,pickup,other)
	if isElement(vehicle) then
		local offset = getElementData(vehicle, "groundoffset") or 2
		
		setElementPosition(vehicle, x, y, z  - 1 + offset)
		setElementInterior(vehicle, interior)
		setElementDimension(vehicle, dimension)
		setElementVelocity(vehicle, 0, 0, 0)
		setVehicleTurnVelocity(vehicle, 0, 0, 0)
		local rx, ry, rz = getVehicleRotation(vehicle)
		setVehicleRotation(vehicle, 0, 0, rz)
		setTimer(setVehicleTurnVelocity, 50, 2, vehicle, 0, 0, 0)			
		setElementHealth(vehicle, getElementData(vehicle, "health") or 1000)
		exports['anticheat-system']:changeProtectedElementDataEx(vehicle, "health")
		setElementFrozen(vehicle, true)
					
		setTimer(setElementFrozen, 1000, 1, vehicle, false)
			
		for i = 0, getVehicleMaxPassengers( vehicle ) do
			local player = getVehicleOccupant( vehicle, i )
			if player then
				setElementInterior(player, interior)
				setCameraInterior(player, interior)
				setElementDimension(player, dimension)
				setCameraTarget(player)
				
				triggerEvent("onPlayerInteriorChange", player)
				exports['anticheat-system']:changeProtectedElementDataEx(player, "realinvehicle", 1, false)
			end
		end
	end
end

function deleteElevator(thePlayer, commandName, id)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) or (exports.donators:hasPlayerPerk(thePlayer,14) and exports.global:isPlayerFullAdmin(thePlayer)) then
		if not (tonumber(id)) then
			outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			id = tonumber(id)
			
			local dbid, entrance, exit, status, elevatorElement = findElevator( id )
			
			if elevatorElement then
				local query = mysql:query_free("DELETE FROM elevators WHERE id='" .. mysql:escape_string(dbid) .. "'")
				if query then
					reloadOneElevator(dbid)
					outputChatBox("Elevator #" .. id .. " Deleted!", thePlayer, 0, 255, 0)
				else
					outputChatBox("ELE0015 Error, please report to a scripter.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Elevator ID does not exist!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delelevator", deleteElevator, false, false)

function getNearbyElevators(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		local dimension = getElementDimension(thePlayer)
		outputChatBox("Nearby Elevators:", thePlayer, 255, 126, 0)
		local found = false
		
		local possibleElevators = getElementsByType("elevator")
		for _, elevator in ipairs(possibleElevators) do
			local elevatorEntrance = getElementData(elevator, "entrance")
			local elevatorExit = getElementData(elevator, "exit")
			
			for _, point in ipairs( { elevatorEntrance, elevatorExit } ) do
				if (point[INTERIOR_DIM] == dimension) then
					local distance = getDistanceBetweenPoints3D(posX, posY, posZ, point[INTERIOR_X], point[INTERIOR_Y], point[INTERIOR_Z])
					if (distance <= 11) then
						local dbid = getElementData(elevator, "dbid")
						if point == elevatorEntrance then
							outputChatBox(" ID " .. dbid ..", leading to dimension "..elevatorExit[INTERIOR_DIM], thePlayer, 255, 126, 0)
						else
							outputChatBox(" ID " .. dbid ..", leading to dimension "..elevatorEntrance[INTERIOR_DIM], thePlayer, 255, 126, 0)
						end
						
						found = true
					end
				end
			end
		end

		if not found then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyelevators", getNearbyElevators, false, false)

function SmallestElevatorID( ) -- finds the smallest ID in the SQL instead of auto increment
	local result = mysql:query_fetch_assoc("SELECT MIN(e1.id+1) AS nextID FROM elevators AS e1 LEFT JOIN elevators AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	if result then
		return tonumber(result["nextID"])
	end
	return false
end

addEvent( "toggleCarTeleportMode", false )
addEventHandler( "toggleCarTeleportMode", getRootElement(),
	function( player )
		local elevatorStatus = getElementData(source, "status")
		local mode = ( elevatorStatus[INTERIOR_TYPE] + 1 ) % 4
		local query = mysql:query_free("UPDATE elevators SET car = " .. mysql:escape_string(mode) .. " WHERE id = " .. mysql:escape_string(getElementData( source, "dbid" )) )
		if query then
			elevatorStatus[INTERIOR_TYPE] = mode
			exports['anticheat-system']:changeProtectedElementDataEx( source, "status", elevatorStatus, false )
			if mode == 0 then
				outputChatBox( "You changed the mode to 'players only'.", player, 0, 255, 0 )
			elseif mode == 1 then
				outputChatBox( "You changed the mode to 'players and vehicles'.", player, 0, 255, 0 )
			elseif mode == 2 then
				outputChatBox( "You changed the mode to 'vehicles only'.", player, 0, 255, 0 )
			else
				outputChatBox( "You changed the mode to 'no entrance'.", player, 0, 255, 0 )
			end
		else
			outputChatBox( "Error 9019 - Report on Forums.", player, 255, 0, 0 )
		end
	end
)

function toggleElevator( thePlayer, commandName, id )
	if exports.global:isPlayerSuperAdmin( thePlayer ) then
		id = tonumber( id )
		if not id then
			outputChatBox( "SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit, status, elevatorElement = findElevator( id )
			
			if elevatorElement then
				if status[INTERIOR_DISABLED] then
					mysql:query_free("UPDATE elevators SET disabled = 0 WHERE id = " .. mysql:escape_string(dbid) )
				else
					mysql:query_free("UPDATE elevators SET disabled = 1 WHERE id = " .. mysql:escape_string(dbid) )
				end
				reloadOneElevator(dbid)
				
			else
				outputChatBox( "Elevator not found.", thePlayer, 255, 194, 14 )
			end
		end
	end
end
addCommandHandler( "toggleelevator", toggleElevator )