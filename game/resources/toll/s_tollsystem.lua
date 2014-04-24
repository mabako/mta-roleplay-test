local tollElements = { }
local tollElementsName = { }
local tollElementsLocked = { }
function startSystem()
	for key, group in ipairs(tollPorts) do
		tollElements[key] = { }
		tollElementsName[key] = group.name
		tollElementsLocked[key] = false
		for dataKey, dataGroup in ipairs (group.data) do
			local pedName = "Unnamed Person"
			local skinID = math.random(1, 2)
			if #pedMaleNames == 0 then
				skinID = 1
			elseif #pedFemaleNames == 0 then
				skinID = 2
			end
			local array = skinID == 1 and pedFemaleNames or pedMaleNames
			local k = math.random(1, #array)
			pedName = array[k]
			table.remove(array, k)

			if skinID == 1 then 
				skinID = 211 
			else 
				skinID = 71 
			end
			
			
			tollElements[key][dataKey] = { }
			
			tollElements[key][dataKey]["object"] = createObject(968,dataGroup.barrierClosed[1],dataGroup.barrierClosed[2],dataGroup.barrierClosed[3],dataGroup.barrierClosed[4],dataGroup.barrierClosed[5],dataGroup.barrierClosed[6])
			
			tollElements[key][dataKey]["ped"] = createPed(skinID, dataGroup.ped[1], dataGroup.ped[2], dataGroup.ped[3])
			setPedRotation(tollElements[key][dataKey]["ped"], dataGroup.ped[4])
			setElementFrozen(tollElements[key][dataKey]["ped"], true)
			exports['anticheat-system']:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "talk",1, true)
			exports['anticheat-system']:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "name", pedName:gsub("_", " "), true)
			exports['anticheat-system']:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "ped:name", pedName, true)
			exports['anticheat-system']:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "ped:type", "toll", true)
			exports['anticheat-system']:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "ped:tollped",true, true)
			
			exports['anticheat-system']:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "languages.lang1" , 1, false)
			exports['anticheat-system']:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "languages.lang1skill", 100, false)
			exports['anticheat-system']:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "languages.lang2" , 2, false)
			exports['anticheat-system']:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "languages.lang2skill", 100, false)
			exports['anticheat-system']:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "languages.current", 1, false)	
			exports['anticheat-system']:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "toll:object", tollElements[key][dataKey]["object"], false)	
			exports['anticheat-system']:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "toll:data", dataGroup, false)	
			exports['anticheat-system']:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "toll:busy", false, false)	
			exports['anticheat-system']:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "toll:state", false, false)	
			exports['anticheat-system']:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "toll:name", group.name, false)	
			exports['anticheat-system']:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "toll:key", key, false)	
					
			--
			-- Toll Pass
			--
			local x, y, z = dataGroup.ped[1], dataGroup.ped[2], dataGroup.ped[3]
			local r = dataGroup.ped[4]
			x = x - math.sin(math.rad(r)) * 2.5
			z = z + math.cos(math.rad(r)) * 2.5
			
			local col = createColSphere(x, y, z, 5)
			addEventHandler("onColShapeHit", col,
				function( thePlayer, match )
					if match and getElementType(thePlayer) == "player" and getPedOccupiedVehicle(thePlayer) and getPedOccupiedVehicleSeat(thePlayer) == 0 then
						local thePed = getElementData(source, "toll:ped")
						local tollKey = getElementData(thePed, "toll:key")
						processOpenTolls(tollKey, thePed, thePlayer, true)
					end
				end
			)
			exports['anticheat-system']:changeProtectedElementDataEx(col, "toll:ped", tollElements[key][dataKey]["ped"], false)
		end
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), startSystem)

function triggerGate(gateKeeperPed, secondtime, sourceElement, timeout)
	local isGateBusy = getElementData(gateKeeperPed, "toll:busy")
	
	local tollData = getElementData(gateKeeperPed, "toll:data")
	local tollObject = getElementData(gateKeeperPed, "toll:object")
	if not (isGateBusy) or (secondtime) then
		exports['anticheat-system']:changeProtectedElementDataEx(gateKeeperPed, "toll:busy", true, false)
		local newX, newY, newZ, offsetRX, offsetRY, offsetRZ
		
		local gateState = getElementData(gateKeeperPed, "toll:state") 
		if gateState then -- its opened, close it
			newX = tollData.barrierClosed[1]
			newY = tollData.barrierClosed[2]
			newZ = tollData.barrierClosed[3]
			offsetRX = tollData.barrierOpen[4] - tollData.barrierClosed[4]
			offsetRY = tollData.barrierOpen[5] - tollData.barrierClosed[5]  
			offsetRZ = tollData.barrierOpen[6] - tollData.barrierClosed[6]
			gateState = false
		else -- its closed, open it
			newX = tollData.barrierOpen[1]
			newY = tollData.barrierOpen[2]
			newZ = tollData.barrierOpen[3]
			offsetRX = tollData.barrierClosed[4] - tollData.barrierOpen[4]
			offsetRY = tollData.barrierClosed[5] - tollData.barrierOpen[5]  
			offsetRZ = tollData.barrierClosed[6] - tollData.barrierOpen[6]
			gateState = true
		end
		
		offsetRX = fixRotation(offsetRX)
		offsetRY = fixRotation(offsetRY)
		offsetRZ = fixRotation(offsetRZ)
		
		exports['anticheat-system']:changeProtectedElementDataEx(gateKeeperPed, "toll:state", gateState, false)
		moveObject ( tollObject, 1500, newX, newY, newZ, offsetRX, offsetRY, offsetRZ )

		if (secondtime) then
			--exports['anticheat-system']:changeProtectedElementDataEx(gateKeeperPed, "toll:busy", false, false)
			setTimer(resetBusyState, 2000, 1, gateKeeperPed)
		else
			setTimer(triggerGate, timeout or 6500, 1, gateKeeperPed, true, sourceElement)
		end
	end
end

--- PEDS
function startTalkToPed ()
	thePed = source
	thePlayer = client
	
	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ) <= 7) then
		return
	end
	
	if (isPedInVehicle(thePlayer)) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if (exports['vehicle-system']:isVehicleWindowUp(theVehicle)) then
			outputChatBox("You might want to lower your window first, before talking to anyone outside the vehicle.", thePlayer, 255,0,0)
			return
		end
	end
	
	local isGateBusy = getElementData(thePed, "toll:busy")
	if (isGateBusy) then
		processMessage(thePed, "Mh..")
		return
	end

	processMessage(thePed, "Hey, want to pass? That'll be six dollars please.")
	setConvoState(thePlayer, 1)
	local responseArray = { "Yes please.", "No thanks." }
	triggerClientEvent(thePlayer, "toll:interact", thePed, responseArray)
end
addEvent( "toll:startConvo", true )
addEventHandler( "toll:startConvo", getRootElement(), startTalkToPed )



function processOpenTolls(tollKey, thePed, thePlayer, payByBank)
	if not tollElementsLocked[tollKey] or exports.global:hasItem(thePlayer, 64) or exports.global:hasItem(thePlayer, 65) or exports.global:hasItem(thePlayer, 112) then
		if payByBank then
			if not exports.global:hasItem(getPedOccupiedVehicle(thePlayer), 118) then
				return -- Has no Toll Pass
			end
			
			local money = getElementData(thePlayer, "bankmoney") - 5
			if money >= 0 then
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "bankmoney", money, false)
				exports.mysql:query_free("UPDATE characters SET bankmoney=bankmoney-5 WHERE id=" .. exports.mysql:escape_string(getElementData( thePlayer, "dbid" )))
				outputChatBox("[Toll Pass] Your bank account has been billed $5.", thePlayer, 0, 255, 0)
			else
				return "Not enough money on your bank account."
			end
		else
			if not exports.global:takeMoney(thePlayer, 6) then
				return "I'm sorry, but I can't let you through then if you can't pay it."
			end
		end

		triggerGate(thePed, false, thePlayer)
		exports.global:giveMoney( getTeamFromName("Government of Los Santos"), 1 )
		
		exports.global:giveMoney( getTeamFromName("Los Santos Police Department"), 2 )
		exports.global:giveMoney( getTeamFromName("State Police"), 2 )
		return "Thanks, there ya go."
	else
		return "Sorry, we've received order to let no-one through."
	end
end

function talkToPed(answer, answerStr)
	thePed = source
	thePlayer = client
	
	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ) <= 7) then
		return
	end
	
	local convState = getConvoState(thePlayer)
	local currSlot = getElementData(thePlayer, "languages.current")
	local currLang = getElementData(thePlayer, "languages.lang" .. currSlot)
	processMessage(thePlayer, answerStr, currLang)
	if (convState == 1) then --  "Hey, want to pass? That'll be six dollar please."
		local languageSkill = exports['language-system']:getSkillFromLanguage(thePlayer, 1)
		if (languageSkill < 60) or (currLang ~= 1) then
			processMessage(thePed, "Wow dude, I can't understand a shit of it.")
			setConvoState(thePlayer, 0)
			return
		end		
	
		if (answer == 1) then -- "Yes please."
			local placeName = getElementData(thePed, "toll:name")
			local isBusy = getElementData(thePed, "toll:busy")
			if not isBusy then
				local tollKey = getElementData(thePed, "toll:key")
				processMessage(thePed, processOpenTolls(tollKey, thePed, thePlayer, false))
			end
			setConvoState(thePlayer, 0)
		elseif (answer == 2) then -- "No thanks."
			processMessage(thePed, "Okay, fine...")
			setConvoState(thePlayer, 0)
		end
	end
end
addEvent( "toll:interact", true )
addEventHandler( "toll:interact", getRootElement(), talkToPed )

function testToggle(thePlayer, commandName, gateID, silent)
	local factionID = getElementData(thePlayer, "faction")
	if factionID ~= 1 and factionID ~= 87 and not exports.global:isPlayerAdmin(thePlayer) then
		return
	end
	
	if not gateID or not tonumber(gateID) then
		outputChatBox("Syntax: /"..commandName.." [ID]", thePlayer)
		--return ]]
		for tollID, tollName in ipairs(tollElementsName) do
			local state = "open"
			if tollElementsLocked[tollID] then
				state = "locked"
			end
			outputChatBox(" "..tostring(tollID).. " - "..tollName .." - State: "..state, thePlayer)
		end
		return
	end
	gateID = tonumber(gateID)
	
	if not tollElementsName[gateID] then
		outputChatBox("Does not exists.", thePlayer)
	end	
	
	tollElementsLocked[gateID] = not tollElementsLocked[gateID]
	if tollElementsLocked[gateID] then
		local first = true
		exports['chat-system']:departmentradio(thePlayer, "d", "Please lock down the "..tollElementsName[gateID].." tolls, how copy?, over.")
		for _, thePed in ipairs(getElementsByType('ped')) do
			local tollKey = getElementData(thePed, "toll:key")
			if tollKey and tollKey == gateID then
				if first then
					exports['chat-system']:departmentradio(thePed, "d", "10-4, locking down "..tollElementsName[gateID]..", out.")
					first = false
				end
				processRadio(thePed, "Comms to the units at "..tollElementsName[gateID]..", don't let anyone through, out!", thePed)
			end
		end
	else
		local first = true
		exports['chat-system']:departmentradio(thePlayer, "d", "Please open the "..tollElementsName[gateID].." tolls, how copy?, over.")
		for _, thePed in ipairs(getElementsByType('ped')) do
			local tollKey = getElementData(thePed, "toll:key")
			if tollKey and tollKey == gateID then
				if first then
					exports['chat-system']:departmentradio(thePed, "d", "10-4, opening up "..tollElementsName[gateID]..", out.")
					first = false
				end
				processRadio(thePed, "Comms to the units at "..tollElementsName[gateID]..", open the toll booth again, out!", thePed)
			end
		end
	end
end
addCommandHandler("tolllock", testToggle)

--- Functions
function getConvoState(thePlayer)
	return getElementData(thePlayer, "toll:convoState", state) or 0
end

function setConvoState(thePlayer, state)
	exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "toll:convoState", state, false)
end

function processMessage(thePed, message, language)
	if not (language) then
		language = 1
	end
	exports['chat-system']:localIC(thePed, message, language)
end

function processRadio(thePed, message, source)
	local name = getElementData(thePed, "name") or getPlayerName(thePed)
	exports['global']:sendLocalText(source, "[English] " .. name .. "'s Radio: "..message, 255, 255, 255)
end

function processMeMessage(thePed, message, source)
	local name = getElementData(thePed, "name") or getPlayerName(thePed)
	exports['global']:sendLocalText(source, " *" ..  string.gsub(name, "_", " ").. ( message:sub( 1, 1 ) == "'" and "" or " " ) .. message, 255, 51, 102)
end

function processDoMessage(thePed, message, source)
	local name = getElementData(thePed, "name") or getPlayerName(thePed)
	exports['global']:sendLocalText(source, " * " .. message .. " *      ((" .. name:gsub("_", " ") .. "))", 255, 51, 102)
end

function fixRotation(value)
	local invert = false
	if value < 0 then
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

	return value
end

function resetBusyState(theGate)
	local isGateBusy = getElementData(theGate, "toll:busy")
	if (isGateBusy) then
		exports['anticheat-system']:changeProtectedElementDataEx(theGate, "toll:busy", false, false)
	end
end

function tollCommand(thePlayer)
	local duty = tonumber(getElementData(thePlayer, "duty")) or 0
	if duty > 0 and getElementDimension( thePlayer ) == 0 then
		-- find nearby gates
		local x, y, z = getElementPosition( thePlayer )
		local any = false
		for key, value in ipairs( tollElements ) do
			local name
			for k, v in ipairs( value ) do
				local ped = v.ped
				if ped then
					if getDistanceBetweenPoints3D( x, y, z, getElementPosition( ped ) ) < 100 then
						name = getElementData( ped, "toll:name" )
						break
					end
				end
			end
			
			if name then
				outputChatBox( "Opening " .. name .. " toll gates.", thePlayer, 0, 255, 0 )
				for k, v in ipairs(value) do
					if v.ped then
						exports.logs:dbLog(thePlayer, 35, v.ped, "TOLL OPEN " .. name)
						triggerGate(v.ped, false, thePlayer, 15000)
						any = true
					end
				end
			end
		end
		
		if not any then
			outputChatBox("You are not near any toll gates.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("toll", tollCommand)
