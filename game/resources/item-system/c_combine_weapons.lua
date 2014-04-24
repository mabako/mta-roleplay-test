function traceBullet(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement )
	--outputChatBox("shot detected w:"..weapon.." a:"..ammo .." aic:"..ammoInClip )
	if ammoInClip == 0 or ammoInClip == 1 then
		-- We shot our last bullet.
		triggerServerEvent("i:s:w", getLocalPlayer(), { { weapon, ammo, 0 } } )
	end
end
addEventHandler ( "onClientPlayerWeaponFire", getLocalPlayer(), traceBullet )

function disableGunOnSwitch ( prevSlot, newSlot )
	local weaponID = getPedWeapon(getLocalPlayer(), newSlot)
	if ((getElementData(source, "cf:"..tostring(weaponID)) or getElementData(source, "r:cf:"..tostring(weaponID)) or  getPedAmmoInClip(getLocalPlayer(), newSlot) < 2) and not (weaponID==2 or weaponID==3 or weaponID==4 or weaponID==5 or weaponID==6 or weaponID==7 or weaponID==9 or weaponID==15 or weaponID == 0)) then
		toggleControl ( "fire", false )
	else 
		toggleControl ( "fire", true )
	end
end
addEventHandler ( "onClientPlayerWeaponSwitch", getLocalPlayer(), disableGunOnSwitch )
addEvent ( "onClientPlayerWeaponCheck", true )
addEventHandler ( "onClientPlayerWeaponCheck", getLocalPlayer(), disableGunOnSwitch )

-- 
function weaponServerSync()
	local loggedin = getElementData(getLocalPlayer(), "loggedin")
	if (loggedin==1) then
		local weaponArr = { }
		for i=0, 12 do
			local weapon = getPedWeapon(getLocalPlayer(), i)
			if weapon then
				local ammo = getPedTotalAmmo(getLocalPlayer(), i) or 0
				if ammo > 0 then
					 weaponArr[ #weaponArr + 1 ]  = { weapon, ammo, getPedAmmoInClip ( getLocalPlayer(), i ) }
				end
			end
		end
		triggerServerEvent("i:s:w", getLocalPlayer(), weaponArr)
	end
end
setTimer(weaponServerSync, 30000, 0)
addEvent("i:s:w:r", true)
addEventHandler("i:s:w:r", getRootElement(), weaponServerSync)

function doReload()
	if getPedWeapon(getLocalPlayer()) then
		weaponServerSync()
		triggerServerEvent("i:s:w:r:do", getLocalPlayer())
	end
end

function bindKeys()
	bindKey("r", "down", doReload)
end
addEventHandler("onClientResourceStart", getResourceRootElement(), bindKeys)
