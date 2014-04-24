function isNumberAHotline(theNumber)
	local challengeNumber = tonumber(theNumber)
	return challengeNumber == 911 or challengeNumber == 311 or challengeNumber == 411 or challengeNumber == 511  or challengeNumber == 611 or challengeNumber == 921 or challengeNumber == 1501 or challengeNumber == 1502 or challengeNumber == 8294 or challengeNumber == 7331 or challengeNumber == 7332 or challengeNumber == 864
end

function routeHotlineCall(callingElement, callingPhoneNumber, outboundPhoneNumber, startingCall, message)
	local callprogress = getElementData(callingElement, "callprogress")
	if callingPhoneNumber == 911 then
		-- 911: Emergency Services and Police.
		-- Emergency calls that they need to respond to.
		if startingCall then
			outputChatBox("911 Operator [Cellphone]: 911 emergency. Please state your location.", callingElement)
			exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("911 Operator [Cellphone]: Can you describe your emergency please?", callingElement)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("911 Operator [Cellphone]: Thanks for your call, we've dispatched a unit to your location.", callingElement)
				local location = getElementData(callingElement, "call.location")
						

				local playerStack = { } 
				
				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos Police Department" ) ) ) do
					table.insert(playerStack, value)
				end
				
				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "State Police" ) ) ) do
					table.insert(playerStack, value)
				end
				
				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos Medical Services" ) ) ) do
					table.insert(playerStack, value)
				end
				
				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos Fire Department" ) ) ) do
					table.insert(playerStack, value)
				end
				
				local affectedElements = { }
									
				for key, value in ipairs( playerStack ) do
					for _, itemRow in ipairs(exports['item-system']:getItems(value)) do 
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end
				
				for key, value in ipairs( affectedElements ) do
					outputChatBox("[RADIO] This is dispatch, We've got an incident call from #" .. outboundPhoneNumber .. ", Over.", value, 0, 183, 239)
					outputChatBox("[RADIO] Situation: '" .. message .. "', Over.", value, 0, 183, 239)
					outputChatBox("[RADIO] Location: '" .. tostring(location) .. "', Out.", value, 0, 183, 239)
				end
				
				executeCommandHandler( "hangup", callingElement )
			end
		end
	elseif callingPhoneNumber == 311 then
		if startingCall then
			outputChatBox("LSPD Operator [Cellphone]: LSPD Hotline. Please state your location.", callingElement)
			exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("LSPD Operator [Cellphone]: Can you please describe the reason for your call?", callingElement)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("LSPD Operator [Cellphone]: Thanks for your call, we've dispatched a unit to your location.", callingElement)
				local location = getElementData(callingElement, "call.location")
		
				local affectedElements = { }
									
				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos Police Department" ) ) ) do
					for _, itemRow in ipairs(exports['item-system']:getItems(value)) do 
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end
		
				for key, value in ipairs( affectedElements ) do
					outputChatBox("[RADIO] This is dispatch, We've got a report from #" .. outboundPhoneNumber .. " via the non-emergency line, Over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Reason: '" .. message .. "', Over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Location: '" .. tostring(location) .. "', Out.", value, 245, 40, 135)
				end
				executeCommandHandler( "hangup", callingElement )
			end
		end
	elseif callingPhoneNumber == 411 then
		if startingCall then
			outputChatBox("Operator [Cellphone]: Medical Services Hotline. Please state your location.", callingElement)
			exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("Operator [Cellphone]: Can you please tell us the reason of your call and your phonenumber?", callingElement)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("Operator [Cellphone]: Thanks for your call, we'll get to you soon.", callingElement)			
				local location = getElementData(callingElement, "call.location")
				
				local affectedElements = { }
									
				for key, value in ipairs( getPlayersInTeam( getTeamFromName("Los Santos Medical Services") ) ) do
					for _, itemRow in ipairs(exports['item-system']:getItems(value)) do 
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end				
				for key, value in ipairs( affectedElements ) do
					outputChatBox("[RADIO] This is dispatch, We've got a report from #" .. outboundPhoneNumber .. " via the non-emergency line, Over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Reason: '" .. message .. "', Over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Location: '" .. tostring(location) .. "', Out.", value, 245, 40, 135)
				end
				executeCommandHandler( "hangup", callingElement )
			end		
		end
	elseif callingPhoneNumber == 511 then
		if startingCall then
			outputChatBox("Operator [Cellphone]: State Police Info-crime. Please State your name.", callingElement)
			exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("Operator [Cellphone]: Please state the message you want to pass to our investigators.", callingElement)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("Operator [Cellphone]: Thank you, we will contact you in the shortest delays.", callingElement)			
				local location = getElementData(callingElement, "call.location")
								
				local affectedElements = { }
									
				for key, value in ipairs( getPlayersInTeam( getTeamFromName("State Police") ) ) do
					for _, itemRow in ipairs(exports['item-system']:getItems(value)) do 
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end		
								
				for key, value in ipairs( affectedElements ) do
					outputChatBox("[RADIO] This is dispatch, We've got a report over 511, Over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Situation: '" .. message .. "', Over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Name: '" .. tostring(location) .. "', Ph: "..outboundPhoneNumber..", Out.", value, 245, 40, 135)
				end
				executeCommandHandler( "hangup", callingElement )
			end		
		end
	elseif callingPhoneNumber == 611 then
		if startingCall then
			outputChatBox("Operator [Cellphone]: Los Santos Fire Department Hotline. Please state your location.", callingElement)
			exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("Operator [Cellphone]: Can you please tell us the reason for your call and your phonenumber?", callingElement)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("Operator [Cellphone]: Thanks for your call, we'll get to you soon.", callingElement)			
				local location = getElementData(callingElement, "call.location")
					
				local affectedElements = { }
									
				for key, value in ipairs( getPlayersInTeam( getTeamFromName("Los Santos Fire Department") ) ) do
					for _, itemRow in ipairs(exports['item-system']:getItems(value)) do 
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end	
					
				for key, value in ipairs( affectedElements ) do
					outputChatBox("[RADIO] This is dispatch, We've got a report from #" .. outboundPhoneNumber .. " via the non-emergency line, Over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Reason: '" .. message .. "', Over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Location: '" .. tostring(location) .. "', Out.", value, 245, 40, 135)
				end
				executeCommandHandler( "hangup", callingElement )
			end		
		end
	elseif callingPhoneNumber == 921 then
		if startingCall then
			outputChatBox("Operator [Cellphone]: Hex Tow 'n Go. Please state your location.", callingElement)
			exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "call.location", message)
				exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "callprogress", 2)
				outputChatBox("Operator [Cellphone]: Can you describe the situation please?", callingElement)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("Operator [Cellphone]: Thanks for your call, we've dispatched a unit to your location.", callingElement)
				local location = getElementData(callingElement, "call.location")
						
				local affectedElements = { }
						
				for key, value in ipairs( getPlayersInTeam( getTeamFromName("Hex Tow 'n Go") ) ) do
					for _, itemRow in ipairs(exports['item-system']:getItems(value)) do 
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end	
						
				for key, value in ipairs( affectedElements ) do
					outputChatBox("[RADIO] This is dispatch, We've got an incident report from #" .. outboundPhoneNumber .. ", Over.", value, 0, 183, 239)
					outputChatBox("[RADIO] Situation: '" .. message .. "', Over.", value, 0, 183, 239)
					outputChatBox("[RADIO] Location: '" .. tostring(location) .. "', Out.", value, 0, 183, 239)
				end
				executeCommandHandler( "hangup", callingElement )
			end		
		end
	elseif callingPhoneNumber == 1501 then
		if (publicphone) then
			outputChatBox("Computer voice [Cellphone]: This service is not available on this phone.", callingElement)
		else
			outputChatBox("Computer voice [Cellphone]: You are now calling with a secret number.", callingElement)
			mysql:query_free( "UPDATE `phone_settings` SET `secretnumber`='1' WHERE `phonenumber`='".. mysql:escape_string(tostring(outboundPhoneNumber)) .."'")
			--exports['anticheat-system']:changeProtectedElementDataEx(callingElement,"cellphone.secret",1, false)
		end
		executeCommandHandler( "hangup", callingElement )
	elseif callingPhoneNumber == 1502 then
		if (publicphone) then
			outputChatBox("Computer voice [Cellphone]: This service is not available on this phone.", callingElement)
		else
			outputChatBox("Computer voice [Cellphone]: You are now calling with a normal number.", callingElement)
			mysql:query_free( "UPDATE `phone_settings` SET `secretnumber`='0' WHERE `phonenumber`='".. mysql:escape_string(tostring(outboundPhoneNumber)) .."'")
			--exports['anticheat-system']:changeProtectedElementDataEx(callingElement,"cellphone.secret",0, false)
		end
		executeCommandHandler( "hangup", callingElement )
	elseif callingPhoneNumber == 8294 then
		if startingCall then
			outputChatBox("Taxi Operator [Cellphone]: Los Santos Cabs here. Please state your location.", callingElement)
			exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			local founddriver = false
			for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
				local job = getElementData(value, "job")						
				if (job == 2) then
					local car = getPedOccupiedVehicle(value)
					if car and (getElementModel(car)==438 or getElementModel(car)==420) then
						outputChatBox("[New Fare] " .. getPlayerName(callingElement):gsub("_"," ") .." Ph:" .. outboundPhoneNumber .. " Location: " .. message .."." , value, 0, 183, 239)
						founddriver = true
					end
				end
			end
								
			if founddriver == true then
				outputChatBox("Taxi Operator [Cellphone]: Thanks for your call, a taxi will be with you shortly.", callingElement)
			else
				outputChatBox("Taxi Operator [Cellphone]: There is no taxi available in that area, please try again later.", callingElement)
			end
			executeCommandHandler( "hangup", callingElement )
		end
	elseif callingPhoneNumber == 7331 then -- SAN Ads
		if startingCall then
			outputChatBox("SAN Worker [Cellphone]: Thanks for calling the ad broadcasting service. What can we air for you?.", callingElement)
			exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if getElementData(callingElement, "adminjailed") then
				outputChatBox("SAN Worker [Cellphone]: Err.. Sorry. We're broadcasting too much ads already. Try again later.", callingElement)
				executeCommandHandler( "hangup", callingElement )	
				return
			end
			if getElementData(callingElement, "alcohollevel") and getElementData(callingElement, "alcohollevel") ~= 0 then
				outputChatBox("SAN Worker [Cellphone]: Hey, shut up you drunk fool. We're not going to broadcast that!", callingElement)
				executeCommandHandler( "hangup", callingElement )	
				return
			end
			if (getElementData(callingElement, "ads") or 0) >= 2 then
				outputChatBox("SAN Worker [Cellphone]: Again you?! You can only place 2 ads every 5 minutes.", callingElement)	
				executeCommandHandler( "hangup", callingElement )					
				return
			end
				
			if message:sub(-1) ~= "." and message:sub(-1) ~= "?" and message:sub(-1) ~= "!" then
				message = message .. "."
			end

			local cost = math.ceil(string.len(message)/5) + 10
			if not exports.global:takeMoney(callingElement, cost) then
				outputChatBox("SAN Worker [Cellphone]: Err.. Sorry. We're broadcasting too much. Try again later.", callingElement)
				outputChatBox("((You don't have enough money to place this ad))", callingElement)
				return
			end
				
			local name = getPlayerName(callingElement):gsub("_", " ")
			outputChatBox("SAN Worker [Cellphone]: Thanks, " .. cost .. " dollar will be withdrawn from your account. We'll air it as soon as possible!", callingElement)
			exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "ads", ( getElementData(callingElement, "ads") or 0 ) + 1, false)
			exports.global:giveMoney(getTeamFromName"San Andreas Network", cost)
			setTimer(
				function(p)
					if isElement(p) then
						local c =  getElementData(p, "ads") or 0
						if c > 1 then
							exports['anticheat-system']:changeProtectedElementDataEx(p, "ads", c-1, false)
						else
							exports['anticheat-system']:changeProtectedElementDataEx(p, "ads", false, false)
						end
					end
				end, 300000, 1, callingElement
			)
				
			SAN_newAdvert(message, name, callingElement, cost, outboundPhoneNumber)									
			executeCommandHandler( "hangup", callingElement )			
		end
	elseif callingPhoneNumber == 7332 then -- SAN Hotline
		if startingCall then
			outputChatBox("SAN Worker [Cellphone]: Thanks for calling SAN. What message can i give through to our reporters?", callingElement)
			exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			local languageslot = getElementData(callingElement, "languages.current")
			local language = getElementData(callingElement, "languages.lang" .. languageslot)
			local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
			if getElementData(callingElement, "adminjailed") then
				outputChatBox("SAN Worker [Cellphone]: Thanks for the message, we'll contact you back if needed.", callingElement)
			elseif getElementData(callingElement, "alcohollevel") and getElementData(callingElement, "alcohollevel") ~= 0 then
				outputChatBox("SAN Worker [Cellphone]: Hey, shut up you drunk fool. ", callingElement)
			else
				outputChatBox("SAN Worker [Cellphone]: Thanks for the message, we'll contact you back if needed.", callingElement)
				local playerNumber = getElementData(callingElement, "cellnumber")
						
				for key, value in ipairs( getPlayersInTeam(getTeamFromName("San Andreas Network")) ) do
					local hasItem, index, number, dbid = exports.global:hasItem(value,2)
					if hasItem then
						local reconning2 = getElementData(value, "reconx")
						if not reconning2 then
							exports.global:sendLocalMeAction(value,"receives a text message.")
						end
						
						outputChatBox("[" .. languagename .. "] SMS from #7332 [#"..number.."]: Ph:".. outboundPhoneNumber .." " .. message, value, 120, 255, 80)
					end
				end
				executeCommandHandler( "hangup", callingElement )					
			end
		end
	elseif callingPhoneNumber == 864 then -- UNI-Tel Hotline
		if startingCall then
			outputChatBox("Receptionist [Cellphone]: Hello, UNI-TEL's importing line. What would be your order today?", callingElement)
			exports['anticheat-system']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			local languageslot = getElementData(callingElement, "languages.current")
			local language = getElementData(callingElement, "languages.lang" .. languageslot)
			local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
			if getElementData(callingElement, "adminjailed") then
				outputChatBox("Receptionist [Cellphone]: Thank you. Your message has been sent to your salesman. One shall contact you soon.", callingElement)
			elseif getElementData(callingElement, "alcohollevel") and getElementData(callingElement, "alcohollevel") ~= 0 then
				outputChatBox("Receptionist [Cellphone]: Hey, shut up you drunk fool. ", callingElement)
			else
				outputChatBox("Receptionist [Cellphone]: Thank you. Your message has been sent to your salesman. One shall contact you soon.", callingElement)
				local playerNumber = getElementData(callingElement, "cellnumber")
						
				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Uni-Tel" ) ) ) do
					local hasItem, index, number, dbid = exports.global:hasItem(value,2)
					if hasItem then
						local reconning2 = getElementData(value, "reconx")
						if not reconning2 then
							exports.global:sendLocalMeAction(value,"receives a text message.")
						end
						outputChatBox("[" .. languagename .. "] SMS from #864 [#"..number.."]: Ph:".. outboundPhoneNumber .." " .. message, value, 120, 255, 80)
					end
				end
				executeCommandHandler( "hangup", callingElement )					
			end
		end
	end
end

--[[function broadcastSANAd(name, message)
	exports.logs:logMessage("ADVERT: " .. message, 2)
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		if (getElementData(value, "loggedin")==1 and not getElementData(value, "disableAds")) then
			if exports.global:isPlayerAdmin(value) then
				outputChatBox("   ADVERT: " .. message .. " ((" .. name .. "))", value, 0, 255, 64)
			else
				outputChatBox("   ADVERT: " .. message , value, 0, 255, 64)
			end
		end
	end
end]]

