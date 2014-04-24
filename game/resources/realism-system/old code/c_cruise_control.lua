ccenabled = false
hasaccel = false
limit = 0
localPlayer = getLocalPlayer()

function toggleCruiseControl(commandName, speed)
	if not (speed) then
		if (not ccenabled) then
			outputChatBox("Your cruise control is disabled. Use /cruisecontrol [speed] to enable it.", 255, 194, 15)
		else
			hasaccel = false
			cooldown = false
			ccenabled = false
			setControlState("accelerate", false)
			removeEventHandler("onClientRender", getRootElement(), limitSpeed)
			outputChatBox("Your cruise control is now disabled.", 255, 0, 0)
		end
	else
		speed = tonumber(speed)
		limit = speed
		
		if (not ccenabled) then
			addEventHandler("onClientRender", getRootElement(), limitSpeed)
		end
		
		ccenabled = true
		outputChatBox("Your cruise control is now enabled and limited to " .. speed .. "Kph.", 0, 255, 0)
	end
end
addCommandHandler("cruisecontrol", toggleCruiseControl, false)
addCommandHandler("cc", toggleCruiseControl, false)

cooldown = false

function resetCD()
	cooldown = false
end

function startAccel()
	hasaccel = true
end
bindKey("accelerate", "down", startAccel)

function stopAccel()
	hasaccel = false
	cooldown = false
	setControlState("accelerate", false)
end
bindKey("brake_reverse", "down", stopAccel)

function limitSpeed()
	local vehicle = getPedOccupiedVehicle(localPlayer)

	if (vehicle) and not (cooldown) and (hasaccel) then
		local speed = exports.global:getVehicleVelocity(vehicle)
		
		if (speed<limit) then
			setControlState("accelerate", true)
		else
			cooldown = true
			local msec = (limit / 30) * 1000
			setTimer(resetCD, 1000, 1)
			setControlState("accelerate", false)
		end
	end
end