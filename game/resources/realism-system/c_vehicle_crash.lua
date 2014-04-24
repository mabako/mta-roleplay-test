local c_root = getRootElement()
local c_player = getLocalPlayer()
local c_lastspeed = 0
local c_speed = 0
local isplayernotjumpaway = true

-----------------------------
function getActualVelocity( element, x, y, z )
	return (x^2 + y^2 + z^2) ^ 0.5
end

-----------------------------
function updateDamage()
	c_speed = getActualVelocity( c_veh, getElementVelocity( c_veh ) )
	if c_lastspeed - c_speed >= 0.25 and not isElementFrozen( c_veh ) then
		if (c_lastspeed - c_speed >= 0.35) then -- trigger throwing out of the vehicle
			local vehicle = getPedOccupiedVehicle(getLocalPlayer())
			local x, y, z = getElementPosition(getLocalPlayer())
			local nx, ny, nz
			local rz = getPedRotation(getLocalPlayer())

			nx = x + math.sin( math.rad( rz )) * 2
			ny = y + math.cos( math.rad( rz )) * 2
			nz = getGroundPosition(nx, ny, z)
			
			local bcollision, ex, ey, ez, element = processLineOfSight(x, y, z+1, nx, ny, nz+1, true, true, true, true, true, false, false, false, vehicle)
			if (bcollision) then
				ez = getGroundPosition(ex, ey, ez)
				triggerServerEvent("crashThrowPlayerFromVehicle", vehicle, ex, ey, ez+1, vehicle)
			else
				triggerServerEvent("crashThrowPlayerFromVehicle", vehicle, nx, ny, nz+1, vehicle)
			end
		end
	
		c_lasthealth = getElementHealth(c_player) - 40*(c_lastspeed)
		if c_lasthealth <= 0 then
			c_lasthealth = 0
		end
		setElementHealth(c_player , c_lasthealth)
	end
	c_lastspeed = c_speed

end

function onJumpOut()
	isplayernotjumpaway = false
end

function onJumpFinished()

	isplayernotjumpaway = true
end

-----------------------------
addEventHandler( "onClientVehicleStartExit", c_root,onJumpOut)
addEventHandler( "onClientVehicleExit", c_root,onJumpFinished)
addEventHandler( "onClientRender", c_root,function  ( )
	if isplayernotjumpaway and isPedInVehicle(c_player) then
		c_veh = getPedOccupiedVehicle(c_player)
		if c_veh then
			local c_veh_driver = getVehicleOccupant ( c_veh, 0 )
			if c_veh_driver == c_player then
				updateDamage()
			end
		end
	else
		c_speed = 0
		c_lastspeed = 0
	end
end
)