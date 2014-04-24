mysql = exports.mysql
gates = { }

function newGate(thePlayer, commandName, itemID)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not itemID or not tonumber(itemID) then
			outputChatBox("Syntax: /"..commandName.." <itemID>", thePlayer)
			return
		end
		local playerX, playerY, playerZ = getElementPosition(thePlayer)
		
		local tempObject = createObject(itemID, playerX, playerY, playerZ, 0, 0, 0)
		if tempObject then
			local tempTable = { }
			tempTable["startPosition"] = { playerX, playerY, playerZ, 0, 0, 0 }
			tempTable["endPosition"] = { playerX, playerY, playerZ, 0, 0, 0 }
			tempTable["state"] = false -- false is closed, true is opened
			tempTable["timer"] = false
			tempTable["type"] = 1
			tempTable["autocloseTime"] = -1
			tempTable["movementTime"] = 3500
			tempTable["gateSecurityParameters"] = ""
			exports['anticheat-system']:changeProtectedElementDataEx(tempObject, "gate:parameters", tempTable, false)
			exports['anticheat-system']:changeProtectedElementDataEx(tempObject, "gate:id", -1, false)
			exports['anticheat-system']:changeProtectedElementDataEx(tempObject, "gate:edit", true, false)
			table.insert(gates, tempObject)
			triggerClientEvent(thePlayer, "gates:startedit", thePlayer, tempObject, tempTable, -1)
		else
			outputChatBox("Failed to spawn object", thePlayer, 255, 0,0)
		end
	end
end
addCommandHandler("newgate", newGate)

function cancelGateEdit()
	if source then
		if isElement(source) then
			local dbid = getElementData(source, "gate:id")
			if dbid and dbid == -1 then
				destroyElement(source)
			end
			outputChatBox("Edit cancelled", client, 255, 0,0)
		end
	end
end
addEvent("gates:canceledit", true)
addEventHandler("gates:canceledit", getRootElement(), cancelGateEdit)

function startGateSystem(res)
	local result = mysql:query("SELECT `id` FROM `gates` ORDER BY `id` ASC")
	if (result) then
		while true do
			row = mysql:fetch_assoc(result)
			if not row then break end

			local co = coroutine.create(loadOneGate)
			coroutine.resume(co, tonumber(row.id), false)
		end
	end
	mysql:free_result(result)
end
addEventHandler("onResourceStart", getResourceRootElement(), startGateSystem)

function loadOneGate(gateID)
	local row = mysql:query_fetch_assoc("SELECT * FROM `gates` WHERE `id`='"..tostring(gateID).."'")
	if row then
		local tempObject = createObject(row["objectID"], row["startX"], row["startY"], row["startZ"], row["startRX"], row["startRY"], row["startRZ"])
		if tempObject then
			local tempTable = { }
			tempTable["startPosition"] = { tonumber(row["startX"]), tonumber(row["startY"]), tonumber(row["startZ"]), tonumber(row["startRX"]), tonumber(row["startRY"]), tonumber(row["startRZ"]) }
			tempTable["endPosition"] = { tonumber(row["endX"]), tonumber(row["endY"]), tonumber(row["endZ"]), tonumber(row["endRX"]), tonumber(row["endRY"]), tonumber(row["endRZ"]) }
			tempTable["state"] = false -- false is closed, true is opened
			tempTable["timer"] = false
			tempTable["type"] = tonumber(row["gateType"])
			tempTable["autocloseTime"] = tonumber(row["autocloseTime"])
			tempTable["movementTime"] = tonumber(row["movementTime"])
			tempTable["gateSecurityParameters"] = row["gateSecurityParameters"]
			exports['anticheat-system']:changeProtectedElementDataEx(tempObject, "gate:parameters", tempTable, false)
			exports['anticheat-system']:changeProtectedElementDataEx(tempObject, "gate:id", row["id"], false)
			exports['anticheat-system']:changeProtectedElementDataEx(tempObject, "gate:edit", false, false)
			exports['anticheat-system']:changeProtectedElementDataEx(tempObject, "gate:busy", false, false)
			exports['anticheat-system']:changeProtectedElementDataEx(tempObject, "gate", true, true)
			setElementDimension(tempObject, tonumber(row["objectDimension"]))
			setElementInterior(tempObject, tonumber(row["objectInterior"]))
			table.insert(gates, tempObject)
		end
	end
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