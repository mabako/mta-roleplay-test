function syncRadio(station)
	local vehicle = getPedOccupiedVehicle(source)
	exports['anticheat-system']:changeProtectedElementDataEx(vehicle, "vehicle:radio", station, true)
end
addEvent("car:radio:sync", true)
addEventHandler("car:radio:sync", getRootElement(), syncRadio)

function syncRadio(vol)
	local vehicle = getPedOccupiedVehicle(source)
	exports['anticheat-system']:changeProtectedElementDataEx(vehicle, "vehicle:radio:volume", vol, true)
end
addEvent("car:radio:vol", true)
addEventHandler("car:radio:vol", getRootElement(), syncRadio)