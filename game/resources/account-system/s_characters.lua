local mysql = exports.mysql

function characterList( theClient )
	
	local characters = { }
	local clientAccountID = getElementDataEx(theClient, "account:id") or -1

	local result = mysql:query("SELECT id, charactername, cked, lastarea, age, weight, height, `description`, gender, faction_id, faction_rank, skin, DATEDIFF(NOW(), lastlogin) as llastlogin FROM characters WHERE account='" .. mysql:escape_string(clientAccountID) .. "' AND `active` = 1 ORDER BY cked ASC, lastlogin DESC")
	
	if (mysql:num_rows(result) > 0) then
		local i = 1
		while true do
			local row = mysql:fetch_assoc(result)
			if not row then break end
		
			characters[i] = { }
			characters[i][1] = tonumber(row["id"])
			characters[i][2] = row["charactername"]
			
			if (tonumber(row["cked"]) or 0) > 0 then
				characters[i][3] = 1
			end
			
			characters[i][4] = row["lastarea"]
			characters[i][5] = tonumber(row["age"])
			characters[i][6] = tonumber(row["gender"])
			
			local factionID = tonumber(row["faction_id"])
			local factionRank = tonumber(row["faction_rank"])
			
			if (factionID<1) or not (factionID) then
				characters[i][7] = nil
				characters[i][8] = nil
			else
				factionResult = mysql:query_fetch_assoc("SELECT name, rank_" .. mysql:escape_string(factionRank) .. " as rankname FROM factions WHERE id='" .. mysql:escape_string(tonumber(factionID)) .. "'")
				if (factionResult) then
					characters[i][7] = factionResult["name"]
					characters[i][8] = factionResult["rankname"]
						
					if (string.len(characters[i][7])>53) then
						characters[i][7] = string.sub(characters[i][7], 1, 32) .. "..."
					end
				else
					characters[i][7] = nil
					characters[i][8] = nil
				end
			end
			characters[i][9] = tonumber(row["skin"])
			characters[i][10] = tonumber(row["llastlogin"])
			characters[i][11] = tonumber(row["weight"])
			characters[i][12] = tonumber(row["height"])
			i = i + 1
		end
	end
	mysql:free_result(result)
	return characters
end

function spawnCharacter(characterID)
	if not client then
		return
	end
	
	if not characterID then
		return
	end
	
	if not tonumber(characterID) then
		return
	end
	characterID = tonumber(characterID)
	
	triggerEvent('setDrunkness', client, 0)
	setElementDataEx(client, "alcohollevel", 0, true)

	removeMasksAndBadges(client)
	
	setElementDataEx(client, "pd.jailserved")
	setElementDataEx(client, "pd.jailtime")
	setElementDataEx(client, "pd.jailtimer")
	setElementDataEx(client, "pd.jailstation")
	setElementDataEx(client, "loggedin", 0)
	
	local timer = getElementData(client, "pd.jailtimer")
	if isTimer(timer) then
		killTimer(timer)
	end
	
	if (getPedOccupiedVehicle(client)) then
		removePedFromVehicle(client)
	end
	-- End cleaning up
	
	local accountID = tonumber(getElementDataEx(client, "account:id"))
	local characterData = mysql:query_fetch_assoc("SELECT * FROM `characters` WHERE `id`='" .. tostring(characterID) .. "' AND `account`='" .. tostring(accountID) .. "' AND `cked`=0")
	if characterData then
		setElementDataEx(client, "look", fromJSON(characterData["description"]) or {"", "", "", "", characterData["description"], ""})
		
		setElementDataEx(client, "age", characterData["age"])
		setElementDataEx(client, "weight", characterData["weight"])
		setElementDataEx(client, "height", characterData["height"])
		setElementDataEx(client, "race", tonumber(characterData["skincolor"]))
		setElementDataEx(client, "maxvehicles", tonumber(characterData["maxvehicles"]))
		
		-- LANGUAGES
		local lang1 = tonumber(characterData["lang1"])
		local lang1skill = tonumber(characterData["lang1skill"])
		local lang2 = tonumber(characterData["lang2"])
		local lang2skill = tonumber(characterData["lang2skill"])
		local lang3 = tonumber(characterData["lang3"])
		local lang3skill = tonumber(characterData["lang3skill"])
		local currentLanguage = tonumber(characterData["currlang"])
		setElementDataEx(client, "languages.current", currentLanguage, false)
				
		if lang1 == 0 then
			lang1skill = 0
		end
		
		if lang2 == 0 then
			lang2skill = 0
		end
		
		if lang3 == 0 then
			lang3skill = 0
		end
		
		setElementDataEx(client, "languages.lang1", lang1, false)
		setElementDataEx(client, "languages.lang1skill", lang1skill, false)
		
		setElementDataEx(client, "languages.lang2", lang2, false)
		setElementDataEx(client, "languages.lang2skill", lang2skill, false)
		
		setElementDataEx(client, "languages.lang3", lang3, false)
		setElementDataEx(client, "languages.lang3skill", lang3skill, false)
		-- END OF LANGUAGES
		
		setElementDataEx(client, "timeinserver", tonumber(characterData["timeinserver"]), false)
		setElementDataEx(client, "account:character:id", characterID, false)
		setElementDataEx(client, "dbid", characterID, false) -- workaround
		exports['item-system']:loadItems( client, true )
		
		setElementDataEx(client, "loggedin", 1)
		
		-- Check his name isn't in use by a squatter
		local playerWithNick = getPlayerFromName(tostring(characterData["charactername"]))
		if isElement(playerWithNick) and (playerWithNick~=client) then
			kickPlayer(playerWithNick, getRootElement(), "Duplicate Session.")
		end
		
		-- casual skin
		setElementDataEx(client, "casualskin", tonumber(characterData["casualskin"]), false)
		setElementDataEx(client, "bleeding", 0, false)
		
		-- Set their name to the characters
		setElementDataEx(client, "legitnamechange", 1)
		setPlayerName(client, tostring(characterData["charactername"]))
		local pid = getElementData(client, "playerid")
		local fixedName = string.gsub(tostring(characterData["charactername"]), "_", " ")

		setElementDataEx(client, "legitnamechange", 0)
	
		
		setPlayerNametagShowing(client, false)
		setElementFrozen(client, true)
		setPedGravity(client, 0)
		spawnPlayer(client, tonumber(characterData["x"]), tonumber(characterData["y"]), tonumber(characterData["z"]), tonumber(characterData["rotation"]), tonumber(characterData["skin"]))
		setElementDimension(client, tonumber(characterData["dimension_id"]))
		setElementInterior(client, tonumber(characterData["interior_id"]), tonumber(characterData["x"]), tonumber(characterData["y"]), tonumber(characterData["z"]))
		setCameraInterior(client, tonumber(characterData["interior_id"]))
		setCameraTarget(client, client)
		setElementHealth(client, tonumber(characterData["health"]))
		setPedArmor(client, tonumber(characterData["armor"]))
		
		local teamElement = nil
		if (tonumber(characterData["faction_id"])~=-1) then
			teamElement = exports.pool:getElement('team', tonumber(characterData["faction_id"]))
			if not (teamElement) then	-- Facshun does not exist?
				characterData["faction_id"] = -1
				mysql:query_free("UPDATE characters SET faction_id='-1', faction_rank='1' WHERE id='" .. mysql:escape_string(tostring(characterID)) .. "' LIMIT 1")
			end
		end
		
		if teamElement then
			setPlayerTeam(client, teamElement)	
		else
			setPlayerTeam(client, getTeamFromName("Citizen"))
		end

		
		local adminLevel = getElementDataEx(client, "adminlevel")
		local gmLevel = getElementDataEx(client, "account:gmlevel")
		exports.global:updateNametagColor(client)
		-- ADMIN JAIL
		local jailed = getElementData(client, "adminjailed")
		local jailed_time = getElementData(client, "jailtime")
		local jailed_by = getElementData(client, "jailadmin")
		local jailed_reason = getElementData(client, "jailreason")
		
		if jailed then
			outputChatBox("You still have " .. jailed_time .. " minute(s) to serve of your admin jail sentence.", client, 255, 0, 0)
			outputChatBox(" ", client)
			outputChatBox("You were jailed by: " .. jailed_by .. ".", client, 255, 0, 0)
			outputChatBox("Reason: " .. jailed_reason, client, 255, 0, 0)
				
			local incVal = getElementData(client, "playerid")
				
			setElementDimension(client, 55000+incVal)
			setElementInterior(client, 6)
			setCameraInterior(client, 6)
			setElementPosition(client, 263.821807, 77.848365, 1001.0390625)
			setPedRotation(client, 267.438446)
						
			setElementDataEx(client, "jailserved", 0, false)
			setElementDataEx(client, "adminjailed", true)
			setElementDataEx(client, "jailreason", jailed_reason, false)
			setElementDataEx(client, "jailadmin", jailed_by, false)
			
			if jailed_time ~= 999 then
				if not getElementData(client, "jailtimer") then
					setElementDataEx(client, "jailtime", jailed_time+1, false)
					--exports['admin-system']:timerUnjailPlayer(client)
					triggerEvent("admin:timerUnjailPlayer", client, client)
				end
			else
				setElementDataEx(client, "jailtime", "Unlimited", false)
				setElementDataEx(client, "jailtimer", true, false)
			end

			
			setElementInterior(client, 6)
			setCameraInterior(client, 6)
		elseif tonumber(characterData["pdjail"]) == 1 then -- PD JAIL
			outputChatBox("You still have " .. tonumber(characterData["pdjail_time"]) .. " minute(s) to serve of your state jail sentence.", client, 255, 0, 0)
			setElementDataEx(client, "pd.jailserved", 0, false)
			setElementDataEx(client, "pd.jailtime", tonumber(characterData["pdjail_time"])+1, false)
			setElementDataEx(client, "pd.jailstation", tonumber(characterData["pdjail_station"]), false)
			exports['lspd-system']:timerPDUnjailPlayer(client)
		end
		
		setElementDataEx(client, "faction", tonumber(characterData["faction_id"]), false)
		setElementDataEx(client, "factionMenu", 0)
		local factionPerks = fromJSON(characterData["faction_perks"]) or { }
		setElementDataEx(client, "factionPackages", factionPerks, false)
		setElementDataEx(client, "factionrank", tonumber(characterData["faction_rank"]), false)
		setElementDataEx(client, "factionleader", tonumber(characterData["faction_leader"]), false)
		
		-- Player is cuffed
		if (tonumber(characterData["cuffed"])==1) then
			toggleControl(client, "sprint", false)
			toggleControl(client, "fire", false)
			toggleControl(client, "jump", false)
			toggleControl(client, "next_weapon", false)
			toggleControl(client, "previous_weapon", false)
			toggleControl(client, "accelerate", false)
			toggleControl(client, "brake_reverse", false)
		end
			
		
		setElementDataEx(client, "businessprofit", 0, false)
		setElementDataEx(client, "legitnamechange", 0)
		setElementDataEx(client, "muted", tonumber(muted))
		setElementDataEx(client, "hoursplayed",  tonumber(characterData["hoursplayed"]))
		setElementDataEx(client, "alcohollevel", tonumber(characterData["alcohollevel"]) or 0, true)
		exports.global:setMoney(client, tonumber(characterData["money"]), true)
		exports.global:checkMoneyHacks(client)
		
		setElementDataEx(client, "restrain", tonumber(characterData["cuffed"]), true)
		setElementDataEx(client, "tazed", 0, false)
		setElementDataEx(client, "cellnumber", tonumber(characterData["cellnumber"]), false)
		setElementDataEx(client, "calling", nil, false)
		setElementDataEx(client, "calltimer", nil, false)
		setElementDataEx(client, "phonestate", 0, false)
		setElementDataEx(client, "realinvehicle", 0, false)
		
		local duty = tonumber(characterData["duty"]) or 0
		setElementDataEx(client, "duty", duty)
		
		setElementDataEx(client, "job", tonumber(characterData["job"]))
		setElementDataEx(client, "license.car", tonumber(characterData["car_license"]))
		setElementDataEx(client, "license.gun", tonumber(characterData["gun_license"]))
		setElementDataEx(client, "bankmoney", tonumber(characterData["bankmoney"]), false)
		setElementDataEx(client, "fingerprint", tostring(characterData["fingerprint"]), false)
		setElementDataEx(client, "tag", tonumber(characterData["tag"]))
		setElementDataEx(client, "dutyskin", tonumber(characterData["dutyskin"]), false)
		setElementDataEx(client, "blindfold", tonumber(characterData["blindfold"]), false)
		setElementDataEx(client, "gender", tonumber(characterData["gender"]))
		setElementDataEx(client, "deaglemode", 0, true)
		setElementDataEx(client, "shotgunmode", 0, true)
		
		if (tonumber(characterData["restrainedobj"])>0) then
			setElementDataEx(client, "restrainedObj", tonumber(characterData["restrainedobj"]), false)
		end
		
		if ( tonumber(characterData["restrainedby"])>0) then
			setElementDataEx(client, "restrainedBy",  tonumber(characterData["restrainedby"]), false)
		end
		
		if tonumber(characterData["job"]) == 1 then
			triggerClientEvent(client,"restoreTruckerJob",client)
		end
		triggerEvent("restoreJob", client)
		triggerClientEvent(client, "updateCollectionValue", client, tonumber(characterData["photos"]))
		
		-- Cleaning their old weapons
		takeAllWeapons(client)
		
		if (getElementType(client) == 'player') then
			triggerEvent("updateLocalGuns", client)
		end
 		
		-- Let's stick some blips on the properties they own
		--[[local interiors = { }
		for _, interior in ipairs(getElementsByType("interior")) do
			if isElement(interior) then
				local interiorEntrance = getElementData(interior, "entrance")
				if interiorEntrance[5] == 0 then -- If its in the real world (dim 0)
					local interiorStatus = getElementData(interior, "status")
					if interiorStatus[4] == tonumber(characterID) then -- If the guy is owning the property
						if (interiorStatus[1] ~= 2) then -- Check interior types
							if interiorStatus[1] == 3 then 
								interiorStatus[1] = 0 
							end
							interiors[#interiors+1] = { interiorStatus[1], interiorEntrance[1], interiorEntrance[2] }
						end
					end
				end
			end
		end
		
		triggerClientEvent(client, "createBlipsFromTable", client, interiors)]]
		
		
		-- Weapon stats
		setPedStat(client, 70, 500)
		setPedStat(client, 71, 500)
		setPedStat(client, 72, 500)
		setPedStat(client, 74, 500)
		setPedStat(client, 76, 500)
		setPedStat(client, 77, 500)
		setPedStat(client, 78, 500)
		setPedStat(client, 79, 500)
		
		toggleAllControls(client, true, true, true)
		triggerClientEvent(client, "onClientPlayerWeaponCheck", client)
		setElementFrozen(client, false)
		
		-- blindfolds
		if (tonumber(characterData["blindfold"])==1) then
			setElementDataEx(client, "blindfold", 1)
			outputChatBox("Your character is blindfolded. If this was an OOC action, please contact an administrator via F2.", client, 255, 194, 15)
			fadeCamera(client, false)
		else
			fadeCamera(client, true, 2)
		end
		
		-- impounded cars
		--[[if exports.global:hasItem(client, 2) then -- phone
			local impounded = mysql:query_fetch_assoc("SELECT COUNT(*) as 'numbr'  FROM `vehicles` WHERE `owner` = " .. mysql:escape_string(characterID) .. " and `Impounded` > 0")
			if impounded then
				local amount = tonumber(impounded["numbr"]) or 0
				if amount > 0 then
					outputChatBox("((Hex Tow 'n Go)) #921 [SMS]: " .. amount .. " of your vehicles are impounded. Head over to the Impound to release them.", client, 120, 255, 80)
				end
			end
		end]]
		setPedFightingStyle(client, tonumber(characterData["fightstyle"]))	
		triggerEvent("onCharacterLogin", client, charname, tonumber(characterData["faction_id"]))
		triggerClientEvent(client, "accounts:characters:spawn", client, fixedName, adminLevel, gmLevel, tonumber(characterData["faction_id"]), tonumber(characterData["faction_rank"]))
		triggerClientEvent(client, "item:updateclient", client)
		
		local motd = getElementData(getRootElement(), "account:motd") or ""
		outputChatBox("MOTD: " .. motd, source, 255, 255, 0)
		
		if ((getElementData(source, "adminlevel") or 0) > 0) then
			local amotd = getElementData(getRootElement(), "account:amotd") or ""
			outputChatBox("Admin MOTD: " .. amotd, source, 135, 206, 250)
			
			local ticketCenterQuery = mysql:query_fetch_assoc("SELECT count(*) as 'noreports' FROM `tc_tickets` WHERE `status` < 3 and `assigned`='".. mysql:escape_string(tostring(accountID)).."'")
			if (tonumber(ticketCenterQuery["noreports"]) > 0) then
				outputChatBox("You have "..tostring(ticketCenterQuery["noreports"]).." reports assigned to you on the ticket center.", source, 135, 206, 250)
			end
		end
		mysql:query_free("UPDATE characters SET lastlogin=NOW() WHERE id='" .. mysql:escape_string(characterID) .. "'")
		exports.logs:dbLog("ac"..tostring(accountID), 27, { "ac"..tostring(accountID), source } , "Spawned" )
		setTimer(setPedGravity, 2000, 1, client, 0.008)
		setElementAlpha(client, 255)
		
		local monitored = getElementData(client, "admin:monitor")
		if monitored then
			exports.global:sendMessageToAdmins("[MONITOR] "..getPlayerName(client) .." ("..pid.."): "..monitored)
		end
		
		-- check if the player has the duty package
		if duty > 0 then
			local foundPackage = false
			for key, value in ipairs(factionPerks) do
				if value == duty then
					foundPackage = true
					break
				end
			end
			
			if not foundPackage then
				triggerEvent("duty:offduty", client)
				outputChatBox("You don't have access to the duty you are using anymore - thus, removed.", client, 255, 0, 0)
			end
		end
		triggerEvent("social:character", client)
	end
end
addEventHandler("accounts:characters:spawn", getRootElement(), spawnCharacter)

function Characters_onCharacterChange()
	triggerEvent("savePlayer", client, "Change Character")
	triggerEvent('setDrunkness', client, 0)
	setElementDataEx(client, "alcohollevel", 0, true)
	
	removeMasksAndBadges(client)
	
	setElementDataEx(client, "pd.jailserved")
	setElementDataEx(client, "pd.jailtime")
	setElementDataEx(client, "pd.jailtimer")
	setElementDataEx(client, "pd.jailstation")
	setElementDataEx(client, "loggedin", 0)
	setElementDataEx(client, "bankmoney", 0)
	setElementDataEx(client, "account:character:id", false)
	setElementAlpha(client, 0)
	if (getPedOccupiedVehicle(client)) then
		removePedFromVehicle(client)
	end
	exports.global:updateNametagColor(client)
	local clientAccountID = getElementDataEx(client, "account:id") or -1
	
	setElementInterior(client, 0)
	setElementDimension(client, 1)
	setElementPosition(client, -26.8828125, 2320.951171875, 24.303373336792)
	exports.logs:dbLog("ac"..tostring(clientAccountID), 27, { "ac"..tostring(clientAccountID), client } , "Went to character selection" )
end
addEventHandler("accounts:characters:change", getRootElement(), Characters_onCharacterChange)

function removeMasksAndBadges(client)
	for k, v in ipairs({exports['item-system']:getMasks(), exports['item-system']:getBadges()}) do
		for kx, vx in pairs(v) do
			if getElementData(client, vx[1]) then
				setElementDataEx(client, vx[1], false, true)
			end
		end
	end
end