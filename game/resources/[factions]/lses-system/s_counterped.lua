addEvent("lses:ped:start", true)
function lsesPedStart(pedName)
	exports['global']:sendLocalText(client, "Rosie Jenkins says: Hello, how can I help you today?", 255, 255, 255, 10)
	--exports.global:sendLocalMeAction(source,"hands " .. genderm .. " collection of photographs to the woman behind the desk.")
end
addEventHandler("lses:ped:start", getRootElement(), lsesPedStart)

addEvent("lses:ped:help", true)
function lsesPedHelp(pedName)
	exports['global']:sendLocalText(client, pedName.." says: Oh really? I'll call someone in right away!", 255, 255, 255, 10)
	for key, value in ipairs( getPlayersInTeam( getTeamFromName("Los Santos Medical Services") ) ) do
		outputChatBox("[RADIO] This is dispatch, We've got an incident, Over.", value, 0, 183, 239)
		outputChatBox("[RADIO] Situation: Someone here needs immidately assistance, Over.  ((" .. getPlayerName(client):gsub("_"," ") .. "))", value, 0, 183, 239)
		outputChatBox("[RADIO] Location: All Saints Hospital, reception, Over. (("..pedName.."))", value, 0, 183, 239)
	end
end
addEventHandler("lses:ped:help", getRootElement(), lsesPedHelp)

addEvent("lses:ped:appointment", true)
function lsesPedAppointment(pedName)
	exports['global']:sendLocalText(client, "Rosie Jenkins says: I'll notify all the staff I can reach, please take a seat while waiting.", 255, 255, 255, 10)
	for key, value in ipairs( getPlayersInTeam( getTeamFromName("Los Santos Medical Services") ) ) do
		outputChatBox("[RADIO] This is the reception speaking, uhm, we've got someone waiting here for their appointment. ((" .. getPlayerName(client):gsub("_"," ") .. "))", value, 0, 183, 239)
		outputChatBox("[RADIO] Location: The hospital at the reception, Over. (("..pedName.."))", value, 0, 183, 239)
	end
end
addEventHandler("lses:ped:appointment", getRootElement(), lsesPedAppointment)