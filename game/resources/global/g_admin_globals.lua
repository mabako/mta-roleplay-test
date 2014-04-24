function getAdmins()
	local players = exports.pool:getPoolElementsByType("player")
	
	local admins = { }
	
	for key, value in ipairs(players) do
		if isPlayerAdmin(value) and getPlayerAdminLevel(value) <= 6 then
			table.insert(admins,value)
		end
	end
	return admins
end

function isPlayerAdmin(thePlayer)
	return getPlayerAdminLevel(thePlayer) >= 1
end

function isPlayerFullAdmin(thePlayer)
	return getPlayerAdminLevel(thePlayer) >= 2
end

function isPlayerSuperAdmin(thePlayer)
	return getPlayerAdminLevel(thePlayer) >= 3
end

function isPlayerHeadAdmin(thePlayer)
	return getPlayerAdminLevel(thePlayer) >= 5
end

function isPlayerLeadAdmin(thePlayer)
	return getPlayerAdminLevel(thePlayer) >= 4
end

function getPlayerAdminLevel(thePlayer)
	return isElement( thePlayer ) and tonumber(getElementData(thePlayer, "adminlevel")) or 0
end

local adminTitles = { "Trial Admin", "Admin", "Super Admin", "Lead Admin", "Head Admin", "Owner" }
function getPlayerAdminTitle(thePlayer)
	local text = adminTitles[getPlayerAdminLevel(thePlayer)] or "Player"
		
	local hiddenAdmin = getElementData(thePlayer, "hiddenadmin") or 0
	if (hiddenAdmin==1) then
		text = text .. " (Hidden)"
	end

	return text
end

--[[ GM ]]--
function getGameMasters()
	local players = exports.pool:getPoolElementsByType("player")
	local gameMasters = { }
	for key, value in ipairs(players) do
		if isPlayerGameMaster(value) then
			table.insert(gameMasters, value)
		end
	end
	return gameMasters
end

function isPlayerGameMaster(thePlayer)
	return getPlayerGameMasterLevel(thePlayer) >= 1
end

function isPlayerFullGameMaster(thePlayer)
	return getPlayerGameMasterLevel(thePlayer) >= 2
end

function isPlayerLeadGameMaster(thePlayer)
	return getPlayerGameMasterLevel(thePlayer) >= 3
end

function isPlayerHeadGameMaster(thePlayer)
	return getPlayerGameMasterLevel(thePlayer) >= 4
end

function getPlayerGameMasterLevel(thePlayer)
	return isElement( thePlayer ) and tonumber(getElementData(thePlayer, "account:gmlevel")) or 0
end

function isPlayerGMTeamLeader(thePlayer)
	if not isPlayerFullAdmin(thePlayer) and not isPlayerHeadGameMaster(thePlayer) then
		return false
	end
	return exports.donators:hasPlayerPerk(thePlayer,17)
end

local GMtitles = { "Trainee GameMaster", "GameMaster", "Lead GameMaster", "Head GameMaster" }
function getPlayerGMTitle(thePlayer)
	local text = GMtitles[getPlayerGameMasterLevel(thePlayer)] or "Player"
	return text
end
--[[ /GM ]]--

function isPlayerScripter(thePlayer)
	return false
end
