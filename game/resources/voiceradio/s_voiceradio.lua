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


addEventHandler( 'onPlayerVoiceStart', root,
    function()
		for i, nearbyPlayer in ipairs(getElementsByType ( "player" )) do
			local x, y, z = getElementPosition(source)
			local x2, y2, z2 = getElementPosition(nearbyPlayer)
			local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if distance <= 50 then
				if not isPedInVehicle(source) or getElementData(getPedOccupiedVehicle(source), "vehicle:windowstat") == 1 then
					setPlayerVoiceBroadcastTo( source, nearbyPlayer )
				end
			end
		end		
    end
)
addEventHandler( 'onPlayerVoiceStop', root,
	function()
		for index, nearbyPlayer in ipairs( nearbyPlayers ) do
			setPlayerVoiceIgnoreFrom( source, nearbyPlayer )
        end	
	end
)