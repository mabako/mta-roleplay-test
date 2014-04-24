rot = 0.0
vehicle = false
effect = false
isdead = false

function realisticDamage(attacker, weapon, bodypart)
	if getElementData(source, "reconx") and getElementData(source, "reconx") ~= true then
		cancelEvent( )
	else
		-- Only AK47, M4 and Sniper can penetrate armor
		local armor = getPedArmor(source)
		
		if (weapon>0) and (attacker) then
			local armorType = getElementData(attacker, "armortype")
			local bulletType = getElementData(attacker, "bullettype")
			
			if (armor>0) and (armorType==1) and (bulletType~=1) and (weapon>0) then
				if ((weapon~=30) and (weapon~=31) and (weapon~=34)) and (bodypart~=9) then
					cancelEvent()
				end
			end
		end
		
		-- Damage effect
		local gasmask = getElementData(source, "gasmask")
		if not (effect) and ((not gasmask or gasmask==0) and (weapon==17)) then
			fadeCamera(false, 1.0, 255, 0, 0)
			effect = true
			setTimer(endEffect, 250, 1)
		end
	end
end
addEventHandler("onClientPlayerDamage", getLocalPlayer(), realisticDamage)

function endEffect()
	fadeCamera(true, 1.0)
	effect = false
	isdead = false
end

function playerDeath()
	if isdead then
		return
	end
	isdead = true
	deathTimer = 10
	deathLabel = nil
	rot = 0.0
	fadeCamera(false, 29)
	vehicle = isPedInVehicle(getLocalPlayer())
	
	local pX, pY, pZ = getElementPosition(getLocalPlayer())

	-- Setup the text
	setTimer(lowerTimer, 1000, 10)
	
	local screenwidth, screenheight = guiGetScreenSize ()
	
	local width = 300
	local height = 100
	local x = (screenwidth - width)/2
	local y = screenheight - (screenheight/8 - (height/8))
	deathLabel = guiCreateLabel(x, y, width, height, "10 Seconds", false)
	guiSetFont(deathLabel, "sa-gothic")
	
	setGameSpeed(0.5)
end
addEventHandler("onClientPlayerWasted", getLocalPlayer(), playerDeath)

function lowerTimer()
	deathTimer = deathTimer - 1
	
	if (deathTimer>1) then
		guiSetText(deathLabel, tostring(deathTimer) .. " Seconds")
	else
		if (isElement(deathLabel)) then
			if deathTimer <= 0 then
				guiSetText(deathLabel, "Respawning...")
			else
				guiSetText(deathLabel, tostring(deathTimer) .. " Second")
			end
		end
	end
end

deathTimer = 10
deathLabel = nil

function playerRespawn()
	setGameSpeed(1)
	if (isElement(deathLabel)) then
		destroyElement(deathLabel)
	end
	setCameraTarget(getLocalPlayer())
end
addEventHandler("onClientPlayerSpawn", getLocalPlayer(), playerRespawn)

local sx, sy = guiGetScreenSize()
local start = 0
local fadeTime = 4000

addEvent("fadeCameraOnSpawn", true)
addEventHandler("fadeCameraOnSpawn", getLocalPlayer(),
	function()
		start = getTickCount()
	end
)

addEventHandler("onClientRender",getRootElement(),
	function()
		local currTime = getTickCount() - start
		if currTime < fadeTime then
			local height = ( sx / 2 ) * ( 1 - currTime / fadeTime )
			local alpha = 255 * ( 1 - currTime / fadeTime )
			dxDrawRectangle( 0, 0, sx, height, tocolor( 0, 0, 0, 255 ) )
			dxDrawRectangle( 0, sy - height, sx, height, tocolor( 0, 0, 0, 255 ) )
			dxDrawRectangle( 0, 0, sx, sy, tocolor( 0, 0, 0, alpha ) )
		end
	end
)