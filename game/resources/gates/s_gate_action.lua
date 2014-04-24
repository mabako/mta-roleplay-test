addEvent("gate:trigger", true)
function triggerGate()
	if not source or not client then
		return
	end
	
	local isGate = getElementData(source, "gate")
	if not isGate then
		return
	end
	local playerX, playerY, playerZ = getElementPosition(client)		
	local gateX, gateY, gateZ = getElementPosition(source)		
	local reachedit = false
	if ( getDistanceBetweenPoints3D(playerX, playerY, playerZ, gateX, gateY, gateZ) <= 5 ) then
		reachedit = true
	end
	if ( isPedInVehicle (client) and getDistanceBetweenPoints3D(playerX, playerY, playerZ, gateX, gateY, gateZ) <= 25 ) then
		reachedit = true
	end
	if reachedit then
		local isGateBusy = getElementData(source, "gate:busy")
		if not (isGateBusy) then
			local gateType = getProtectionType(source)
			if (gateType == 1 or gateType == 3 or gateType == 4 or gateType == 5) then
				-- Doesn't need players input
				if (canPlayerControlGate(source, client)) then
					moveGate(source)
				else
					outputChatBox("You're unable to open this door, it seems to be locked.", client, 255, 0, 0)
				end
			end
		end
	end
end
addEventHandler("gate:trigger", getRootElement(), triggerGate)

function moveGate(theGate, secondtime)
	if not secondtime then
		secondtime = false
	end
	local isGateBusy = getElementData(theGate, "gate:busy")
	if not (isGateBusy) or (secondtime) then
		exports['anticheat-system']:changeProtectedElementDataEx(theGate, "gate:busy", true, false)
		local gateParameters = getElementData(theGate, "gate:parameters")
		
		local newX, newY, newZ, offsetRX, offsetRY, offsetRZ, movementTime, autocloseTime
		
		local startPosition = gateParameters["startPosition"]
		local endPosition = gateParameters["endPosition"]
		
		if gateParameters["state"] then -- its opened, close it
			newX = startPosition[1]
			newY = startPosition[2]
			newZ = startPosition[3]
			offsetRX = endPosition[4] - startPosition[4] 
			offsetRY = endPosition[5] - startPosition[5] 
			offsetRZ = endPosition[6] - startPosition[6] 
			gateParameters["state"] = false1
			gateParameters["state"] = false
		else -- its closed, open it
			newX = endPosition[1]
			newY = endPosition[2]
			newZ = endPosition[3]
			offsetRX = startPosition[4] - endPosition[4] 
			offsetRY = startPosition[5] - endPosition[5] 
			offsetRZ = startPosition[6] - endPosition[6] 
			gateParameters["state"] = true
		end

		movementTime = gateParameters["movementTime"] * 100

		offsetRX = fixRotation(offsetRX)
		offsetRY = fixRotation(offsetRY)
		offsetRZ = fixRotation(offsetRZ)
		
		moveObject ( theGate, movementTime, newX, newY, newZ, offsetRX, offsetRY, offsetRZ )
		
		
		if (not secondtime) and (gateParameters["autocloseTime"] ~= 0) then
			autocloseTime = tonumber(gateParameters["autocloseTime"])*100
			gateParameters["timer"] = setTimer(moveGate, movementTime+autocloseTime, 1, theGate, true)
		else
			setTimer(resetBusyState, movementTime, 1, theGate)
		end
		exports['anticheat-system']:changeProtectedElementDataEx(theGate, "gate:parameters", gateParameters, false)
	end
end

function fixRotation(value)
	local invert = false
	if value < 0 then
		--invert = true
		--value = value - value - value
		while value < -360 do
			value = value + 360
		end
		if value < -180 then
			value = value + 180
			value = value - value - value
		end
	else
		while value > 360 do
			value = value - 360
		end
		if value > 180 then
			value = value - 180
			value = value - value - value
		end
	end
	
	--[[if invert then
		value = 360 - value
	end--]]
	return value
end

function resetBusyState(theGate)
	local isGateBusy = getElementData(theGate, "gate:busy")
	if (isGateBusy) then
		exports['anticheat-system']:changeProtectedElementDataEx(theGate, "gate:busy", false, false)
	end
end

function getProtectionType(theGate)
	local gateParameters = getElementData(theGate, "gate:parameters")
	return tonumber(gateParameters["type"]) or -1
end

function canPlayerControlGate(theGate, thePlayer, password)
	if not password then
		password = ""
	end
	local gateParameters = getElementData(theGate, "gate:parameters")
	local gateProtection = getProtectionType(theGate)
	if gateProtection == 1 then
		return true
	elseif gateProtection == 2 then
		if password == gateParameters["gateSecurityParameters"] then
			return true
		end
	elseif gateProtection == 3 then
		local tempAccess = split(gateParameters["gateSecurityParameters"], " ")
		for _, itemID in ipairs(tempAccess) do
			if (exports.global:hasItem(thePlayer, tonumber(itemID))) then
				return true
			end
		end
		return false
	elseif gateProtection == 4 then
		local tempAccess = split(gateParameters["gateSecurityParameters"], " ")
		local hasItem, slotID, itemValue, databaseID = exports.global:hasItem(thePlayer, tonumber(tempAccess[1]))
		if (hasItem) then
			if string.find(itemValue, tempAccess[2]) then
				return true
			end
		end
	elseif gateProtection == 5 then
		if password == gateParameters["gateSecurityParameters"] then
			return true
		end
	else
		outputDebugString("nothing matched :( "..type(gateProtection) .. " "..tostring(gateProtection))
	end
	
	return false
end

function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end


--[[
Gate types:
1. /gate for everyone
2. /gate for everyone with password
3. /gate with item
4. /gate with item and itemvalue ending on *
5. open with /gate and keypad
6. colsphere trigger
]]