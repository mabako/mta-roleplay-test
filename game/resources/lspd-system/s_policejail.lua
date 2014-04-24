-- cells
cells =
{
	createColSphere( 227.5, 114.7, 999.02, 2 ), --1
	createColSphere( 223.5, 114.7, 999.02, 2 ), --2
	createColSphere( 219.5, 114.7, 999.02, 2 ), --3
	createColSphere( 215.5, 114.7, 999.02, 2 ), --4
		-- Sherrifs
	
	createColSphere( 1939.3173828125, -2383.236328125, 33.558120727539, 3 ),	-- 5
	createColSphere( 1934.3173828125, -2383.3759765625, 33.558120727539, 3 ), -- 6
	createColSphere( 1929.3173828125, -2383.3759765625, 33.558120727539, 3 ), -- 7	
	createColSphere( 1938.9970703125, -2369.775390625, 33.551563262939, 3 ),	-- 8
	createColSphere( 1934.3173828125, -2369.775390625, 33.551563262939, 3 ), -- 9
	createColSphere( 1929.3173828125, -2369.775390625, 33.551563262939, 3 ), -- 10
	
	

	--createColSphere(1805.1162109375, -2445.5634765625, 113.55146026611, 3 ),
	--createColSphere(1800.919921875, -2445.8955078125, 113.55146026611, 3 ),
	--createColSphere(1805.06640625, -2461.1640625, 113.55801391602, 3 ),

}

for k, v in pairs( cells ) do
	setElementInterior( v, k <= 4 and 10 or 11 )
	setElementDimension( v, k <= 4 and 1 or 1483 )
	if k <= 4 then
		setElementData(v, "spawnoffset", -5, false)
	else
		setElementData(v, "spawnoffset", 0, false)
	end
end

function isInArrestColshape( thePlayer )
	for k, v in pairs( cells ) do
		if isElementWithinColShape( thePlayer, v ) and getElementDimension( thePlayer ) == getElementDimension( v ) then
			return k
		end
	end
	return false
end

function destroyJailTimer ( ) -- 0001290: PD /release bug
	local theMagicTimer = getElementData(source, "pd.jailtimer") -- 0001290: PD /release bug
	if (isTimer(theMagicTimer)) then
		killTimer(theMagicTimer) 
		exports['anticheat-system']:changeProtectedElementDataEx(source, "pd.jailserved", 0, false)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "pd.jailtime", 0, false)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "pd.jailtimer", false, false)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "pd.jailstation", false, false)
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), destroyJailTimer )

-- /arrest
function arrestPlayer(thePlayer, commandName, targetPlayerNick, fine, jailtime, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if (jailtime) then
			jailtime = tonumber(jailtime)
		end
		
		local playerCol = isInArrestColshape(thePlayer)
		if (factionType==2) and playerCol then
			if not (targetPlayerNick) or not (fine) or not (jailtime) or not (...) or (jailtime<1) or (jailtime>181) then
				outputChatBox("SYNTAX: /arrest [Player Partial Nick / ID] [Fine] [Jail Time (Minutes 1->180)] [Crimes Committed]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
				if targetPlayer then
					local targetCol = isInArrestColshape(targetPlayer)
					
					if not targetCol then
						outputChatBox("The player is not within range of the booking desk.", thePlayer, 255, 0, 0)
					elseif targetCol ~= playerCol then
						outputChatBox("The player is standing infront of another cell.", thePlayer, 255, 0, 0)
					else
						local jailTimer = getElementData(targetPlayer, "pd.jailtimer")
						local username  = getPlayerName(thePlayer)
						local reason = table.concat({...}, " ")
						
						if (jailTimer) then
							outputChatBox("This player is already serving a jail sentence.", thePlayer, 255, 0, 0)
						else
							local finebank = false
							local targetPlayerhasmoney = exports.global:getMoney(targetPlayer, true)
							local amount = tonumber(fine)
							if not exports.global:takeMoney(targetPlayer, amount) then
								finebank = true
								exports.global:takeMoney(targetPlayer, targetPlayerhasmoney)
								local fineleft = amount - targetPlayerhasmoney
								local bankmoney = getElementData(targetPlayer, "bankmoney")
								exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "bankmoney", bankmoney-fineleft, false)
							end
						
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "pd.jailserved", 0, false)
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "pd.jailtime", jailtime+1, false)
							
							toggleControl(targetPlayer,'next_weapon',false)
							toggleControl(targetPlayer,'previous_weapon',false)
							toggleControl(targetPlayer,'fire',false)
							toggleControl(targetPlayer,'aim_weapon',false)
							
							-- auto-uncuff
							local restrainedObj = getElementData(targetPlayer, "restrainedObj")
							if restrainedObj then
								toggleControl(targetPlayer, "sprint", true)
								toggleControl(targetPlayer, "jump", true)
								toggleControl(targetPlayer, "accelerate", true)
								toggleControl(targetPlayer, "brake_reverse", true)
								exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "restrain", 0, true)
								exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "restrainedBy", false, true)
								exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "restrainedObj", false, true)
								if restrainedObj == 45 then -- If handcuffs.. take the key
									local dbid = getElementData(targetPlayer, "dbid")
									exports['item-system']:deleteAll(47, dbid)
								end
								exports.global:giveItem(thePlayer, restrainedObj, 1)
								mysql:query_free("UPDATE characters SET cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
							end
							setPedWeaponSlot(targetPlayer,0)
							
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "pd.jailstation", targetCol, false)
							
							mysql:query_free("UPDATE characters SET pdjail='1', pdjail_time='" .. mysql:escape_string(jailtime) .. "', pdjail_station='" .. mysql:escape_string(targetCol) .. "', cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
							outputChatBox("You jailed " .. targetPlayerNick .. " for " .. jailtime .. " Minutes.", thePlayer, 255, 0, 0)
							
							local x, y, z = getElementPosition(cells[targetCol])
							local offset = getElementData(cells[targetCol], "spawnoffset")
							setElementPosition(targetPlayer, x, y + offset, z)
							setPedRotation(targetPlayer, 0)
							
							-- Show the message to the faction
							local theTeam = getPlayerTeam(thePlayer)
							local teamPlayers = getPlayersInTeam(theTeam)

							local factionID = getElementData(thePlayer, "faction")
							local factionRank = getElementData(thePlayer, "factionrank")
														
							local factionRanks = getElementData(theTeam, "ranks")
							local factionRankTitle = factionRanks[factionRank]
							
							outputChatBox("You were arrested by " .. username .. " for " .. jailtime .. " minute(s).", targetPlayer, 0, 102, 255)
							outputChatBox("Crimes Committed: " .. reason .. ".", targetPlayer, 0, 102, 255)
							if (finebank == true) then
								outputChatBox("The rest of the fine has been taken from your banking account.", targetPlayer, 0, 102, 255)
							end
							
							for key, value in ipairs(teamPlayers) do
								outputChatBox(factionRankTitle .. " " .. username .. " arrested " .. targetPlayerNick .. " for " .. jailtime .. " minute(s).", value, 0, 102, 255)
								outputChatBox("Crimes Committed: " .. reason .. ".", value, 0, 102, 255)
							end
							timerPDUnjailPlayer(targetPlayer)
							exports.logs:logMessage("[PD/ARREST] ".. factionRankTitle .. " " .. username .. " jailed " .. targetPlayerNick .. " for " .. jailtime .. " minute(s). Reason: "..reason , 30)
						end
					end
				end
			end
		end
	end
end
addCommandHandler("arrest", arrestPlayer)

function timerPDUnjailPlayer(jailedPlayer)
	if(isElement(jailedPlayer)) then
		local timeServed = tonumber(getElementData(jailedPlayer, "pd.jailserved"))
		local timeLeft = getElementData(jailedPlayer, "pd.jailtime")
		local username = getPlayerName(jailedPlayer)
		
		if ( timeServed ) then
			exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "pd.jailserved", tonumber(timeServed)+1, false)
			local timeLeft = timeLeft - 1
			exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "pd.jailtime", timeLeft, false)

			if (timeLeft<=0) then
				theMagicTimer = nil
				fadeCamera(jailedPlayer, false)
				if (getElementData(jailedPlayer, "pd.jailstation") <= 4) then
					-- LSPD
					mysql:query_free("UPDATE characters SET pdjail_time='0', pdjail='0', pdjail_station='0' WHERE id=" .. mysql:escape_string(getElementData(jailedPlayer, "dbid")))
					setElementDimension(jailedPlayer, getElementData(jailedPlayer, "pd.jailstation") <= 4 and 1 or 10583)
					setElementInterior(jailedPlayer, 10)
					setCameraInterior(jailedPlayer, 10)
					setElementPosition(jailedPlayer, 241.3583984375, 115.232421875, 1003.2257080078)
					setPedRotation(jailedPlayer, 270)
				else
					-- Sheriffs
					mysql:query_free("UPDATE characters SET pdjail_time='0', pdjail='0', pdjail_station='0' WHERE id=" .. mysql:escape_string(getElementData(jailedPlayer, "dbid")))
					setElementDimension(jailedPlayer, 1483)
					setElementInterior(jailedPlayer, 11)
					setCameraInterior(jailedPlayer, 11)
					setElementPosition(jailedPlayer, 1965.3037109375, -2427.748046875, 17.707571029663)
					setPedRotation(jailedPlayer, 90)
				end

				
					
				exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "pd.jailserved", 0, false)
				exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "pd.jailtime", 0, false)
				exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "pd.jailtimer", false, false)
				exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "pd.jailstation", false, false)
				
				toggleControl(jailedPlayer,'next_weapon',true)
				toggleControl(jailedPlayer,'previous_weapon',true)
				toggleControl(jailedPlayer,'fire',true)
				toggleControl(jailedPlayer,'aim_weapon',true)
				
				fadeCamera(jailedPlayer, true)
				outputChatBox("Your time has been served.", jailedPlayer, 0, 255, 0)

			elseif (timeLeft>0) then
				mysql:query_free("UPDATE characters SET pdjail_time='" .. mysql:escape_string(timeLeft) .. "' WHERE id=" .. mysql:escape_string(getElementData(jailedPlayer, "dbid")))
				local theTimer = setTimer(timerPDUnjailPlayer, 60000, 1, jailedPlayer)
				exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "pd.jailtimer", theTimer, false)
			end
		end
	end
end

function showJailtime(thePlayer)
	local ajailtime = getElementData(thePlayer, "jailtime")
	if ajailtime then
		outputChatBox("You have " .. ajailtime .. " minutes remaining on your admin jail.", thePlayer, 255, 194, 14)
	else
		local isJailed = getElementData(thePlayer, "pd.jailtimer")
		
		if not (isJailed) then
			outputChatBox("You are not jailed.", thePlayer, 255, 0, 0)
		else
			local jailtime = getElementData(thePlayer, "pd.jailtime")
			outputChatBox("You have " .. jailtime .. " minutes remaining of your jail sentence.", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("jailtime", showJailtime)

function jailRelease(thePlayer, commandName, targetPlayerNick)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if factionType == 2 and isInArrestColshape(thePlayer) then
			if not (targetPlayerNick) then
				outputChatBox("SYNTAX: /release [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
				if targetPlayer then
					local jailTimer = getElementData(targetPlayer, "pd.jailtimer")
					local username  = getPlayerName(thePlayer)
						
					if (jailTimer) then
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "pd.jailtime", 1, false)
						timerPDUnjailPlayer(targetPlayer)
						exports.logs:logMessage("[PD/RELEASE]" .. username .. " released "..targetPlayerNick , 30)
					else
						outputChatBox("This player is not serving a jail sentence.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("release", jailRelease)