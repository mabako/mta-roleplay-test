mysql = exports.mysql

-- function adds a new suspect to the database, where the details are stored in the table, "details"
function addNewSuspectToDatabase(details)

	-- check to see if the suspect is already in the database
	local result = mysql:query("SELECT suspect_name FROM suspectDetails WHERE suspect_name='" .. mysql:escape_string(details[1]) .. "'")
	local name
	if (mysql:num_rows(result)>0) then
		name = "exists"
	else
		name = nil
	end
	mysql:free_result(result)
	
	-- if the player has attached a photo, get the suspects skin
	if (details[9] ) then
	
		local suspect
		
		suspect = getPlayerFromName ( details[1]	)
		
		if not (suspect == false) then
			local skin= getPedSkin(suspect)
			
			if(skin <10) then
				details[9] = "00"..skin
			elseif(skin >= 10 and skin < 100) then
				details[9] = "0"..skin
			else
				details[9] = skin
			end
			
		else
			details[9] = "nil"
		end
		
	else
		details[9] = "nil"
	end
	
	-- if player is not already in the database, insert them
	
	if (name==nil) then
		mysql:query_free("INSERT INTO suspectDetails SET suspect_name='" .. mysql:escape_string(details[1]) .. "', birth='" .. mysql:escape_string(details[2]) .. "', gender='" .. mysql:escape_string(details[3]) .. "', ethnicy='" .. mysql:escape_string(details[4]) .. "', cell='" .. mysql:escape_string((tonumber(details[5]) or 0)) .. "', occupation='" .. mysql:escape_string(details[6]) .. "', address='" .. mysql:escape_string(details[7]) .. "', other='" .. mysql:escape_string(details[8]) .. "', is_wanted='0', wanted_reason='None', wanted_punishment='None', wanted_by='None', photo='" .. mysql:escape_string(details[9]) .. "', done_by='" .. mysql:escape_string(details[10]) .. "'")
	end
end
addEvent("onAddNewSuspect", true)
addEventHandler("onAddNewSuspect", getRootElement(), addNewSuspectToDatabase)

-- function adds a new suspect to the database, where the details are stored in the table, "details"
function addUpdateSuspectToDatabase(details)

	-- check to see if the suspect is already in the database
	local result = mysql:query_fetch_assoc("SELECT suspect_name FROM suspectDetails WHERE suspect_name='" .. mysql:escape_string(details[1]) .. "'")
	local name = result["suspect_name"]
	
	local updatePhoto = details[9]
	
	-- if the player has attached a photo, get the suspects skin
	if (updatePhoto ) then
	
		local suspect
		suspect = getPlayerFromName ( details[1]	)
		
		if not (suspect == false) then
			local skin= getElementModel(suspect)
			
			if(skin <10) then
				details[9] = "00"..skin
			elseif(skin >= 10 and skin < 100) then
				details[9] = "0"..skin
			else
				details[9] = skin
			end
		else
			details[9] = "nil"
		end
	end
	
	--if player is already in the database, updatethem
	if (name) then
	
		local sucess
		
		-- build our query
		local query = "UPDATE suspectDetails SET birth='" ..  mysql:escape_string(details[2]) .. "', gender='" ..  mysql:escape_string(details[3]) .. "', ethnicy='" ..  mysql:escape_string(details[4]) .. "', cell='" ..  mysql:escape_string(details[5]) .. "', occupation='" ..  mysql:escape_string(details[6]) .. "', address='" ..  mysql:escape_string(details[7]) .. "', other='" ..  mysql:escape_string(details[8]) .. "', done_by='" ..  mysql:escape_string(details[10]) .. "'"
		if(updatePhoto) then
			query = query .. ", photo='" ..  mysql:escape_string(details[9]) .. "'"
		end
		query = query .. " WHERE suspect_name='" ..  mysql:escape_string(details[1]) .. "'"
		mysql:query_free(query)
		
		if(sucess) then
			-- get the new details and send them back to the client
			local result = mysql:query_fetch_assoc("SELECT suspect_name, birth, gender, ethnicy, cell, occupation, address, otherphoto, done_by FROM suspectDetails WHERE suspect_name='" .. mysql:escape_string(details[1]) .. "' LIMIT 1")
			
			-- backwards compatability for jasons code...
			local tableresult = { }
			tableresult[1] = { }
			tableresult[1][1] = result["suspect_name"]
			tableresult[1][2] = result["birth"]
			tableresult[1][3] = result["gender"]
			tableresult[1][4] = result["ethnicy"]
			tableresult[1][5] = result["cell"]
			tableresult[1][6] = result["occupation"]
			tableresult[1][7] = result["address"]
			tableresult[1][8] = result["otherphoto"]
			tableresult[1][9] = result["done_by"]
			
			triggerClientEvent(client, "onSaveSuspectDetailsClient", client, details[1] , tableresult)
		end
	else -- output error message
		outputChatBox("~~ Could not update since you changed the name of the suspect ~~", client, 255, 0 ,0 , true)
	end

end
addEvent("onUpdateSuspectDetails", true)
addEventHandler("onUpdateSuspectDetails", getRootElement(), addUpdateSuspectToDatabase)


-- function gets the details of the suspects name provided from the database
function getSuspectDetails(suspectName)

	-- get the details
	local result = mysql:query_fetch_assoc("SELECT suspect_name, birth, gender, ethnicy, cell, occupation, address, other, is_wanted, wanted_punishment, wanted_by, photo, done_by FROM suspectDetails WHERE suspect_name='" .. mysql:escape_string(suspectName) .. "' LIMIT 1")
	
	-- send the details to the client
	if(result) then
		local tableresult = { }
		tableresult[1] = { }
		tableresult[1][1] = result["suspect_name"]
		tableresult[1][2] = result["birth"]
		tableresult[1][3] = result["gender"]
		tableresult[1][4] = result["ethnicy"]
		tableresult[1][5] = result["cell"]
		tableresult[1][6] = result["occupation"]
		tableresult[1][7] = result["address"]
		tableresult[1][8] = result["other"]
		tableresult[1][9] = result["is_wanted"]
		tableresult[1][10] = result["wanted_punishment"]
		tableresult[1][11] = result["wanted_by"]
		tableresult[1][12] = result["photo"]
		tableresult[1][13] = result["done_by"]
		triggerClientEvent(client, "onSaveSuspectDetailsClient", client, suspectName, tableresult, 1)
	else
		triggerClientEvent(client, "onSaveSuspectDetailsClient", client, suspectName, nil, 1 )
	end

end
addEvent("onGetSuspectDetails", true)
addEventHandler("onGetSuspectDetails", getRootElement(), getSuspectDetails)

local vehicleColors = {
	"white", "blue", "red", "dark green", "purple",
	"yellow", "blue", "gray", "blue", "silver",
	"gray", "blue", "dark gray", "silver", "gray",
	"green", "red", "red", "gray", "blue",
	"red", "red", "gray", "dark gray", "dark gray",
	"silver", "brown", "blue", "silver", "brown",
	"red", "blue", "gray", "gray", "dark gray",
	"black", "green", "light green", "blue", "black",
	"brown", "red", "red", "green", "red",
	"pale", "brown", "gray", "silver", "gray",
	"green", "blue", "dark blue", "dark blue", "brown",
	"silver", "pale", "red", "blue", "gray",
	"brown", "red", "silver", "silver", "green",
	"dark red", "blue", "pale", "light pink", "red",
	"blue", "brown", "light green", "red", "black",
	"silver", "pale", "red", "blue", "dark red",
	"purple", "dark red", "dark green", "dark brown", "purple",
	"green", "blue", "red", "pale", "silver",
	"dark blue", "gray", "blue", "blue", "blue",
	"silver", "light blue", "gray", "pale", "blue",
	"black", "pale", "blue", "pale", "gray",
	"blue", "pale", "blue", "dark gray", "brown",
	"silver", "blue", "dark brown", "dark green", "red",
	"dark blue", "red", "silver", "dark brown", "brown",
	"red", "gray", "brown", "red", "blue",
	"pink", [0] = "black" }
	
local function vehicleColor( c1, c2 )
	local color1 = vehicleColors[ c1 ] or "Unknown"
	local color2 = vehicleColors[ c2 ] or "Unknown"
	
	if color1 ~= color2 then
		return color1 .. " & " .. color2
	else
		return color1
	end
end

-- function gets the details of the vehicle
function onGetVehicleDetails(vehiclePlate)
	local result = mysql:query_fetch_assoc("SELECT `id`, `model`, `color1`, `color2`, `plate`, `owner`,`Impounded` FROM `vehicles` WHERE plate='" .. mysql:escape_string(vehiclePlate) .. "' LIMIT 1")
	-- send the details to the client
	if(result) then
		local tableresult = { }
		tableresult[1] = { }
		tableresult[1][1] = getVehicleNameFromModel(tonumber(result["model"]))	-- Vehicle name
		if not exports['vehicle-system']:hasVehiclePlates(tonumber(result.model)) then
			return
		end
		tableresult[1][2] = exports.cache:getCharacterName(result["owner"])		-- Registered owner
		tableresult[1][3] = vehicleColor(tonumber(result["color1"]), tonumber(result["color2"]))		-- Colors
		tableresult[1][4] = result["plate"]		-- Plate
		tableresult[1][5] = tostring(result["id"])		-- ID/Chassis number
		triggerClientEvent(client, "onSaveSuspectDetailsClient", client, result["plate"], tableresult, 2)
		
		local carCrimes = {}
		local result2 = mysql:query("SELECT * FROM `speedingviolations` WHERE `carID`="..mysql:escape_string(tostring(result["id"])))
		while true do
			local row = mysql:fetch_assoc(result2)
			if not row then break end
			local tempArr = {}
			tempArr[1] = row["id"]
			tempArr[2] = tableresult[1][4]
			tempArr[3] = row["time"]
			tempArr[4] = row["speed"]
			tempArr[5] = row["area"]

			if row["personVisible"] == -1 then
				tempArr[6] = "Not visible"
			else
				tempArr[6] = exports.cache:getCharacterName(row["personVisible"]) or "Not visible"
			end
			carCrimes [ #carCrimes + 1 ] = tempArr
		end	
		triggerClientEvent(client, "onClientSaveSuspectCrimes", client, carCrimes)
		
	else
		triggerClientEvent(client, "onSaveSuspectDetailsClient", client, suspectName, nil, 2  )
	end
	

end
addEvent("onGetVehicleDetails", true)
addEventHandler("onGetVehicleDetails", getRootElement(), onGetVehicleDetails)

-- function gives the client all the player who are currently wanted
function getSuspectWhoAreWanted()
	
	-- get the details
	local result = mysql:query("SELECT suspect_name FROM suspectDetails WHERE is_wanted='1'")
	
	if (mysql:num_rows(result)>0) then
		-- backwards compatability for jasons code...
		local tableresult = { }
		local tablecount = 1
		while true do
			local row = mysql:fetch_assoc(result)
			if (not row) then break end
			tableresult[tablecount] = { }
			tableresult[tablecount][1] = row["suspect_name"]
			tablecount = tablecount + 1
		end
		triggerClientEvent(client, "onSaveSuspectWantedClient", client, tableresult)
	else
		triggerClientEvent(client, "onSaveSuspectWantedClient", client, nil )
	end
	mysql:free_result(result)
	
end
addEvent("onGetWantedSuspects", true)
addEventHandler("onGetWantedSuspects", getRootElement(), getSuspectWhoAreWanted)


-- function updates the suspects warrant details
function addUpdateSuspectWarrantToDatabase(warrantDetails)
	-- check to see if the suspect is already in the database
	local result = mysql:query_fetch_assoc("SELECT suspect_name FROM suspectDetails WHERE suspect_name='" .. mysql:escape_string(warrantDetails[1]) .. "'")
	local name = result["suspect_name"]
	
	--if player is already in the database, updatethem
	if (name) then
		mysql:query_free("UPDATE suspectDetails SET is_wanted = '"..mysql:escape_string(warrantDetails[2]).."', wanted_reason = '"..mysql:escape_string(warrantDetails[3]).."', wanted_punishment = '"..mysql:escape_string(warrantDetails[4]).."', wanted_by = '"..mysql:escape_string(warrantDetails[5]).."' WHERE suspect_name = '"..mysql:escape_string(warrantDetails[1]).. "'")
	end

end
addEvent("onUpdateSuspectWarrantDetails", true)
addEventHandler("onUpdateSuspectWarrantDetails", getRootElement(), addUpdateSuspectWarrantToDatabase)


-- function saves a crime to the database
function saveCrime(details)
	if(string.len(details[12]) > 350) then
		outputChatBox("Too much information passed, unable to save crime - please add again.", client, 255, 0 ,0, true)
	else
		-- insert the crimes
		mysql:query_free("INSERT INTO suspectCrime SET suspect_name='" .. mysql:escape_string(details[1]) .. "', time='" .. mysql:escape_string(details[2]) .. "', date='" .. mysql:escape_string(details[3]) .. "', officers='" .. mysql:escape_string(details[4]) .. "', ticket='" .. mysql:escape_string(details[5]) .. "', arrest='" .. mysql:escape_string(details[6]) .. "', fine='" .. mysql:escape_string(details[7]) .. "', ticket_price='" .. mysql:escape_string(details[8]) .. "', arrest_price='" .. mysql:escape_string(details[9]) .. "', fine_price='" .. mysql:escape_string(details[10]) .. "', illegal_items='" .. mysql:escape_string(details[11]) .. "', details='" .. mysql:escape_string(details[12]) .. "', done_by='" .. mysql:escape_string(details[13]) .. "'")

		outputChatBox("Crime added sucessfully.", client, 0, 255 ,0, true)
	end
end
addEvent("onSaveSuspectCrime", true)
addEventHandler("onSaveSuspectCrime", getRootElement(), saveCrime)


-- function returns all of the crimes for a suspect to the player
function getSuspectCrime(name)
	local result = mysql:query("SELECT id, suspect_name, time, date, officers, ticket, arrest, fine, ticket_price, arrest_price, fine_price, illegal_items, details, done_by FROM suspectCrime WHERE suspect_name='" .. mysql:escape_string(name) .. "'")
	
	if (result) then
		if (mysql:num_rows(result)>0) then
			-- backwards compatability for jasons code...
			local tableresult = { }
			local tablecount = 1
			while true do
				local row = mysql:fetch_assoc(result)
				if (not row) then break end
				tableresult[tablecount] = { }
				tableresult[tablecount][1] = row["id"]
				tableresult[tablecount][2] = row["suspect_name"]
				tableresult[tablecount][3] = row["time"]
				tableresult[tablecount][4] = row["date"]
				tableresult[tablecount][5] = row["officers"]
				tableresult[tablecount][6] = row["ticket"]
				tableresult[tablecount][7] = row["arrest"]
				tableresult[tablecount][8] = row["fine"]
				tableresult[tablecount][9] = row["ticket_price"]
				tableresult[tablecount][10] = row["arrest_price"]
				tableresult[tablecount][11] = row["fine_price"]
				tableresult[tablecount][12] = row["illegal_items"]
				tableresult[tablecount][13] = row["details"]
				tableresult[tablecount][14] = row["done_by"]
				
				tablecount = tablecount + 1
			end
			triggerClientEvent("onClientSaveSuspectCrimes", client, tableresult)
		else
			triggerClientEvent("onClientSaveSuspectCrimes", client, nil)
		end
		mysql:free_result(result)
	end

end
addEvent("onGetSuspectCrimes", true)
addEventHandler("onGetSuspectCrimes", getRootElement(), getSuspectCrime)


-- function deletes a crime from the database
function deleteCrime(crimeID)
	mysql:query_free("DELETE FROM suspectCrime WHERE id='" .. mysql:escape_string(tonumber(crimeID)) .. "'")
end
addEvent("onDeleteCrime", true)
addEventHandler("onDeleteCrime", getRootElement(), deleteCrime)



-- function check to see if the user is in the database when the client logs in
function clientLogIn(logInDetails)

	-- get the log in details for the client
	local result = mysql:query_fetch_assoc("SELECT user_name,password,high_command FROM mdcUsers WHERE user_name='" .. mysql:escape_string(tostring(logInDetails[1])) .. "' and password='".. mysql:escape_string(tostring(logInDetails[2])) .."' LIMIT 1")
	
	if(result) then
		local tableresult = { }
		tableresult[1] = { }
		tableresult[1][1] = result["user_name"]
		tableresult[1][2] = result["password"]
		tableresult[1][3] = result["high_command"]
		triggerClientEvent("onCorrectLogInDetails", client, tableresult)
	else
		triggerClientEvent("onFalseLogInDetails", client, tableresult)
	end
end
addEvent("onClientLogInToMDC", true)
addEventHandler("onClientLogInToMDC", getRootElement(), clientLogIn)

-- function updates the users account details
function UpdateAccount(details)
	mysql:query_free("UPDATE mdcUsers SET password = '"..mysql:escape_string(details[2]).."', high_command = '"..mysql:escape_string(details[3]).."' WHERE user_name = '"..mysql:escape_string(details[1]).."'")
end
addEvent("onUpdateAccount", true)
addEventHandler("onUpdateAccount", getRootElement(), UpdateAccount)

-- function updates the users account details
function CreateAccount(details)
	local result = mysql:query("SELECT user_name FROM mdcUsers where user_name='" .. mysql:escape_string(details[1]) .. "'")
	
	if not (mysql:num_rows(result)>0) then
		mysql:query_free("INSERT INTO mdcUsers SET user_name='" .. mysql:escape_string(details[1]) .. "', password='" .. mysql:escape_string(details[2]) .. "', high_command='" .. mysql:escape_string(details[3]) .. "'")
		outputChatBox("Account: "..details[1].." with password "..details[2].." and high command limits: '"..details[3].."' sucessfully created.", client, 0, 255, 0, true)
	else
		outputChatBox("Unable to create the account: "..details[1].." since it already exists in the database.", client, 255, 0, 0, true)
	end
	mysql:free_result(result)
end
addEvent("onCreateAccount", true)
addEventHandler("onCreateAccount", getRootElement(), CreateAccount)

-- function removes the user from the database
function RemoveAccount(details)
	local result = mysql:query("SELECT user_name FROM mdcUsers where user_name='" .. mysql:escape_string(details[1]) .. "'")
	
	if (mysql:num_rows(result)>0) then
		mysql:query_free("DELETE FROM mdcUsers WHERE user_name='" .. mysql:escape_string(details[1]) .. "'")
		outputChatBox("Account: "..details[1].." has been removed from the database.", client, 0, 255, 0, true)
	else
		outputChatBox("Unable to remove the account: "..details[1].." since it does not exist in the database.", client, 255, 0, 0, true)
	end
	mysql:free_result(result)
end
addEvent("onRemoveAccount", true)
addEventHandler("onRemoveAccount", getRootElement(), RemoveAccount)


function getAccountInfo(account)
	local result = mysql:query_fetch_assoc("SELECT user_name, password, high_command FROM mdcUsers WHERE user_name='" .. mysql:escape_string(account) .. "'")
	if(result) then
		-- backwards compatability for jasons code...
		local tableresult = { }
		tableresult[1] = { }
		tableresult[1][1] = result["user_name"]
		tableresult[1][2] = result["password"]
		tableresult[1][3] = result["high_command"]
		triggerClientEvent("onSaveUserAccountDetails", client, tableresult)
	end
end
addEvent("onGetAccountInfo", true)
addEventHandler("onGetAccountInfo", getRootElement(), getAccountInfo)


-- function gets all of the active  user accounts and their high command limits, and sends it to the client
function getAllAccountInfo()
	local result = mysql:query("SELECT user_name, high_command FROM mdcUsers")

	if(result) then
		-- backwards compatability for jasons code...
		local tableresult = { }
		
		local count = 1
		local continue = true
		while continue do
			row = mysql:fetch_assoc(result)
			if not row then break end
			tableresult[count] = { }
			tableresult[count][1] = row["user_name"]
			tableresult[count][2] = row["high_command"]
			count = count + 1
		end
		mysql:free_result(result)
		triggerClientEvent("onSaveAllAccounts", client, tableresult)
	end
end
addEvent("onGetAllAccounts", true)
addEventHandler("onGetAllAccounts", getRootElement(), getAllAccountInfo)


function getAllSuspects()
	local result = mysql:query("SELECT suspect_name, done_by FROM suspectDetails")

	-- backwards compatability for jasons code...
	local tableresult = { }
		
	local count = 1
	local continue = true
	while continue do
		row = mysql:fetch_assoc(result)
		if not row then break end
		tableresult[count] = { }
		tableresult[count][1] = row["suspect_name"]
		tableresult[count][2] = row["done_by"]
		count = count + 1
	end
	mysql:free_result(result)
	triggerClientEvent("onSaveAllSuspects", client, tableresult)
end
addEvent("onGetAllSuspects", true)
addEventHandler("onGetAllSuspects", getRootElement(), getAllSuspects)


-- function gets all of the active  user accounts and their high command limits, and sends it to the client
function deleteSuspect(name)
	local result = mysql:query("SELECT suspect_name FROM suspectDetails WHERE suspect_name='" .. mysql:escape_string(tostring(name)) .. "'")
	
	if (mysql:num_rows(result)>0) then
		mysql:query_free("DELETE FROM suspectDetails WHERE suspect_name='" .. mysql:escape_string(name) .. "'")
		mysql:query_free("DELETE FROM suspectCrime WHERE suspect_name='" ..mysql:escape_string(name) .. "'")
		outputChatBox("Sucessfull deletion of suspect: "..name..", including all of their crimes.", client, 0, 255, 0, true)
	else
		outputChatBox("Could not delete suspect "..name.." since they do not exist in the database.", client, 255, 0, 0, true)
	end
	mysql:free_result(result)
end
addEvent("onDeleteSuspect", true)
addEventHandler("onDeleteSuspect", getRootElement(), deleteSuspect)