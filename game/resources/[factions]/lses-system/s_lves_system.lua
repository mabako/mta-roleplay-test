mysql = exports.mysql

function playerDeath(totalAmmo, killer, killerWeapon)
	if getElementData(source, "dbid") then
		if getElementData(source, "adminjailed") then
			spawnPlayer(source, 263.821807, 77.848365, 1001.0390625, 270, getElementModel(source), 6, getElementData(source, "playerid")+65400, getPlayerTeam(source))
			setCameraInterior(source, 6)
			setCameraTarget(source)
			fadeCamera(source, true)
			
			exports.logs:dbLog(source, 34, source, "died in admin jail")
		elseif getElementData(source, "pd.jailtimer") then
			local x, y, z = getElementPosition(source)
			local int = getElementInterior(source)
			local dim = getElementDimension(source)
			spawnPlayer(source, x, y, z, 270, getElementModel(source), int, dim, getPlayerTeam(source))
			setCameraInterior(source, int)
			setCameraTarget(source)
			
			exports.logs:dbLog(source, 34, source, "died in police jail")
		else
			local affected = { }
			table.insert(affected, source)
			local killstr = ' died'
			if (killer) then
				killstr = ' got killed by '..getPlayerName(killer).. ' ('..getWeaponNameFromID ( killerWeapon )..')'
				table.insert(affected, killer)
			end
			outputChatBox("Respawn in 10 seconds.", source)
			setTimer(respawnPlayer, 10000, 1, source)
			
			exports.logs:dbLog(source, 34, affected, killstr)
			logMe(" [KILL] "..getPlayerName(source) .. killstr)
			
		end
	end
end
addEventHandler("onPlayerWasted", getRootElement(), playerDeath)

function logMe( message )
	local logMeBuffer = getElementData(getRootElement(), "killog") or { }
	local r = getRealTime()
	exports.global:sendMessageToAdmins(message)
	table.insert(logMeBuffer,"["..("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)
	
	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "killog", logMeBuffer)
end

function readLog(thePlayer)
	if exports.global:isPlayerAdmin(thePlayer) then
		local logMeBuffer = getElementData(getRootElement(), "killog") or { }
		outputChatBox("Recent kill list:", thePlayer)
		for a, b in ipairs(logMeBuffer) do
			outputChatBox("- "..b, thePlayer)
		end
		outputChatBox("  END", thePlayer)
	end
end
addCommandHandler("showkills", readLog)
addCommandHandler("showkills2", readLog)

function respawnPlayer(thePlayer)
	if (isElement(thePlayer)) then
		
		if (getElementData(thePlayer, "loggedin") == 0) then
			exports.global:sendMessageToAdmins("AC0x0000004: "..getPlayerName(thePlayer).." died while not in character, triggering blackfade.")
			return
		end
		
		local cost = math.random(175, 500)		
		local tax = exports.global:getTaxAmount()
		
		exports.global:giveMoney( getTeamFromName("Los Santos Emergency Services"), math.ceil((1-tax)*cost) )
		exports.global:takeMoney( getTeamFromName("Government of Los Santos"), math.ceil((1-tax)*cost) )
			
		mysql:query_free("UPDATE characters SET deaths = deaths + 1 WHERE charactername='" .. mysql:escape_string(getPlayerName(thePlayer)) .. "'")

		setCameraInterior(thePlayer, 0)

		outputChatBox("You have recieved treatment from the Los Santos Emergency Services.", thePlayer, 255, 255, 0)
		
		-- take all drugs
		local count = 0
		for i = 30, 43 do
			while exports.global:hasItem(thePlayer, i) do
				local number = exports['item-system']:countItems(thePlayer, i)
				exports.global:takeItem(thePlayer, i)
				exports.logs:logMessage("[LSES Death] " .. getElementData(thePlayer, "account:username") .. "/" .. getPlayerName(thePlayer) .. " lost "..number.."x item "..tostring(i), 28)
				exports.logs:dbLog(thePlayer, 34, thePlayer, "lost "..number.."x item "..tostring(i))
				count = count + 1
			end
		end
		if count > 0 then
			outputChatBox("LSES Employee: We handed your drugs over to the LSPD Investigators.", thePlayer, 255, 194, 14)
		end
		
		-- take guns
		local gunlicense = tonumber(getElementData(thePlayer, "license.gun"))
		local team = getPlayerTeam(thePlayer)
		local factiontype = getElementData(team, "type")
		local items = exports['item-system']:getItems( thePlayer ) -- [] [1] = itemID [2] = itemValue
		local removedWeapons
		local correction = 0
		for itemSlot, itemCheck in ipairs(items) do
			if (itemCheck[1] == 115) or (itemCheck[1] == 116) then -- Weapon
				-- itemCheck[2]: [1] = gta weapon id, [2] = serial number/Amount of bullets, [3] = weapon/ammo name
				local itemCheckExplode = exports.global:explode(":", itemCheck[2])
				local weapon = tonumber(itemCheckExplode[1])
				if (((weapon >= 16 and weapon <= 40 and gunlicense == 0) or weapon == 29 or weapon == 30 or weapon == 32 or weapon ==31 or weapon == 34) and factiontype ~= 2) or (weapon >= 35 and weapon <= 38)  then -- (weapon == 4 or weapon == 8)
					exports['item-system']:takeItemFromSlot(thePlayer, itemSlot - correction)
					correction = correction + 1
					
					if (itemCheck[1] == 115) then
						exports.logs:dbLog(thePlayer, 34, thePlayer, "lost a weapon (" ..  itemCheck[2] .. ")")
					else
						exports.logs:dbLog(thePlayer, 34, thePlayer, "lost a magazine of ammo (" ..  itemCheck[2] .. ")")
					end
					
					if (removedWeapons == nil) then
						removedWeapons = itemCheckExplode[3]
					else
						removedWeapons = removedWeapons .. ", " .. itemCheckExplode[3]
					end
				end
			end
		end
		
		if (removedWeapons~=nil) then
			if gunlicense == 0 and factiontype ~= 2 then
				outputChatBox("LSES Employee: We have taken away weapons which you did not have a license for. (" .. removedWeapons .. ").", thePlayer, 255, 194, 14)
			else
				outputChatBox("LSES Employee: We have taken away weapons which you are not allowed to carry. (" .. removedWeapons .. ").", thePlayer, 255, 194, 14)
			end
		end
		
		
		local theSkin = getPedSkin(thePlayer)
		local theTeam = getPlayerTeam(thePlayer)
		
		local fat = getPedStat(thePlayer, 21)
		local muscle = getPedStat(thePlayer, 23)


		spawnPlayer(thePlayer, 2019.37, -1428.81, 13.53, 134, theSkin, 0, 0, theTeam)
		
				
		setPedStat(thePlayer, 21, fat)
		setPedStat(thePlayer, 23, muscle)

		fadeCamera(thePlayer, true, 6)
		triggerClientEvent(thePlayer, "fadeCameraOnSpawn", thePlayer)
		triggerEvent("updateLocalGuns", thePlayer)
	end
end