local factor = 1.5 -- 1.9487

function relateVelocity(speed)
	return factor * speed
end

function getVehicleVelocity(vehicle)
	speedx, speedy, speedz = getElementVelocity (vehicle)
	return relateVelocity((speedx^2 + speedy^2 + speedz^2)^(0.5)*100)
end