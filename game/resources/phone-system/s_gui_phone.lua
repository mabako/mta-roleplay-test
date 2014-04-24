addEvent("phone:requestShowPhoneGUI", true)
function requestPhoneGUI(itemValue, newSource)
	if newSource then
		client = newSource
	end

	local contactList = { }
	local ownCellnumber = tonumber (itemValue)

	if not ownCellnumber or ownCellnumber < 10 then
		return
	end
	
	local phoneSettings = mysql:query_fetch_assoc("SELECT * FROM `phone_settings` WHERE `phonenumber`='"..mysql:escape_string(tostring(ownCellnumber)).."'")
	if not phoneSettings then
		mysql:query_free("INSERT INTO `phone_settings` (`phonenumber`) VALUES ('".. mysql:escape_string(tostring(ownCellnumber)) .."')")
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
	
	if callerphoneIsTurnedOn == 0 then
		outputChatBox("You take your phone out, but notice it is turned off.", client, 255,0,0)
		outputChatBox("((/togglephone "..ownCellnumber.." to turn it on))", client, 255,0,0)
		return
	end
	
	local mQuery1 = mysql:query("SELECT `entryName`, `entryNumber` from `phone_contacts` WHERE `phone`='".. mysql:escape_string( ownCellnumber ) .."'")
	while true do
		local row = mysql:fetch_assoc(mQuery1)
		if not row then break end
		table.insert(contactList, { row["entryName"], tostring(row["entryNumber"]) } )
	end
	mysql:free_result(mQuery1)
	triggerClientEvent(client, "phone:showPhoneGUI", client, tostring(ownCellnumber), contactList)
end
addEventHandler("phone:requestShowPhoneGUI", getRootElement(), requestPhoneGUI)
--
addEvent("phone:addContact", true)
function addPhoneContact(name, number, phoneBookPhone)
	if (client) then
		if not phoneBookPhone then
			return
		end
		
		local ownCellnumber = getElementData(client, "cellnumber")
		if not exports.global:hasItem(client,2, tonumber(phoneBookPhone)) and tonumber(ownCellnumber) ~= tonumber(phoneBookPhone) then
			return
		end
		
		if name and number then
			if tonumber(number) then
				local result = mysql:query_free("INSERT INTO `phone_contacts` (`phone`, `entryName`, `entryNumber`) VALUES ('" ..  mysql:escape_string(tostring(phoneBookPhone)).."', '".. mysql:escape_string(name) .."', '".. mysql:escape_string(number) .."')")
				if result then
					requestPhoneGUI(phoneBookPhone, client)
					return
				end
			end
		end
		outputChatBox("Error, please try it again.", client, 255,0,0)
	end
end
addEventHandler("phone:addContact", getRootElement(), addPhoneContact)
--
addEvent("phone:deleteContact", true)
function deletePhoneContact(name, number, phoneBookPhone)
	if (client) then
		if not phoneBookPhone then
			return
		end
		
		local ownCellnumber = getElementData(client, "cellnumber")
		if not exports.global:hasItem(client,2, tonumber(phoneBookPhone)) and tonumber(ownCellnumber) ~= tonumber(phoneBookPhone) then
			return
		end
		if name and number then
			if tonumber(number) then
				local result = mysql:query_free("DELETE FROM `phone_contacts` WHERE `phone`='" ..  mysql:escape_string(phoneBookPhone).."' AND `entryName`='".. mysql:escape_string(name) .."' AND `entryNumber`='".. mysql:escape_string(number) .."'")
				if result then
					requestPhoneGUI(phoneBookPhone, client)
					return
				end
			end
		end
		outputChatBox("Error, please try it again.", client, 255,0,0)
	end
end
addEventHandler("phone:deleteContact", getRootElement(), deletePhoneContact)

function saveCurrentRingtone(itemValue, phoneBookPhone)
	if client and itemValue then
		if not phoneBookPhone then
			outputChatBox("one")
			return
		end
		
		local ownCellnumber = getElementData(client, "cellnumber")
		if not exports.global:hasItem(client,2, tonumber(phoneBookPhone)) and tonumber(ownCellnumber) ~= tonumber(phoneBookPhone) then
			outputChatBox("two")
			return
		end
		
		if not tonumber(itemValue) then
			outputChatBox("three")
			return
		end

		local result = mysql:query_free("UPDATE `phone_settings` SET `ringtone`='" ..  mysql:escape_string(itemValue).."' WHERE `phonenumber`='"..mysql:escape_string(phoneBookPhone).."'")
		if not result then
			outputChatBox("Error, please try it again.", client, 255,0,0)
			return
		end
	end
end
addEvent("saveRingtone", true)
addEventHandler("saveRingtone", getRootElement(), saveCurrentRingtone)