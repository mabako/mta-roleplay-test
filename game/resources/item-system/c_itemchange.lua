function updateItemThings()
	--outputDebugString("itemThingsUpdate")
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if exports.global:hasItem(getLocalPlayer(), 111) or (vehicle and (tonumber(getElementData(vehicle, "job")) or 0) > 0) then
		showPlayerHudComponent("radar", true)
	else
		showPlayerHudComponent("radar", false)
	end
end
addEvent("item:updateclient", true)
addEventHandler("item:updateclient", getRootElement(), updateItemThings)
addEventHandler("onCharacterLogin", getRootElement(), updateItemThings)
addEventHandler("onClientPlayerVehicleEnter", getLocalPlayer(), updateItemThings)
addEventHandler("onClientPlayerVehicleExit", getLocalPlayer(), updateItemThings)
