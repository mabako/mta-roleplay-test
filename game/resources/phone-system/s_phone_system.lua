mysql = exports.mysql

MTAoutputChatBox = outputChatBox
function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if string.len(text) > 128 then -- MTA Chatbox size limit
		MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
		outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
	else
		MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
	end
end

function callSomeone(thePlayer, commandName, phoneNumber, withNumber)
	local logged = getElementData(thePlayer, "loggedin")

	withNumber = tonumber(withNumber)
	local outboundPhoneNumber = -1
	if (logged==1) then
		local publicphone = nil
		for k, v in pairs( getElementsByType( "colshape", getResourceRootElement( ) ) ) do
			if isElementWithinColShape( thePlayer, v ) then
				for kx, vx in pairs( getElementsByType( "player" ) ) do
					if getElementData( vx, "call.col" ) == v then
						outputChatBox( "Someone else is already using this phone.", thePlayer, 255, 0, 0 )
						return
					end
				end
				publicphone = v
				break
			end
		end
		
		
		
		if publicphone or exports.global:hasItem(thePlayer, 2) then
			local localPhoneNumber = getElementData(thePlayer, "cellnumber")
			-- Determine the outbound number, -1 is secret
			if publicphone then
				outboundPhoneNumber = math.random(5111151000, 58111510000)
			elseif withNumber and withNumber > 10 then
				if exports.global:hasItem(thePlayer, 2, tonumber(withNumber)) or (localPhoneNumber > 10 and tonumber(localPhoneNumber) ==  tonumber(withNumber))  then
					outboundPhoneNumber = tonumber(withNumber)
				else
					outputDebugString(getPlayerName(thePlayer).." tried to call with a phone he doesn't have?")
					return
				end
			else
				
				if localPhoneNumber and localPhoneNumber > 1 then
					outboundPhoneNumber = tonumber(localPhoneNumber)
				else
					outputDebugString(getPlayerName(thePlayer).." tried to his default number he doesn't have?")
					return
				end
			end
			
			if not outboundPhoneNumber or outboundPhoneNumber == -1 then
				outputChatBox("Error: please report on F2.", thePlayer, 255, 0, 0)
				return
			end
			
			if not (phoneNumber) then
				outputChatBox("Press 'i' and click the phone you want to use, please.", thePlayer)
				return
				--requestPhoneGUI(1, thePlayer)
			end
			
			if not tonumber(phoneNumber) then
				outputChatBox("Invalid phonenumber.", thePlayer)
				return
			end
			local realOutboundPhoneNumber = tonumber(outboundPhoneNumber)
			
			local callerphoneIsSecretNumber = 1
			local callerphoneIsTurnedOn = 1
			local callerphoneRingTone = 1
			local callerphonePhoneBook = 1
			local callerphoneBoughtBy = -1
					
			if not publicphone then
				local phoneSettings = mysql:query_fetch_assoc("SELECT * FROM `phone_settings` WHERE `phonenumber`='"..mysql:escape_string(tostring(realOutboundPhoneNumber)).."'")
				if not phoneSettings then
					mysql:query_free("INSERT INTO `phone_settings` (`phonenumber`) VALUES ('".. mysql:escape_string(tostring(realOutboundPhoneNumber)) .."')")
					callerphoneIsSecretNumber = 0
					callerphoneIsTurnedOn = 1
					callerphoneRingTone = 1
					callerphonePhoneBook = 1
					callerphoneBoughtBy = -1
				else
					callerphoneIsSecretNumber = tonumber(phoneSettings["secretnumber"]) or 0
					callerphoneIsTurnedOn = tonumber(phoneSettings["turnedon"]) or 1
					callerphoneRingTone =  tonumber(phoneSettings["ringtone"]) or 1
					callerphonePhoneBook =  tonumber(phoneSettings["phonebook"]) or 1
					callerphoneBoughtBy =  tonumber(phoneSettings["boughtby"]) or -1
				end
			end
			
			
			
			if callerphoneIsTurnedOn == 0 then
				outputChatBox("Your phone is off.", thePlayer, 255, 0, 0)
			else
				local calling = getElementData(thePlayer, "calling")
				
				if (calling) then -- Using phone already
					outputChatBox("You are already using a phone.", thePlayer, 255, 0, 0)
				elseif getElementData(thePlayer, "injuriedanimation") then
					outputChatBox("You can't use your phone while knocked out.", thePlayer, 255, 0, 0)
				else
					-- /me it
					if publicphone then
						exports.global:sendLocalMeAction(thePlayer, "reaches for the public phone.")
					else
						exports.global:sendLocalMeAction(thePlayer, "takes out a cell phone.")
					end
					
					-- If the number is a hotline aka automated machine, then..
					if isNumberAHotline(phoneNumber) then
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "phonestate", 1, false)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "calling", phoneNumber, false)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "callingwith", outboundPhoneNumber, false)	
						routeHotlineCall(thePlayer, tonumber(phoneNumber), tonumber(outboundPhoneNumber), true, "")				
						
					-- Otherwise find a fool to answer it
					else
						-- Search for the phone
						local found, foundElement = searchForPhone(phoneNumber)
						
						-- Some basic checks.
						-- Can we afford it?
						if not exports.donators:hasPlayerPerk(thePlayer, 6) and not exports.global:hasMoney(thePlayer, 5) then
							outputChatBox("You cannot afford a call.", thePlayer, 255, 0, 0)
							return
						end
						
						-- Yes, Is the target phone online or found at all?
						if not found or foundElement == thePlayer then
							outputChatBox("You get a dead tone...", thePlayer, 255, 194, 14)
							return
						end
						
						-- Fetch some details
						local calledphoneIsSecretNumber = 1
						local calledphoneIsTurnedOn = 1
						local calledphoneRingTone = 1
						local calledphonePhoneBook = 1
						local calledphoneBoughtBy = -1
								
						if not publicphone then
							local phoneSettings = mysql:query_fetch_assoc("SELECT * FROM `phone_settings` WHERE `phonenumber`='"..mysql:escape_string(tostring(phoneNumber)).."'")
							if not phoneSettings then
								mysql:query_free("INSERT INTO `phone_settings` (`phonenumber`) VALUES ('".. mysql:escape_string(tostring(phoneNumber)) .."')")
								calledphoneIsSecretNumber = 0
								calledphoneIsTurnedOn = 1
								calledphoneRingTone = 1
								calledphonePhoneBook = 1
								calledphoneBoughtBy = -1
							else
								calledphoneIsSecretNumber = tonumber(phoneSettings["secretnumber"]) or 0
								calledphoneIsTurnedOn = tonumber(phoneSettings["turnedon"]) or 1
								calledphoneRingTone =  tonumber(phoneSettings["ringtone"]) or 1
								calledphonePhoneBook =  tonumber(phoneSettings["phonebook"]) or 1
								calledphoneBoughtBy =  tonumber(phoneSettings["boughtby"]) or -1
							end
						end
						
						-- Yes, It is perchance off?
						if calledphoneIsTurnedOn == 0 then
							outputChatBox("The phone you are trying to call is switched off.", thePlayer, 255, 194, 14)
							return
						end
						
						-- No, Is the player already calling?
						if getElementData(foundElement, "calling") then
							outputChatBox("You get a busy tone.", thePlayer)
							return
						end
						
						-- Note down some needed details.
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "call.col", publicphone, false)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "calling", tonumber(phoneNumber), false)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "called", true, false)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "callingwith", outboundPhoneNumber, false)
						exports['anticheat-system']:changeProtectedElementDataEx(foundElement, "calling", tonumber(outboundPhoneNumber), false)
						exports['anticheat-system']:changeProtectedElementDataEx(foundElement, "called", nil, false)
															
						local reconning = getElementData(foundElement, "reconx")
						if not reconning then 
							if calledphoneRingTone ~= 0 then
								for _,nearbyPlayer in ipairs(exports.global:getNearbyElements(foundElement, "player"), 10) do
									triggerClientEvent(nearbyPlayer, "startRinging", foundElement, 1, calledphoneRingTone)
								end
							end
							exports.global:sendLocalMeAction(foundElement, "'s Phone starts to ring.")
						end
						
						local display = "Unknown Number"
						if (callerphoneIsSecretNumber == 1) then
							display = "Unknown Number"
						else
							local callerIDQuery = mysql:query("SELECT `entryName` FROM `phone_contacts` WHERE `phone`='".. mysql:escape_string(phoneNumber) .."' AND `entryNumber`='".. mysql:escape_string(outboundPhoneNumber ).."' LIMIT 1")
							if (mysql:num_rows(callerIDQuery) > 0) then
								local row = mysql:fetch_assoc(callerIDQuery)
								display =  row["entryName"] .." (#".. outboundPhoneNumber .. ")"
							else
								display = "#".. outboundPhoneNumber
							end
							mysql:free_result(callerIDQuery)
						end
						outputChatBox("Your phone #"..tostring(phoneNumber).." is ringing. The display shows '".. display .."' (( /pickup to answer ))", foundElement, 255, 194, 14)
						-- Give the target 30 seconds to answer the call
						setTimer(cancelCall, 30000, 1, { tonumber(phoneNumber), tonumber(outboundPhoneNumber) } )
						exports['logs']:dbLog(thePlayer, 29, { thePlayer, "ph"..tostring(realOutboundPhoneNumber), foundElement, "ph"..tostring(phoneNumber) }, "**Starting call - " .. display .. "**") 
					end
				end
			end
		else
			outputChatBox("Believe it or not, it's hard to dial on a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addEvent("remoteCall", true)
addEventHandler("remoteCall", getRootElement(), callSomeone)

for i = 1, 20 do
	addCommandHandler( "call" .. tostring( i ), 
		function( thePlayer, commandName, number )
			if i <= exports['item-system']:countItems(thePlayer, 2) then
				local count = 0
				local items = exports['item-system']:getItems(thePlayer)
				for k, v in ipairs(items) do
					if tostring(v[1]) == 2 then
						count = count + 1
						if count == i then							
							triggerEvent("remoteCall", thePlayer, thePlayer, commandName, number, v[2])
							break
						end
					end
				end
				
			end
		end
	)
end

function callSomeoneHax( thePlayer, commandName, number )
	executeCommandHandler( "call1", thePlayer, number)
end
addCommandHandler("call", callSomeoneHax)

function cancelCall(phoneNumbers)
	for _, phoneNumber in ipairs(phoneNumbers) do
		local found, foundElement = searchForPhone(phoneNumber)
		if found and foundElement and isElement(foundElement) then
			local phoneState = getElementData(foundElement, "phonestate")
			
			if (phoneState==0) then
				exports['anticheat-system']:changeProtectedElementDataEx(foundElement, "calling", nil, false)
				exports['anticheat-system']:changeProtectedElementDataEx(foundElement, "called", nil, false)
				exports['anticheat-system']:changeProtectedElementDataEx(foundElement, "call.col", nil, false)
			end
		end
	end
end

function answerPhone(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 2)) then
			local phoneState = getElementData(thePlayer, "phonestate")
			local calling = getElementData(thePlayer, "calling")
			
			if getElementData(thePlayer, "called") then
				outputChatBox("You're the one calling someone else, smart-ass.", thePlayer, 255, 0, 0)
			elseif (calling) then
				if (phoneState==0) then
					local found, foundElement = searchForPhone(calling)
					--local target = calling
					outputChatBox("You picked up the phone. (( /p to talk ))", thePlayer)
					if not found then
						outputChatBox("You can't hear anything on the other side of the line", thePlayer)
						executeCommandHandler( "hangup", thePlayer )
					else
						outputChatBox("They picked up the phone.", foundElement)
						exports.global:sendLocalMeAction(thePlayer, "takes out a cell phone.")
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "phonestate", 1, false)
						exports['anticheat-system']:changeProtectedElementDataEx(foundElement, "phonestate", 1, false)
						exports['anticheat-system']:changeProtectedElementDataEx(foundElement, "called", nil, false)
						exports.global:sendLocalMeAction(thePlayer, "answers their cellphone.")
						local ownPhoneNo = getElementData(foundElement, "calling")
						exports['logs']:dbLog(thePlayer, 29, { thePlayer, "ph"..tostring(ownPhoneNo), foundElement, "ph"..tostring(calling) }, "**Picked up phone**") 
					end

					triggerClientEvent("stopRinging", thePlayer)
				end
			elseif not (calling) then
				outputChatBox("Your phone is not ringing.", thePlayer, 255, 0, 0)
			elseif (phoneState==1) or (phoneState==2) then
				outputChatBox("Your phone is already in use.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Believe it or not, it's hard to use a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("pickup", answerPhone)

function hangupPhone(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 2)) or getElementData(thePlayer, "call.col") then
			local calling = getElementData(thePlayer, "calling")
			
			if (calling) then
				if not (isNumberAHotline(calling)) then
					local phoneState = getElementData(thePlayer, "phonestate")
					if phoneState >= 1 then
						if not exports.donators:hasPlayerPerk(calling, 6) then
							exports.global:takeMoney(calling, 10, true)
						end
					end
					
					local found, foundElement = searchForPhone(calling)
					if found then
						if (isElement(foundElement)) then
							outputChatBox("They hung up.", foundElement)
							local ownPhoneNo = getElementData(foundElement, "calling")
							exports['logs']:dbLog(thePlayer, 29, { thePlayer, "ph"..tostring(ownPhoneNo), foundElement, "ph"..tostring(calling) }, "**Hung up phone**") 
							exports['anticheat-system']:changeProtectedElementDataEx(foundElement, "calling", false, false)
							exports['anticheat-system']:changeProtectedElementDataEx(foundElement, "caller", false, false)
							exports['anticheat-system']:changeProtectedElementDataEx(foundElement, "call.col", false, false)
							exports['anticheat-system']:changeProtectedElementDataEx(foundElement, "phonestate", 0, false)
							
							local reconning2 = getElementData(foundElement, "reconx")
							if not reconning2 then
								exports.global:sendLocalMeAction(foundElement, "hangs up their phone.")
							end
							
						end
					end
				end
				
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "calling", false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "caller", false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "call.col", false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "phonestate", 0, false)
				
				-- Reset hotline stuff
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "callprogress", false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "call.situation", false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "call.location", false)
				
				local reconning = getElementData(thePlayer, "reconx")
				if not reconning then
					exports.global:sendLocalMeAction(thePlayer, "hangs up their phone.")
				end
				
				
			else
				outputChatBox("Your phone is not in use.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Believe it or not, it's hard to use a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("hangup", hangupPhone)

function loudSpeaker(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 2)) or getElementData(thePlayer, "call.col") then -- 2 = Cell phone item
			local phoneState = getElementData(thePlayer, "phonestate")
			
			if (phoneState==1) then
				exports.global:sendLocalMeAction(thePlayer, "turns on loudspeaker on the phone.")
				outputChatBox("You flick your phone onto loudspeaker.", thePlayer)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "phonestate", 2, false)
			elseif (phoneState==2) then
				exports.global:sendLocalMeAction(thePlayer, "turns off loudspeaker on the phone.")
				outputChatBox("You flick your phone off of loudspeaker.", thePlayer)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "phonestate", 1, false)
			else
				outputChatBox("You are not in a call.", thePlayer, 255, 0 ,0)
			end
		else
			outputChatBox("Believe it or not, it's hard to use a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("loudspeaker", loudSpeaker)

addEventHandler( "onColShapeLeave", getResourceRootElement(),
	function( thePlayer )
		if getElementData( thePlayer, "call.col" ) == source then
			executeCommandHandler( "hangup", thePlayer )
		end
	end
)
addEventHandler( "onPlayerQuit", getRootElement(),
	function( )
		local calling = getElementData( source, "calling" )
		if isElement( calling ) then
			executeCommandHandler( "hangup", source )
		end
	end
)

function talkPhone(thePlayer, commandName, ...)
	local affected = { }
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 2)) or getElementData(thePlayer, "call.col") then
			if not (...) then
				outputChatBox("SYNTAX: /p [Message]", thePlayer, 255, 194, 14)
			elseif getElementData(thePlayer, "injuriedanimation") then
				outputChatBox("You can't use your phone while knocked out.", thePlayer, 255, 0, 0)
			else
				local phoneState = getElementData(thePlayer, "phonestate")
				
				if (phoneState>=1) then 
					local message = table.concat({...}, " ")
					local username = getPlayerName(thePlayer):gsub("_", " ")
					
					local languageslot = getElementData(thePlayer, "languages.current")
					local language = getElementData(thePlayer, "languages.lang" .. languageslot)
					local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
					
					local callingNumber = getElementData(thePlayer, "calling")
					local callingNumberWith = getElementData(thePlayer, "callingwith")
					table.insert(affected, thePlayer)
					table.insert(affected, "ph"..tostring(callingNumberWith))
					local found, target = searchForPhone(callingNumber)
					if not (found and target and isElement(target) and (getElementData(target, "loggedin") == 1)) and not isNumberAHotline(callingNumber) then
						executeCommandHandler( "hangup", thePlayer )
						return
					end
					
					table.insert(affected, target)
					table.insert(affected, "ph"..tostring(callingNumber))
					
					message = call( getResourceFromName( "chat-system" ), "trunklateText", thePlayer, message )
					
					local callprogress = getElementData(thePlayer, "callprogress")
					if (callprogress) then
						outputChatBox("You [Cellphone]: " ..message, thePlayer)
						-- Send it to nearby players of the speaker
						exports.global:sendLocalText(thePlayer, username .. " [Cellphone]: " .. message, nil, nil, nil, 10, {[thePlayer] = true})
						
						if isNumberAHotline(callingNumber) then
							exports['logs']:dbLog(thePlayer, 29, affected, "[" .. languagename .. "] " ..message) 
							routeHotlineCall(thePlayer, tonumber(callingNumber), tonumber(callingNumberWith), false, message)		
							return
						end
					end
					
					local message2 = call(getResourceFromName("language-system"), "applyLanguage", thePlayer, target, call( getResourceFromName( "chat-system" ), "trunklateText", target, message ), language)
					outputChatBox("[" .. languagename .. "] ((" .. username .. ")) [Cellphone]: " .. message2, target)
					
					-- Send the message to the person on the other end of the line
					outputChatBox("[" .. languagename .. "] You [Cellphone]: " ..message, thePlayer)
					
					-- Send it to nearby players of the speaker
					exports.global:sendLocalText(thePlayer, username .. " [Cellphone]: " .. message, nil, nil, nil, 10, {[thePlayer] = true})
					
					local phoneState = getElementData(target, "phonestate")
					-- Send it to the listener, if they have loud speaker
					if (phoneState==2) then -- Loudspeaker
						local x, y, z = getElementPosition(target)
						local username = getPlayerName(target):gsub("_", " ")
						
						for index, nearbyPlayer in ipairs(getElementsByType("player")) do
							if isElement(nearbyPlayer) and nearbyPlayer ~= target and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyPlayer)) < 40 and getElementDimension(nearbyPlayer) == getElementDimension(target) then
								local message2 = call(getResourceFromName("language-system"), "applyLanguage", thePlayer, nearbyPlayer, call( getResourceFromName( "chat-system" ), "trunklateText", target, message ), language)
								outputChatBox("[" .. languagename .. "] " .. username .. "'s Cellphone Loudspeaker: " .. message2, nearbyPlayer)
								table.insert(affected, nearbyPlayer)
							end
						end
					end
					exports['logs']:dbLog(thePlayer, 29, affected, "[" .. languagename .. "] " ..message) 
				else
					outputChatBox("You are not on a call.", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox("Believe it or not, it's hard to use a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("p", talkPhone)

function phoneBook(thePlayer, commandName, partialNick)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 7)) then
			if not (partialNick) then
				outputChatBox("SYNTAX: /phonebook [Partial Name]", thePlayer, 255, 194, 14)
			else
				exports.global:sendLocalMeAction(thePlayer, "looks into their phonebook.")
				local result = mysql:query("SELECT phonenumber, phonebook FROM characters WHERE phonebook IS NOT NULL AND phonebook != '' AND phonebook LIKE '%" .. mysql:escape_string(partialNick) .. "%' AND secretnumber = 0")
				if (mysql:num_rows(result)>10) then
					outputChatBox("Too many results.", thePlayer, 255, 194, 14)
				elseif (mysql:num_rows(result)>0) then
					local continue = true
					while true do
						local row = mysql:fetch_assoc(result)
						if not row then break end
						local phoneNumber = tonumber(row["phonenumber"])
						local username = tostring(row["phonebook"])
						
						outputChatBox(username .. " - #" .. phoneNumber .. ".", thePlayer)
					end
				else
					outputChatBox("You find no one with that name.", thePlayer, 255, 194, 14)
				end
				mysql:free_result(result)
			end
		else
			outputChatBox("Believe it or not, it's hard to use a phonebook you do not have.", thePlayer, 255, 0, 0)
		end
	end
end

function phoneBook(thePlayer, commandName)
	outputChatBox("This feature is currently disabled.", thePlayer, 255, 0, 0)
end
addCommandHandler("phonebook", phoneBook)

function initiateSendSMS(thePlayer, commandName, number, ...)
	 sendSMS(thePlayer, commandName, 1, number, ...)
end
addCommandHandler("sms", initiateSendSMS)


function sendSMS(thePlayer, commandName, sourcePhone, number, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 2)) then
		
			local phoneNumber = -1
			
			local count = 0
			local items = exports['item-system']:getItems(thePlayer)
			for k, v in ipairs(items) do
				if v[1] == 2 then
					count = count + 1
					if count == sourcePhone then
						foundPhoneNumber = v[2]
						break
					end
				end
			end
			
			if not foundPhoneNumber or foundPhoneNumber < 10 then
				phoneNumber = getElementData(thePlayer, "cellnumber")
			else
				phoneNumber = foundPhoneNumber
			end
			
			if not tonumber(number) then
				outputChatBox("Invalid phonenumber.", thePlayer)
				return
			end
			
			-- Fetch some details
			local callerphoneIsSecretNumber = 1
			local callerphoneIsTurnedOn = 1
			local callerphoneRingTone = 1
			local callerphonePhoneBook = 1
			local callerphoneBoughtBy = -1
							
			if not publicphone then
				local phoneSettings = mysql:query_fetch_assoc("SELECT * FROM `phone_settings` WHERE `phonenumber`='"..mysql:escape_string(tostring(phoneNumber)).."'")
				if not phoneSettings then
					mysql:query_free("INSERT INTO `phone_settings` (`phonenumber`) VALUES ('".. mysql:escape_string(tostring(phoneNumber)) .."')")
					callerphoneIsSecretNumber = 0
					callerphoneIsTurnedOn = 1
					callerphoneRingTone = 1
					callerphonePhoneBook = 1
					callerphoneBoughtBy = -1
				else
					callerphoneIsSecretNumber = tonumber(phoneSettings["secretnumber"]) or 0
					callerphoneIsTurnedOn = tonumber(phoneSettings["turnedon"]) or 1
					callerphoneRingTone =  tonumber(phoneSettings["ringtone"]) or 1
					callerphonePhoneBook =  tonumber(phoneSettings["phonebook"]) or 1
					callerphoneBoughtBy =  tonumber(phoneSettings["boughtby"]) or -1
				end
			end
			
			
						
			if not number or not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [number] [message]", thePlayer, 255, 194, 14)
			elseif callerphoneIsTurnedOn == 0 then
				outputChatBox("Your phone is off.", thePlayer, 255, 0, 0)
			elseif getElementData(thePlayer, "injuriedanimation") then
				outputChatBox("You can't use your phone while knocked out.", thePlayer, 255, 0, 0)
			elseif exports.global:hasMoney(thePlayer, 1) or exports.donators:hasPlayerPerk(thePlayer, 6) then
			
				local languageslot = getElementData(thePlayer, "languages.current")
				local language = getElementData(thePlayer, "languages.lang" .. languageslot)
				local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
				local message = table.concat({...}, " ")
			
				if tonumber(number) == 921 then
					if not exports.donators:hasPlayerPerk(thePlayer, 6) then
						exports.global:takeMoney(thePlayer, 1)
					end
					
					local reconning = getElementData(thePlayer, "reconx")
					if not reconning then
						exports.global:sendLocalMeAction(thePlayer, "sends a text message.")
					end
					outputChatBox("["..languagename.."] SMS to #921 [#"..tostring(phoneNumber).."]: "..message, thePlayer, 120, 255, 80)
					setTimer( 
						function( thePlayer )
							if isElement( thePlayer ) then
								local id = getElementData( thePlayer, "dbid" )
								if id then
									local impounded = mysql:query_fetch_assoc("SELECT COUNT(*) as no FROM vehicles WHERE owner = " .. mysql:escape_string(id) .. " and Impounded > 0")
									if impounded then
										local amount = tonumber(impounded["no"])
										local reconning2 = getElementData(thePlayer, "reconx")
										if not reconning2 then
											exports.global:sendLocalMeAction(thePlayer,"receives a text message.")
										end
										if amount > 0 then
											outputChatBox("[English] SMS from #921 [#"..phoneNumber.."]: " .. amount .. " of your vehicles are impounded. Head over to the Impound to release them.", thePlayer, 120, 255, 80)
										else
											outputChatBox("[English] SMS from #921 [#"..phoneNumber.."]: None of your vehicles are impounded.", thePlayer, 120, 255, 80)
										end
									end
								end
							end
						end, 3000, 1, thePlayer
					)
				elseif tonumber(number) == 7332 then
					if not exports.donators:hasPlayerPerk(thePlayer, 6) then
						exports.global:takeMoney(thePlayer, 1)
					end					
					
					if getElementData(thePlayer, "adminjailed") then
						return
					elseif getElementData(thePlayer, "alcohollevel") and getElementData(thePlayer, "alcohollevel") ~= 0 then
						return
					else
						local reconning2 = getElementData(thePlayer, "reconx")
						if not reconning2 then
							exports.global:sendLocalMeAction(thePlayer, "sends a text message.")
						end
						local message = table.concat({...}, " ")
						outputChatBox("["..languagename.."] SMS to #7332 [#"..tostring(phoneNumber).."]: "..message, thePlayer, 120, 255, 80)
						setTimer(
							function( thePlayer )
								if isElement( thePlayer ) then
									exports.global:takeMoney(thePlayer, 3)
									
									local reconning2 = getElementData(thePlayer, "reconx")
									if not reconning2 then
										exports.global:sendLocalMeAction(thePlayer, "receives a text message.")
									end
									outputChatBox("[English] SMS from #7332 [#"..phoneNumber.."]: Thanks for your message. - San Andreas Network", thePlayer, 120, 255, 80)
								end
							end, 3000, 1, thePlayer
						)
						local theTeam = getTeamFromName("San Andreas Network")
						local teamMembers = getPlayersInTeam(theTeam)
						
						exports.global:giveMoney(theTeam, 3)
					
						for key, value in ipairs(teamMembers) do
							local hasItem, index, number, dbid = exports.global:hasItem(value,2)
							if(hasItem)then
								local reconning2 = getElementData(value, "reconx")
								if not reconning2 then
									exports.global:sendLocalMeAction(value,"receives a text message.")
								end
								
								message = call( getResourceFromName( "chat-system" ), "trunklateText", thePlayer, message )
								local message2 = call(getResourceFromName("language-system"), "applyLanguage", thePlayer, value, call( getResourceFromName( "chat-system" ), "trunklateText", value, message ), language)
								outputChatBox("[" .. languagename .. "] SMS from #7332 [#"..number.."]: Ph:".. phoneNumber .." " .. message2, value, 120, 255, 80)
							end
						end
					end
				else
					local found, target = searchForPhone(number)
										
					if target then
						-- Fetch some details
						local calledphoneIsTurnedOn = 1
						
						local phoneSettings = mysql:query_fetch_assoc("SELECT * FROM `phone_settings` WHERE `phonenumber`='"..mysql:escape_string(tostring(number)).."'")
						if not phoneSettings then
							mysql:query_free("INSERT INTO `phone_settings` (`phonenumber`) VALUES ('".. mysql:escape_string(tostring(number)) .."')")
							calledphoneIsTurnedOn = 1
						else
							calledphoneIsTurnedOn = tonumber(phoneSettings["turnedon"]) or 1
						end
						
						
						if calledphoneIsTurnedOn == 0 then
							local reconning = getElementData(thePlayer, "reconx")
							if not reconning then
								exports.global:sendLocalMeAction(thePlayer, "sends a text message.")
							end
							outputChatBox("[" .. languagename .. "] SMS to  #" .. number .. " [#"..tostring(phoneNumber).."]: " .. message, thePlayer, 120, 255, 80)
							
							setTimer( outputChatBox, 3000, 1, "((Automated Message)) The phone with that number is currently off.", thePlayer, 120, 255, 80 )
							return
						end
						
						local username = getPlayerName(thePlayer):gsub("_", " ")
								
						local message2 = call(getResourceFromName("language-system"), "applyLanguage", thePlayer, target, message, language)
							
						local reconning = getElementData(thePlayer, "reconx")
						if not reconning then
							exports.global:sendLocalMeAction(thePlayer, "sends a text message.")
						end
						
						
						outputChatBox("[" .. languagename .. "] SMS to #" .. number .. " [#"..tostring(phoneNumber).."]: " .. message, thePlayer, 120, 255, 80)
						
						-- Send the message to the person on the other end of the line
						setTimer(
							function( target, sender, phoneNumber, number, message2 )
								if isElement( target ) then
									local reconning2 = getElementData(target, "reconx")
									if not reconning2 then
										exports.global:sendLocalMeAction(target, "receives a text message.")
									end
									outputChatBox("[" .. languagename .. "] SMS from #" .. phoneNumber .. " [#"..number.."]: " .. message2, target, 120, 255, 80)
								else
									if isElement(sender) then
										local reconning2 = getElementData(sender, "reconx")
										if not reconning2 then
											exports.global:sendLocalMeAction(sender, "receives a text message.")
										end
										outputChatBox("((Automated Message)) The recipient of the message could not be found.", thePlayer, 120, 255, 80)
									end
								end
							end, 1500, 1, target, thePlayer, phoneNumber, number, message2
						)
						
						if not exports.donators:hasPlayerPerk(thePlayer, 6) then
							exports.global:takeMoney(thePlayer, 1)
						end
						
						exports['logs']:dbLog(thePlayer, 30, {thePlayer, "ph"..tostring(phoneNumber), target, "ph"..tostring(number)}, "[" .. languagename .. "] " ..message)
					else
						local reconning = getElementData(thePlayer, "reconx")
						if not reconning then
							exports.global:sendLocalMeAction(thePlayer, "sends a text message.")
						end
						outputChatBox("[" .. languagename .. "] SMS to #" .. number .. " [#"..tostring(phoneNumber).."]: " .. message, thePlayer, 120, 255, 80)
						
						local reconning2 = getElementData(thePlayer, "reconx")
						if not reconning2 then
							exports.global:sendLocalMeAction(thePlayer, "receives a text message.")
						end
						setTimer( outputChatBox, 3000, 1, "((Automated Message)) The recipient of the message could not be found.", thePlayer, 120, 255, 80)
					end
				end
			else
				outputChatBox("You cannot afford a SMS.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Believe it or not, it's hard to use a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end



function togglePhone(thePlayer, commandName, phoneNumber)
	local logged = getElementData(thePlayer, "loggedin")
	
	if logged == 1 then
		if not phoneNumber then
			local foundPhone,_,foundPhoneNumber = exports.global:hasItem(thePlayer, 2)
			if not foundPhoneNumber or foundPhoneNumber < 10 then
				phoneNumber = getElementData(thePlayer, "cellnumber")
			else
				phoneNumber = foundPhoneNumber
			end
		elseif tonumber(phoneNumber) < 10 then
			local count = 0
			local items = exports['item-system']:getItems(thePlayer)
			for k, v in ipairs(items) do
				if v[1] == 2 then
					count = count + 1
					if count == phoneNumber then
						phoneNumber = v[2]
						break
					end
				end
			end
		else
			if not (exports.global:hasItem(thePlayer, 2, tonumber(phoneNumber))) then
				outputChatBox("You don't own this phone number", thePlayer, 255, 0, 0)
				return
			end
		end
		local calledphoneIsTurnedOn = 0
		local phoneSettings = mysql:query_fetch_assoc("SELECT * FROM `phone_settings` WHERE `phonenumber`='"..mysql:escape_string(tostring(phoneNumber)).."'")
		if not phoneSettings then
			mysql:query_free("INSERT INTO `phone_settings` (`phonenumber`) VALUES ('".. mysql:escape_string(tostring(phoneNumber)) .."')")
		else
			calledphoneIsTurnedOn = tonumber(phoneSettings["turnedon"]) or 0
		end
		if getElementData( thePlayer, "calling" ) then
			outputChatBox("You are using your phone!", thePlayer, 255, 0, 0)
		else
			if calledphoneIsTurnedOn == 0 then
				outputChatBox("You switched your phone with number '"..tostring(phoneNumber).."' on.", thePlayer, 0, 255, 0)
			else
				outputChatBox("You switched your phone with number '"..tostring(phoneNumber).."' off.", thePlayer, 255, 0, 0)
			end
			mysql:query_free( "UPDATE `phone_settings` SET `turnedon`='"..( 1 - calledphoneIsTurnedOn ) .."' WHERE `phonenumber`='".. mysql:escape_string(tostring(phoneNumber)) .."'")
		end
	end
end
addCommandHandler("togglephone", togglePhone)

for i = 1, 20 do
	addCommandHandler( "sms" .. tostring( i ), 
		function( thePlayer, commandName, number, ... )
			if i <= exports['item-system']:countItems(thePlayer, 2) then
				sendSMS( thePlayer, commandName, i, number, ... )
			end
		end
	)
end


function setPhoneBook(thePlayer, commandName, phoneNumber, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if logged == 1 then
		if not phoneNumber then
			outputChatBox("Usage: /" .. commandName .. " [phone no.] [text to be found under via /phonebook]", thePlayer, 255, 194, 14)
			return
		end
		
		if tonumber(phoneNumber) < 10 then
			local count = 0
			local items = exports['item-system']:getItems(thePlayer)
			for k, v in ipairs(items) do
				if v[1] == 2 then
					count = count + 1
					if count == phoneNumber then
						phoneNumber = v[2]
						break
					end
				end
			end
		else
			if not (exports.global:hasItem(thePlayer, 2, tonumber(phoneNumber))) then
				outputChatBox("You don't own this phone number", thePlayer, 255, 0, 0)
				return
			end
		end

		local phoneSettings = mysql:query_fetch_assoc("SELECT * FROM `phone_settings` WHERE `phonenumber`='"..mysql:escape_string(tostring(phoneNumber)).."'")
		if not phoneSettings then
			mysql:query_free("INSERT INTO `phone_settings` (`phonenumber`) VALUES ('".. mysql:escape_string(tostring(phoneNumber)) .."')")
		end
		
		local name = (...) and table.concat({...}, " ") or nil
		local success = false
		if name then
			name = name:sub(1, 40)
			success = mysql:query_free( "UPDATE `phone_settings` SET `phonebook`='"..mysql:escape_string(name) .."' WHERE `phonenumber`='".. mysql:escape_string(tostring(phoneNumber)) .."'")
			outputChatBox("You've set your phonebook entry to '" .. name .. "'.", thePlayer, 0, 255, 0)
		else
			success = mysql:query_free( "UPDATE `phone_settings` SET `phonebook`=NULL WHERE `phonenumber`='".. mysql:escape_string(tostring(phoneNumber)) .."'")
			outputChatBox("You've removed your phonebook entry.", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("setphonebook", setPhoneBook)
addCommandHandler("setphonebookname", setPhoneBook)
addCommandHandler("setpbname", setPhoneBook)

function searchForPhone(phoneNumber)
	local found, foundElement = false
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		local logged = getElementData(value, "loggedin")
		if (logged==1) then
			-- Check the new system way, phoneNumber in value
			local foundPhone,_,foundPhoneNumber = exports.global:hasItem(value, 2, tonumber(phoneNumber))
			if foundPhone then
				found = true
				foundElement = value
				break
			else -- Check the old system
				if exports.global:hasItem(value, 2) then
					
					local number = getElementData(value, "cellnumber")
					if (number==tonumber(phoneNumber) and tonumber(number) > 10) then
						found = true
						foundElement = value
						break
					end
				end
				-- End check old system (this piece of obsolete shit needs to be removed once)
			end
		end
	end
	return found, foundElement
end