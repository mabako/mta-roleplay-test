
--give player license
function givePlayerLicense(thePlayer, commandName, targetPlayerName, licenseType)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not targetPlayerName or not (licenseType and (licenseType == "1" or licenseType == "2")) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Type]", thePlayer, 255, 194, 14)
			outputChatBox("Type 1 = Driver", thePlayer, 255, 194, 14)
			outputChatBox("Type 2 = Weapon", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local licenseTypeOutput = licenseType == "1" and "driver" or "weapon"
					licenseType = licenseType == "1" and "car" or "gun"
					if getElementData(targetPlayer, "license."..licenseType) == 1 then
						outputChatBox(getPlayerName(thePlayer).." has already a "..licenseTypeOutput.." license.", thePlayer, 255, 255, 0)
					else
						if (licenseType == "gun") then
							if exports.global:isPlayerSuperAdmin(thePlayer) then
								exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 1, false)
								mysql:query_free("UPDATE characters SET "..mysql:escape_string(licenseType).."_license='1' WHERE id = "..mysql:escape_string(getElementData(targetPlayer, "dbid")).." LIMIT 1")
								
								outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." gives you a "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
								exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVELICENSE GUN")
								local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							
								if (hiddenAdmin==0) then
									local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
									exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " a weapon license.")
								else
									outputChatBox("Player "..targetPlayerName.." now has a "..licenseTypeOutput.." license.", thePlayer, 0, 255, 0)
								end
							else
								outputChatBox("You are not allowed to spawn gun licenses.", thePlayer, 255, 0, 0)
							end
						else
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 1, false)
							mysql:query_free("UPDATE characters SET "..mysql:escape_string(licenseType).."_license='1' WHERE id = "..mysql:escape_string(getElementData(targetPlayer, "dbid")).." LIMIT 1")
							
							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." gives you a "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVELICENSE CAR")
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							
							if (hiddenAdmin==0) then
								local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
								exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " a drivers license.")
							else
								outputChatBox("Player "..targetPlayerName.." now has a "..licenseTypeOutput.." license.", thePlayer, 0, 255, 0)
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("agivelicense", givePlayerLicense)


--take player license
function takePlayerLicense(thePlayer, commandName, dtargetPlayerName, licenseType)
	if exports.global:isPlayerSuperAdmin(thePlayer) then
		if not dtargetPlayerName or not (licenseType and (licenseType == "1" or licenseType == "2")) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Nick] [Type]", thePlayer, 255, 194, 14)
			outputChatBox("Type 1 = Driver", thePlayer, 255, 194, 14)
			outputChatBox("Type 2 = Weapon", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(nil, dtargetPlayerName)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local licenseTypeOutput = licenseType == "1" and "driver" or "weapon"
					licenseType = licenseType == "1" and "car" or "gun"
					if getElementData(targetPlayer, "license."..licenseType) == 0 then
						outputChatBox(getPlayerName(thePlayer).." has no "..licenseTypeOutput.." license.", thePlayer, 255, 255, 0)
					else
						if (licenseType == "gun") then
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 0, false)
							mysql:query_free("UPDATE characters SET "..mysql:escape_string(licenseType).."_license='0' WHERE id = "..mysql:escape_string(getElementData(targetPlayer, "dbid")).." LIMIT 1")
							--outputChatBox("Player "..targetPlayerName.." now has a "..licenseTypeOutput.." license.", thePlayer, 0, 255, 0)
							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." revokes your "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "TAKELICENSE GUN")
							
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							if (hiddenAdmin==0) then
								local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
								exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " revoked " .. targetPlayerName .. " his ".. licenseType .." license.")
							else
								outputChatBox("Player "..targetPlayerName.." now  has his  "..licenseType.." license revoked.", thePlayer, 0, 255, 0)
							end
						else
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 0, false)
							mysql:query_free("UPDATE characters SET "..mysql:escape_string(licenseType).."_license='0' WHERE id = "..mysql:escape_string(getElementData(targetPlayer, "dbid")).." LIMIT 1")
							outputChatBox("Player "..targetPlayerName.." now has a "..licenseTypeOutput.." license.", thePlayer, 0, 255, 0)
							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." revokes your "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "TAKELICENSE CAR")
							
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							if (hiddenAdmin==0) then
								local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
								exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " revoked " .. targetPlayerName .. " his ".. licenseType .." license.")
							else
								outputChatBox("Player "..targetPlayerName.." now  has his  "..licenseType.." license revoked.", thePlayer, 0, 255, 0)
							end
						end
					end
				end
			else
				local resultSet = mysql:query_fetch_assoc("SELECT `id`,`car_license`,`gun_license` FROM `characters` where `charactername`='"..mysql:escape_string(dtargetPlayerName).."'")
				if resultSet then
					licenseType = licenseType == "1" and "car" or "gun"
					if (tonumber(resultSet[licenseType.."_license"]) ~= 0) then
						local resultQry = mysql:query_free("UPDATE `characters` SET `"..licenseType.."_license`=0 WHERE `charactername`='"..mysql:escape_string(dtargetPlayerName).."'")
						if (resultQry) then
							exports.logs:dbLog(thePlayer, 4, { "ch"..resultSet["id"] }, "TAKELICENSE "..licenseType)
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							if (hiddenAdmin==0) then
								local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
								exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " revoked " .. dtargetPlayerName .. " his ".. licenseType .." license.")
							else
								outputChatBox("Player "..dtargetPlayerName.." now  has his  "..licenseType.." license revoked.", thePlayer, 0, 255, 0)
							end
						else
							outputChatBox("Wups, atleast something went wrong there..", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("The player doesn't have this license.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("No player found.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("atakelicense", takePlayerLicense)
