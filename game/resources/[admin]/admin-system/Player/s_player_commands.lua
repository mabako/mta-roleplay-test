mysql = exports.mysql

local getPlayerName_ = getPlayerName
getPlayerName = function( ... )
	s = getPlayerName_( ... )
	return s and s:gsub( "_", " " ) or s
end

--/AUNCUFF
function adminUncuff(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local restrain = getElementData(targetPlayer, "restrain")
					
					if (restrain==0) then
						outputChatBox("Player is not restrained.", thePlayer, 255, 0, 0)
					else
						outputChatBox("You have been uncuffed by " .. username .. ".", targetPlayer)
						outputChatBox("You have uncuffed " .. targetPlayerName .. ".", thePlayer)
						toggleControl(targetPlayer, "sprint", true)
						toggleControl(targetPlayer, "fire", true)
						toggleControl(targetPlayer, "jump", true)
						toggleControl(targetPlayer, "next_weapon", true)
						toggleControl(targetPlayer, "previous_weapon", true)
						toggleControl(targetPlayer, "accelerate", true)
						toggleControl(targetPlayer, "brake_reverse", true)
						toggleControl(targetPlayer, "aim_weapon", true)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "restrain", 0, true)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "restrainedBy", false, true)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "restrainedObj", false, true)
						exports.global:removeAnimation(targetPlayer)
						mysql:query_free("UPDATE characters SET cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
						exports['item-system']:deleteAll(47, getElementData( targetPlayer, "dbid" ))
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNCUFF")
					end
				end
			end
		end
	end
end
addCommandHandler("auncuff", adminUncuff, false, false)

--/AUNMASK
function adminUnmask(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local any = false
					local masks = exports['item-system']:getMasks()
					for key, value in pairs(masks) do
						if getElementData(targetPlayer, value[1]) then
							any = true
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, value[1], false, true)
						end
					end
					
					if any then
						outputChatBox("You have removed the mask from " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNMASK")
					else
						outputChatBox("Player is not masked.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("aunmask", adminUnmask, false, false)

function infoDisplay(thePlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		outputChatBox("---[        Useful Information        ]---", getRootElement(), 255, 194, 15)
		outputChatBox("---[ Server: server.mta.vg Port: 22003", getRootElement(), 255, 194, 15)
		outputChatBox("---[ Ventrilo: vent.valhallagaming.net Port: 4263", getRootElement(), 255, 194, 15)
		outputChatBox("---[ Site/UCP/TicketCenter: www.mta.vg", getRootElement(), 255, 194, 15)
		outputChatBox("---[ Bug Tracker: bugs.mta.vg", getRootElement(), 255, 194, 15)
	end
end
addCommandHandler("vginfo", infoDisplay)

function adminUnblindfold(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local blindfolded = getElementData(targetPlayer, "rblindfold")
					
					if (blindfolded==0) then
						outputChatBox("Player is not blindfolded", thePlayer, 255, 0, 0)
					else
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "blindfold", false, false)
						fadeCamera(targetPlayer, true)
						outputChatBox("You have unblindfolded " .. targetPlayerName .. ".", thePlayer)
						mysql:query_free("UPDATE characters SET blindfold = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNBLINDFOLD")
					end
				end
			end
		end
	end
end
addCommandHandler("aunblindfold", adminUnblindfold, false, false)

-- /MUTE
function mutePlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local muted = getElementData(targetPlayer, "muted") or 0
					
					if muted == 0 then
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "muted", 1, false)
						outputChatBox(targetPlayerName .. " is now muted from OOC.", thePlayer, 255, 0, 0)
						outputChatBox("You were muted by '" .. getPlayerName(thePlayer) .. "'.", targetPlayer, 255, 0, 0)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "MUTE")
					else
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "muted", 0, false)
						outputChatBox(targetPlayerName .. " is now unmuted from OOC.", thePlayer, 0, 255, 0)
						outputChatBox("You were unmuted by '" .. getPlayerName(thePlayer) .. "'.", targetPlayer, 0, 255, 0)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNMUTE")
					end
					mysql:query_free("UPDATE accounts SET muted=" .. mysql:escape_string(getElementData(targetPlayer, "muted")) .. " WHERE id = " .. mysql:escape_string(getElementData(targetPlayer, "account:id")) )
				end
			end
		end
	end
end
addCommandHandler("pmute", mutePlayer, false, false)

-- /DISARM
function disarmPlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					for i = 115, 116 do
						while exports['item-system']:takeItem(targetPlayer, i) do
						end
					end
					outputChatBox(targetPlayerName .. " is now disarmed.", thePlayer, 255, 194, 14)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "DISARM")
				end
			end
		end
	end
end
addCommandHandler("disarm", disarmPlayer, false, false)

-- forceapp
function forceApplication(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerLeadGameMaster(thePlayer)) then
		if not (targetPlayer) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick/ID] [Reason]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if not (targetPlayer) then
			elseif exports.global:isPlayerAdmin(targetPlayer) then
				outputChatBox("No.", thePlayer, 255, 0, 0)
			else
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local reason = table.concat({...}, " ")
					local id = getElementData(targetPlayer, "account:id")
					local username = getElementData(thePlayer, "account:username")
					mysql:query_free("UPDATE accounts SET appstate = 2, appreason='" .. mysql:escape_string(reason) .. "', appdatetime = NOW() + INTERVAL 1 DAY, monitored = 'Forceapped for " .. mysql:escape_string(reason) .. "' WHERE id='" .. mysql:escape_string(id) .. "'")
					outputChatBox(targetPlayerName .. " was forced to re-write their application.", thePlayer, 255, 194, 14)
					
					local port = getServerPort()
					local password = getServerPassword()
					
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " sent " .. targetPlayerName .. " back to the application stage.")
					
					local res = mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("' .. mysql:escape_string(getPlayerName(targetPlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(targetPlayer, "account:id") or 0)) .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',0,3,0,"' .. mysql:escape_string(reason) .. '")' )
					
					kickPlayer(targetPlayer, getRootElement( ), "Please rewrite your application at mta.vg")
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "FORCEAPP " .. reason)
				end
			end
		end
	end
end
addCommandHandler("forceapp", forceApplication, false, false)


-- /FRECONNECT
function forceReconnect(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				if (hiddenAdmin==0) then
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " reconnected " .. targetPlayerName )
				end
				outputChatBox("Player '" .. targetPlayerName .. "' was forced to reconnect.", thePlayer, 255, 0, 0)
					
				local timer = setTimer(kickPlayer, 1000, 1, targetPlayer, getRootElement(), "Please Reconnect")
				addEventHandler("onPlayerQuit", targetPlayer, function( ) killTimer( timer ) end)
				
				redirectPlayer(targetPlayer)
				
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "FRECONNECT")
			end
		end
	end
end
addCommandHandler("freconnect", forceReconnect, false, false)

-- /MAKEGUN
function givePlayerGun(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local args = {...}
		if not (targetPlayer) or (#args < 1) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Weapon ID] [Name]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local weapon = tonumber(args[1])
				local ammo = #args ~= 1 and tonumber(args[#args]) or 1
				
				if not getWeaponNameFromID(weapon) then
					outputChatBox("Invalid Weapon ID.", thePlayer, 255, 0, 0)
					return
				end
				
				if (weapon == 38) or (weapon == 37) or (weapon == 36) then
					outputChatBox("No.", thePlayer, 255,0,0)
					return
				end
				
				local logged = getElementData(targetPlayer, "loggedin")
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local adminDBID = tonumber(getElementData(thePlayer, "account:character:id"))
					local playerDBID = tonumber(getElementData(targetPlayer, "account:character:id"))
					local mySerial = exports.global:createWeaponSerial( 1, adminDBID, playerDBID)
					local give, error = exports.global:giveItem(targetPlayer, 115, weapon..":"..mySerial..":"..getWeaponNameFromID(weapon))
					if give then
						outputChatBox("Player " .. targetPlayerName .. " now has a " .. getWeaponNameFromID(weapon) .. " with serial '"..mySerial.."'.", thePlayer, 0, 255, 0)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEWEAPON "..getWeaponNameFromID(weapon).." "..tostring(mySerial))
						if (hiddenAdmin==0) then
							local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
							exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " a " .. getWeaponNameFromID(weapon) .. " with serial '"..mySerial.."'")
						end
					else
						outputChatBox("Error: ".. error ..".", thePlayer, 0, 255, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("makegun", givePlayerGun, false, false)

-- /makeammo
function givePlayerGunAmmo(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local args = {...}
		if not (targetPlayer) or (#args < 2) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Weapon ID] [Amount in clip] [Name]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local weapon = tonumber(args[1])
				local ammo =  tonumber(args[2]) or 1
				
				if not getWeaponNameFromID(weapon) then
					outputChatBox("Invalid Weapon ID.", thePlayer, 255, 0, 0)
					return
				end
				
				if (weapon == 38) or (weapon == 37) or (weapon == 36) then
					outputChatBox("No.", thePlayer, 255,0,0)
					return
				end
				
				local logged = getElementData(targetPlayer, "loggedin")
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local give, error = exports.global:giveItem(targetPlayer, 116, weapon..":"..ammo..":Ammo for "..getWeaponNameFromID(weapon))
					if give then
						outputChatBox("Player " .. targetPlayerName .. " now has an ammopack for an " .. getWeaponNameFromID(weapon) .. " with '"..ammo.."' bullets.", thePlayer, 0, 255, 0)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEBULLETS "..getWeaponNameFromID(weapon).." "..tostring(bullets))
						if (hiddenAdmin==0) then
							local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
							exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " an " .. getWeaponNameFromID(weapon) .. " magazine with '"..ammo.."' bullets.")
						end
					else
						outputChatBox("Error: ".. error ..".", thePlayer, 0, 255, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("makeammo", givePlayerGunAmmo, false, false)

-- /GIVEITEM
function givePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (itemID) or not (...) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Item ID] [Item Value]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				itemID = tonumber(itemID)
				local itemValue = table.concat({...}, " ")
				itemValue = tonumber(itemValue) or itemValue
				
				if ( itemID == 74 or itemID == 75 or itemID == 78 or itemID == 2) and not exports.global:isPlayerScripter( thePlayer ) and not exports.global:isPlayerHeadAdmin( thePlayer) then
					-- nuthin
				elseif ( itemID == 84 ) and not exports.global:isPlayerLeadAdmin( thePlayer ) then
				elseif itemID == 114 and not exports.global:isPlayerSuperAdmin( thePlayer ) then
				elseif (itemID == 115 or itemID == 116) then
					outputChatBox("Not possible to use this item with /giveitem, sorry.", thePlayer, 255, 0, 0)
				elseif (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local name = call( getResourceFromName( "item-system" ), "getItemName", itemID, itemValue )
					
					if itemID > 0 and name and name ~= "?" then
						local success, reason = exports.global:giveItem(targetPlayer, itemID, itemValue)
						if success then
							outputChatBox("Player " .. targetPlayerName .. " now has a " .. name .. " with value " .. itemValue .. ".", thePlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEITEM "..name.." "..tostring(itemValue))
							
						
							triggerClientEvent(targetPlayer, "item:updateclient", targetPlayer)
						else
							outputChatBox("Couldn't give " .. targetPlayerName .. " a " .. name .. ": " .. tostring(reason), thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("Invalid Item ID.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("giveitem", givePlayerItem, false, false)

-- /TAKEITEM
function takePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (itemID) or not (...) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Item ID] [Item Value]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				itemID = tonumber(itemID)
				local itemValue = table.concat({...}, " ")
				itemValue = tonumber(itemValue) or itemValue
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					if exports.global:hasItem(targetPlayer, itemID, itemValue) then
						outputChatBox("You took that Item " .. itemID .. " from " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
						exports.global:takeItem(targetPlayer, itemID, itemValue)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "TAKEITEM "..tostring(itemID).." "..tostring(itemValue))
						
						triggerClientEvent(targetPlayer, "item:updateclient", targetPlayer)
					else
						outputChatBox("Player doesn't have that item", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("takeitem", takePlayerItem, false, false)

-- /SETHP
function setPlayerHealth(thePlayer, commandName, targetPlayer, health)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not tonumber(health) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Health]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				if tonumber( health ) < getElementHealth( targetPlayer ) and getElementData( thePlayer, "adminlevel" ) < getElementData( targetPlayer, "adminlevel" ) then
					outputChatBox("Nah.", thePlayer, 255, 0, 0)
				elseif not setElementHealth(targetPlayer, tonumber(health)) then
					outputChatBox("Invalid health value.", thePlayer, 255, 0, 0)
				else
					outputChatBox("Player " .. targetPlayerName .. " now has " .. health .. " Health.", thePlayer, 0, 255, 0)
					triggerEvent("onPlayerHeal", targetPlayer, true)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETHP "..health)
				end
			end
		end
	end
end
addCommandHandler("sethp", setPlayerHealth, false, false)

-- /SETARMOR
function setPlayerArmour(thePlayer, commandName, targetPlayer, armor)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (armor) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Armor]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (tostring(type(tonumber(armor))) == "number") then
					local setArmor = setPedArmor(targetPlayer, tonumber(armor))
					outputChatBox("Player " .. targetPlayerName .. " now has " .. armor .. " Armor.", thePlayer, 0, 255, 0)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETARMOR "..tostring(armor))
				else
					outputChatBox("Invalid armor value.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setarmor", setPlayerArmour, false, false)

-- /SETSKIN
function setPlayerSkinCmd(thePlayer, commandName, targetPlayer, skinID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (skinID) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Skin ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (tostring(type(tonumber(skinID))) == "number" and tonumber(skinID) ~= 0) then
					local fat = getPedStat(targetPlayer, 21)
					local muscle = getPedStat(targetPlayer, 23)
					
					setPedStat(targetPlayer, 21, 0)
					setPedStat(targetPlayer, 23, 0)
					local skin = setElementModel(targetPlayer, tonumber(skinID))
					
					setPedStat(targetPlayer, 21, fat)
					setPedStat(targetPlayer, 23, muscle)
					if not (skin) then
						outputChatBox("Invalid skin ID.", thePlayer, 255, 0, 0)
					else
						outputChatBox("Player " .. targetPlayerName .. " now has skin " .. skinID .. ".", thePlayer, 0, 255, 0)
						mysql:query_free("UPDATE characters SET skin = " .. mysql:escape_string(skinID) .. " WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETSKIN "..tostring(skinID))
					end
				else
					outputChatBox("Invalid skin ID.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setskin", setPlayerSkinCmd, false, false)

-- /CHANGENAME
function asetPlayerName(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (...) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Player New Nick]", thePlayer, 255, 194, 14)
		else
			local newName = table.concat({...}, "_")
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				if newName == targetPlayerName then
					outputChatBox( "The player's name is already that.", thePlayer, 255, 0, 0)
				else
					local dbid = getElementData(targetPlayer, "dbid")
					local result = mysql:query("SELECT charactername FROM characters WHERE charactername='" .. mysql:escape_string(newName) .. "' AND id != " .. mysql:escape_string(dbid))
					
					if (mysql:num_rows(result)>0) then
						outputChatBox("This name is already in use.", thePlayer, 255, 0, 0)
					else
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 1, false)
						local name = setPlayerName(targetPlayer, tostring(newName))
						
						if (name) then
							exports['cache']:clearCharacterName( dbid )
							mysql:query_free("UPDATE characters SET charactername='" .. mysql:escape_string(newName) .. "' WHERE id = " .. mysql:escape_string(dbid))
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							
							if (hiddenAdmin==0) then
								local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
								exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " changed " .. targetPlayerName .. "'s Name to " .. newName .. ".")
							end
							outputChatBox("You changed " .. targetPlayerName .. "'s Name to " .. tostring(newName) .. ".", thePlayer, 0, 255, 0)
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 0, false)
							
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "CHANGENAME "..targetPlayerName.." -> "..tostring(newName))
							triggerClientEvent(targetPlayer, "updateName", targetPlayer, getElementData(targetPlayer, "dbid"))
						else
							outputChatBox("Failed to change name.", thePlayer, 255, 0, 0)
						end
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 0, false)
					end
					mysql:free_result(result)
				end
			end
		end
	end
end
addCommandHandler("changename", asetPlayerName, false, false)

-- /HIDEADMIN
function hideAdmin(thePlayer, commandName)
	if exports.global:isPlayerHeadAdmin(thePlayer) or exports.global:isPlayerScripter(thePlayer) then
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		
		if (hiddenAdmin==0) then
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "hiddenadmin", 1, false)
			outputChatBox("You are now a hidden admin.", thePlayer, 255, 194, 14)
		elseif (hiddenAdmin==1) then
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "hiddenadmin", 0, false)
			outputChatBox("You are no longer a hidden admin.", thePlayer, 255, 194, 14)
		end
		exports.global:updateNametagColor(thePlayer)
		mysql:query_free("UPDATE accounts SET hiddenadmin=" .. mysql:escape_string(getElementData(thePlayer, "hiddenadmin")) .. " WHERE id = " .. mysql:escape_string(getElementData(thePlayer, "account:id")) )
	end
end
addCommandHandler("hideadmin", hideAdmin, false, false)
	
-- /SLAP
function slapPlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (targetPlayerPower > thePlayerPower) then -- Check the admin isn't slapping someone higher rank them him
					outputChatBox("You cannot slap this player as they are a higher admin rank then you.", thePlayer, 255, 0, 0)
				else
					local x, y, z = getElementPosition(targetPlayer)
					
					if (isPedInVehicle(targetPlayer)) then
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "realinvehicle", 0, false)
						removePedFromVehicle(targetPlayer)
					end
					detachElements(targetPlayer)
					
					setElementPosition(targetPlayer, x, y, z+15)
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					
					if (hiddenAdmin==0) then
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " slapped " .. targetPlayerName .. ".")
					end
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "SLAP")
				end
			end
		end
	end
end
addCommandHandler("slap", slapPlayer, false, false)

-- HEADS Hidden OOC
function hiddenOOC(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local players = exports.pool:getPoolElementsByType("player")
			local message = table.concat({...}, " ")
			
			for index, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")
			
				if (logged==1) and getElementData(arrayPlayer, "globalooc") == 1 then
					outputChatBox("(( Hidden Admin: " .. message .. " ))", arrayPlayer, 255, 255, 255)
				end
			end
		end
	end
end
addCommandHandler("ho", hiddenOOC, false, false)

-- HEADS Hidden Whisper
function hiddenWhisper(thePlayer, command, who, ...)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (who) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Message]", thePlayer, 255, 194, 14)
		else
			message = table.concat({...}, " ")
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, who)
			
			if (targetPlayer) then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==1) then
					local playerName = getPlayerName(thePlayer)
					outputChatBox("PM From Hidden Admin: " .. message, targetPlayer, 255, 255, 0)
					outputChatBox("Hidden PM Sent to " .. targetPlayerName .. ": " .. message, thePlayer, 255, 255, 0)
				elseif (logged==0) then
					outputChatBox("Player is not logged in yet.", thePlayer, 255, 255, 0)
				end
			end
		end
	end
end
addCommandHandler("hw", hiddenWhisper, false, false)

-- Kick
function kickAPlayer(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Reason]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				reason = table.concat({...}, " ")
				
				if (targetPlayerPower <= thePlayerPower) then
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local playerName = getPlayerName(thePlayer)
					--[[outputDebugString("---------------")
					outputDebugString(getPlayerName(targetPlayer))
					outputDebugString(tostring(getElementData(targetPlayer, "account:id")))
					outputDebugString(getPlayerName(thePlayer))
					outputDebugString(tostring(getElementData(thePlayer, "account:id")))
					outputDebugString(tostring(hiddenAdmin))
					outputDebugString(reason)]]
					mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("' .. mysql:escape_string(getPlayerName(targetPlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(targetPlayer, "account:id") or 0)) .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',' .. mysql:escape_string(hiddenAdmin) .. ',1,0,"' .. mysql:escape_string(reason) .. '")' )
					
					if (hiddenAdmin==0) then
						if commandName ~= "skick" then
							local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
							outputChatBox("AdmKick: " .. adminTitle .. " " .. playerName .. " kicked " .. targetPlayerName .. ".", getRootElement(), 255, 0, 51)
							outputChatBox("AdmKick: Reason: " .. reason .. ".", getRootElement(), 255, 0, 51)
						end
						kickPlayer(targetPlayer, thePlayer, reason)
					else
						if commandName ~= "skick" then
							outputChatBox("AdmKick: Hidden Admin kicked " .. targetPlayerName .. ".", getRootElement(), 255, 0, 51)
							outputChatBox("AdmKick: Reason: " .. reason, getRootElement(), 255, 0, 51)
						end
						kickPlayer(targetPlayer, getRootElement(), reason)
					end
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "PKICK "..reason)
				else
					outputChatBox(" This player is a higher level admin than you.", thePlayer, 255, 0, 0)
					outputChatBox(playerName .. " attempted to execute the kick command on you.", targetPlayer, 255, 0 ,0)
				end
			end
		end
	end
end
addCommandHandler("pkick", kickAPlayer, false, false)
addCommandHandler("skick", kickAPlayer, false, false)



function makePlayerAdmin(thePlayer, commandName, who, rank)
	if exports.global:isPlayerHeadAdmin(thePlayer) or exports.global:isPlayerGMTeamLeader(thePlayer) then
		if not (who) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name/ID] [Rank, -1 .. -4 = GMs, 1 .. 6 = admins]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, who)
			
			if (targetPlayer) then
				rank = math.floor(tonumber(rank))
				if exports.global:isPlayerHeadAdmin(thePlayer) then
				elseif exports.global:isPlayerGMTeamLeader(thePlayer) then
					-- do restrict GM team leader to set GM ranks only
					if exports.global:isPlayerAdmin(targetPlayer) then
						outputChatBox("You can't set this player's rank.", thePlayer, 255, 0, 0)
						return
					else
						if rank > 0 or rank < -4 then
							outputChatBox("You can't set this rank.", thePlayer, 255, 0, 0)
							return
						end
					end
				else
					return
				end
				
				local username = getPlayerName(thePlayer)
				local accountID = getElementData(targetPlayer, "account:id")
				
				local query = mysql:query_free("UPDATE accounts SET admin='" .. mysql:escape_string(rank) .. "', hiddenadmin='0' WHERE id='" .. mysql:escape_string(accountID) .. "'")
				if (rank > 0) or (rank == -999999999) then
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminduty", 1, false)
				else
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminduty", 0, false)
				end
				mysql:query_free("UPDATE accounts SET adminduty=" .. mysql:escape_string(getElementData(targetPlayer, "adminduty")) .. " WHERE id = " .. mysql:escape_string(getElementData(targetPlayer, "account:id")) )
				
				
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				if (rank < 0) then
					local gmrank = -rank
					outputChatBox("You set " .. targetPlayerName .. "'s GM rank to " .. tostring(gmrank) .. ".", thePlayer, 0, 255, 0)
					outputChatBox(adminTitle .. " " .. username .. " set your GM rank to " .. gmrank .. ".", targetPlayer, 255, 194, 14)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "account:gmlevel", gmrank, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "account:gmduty", true, true)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminlevel", 0, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminduty", 0, false)
				else
					outputChatBox(adminTitle .. " " .. username .. " set your admin rank to " .. rank .. ".", targetPlayer, 255, 194, 14)
					outputChatBox("You set " .. targetPlayerName .. "'s Admin rank to " .. tostring(rank) .. ".", thePlayer, 0, 255, 0)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminlevel", rank, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "adminduty", 1, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "account:gmlevel", 0, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "account:gmduty", false, true)
				end
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "MAKEADMIN " .. rank)
				
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				
				-- Fix for scoreboard & nametags
				if (hiddenAdmin==0) then
					exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " set " .. targetPlayerName .. "'s admin level to " .. rank .. ".")
				end
				
				exports.global:updateNametagColor(targetPlayer)
			end
		end
	end
end
addCommandHandler("makeadmin", makePlayerAdmin, false, false)

function setMoney(thePlayer, commandName, target, money)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local money = tonumber((money:gsub(",","")))
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Money]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETMONEY "..money)
				exports.global:setMoney(targetPlayer, money)
				outputChatBox(targetPlayerName .. " now has " .. exports.global:formatMoney(money) .. " $.", thePlayer)
				outputChatBox("Admin " .. username .. " set your money to " .. exports.global:formatMoney(money) .. " $.", targetPlayer)
			end
		end
	end
end
addCommandHandler("setmoney", setMoney, false, false)

function giveMoney(thePlayer, commandName, target, money)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local money = tonumber((money:gsub(",","")))
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Money]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEMONEY " ..money)
				exports.global:giveMoney(targetPlayer, money)
				outputChatBox("You have given " .. targetPlayerName .. " $" .. exports.global:formatMoney(money) .. ".", thePlayer)
				outputChatBox("Admin " .. username .. " has given you $" .. exports.global:formatMoney(money) .. ".", targetPlayer)
			end
		end
	end
end
addCommandHandler("givemoney", giveMoney, false, false)

-----------------------------------[FREEZE]----------------------------------
function freezePlayer(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerFullGameMaster(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local textStr = "admin"
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				if exports.global:isPlayerGameMaster(thePlayer) then
					textStr = "gamemaster"
					adminTitle = exports.global:getPlayerGMTitle(thePlayer)
				end
				local veh = getPedOccupiedVehicle( targetPlayer )
				if (veh) then
					setElementFrozen(veh, true)
					toggleAllControls(targetPlayer, false, true, false)
					outputChatBox(" You have been frozen by an ".. textStr ..". Take care when following instructions.", targetPlayer)
					outputChatBox(" You have frozen " ..targetPlayerName.. ".", thePlayer)
				else
					detachElements(targetPlayer)
					toggleAllControls(targetPlayer, false, true, false)
					setElementFrozen(targetPlayer, true)
					triggerClientEvent(targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
					setPedWeaponSlot(targetPlayer, 0)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "freeze", 1, false)
					outputChatBox(" You have been frozen by an ".. textStr ..". Take care when following instructions.", targetPlayer)
					outputChatBox(" You have frozen " ..targetPlayerName.. ".", thePlayer)
				end
				
				local username = getPlayerName(thePlayer)
				exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " froze " .. targetPlayerName .. ".")
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "FREEZE")
			end
		end
	end
end
addCommandHandler("freeze", freezePlayer, false, false)
addEvent("remoteFreezePlayer", true )
addEventHandler("remoteFreezePlayer", getRootElement(), freezePlayer)

-----------------------------------[UNFREEZE]----------------------------------
function unfreezePlayer(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerFullGameMaster(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " /unfreeze [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local textStr = "admin"
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				if exports.global:isPlayerGameMaster(thePlayer) then
					textStr = "gamemaster"
					adminTitle = exports.global:getPlayerGMTitle(thePlayer)
				end
			
				local veh = getPedOccupiedVehicle( targetPlayer )
				if (veh) then
					setElementFrozen(veh, false)
					toggleAllControls(targetPlayer, true, true, true)
					triggerClientEvent(targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
					if (isElement(targetPlayer)) then
						outputChatBox(" You have been unfrozen by an ".. textStr ..". Thanks for your co-operation.", targetPlayer)
					end
					
					if (isElement(thePlayer)) then
						outputChatBox(" You have unfrozen " ..targetPlayerName.. ".", thePlayer)
					end
				else
					toggleAllControls(targetPlayer, true, true, true)
					setElementFrozen(targetPlayer, false)
					-- Disable weapon scrolling if restrained
					if getElementData(targetPlayer, "restrain") == 1 then
						setPedWeaponSlot(targetPlayer, 0)
						toggleControl(targetPlayer, "next_weapon", false)
						toggleControl(targetPlayer, "previous_weapon", false)
					end
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "freeze", false, false)
					outputChatBox(" You have been unfrozen by an ".. textStr ..". Thanks for your co-operation.", targetPlayer)
					outputChatBox(" You have unfrozen " ..targetPlayerName.. ".", thePlayer)
				end

				local username = getPlayerName(thePlayer)
				exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " unfroze " .. targetPlayerName .. ".")
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNFREEZE")
			end
		end
	end
end
addCommandHandler("unfreeze", unfreezePlayer, false, false)

function adminDuty(thePlayer, commandName)
	if exports.global:isPlayerAdmin(thePlayer) then
		local adminduty = getElementData(thePlayer, "adminduty")
		local username = getPlayerName(thePlayer)
		
		if (adminduty==0) then
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "adminduty", 1, false)
			outputChatBox("You went on admin duty.", thePlayer, 0, 255, 0)
			exports.global:sendMessageToAdmins("AdmDuty: " .. username .. " came on duty.")
		elseif (adminduty==1) then
			local adminlevel = getElementData(thePlayer, "adminlevel")
			if (adminlevel == 1) then
				outputChatBox("Trial admins can't go off duty.", thePlayer, 255, 0, 0)
				return
			end
		
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "adminduty", 0, false)
			outputChatBox("You went off admin duty.", thePlayer, 255, 0, 0)
			exports.global:sendMessageToAdmins("AdmDuty: " .. username .. " went off duty.")
		end
		mysql:query_free("UPDATE accounts SET adminduty=" .. mysql:escape_string(getElementData(thePlayer, "adminduty")) .. " WHERE id = '" .. mysql:escape_string(getElementData(thePlayer, "account:id")).."'" )
		exports.global:updateNametagColor(thePlayer)
	end
end
addCommandHandler("adminduty", adminDuty, false, false)

function gmDuty(thePlayer, commandName)
	if exports.global:isPlayerGameMaster(thePlayer) then
		local gmDuty = getElementData(thePlayer, "account:gmduty")
		local username = getPlayerName(thePlayer)
		
		if not (gmDuty) then
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "account:gmduty", true, true)
			outputChatBox("You went on GM duty.", thePlayer, 0, 255, 0)
			exports.global:sendMessageToAdmins("GMDuty: " .. username .. " came on duty.")
			mysql:query_free("UPDATE accounts SET adminduty='1' WHERE id = '" .. mysql:escape_string(getElementData(thePlayer, "account:id")).."'" )
		else	
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "account:gmduty", false, true)
			outputChatBox("You went off GM duty.", thePlayer, 255, 0, 0)
			exports.global:sendMessageToAdmins("GMDuty: " .. username .. " went off duty.")
			mysql:query_free("UPDATE accounts SET adminduty='0' WHERE id = '" .. mysql:escape_string(getElementData(thePlayer, "account:id")).."'" )
		end
		
		exports.global:updateNametagColor(thePlayer)
	end
end
addCommandHandler("gmduty", gmDuty, false, false)

----------------------------[SET MOTD]---------------------------------------
function setMOTD(thePlayer, commandName, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: " .. commandName .. " [message]", thePlayer, 255, 194, 14)
		else
			local message = table.concat({...}, " ")
			local query = mysql:query_free("UPDATE settings SET value='" .. mysql:escape_string(message) .. "' WHERE name='motd'")
			triggerClientEvent("updateMOTD", thePlayer, message)
			
			if (query) then
				outputChatBox("MOTD set to '" .. message .. "'.", thePlayer, 0, 255, 0)
				exports.logs:dbLog(thePlayer, 4, thePlayer, "SETMOTD "..message)
				exports['anticheat-system']:changeProtectedElementDataEx(getRootElement(), "account:motd", message, false )
			else
				outputChatBox("Failed to set MOTD.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setmotd", setMOTD, false, false)

function getMOTD(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	if (logged==1) then
		local motd = getElementData(getRootElement(), "account:motd") or ""
		outputChatBox("MOTD: " .. motd, thePlayer, 255, 255, 0)
	end
end
addCommandHandler("motd", getMOTD, false, false)



----------------------------[SET ADMIN MOTD]---------------------------------------
function setAdminMOTD(thePlayer, commandName, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: " .. commandName .. " [message]", thePlayer, 255, 194, 14)
		else
			local message = table.concat({...}, " ")
			local query = mysql:query_free("UPDATE settings SET value='" .. mysql:escape_string(message) .. "' WHERE name='amotd'")
			
			if (query) then
				outputChatBox("Admin MOTD set to '" .. message .. "'.", thePlayer, 0, 255, 0)
				exports.logs:dbLog(thePlayer, 4, thePlayer, "SETADMINMOTD "..message)
				exports['anticheat-system']:changeProtectedElementDataEx(getRootElement(), "account:amotd", message, false )
			else
				outputChatBox("Failed to set MOTD.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setamotd", setAdminMOTD, false, false)

function getAdminMOTD(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local amotd = getElementData(getRootElement(), "account:amotd") or ""
		outputChatBox("Admin MOTD: " .. amotd, thePlayer, 135, 206, 250)
		local accountID = tonumber(getElementDataEx(thePlayer, "account:id"))
		local ticketCenterQuery = mysql:query_fetch_assoc("SELECT count(*) as 'noreports' FROM `tc_tickets` WHERE `status` < 3 and `assigned`='".. mysql:escape_string(accountID).."'")
		if (tonumber(ticketCenterQuery["noreports"]) > 0) then
			outputChatBox("You have "..tostring(ticketCenterQuery["noreports"]).." reports assigned to you on the ticket center.", thePlayer, 135, 206, 250)
		end
	end
end
addCommandHandler("amotd", getAdminMOTD, false, false)

-- GET PLAYER ID
function getPlayerID(thePlayer, commandName, target)
	if not (target) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
	else
		local username = getPlayerName(thePlayer)
		local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
		
		if targetPlayer then
			local logged = getElementData(targetPlayer, "loggedin")
			if (logged==1) then
				local id = getElementData(targetPlayer, "playerid")
				outputChatBox("** " .. targetPlayerName .. "'s ID is " .. id .. ".", thePlayer, 255, 194, 14)
			else
				outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("getid", getPlayerID, false, false)
addCommandHandler("id", getPlayerID, false, false)

-- EJECT
function ejectPlayer(thePlayer, commandName, target)
	if not (target) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
	else
		if not (isPedInVehicle(thePlayer)) then
			outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
		else
			local vehicle = getPedOccupiedVehicle(thePlayer)
			local seat = getPedOccupiedVehicleSeat(thePlayer)
			
			if (seat~=0) then
				outputChatBox("You must be the driver to eject.", thePlayer, 255, 0, 0)
			else
				local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
				
				if not (targetPlayer) then
				elseif (targetPlayer==thePlayer) then
					outputChatBox("You cannot eject yourself.", thePlayer, 255, 0, 0)
				else
					local targetvehicle = getPedOccupiedVehicle(targetPlayer)
					
					if targetvehicle~=vehicle and not exports.global:isPlayerAdmin(thePlayer) then
						outputChatBox("This player is not in your vehicle.", thePlayer, 255, 0, 0)
					else
						outputChatBox("You have thrown " .. targetPlayerName .. " out of your vehicle.", thePlayer, 0, 255, 0)
						removePedFromVehicle(targetPlayer)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "realinvehicle", 0, false)
					end
				end
			end
		end
	end
end
addCommandHandler("eject", ejectPlayer, false, false)

-- WARNINGS
function warnPlayer(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetPlayer) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Reason]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local accountID = getElementData(targetPlayer, "account:id")
				if not accountID then
					return
				end
				
				local fetchData = mysql:query_fetch_assoc("SELECT `warns` FROM `accounts` WHERE `id`='"..mysql:escape_string(accountID).."'")
				
				local playerName = getPlayerName(thePlayer)
				local warns = fetchData["warns"] or 0
				reason = table.concat({...}, " ")
				warns = warns + 1
				
				mysql:query_free("UPDATE accounts SET warns=" .. mysql:escape_string(warns) .. ", monitored = 'Warn for " .. mysql:escape_string(reason) .. "' WHERE id = " .. mysql:escape_string(accountID) )
				outputChatBox("You have given " .. targetPlayerName .. " a warning. (" .. warns .. "/3).", thePlayer, 255, 0, 0)
				outputChatBox("You have been given a warning by " .. getPlayerName(thePlayer) .. ".", targetPlayer, 255, 0, 0)
				outputChatBox("Reason: " .. reason, targetPlayer, 255, 0, 0)
				
				exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "warns", warns, false)
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "WARN "..warns .. ": " .. reason)
				
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("' .. mysql:escape_string(getPlayerName(targetPlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(targetPlayer, "account:id") or 0)) .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',' .. mysql:escape_string(hiddenAdmin) .. ',4,0,"' .. mysql:escape_string(reason) .. '")' )

				if (hiddenAdmin==0) then
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					outputChatBox("AdmWarn: " .. adminTitle .. " " .. playerName .. " warned " .. targetPlayerName .. ". (" .. warns .. "/3)", getRootElement(), 255, 0, 51)
				end
				
				if (warns>=3) then
					mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("' .. mysql:escape_string(getPlayerName(targetPlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(targetPlayer, "account:id") or 0)) .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',' .. mysql:escape_string(hiddenAdmin) .. ',5,0,"' .. mysql:escape_string(warns) .. ' Admin Warnings")' )
					banPlayer(targetPlayer, false, false, true, thePlayer, "Received " .. warns .. " admin warnings.", 0)
					outputChatBox("AdmWarn: " .. targetPlayerName .. " was banned for several admin warnings.", getRootElement(), 255, 0, 51)
					
					mysql:query_free("UPDATE accounts SET banned='1', banned_reason='3 Admin Warnings', banned_by='Warn System' WHERE id='" .. mysql:escape_string(accountID) .. "'")
				else
					local countedWarns = 0
					local result = mysql:query_fetch_assoc("SELECT SUM(`warns`) AS warns FROM `accounts` WHERE `ip`='" .. mysql:escape_string( getPlayerIP(targetPlayer) ) .. "' OR mtaserial='" .. mysql:escape_string( getPlayerSerial(targetPlayer) ) .."'")
					if result then
						countedWarns = tonumber( result.warns )
						if (countedWarns >= 3) then
							mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("' .. mysql:escape_string(getPlayerName(targetPlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(targetPlayer, "account:id") or 0)) .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',' .. mysql:escape_string(hiddenAdmin) .. ',5,0,"' .. mysql:escape_string(warns) .. ' Admin Warnings over multiple accounts.")' )
							banPlayer(targetPlayer, false, false, true, thePlayer, "Received " .. warns .. " admin warnings over multiple accounts.", 0)
							outputChatBox("AdmWarn: " .. targetPlayerName .. " was banned for several admin warnings over multiple accounts.", getRootElement(), 255, 0, 51)
							mysql:query_free("UPDATE accounts SET banned='1', banned_reason='3 Admin Warnings', banned_by='Warn System' WHERE id='" .. mysql:escape_string(accountID) .. "'")
						end
					end
				end
			end
		end
	end
end
addCommandHandler("warn", warnPlayer, false, false)

-- RESET CHARACTER
function resetCharacter(thePlayer, commandName, ...)
	if exports.global:isPlayerLeadAdmin(thePlayer) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [exact character name]", thePlayer, 255, 0, 0)
		else
			local character = table.concat({...}, "_")
			if getPlayerFromName(character) then
				kickPlayer(getPlayerFromName(character), "Character Reset")
			end
				
			local result = mysql:query_fetch_assoc("SELECT id, account FROM characters WHERE charactername='" .. mysql:escape_string(character) .. "'")
			local charid = tonumber(result["id"])
			local account = tonumber(result["account"])
			
			if charid then
				-- delete all in-game vehicles
				for key, value in pairs( getElementsByType( "vehicle" ) ) do
					if isElement( value ) then
						if getElementData( value, "owner" ) == charid then
							call( getResourceFromName( "item-system" ), "deleteAll", 3, getElementData( value, "dbid" ) )
							destroyElement( value )
						end
					end
				end
				mysql:query_free("DELETE FROM vehicles WHERE owner = " .. mysql:escape_string(charid) )
				
				-- un-rent all interiors
				local old = getElementData( thePlayer, "dbid" )
				exports['anticheat-system']:changeProtectedElementDataEx( thePlayer, "dbid", charid, false )
				local result = mysql:query("SELECT id FROM interiors WHERE owner = " .. mysql:escape_string(charid) .. " AND type != 2" )
				if result then
					local continue = true
					while continue do
						local row = mysql:fetch_assoc(result)
						if not row then break end
						
						local id = tonumber(row["id"])
						call( getResourceFromName( "interior-system" ), "publicSellProperty", thePlayer, id, false, false )
					end
				end
				exports['anticheat-system']:changeProtectedElementDataEx( thePlayer, "dbid", old, false )
				
				-- get rid of all items, give him default items back
				mysql:query_free("DELETE FROM items WHERE type = 1 AND owner = " .. mysql:escape_string(charid) )
				
				-- get the skin
				local skin = 264
				local skinr = mysql:query_fetch_assoc("SELECT skin FROM characters WHERE id = " .. mysql:escape_string(charid) )
				if skinr then
					skin = tonumber(skinr["skin"]) or 264
				end
				
				mysql:query_free("INSERT INTO items (type, owner, itemID, itemValue) VALUES (1, " .. mysql:escape_string(charid) .. ", 16, " .. mysql:escape_string(skin) .. ")" )
				mysql:query_free("INSERT INTO items (type, owner, itemID, itemValue) VALUES (1, " .. mysql:escape_string(charid) .. ", 17, 1)" )
				mysql:query_free("INSERT INTO items (type, owner, itemID, itemValue) VALUES (1, " .. mysql:escape_string(charid) .. ", 18, 1)" )
				
				-- delete wiretransfers
				mysql:query_free("DELETE FROM wiretransfers WHERE `from` = " .. mysql:escape_string(charid) .. " OR `to` = " .. mysql:escape_string(charid) )
				
				-- set spawn at unity, strip off money etc
				mysql:query_free("UPDATE characters SET x=1742.1884765625, y=-1861.3564453125, z=13.577615737915, rotation=0, faction_id=-1, faction_rank=0, faction_leader=0, weapons='', ammo='', car_license=0, gun_license=0, lastarea='El Corona', lang1=1, lang1skill=100, lang2=0, lang2skill=0, lang3=0, lang3skill=0, currLang=1, money=250, bankmoney=500, interior_id=0, dimension_id=0, health=100, armor=0, fightstyle=0, pdjail=0, pdjail_time=0, restrainedobj=0, restrainedby=0, fish=0, truckingruns=0, truckingwage=0, blindfold=0 WHERE id = " .. mysql:escape_string(charid) )
				
				outputChatBox("You stripped " .. character .. " off their possession.", thePlayer, 0, 255, 0)
				if (getElementData(thePlayer, "hiddenadmin")==0) then
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " has reset " .. character .. ".")
				end
				
				exports.logs:dbLog(thePlayer, 4, "ch"..tostring(charid), "RESETCHARACTER")
			else
				outputChatBox("Couldn't find " .. character, thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("resetcharacter", resetCharacter)

function getGM(admin, command)
	if exports.global:isPlayerAdmin(admin) then
		if getElementData(admin, "account:gmlevel") > 0 then
			exports['anticheat-system']:changeProtectedElementDataEx(admin, "account:gmlevel", 0, false)
			exports['anticheat-system']:changeProtectedElementDataEx(admin, "account:gmduty", false, true)
			outputChatBox("Set to GM level 0.", admin, 255, 194, 14)
		else
			if exports.global:isPlayerHeadAdmin(admin) or exports.global:isPlayerGMTeamLeader(admin) then
				exports['anticheat-system']:changeProtectedElementDataEx(admin, "account:gmlevel", 4, false)
				exports['anticheat-system']:changeProtectedElementDataEx(admin, "account:gmduty", true, true)
				outputChatBox("Set to GM level 4.", admin, 255, 194, 14)
			elseif exports.global:isPlayerLeadAdmin(admin) then
				exports['anticheat-system']:changeProtectedElementDataEx(admin, "account:gmlevel", 3, false)
				exports['anticheat-system']:changeProtectedElementDataEx(admin, "account:gmduty", true, true)
				outputChatBox("Set to GM level 3.", admin, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("getgmrank", getGM)

function vehicleLimit(admin, command, player, limit)
	if exports.global:isPlayerLeadAdmin(admin) then
		if (not player and not limit) then
			outputChatBox("SYNTAX: /" .. command .. " [Player] [Limit]", admin, 255, 194, 14)
		else
			local tplayer, targetPlayerName = exports.global:findPlayerByPartialNick(admin, player)
			if (tplayer) then
				local query = mysql:query_fetch_assoc("SELECT maxvehicles FROM characters WHERE id = " .. mysql:escape_string(getElementData(tplayer, "dbid")))
				if (query) then
					local oldvl = query["maxvehicles"]
					local newl = tonumber(limit)
					if (newl) then
						if (newl>0) then
							mysql:query_free("UPDATE characters SET maxvehicles = " .. mysql:escape_string(newl) .. " WHERE id = " .. mysql:escape_string(getElementData(tplayer, "dbid")))

							exports['anticheat-system']:changeProtectedElementDataEx(tplayer, "maxvehicles", newl, false)
							
							outputChatBox("You have set " .. targetPlayerName:gsub("_", " ") .. " vehicle limit to " .. newl .. ".", admin, 255, 194, 14)
							outputChatBox("Admin " .. getPlayerName(admin):gsub("_"," ") .. " has set your vehicle limit to " .. newl .. ".", tplayer, 255, 194, 14)
							
							exports.logs:dbLog(thePlayer, 4, tplayer, "SETVEHLIMIT "..oldvl.." "..newl)
						else
							outputChatBox("You can not set a level below 0", admin, 255, 194, 14)
						end
					end
				end
			else
				outputChatBox("Something went wrong with picking the player.", admin)
			end
		end
	end
end
addCommandHandler("setvehlimit", vehicleLimit)
