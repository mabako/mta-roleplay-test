backupBlip = false
backupPlayer = nil

function removeBackup(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) or (getElementData(getPlayerTeam(thePlayer), "type") == 4 and getElementData(thePlayer, "factionleader") == 1) then
		if (backupPlayer~=nil) then
			
			for k,v in ipairs(getPlayersInTeam ( getTeamFromName("Los Santos Emergency Services") )) do
				triggerClientEvent(v, "destroyBackupBlip2", getRootElement())
			end
			removeEventHandler("onPlayerQuit", backupPlayer, destroyBlip)
			removeEventHandler("savePlayer", backupPlayer, destroyBlip)
			backupPlayer = nil
			backupBlip = false
			outputChatBox("LSES-Assist system reset!", thePlayer, 255, 194, 14)
		else
			outputChatBox("LSES-Assist system did not need reset.", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("resetassist", removeBackup, false, false)

function backup(thePlayer, commandName)
	local duty = tonumber(getElementData(thePlayer, "duty"))
	local theTeam = getPlayerTeam(thePlayer)
	local factionType = getElementData(theTeam, "type")
	
	if (factionType==4) and (duty>0) then
		if (backupBlip == true) and (backupPlayer~=thePlayer) then -- in use
			outputChatBox("There is already a assist beacon in use.", thePlayer, 255, 194, 14)
		elseif (backupBlip == false) then -- make backup blip
			backupBlip = true
			backupPlayer = thePlayer
			for k,v in ipairs(getPlayersInTeam ( getTeamFromName("Los Santos Emergency Services") )) do
				local duty = tonumber(getElementData(v, "duty"))
				
				if (duty>0) then
					triggerClientEvent(v, "createBackupBlip2", thePlayer)
					outputChatBox("A unit needs urgent assistance! Please respond ASAP!", v, 255, 194, 14)
				end
			end

			addEventHandler("onPlayerQuit", thePlayer, destroyBlip)
			addEventHandler("savePlayer", thePlayer, destroyBlip)
			
		elseif (backupBlip == true) and (backupPlayer==thePlayer) then -- in use by this player
			for key, v in ipairs(getPlayersInTeam(theTeam)) do
			
				local duty = tonumber(getElementData(v, "duty"))
				
				if (duty>0) then
					triggerClientEvent(v, "destroyBackupBlip2", getRootElement())
					outputChatBox("The unit no longer requires assistance.", v, 255, 194, 14)
				end
			end

			removeEventHandler("onPlayerQuit", thePlayer, destroyBlip)
			removeEventHandler("savePlayer", thePlayer, destroyBlip)
			backupPlayer = nil
			backupBlip = false
		end
	end
end
addCommandHandler("assist", backup, false, false)

function destroyBlip()
	local theTeam = getPlayerTeam(source)
	for key, value in ipairs(getPlayersInTeam(theTeam)) do
		outputChatBox("The unit no longer requires assistance.", value, 255, 194, 14)
		triggerClientEvent(value, "destroyBackupBlip2", getRootElement())
	end
	removeEventHandler("onPlayerQuit", source, destroyBlip)
	removeEventHandler("savePlayer", source, destroyBlip)
	backupPlayer = nil
	backupBlip = false
end