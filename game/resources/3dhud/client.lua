--//
--|| Created by KryPtoHolYx
--|| for More free Scripts visit kryptoholyx.com
--|| Thanks for Downloading
--\\



--// Settings
C_Disable_GTA_HUD = false
C_Creator_ScreenWidth = 1440
C_Creator_ScreenHeight = 900
s = {guiGetScreenSize()}
--AMMO
offsetboneAmmo = "muzzle" --// valid are "muzzle" and all bones
offsetdistAmmo1 = 0.15
offsetdistAmmo2 = 0.15
rotoffsetAmmo1 = 0
rotoffsetAmmo2 = -90
zoffsetAmmo = 0.1
--HEALTH
offsetboneHealth = 32 --// valid are all bones
offsetdistHealth1 = 0.1
offsetdistHealth2 = 0.1
rotoffsetHealth1 = 150
rotoffsetHealth2 = -90
zoffsetHealth = 0.1
--MONEY
offsetboneMoney = 41 --// valid are all bones
offsetdistMoney1 = 0.25
offsetdistMoney2 = 0.25
rotoffsetMoney1 = 230
rotoffsetMoney2 = -90
zoffsetMoney = -0.2
debug = false
drawboxes = true
drawammo = true
drawhp = false
drawmoney = false
--\\
local function dxDrawTextBordered(text,x,y,tx,ty, color, size, font,right,top, clip, wordBreak, postGUI,colorCoded, subPixelPositioning)
dxDrawText(text,x-1,y,tx-1,ty, tocolor(0, 0, 0, 255), size, font,right,top, clip, wordBreak, postGUI,colorCoded, subPixelPositioning)
dxDrawText(text,x,y-1,tx,ty-1, tocolor(0, 0, 0, 255), size, font,right,top, clip, wordBreak, postGUI,colorCoded, subPixelPositioning)
dxDrawText(text,x+1,y,tx+1,ty, tocolor(0, 0, 0, 255), size, font,right,top, clip, wordBreak, postGUI,colorCoded, subPixelPositioning)
dxDrawText(text,x,y+1,tx,ty+1, tocolor(0, 0, 0, 255), size, font,right,top, clip, wordBreak, postGUI,colorCoded, subPixelPositioningpo)
dxDrawText(text,x,y,tx,ty, color, size, font,right,top)
end

showPlayerHudComponent ( "all",C_Disable_GTA_HUD )
showPlayerHudComponent ( "radar", not C_Disable_GTA_HUD )
showPlayerHudComponent ( "crosshair", not C_Disable_GTA_HUD )
showPlayerHudComponent ( "vehicle_name", not C_Disable_GTA_HUD )

		function findrotation (x,y,rz,dist,rot)
			local x = x+dist*math.cos(math.rad(rz+rot))
			local y = y+dist*math.sin(math.rad(rz+rot))
			return x,y
		end

		
--// Making the dxdraws fit on all Resolutions !
_dxDrawRectangle = dxDrawRectangle
_dxDrawText = dxDrawText
function dxDrawRectangle(x,y,w,h,...)
	local x = s[1]*(x)/C_Creator_ScreenWidth
	local y = s[2]*(y)/C_Creator_ScreenHeight
	local w = s[1]*(w)/C_Creator_ScreenWidth
	local h = s[2]*(h)/C_Creator_ScreenHeight
	return _dxDrawRectangle(x,y,w,h,...)
end
function dxDrawText(text,x,y,w,h,...)
	local x = s[1]*(x)/C_Creator_ScreenWidth
	local y = s[2]*(y)/C_Creator_ScreenHeight
	local w = s[1]*(w)/C_Creator_ScreenWidth
	local h = s[2]*(h)/C_Creator_ScreenHeight
	return _dxDrawText(text,x,y,w,h,...)
end
--\\
--// Syncing the Fucking money 
setTimer(function ()
setElementData(localPlayer,"money",getPlayerMoney())

end,1000,0)

--\\
		
magazines = {
		[22]=17,
		[23]=17,
		[24]=7,
		[25]=1,
		[26]=2,
		[27]=7,
		[28]=50,
		[29]=30,
		[30]=30,
		[31]=50,
		[32]=50,
		[33]=1,
		[34]=1,
		[35]=1,
		[36]=1,
		[37]=50,
		[38]=500,
		[41]=500,
		[42]=500,
		[43]=36,
}

--// Createds rTargets
local rTarget = {}
rTarget[localPlayer] = {}

rTarget[localPlayer]["ammo"] = dxCreateRenderTarget(s[1]*(400)/C_Creator_ScreenWidth, s[2]*(400)/C_Creator_ScreenHeight,true)
rTarget[localPlayer]["health"] = dxCreateRenderTarget(s[1]*(400)/C_Creator_ScreenWidth, s[2]*(400)/C_Creator_ScreenHeight,true)
rTarget[localPlayer]["Money"] = dxCreateRenderTarget(s[1]*(400)/C_Creator_ScreenWidth, s[2]*(400)/C_Creator_ScreenHeight,true)

addEventHandler("onClientHUDRender",getRootElement(),
	function ()
	for index,player in ipairs(getElementsByType("player")) do
			if not isElementStreamedIn (player) then return end
			if getElementDimension(player) ~= getElementDimension(localPlayer) then return end
			if getElementInterior(player) ~= getElementInterior(localPlayer) then return end
			
			
	if not rTarget[player] then
		rTarget[player] = {}
			rTarget[player]["ammo"] = dxCreateRenderTarget(s[1]*(400)/C_Creator_ScreenWidth,s[2]*(400)/C_Creator_ScreenHeight,true)
			rTarget[player]["health"] = dxCreateRenderTarget(s[1]*(400)/C_Creator_ScreenWidth, s[2]*(400)/C_Creator_ScreenHeight,true)
			rTarget[player]["Money"] = dxCreateRenderTarget(s[1]*(400)/C_Creator_ScreenWidth, s[2]*(400)/C_Creator_ScreenHeight,true)
	end
	
	
	-- // Total Ammo and Ammo for rTarget["ammo"]
	ammo = getPedAmmoInClip(player)
	atammo = getPedTotalAmmo(player)
		if magazines[getPedWeapon(player)] then
			tammo = math.floor((atammo-ammo)/magazines[getPedWeapon(player)])
			-- // Updates the rTarget Ammo with the Informations from above
			dxSetRenderTarget ( rTarget[player]["ammo"],true )
			if drawboxes then
			--// Draws the Borders around the Ammo 
			local bbox = 0
			for i=0,75,2 do
			bbox = bbox +1
			if bbox == 1	then
				
				dxDrawRectangle(160,143+i,80,2,tocolor(0,0,0,150))
			else
				bbox = 0
			end
			end			
			
			
			dxDrawRectangle(160,140,5,80,tocolor(0,242,236,150))
			dxDrawRectangle(160+5,140,15,5,tocolor(0,242,236,150))
			dxDrawRectangle(160+5,140+75,15,5,tocolor(0,242,236,150))
			
			dxDrawRectangle(160+75,140,5,80,tocolor(0,242,236,150))
			dxDrawRectangle(160+60,140,15,5,tocolor(0,242,236,150))
			dxDrawRectangle(160+60,140+75,15,5,tocolor(0,242,236,150))
			--\\
			end
				dxDrawTextBordered (ammo,200,170,200,170,tocolor(255,255,255,255),4,"default","center", "center")
				if atammo > 9999 then tammo = "∞" end
				dxDrawTextBordered (tammo, 200,200,200,200,tocolor(255,255,255,255),2,"default","center", "center")
			dxSetRenderTarget ()
		end
		
		dxSetRenderTarget (rTarget[player]["health"],true )
					if drawboxes then
			--// Draws the Borders around the Ammo 
			local bbox = 0
			for i=0,75,2 do
			bbox = bbox +1
			if bbox == 1	then
				
				dxDrawRectangle(150,(133+i),100,2,tocolor(0,0,0,150))
			else
				bbox = 0
			end
			end			
			
			
			dxDrawRectangle(150,130,5,80,tocolor(0,242,236,150))
			dxDrawRectangle(150+5,130,15,5,tocolor(0,242,236,150))
			dxDrawRectangle(150+5,130+75,15,5,tocolor(0,242,236,150))
			
			dxDrawRectangle(150+95,130,5,80,tocolor(0,242,236,150))
			dxDrawRectangle(150+80,130,15,5,tocolor(0,242,236,150))
			dxDrawRectangle(150+80,130+75,15,5,tocolor(0,242,236,150))
			--\\
			end
		
			dxDrawTextBordered (math.floor(getElementHealth(player)), 200,160,200,160,tocolor(200,0,0,255),4,"default","center", "center")
			dxDrawTextBordered (math.floor(getPedArmor(player)), 200,190,200,190,tocolor(150,150,150,255),1.5,"default","center", "center")
		dxSetRenderTarget ()

		dxSetRenderTarget ( rTarget[player]["Money"],true )
			dxDrawTextBordered ("$"..math.floor(getElementData(player,"money")), 200,160,200,160,tocolor(0,200,0,255),4,"default","center", "center")
		dxSetRenderTarget ()	

		--// Finds Positions for the rTarget Ammo
			if offsetboneAmmo ~= "muzzle" then
				sx,sy,z = getPedBonePosition(player,offsetboneAmmo)
			else
				sx,sy,z = getPedWeaponMuzzlePosition(player)
			end
			
			local rz = getPedRotation(player)
			x1,y1 = findrotation (sx,sy,rz,offsetdistAmmo1,rotoffsetAmmo1)
			x,y = findrotation (x1,y1,rz,offsetdistAmmo2,rotoffsetAmmo2)
		--// Draws Ammo rTarget
			if drawammo then
				if magazines[getPedWeapon(player)] then
					dxDrawMaterialLine3D ( x1,y1,z+zoffsetAmmo+0.5,x1,y1,z+zoffsetAmmo-0.5,rTarget[player]["ammo"], 1, tocolor(255,255,255,255),x,y,z)
				end
			end
	--// for Testing 
		if debug then
			dxDrawLine3D(sx,sy,z,x1,y1,z+zoffsetAmmo)
			dxDrawLine3D(x1,y1,z+zoffsetAmmo,x,y,z+zoffsetAmmo)
		end
		
		--// Finds Positions for the rTarget Health
			local sx,sy,z = getPedBonePosition(player,offsetboneHealth)
			local rz = getPedRotation(player)
			x1,y1 = findrotation (sx,sy,rz,offsetdistHealth1,rotoffsetHealth1)
			x,y = findrotation (x1,y1,rz,offsetdistHealth2,rotoffsetHealth2)
				--// Draws health rTarget
				if drawhp then
					dxDrawMaterialLine3D ( x1,y1,z+zoffsetHealth+0.5,x1,y1,z+zoffsetHealth-0.5,rTarget[player]["health"], 1, tocolor(255,255,255,255),x,y,z)
				end
			--// for Testing 
				if debug then
					dxDrawLine3D(sx,sy,z,x1,y1,z+zoffsetHealth)
					dxDrawLine3D(x1,y1,z+zoffsetHealth,x,y,z+zoffsetHealth)
				end
				
		--// Finds Positions for the rTarget Money
			local sx,sy,z = getPedBonePosition(player,offsetboneMoney)
			local rz = getPedRotation(player)
			x1,y1 = findrotation (sx,sy,rz,offsetdistMoney1,rotoffsetMoney1)
			x,y = findrotation (x1,y1,rz,offsetdistMoney2,rotoffsetMoney2)
				--// Draws Money rTarget
				if drawmoney then
					dxDrawMaterialLine3D ( x1,y1,z+zoffsetMoney+0.5,x1,y1,z+zoffsetMoney-0.5,rTarget[player]["Money"], 1, tocolor(255,255,255,255),x,y,z)
				end
				--// for Testing 
				if debug then
					dxDrawLine3D(sx,sy,z,x1,y1,z+zoffsetMoney)
					dxDrawLine3D(x1,y1,z+zoffsetMoney,x,y,z+zoffsetMoney)
				end
	end
end)


