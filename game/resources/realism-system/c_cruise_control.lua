local limitSpeed = { }
table.insert(limitSpeed, 510, 40) -- Mountain bike
table.insert(limitSpeed, 509, 40) -- Bike
table.insert(limitSpeed, 481, 40) -- BMX
table.insert(limitSpeed, 522, 140) -- NRG-500
table.insert(limitSpeed, 468, 110) -- Sanchez
table.insert(limitSpeed, 581, 130) -- BF-400
table.insert(limitSpeed, 521, 130) -- FCR-900
table.insert(limitSpeed, 461, 135) -- PCJ-600
table.insert(limitSpeed, 463, 130) -- Freeway
table.insert(limitSpeed, 586, 120) -- Wayfarer
table.insert(limitSpeed, 448, 80) -- Pizzaboy
table.insert(limitSpeed, 462, 90) -- Faggio
table.insert(limitSpeed, 471, 80) -- Quadbike
table.insert(limitSpeed, 523, 140) -- HPV1000

table.insert(limitSpeed, 414, 60) -- Mule
table.insert(limitSpeed, 431, 60) -- Bus


local ccEnabled = false
local theVehicle = nil
local targetSpeed = 0

function doCruiseControl()
	if (not isElement(theVehicle)) then
		deactivateCruiseControl()
		return false
	end
	local x,y = angle(theVehicle)
	if (x < 17) then
		local targetSpeedTmp = getElementSpeed(theVehicle)
		if (targetSpeedTmp > targetSpeed) then
			setControlState("accelerate",false)
		elseif (targetSpeedTmp < targetSpeed) then
			setControlState("accelerate",true)
		end
	end
end

function activateCruiseControl()
	addEventHandler("onClientRender", getRootElement(), doCruiseControl)
	ccEnabled = true
	bindMe()
end

function deactivateCruiseControl()
	removeEventHandler("onClientRender", getRootElement(), doCruiseControl)
	setControlState("accelerate",false)
	ccEnabled = false
end

function applyCruiseControl()
	theVehicle = getPedOccupiedVehicle( getLocalPlayer() )
	if (theVehicle) then
		if (getVehicleOccupant(theVehicle) == getLocalPlayer()) then
			if (ccEnabled) then
				outputChatBox("Cruise Control disabled", 255,0,0)
				deactivateCruiseControl()
			else
				targetSpeed = getElementSpeed(theVehicle)
				if targetSpeed > 4 then
					if (getVehicleType(theVehicle) == "Automobile" or getVehicleType(theVehicle) == "Bike" or getVehicleType(theVehicle) =="Boat" or getVehicleType(theVehicle) == "Train") then
						outputChatBox("Cruise Control Enabled", 0,255,0)
						outputChatBox("Use - and + to adjust the speed", 0,255,0)
						activateCruiseControl()
					end
				else
					outputChatBox("Cruise Control can be used for maintaining speed, not pulling up.", 0,255,0)
				end
			end
		end
	end
end


addEventHandler("onClientPlayerVehicleExit", getLocalPlayer(), function(veh, seat)
	if (seat==0) then
		if (ccEnabled) then
			deactivateCruiseControl()
		end
	end
end)

function increaseCruiseControl()
	if (ccEnabled) then
		targetSpeed = targetSpeed + 5
		
		local tV = getPedOccupiedVehicle(getLocalPlayer()) 
		if (tV) then
			local maxSpeed = limitSpeed[getElementModel(tV)]
			if maxSpeed then 
				if targetSpeed > maxSpeed then
					targetSpeed = maxSpeed
				end
			end
		end 
	end
end


function decreaseCruiseControl()
	if (ccEnabled) then
		targetSpeed = targetSpeed - 5
	end
end


function startAccel()
	if (ccEnabled) then
		deactivateCruiseControl()
	end
end


function stopAccel()
	if (ccEnabled) then
		deactivateCruiseControl()
	end
end


function restrictBikes(manual) 
	local tV = getPedOccupiedVehicle(getLocalPlayer()) 
	if (tV) then
		local maxSpeed = limitSpeed[getElementModel(tV)]
		if maxSpeed then 
			tS = exports.global:getVehicleVelocity(tV) 
			if tS > maxSpeed then 
				toggleControl("accelerate",false) 
			else 
				toggleControl("accelerate", true) 
			end 
		end
	end 
end

function bindMe()
	bindKey("brake_reverse", "down", stopAccel)
	bindKey("accelerate", "down", startAccel)
end

    function loadMe( startedRes )
		outputDebugString("cc loaded")
		bindKey("-", "down", decreaseCruiseControl)
		bindKey("num_sub", "down", decreaseCruiseControl)
		
		bindKey("=", "down", increaseCruiseControl)
		bindKey("num_add", "down", increaseCruiseControl)
		
		addCommandHandler("cc", applyCruiseControl)
		addCommandHandler("cruisecontrol", applyCruiseControl)

		addEventHandler("onClientRender", getRootElement(), restrictBikes)
		bindMe()
    end
addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()) , loadMe)