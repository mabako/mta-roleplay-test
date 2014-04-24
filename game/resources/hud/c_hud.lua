local active = true
local screenWidth, screenHeight = guiGetScreenSize()
local localPlayer = getLocalPlayer()

function drawHUD()
	if active and not isPlayerMapVisible() then
		local ax, ay = screenWidth - 34, 0	

		local health = getElementHealth( localPlayer )
		if (health <= 30) then
			dxDrawImage(ax,ay,32,37,"images/hud/lowhp.png")
			
			if (health <= 10) then
				local getTickStart = getTickCount ()
				getTickStart = math.floor(getTickStart / 1000)
				if math.mod(getTickStart, 2) == 0 then
					dxDrawImage(ax,ay+37,32,37,"images/hud/bleeding.png")
				end
			end
			ax = ax - 34
		end
		
		local armour = getPedArmor( localPlayer )
		if armour > 0 then
			dxDrawImage(ax,ay,32,37,"images/hud/armour.png")
			ax = ax - 34
		end
		
		for key, value in pairs(masks) do
			if getElementData(localPlayer, value[1]) then
				dxDrawImage(ax,ay,32,37,"images/hud/" .. value[1] .. ".png")
				ax = ax - 34
			end
		end
		
		local _, _, _, badge = getBadgeColor(localPlayer)
		if badge then
			dxDrawImage(ax,ay,32,37,"images/hud/badge" .. tostring(badge) .. ".png")
			ax = ax - 34
		end
		
		if exports['realism-system']:isLocalPlayerSmoking() then
			dxDrawImage(ax,ay,32,37,"images/hud/cigarette.png")
			ax = ax - 34
		end
		
		if (getPedWeapon(localPlayer) == 24) and (getPedTotalAmmo(localPlayer) > 0) then
			local deagleMode = getElementData(localPlayer, "deaglemode")
			if (deagleMode == 0) then -- tazer
				dxDrawImage(ax,ay,32,37,"images/hud/dtazer.png")
			elseif (deagleMode == 1) then-- lethal
				dxDrawImage(ax,ay,32,37,"images/hud/dglock.png")
			elseif (deagleMode == 2) then-- radar
				dxDrawImage(ax,ay,32,37,"images/hud/dradar.png")
			end
			ax = ax - 34
		end
		
		if (getPedWeapon(localPlayer) == 25) and (getPedTotalAmmo(localPlayer) > 0) then
			local shotgunMode = getElementData(localPlayer, "shotgunmode")
			if shotgunMode == 0 then -- bean bag
				dxDrawImage(ax,ay,32,37,"images/hud/shotbean.png")
			elseif shotgunMode == 1 then -- lethal
				dxDrawImage(ax,ay,32,37,"images/hud/shotlethal.png")
			end
			ax = ax - 34
		end
		
	end
end
addEventHandler("onClientPreRender", getRootElement(), drawHUD)

addCommandHandler( "togglehud",
	function( )
		active = not active
		if active then
			outputChatBox( "HUD is now on.", 0, 255, 0 )
		else
			outputChatBox( "HUD is now off.", 255, 0, 0 )
		end
	end
)