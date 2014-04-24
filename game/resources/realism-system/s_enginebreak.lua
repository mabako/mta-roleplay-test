function engineBreak()
	local health = getElementHealth(source)
	local driver = getVehicleController(source)
	
	if (driver) then
		if (health<=300) then
			local rand = math.random(1, 2)

			if (rand==1) then -- 50% chance
				setVehicleEngineState(source, false)
				exports['anticheat-system']:changeProtectedElementDataEx(source, "engine", 0, false)
				exports.global:sendLocalDoAction(driver, "The engine stalls due to damage.")
			end
		elseif (health<=400) then
			local rand = math.random(1, 5)

			if (rand==1) then -- 20% chance
				setVehicleEngineState(source, false)
				exports['anticheat-system']:changeProtectedElementDataEx(source, "engine", 0, false)
				exports.global:sendLocalDoAction(driver, "The engine stalls due to damage.")
			end
		end
	end
end
addEventHandler("onVehicleDamage", getRootElement(), engineBreak)