localPlayer = getLocalPlayer()

function clickOnGate(button, state, absX, absY, wx, wy, wz, element)
	if (element) and (getElementType(element)=="object") and (button=="left") and (state=="down") then
		local isGate = getElementData(element, "gate")
		if isGate then
			if (canPlayerReachGate(element, localPlayer)) then
				triggerServerEvent("gate:trigger", element)
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickOnGate, true)

function triggerNearbyGates()
	for _, theGate in ipairs(getElementsByType("object")) do
		--outputChatBox("loop")
		local isGate = getElementData(theGate, "gate")
		if isGate then
			if (canPlayerReachGate(theGate, localPlayer)) then
				triggerServerEvent("gate:trigger", theGate)
			end
		end
	end
end
addCommandHandler("gate", triggerNearbyGates)


function canPlayerReachGate(theGate, thePlayer)
	if thePlayer and isElement(thePlayer)  and theGate and isElement(theGate) then
		if getElementDimension(thePlayer) ~= getElementDimension(theGate) or getElementInterior(thePlayer) ~= getElementInterior(theGate) then
			return false
		end
	
		local distance =  getGateTriggerDistance(theGate, thePlayer)
		if distance > 0 then
			local x, y, z = getElementPosition(thePlayer)		
			local wx, wy, wz = getElementPosition(theGate)	
			if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz) <= distance) then
				return true
			end
		end
	end
	return false
end

function getGateTriggerDistance(theGate, thePlayer)
	local isGate = getElementData(theGate, "gate")
	if isGate == true then
		if thePlayer and isElement(thePlayer) and isPedInVehicle(thePlayer) then
			return 20
		else
			return 5
		end
	end
	return 0
end