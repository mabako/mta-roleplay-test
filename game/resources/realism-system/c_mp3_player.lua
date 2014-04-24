------ MP3 PLAYER - gotta have my boats n hoes!
local currMP3 = 0

function toggleMP3(key, state)
	if getElementData(getLocalPlayer(), "fishing") or getElementData(getLocalPlayer(), "jammed") then
		-- fishing and weapon jams need +/= keys already
	elseif (exports.global:hasItem(getLocalPlayer(), 19) and not (isPedInVehicle(getLocalPlayer()))) then
		if (key=="-") then -- lower the channel
			if (currMP3==0) then
				currMP3 = 12
			else
				currMP3 = currMP3 - 1
			end
		elseif (key=="=") then -- raise the channel
			if (currMP3==12) then
				currMP3 = 0
			else
				currMP3 = currMP3 + 1
			end
			
		end
		setRadioChannel(currMP3)
		outputChatBox("You switched your MP3 Player to " .. getRadioChannelName(currMP3) .. ".")
	elseif not (isPedInVehicle(getLocalPlayer())) then
		currMP3 = 0
		setRadioChannel(currMP3)
	end
end
bindKey("-", "down", toggleMP3)
bindKey("=", "down", toggleMP3)

addEventHandler("onClientElementDataChange", getLocalPlayer(),
	function(name) 
		if name == "fishing" or name == "jammed" then
			if not getElementData(source, "fishing") and not getElementData(source, "jammed") then
				setTimer(
					function() -- delay enabling those keys a little, so we wont immediately change the radio
						bindKey("-", "down", toggleMP3)
						bindKey("=", "down", toggleMP3)
					end, 
					1000,
					1
				)
			else
				unbindKey("-", "down", toggleMP3)
				unbindKey("=", "down", toggleMP3)
			end
		end
	end
)

addEvent( "realism:mp3:off" )
addEventHandler( "realism:mp3:off", localPlayer,
	function( )
		if not isPedInVehicle(localPlayer) then
			currMP3 = 0
			setRadioChannel(currMP3)
		end
	end
)
