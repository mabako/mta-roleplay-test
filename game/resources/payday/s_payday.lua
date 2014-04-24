local mysql = exports.mysql

local incomeTax = 0
local taxVehicles = {}
local vehicleCount = {}
local taxHouses = {}
local threads = { }
local threadTimer = nil
local govAmount = 0
local unemployedPay = 150

function payWage(player, pay, faction, tax)
	local governmentIncome = 0
	local bankmoney = getElementData(player, "bankmoney")
	local noWage = pay == 0
	local donatormoney = 0 
	local startmoney = bankmoney
	
	if (exports.donators:hasPlayerPerk(player, 4)) then
		donatormoney = donatormoney + 25
	end
	
	if (exports.donators:hasPlayerPerk(player, 5)) then
		donatormoney = donatormoney + 75
	end
	
	local interest = math.ceil(0.003 * bankmoney)
	if (interest >  74999) then
		interest = 75000
	end
	
	if interest ~= 0 then
		mysql:query_free( "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (-57, " .. getElementData(player, "dbid") .. ", " .. interest .. ", 'BANKINTEREST', 6)" )
	end
	
	-- business money
	local profit = getElementData(player, "businessprofit")
	exports['anticheat-system']:changeProtectedElementDataEx(player, "businessprofit", 0, false)
	bankmoney = bankmoney + math.max( 0, pay ) + interest + profit + donatormoney
	
	-- rentable houses
	local rent = 0
	local rented = nil -- store id in here
	local dbid = tonumber(getElementData(player, "dbid"))
	for key, value in ipairs(getElementsByType("interior")) do
		local interiorStatus = getElementData(value, "status")
		local owner = tonumber( interiorStatus[4] )
		
		if (owner) and (owner == dbid) and (getElementData(value, "status")) and (tonumber(interiorStatus[1]) == 3) and (tonumber(interiorStatus[5]) > 0) then
			rent = rent + tonumber(interiorStatus[5])
			rented = tonumber(getElementData(value, "dbid"))
		end
	end
	
	if not faction then
		if bankmoney > 25000 then
			noWage = true
			pay = 0
		elseif pay > 0 then
			governmentIncome = governmentIncome - pay
			mysql:query_free( "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (-3, " .. getElementData(player, "dbid") .. ", " .. pay .. ", 'STATEBENEFITS', 6)" )
		else
			pay = 0
		end
	else
		if pay > 0 then
			local teamid = getElementData(player, "faction")
			if teamid <= 0 then
				teamid = 0
			else
				teamid = -teamid
			end
			mysql:query_free( "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. teamid .. ", " .. getElementData(player, "dbid") .. ", " .. pay .. ", 'WAGE', 6)" )
		else
			pay = 0
		end
	end
	
	if tax > 0 then
		pay = pay - tax
		bankmoney = bankmoney - tax
		governmentIncome = governmentIncome + tax
		mysql:query_free( "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. getElementData(player, "dbid") .. ", -3, " .. tax .. ", 'INCOMETAX', 6)" )
	end
	
	local vtax = taxVehicles[ getElementData(player, "dbid") ] or 0
	if vtax > 0 then
		vtax = math.min( vtax, bankmoney )
		bankmoney = bankmoney - vtax
		governmentIncome = governmentIncome + vtax
		mysql:query_free( "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. getElementData(player, "dbid") .. ", -3, " .. vtax .. ", 'VEHICLETAX', 6)" )
	end
	
	local ptax = taxHouses[ getElementData(player, "dbid") ] or 0
	if ptax > 0 then
		ptax = math.floor( ptax * 0.5 )
		ptax = math.min( ptax, bankmoney )
		bankmoney = bankmoney - ptax
		governmentIncome = governmentIncome + ptax
		mysql:query_free( "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. getElementData(player, "dbid") .. ", -3, " .. ptax .. ", 'PROPERTYTAX', 6)" )
	end
	
	if (rent > 0) then
		if (rent > bankmoney)   then
			rent = -1
			call( getResourceFromName( "interior-system" ), "publicSellProperty", player, rented, false, true )
		else
			bankmoney = bankmoney - rent
			mysql:query_free( "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. getElementData(player, "dbid") .. ", 0, " .. rent .. ", 'HOUSERENT', 6)" )
		end
	end

	-- save the bankmoney
	exports['anticheat-system']:changeProtectedElementDataEx(player, "bankmoney", bankmoney, true)

	-- let the client tell them the (bad) news
	local grossincome = pay+profit+interest+donatormoney-rent-vtax-ptax
	triggerClientEvent(player, "cPayDay", player, faction, noWage and -1 or pay, profit, interest, donatormoney, tax, incomeTax, vtax, ptax, rent, grossincome)
	return governmentIncome
end

function payAllWages(timer)
	if timer then
		local mins = getRealTime().minute
		local minutes = 60 - mins
		if (minutes < 15) then
			minutes = minutes + 60
		end
		setTimer(payAllWages, 60000*minutes, 1, true)
	end
	loadWelfare( )
	threads = { }
	taxVehicles = {}
	vehicleCount = {}
	for _, veh in pairs(getElementsByType("vehicle")) do
		if isElement(veh) then
			local owner, faction = tonumber(getElementData(veh, "owner")) or 0, tonumber(getElementData(veh, "faction")) or 0
			if faction < 0 and owner > 0 then -- non-faction vehicles
				local tax = vehicleTaxes[getElementModel(veh)-399] or 25
				if tax > 0 then
					taxVehicles[owner] = ( taxVehicles[owner] or 0 ) + ( tax * 2 )
					vehicleCount[owner] = ( vehicleCount[owner] or 0 ) + 1
					--if vehicleCount[owner] > 3 then -- $75 for having too much vehicles, per vehicle more than 3
					--	taxVehicles[owner] = taxVehicles[owner] + 75
					--end
				end
			end
		end
	end
	
	-- count all player props
	taxHouses = { }
	for _, property in pairs( getElementsByType( "interior" ) ) do
		local interiorStatus = getElementData(property, "status")
		if interiorStatus[5] and interiorStatus[4] > 0 and interiorStatus[1] < 2 then
			-- businesses pay more
			local factor = 0.015
			if interiorStatus[1] == 1 then
				factor = 0.03
			end
			taxHouses[ interiorStatus[4] ] = ( taxHouses[ interiorStatus[4] ] or 0 ) + factor * interiorStatus[5]
		end
	end
	
	-- Get some data
	local players = exports.pool:getPoolElementsByType("player")
	govAmount = exports.global:getMoney(getTeamFromName("Government of Los Santos"))
	incomeTax = exports.global:getIncomeTaxAmount()
	
	-- Pay Check tooltip
	if(getResourceFromName("tooltips-system"))then
		triggerClientEvent("tooltips:showHelp", getRootElement(),12)
	end

	for _, value in ipairs(players) do
		local co = coroutine.create(doPayDayPlayer)
		coroutine.resume(co, value, true)
		table.insert(threads, co)
	end

	threadTimer = setTimer(resumeThreads, 100, 0)
end

function resumeThreads()
	local inFor = false
	--outputDebugString("resumeThreadsCalled")
	for threadRow, threadValue in ipairs(threads) do
		inFor = true
		coroutine.resume(threadValue)
		table.remove(threads,threadRow)
		break
	end
	
	if not inFor then	
		-- Store the government money
		exports.global:setMoney(getTeamFromName("Government of Los Santos"), govAmount)
		
		killTimer(threadTimer)
	end
end

function doPayDayPlayer(value, hourly)
	if hourly then
	coroutine.yield()
	end
	--exports.global:sendMessageToAdmins("Payday: Processing thread for " .. getPlayerName(value))
	local sqlupdate = ""
	local logged = getElementData(value, "loggedin")
	local timeinserver = getElementData(value, "timeinserver")
	local dbid = getElementData( value, "dbid" )
	if (logged==1) and (timeinserver>=58) and (getPlayerIdleTime(value) < 600000) then
		mysql:query_free( "UPDATE characters SET jobcontract = jobcontract - 1 WHERE id = " .. dbid .. " AND jobcontract > 0" )
		local carLicense = getElementData(value, "license.car")			
		if carLicense and carLicense < 0 then
			exports['anticheat-system']:changeProtectedElementDataEx(value, "license.car", carLicense + 1, false)
			sqlupdate = sqlupdate .. ", car_license = car_license + 1"
		end
		
		local gunLicense = getElementData(value, "license.gun")
		if gunLicense and gunLicense < 0 then
			exports['anticheat-system']:changeProtectedElementDataEx(value, "license.gun", gunLicense + 1, false)
			sqlupdate = sqlupdate .. ", gun_license = gun_license + 1"
		end
		
		local playerFaction = getElementData(value, "faction")
		if (playerFaction~=-1) then
			local theTeam = getPlayerTeam(value)
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) then -- Factions with wages
				local wages = getElementData(theTeam,"wages")
				
				local factionRank = getElementData(value, "factionrank")
				local rankWage = tonumber( wages[factionRank] )
				
				local taxes = 0
				if not exports.global:takeMoney(theTeam, rankWage) then
					rankWage = -1
				else
					taxes = math.ceil( incomeTax * rankWage )
				end
				
				govAmount = govAmount + payWage( value, rankWage, true, taxes )
			else
				if unemployedPay >= govAmount then
					unemployedPay = -1
				end
				govAmount = govAmount + payWage( value, unemployedPay, false, 0 )
			end
		else
			if unemployedPay >= govAmount then
				unemployedPay = -1
			end
			govAmount = govAmount + payWage( value, unemployedPay, false, 0 )
		end
		exports['anticheat-system']:changeProtectedElementDataEx(value, "timeinserver", math.max(0, timeinserver-60), false, true)
		local hoursplayed = getElementData(value, "hoursplayed") or 0
		exports['anticheat-system']:changeProtectedElementDataEx(value, "hoursplayed", hoursplayed+1, false, true)
		mysql:query_free( "UPDATE characters SET hoursplayed = hoursplayed + 1, bankmoney = " .. getElementData( value, "bankmoney" ) .. sqlupdate .. " WHERE id = " .. dbid )
	elseif (getPlayerIdleTime(value) > 600000) then
		exports.global:sendMessageToAdmins("[Payday] No payday for '"..getPlayerName(value):gsub("_", " ").."' due more as 10 minutes no movement.")
	elseif (logged==1) and (timeinserver) and (timeinserver<60) then
		outputChatBox("You have not played long enough to recieve a payday. (You require another " .. 60-timeinserver .. " Minutes of play.)", value, 255, 0, 0)
	end
end

function adminDoPayday(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:isPlayerLeadAdmin(thePlayer)) then
			payAllWages(false)
		end
	end
end
addCommandHandler("dopayday", adminDoPayday)

function adminDoPaydayOne(thePlayer, commandName, targetPlayerName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:isPlayerHeadAdmin(thePlayer)) then
			targetPlayer = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
			if targetPlayer then
				if getElementData(targetPlayer, "loggedin") == 1 then
					doPayDayPlayer(targetPlayer)
				else
					outputChatBox("Player is not logged in.", showPlayer, 255, 0, 0)
					return
				end
			else
				outputChatBox("Fail.", showPlayer, 255, 0, 0)
				return
			end
		end
	end
end
addCommandHandler("dopaydayone", adminDoPaydayOne)

function timeSaved(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local timeinserver = getElementData(thePlayer, "timeinserver")
		
		if (timeinserver>60) then
			timeinserver = 60
		end
		
		outputChatBox("You currently have " .. timeinserver .. " Minutes played.", thePlayer, 255, 195, 14)
		outputChatBox("You require another " .. 60-timeinserver .. " Minutes to obtain a payday.", thePlayer, 255, 195, 14)
	end
end
addCommandHandler("timesaved", timeSaved)

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

function startResource()
	local mins = getRealTime().minute
	local minutes = 60 - mins
	setTimer(payAllWages, 60000*minutes, 1, true)
	
	loadWelfare( )
end
addEventHandler("onResourceStart", getResourceRootElement(), startResource)
