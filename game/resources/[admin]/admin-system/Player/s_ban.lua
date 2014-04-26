-- BAN
function banAPlayer(thePlayer, commandName, targetPlayer, hours, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) or not (hours) or (tonumber(hours)<0) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Time in Hours, 0 = Infinite] [Reason]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			hours = tonumber(hours)
			
			if not (targetPlayer) then
			elseif (hours>168) then
				outputChatBox("You cannot ban for more than 7 days (168 Hours).", thePlayer, 255, 194, 14)
			else
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				reason = table.concat({...}, " ")
				
				if (targetPlayerPower <= thePlayerPower) then -- Check the admin isn't banning someone higher rank them him
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local playerName = getPlayerName(thePlayer)
					local accountID = getElementData(targetPlayer, "account:id")
					
					local seconds = ((hours*60)*60)
					local rhours = hours
					-- text value
					if (hours==0) then
						hours = "Permanent"
					elseif (hours==1) then
						hours = "1 Hour"
					else
						hours = hours .. " Hours"
					end
					
					reason = reason .. " (" .. hours .. ")"
					
					mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("' .. mysql:escape_string(getPlayerName(targetPlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(targetPlayer, "account:id") or 0)) .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',' .. mysql:escape_string(hiddenAdmin) .. ',2,' .. mysql:escape_string(rhours) .. ',"' .. mysql:escape_string(reason) .. '")' )
					
					local showingPlayer = nil
					if (hiddenAdmin==0) then
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						outputChatBox("AdmBan: " .. adminTitle .. " " .. playerName .. " banned " .. targetPlayerName .. ". (" .. hours .. ")", getRootElement(), 255, 0, 51)
						outputChatBox("AdmBan: Reason: " .. reason .. ".", getRootElement(), 255, 0, 51)
						showingPlayer = thePlayer
						
						local ban = addBan(nil, nil, getPlayerSerial(targetPlayer), thePlayer, reason, seconds)
						--local ban = banPlayer(targetPlayer, false, false, true, thePlayer, reason, seconds)
						
						if (seconds == 0) then
							mysql:query_free("UPDATE accounts SET banned='1', banned_reason='" .. mysql:escape_string(reason) .. "', banned_by='" .. mysql:escape_string(playerName) .. "' WHERE id='" .. mysql:escape_string(accountID) .. "'")
						end
					elseif (hiddenAdmin==1) then
						outputChatBox("AdmBan: Hidden Admin banned " .. targetPlayerName .. ". (" .. hours .. ")", getRootElement(), 255, 0, 51)
						outputChatBox("AdmBan: Reason: " .. reason, getRootElement(), 255, 0, 51)
						showingPlayer = getRootElement()
						
						local ban = addBan(nil, nil, getPlayerSerial(targetPlayer), thePlayer, reason, seconds)
						--local ban = banPlayer(targetPlayer, false, false, true, getRootElement(), reason, seconds)
						
						if (seconds == 0) then
							mysql:query_free("UPDATE accounts SET banned='1', banned_reason='" .. mysql:escape_string(reason) .. "', banned_by='" .. mysql:escape_string(playerName) .. "' WHERE id='" .. mysql:escape_string(accountID) .. "'")
						end
					end
					
					local serial = getPlayerSerial(targetPlayer)
					for key, value in ipairs(getElementsByType("player")) do
						if getPlayerSerial(value) == serial then
							kickPlayer(value, showingPlayer, reason)
						end
					end
				else
					outputChatBox(" This player is a higher level admin than you.", thePlayer, 255, 0, 0)
					outputChatBox(playerName .. " attempted to execute the ban command on you.", targetPlayer, 255, 0 ,0)
				end
			end
		end
	end
end
addCommandHandler("pban", banAPlayer, false, false)

-- /UNBAN
function unbanPlayer(thePlayer, commandName, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player username/IP/Serial]", thePlayer, 255, 194, 14)
		else
			local searchString = table.concat({...}, " ")
			local searchStringM =  string.gsub(searchString, " ", "_")
			local accountID = nil
			local searchCode = "UN" 
			local localBan = nil
			
			-- Try on account name or serial or ip
			if not accountID then
				local accountSearch = mysql:query_fetch_assoc("SELECT `id` FROM `accounts` WHERE `username`='" .. mysql:escape_string(tostring(searchString)) .. "' or `mtaserial`='" .. mysql:escape_string(tostring(searchString)) .. "' or `ip`='" .. mysql:escape_string(tostring(searchString)) .. "' LIMIT 1")
				if accountSearch then
					accountID = accountSearch["id"]
					searchCode = "DA"
				end
			end
			
			-- Try on character name
			if not accountID then
				
				local characterSearch = mysql:query_fetch_assoc("SELECT `account` FROM `characters` WHERE `charactername`='" .. mysql:escape_string(tostring(searchStringM)) .. "' LIMIT 1")
				if characterSearch then
					accountID = characterSearch["account"]
					searchCode = "DC"
				end
			end
			
			-- Check local
			if not accountID then
				for _, banElement in ipairs(getBans()) do
					if (getBanSerial(banElement) == searchString) then
						accountID = -1
						searchCode = "XS"
						localBan = banElement
						break
					end
					
					if (getBanIP(banElement) == searchString) then
						accountID = -1
						searchCode = "XI"
						localBan = banElement
						break
					end
					
					if (getBanNick(banElement) == searchStringM) then
						accountID = -1
						searchCode = "XN"
						localBan = banElement
						break
					end
				end
			end
			
			if not accountID then
				outputChatBox("No ban found for '" .. searchString .. "'", thePlayer, 255, 0, 0)
				return
			end
			
			if (accountID == -1 and localBan) then
				exports.global:sendMessageToAdmins("[BanMan] "..getBanNick(localBan) .. "/"..getBanSerial(localBan).." was unbanned by " .. getPlayerName(thePlayer) .. ". (S: ".. searchCode ..")")
				removeBan( localBan )
				return
			end
			
			-- Get ban details
			local banDetails = mysql:query_fetch_assoc("SELECT `ip`, `mtaserial`, `username`, `id`, `banned` FROM `accounts` WHERE `id`='" .. mysql:escape_string(tostring(accountID)) .. "' LIMIT 1")
			if banDetails then 
			
				-- Check local
				local unbannedSomething = false
				for _, banElement in ipairs(getBans()) do
					local unban = false
					if (getBanSerial(banElement) == banDetails["mtaserial"]) then
						searchCode = searchCode .. "-XS"
						unban = true
					end
					
					if (getBanIP(banElement) == banDetails["ip"]) then
						searchCode = searchCode .. "-IS"
						unban = true
					end
					
					if unban then
						removeBan(banElement)		
						unbannedSomething = true
					end
				end
				
				if not (unbannedSomething) and not (banDetails["banned"] == 1) then
					outputChatBox("No ban found for '" .. searchString .. "'", thePlayer, 255, 0, 0)
				else
					exports.global:sendMessageToAdmins("[BanMan] "..banDetails["username"] .. "/"..banDetails["mtaserial"].."/".. banDetails["id"] .." was unbanned by " .. getPlayerName(thePlayer) .. ". (S: ".. searchCode ..")")
					mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("'..mysql:escape_string(banDetails["username"])..'",' ..accountID .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',0,2,0,"UNBAN")' )
					mysql:query_free("UPDATE accounts SET banned='0', banned_by=NULL, banned_reason=NULL WHERE id='" .. mysql:escape_string(banDetails["id"]) .. "'")
				end
			end
		end
	end
end
addCommandHandler("unban", unbanPlayer, false, false)
--]]

--[[ /UNBAN
function unbanPlayer(thePlayer, commandName, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Full Name]", thePlayer, 255, 194, 14)
		else
			local bans = getBans()
			local found = false
			local nickName = table.concat({...}, " ")
			local result1 = mysql:query("SELECT account FROM characters WHERE charactername='" .. mysql:escape_string(tostring(nickName)) .. "' LIMIT 1")
			
			if (result1 and mysql:num_rows(result1)>0) then
				local row = mysql:fetch_assoc(result1)
				local accountid = tonumber(row["account"])
				mysql:free_result(result1)
				
				local result = mysql:query("SELECT id, ip, banned, mtaserial FROM accounts WHERE id='" .. mysql:escape_string(accountid) .. "'")
					
				if (result) then
					if (mysql:num_rows(result)>0) then
						local row = mysql:fetch_assoc(result)
						local ip = tostring(row["ip"])
						local banned = tonumber(row["banned"])
						local serial = row["mtaserial"]
						local id = row["id"]
						
						for key, value in ipairs(bans) do
							local removed = false
							--if (ip==getBanIP(value)) then
							-	exports.global:sendMessageToAdmins(tostring(nickName) .. " was unbanned by " .. getPlayerName(thePlayer) .. ".")
							--	mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("'..mysql:escape_string(nickName)..'",' .. id .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',0,2,0,"UNBAN")' )
							--	removeBan(value, thePlayer)
							--	mysql:query_free("UPDATE accounts SET banned='0', banned_by=NULL WHERE ip='" .. mysql:escape_string(ip) .. "'")
							--	found = true
							--	removed = true
							--end
							
							if not removed then
								local bannedSerial = getBanSerial(value) or ""
								if (serial == bannedSerial) then
									exports.global:sendMessageToAdmins(tostring(nickName) .. " was unbanned by " .. getPlayerName(thePlayer) .. ".")
									mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("'..mysql:escape_string(nickName)..'",' .. id .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',0,2,0,"UNBAN")' )
									removeBan(value, thePlayer)
									mysql:query_free("UPDATE accounts SET banned='0', banned_by=NULL WHERE mtaserial='" .. mysql:escape_string(serial) .. "'")
									found = true
									removed = true
								end
							end
						end
						
						if not found and banned == 1 then
							exports.global:sendMessageToAdmins(tostring(nickName) .. " was unbanned by " .. getPlayerName(thePlayer) .. ".")
							mysql:query_free("UPDATE accounts SET banned='0', banned_by=NULL WHERE id='" .. mysql:escape_string(accountid) .. "'")
							mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("'..mysql:escape_string(nickName)..'",' .. id .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',0,2,0,"UNBAN")' )
							found = true
						end
						
						if not (found) then
							outputChatBox("No ban found for '" .. nickName .. "'", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("No ban found for '" .. nickName .. "'", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("No ban found for '" .. nickName .. "'", thePlayer, 255, 0, 0)
				end
				mysql:free_result(result)
			else -- lets check by account instead
				mysql:free_result(result1)
				local result2 = mysql:query("SELECT id FROM accounts WHERE username='" .. mysql:escape_string(tostring(nickName)) .. "' LIMIT 1")
			
				if (mysql:num_rows(result2)>0) then
					local row = mysql:fetch_assoc(result2)
					local accountid = tonumber(row["id"])
					mysql:free_result(result2)
					
					
					local result = mysql:query("SELECT id, ip, banned FROM accounts WHERE id='" .. mysql:escape_string(accountid) .. "'")
						
					if (result) then
						if (mysql:num_rows(result)>0) then
							local row = mysql:fetch_assoc(result)
							local ip = tostring(row["ip"])
							local banned = tonumber(row["banned"])
							local serial = row["mtaserial"]
							local id = row["id"]
							
							for key, value in ipairs(bans) do
								local removed = false
								--if (ip==getBanIP(value)) then
								--	exports.global:sendMessageToAdmins(tostring(nickName) .. " was unbanned by " .. getPlayerName(thePlayer) .. ".")
								--	mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("'..mysql:escape_string(nickName)..'",' .. id .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',0,2,0,"UNBAN")' )
								--	removeBan(value, thePlayer)
								--	mysql:query_free("UPDATE accounts SET banned='0', banned_by=NULL WHERE ip='" .. mysql:escape_string(ip) .. "'")
								--	found = true
								--	removed = true
								--end
								
								if not removed then
									local bannedSerial = getBanSerial(value) or ""
									if (serial == bannedSerial) then
										exports.global:sendMessageToAdmins(tostring(nickName) .. " was unbanned by " .. getPlayerName(thePlayer) .. ".")
										mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("'..mysql:escape_string(nickName)..'",' .. id .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',0,2,0,"UNBAN")' )
										removeBan(value, thePlayer)
										mysql:query_free("UPDATE accounts SET banned='0', banned_by=NULL WHERE mtaserial='" .. mysql:escape_string(serial) .. "'")
										found = true
										removed = true
									end
								end
							end
							
							if not found and banned == 1 then
								exports.global:sendMessageToAdmins(tostring(nickName) .. " was unbanned by " .. getPlayerName(thePlayer) .. ".")
								mysql:query_free("UPDATE accounts SET banned='0', banned_by=NULL WHERE ip='" .. mysql:escape_string(ip) .. "'")
								mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("'..mysql:escape_string(nickName)..'",' .. id .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',0,2,0,"UNBAN")' )
								found = true
							end
							
							if not (found) then
								outputChatBox("No ban found for '" .. nickName .. "'", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("No ban found for '" .. nickName .. "'", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("No ban found for '" .. nickName .. "'", thePlayer, 255, 0, 0)
					end
					mysql:free_result(result)
				else
					outputChatBox("No ban found for '" .. nickName .. "'", thePlayer, 255, 0, 0)
				end
			end
			mysql:free_result(result1)
		end
	end
end
addCommandHandler("unban", unbanPlayer, false, false)
--]]

-- /UNBANIP
function unbanPlayerIP(thePlayer, commandName, ip)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (ip) then
			outputChatBox("SYNTAX: /" .. commandName .. " [IP]", thePlayer, 255, 194, 14)
		else
			ip = mysql:escape_string(ip)
			local bans = getBans()
			local found = false
				
			for key, value in ipairs(bans) do
				if (ip==getBanIP(value)) then
					exports.global:sendMessageToAdmins(tostring(ip) .. " was unbanned by " .. getPlayerName(thePlayer) .. ".")
					removeBan(value, thePlayer)
					mysql:query_free("UPDATE accounts SET banned='0', banned_by=NULL WHERE ip='" .. mysql:escape_string(ip) .. "'")
					found = true
					--break
				end
			end
			
			local query = mysql:query_fetch_assoc("SELECT COUNT(*) as number FROM accounts WHERE ip = '" .. mysql:escape_string(ip) .. "' AND banned = 1")
			if tonumber(query["number"]) > 0 then
				mysql:query_free("UPDATE accounts SET banned='0', banned_by=NULL WHERE ip='" .. mysql:escape_string(ip) .. "'")
				found = true
			end
			
			if found then
				outputChatBox("Unbanned ip '" .. ip .. "'", thePlayer, 255, 0, 0)
			else
				outputChatBox("No ban found for '" .. ip .. "'", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("unbanip", unbanPlayerIP, false, false)

-- /UNBANIP
function unbanPlayerSerial(thePlayer, commandName, ip)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (ip) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Serial]", thePlayer, 255, 194, 14)
		else
			ip = mysql:escape_string(ip)
			local bans = getBans()
			local found = false
				
			for key, value in ipairs(bans) do
				local bannedSerial = getBanSerial(value) or ""
				if (ip==bannedSerial) then
					exports.global:sendMessageToAdmins(tostring(ip) .. " was unbanned by " .. getPlayerName(thePlayer) .. ".")
					removeBan(value, thePlayer)
					mysql:query_free("UPDATE accounts SET banned='0', banned_by=NULL WHERE mtaserial='" .. mysql:escape_string(ip) .. "'")
					found = true
					--break
				end
			end
			
			local query = mysql:query_fetch_assoc("SELECT COUNT(*) as number FROM accounts WHERE mtaserial = '" .. mysql:escape_string(ip) .. "' AND banned = 1")
			if tonumber(query["number"]) > 0 then
				mysql:query_free("UPDATE accounts SET banned='0', banned_by=NULL WHERE mtaserial='" .. mysql:escape_string(ip) .. "'")
				found = true
			end
			
			if found then
				outputChatBox("Unbanned serial '" .. ip .. "'", thePlayer, 255, 0, 0)
			else
				outputChatBox("No ban found for '" .. ip .. "'", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("unbanserial", unbanPlayerSerial, false, false)


function checkForFairPlayBan(dummy1, dummy2, dummy3, MTAserial)
	local result = exports.mysql:query("SELECT username FROM accounts WHERE mtaserial = '" .. exports.mysql:escape_string(MTAserial) .. "' and banned=1")
	if exports.mysql:num_rows(result) > 0 then
		cancelEvent(true, "You are banned from this server.")
		local row = exports.mysql:fetch_assoc(result)
		exports.global:sendMessageToAdmins("[MTA.VG] Rejected connection from " .. row["username"] .. "/" .. MTAserial .." as this user currently has FairPlay bans against them.")
		--outputDebugString("[MTA.VG] Rejected connection from " .. MTAserial .. " as this user currently has FairPlay bans against them.")
	end
	exports.mysql:free_result(result)
end
addEventHandler("onPlayerConnect", getRootElement(), checkForFairPlayBan)