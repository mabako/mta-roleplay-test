---Voice radio by Anumaz
---Using MTA's voice resource
function setRadioFrequency(thePlayer, commandName, theFrequency)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")		
		if (factionType==2) or (factionType==4) then
			if not theFrequency then outputChatBox("Syntax: /" .. commandName .." [frequency]", thePlayer) end
			if theFrequency then
				exports.voice:setPlayerChannel(thePlayer, theFrequency)
				outputChatBox("Your voice frequency has been changed to: " .. theFrequency, thePlayer)
				exports.global:sendLocalMeAction(thePlayer, "changes the radio frequency.")
			end
		else
			outputChatBox("You must be in LSPD or LSFD to use this command.", thePlayer)
		end
	end
end
addCommandHandler("changefreq", setRadioFrequency)

