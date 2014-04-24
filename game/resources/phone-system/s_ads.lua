local ads = { }
local AD_MESSAGE = 1
local AD_SENDERNAME = 2
local AD_SENDERELEMENT = 3
local AD_COST = 4
local AD_PHONENUMER = 5
local AD_CREATIONTIME = 6
local AD_EDITTIME = 7
local AD_FROZEN = 8
local AD_AIRED = 9

local adTimer = nil

function SAN_newAdvert(message, sourceName, sourceElement, theCost, outboundPhoneNumber)
	table.insert(ads, { message, sourceName, sourceElement, theCost, outboundPhoneNumber or 0, getRealTime().timestamp, getRealTime().timestamp, false, false } )
	
	local advertID = -1
	for adIndex, adTable in ipairs (ads) do
		advertID = adIndex
	end
	exports.global:sendMessageToAdmins("[AD] ADVERT "..advertID .. " created by `"..sourceName.."`.")
	
	if not adTimer then
		adTimer = setTimer(SAN_runAdverts, math.random(40000, 120000), 1)
	end
end

function SAN_runAdverts()
	local didAirSomething = false
	local removeIDs = { }
	for adIndex, adTable in ipairs (ads) do
		if adTable[ AD_AIRED ] then -- remove from list
			table.insert(removeIDs, adIndex)
		elseif adTable[ AD_FROZEN ] then
			local currentTime = getRealTime().timestamp
			if (currentTime - adTable [ AD_EDITTIME ]) > 600 then
				table.insert(removeIDs, adIndex)
				exports.global:sendMessageToAdmins("[ADS] Removing ad "..adIndex.." due being 10 minutes frozen. (`"..adTable[AD_MESSAGE].."`, `"..adTable[AD_SENDERNAME].."`)")
			end
		elseif ( not didAirSomething ) and not (adTable[AD_EDITTIME] == adTable[AD_CREATIONTIME] ) then
			
		
			didAirSomething = true
			
			exports.logs:logMessage("ADVERT: " .. adTable[AD_MESSAGE] .. " ((".. adTable[AD_SENDERNAME].." ))", 2)
			for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
				if (getElementData(value, "loggedin")==1 and not getElementData(value, "disableAds")) then
					if exports.global:isPlayerAdmin(value) then
						outputChatBox("   ADVERT: " .. adTable[AD_MESSAGE] .. " (( ".. adTable[AD_SENDERNAME].." ))", value, 0, 255, 64)
					else
						outputChatBox("   ADVERT: " .. adTable[AD_MESSAGE], value, 0, 255, 64)
					end
				end
			end
			--table.insert(removeIDs, adIndex)
			ads[adIndex][AD_AIRED] = true
		end
		
		if adTable[AD_EDITTIME] == adTable[AD_CREATIONTIME] then
			ads[adIndex][AD_EDITTIME] = getRealTime().timestamp
		end
	end
	
	local offset = 0
	for _, removeID in ipairs (removeIDs) do
		table.remove(ads, removeID - offset)
		offset = offset + 1
	end
	
	
	if #ads > 0 then
		local timer = (120 / (#ads + 1)) * 1000
		adTimer = setTimer(SAN_runAdverts, timer, 1)
	else
		adTimer = nil
	end
end

function SAN_listAdverts(thePlayer)
	if exports.global:isPlayerAdmin(thePlayer) then
		outputChatBox("Current adverts list", thePlayer)
		for adIndex, adTable in ipairs (ads) do
			local msg = " "..adIndex..". "..adTable[AD_MESSAGE].." /-/ "..adTable[AD_SENDERNAME].." /-/ "
			
			if (adTable[AD_AIRED]) then
				msg = msg.."Already aired"
			elseif (adTable[AD_FROZEN]) then
				msg = msg.."Frozen by "..adTable[AD_FROZEN]
			else
				msg = msg.."In queue"
			end
			
			outputChatBox(msg, thePlayer)
		end
		outputChatBox("--- Commands: /freezead /unfreezead /deletead", thePlayer)
	end
end
addCommandHandler("listadverts", SAN_listAdverts)
addCommandHandler("listads", SAN_listAdverts)
addCommandHandler("adverts", SAN_listAdverts)
addCommandHandler("ads", SAN_listAdverts)

function SAN_freezeAdvert(thePlayer, commandHandler, advertID)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not advertID or not tonumber(advertID) then
			outputChatBox("Syntax: /"..commandHandler.." <advertID>", thePlayer)
			return
		end
		
		advertID = tonumber(advertID)
		
		if not ads[advertID] then
			outputChatBox("Invalid ad", thePlayer, 255, 0 ,0)
			return
		end
		
		if ads[advertID][AD_FROZEN] then
			outputChatBox("Ad is already frozen by `"..ads[advertID][AD_FROZEN].."`.", thePlayer, 255, 0 ,0)
			return
		end
		
		if ads[advertID][AD_AIRED] then
			outputChatBox("Ad is already aired", thePlayer, 255, 0 ,0)
			return
		end
		
		ads[advertID][AD_FROZEN] = getPlayerName(thePlayer)
		ads[advertID][AD_EDITTIME] = getRealTime().timestamp
		exports.global:sendMessageToAdmins("[AD] "..getPlayerName(thePlayer).." froze advert "..advertID .. ".")
	end
end
addCommandHandler("freezead", SAN_freezeAdvert)


function SAN_unfreezeAdvert(thePlayer, commandHandler, advertID)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not advertID or not tonumber(advertID) then
			outputChatBox("Syntax: /"..commandHandler.." <advertID>", thePlayer)
			return
		end
		
		advertID = tonumber(advertID)
		
		if not ads[advertID] then
			outputChatBox("Invalid ad", thePlayer, 255, 0 ,0)
			return
		end
		
		if not ads[advertID][AD_FROZEN] then
			outputChatBox("Ad is not frozen.", thePlayer, 255, 0 ,0)
			return
		end
		
		if ads[advertID][AD_AIRED] then
			outputChatBox("Ad is already aired", thePlayer, 255, 0 ,0)
			return
		end
		
		ads[advertID][AD_FROZEN] = false
		ads[advertID][AD_EDITTIME] = getRealTime().timestamp
		exports.global:sendMessageToAdmins("[AD] "..getPlayerName(thePlayer).." unfroze advert "..advertID .. ".")
		outputChatBox("Unfroze ad "..advertID, thePlayer, 0, 255 ,0)
	end
end
addCommandHandler("unfreezead", SAN_unfreezeAdvert)


function SAN_deleteAdvert(thePlayer, commandHandler, advertID)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not advertID or not tonumber(advertID) then
			outputChatBox("Syntax: /"..commandHandler.." <advertID>", thePlayer)
			return
		end
		
		advertID = tonumber(advertID)
		
		if not ads[advertID] then
			outputChatBox("Invalid ad", thePlayer, 255, 0 ,0)
			return
		end
		
		if ads[advertID][AD_AIRED] then
			outputChatBox("Ad is already aired", thePlayer, 255, 0 ,0)
			return
		end
		
		ads[advertID][AD_AIRED] = true
		exports.global:sendMessageToAdmins("[AD] "..getPlayerName(thePlayer).." marked advert "..advertID .. " as aired.")
	end
end
addCommandHandler("deletead", SAN_deleteAdvert)
addCommandHandler("delad", SAN_deleteAdvert)

--adTimer = setTimer(SAN_runAdverts, 20000, 1)