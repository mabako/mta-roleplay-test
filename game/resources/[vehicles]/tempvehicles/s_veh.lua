local armoredCars = { [427]=true, [528]=true, [432]=true, [601]=true, [428]=true, [597]=true } -- Enforcer, FBI Truck, Rhino, SWAT Tank, Securicar, SFPD Car
local removalTimers = {}
local tempID = 0
local function newTempVehicleID()
	tempID = tempID - 1
	return tempID
end

local function destroyVehicle(vehicle)
	outputDebugString('deleting vehicle ' .. getElementData(vehicle, 'dbid') .. ' ' .. tostring(removalTimers[vehicle]))
	destroyElement(vehicle)
end

function create(model, x, y, z, rz, player, col1, col2)
	local plate = tostring( getElementData(player, "account:id") )
	if #plate < 8 then
		plate = " " .. plate
		while #plate < 8 do
			plate = string.char(math.random(string.byte('A'), string.byte('Z'))) .. plate
		end
	end

	local veh = createVehicle(model, x, y, z, rx, ry, rz, plate)
	if not (veh) then
		outputChatBox("Invalid Vehicle ID.", player, 255, 0, 0)
	else
		if (armoredCars[model]) then
			setVehicleDamageProof(veh, true)
		end

		local dbid = newTempVehicleID()
		exports.pool:allocateElement(veh, dbid)
		
		setElementInterior(veh, getElementInterior(player))
		setElementDimension(veh, getElementDimension(player))
		setVehicleColor(veh, col1, col2, col1, col2)
		
		setVehicleOverrideLights(veh, 1)
		setVehicleEngineState(veh, false)
		setVehicleFuelTankExplodable(veh, false)
		setVehicleVariant(veh, exports['vehicle-system']:getRandomVariant(getElementModel(veh)))
		
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "dbid", dbid)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "fuel", 100, false)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "Impounded", 0)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "engine", 0, false)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "oldx", x, false)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "oldy", y, false)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "oldz", z, false)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "faction", -1)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "owner", -1, false)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "job", 0, false)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "handbrake", 0, false)
		outputChatBox(getVehicleName(veh) .. " spawned with TEMP ID " .. dbid .. ".", player, 255, 194, 14)
		
		exports['vehicle-interiors']:add( veh )
		exports.logs:dbLog(player, 6, player, "VEH ".. model .. " created with ID " .. dbid)

		removalTimers[veh] = setTimer(destroyVehicle, 15 * 60 * 1000, 1, veh)

		return veh
	end
end

-- delete inactive vehicles after 15 minutes.


local function isOccupied(vehicle, ignoredPlayer)
	for k, v in pairs(getVehicleOccupants(vehicle)) do
		if v ~= ignoredPlayer then
			return true
		end
	end
	return false
end

addEventHandler('onVehicleEnter', resourceRoot,
	function(player)
		-- check with a slight delay to avoid wrong events due to locking (where players got removed shortly after)
		if removalTimers[source] then
			setTimer(
				function(vehicle)
					if isOccupied(vehicle) and removalTimers[vehicle] then
						killTimer(removalTimers[vehicle])
						removalTimers[vehicle] = nil
					end
				end, 200, 1, source)
		end
	end
)

addEventHandler('onVehicleExit', resourceRoot,
	function(player)
		-- still occupied?
		if not isOccupied(source, player) and not removalTimers[source] then
			removalTimers[source] = setTimer(destroyVehicle, 15 * 60 * 1000, 1, source)
		end
	end
)

addEventHandler('onElementDestroy', resourceRoot,
	function()
		if removalTimers[source] then
			removalTimers[source] = nil
		end
	end
)
