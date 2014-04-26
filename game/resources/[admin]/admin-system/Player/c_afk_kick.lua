local checkAFK = false

function armAFK()
	checkAFK = true
end
addEvent("admin:armAFK", true)
addEventHandler("admin:armAFK", getRootElement(), armAFK)

function playerIsNotAway()
	if checkAFK then
		triggerServerEvent("admin:disarmAFK", getLocalPlayer())
		checkAFK = false
	end
end

for _, v in pairs({"onClientCursorMove", "onClientConsole", "onClientClick", "onClientKey"}) do
	addEventHandler(v, getRootElement(), playerIsNotAway)
end