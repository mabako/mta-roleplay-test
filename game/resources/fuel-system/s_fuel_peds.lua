local mysql = exports.mysql
function startTalkToPed ()
	
	thePed = source
	thePlayer = client
	
	
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	
	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ)<=7) then
		return
	end

	if not (isPedInVehicle(thePlayer)) then
		processMessage(thePed, "Hey, what could I do for you?.")
		setConvoState(thePlayer, 3)
		local responseArray = { "Could you fill my fuelcan?", "Eh.. nothing actually", "Do you have a cigarette for me?", "I like your suit." }
		triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
	else
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if (exports['vehicle-system']:isVehicleWindowUp(theVehicle)) then
			outputChatBox("You might want to lower your window first, before talking to anyone outside the vehicle", thePlayer, 255,0,0)
			return
		end
		processMeMessage(thePed, "leans against " .. getPlayerName(thePlayer):gsub("_"," ") .. "'s vehicle.", thePlayer )
		processMessage(thePed, "Hey, how could I help you?")
		setConvoState(thePlayer, 1)
		local responseArray = { "Ehm, fill my tank up, please.", "No thanks.", "Do you have a cigarette for me?", "Stop leaning against my vehicle." }
		triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
	end
end
addEvent( "fuel:startConvo", true )
addEventHandler( "fuel:startConvo", getRootElement(), startTalkToPed )


function talkToPed(answer, answerStr)
	thePed = source
	thePlayer = client
	
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	
	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ) <= 7) then
		return
	end
	
	local convState = getElementData(thePlayer, "ped:convoState")
	local currSlot = getElementData(thePlayer, "languages.current")
	local currLang = getElementData(thePlayer, "languages.lang" .. currSlot)
	processMessage(thePlayer, answerStr, currLang)
	if (convState == 1) then -- "Hey, how could I help you?"
		local languageSkill = exports['language-system']:getSkillFromLanguage(thePlayer, 1)
		if (languageSkill < 60) or (currLang ~= 1) then
			processMessage(thePed, "Wow dude, I can't understand a shit of it.")
			setConvoState(thePlayer, 0)
			return
		end
	
		if (answer == 1) then -- "Ehm, fill my tank up, please."
			if not (isPedInVehicle(thePlayer)) then
				processMessage(thePed, "Ehm...")
				setConvoState(thePlayer, 0)
				return
			end
			processMessage(thePed, "Sure... we could arrange that.")
			local theVehicle = getPedOccupiedVehicle(thePlayer)
			if (getElementData(theVehicle, "engine") == 1) then
				processMessage(thePed, "Could you please turn your engine off?")
				local responseArray = { "Sure, no problemo.", "Can't you do it with the engine running?", "Eh, WHAT?" }
				triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
				setConvoState(thePlayer, 2)
				return
			else
				pedWillFillVehicle(thePlayer, thePed)
			end
		elseif (answer == 2) then -- "No thanks."
			processMessage(thePed, "Okay, fine. Hop by when you need some fuel.")
			setConvoState(thePlayer, 0)
		elseif (answer == 3) then -- "Do you have a sigarette for me?"
			processMessage(thePed, "Uhm, no. You could check the twenty-four seven.")
			setConvoState(thePlayer, 0)
		elseif (answer == 4) then -- stop leaning against my car
			processMessage(thePed, "Okay, okay... Take it easy.")
			processMeMessage(thePed, "pushes himself up again, standing on his feet.", thePlayer )
			processMessage(thePed, "Well, should I fill it up or not?.")
			local responseArray = {  "Go ahead.", "No, not anymore." }
			triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
			setConvoState(thePlayer, 1)
		end
	elseif (convState == 2) then -- "Could you please turn your engine off?"
		if (answer == 1) then -- "Sure, no problemo." / "Ok, okay.."
			if not (isPedInVehicle(thePlayer)) then
				processMessage(thePed, "Ehm...")
				setConvoState(thePlayer, 0)
				return
			end
			processMeMessage(thePlayer, "shuts down the engine.",thePlayer )
			local theVehicle = getPedOccupiedVehicle(thePlayer)
			setElementData(theVehicle, "engine", 0)
			setVehicleEngineState(theVehicle, false)
			pedWillFillVehicle(thePlayer, thePed)
		elseif (answer == 2) then -- "Can't you do it with the engine running?" 
			processMeMessage(thePed, "sighs.",thePlayer )
			processMessage(thePed, "Ehm... no. I don't want to die. So, shutting it off or not?")
			local responseArray = {  "Go ahead.", false, false, "Ugh, shut up then."  }
			triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
			setConvoState(thePlayer, 2)
		elseif (answer == 3) then -- "Eh, WHAT?"
			processMessage(thePed, "I've asked: Could you turn off your engine?")
			local responseArray = {  "Ok, okay..", false,false, "Ugh, no."  }
			triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
			setConvoState(thePlayer, 2)
		elseif answer == 4 then -- "Ugh, shut up then." / "Ugh, no."
			processMessage(thePed, "Okay, okay... Take it easy. Get lost.")
			setConvoState(thePlayer, 0)
		end
	elseif (convState == 3) then
		if answer == 1 then -- Could you fill my fuelcan?
			if (exports.global:hasItem(thePlayer, 57)) then
				processMessage(thePed, "Sure. Lets do it!")
				processMeMessage(thePed, "attaches the hose to the tanker, rolling it out.",thePlayer )
				processMeMessage(thePed, "twists the cap of the fuelcan, hosing in and filling it slowly.",thePlayer )
				setTimer(pedWillFillFuelCan, 3500, 1, thePlayer, thePed)
			else
				processMessage(thePed, "Uhm.. You'll need an fuelcan for this... You can buy one in the twenty-four seven.")
				setConvoState(thePlayer, 0)
			end
		elseif answer == 2 then -- No thanks
			processMessage(thePed, "Okay, have a pleasant day.")
			setConvoState(thePlayer, 0)
		elseif answer == 3 then -- do you have a cigarette for me?
			processMessage(thePed, "Uhm, no. You could check the twenty-four seven.")
			setConvoState(thePlayer, 0)
		elseif answer == 4 then -- I like your suit
			processMessage(thePed, "Eh, thanks... I guess.")
			setConvoState(thePlayer, 0)
		end
	end
end
addEvent( "fuel:convo", true )
addEventHandler( "fuel:convo", getRootElement(), talkToPed )

function pedWillFillFuelCan(thePlayer, thePed)
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ) <= 7) then
		exports['chat-system']:localShout(thePed, "do", "Fine, no fuel for you!")
		return
	end
	
	local hasItem, itemSlot, itemValue, itemUniqueID = exports.global:hasItem(thePlayer, 57)
	if not (hasItem) then
		processMessage(thePed, "Funny...")
		processMeMessage(thePed, "sighs.",thePlayer )
		return
	end
	
	if itemValue >= 10 then
		processMessage(thePed, "Eh... that one is already full.")
		return
	end
	
	local theLitres = 10 - itemValue
		
	local currentTax = exports.global:getTaxAmount()
	local fuelCost = math.floor(theLitres*(FUEL_PRICE + (currentTax*FUEL_PRICE)))
	
	if not (exports.global:takeMoney(thePlayer, fuelCost, true)) then
		processMessage(thePed, "How did you thought about paying this?! Punk!")
		return
	end
	
	if not (exports['item-system']:updateItemValue(thePlayer, itemSlot, itemValue + theLitres)) then
		outputChatBox("Something went wrong, please /report.", thePlayer)
		return
	end
			
	processMeMessage(thePed, "offers the receipt to " .. getPlayerName(thePlayer):gsub("_"," ") .. "." ,thePlayer )	
	processMeMessage(thePlayer, "takes the receipt, and reads it." ,thePlayer )	
	outputChatBox("============================", thePlayer)
	outputChatBox("Gas Station Receipt:", thePlayer)
	outputChatBox("    " .. math.ceil(theLitres) .. " Litres of petrol    -    " .. fuelCost .. "$", thePlayer)
	outputChatBox("============================", thePlayer)
	if (fuelCost > 0) then
		processMeMessage(thePlayer, "hands ".. fuelCost .." dollar(s) to the guy." ,thePlayer )	
	else
		processMeMessage(thePlayer, "nods once while looking at it." ,thePlayer )	
	end
	setTimer(processMessage, 500, 1, thePed, "Thanks! See you next time.")			
end

function pedWillFillVehicle(thePlayer, thePed)
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	processMeMessage(thePed, "attaches the hose to the tanker, rolling it out.",thePlayer )
	processMeMessage(thePed, "opens the fuelhatch of the car, hosing it in and refuelling the car..",thePlayer )
	setTimer(processMessage, 7000, 1, thePed, "Almost done..")
	setTimer(pedWillFuelTheVehicle, 10000, 1, thePlayer, thePed)
end

function pedWillFuelTheVehicle(thePlayer, thePed)
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ) <= 7) then
		exports['chat-system']:localShout(thePed, "do", "HEY IDIOT, WANT TO DIE? ASSHOLE!")
		return
	end
	
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	
	if (getVehicleEngineState(theVehicle)) then
		exports['chat-system']:localShout(thePed, "do", "HEY IDIOT, WANT TO DIE? ASSHOLE!")
		--processDoMessage(thePlayer, "The vehicle explodes", thePlayer)
		--blowVehicle (theVehicle, false )
		return
	end
	
	if not (isPedInVehicle(thePlayer)) then
		processMessage(thePed, "Ehm...")
		setConvoState(thePlayer, 0)
		return
	end
	

		
	local theLitres, free, factionToCharge = calculateFuelPrice(thePlayer, thePed)
	local currentTax = exports.global:getTaxAmount()
	local fuelCost = math.floor(theLitres*(FUEL_PRICE + (currentTax*FUEL_PRICE)))
	if (free) then
		if factionToCharge then
			exports.global:takeMoney(factionToCharge, fuelCost, true)
		end
		fuelCost = 0
	end
	
	exports.global:takeMoney(thePlayer, fuelCost, true)
					
	local loldFuel = getElementData(theVehicle, "fuel")
	local newFuel = loldFuel+theLitres
	exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "fuel", newFuel, false)
	triggerClientEvent(thePlayer, "syncFuel", theVehicle, newFuel)
		
	processMeMessage(thePed, "offers the receipt to " .. getPlayerName(thePlayer):gsub("_"," ") .. "." ,thePlayer )	
	processMeMessage(thePlayer, "takes the receipt, and reads it." ,thePlayer )	
	outputChatBox("============================", thePlayer)
	outputChatBox("Gas Station Receipt:", thePlayer)
	outputChatBox("    " .. math.ceil(theLitres) .. " Litres of petrol    -    " .. fuelCost .. "$", thePlayer)
	outputChatBox("============================", thePlayer)
	if (fuelCost > 0) then
		processMeMessage(thePlayer, "hands ".. fuelCost .." dollar(s) to the guy." ,thePlayer )	
	else
		processMeMessage(thePlayer, "nods once while looking at it." ,thePlayer )	
	end
	setTimer(processMessage, 500, 1, thePed, "Thanks! See you next time.")			
end

function setConvoState(thePlayer, state)
	exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "ped:convoState", state, false)
end

function processMessage(thePed, message, language)
	if not (language) then
		language = 1
	end
	exports['chat-system']:localIC(thePed, message, language)
end

function processMeMessage(thePed, message, source)
	local name = getElementData(thePed, "name") or getPlayerName(thePed)
	exports['global']:sendLocalText(source, " *" ..  string.gsub(name, "_", " ").. ( message:sub( 1, 1 ) == "'" and "" or " " ) .. message, 255, 51, 102)
end

function processDoMessage(thePed, message, source)
	local name = getElementData(thePed, "name") or getPlayerName(thePed)
	exports['global']:sendLocalText(source, " * " .. message .. " *      ((" .. name:gsub("_", " ") .. "))", 255, 51, 102)
end

function calculateFuelPrice(thePlayer, thePed)
	local litresAffordable = MAX_FUEL
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	local currFuel = tonumber(getElementData(theVehicle, "fuel"))
	local faction = getPlayerTeam(thePlayer)
	local ftype = getElementData(faction, "type")
	local fid = getElementData(faction, "id")
	local ratio = getElementData(thePed, "fuel:priceratio") or 100
	local factionToCharge = false
	
	local free = false
	if (ftype~=2) and (ftype~=3) and (ftype~=4) and (fid~=30) and not (exports.donators:hasPlayerPerk(thePlayer, 7)) then
		local money = exports.global:getMoney(thePlayer)
				
		local tax = exports.global:getTaxAmount()
		local cost = FUEL_PRICE + (tax*FUEL_PRICE)
		local cost = (cost / 100) * ratio
		local litresAffordable = math.ceil(money/cost)
			
		if amount and amount <= litresAffordable and amount > 0 then
			litresAffordable = amount
		end
					
		if (litresAffordable>MAX_FUEL) then
			litresAffordable=MAX_FUEL
		end
	else
		if not exports.donators:hasPlayerPerk(thePlayer, 7) then
			factionToCharge = faction
			local tax = exports.global:getTaxAmount()
			local cost = FUEL_PRICE + (tax*FUEL_PRICE)
			local cost = (cost / 100) * ratio
			local litresAffordable=MAX_FUEL
		end
		
		
		free = true
	end
	
	if (litresAffordable+currFuel>MAX_FUEL) then
		litresAffordable = MAX_FUEL - currFuel
	end
	return litresAffordable, free, factionToCharge
end

function createFuelPed(skin, posX, posY, posZ, rotZ, name, priceratio)
	theNewPed = createPed (skin, posX, posY, posZ)
	exports.pool:allocateElement(theNewPed)
	setPedRotation (theNewPed, rotZ)
	setElementFrozen(theNewPed, true)
	--setPedAnimation(theNewPed, "FOOD", "FF_Sit_Loop",  -1, true, false, true)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "talk",1, true)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "name", name:gsub("_", " "), true)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "ped:name", name, true)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "ped:type", "fuel", true)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "ped:fuelped",true, true)
	
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "fuel:priceratio" , priceratio or 100, false)
	
	-- For the language system
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "languages.lang1" , 1, false)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "languages.lang1skill", 100, false)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "languages.lang2" , 2, false)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "languages.lang2skill", 100, false)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "languages.current", 1, false)	
	createBlip(posX, posY, posZ, 55, 2, 255, 0, 0, 255, 0, 300)
	return theNewPed
end
function onServerStart()
	local sqlHandler = mysql:query("SELECT * FROM fuelpeds")
	if (sqlHandler) then
		while true do
			local row = mysql:fetch_assoc( sqlHandler )
			if not row then break end
			
			createFuelPed(tonumber(row["skin"]),tonumber(row["posX"]),tonumber(row["posY"]),tonumber(row["posZ"]), tonumber(row["rotZ"]), row["name"],tonumber(row["priceratio"]))
		end
		
	end
	mysql:free_result(sqlHandler)
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), onServerStart)


--createFuelPed(217, 2112.86328125, 915.0595703125, 10.9609375, 0)