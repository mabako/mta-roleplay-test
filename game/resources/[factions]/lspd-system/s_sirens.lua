function vehicleBlown()
	exports['anticheat-system']:changeProtectedElementDataEx(source, "lspd:siren", false)
	setVehicleSirensOn ( source , false )
end
addEventHandler("onVehicleRespawn", getRootElement(), vehicleBlown)

function setSirenState(enabled)
	if not (client) then
		return false
	end
	local theVehicle = getPedOccupiedVehicle(client)
	if not theVehicle then
		return false
	end
	if not isOwnedByFactionType(theVehicle, {2, 3, 4}) or not exports.global:hasItem(theVehicle, 85) then
		exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "lspd:siren", false)
		outputChatBox("Sirens don't seem to work in this car...", client, 255, 0, 0)
		return false
	end
	exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "lspd:siren", enabled)
	setVehicleSirensOn ( theVehicle , false )
	return true
end
addEvent( "lspd:setSirenState", true )
addEventHandler( "lspd:setSirenState", getRootElement(), setSirenState )

function isOwnedByFactionType(vehicle, factiontypes)
	local vehicleFactionID = getElementData(vehicle, "faction")
	local vehicleFactionElement = exports.pool:getElement("team", vehicleFactionID)
	if vehicleFactionElement then
		local vehicleFactionType = getElementData(vehicleFactionElement, "type")
		for key, factionType in ipairs(factiontypes) do
			if factionType == vehicleFactionType then
				return true
			end
		end
	end
	return false
end