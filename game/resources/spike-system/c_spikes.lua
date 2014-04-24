function SpikesOnGround(theElement, matchingDimension)
	if(getElementType(theElement) == "vehicle") and (getVehicleController(theElement)==getLocalPlayer()) then
		local shapetype = getElementData(source, "type")
		
		if (shapetype) then
			if (shapetype=="spikes") then
				local luck
				luck = math.random(1, 4)
				if(luck ~= 1) then
					setVehicleWheelStates ( theElement, 1, -1, -1, -1 )
				end
				luck = math.random(1, 4)
				if(luck ~= 4) then
					setVehicleWheelStates ( theElement, -1, 1, -1, -1 )
				end
				luck = math.random(1, 4)
				if(luck ~= 3) then
					setVehicleWheelStates ( theElement, -1, -1, 1, -1 )
				end
				luck = math.random(1, 4)
				if(luck ~= 2) then
					setVehicleWheelStates ( theElement, -1, -1, -1, 1 )
				end
				local tx, ty, tz = getVehicleTurnVelocity( theElement )
				setVehicleTurnVelocity ( theElement, tx, ty, tz > 0 and 0.22 or -0.22 )
			end
		end
	end
end
addEventHandler( "onClientColShapeHit", getRootElement(), SpikesOnGround )