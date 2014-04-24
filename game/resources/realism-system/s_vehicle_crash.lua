function throwPlayerThroughWindow(x, y, z)	
	if source then
		local occupants = getVehicleOccupants ( source )
		local seats = getVehicleMaxPassengers( source )
	
		if occupants[0] == client then
			for seat = 0, seats do			
				local occupant = occupants[seat] -- Get the occupant
	 
				if occupant and getElementType(occupant) == "player" then -- If the seat is occupied by a player...
					exports['anticheat-system']:changeProtectedElementDataEx(occupant, "realinvehicle", 0, false)
					removePedFromVehicle(occupant, vehicle)
					setElementPosition(occupant, x, y, z)
					setPedAnimation(occupant, "CRACK", "crckdeth2", 10000, true, false, false)
					setTimer(setPedAnimation, 10005, 1, occupant)
				end
			end
		end
	end
end
addEvent("crashThrowPlayerFromVehicle", true)
addEventHandler("crashThrowPlayerFromVehicle", getRootElement(), throwPlayerThroughWindow)

function unhookTrailer(thePlayer)
   if (isPedInVehicle(thePlayer)) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
			detachTrailerFromVehicle(theVehicle) 
		end
   end
end
addCommandHandler("detach", unhookTrailer)
addCommandHandler("unhook", unhookTrailer)