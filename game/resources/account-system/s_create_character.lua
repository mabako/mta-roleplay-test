local mysql = exports.mysql

function newCharacter_create(characterName, characterDescription, race, gender, skin, height, weight, age, languageselected)
	if not (checkValidCharacterName(characterName)) then
		triggerClientEvent(client, "accounts:characters:new", client, 1, 1) -- State 1:1: error validating data
		return
	end

	if not (race > -1 and race < 3) then
		triggerClientEvent(client, "accounts:characters:new", client, 1, 2) -- State 1:2: error validating data
		return
	end
	
	if not (gender == 0 or gender == 1) then
		triggerClientEvent(client, "accounts:characters:new", client, 1, 3) -- State 1:3: error validating data
		return
	end
	
	if not skin then
		triggerClientEvent(client, "accounts:characters:new", client, 1, 4) -- State 1:4: error validating data
		return
	end
	
	if not (height < 201 and height > 149) then
		triggerClientEvent(client, "accounts:characters:new", client, 1, 5) -- State 1:5: error validating data
		return
	end
	
	if not (weight < 200 and weight > 49) then
		triggerClientEvent(client, "accounts:characters:new", client, 1, 6) -- State 1:6: error validating data
		return
	end
	
	if not (age > 17 and age < 101) then
		triggerClientEvent(client, "accounts:characters:new", client, 1, 7) -- State 1:7: error validating data
		return
	end
	
	if not tonumber(languageselected) then
		triggerClientEvent(client, "accounts:characters:new", client, 1, 8) -- State 1:8: error validating data
		return
	end
	
	characterName = string.gsub(tostring(characterName), " ", "_")
	characterName = mysql:escape_string(characterName)
	
	if #characterDescription < 50 or #characterDescription > 128 then
	triggerClientEvent(client, "accounts:characters:new", client, 1, 9) -- State 1:9: error validating data
		return
	end
	characterDescription = mysql:escape_string(characterDescription)
	
	local mQuery1 = mysql:query("SELECT charactername FROM characters WHERE charactername='" .. characterName .. "'")
	if (mysql:num_rows(mQuery1)>0) then 
		mysql:free_result(mQuery1)
		triggerClientEvent(client, "accounts:characters:new", client, 2, 1) -- State 2:1: Name already in use
		return
	end
	mysql:free_result(mQuery1)
	
	local accountID = getElementData(client, "account:id")
	local accountUsername = getElementData(client, "account:username")
	local fingerprint = md5(characterName .. characterDescription .. accountID .. race .. gender .. age)
	
	local id = mysql:query_insert_free("INSERT INTO characters SET charactername='" .. characterName .. "', lastarea='Unity Bus Station', gender='" .. mysql:escape_string(gender) .. "', skincolor='" .. mysql:escape_string(race) .. "', weight='" .. mysql:escape_string(weight) .. "', height='" .. mysql:escape_string(height) .. "', description='" .. mysql:escape_string(characterDescription) .. "', account='" .. mysql:escape_string(accountID) .. "', skin='" .. mysql:escape_string(skin) .. "', age='" .. mysql:escape_string(age) .. "', fingerprint='" .. mysql:escape_string(fingerprint) .. "', lang1=" .. mysql:escape_string(languageselected) .. ", lang1skill=100, currLang=1" )
		
	if (id) then -- 
		exports.logs:dbLog("ac"..tostring(accountID), 27, { "ac"..tostring(accountID), "ch" .. id } , "Created" )

		exports['anticheat-system']:changeProtectedElementDataEx(client, "dbid", id, false)
		exports.global:giveItem( client, 16, skin )
		exports.global:giveItem( client, 17, 1 )
		exports.global:giveItem( client, 18, 1 )
		exports['anticheat-system']:changeProtectedElementDataEx(client, "dbid")

		-- CELL PHONE
		local cellnumber = id+15000
		local update = mysql:query_free("UPDATE characters SET cellnumber='" .. mysql:escape_string(cellnumber) .. "' WHERE id='" .. id .. "'")
			
		if (update) then
			triggerClientEvent(client, "accounts:characters:new", client, 3, tonumber(id)) -- State 3:<var>: Spic win!
		else
			triggerClientEvent(client, "accounts:characters:new", client, 2, 3) -- State 2:3: Cannot update data
		end
	else
		triggerClientEvent(client, "accounts:characters:new", client, 2, 2) -- State 2:2: Failed to update database
	end
end
addEventHandler("accounts:characters:new", getRootElement(), newCharacter_create)