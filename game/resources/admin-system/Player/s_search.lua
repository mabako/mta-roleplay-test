-- FIND IP --
local function showIPAlts(thePlayer, ip)
	result = mysql:query("SELECT `username`, `lastlogin`, `banned`, `banned_by`,`appstate` FROM `accounts` WHERE `ip` = '" .. mysql:escape_string(ip) .. "' ORDER BY `id` ASC" )
	if result then
		local count = 0
		
		outputChatBox( " IP Address: " .. ip, thePlayer)
		while true do
			local row = mysql:fetch_assoc(result)
			if not row then break end
			
			if row["lastlogin"] == mysql_null() then
				row["lastlogin"] = "Never"
			end
			
			local text = " #" .. count .. ": " .. tostring(row["username"])
			
			if tonumber( row["banned"] ) == 1 then
				text = text .. " (Banned by " .. tostring(row["banned_by"]) .. ")"
			else
				text = text .. " (Last login: " .. tostring(row["lastlogin"]) .. ")"
			end
			
			if tonumber( row["appstate"] ) == 0 then
				text = text .. " (Awaiting App)"
			elseif tonumber( row["appstate"] ) == 1 then
				text = text .. " (Pending App)"
			elseif tonumber( row["appstate"] ) == 2 then
				text = text .. " (Denied App)"
			end
			
			outputChatBox( text, thePlayer)
			
			count = count + 1
		end
		mysql:free_result( result )
	else
		outputChatBox( "Error #9101 - Report on Forums", thePlayer, 255, 0, 0)
	end
end

function findAltAccIP(thePlayer, commandName, ...)
	if exports.global:isPlayerAdmin( thePlayer ) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local targetPlayerName = table.concat({...}, "_")
			local targetPlayer = exports.global:findPlayerByPartialNick(nil, targetPlayerName)
			
			if not targetPlayer or getElementData( targetPlayer, "loggedin" ) ~= 1 then
				-- select by charactername
				local result = mysql:query("SELECT a.`ip` FROM `characters` c LEFT JOIN `accounts` a on c.`account`=a.`id` WHERE c.`charactername` = '" .. mysql:escape_string(targetPlayerName ) .. "'" )
				if result then
					if mysql:num_rows( result ) == 1 then
						local row = mysql:fetch_assoc(result)
						local ip = row["ip"] or '0.0.0.0'
						mysql:free_result( result )
						showIPAlts( thePlayer, ip )
						return
					end
					mysql:free_result( result )
				end
				
				targetPlayerName = table.concat({...}, " ")
				
				-- select by accountname
				local result = mysql:query("SELECT ip FROM accounts WHERE username = '" .. mysql:escape_string(targetPlayerName ) .. "'" )
				if result then
					if mysql:num_rows( result ) == 1 then
						local row = mysql:fetch_assoc(result)
						local ip = row["ip"] or '0.0.0.0'
						mysql:free_result( result )
						showIPAlts( thePlayer, ip )
						return
					end
					mysql:free_result( result )
				end

				-- select by ip
				local result = mysql:query("SELECT ip FROM accounts WHERE ip = '" .. mysql:escape_string( targetPlayerName ) .. "'" )
				if result then
					if mysql:num_rows( result ) >= 1 then
						local row = mysql:fetch_assoc(result2)
						local ip = tonumber( row["ip"] ) or '0.0.0.0'
						mysql:free_result( result )
						showIPAlts( thePlayer, ip )
						return
					end
					mysql:free_result( result )
				end

				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else -- select by online player
				showIPAlts( thePlayer, getPlayerIP(targetPlayer) )
			end
		end
	end
end
addCommandHandler( "findip", findAltAccIP )
-- END FIND IP --

-- START FINDALTS --
local function showAlts(thePlayer, id, creation)
	result = mysql:query("SELECT `charactername`, `cked`, `faction_id`, `lastlogin`, `creationdate`, `hoursplayed` FROM `characters` WHERE `account` = '" .. mysql:escape_string(id) .. "' ORDER BY `charactername` ASC" )
	if result then
		local name = mysql:query_fetch_assoc("SELECT `username`, `banned`, `appstate` FROM `accounts` WHERE `id` = '" .. mysql:escape_string(id) .. "'" )
		if name then
			local uname = name["username"]
			if uname and uname ~= mysql_null() then
				if (tonumber(name["banned"])) == 1 then
					outputChatBox( "WHOIS " .. uname .. ": (BANNED)", thePlayer, 255, 194, 14 )
				else
					outputChatBox( "WHOIS " .. uname .. ": ", thePlayer, 255, 194, 14 )
				end
				
				if (tonumber(name["appsate"])) == 0 then
					outputChatBox( "This account didn't make an application yet.", thePlayer, 255, 0, 0 )
				elseif (tonumber(name["appsate"])) == 1 then
					outputChatBox( "This account has a pending application.", thePlayer, 255, 0, 0 )
				elseif (tonumber(name["appsate"])) == 2 then
					outputChatBox( "This account has a denied application.", thePlayer, 255, 0, 0 )	
				end
			else
				outputChatBox( "?", thePlayer )
			end
		else
			outputChatBox( "?", thePlayer )
		end
		
		local count = 0
		while true do
			local row = mysql:fetch_assoc(result)
			if not row then break end
		
			count = count + 1
			local r = 255
			if getPlayerFromName( row["charactername"] ) then
				r = 0
			end
			
			local text = "#" .. count .. ": " .. row["charactername"]:gsub("_", " ")
			if tonumber( row["cked"] ) == 1 then
				text = text .. " (Missing)"
			elseif tonumber( row["cked"] ) == 2 then
				text = text .. " (Buried)"
			end
			
			if row['lastlogin'] ~= mysql_null() then
				text = text .. " - " .. tostring( row['lastlogin'] )
			end
			
			if creation and row['creationdate'] ~= mysql_null() then
				text = text .. " - Created " .. tostring( row['creationdate'] )
			end
			
			local faction = tonumber( row["faction_id"] ) or 0
			if faction > 0 then
				local theTeam = exports.pool:getElement("team", faction)
				if theTeam then
					text = text .. " - " .. getTeamName( theTeam )
				end
			end
			
			local hours = tonumber(row.hoursplayed)
			if hours and hours > 0 then
				text = text .. " - " .. hours .. " hours"
			end
			
			outputChatBox( text, thePlayer, r, 255, 0)
		end
		mysql:free_result( result )
	else
		outputChatBox( "Error #9102 - Report on Forums", thePlayer, 255, 0, 0)
	end
end

function findAltChars(thePlayer, commandName, ...)
	if exports.global:isPlayerAdmin( thePlayer ) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local creation = commandName == "findalts2"
			local targetPlayerName = table.concat({...}, "_")
			local targetPlayer = targetPlayerName == "*" and thePlayer or exports.global:findPlayerByPartialNick(nil, targetPlayerName)
			
			if not targetPlayer or getElementData( targetPlayer, "loggedin" ) ~= 1 then
				-- select by character name
				local result = mysql:query("SELECT account FROM characters WHERE charactername = '" .. mysql:escape_string(targetPlayerName ) .. "'" )
				if result then
					if mysql:num_rows( result ) == 1 then
						local row = mysql:fetch_assoc(result)
						local id = tonumber( row["account"] ) or 0
						mysql:free_result( result )
						showAlts( thePlayer, id, creation )
						return
					end
					mysql:free_result( result )
				end
				
				targetPlayerName = table.concat({...}, " ")
				
				-- select by account name
				local result = mysql:query("SELECT id FROM accounts WHERE username = '" .. mysql:escape_string( targetPlayerName ) .. "'" )
				if result then
					if mysql:num_rows( result ) == 1 then
						local row = mysql:fetch_assoc(result)
						local id = tonumber( row["id"] ) or 0
						showAlts( thePlayer, id, creation )
						return
					end
					mysql:free_result( result )
				end
				
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local id = getElementData( targetPlayer, "account:id" )
				if id then
					showAlts( thePlayer, id, creation )
				else
					outputChatBox("Game Account is unknown.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler( "findalts", findAltChars )
addCommandHandler( "findalts2", findAltChars )
-- END FINDALTS --

-- START FINDSERIAL --
local function showSerialAlts(thePlayer, serial)
	result = mysql:query("SELECT `username`, `lastlogin`, `banned`, `banned_by`,`appstate` FROM accounts WHERE mtaserial = '" .. mysql:escape_string(serial) .. "'" )
	if result then
		local count = 0
		local continue = true
		while continue do
			local row = mysql:fetch_assoc(result)
			if not row then break end
			count = count + 1
			if (count == 1) then
				outputChatBox( " Serial: " .. serial, thePlayer)
			end
			
			local text = "#" .. count .. ": " .. row["username"]
			if tonumber( row["banned"] ) == 1 then
				text = text .. " (Banned by " .. row["banned_by"] .. ")"
			else
				text = text .. " (Last login: " .. row["lastlogin"] .. ")"
			end
			
			if tonumber( row["appstate"] ) == 0 then
				text = text .. " (Awaiting App)"
			elseif tonumber( row["appstate"] ) == 1 then
				text = text .. " (Pending App)"
			elseif tonumber( row["appstate"] ) == 2 then
				text = text .. " (Denied App)"
			end

			outputChatBox( text, thePlayer)
		end
		mysql:free_result( result )
	else
		outputChatBox( "Error #9101 - Report on Forums", thePlayer, 255, 0, 0)
	end
end

function findAltAccSerial(thePlayer, commandName, ...)
	if exports.global:isPlayerAdmin( thePlayer ) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Nick/Serial]", thePlayer, 255, 194, 14)
		else
			local targetPlayerName = table.concat({...}, "_")
			local targetPlayer = exports.global:findPlayerByPartialNick(nil, targetPlayerName)
			
			if not targetPlayer then --or getElementData( targetPlayer, "loggedin" ) ~= 1 then
				
				
				-- select by charactername
				local result = mysql:query("SELECT a.`mtaserial` FROM `characters` c LEFT JOIN `accounts` a on c.`account`=a.`id` WHERE c.`charactername` = '" .. mysql:escape_string(targetPlayerName ) .. "'" )
				if result then
					if mysql:num_rows( result ) == 1 then
						local row = mysql:fetch_assoc(result)
						local serial = row["mtaserial"] or 'UnknownSerial'
						mysql:free_result( result )
						showSerialAlts( thePlayer, serial )
						return
					end
					mysql:free_result( result )
				end
				
				targetPlayerName = table.concat({...}, " ")
				
				-- select by accountname
				local result = mysql:query("SELECT `mtaserial` FROM `accounts` WHERE `username` = '" .. mysql:escape_string(targetPlayerName ) .. "'" )
				if result then
					if mysql:num_rows( result ) == 1 then
						local row = mysql:fetch_assoc(result)
						local serial = row["mtaserial"] or 'UnknownSerial'
						mysql:free_result( result )
						showSerialAlts( thePlayer, serial)
						return
					end
					mysql:free_result( result )
				end
				
				-- select by ip
				local result = mysql:query("SELECT `mtaserial` FROM `accounts` WHERE `ip` = '" .. mysql:escape_string( targetPlayerName ) .. "'" )
				if result then
					if mysql:num_rows( result ) >= 1 then
						local row = mysql:fetch_assoc(result)
						local serial = row["mtaserial"] or 'UnknownSerial'
						mysql:free_result( result )
						showSerialAlts( thePlayer, serial )
						return
					end
					mysql:free_result( result )
				end
				
				-- select by serial
				local result = mysql:query("SELECT `mtaserial` FROM `accounts` WHERE `mtaserial` = '" .. mysql:escape_string( targetPlayerName ) .. "'" )
				if result then
					if mysql:num_rows( result ) >= 1 then
						local row = mysql:fetch_assoc(result)
						local serial = row["mtaserial"] or 'UnknownSerial'
						mysql:free_result( result )
						showSerialAlts( thePlayer, serial )
						return
					end
					mysql:free_result( result )
				end
				
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else -- select by online player
				showSerialAlts( thePlayer, getPlayerSerial(targetPlayer) )
			end
		end
	end
end
addCommandHandler( "findserial", findAltAccSerial )
-- END FINDSERIAL --