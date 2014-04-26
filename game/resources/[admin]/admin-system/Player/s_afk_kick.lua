local pending = {}

function checkAFK()
	for thePlayer, isPending in pairs(pending) do
		if (getPlayerIdleTime(thePlayer) >  600000) then
			if exports.global:isPlayerFullAdmin(thePlayer) then
				if getElementData(thePlayer, "adminduty") == 1 then
					exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "adminduty", 0, false)
					exports.global:sendMessageToAdmins("AdmDuty: " .. getPlayerName(thePlayer):gsub("_", " ") .. " went off duty (AFK).")
					exports.global:updateNametagColor(thePlayer)
				end
			else
				triggerClientEvent(thePlayer, "accounts:logout", thePlayer, "You have been put to the character selection for being AFK.")
			end
		else
			pending[thePlayer] = nil
		end
	end

	for _, thePlayer in ipairs(getElementsByType('player')) do
		if (getPlayerIdleTime(thePlayer) >  600000) then
			local loggedIn = getElementData(thePlayer, "loggedin")
			if loggedIn == 1 then
				pending[thePlayer] = true
				triggerClientEvent(thePlayer, "admin:armAFK", thePlayer)
			end
		end
	end

end
setTimer(checkAFK, 60000, 0) -- Every minute check pls

function disarmAFK()
	pending[client or source] = false
end
addEvent("admin:disarmAFK", true)
addEventHandler("admin:disarmAFK", getRootElement(), disarmAFK)