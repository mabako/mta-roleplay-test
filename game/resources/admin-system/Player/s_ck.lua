
-- /CK
function ckPlayer(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (targetPlayer) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Cause of Death]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					info = table.concat({...}, " ")
					local query = mysql:query_free("UPDATE characters SET cked='1', ck_info='" .. mysql:escape_string(tostring(info)) .. "' WHERE id = " .. mysql:escape_string(getElementData(targetPlayer, "dbid")))
					
					local x, y, z = getElementPosition(targetPlayer)
					local skin = getPedSkin(targetPlayer)
					local rotation = getPedRotation(targetPlayer)
					
					call( getResourceFromName( "realism-system" ), "addCharacterKillBody", x, y, z, rotation, skin, getElementData(targetPlayer, "dbid"), targetPlayerName, getElementInterior(targetPlayer), getElementDimension(targetPlayer), getElementData(targetPlayer, "age"), getElementData(targetPlayer, "race"), getElementData(targetPlayer, "weight"), getElementData(targetPlayer, "height"), getElementData(targetPlayer, "chardescription"), info, getElementData(targetPlayer, "gender"))
					
					-- send back to change char screen
					local id = getElementData(targetPlayer, "account:id")
					showCursor(targetPlayer, false)
					triggerEvent("accounts:characters:change", targetPlayer, "Change Character")
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "loggedin", 0, false)
					outputChatBox("Your character was CK'ed by " .. getPlayerName(thePlayer) .. ".", targetPlayer, 255, 194, 14)
					showChat(targetPlayer, false)
					outputChatBox("You have CK'ed ".. targetPlayerName ..".", thePlayer, 255, 194, 1, 14)
					--exports.logs:logMessage("[/CK] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." CK'ED ".. targetPlayerName , 4)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "CK with reason: "..mysql:escape_string(tostring(info)))
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "dbid", 0, false)
					local port = getServerPort()
					local password = getServerPassword()
						
					redirectPlayer(targetPlayer)
				end
			end
		end
	end
end
addCommandHandler("ck", ckPlayer)

-- /UNCK
function unckPlayer(thePlayer, commandName, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Full Player Name]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = table.concat({...}, "_")
			local result = mysql:query("SELECT id FROM characters WHERE charactername='" .. mysql:escape_string(tostring(targetPlayer)) .. "' AND cked > 0")
			
			if (mysql:num_rows(result)>1) then
				outputChatBox("Too many results - Please enter a more exact name.", thePlayer, 255, 0, 0)
			elseif (mysql:num_rows(result)==0) then
				outputChatBox("Player does not exist or is not CK'ed.", thePlayer, 255, 0, 0)
			else
				local row = mysql:fetch_assoc(result)
				local dbid = tonumber(row["id"]) or 0
				mysql:query_free("UPDATE characters SET cked='0' WHERE id = " .. dbid .. " LIMIT 1")
				
				-- delete all peds for him
				for key, value in pairs( getElementsByType( "ped" ) ) do
					if isElement( value ) and getElementData( value, "ckid" ) then
						if getElementData( value, "ckid" ) == dbid then
							destroyElement( value )
						end
					end
				end
				
				outputChatBox(targetPlayer .. " is no longer CK'ed.", thePlayer, 0, 255, 0)
				--exports.logs:logMessage("[/UNCK] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." UNCK'ED ".. targetPlayer , 4)
				exports.logs:dbLog(thePlayer, 4, "ch"..row["id"], "UNCK")
			end
			mysql:free_result(result)
		end
	end
end
addCommandHandler("unck", unckPlayer)

-- /BURY
function buryPlayer(thePlayer, commandName, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Full Player Name]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = table.concat({...}, "_")
			local result = mysql:query("SELECT id, cked FROM characters WHERE charactername='" .. mysql:escape_string(tostring(targetPlayer)) .. "'")
			
			if (mysql:num_rows(result)>1) then
				outputChatBox("Too many results - Please enter a more exact name.", thePlayer, 255, 0, 0)
			elseif (mysql:num_rows(result)==0) then
				outputChatBox("Player does not exist.", thePlayer, 255, 0, 0)
			else
				local row = mysql:fetch_assoc(result)
				local dbid = tonumber(row["id"]) or 0
				local cked = tonumber(row["cked"]) or 0
				if cked == 0 then
					outputChatBox("Player is not CK'ed.", thePlayer, 255, 0, 0)
				elseif cked == 2 then
					outputChatBox("Player is already buried.", thePlayer, 255, 0, 0)
				else
					mysql:query_free("UPDATE characters SET cked='2' WHERE id = " .. dbid .. " LIMIT 1")
					
					-- delete all peds for him
					for key, value in pairs( getElementsByType( "ped" ) ) do
						if isElement( value ) and getElementData( value, "ckid" ) then
							if getElementData( value, "ckid" ) == dbid then
								destroyElement( value )
							end
						end
					end
					
					outputChatBox(targetPlayer .. " was buried.", thePlayer, 0, 255, 0)
					exports.logs:logMessage("[/BURY] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." buried ".. targetPlayer , 4)
					exports.logs:dbLog(thePlayer, 4, "ch"..row["id"], "CK-BURY")
				end
			end
			mysql:free_result(result)
		end
	end
end
addCommandHandler("bury", buryPlayer)