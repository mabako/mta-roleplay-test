local fuel = 100
local fuellessVehicle = {
	[594]=true, [537]=true, [538]=true, [569]=true, [590]=true, [606]=true, [607]=true, [610]=true, [590]=true,
	[569]=true, [611]=true, [584]=true, [608]=true, [435]=true, [450]=true, [591]=true, [472]=true, [473]=true,
	[493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [497]=true,
	[592]=true, [577]=true, [511]=true, [548]=true, [512]=true, [593]=true, [425]=true, [520]=true, [417]=true,
	[487]=true, [553]=true, [488]=true, [563]=true, [476]=true, [447]=true, [519]=true, [460]=true, [469]=true,
	[513]=true, [509]=true, [510]=true, [481]=true }

function syncFuel(ifuel)
	if not (ifuel) then
		fuel = 100
	else
		fuel = ifuel
	end
end
addEvent("syncFuel", true)
addEventHandler("syncFuel", getRootElement(), syncFuel)



local clr = tocolor(0, 255, 0)
local clr2 = tocolor(0, 255, 0)
local clrWhite = tocolor(255,255,255,223)
local clrGrey = tocolor(191,191,191,191)
local clrRed = tocolor(255,0,0,191)
local clrOrange = tocolor(255,165,0,223)

local resolutionFactor = guiGetScreenSize()/720 --4
local borderSize = 0.5

local drawing = false
local veh = false
local speed = false
local renderTarget = false
local minX = 2
local scrnX, scrnY = guiGetScreenSize()
local twoDMode = false

addEventHandler("onClientVehicleEnter", root,
function(player, seat)
	if player == localPlayer and isElement(source) then --and getVehicleType(source) ~= "Plane" then
		toggleSpeed(true)
	end
end)

addEventHandler("onClientVehicleExit", root,
function(player, seat)
	if player == localPlayer and isElement(source) then
		toggleSpeed(false)
	end
end)

function toggleSpeed(setTo)
	drawing = setTo
	veh = getPedOccupiedVehicle(localPlayer)
	if setTo then
		minX = getElementBoundingBox(veh)
		i = 15
		if not isElement(renderTarget) then renderTarget = dxCreateRenderTarget(232 * resolutionFactor, 102 * resolutionFactor, true) end
		addEventHandler("onClientPreRender", root, drawSpeed)
	end
end

local function isExceedingSpeedLimit(speed)
	local limit = getElementData(localPlayer, 'speedo:limit')
	return limit and speed > limit + 5
end

function drawSpeed()
	if drawing and isElement(veh) and getPedOccupiedVehicle(localPlayer) == veh then	
		dxSetRenderTarget(renderTarget, true)

		local speed = exports.global:getVehicleVelocity(veh)
		local str = math.floor(speed) .. "km/h"
		dxDrawBorderedText(str, 0, 0, 230 * resolutionFactor, 90 * resolutionFactor, isExceedingSpeedLimit(speed) and clrOrange or clrWhite, 4 * resolutionFactor, "default", "right", "bottom", true)
		
		if not fuellessVehicle[getElementModel(veh)] then
			local fuel = math.max(0, math.min(1, fuel/100))
			--dxDrawLine((10 * resolutionFactor) - (2 * borderSize), 95 * resolutionFactor, 229 * resolutionFactor + (2 * borderSize), 95 * resolutionFactor, tocolor(0, 0, 0), (8 * resolutionFactor) + (4 * borderSize))
			dxDrawLine(10 * resolutionFactor, 95 * resolutionFactor, 229 * resolutionFactor, 95 * resolutionFactor, fuel < .1 and clrRed or clrGrey, 8 * resolutionFactor)
			dxDrawLine(10 * resolutionFactor, 95 * resolutionFactor, (fuel * 219 + 10) * resolutionFactor, 95 * resolutionFactor, clrWhite, 8 * resolutionFactor)
		end

		-- le street name
		local street = getElementData(localPlayer, 'speedo:street')
		if street and getVehicleType(veh) ~= "Boat" and getVehicleType(veh) ~= "Helicopter" and getVehicleType(veh) ~= "Plane" then
			dxDrawBorderedText(street, 0, 10 * resolutionFactor, 230 * resolutionFactor, 40 * resolutionFactor, clrWhite, 1.5 * resolutionFactor, "default", "right", "top", true)
		end
		
		dxSetRenderTarget()

		if renderTarget then
			if twoDMode then
				dxDrawImage(scrnX-270, scrnY-130, 230, 100, renderTarget)
			else
				x,y,z,lx,ly,lz,x2,y2,z2 = getPositionFromElementOffset(minX-1.3,0,minX+0.5,-5)	---2.5,0,-1.3,-5
				dxDrawMaterialLine3D(x2,y2,z2,x,y,z, renderTarget, 2.2, clrWhite,lx,ly,lz)
			end
		end
	else
		removeEventHandler("onClientPreRender", root, drawSpeed)
	end
end

function getPositionFromElementOffset(offX,offY,offX2,offY2)
	local offZ = -0.5
	local m = getElementMatrix ( veh )  -- Get the matrix
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	
	local x2 = offX2 * m[1][1] + offY2 * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
	local y2 = offX2 * m[1][2] + offY2 * m[2][2] + offZ * m[3][2] + m[4][2]
	local z2 = offX2 * m[1][3] + offY2 * m[2][3] + offZ * m[3][3] + m[4][3]
	
	offZ = 0.5
	local x3 = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
	local y3 = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z3 = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	
	return x, y, z, x2, y2, z2, x3, y3, z3                            -- Return the transformed point
end

addCommandHandler("speedotype", function() twoDMode = not twoDMode end)

function dxDrawBorderedText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak,postGUI)
    for oX = -borderSize, borderSize do
        for oY = -borderSize, borderSize do
            dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak,postGUI)
        end
    end
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
end

if getPedOccupiedVehicle(localPlayer) then toggleSpeed(true) end