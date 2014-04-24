function toggleHandbrake( player, vehicle )
	local handbrake = getElementData(player, "handbrake") or isElementFrozen(vehicle) and 1 or 0
	if (handbrake == 0) then
		if isVehicleOnGround(vehicle) or getVehicleType(vehicle) == "Boat" or getElementDimension(vehicle) ~= 0 or getElementModel(vehicle) == 573 then -- 573 = Dune
			exports['anticheat-system']:changeProtectedElementDataEx(vehicle, "handbrake", 1, false)
			setElementFrozen(vehicle, true)
			outputChatBox("Handbrake has been applied.", player, 0, 255, 0)
		else
			outputChatBox("You can only apply the handbrake when your vehicle is on the ground.", player, 255, 0, 0)
		end
	else
		exports['anticheat-system']:changeProtectedElementDataEx(vehicle, "handbrake", 0, false)
		setElementFrozen(vehicle, false) 
		outputChatBox("Handbrake has been released.", player, 0, 255, 0)
		triggerEvent("vehicle:handbrake:lifted", vehicle, player)
	end
end

function cmdHandbrake(sourcePlayer)
	if isPedInVehicle ( sourcePlayer ) and (getElementData(sourcePlayer,"realinvehicle") == 1)then
		local playerVehicle = getPedOccupiedVehicle ( sourcePlayer )
		if (getVehicleOccupant(playerVehicle, 0) == sourcePlayer) then
			toggleHandbrake( sourcePlayer, playerVehicle )
		else
			outputChatBox("You need to be an driver to control the handbrake...", sourcePlayer, 255, 0, 0)
		end
	else
		outputChatBox("Ahum, how would you apply a handbrake without a vehicle...", sourcePlayer, 255, 0, 0)
	end
end
addCommandHandler("handbrake", cmdHandbrake)

addEvent("vehicle:handbrake:lifted", true)

addEvent("vehicle:handbrake", true)
addEventHandler( "vehicle:handbrake", root, function( ) if getVehicleType( source ) == "Trailer" then toggleHandbrake( client, source ) end end )
