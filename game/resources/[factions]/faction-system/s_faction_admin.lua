
-- // ADMIN COMMANDS
function createFaction(thePlayer, commandName, factionType, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction Type 0=GANG, 1=MAFIA, 2=LAW, 3=GOV, 4=MED, 5=OTHER, 6=NEWS][Faction Name]", thePlayer, 255, 194, 14)
		else
			factionName = table.concat({...}, " ")
			factionType = tonumber(factionType)
			
			local theTeam = createTeam(tostring(factionName))
			if theTeam then
				if mysql:query_free("INSERT INTO factions SET name='" .. mysql:escape_string(factionName) .. "', bankbalance='0', type='" .. mysql:escape_string(factionType) .. "'") then
					local id = mysql:insert_id()
					exports.pool:allocateElement(theTeam, id)
					
					mysql:query_free("UPDATE factions SET rank_1='Dynamic Rank #1', rank_2='Dynamic Rank #2', rank_3='Dynamic Rank #3', rank_4='Dynamic Rank #4', rank_5='Dynamic Rank #5', rank_6='Dynamic Rank #6', rank_7='Dynamic Rank #7', rank_8='Dynamic Rank #8', rank_9='Dynamic Rank #9', rank_10='Dynamic Rank #10', rank_11='Dynamic Rank #11', rank_12='Dynamic Rank #12', rank_13='Dynamic Rank #13', rank_14='Dynamic Rank #14', rank_15='Dynamic Rank #15', rank_16='Dynamic Rank #16', rank_17='Dynamic Rank #17', rank_18='Dynamic Rank #18', rank_19='Dynamic Rank #19', rank_20='Dynamic Rank #20',  motd='Welcome to the faction.', note = '' WHERE id='" .. id .. "'")
					outputChatBox("Faction " .. factionName .. " created with ID #" .. id .. ".", thePlayer, 0, 255, 0)
					exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "type", tonumber(factionType))
					exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "id", tonumber(id))
					exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "money", 0)
					
					local factionRanks = {}
					local factionWages = {}
					for i = 1, 20 do
						factionRanks[i] = "Dynamic Rank #" .. i
						factionWages[i] = 100
					end
					exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "ranks", factionRanks, false)
					exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "wages", factionWages, false)
					exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "motd", "Welcome to the faction.", false)
					exports['anticheat-system']:changeProtectedElementDataEx(theTeam, "note", "", false)
					exports.logs:dbLog(thePlayer, 4, theTeam, "MAKE FACTION")
				else
					destroyElement(theTeam)
					outputChatBox("Error creating faction.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Faction '" .. tostring(factionName) .. "' already exists.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("makefaction", createFaction, false, false)

function adminRenameFaction(thePlayer, commandName, factionID, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (factionID) or not (...)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction ID] [Faction Name]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				if (theTeam) then
					local factionName = table.concat({...}, " ")
					mysql:query_free("UPDATE factions SET name='" .. mysql:escape_string(factionName) .. "' WHERE id='" .. factionID .. "'")
					
					setTeamName(theTeam, factionName)
					
					outputChatBox("Faction #" .. factionID .. " was renamed to " .. factionName .. ".", thePlayer, 0, 255, 0)
				else
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("renamefaction", adminRenameFaction, false, false)

function adminSetPlayerFaction(thePlayer, commandName, partialNick, factionID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		factionID = tonumber(factionID)
		if not (partialNick) or not (factionID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name/ID] [Faction ID (-1 for none)]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, partialNick)
			
			if targetPlayer then
				local theTeam = exports.pool:getElement("team", factionID)
				if not theTeam and factionID ~= -1 then
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
					return
				end
				
				if mysql:query_free("UPDATE characters SET faction_leader = 0, faction_id = " .. factionID .. ", faction_rank = 1, duty = 0, dutyskin = -1 WHERE id=" .. getElementData(targetPlayer, "dbid")) then
					setPlayerTeam(targetPlayer, theTeam)
					if factionID > 0 then
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "faction", factionID, false)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "factionrank", 1, false)
						--triggerClientEvent(targetPlayer, "updateFactionInfo", targetPlayer, factionID, 1)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "dutyskin", -1, false)
						triggerEvent("duty:offduty", targetPlayer)
						
						outputChatBox("Player " .. targetPlayerNick .. " is now a member of faction '" .. getTeamName(theTeam) .. "' (#" .. factionID .. ").", thePlayer, 0, 255, 0)
						
						triggerEvent("onPlayerJoinFaction", targetPlayer, theTeam)
						outputChatBox("You were set to Faction '" .. getTeamName(theTeam) .. ".", targetPlayer, 255, 194, 14)
						
						exports.logs:dbLog(thePlayer, 4, { targetPlayer, theTeam }, "SET TO FACTION")
					else
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "faction", -1, false)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "factionrank", 1, false)
						--triggerClientEvent(targetPlayer, "updateFactionInfo", targetPlayer, -1, 1)
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "dutyskin", -1, false)
						if getElementData(targetPlayer, "duty") and getElementData(targetPlayer, "duty") > 0 then
							takeAllWeapons(targetPlayer)
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "duty", 0, false)
						end
						
						outputChatBox("Player " .. targetPlayerNick .. " was set to no faction.", thePlayer, 0, 255, 0)
						outputChatBox("You were removed from your faction.", targetPlayer, 255, 0, 0)
						
						exports.logs:dbLog(thePlayer, 4, { targetPlayer }, "REMOVE FROM FACTION")
					end
				end
			end
		end
	end
end
addCommandHandler("setfaction", adminSetPlayerFaction, false, false)

function adminSetFactionLeader(thePlayer, commandName, partialNick, factionID)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		factionID = tonumber(factionID)
		if not (partialNick) or not (factionID)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name] [Faction ID]", thePlayer, 255, 194, 14)
		elseif factionID > 0 then
			local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, partialNick)
			
			if targetPlayer then
				local theTeam = exports.pool:getElement("team", factionID)
				if not theTeam then
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
					return
				end
				
				if mysql:query_free("UPDATE characters SET faction_leader = 1, faction_id = " .. tonumber(factionID) .. ", faction_rank = 1, dutyskin = -1, duty = 0 WHERE id = " .. getElementData(targetPlayer, "dbid")) then
					setPlayerTeam(targetPlayer, theTeam)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "faction", factionID, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "factionrank", 1, false)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "factionleader", 1, false)
					--triggerClientEvent(targetPlayer, "updateFactionInfo", targetPlayer, factionID, 1)
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "dutyskin", -1, false)
					triggerEvent("duty:offduty", targetPlayer)
					
					outputChatBox("Player " .. targetPlayerNick .. " is now a leader of faction '" .. getTeamName(theTeam) .. "' (#" .. factionID .. ").", thePlayer, 0, 255, 0)
						
					triggerEvent("onPlayerJoinFaction", targetPlayer, theTeam)
					outputChatBox("You were set to the leader of Faction '" .. getTeamName(theTeam) .. ".", targetPlayer, 255, 194, 14)
					
					exports.logs:dbLog(thePlayer, 4, { targetPlayer, theTeam }, "SET TO FACTION LEADER")
				else
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setfactionleader", adminSetFactionLeader, false, false)

function adminSetFactionRank(thePlayer, commandName, partialNick, factionRank)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		factionRank = math.ceil(tonumber(factionRank) or -1)
		if not (partialNick) or not (factionRank)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name] [Faction Rank, 1-20]", thePlayer, 255, 194, 14)
		elseif factionRank >= 1 and factionRank <= 20 then
			local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, partialNick)
			
			if targetPlayer then
				local theTeam = getPlayerTeam(targetPlayer)
				if not theTeam or getTeamName( theTeam ) == "Citizen" then
					outputChatBox("Player is not in a faction.", thePlayer, 255, 0, 0)
					return
				end
				
				if mysql:query_free("UPDATE characters SET faction_rank = " .. factionRank .. " WHERE id = " .. getElementData(targetPlayer, "dbid")) then
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "factionrank", factionRank, false)
					
					outputChatBox("Player " .. targetPlayerNick .. " is now on rank " .. factionRank .. ".", thePlayer, 0, 255, 0)
					
					exports.logs:dbLog(thePlayer, 4, { targetPlayer, theTeam }, "SET TO FACTION RANK " .. factionRank)
				else
					outputChatBox("Error #125151 - Report on Mantis.", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox( "Invalid Rank - valid ones are 1 to 20", thePlayer, 255, 0, 0 )
		end
	end
end
addCommandHandler("setfactionrank", adminSetFactionRank, false, false)

function adminDeleteFaction(thePlayer, commandName, factionID)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (factionID)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction ID]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				
				if (theTeam) then
					if factionID == 57 then
						outputChatBox("So you did it! HA! Logged. Now stop deleting factions needed for the script. -Mount", thePlayer, 255, 0, 0)
						exports.logs:dbLog(thePlayer, 4, theTeam, "DELETE FACTION: BANKFACTION")
					else
						mysql:query_free("DELETE FROM factions WHERE id='" .. factionID .. "'")
						
						outputChatBox("Faction #" .. factionID .. " was deleted.", thePlayer, 0, 255, 0)
						exports.logs:dbLog(thePlayer, 4, theTeam, "DELETE FACTION")
						local civTeam = getTeamFromName("Citizen")
						for key, value in pairs( getPlayersInTeam( theTeam ) ) do
							setPlayerTeam( value, civTeam )
							exports['anticheat-system']:changeProtectedElementDataEx( value, "faction", -1, false )
							--triggerClientEvent(targetPlayer, "updateFactionInfo", targetPlayer, -1, 1)
						end
						destroyElement( theTeam )
					end
				else
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delfaction", adminDeleteFaction, false, false)

function adminShowFactions(thePlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local result = mysql:query("SELECT id, name, type, (SELECT COUNT(*) FROM characters c WHERE c.faction_id = f.id) AS members FROM factions f ORDER BY id ASC")
		if result then
			local factions = { }
			
			while true do
				local row = mysql:fetch_assoc(result)
				if not row then break end
				
				table.insert( factions, { row.id, row.name, row.type, ( getTeamFromName( row.name ) and #getPlayersInTeam( getTeamFromName( row.name ) ) or "?" ) .. " / " .. row.members } )
			end
			
			mysql:free_result(result)
			triggerClientEvent(thePlayer, "showFactionList", getRootElement(), factions)
		else
			outputChatBox("Error 300001 - Report on forums.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("showfactions", adminShowFactions, false, false)

function adminShowFactionOnlinePlayers(thePlayer, commandName, factionID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (factionID)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction ID]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				local theTeamName = getTeamName(theTeam)
				local teamPlayers = getPlayersInTeam(theTeam)
				
				if #teamPlayers == 0 then
					outputChatBox("There are no players online in faction '".. theTeamName .."'", thePlayer, 255, 194, 14)
				else
					local teamRanks = getElementData(theTeam, "ranks")
					outputChatBox("Players online in faction '".. theTeamName .."':", thePlayer, 255, 194, 14)
					for k, teamPlayer in ipairs(teamPlayers) do
						local leader = ""
						local playerRank = teamRanks [ getElementData(teamPlayer, "factionrank") ]
						if (getElementData(teamPlayer, "factionleader") == 1) then
							leader = "LEADER "
						end
						outputChatBox("  "..leader.." ".. getPlayerName(teamPlayer) .." - "..playerRank, thePlayer, 255, 194, 14)
					end
				end
			else
				outputChatBox("Faction not found.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("showfactionplayers", adminShowFactionOnlinePlayers, false, false)

function callbackAdminPlayersFaction(teamID)
	adminShowFactionOnlinePlayers(client, "showfactionplayers", teamID)
end
addEvent("faction:admin:showplayers", true )
addEventHandler("faction:admin:showplayers", getRootElement(), callbackAdminPlayersFaction)

function setFactionMoney(thePlayer, commandName, factionID, amount)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (factionID) or not (amount)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction ID] [Money]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				amount = tonumber(amount)
				
				if (theTeam) then
					exports.global:setMoney(theTeam, amount)
					outputChatBox("Set faction '" .. getTeamName(theTeam) .. "'s money to " .. amount .. " $.", thePlayer, 255, 194, 14)
				else
					outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("setfactionmoney", setFactionMoney, false, false)


-----

function loadWelfare( )
	local result = mysql:query_fetch_assoc( "SELECT value FROM settings WHERE name = 'welfare'" )
	if result then
		if not result.value then
			mysql:query_free( "INSERT INTO settings (name, value) VALUES ('welfare', " .. unemployedPay .. ")" )
		else
			unemployedPay = tonumber( result.value ) or 150
		end
	end
end
addEventHandler( "onResourceStart", resourceRoot, loadWelfare )

function getTax(thePlayer)
	loadWelfare( )
	outputChatBox( "Welfare: $" .. exports.global:formatMoney(unemployedPay), thePlayer, 255, 194, 14 )
	outputChatBox( "Tax: " .. ( exports.global:getTaxAmount(thePlayer) * 100 ) .. "%", thePlayer, 255, 194, 14 )
	outputChatBox( "Income Tax: " .. ( exports.global:getIncomeTaxAmount(thePlayer) * 100 ) .. "%", thePlayer, 255, 194, 14 )
end
addCommandHandler("gettax", getTax, false, false)

function setFactionBudget(thePlayer, commandName, factionID, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Government of Los Santos") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber( amount )
		if not factionID or not amount or amount < 0 then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction ID] [Money]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				amount = tonumber(amount)
				
				if (theTeam) then
					if getElementData(theTeam, "type") >= 2 and getElementData(theTeam, "type") <= 6 then
						if exports.global:takeMoney(getPlayerTeam(thePlayer), amount) then
							exports.global:giveMoney(theTeam, amount)
							outputChatBox("You added $" .. exports.global:formatMoney(amount) .. " to the budget of '" .. getTeamName(theTeam) .. "' (Total: " .. exports.global:getMoney(theTeam) .. ").", thePlayer, 255, 194, 14)
							mysql:query_free( "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. -getElementData(getPlayerTeam(thePlayer), "id") .. ", " .. -getElementData(theTeam, "id") .. ", " .. amount .. ", '', 8)" )
						else
							outputChatBox("You can't afford this.", thePlayer, 255, 194, 14)
						end
					else
						outputChatBox("You can't set a budget for that faction.", thePlayer, 255, 194, 14)
					end
				else
					outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("setbudget", setFactionBudget, false, false)


function setTax(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Government of Los Santos") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber( amount )
		if not amount or amount < 0 or amount > 30 then
			outputChatBox("SYNTAX: /" .. commandName .. " [0-30%]", thePlayer, 255, 194, 14)
		else
			exports.global:setTaxAmount(amount)
			outputChatBox("New Tax is " .. amount .. "%", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("settax", setTax, false, false)

function setIncomeTax(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Government of Los Santos") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber( amount )
		if not amount or amount < 0 or amount > 25 then
			outputChatBox("SYNTAX: /" .. commandName .. " [0-25%]", thePlayer, 255, 194, 14)
		else
			exports.global:setIncomeTaxAmount(amount)
			outputChatBox("New Income Tax is " .. amount .. "%", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("setincometax", setIncomeTax, false, false)

function setWelfare(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Government of Los Santos") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber( amount )
		if not amount or amount <= 0 then
			outputChatBox("SYNTAX: /" .. commandName .. " [Money]", thePlayer, 255, 194, 14)
		elseif mysql:query_free( "UPDATE settings SET value = " .. unemployedPay .. " WHERE name = 'welfare'" ) then
			unemployedPay = amount
			outputChatBox("New Welfare is $" .. exports.global:formatMoney(unemployedPay) .. "/payday", thePlayer, 0, 255, 0)
		else
			outputChatBox("Error 129314 - Report on Mantis.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("setwelfare", setWelfare, false, false)
