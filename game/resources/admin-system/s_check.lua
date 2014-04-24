function doCheck(sourcePlayer, command, ...)
	if (exports.global:isPlayerAdmin(sourcePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. command .. " [Partial Player Name / ID]", sourcePlayer, 255, 194, 14)
		else
			local noob = exports.global:findPlayerByPartialNick(sourcePlayer, table.concat({...},"_"))
			if (noob) then
				local logged = getElementData(noob, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", sourcePlayer, 255, 0, 0)
				else
					if noob and isElement(noob) then
						local ip = getPlayerIP(noob)
						local adminreports = tonumber(getElementData(noob, "adminreports"))
						local vPoints = nil
						
						-- get admin note
						local note = ""
						local warns = "?"
						local transfers = "?"
						local result = mysql:query_fetch_assoc("SELECT adminnote, warns, credits, transfers FROM accounts WHERE id = " .. mysql:escape_string(tostring(getElementData(noob, "account:id"))) )
						if result then
							local text = result["adminnote"]
							if text ~= mysql_null() then
								note = text
							end
							
							warns = result["warns"] or "?"
							vPoints = result["credits"] or "?"
							transfers = result["transfers"] or "?"
						end
						
						-- count warns
						local result = mysql:query_fetch_assoc("SELECT SUM(`warns`) AS warns FROM `accounts` WHERE mtaserial='" .. mysql:escape_string( getPlayerSerial(noob) ) .."'")
						if result then
							-- has warns on other accounts?
							if result["warns"] ~= warns then
								-- show how many
								warns = warns .. " (" .. result["warns"] .. ")"
							end
						end
						
						-- get admin history count
						local history = {}
						local result = mysql:query("SELECT action, COUNT(*) as numbr FROM adminhistory WHERE user = " .. mysql:escape_string(tostring(getElementData(noob, "account:id"))) .. " GROUP BY action" )
						if result then
							repeat
								row = mysql:fetch_assoc(result)
								if row then
									table.insert(history, {tonumber(row.action), tonumber(row.numbr)})
								end
							until not row
							mysql:free_result(result)
						end
						
						-- hours played on all chars
						local hoursAcc = "N/A"
						local result = mysql:query_fetch_assoc("SELECT SUM(hoursPlayed) AS hours FROM `characters` WHERE account = " .. mysql:escape_string(tostring(getElementData(noob, "account:id"))))
						if result then
							hoursAcc = tonumber(result.hours)
						end
						
						local bankmoney = getElementData(noob, "bankmoney") or -1
						local money = getElementData(noob, "money") or -1
						
						local adminlevel = getElementData(noob, "adminlevel") or 0
						if adminlevel == 0 then
							local gmlevel = getElementData(noob, "account:gmlevel") or 0
							if gmlevel > 0 then
								adminlevel = -gmlevel
							end
						end
						
						local hoursPlayed = getElementData( noob, "hoursplayed" )
						local username = getElementData( noob, "account:username" )
						triggerClientEvent( sourcePlayer, "onCheck", noob, ip, adminreports, vPoints, note, history, warns, transfers, bankmoney, money, adminlevel, hoursPlayed, username, hoursAcc)
					end
				end
			end
		end
	end
end
addCommandHandler("check", doCheck)

function savePlayerNote( target, text )
	if exports.global:isPlayerAdmin(client) then
		local account = getElementData(target, "account:id")
		if account then
			local result = mysql:query_free("UPDATE accounts SET adminnote = '" .. mysql:escape_string( text ) .. "' WHERE id = " .. mysql:escape_string(account) )
			if result then
				outputChatBox( "Note for the " .. getPlayerName( target ):gsub("_", " ") .. " (" .. getElementData( target, "account:username" ) .. ") has been updated.", client, 0, 255, 0 )
			else
				outputChatBox( "Note Update failed.", client, 255, 0, 0 )
			end
		else
			outputChatBox( "Unable to get Account ID.", client, 255, 0, 0 )
		end
	end
end
addEvent( "savePlayerNote", true )
addEventHandler( "savePlayerNote", getRootElement(), savePlayerNote )

function showAdminHistory( target )
	if exports.global:isPlayerAdmin( client ) then
		local targetID = getElementData( target, "account:id" )
		if targetID then
			local result = mysql:query("SELECT date, action, reason, duration, a.username as username, user_char, h.id as recordid FROM adminhistory h LEFT JOIN accounts a ON a.id = h.admin WHERE user = " .. mysql:escape_string(targetID) .. " ORDER BY h.id DESC" )
			if result then
				local info = {}
				local continue = true
				while continue do
					local row = mysql:fetch_assoc(result)
					if not row then break end
					
					local tempr = {}
					tempr[1] = row["date"]
					tempr[2] = row["action"]
					tempr[3] = row["reason"]
					tempr[4] = row["duration"]
					tempr[5] = row["username"]
					tempr[6] = row["user_char"]
					tempr[7] = row["recordid"]
					
					table.insert( info, tempr )
				end
				
				triggerClientEvent( client, "cshowAdminHistory", target, info, tostring( getElementData( target, "account:username" ) ) )
				mysql:free_result( result )
			else
				outputChatBox( "Failed to retrieve history.", client, 255, 0, 0)
			end
		else
			outputChatBox("Unable to find the account id.", client, 255, 0, 0)
		end
	end
end
addEvent( "showAdminHistory", true )
addEventHandler( "showAdminHistory", getRootElement(), showAdminHistory )

function showOfflineAdminHistory( gameaccountid, name )
	if exports.global:isPlayerAdmin( source ) and tonumber(gameaccountid) then
		local targetID = gameaccountid
		local result = mysql:query("SELECT date, action, reason, duration, a.username, user_char, h.id as recordid FROM adminhistory h LEFT JOIN accounts a ON a.id = h.admin WHERE user = " .. mysql:escape_string(targetID) .. " ORDER BY h.id DESC" )
		if result then
			local info = {}
			local continue = true
			while continue do
				local row = mysql:fetch_assoc(result)
				if not row then break end
				local record = {}
				record[1] = row["date"]
				record[2] = row["action"]
				record[3] = row["reason"]
				record[4] = row["duration"]
				record[5] = row["username"]
				record[6] = row["user_char"]
				record[7] = row["recordid"]
				
				table.insert( info, record )
			end
			triggerClientEvent( source, "cshowAdminHistory", source, info, name or gameaccountid )
			mysql:free_result( result )
		else
			outputDebugString( "admin-system\showOfflineAdminHistory: Error." )
			outputChatBox( "Failed to retrieve history.", source, 255, 0, 0)
		end
	end
end
addEvent( "showOfflineAdminHistory", true )
addEventHandler( "showOfflineAdminHistory", getRootElement(), showOfflineAdminHistory )

function removeAdminHistoryLine(ID, target)
	if not client then  return end
	if not ID then return end
	if not target then return end
	if exports.global:isPlayerHeadAdmin(client) then -- type 4
		local sqlQuery = mysql:query_fetch_assoc("SELECT * FROM `adminhistory` WHERE `id`='".. mysql:escape_string(tostring(ID)).."'")
		if sqlQuery then
			if (tonumber(sqlQuery["action"]) == 4) then -- Warning
				local accountNumber = tostring(sqlQuery["user"])
				mysql:query_free("UPDATE `accounts` SET `warns`=warns-1 WHERE `ID`='"..mysql:escape_string(accountNumber).."' AND `warns` > 0")
				outputChatBox("Warn removed, will be updated when the player reconnects.", client, 0, 255, 0)
			end
		
			mysql:query_free("DELETE FROM `adminhistory` WHERE `id`='".. mysql:escape_string(tostring(ID)) .."'")
			outputChatBox("Entry Removed", client, 0, 255, 0)
			triggerEvent("showOfflineAdminHistory", client, target)
		end
	else
		outputChatBox("Not allowed", client, 255, 0, 0)
	end
end
addEvent( "admin:removehistory", true)
addEventHandler( "admin:removehistory", getRootElement(), removeAdminHistoryLine )

addCommandHandler( "history", 
	function( thePlayer, commandName, ... )
		if exports.global:isPlayerAdmin( thePlayer ) then
			if not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [player]", thePlayer, 255, 194, 14)
			else
				local targetPlayer = exports.global:findPlayerByPartialNick(nil, table.concat({...},"_"))
				if targetPlayer then
					local logged = getElementData(targetPlayer, "loggedin")
					if (logged==0) then
						outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
					else
						triggerEvent("showAdminHistory", thePlayer, targetPlayer)
					end
				else
					local targetPlayerName = table.concat({...},"_")
					-- select by charactername
					local result = mysql:query("SELECT account FROM characters WHERE charactername = '" .. mysql:escape_string(targetPlayerName ) .. "'" )
					if result then
						if mysql:num_rows( result ) == 1 then
							local row = mysql:fetch_assoc(result)
							local id = row["account"] or '0'
							triggerEvent("showOfflineAdminHistory", thePlayer, id, targetPlayerName)
							mysql:free_result( result )
							return
						else
							-- select by account
							local targetPlayerName = table.concat({...}," ")
							local result2 = mysql:query("SELECT id FROM accounts WHERE username = '" .. mysql:escape_string( targetPlayerName ) .. "'" )
							if result2 then
								if mysql:num_rows( result2 ) == 1 then
									local row2 = mysql:fetch_assoc(result2)
									local id = tonumber( row2["id"] ) or '0'
									triggerEvent("showOfflineAdminHistory", thePlayer, id, targetPlayerName)
									mysql:free_result( result2 )
									return
								end
								mysql:free_result( result2 )
							end
						end
						mysql:free_result( result )
					end
					mysql:free_result( result )
					outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
)


addEvent("admin:showInventory", true)
addEventHandler("admin:showInventory", getRootElement(), 
	function ()
		 executeCommandHandler( "showinv", client, getElementData(source, "playerid") )
	end
)