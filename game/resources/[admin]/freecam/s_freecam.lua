function setPlayerFreecamEnabled(player, x, y, z, dontChangeFixedMode)
	removePedFromVehicle(player)
	setElementData(player, "realinvehicle", 0, false)

	return triggerClientEvent(player,"doSetFreecamEnabled", getRootElement(), x, y, z, dontChangeFixedMode)
end

function setPlayerFreecamDisabled(player, dontChangeFixedMode)
	return triggerClientEvent(player,"doSetFreecamDisabled", getRootElement(), dontChangeFixedMode)
end

function setPlayerFreecamOption(player, theOption, value)
	return triggerClientEvent(player,"doSetFreecamOption", getRootElement(), theOption, value)
end

function isPlayerFreecamEnabled(player)
	return getElementData(player,"freecam:state")
end