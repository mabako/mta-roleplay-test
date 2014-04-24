-- Contributed code, modified for vG likings
speedoSpeedStr = " "
local oldx = 0
local oldy = 0
local gears = false

-- 
local playerGear = 0 

function gearPlus()
	if isPedInVehicle( getLocalPlayer() ) then
		local vehicle = getPedOccupiedVehicle( getLocalPlayer() )
		if getVehicleController ( vehicle ) == getLocalPlayer() then
			local vType = getVehicleType( vehicle )
			if vType ~= "Plane" and vType ~= "Helicopter" and vType ~= "Boat" and vType ~= "Trailer" and vType ~= "Train" then
				if playerGear < 5 then
					playerGear = playerGear + 1
					setElementData(vehicle, "realism:gear", playerGear, true)
				end
			end
		end
	end
end
bindKey( "num_add", "down", gearPlus )
addCommandHandler("gear+", gearPlus)
addCommandHandler("gearplus", gearPlus)

function gearMinus()
	if isPedInVehicle( getLocalPlayer() ) then
		local vehicle = getPedOccupiedVehicle( getLocalPlayer() )
		if vehicle and getVehicleController ( vehicle ) == getLocalPlayer() then
			local vType = getVehicleType( vehicle )
			if vType ~= "Plane" and vType ~= "Helicopter" and vType ~= "Boat" and vType ~= "Trailer" and vType ~= "Train" then
				if playerGear > -1 then
					playerGear = playerGear - 1
					setElementData(vehicle, "realism:gear", playerGear, true)
				end
			end
		end
	end
end
bindKey( "num_sub", "down", gearMinus )
addCommandHandler("gear-", gearMinus)
addCommandHandler("gearmin", gearMinus)

function toggear()
	gears = not gears
	toggleControl( "accelerate", true)
	toggleControl( "brake_reverse", true ) 
end
addCommandHandler("toggear", toggear)

function automaticHandling()
	speedoSpeedStr = "A" 
	if isPedInVehicle( getLocalPlayer() ) then
		local vehicle = getPedOccupiedVehicle( getLocalPlayer() )
		if getVehicleController ( vehicle ) == getLocalPlayer() then
			local velX, velY, velZ = getElementVelocity( vehicle )
			if math.max( velX, velY, velZ ) ~= velZ then
				local s = ( 1 / 900 ) + 1  
				local x, y = velX / s, velY / s
				setElementVelocity ( vehicle, x, y, velZ )
			end
		end
	end
end

function bmxHandling()
	speedoSpeedStr = " " 
	if isPedInVehicle( getLocalPlayer() ) then
		local vehicle = getPedOccupiedVehicle( getLocalPlayer() )
		if getVehicleController ( vehicle ) == getLocalPlayer() then
			local velX, velY, velZ = getElementVelocity( vehicle )
			if math.max( velX, velY, velZ ) ~= velZ then
				local s = ( 1 / 175 ) + 1  
				local x, y = velX / s, velY / s
				setElementVelocity ( vehicle, x, y, velZ )
			end
		end
	end
end


function doGearCheck()
	
	if not exports.global:isPlayerAdmin(getLocalPlayer()) and not exports.global:cisPlayerBronzeDonator( getLocalPlayer() )  then
		return
	end
	
	if gears == false then
		automaticHandling()
		return
	end

	if isPedInVehicle( getLocalPlayer() ) then
		local vehicle = getPedOccupiedVehicle( getLocalPlayer() )
		if isElement(vehicle) and getVehicleController ( vehicle ) == getLocalPlayer() then
			local vehicleGear = getVehicleCurrentGear( vehicle )
			local velX, velY, velZ = getElementVelocity( vehicle )
			local vType = getVehicleType( vehicle )
			local visible
			local dvel
				
			if playerGear == 1 then
				dvel = 1.055
			elseif playerGear == 2 then 
				dvel = 1.012
			elseif playerGear == 3 then 
				dvel = 1.005
			elseif playerGear == 4 then 
				dvel = 1.0025 
			end
			
			if (vType == "BMX") then
				bmxHandling()
				return
			end

			if vType ~= "Plane" and vType ~= "BMX" and vType ~= "Helicopter" and vType ~= "Boat" and vType ~= "Trailer" and vType ~= "Train" then
				visible = true
				if playerGear > 0 then
					toggleControl( "accelerate", true )
					if (isObjectGoingBackwards(vehicle)) then
						toggleControl( "brake_reverse", false )
					else
						toggleControl( "brake_reverse", true )
					end
					
					if playerGear < vehicleGear then
						if math.max( velX, velY, velZ ) ~= velZ then
							local x, y = velX / dvel, velY / dvel
							setElementVelocity ( vehicle, x, y, velZ )
						end
					end
				elseif playerGear == 0 then
					if (isObjectGoingBackwards(vehicle, true)) then
						toggleControl( "accelerate", true)
						toggleControl( "brake_reverse", false ) 
					else
						toggleControl( "accelerate", false)
						toggleControl( "brake_reverse", true ) 
					end
				elseif playerGear == -1 then
					if not (isObjectGoingBackwards(vehicle, true)) then
						toggleControl( "accelerate", false )
					else
						toggleControl( "accelerate", true )
					end
					toggleControl( "brake_reverse", true )
				end
				
				if vehicleGear < playerGear then
					if math.max( velX, velY, velZ ) ~= velZ then
						local s = ( ( ( playerGear - vehicleGear ) / 100 ) + 1 )
						local x, y = velX / s, velY / s
						setElementVelocity ( vehicle, x, y, velZ )
					end
				end
			else
				visible = false
				toggleControl( "accelerate", true )
				toggleControl( "brake_reverse", true )
			end
			
			if visible then
				if playerGear == -1 then
					speedoSpeedStr = "R"
				elseif playerGear == 0 then
					speedoSpeedStr = "N"
				else
					speedoSpeedStr = tostring(playerGear)
				end
			else
				speedoSpeedStr = " "
			end
		else
			playerGear = 0
			speedoSpeedStr = " "
		end
	else
		playerGear = 0
		speedoSpeedStr = " "
	end	
end
addEventHandler( "onClientRender", getRootElement(), doGearCheck )

function isObjectGoingBackwards(vehicle, stopfix)
	if (stopfix == nil) then
		stopfix = false
	end
	
	local backwards = false
	local px, py, pz = getElementPosition ( vehicle )
	local rx, ry, rz = getElementRotation ( vehicle )
		
	local dx = px - oldx
	local dy = py - oldy
	
	local tolerance = 50
		
	if dy > math.abs(dx) then
		if rz+tolerance < 315 and rz-tolerance > 45 then
			backwards = true
		end
	elseif dy < -math.abs(dx) then
		if rz+tolerance < 135 or rz-tolerance > 225 then
			backwards = true
		end
	elseif dx > math.abs(dy) then
		if rz+tolerance < 225 or rz-tolerance > 315 then
			backwards = true
		end
	elseif dx < -math.abs(dy) then
		if rz+tolerance < 45 or rz-tolerance > 135 then
			backwards = true
		end	
	end
	
	-- fixing a wierd bug :S
	if (px == oldx) then
		backwards = not stopfix
	end
	
	oldx = px
	oldy = py

	return backwards
end

function getGearStateOnEnter(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		playerGear = getElementData(source, "realism:gear") or 0
    end
end
addEventHandler("OnClientVehicleExit", getRootElement(), getGearStateOnEnter)