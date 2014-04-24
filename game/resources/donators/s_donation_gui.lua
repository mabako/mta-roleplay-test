-- Bind Keys required
function bindKeys()
	local players = exports.pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		setElementData(arrayPlayer, "donation-system:GUI:active", false, false)
		if not(isKeyBound(arrayPlayer, "F7", "down", showDonationGUI)) then
			bindKey(arrayPlayer, "F7", "down", showDonationGUI)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "F7", "down", showDonationGUI)
	setElementData(source, "donation-system:GUI:active", false, false)
end
addEventHandler("onResourceStart", getResourceRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function showDonationGUI(source)
	local logged = getElementData(source, "loggedin")
	if (logged==1) then
		local characterID = getElementData(source, "account:character:id")
		if not (characterID) then
			return false
		end	
		local menuVisible = getElementData(source, "donation-system:GUI:active")
		if (menuVisible == false or menuVisible == nil) then
			setElementData(source, "donation-system:GUI:active", true, false)
			local gameAccountID = getElementData(source, "account:id")
			local obtainedTable = { }
			local availableTable = { }
			local vPoints = 0
			local perkTable = getElementData(source, "donation-system:perks")
			if not (perkTable) then
				perkTable = { }
			end
			for perkID, perkArr in ipairs(donationPerks) do
				if (perkArr[1] ~= nil) then 
					perkArr[4] = perkID
					if (perkTable [ tonumber( perkID) ]) then
						--[[
						local mysqlResult = exports.mysql:query("SELECT `perkID`,`perkValue` FROM `donators` WHERE `accountID`='".. tostring(gameAccountID) .."' AND expirationDate > NOW()")
					local perksTable = { }
					exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "donation-system:perks", perksTable, { }, false)
					if (mysqlResult) then
						while true do
							local mysqlRow = exports.mysql:fetch_assoc(mysqlResult)
							if not mysqlRow then break end
							perksTable[ tonumber(mysqlRow["perkID"]) ] = mysqlRow["perkValue"]
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "donation-system:perks", perksTable, false)
						end
					end
					exports.mysql:free_result(mysqlResult)
						]]
						local expirationDate = "Unknown"
						local mysqlResult = exports.mysql:query_fetch_assoc("SELECT `expirationDate` - INTERVAL 1 hour as 'newtime' FROM `donators` WHERE `accountID`='".. tostring(gameAccountID) .."' AND perkID='"..exports.mysql:escape_string(perkID).."' AND perkValue = '"..exports.mysql:escape_string(perkTable [ tonumber( perkID) ]).."' order by id desc limit 1")
						if (mysqlResult) then
							if mysqlResult["newtime"] ~= mysql_null() then
								expirationDate = tostring(mysqlResult["newtime"])
							end
						end
						-- w.`time` - INTERVAL 1 hour as 'newtime'
						table.insert(obtainedTable, { perkArr, expirationDate } )
					elseif perkArr[3] >= 1 then
						table.insert(availableTable, perkArr)
					end
				end
			end
			
			local gameAccountID = getElementData(source, "account:id")
			if (gameAccountID) then
				if (gameAccountID > 0) then
					local mResult1 = exports.mysql:query_fetch_assoc("SELECT `credits` FROM `accounts` WHERE `id`='".. tostring(gameAccountID) .."'")
					if (mResult1) then
						vPoints = tonumber(mResult1["credits"]) or 0
					end
				end
			end
			
			triggerClientEvent(source, "donation-system:GUI:open", source, obtainedTable, availableTable, vPoints)			
		end
	end
end

function closeDonationGUI(thePlayer)
	if not thePlayer then
		thePlayer = client
	end
	setElementData(thePlayer, "donation-system:GUI:active", false, false)
end
addEvent("donation-system:GUI:close", true)
addEventHandler("donation-system:GUI:close", getRootElement(), closeDonationGUI)

function activateDonationPerk(thePerk, ...)
	closeDonationGUI(client)
	
	local logged = getElementData(client, "loggedin")
	local vPoints = 0
	local gameAccountID = 0
	if (logged==1) then
		gameAccountID = getElementData(source, "account:id")
		if (gameAccountID) then
			if (gameAccountID > 0) then
				local mResult1 = exports.mysql:query_fetch_assoc("SELECT `credits` FROM `accounts` WHERE `id`='".. tostring(gameAccountID) .."'")
				if (mResult1) then
					vPoints = tonumber(mResult1["credits"]) or 0
				end
			end
		end
	end
	
	if not (donationPerks[ thePerk ]) then
		return false
	end
	
	local perkDetails = donationPerks[ thePerk ]
	if (perkDetails[2] <= vPoints) then
		local result, message = givePlayerPerk(client, thePerk, nil, perkDetails[3], perkDetails[2], ... )
		if not result then
			outputChatBox(" Error while activating donation perk: "..message, client, 255, 0, 0)
		end
		showDonationGUI(client)
	else
		outputChatBox(" You don't have enough points to activate '"..perkDetails[1] .."'", client, 255,0,0)
		showDonationGUI(client)
	end
end
addEvent("donation-system:GUI:activate", true)
addEventHandler("donation-system:GUI:activate", getRootElement(), activateDonationPerk)