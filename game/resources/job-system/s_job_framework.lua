function cancelCityMaintenance()
	exports.global:takeWeapon(source, 41)
end
addEvent("cancelCityMaintenance", true)
addEventHandler("cancelCityMaintenance", getRootElement(), cancelCityMaintenance)