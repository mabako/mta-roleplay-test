function beanbagFired(x, y, z, target)
	local px, py, pz = getElementPosition(source)
	local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)

	if (distance<35) then
		if (isElement(target) and getElementType(target)=="player") then
			exports['anticheat-system']:changeProtectedElementDataEx(target, "tazed", 1, false)
			toggleAllControls(target, false, true, false)
			exports.global:applyAnimation(target, "ped", "FLOOR_hit_f", -1, false, false, true)
			triggerClientEvent(target, "onClientPlayerWeaponCheck", target)
			setTimer(removeAnimationX, 10005, 1, target)
		end
	end
end
addEvent("beanbagFired", true )
addEventHandler("beanbagFired", getRootElement(), beanbagFired)

function removeAnimationX(thePlayer)
	if (isElement(thePlayer) and getElementType(thePlayer)=="player") then
		exports.global:removeAnimation(thePlayer)
		toggleAllControls(thePlayer, true, true, true)
		triggerClientEvent(thePlayer, "onClientPlayerWeaponCheck", thePlayer)
	end
end

function updateShotgunMode(mode)
	if ( tonumber(mode) and (tonumber(mode) >= 0 and tonumber(mode) <= 1) ) then
		exports['anticheat-system']:changeProtectedElementDataEx(client, "shotgunmode", mode, true)
	end
end
addEvent("shotgunmode", true)
addEventHandler("shotgunmode", getRootElement(), updateShotgunMode)