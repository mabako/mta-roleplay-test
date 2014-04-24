local mysql = exports.mysql
local salt = "vgrpkeyscotland"

addEventHandler("accounts:login:request", getRootElement(), 
	function ()
		local seamless = getElementData(client, "account:seamless:validated")
		if seamless == true then
			
			outputChatBox("-- Migrated your session after a system restart", client, 0, 200, 0)
			setElementData(client, "account:seamless:validated", false, false, true)
			triggerClientEvent(client, "accounts:options", client)
			triggerClientEvent(client, "item:updateclient", client)
			return
		end
		triggerClientEvent(client, "accounts:login:request", client)
	end
);

addEventHandler("accounts:login:attempt", getRootElement(), 
	function (username, password, wantsLoginHash)
		local accountCheckQueryStr, accountData,newAccountHash,safeusername,safepassword = nil
		local cpypassword = password
		if (string.len(cpypassword) ~= 64) then
			password = md5(salt .. password)
			safeusername = mysql:escape_string(username)
			safepassword = mysql:escape_string(password)
			accountCheckQueryStr = "SELECT `id`,`username`,`banned`,`appstate`,`admin`,`adminduty`,`adminreports`,`hiddenadmin`,`adminjail`,`adminjail_time`,`adminjail_by`,`adminjail_reason`, `monitored` FROM `accounts` WHERE `username`='" .. safeusername .. "' AND `password`='" .. safepassword .. "'"
		else
			safeusername = mysql:escape_string(username)
			safepassword = mysql:escape_string(password)
			accountCheckQueryStr = "SELECT `id`,`username`,`banned`,`appstate`,`admin`,`adminduty`,`adminreports`,`hiddenadmin`,`adminjail`,`adminjail_time`,`adminjail_by`,`adminjail_reason`, `monitored` FROM `accounts` WHERE `username`='" .. safeusername .. "' AND `loginhash`='" .. safepassword .. "'"
		end	
		
		local accountCheckQuery = mysql:query(accountCheckQueryStr)
		if (mysql:num_rows(accountCheckQuery) > 0) then
			accountData = mysql:fetch_assoc(accountCheckQuery)
			mysql:free_result(accountCheckQuery)
			
			
			-- Create a new safety hash, also used for autologin
			local newAccountHash = Login_calculateAutoLoginHash(safeusername)
			setElementDataEx(client, "account:seamlesshash", newAccountHash, false, true)
			if not (wantsLoginHash) then
				newAccountHash = ""
			end
			
			-- Check the account isn't already logged in
			local found = false
			for _, thePlayer in ipairs(exports.pool:getPoolElementsByType("player")) do
				local playerAccountID = tonumber(getElementData(thePlayer, "account:id"))
				if (playerAccountID) then
					if (playerAccountID == tonumber(accountData["id"])) and (thePlayer ~= client) then
						triggerClientEvent(client, "accounts:login:attempt", client, 1, "Account is already logged in." ) 
						return false
					end
				end
			end
			
			-- Check if the account ain't banned
			if (tonumber(accountData["banned"]) == 1) then
				triggerClientEvent(client, "accounts:login:attempt", client, 2, "Account is disabled." ) 
				return
			end
			
			-- Check the application state
			
			if (tonumber(accountData["appstate"]) == 0) then
				triggerClientEvent(client, "accounts:login:attempt", client, 5, "You need to send in an application to play on this server." ) 
				return
			elseif (tonumber(accountData["appstate"]) == 1) then
				triggerClientEvent(client, "accounts:login:attempt", client, 4, "Your application is still pending." ) 
				return
			elseif (tonumber(accountData["appstate"]) == 2) then
				triggerClientEvent(client, "accounts:login:attempt", client, 3, "Your application has been denied, you can remake one at http://mta.vg." ) 
				return
			end
			local forceAppCheckQuery = mysql:query("SELECT `username`,`appstate` FROM `accounts` WHERE `ip`='" .. mysql:escape_string(getPlayerIP(client)) .. "' OR `mtaserial`='" .. mysql:escape_string(getPlayerSerial(client)) .. "'")
			if forceAppCheckQuery then
				while true do
					local forceAppRow = mysql:fetch_assoc(forceAppQuery)
					if not forceAppRow then break end
					if (tonumber(forceAppRow["appstate"]) == 1) then
						triggerClientEvent(client, "accounts:login:attempt", client, 4, "Your application is still pending on account "..forceAppRow["username"].."." ) 
						mysql:free_result(forceAppCheckQuery)
						return
					elseif (tonumber(forceAppRow["appstate"]) == 2) then
						triggerClientEvent(client, "accounts:login:attempt", client, 3, "Your application has been denied on account "..forceAppRow["username"]..", you can remake one at http://mta.vg." ) 
						mysql:free_result(forceAppCheckQuery)
						return
					end
					
				end
			end
			mysql:free_result(forceAppCheckQuery)
			-- Start the magic
			setElementDataEx(client, "account:loggedin", true, true)
			setElementDataEx(client, "account:id", tonumber(accountData["id"]), true) 
			setElementDataEx(client, "account:username", accountData["username"], false)
			
			setElementDataEx(client, "adminreports", accountData["adminreports"], false)
			setElementDataEx(client, "hiddenadmin", accountData["hiddenadmin"], false)
			
			if (tonumber(accountData["admin"]) >= 0) then
				setElementDataEx(client, "adminlevel", tonumber(accountData["admin"]), false)
				setElementDataEx(client, "account:gmlevel", 0, false)
				setElementDataEx(client, "adminduty", accountData["adminduty"], false)
				setElementDataEx(client, "account:gmduty", false, true)
			else
				setElementDataEx(client, "adminlevel", 0, false)
				local GMlevel = -tonumber(accountData["admin"])
				setElementDataEx(client, "account:gmlevel", GMlevel, false)
				if (tonumber(accountData["adminduty"]) == 1) then
					setElementDataEx(client, "account:gmduty", true, true)
				else
					setElementDataEx(client, "account:gmduty", false, true)
				end
			end
			
			if  tonumber(accountData["adminjail"]) == 1 then
				setElementDataEx(client, "adminjailed", true, false)
			else
				setElementDataEx(client, "adminjailed", false, false)
			end
			setElementDataEx(client, "jailtime", tonumber(accountData["adminjail_time"]), false)
			setElementDataEx(client, "jailadmin", accountData["adminjail_by"], false)
			setElementDataEx(client, "jailreason", accountData["adminjail_reason"], false)
			
			if accountData["monitored"] ~= "" then
				setElementDataEx(client, "admin:monitor", accountData["monitored"], false)
			end

			local dataTable = { }
			
			table.insert(dataTable, { "account:newAccountHash", newAccountHash } )
			table.insert(dataTable, { "account:characters", characterList( client ) } )
			triggerClientEvent(client, "accounts:login:attempt", client, 0, dataTable  ) 
			local loginmethodstr = "manually"
			if (string.len(cpypassword) == 64) then
				loginmethodstr = "Autologin - "..cpypassword 
			end
			
			exports.logs:dbLog("ac"..tostring(accountData["id"]), 27, "ac"..tostring(accountData["id"]), "Connected from "..getPlayerIP(client) .. " - "..getPlayerSerial(client) .. " (".. loginmethodstr ..")" )
			mysql:query_free("UPDATE `accounts` SET `ip`='" .. mysql:escape_string(getPlayerIP(client)) .. "', `mtaserial`='" .. mysql:escape_string(getPlayerSerial(client)) .. "' WHERE `id`='".. mysql:escape_string(tostring(accountData["id"])) .."'")	
			triggerEvent( "social:account", client, tonumber( accountData.id ) )
		else
			mysql:free_result(accountCheckQuery)
			triggerClientEvent(client, "accounts:login:attempt", client, 1, "No combination found of the \nentered username/password." ) 
		end
	end
);

function Login_calculateAutoLoginHash(username)
	local finalhash = ""
	local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	for i = 1, 64 do
		local rand = math.random(#chars)
		finalhash = finalhash .. chars:sub(rand, rand)
	end
	mysql:query_free("UPDATE `accounts` SET `loginhash`='".. finalhash .."' WHERE `username`='".. mysql:escape_string(username) .."'")
	return finalhash
end

function quitPlayer(quitReason, reason)
	local accountID = tonumber(getElementData(source, "account:id"))
	if accountID then
		local affected = { "ac"..tostring(accountID) } 
		local dbID = getElementData(source,"dbid")
		if dbID then
			table.insert(affected, "ch"..tostring(dbID))
		end
		exports.logs:dbLog("ac"..tostring(accountID), 27, affected, "Disconnected ("..quitReason or "Unknown reason"..") (Name: "..getPlayerName(source)..")" )
	end
end
addEventHandler("onPlayerQuit",getRootElement(), quitPlayer)