wMonitor, monitorList, bRemove, bCancel = nil

function showMonitorWindow(content, ableToRemove)
	if wMonitor then
		destroyElement(wMonitor)
		wMonitor = nil
	end
	
	local width, height = 750, 500
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
	
	wMonitor = guiCreateWindow(x, y, width, height, "To monitor", false)

	monitorList = guiCreateGridList(0.05, 0.05, 0.9, 0.85, true, wMonitor)
	local column = guiGridListAddColumn(monitorList, "Username", 0.2)
	local column2 = guiGridListAddColumn(monitorList, "Playername", 0.25)
	local column3 = guiGridListAddColumn(monitorList, "Reason", 1)
	
	for row, value in ipairs( content ) do
		local row = guiGridListAddRow(monitorList)
		guiGridListSetItemText(monitorList, row, column, value[1], false, false)
		guiGridListSetItemText(monitorList, row, column2, value[2], false, false)
		guiGridListSetItemText(monitorList, row, column3, value[3], false, false)
	end
	
	if (ableToRemove) then
		bRemove = guiCreateButton(0.05, 0.92, 0.44, 0.05, "Remove Selected", true, wMonitor)
		addEventHandler("onClientGUIClick", bRemove, removePlayerFromList, false)
	end
	bCancel = guiCreateButton(0.51, 0.92, 0.44, 0.05, "Close", true, wMonitor)
	addEventHandler("onClientGUIClick", bCancel, closeMonitor, false)
	
	showCursor(true)
end
addEvent("onMonitorPopup", true)
addEventHandler("onMonitorPopup", getRootElement(), showMonitorWindow)

function removePlayerFromList(button, state)
	if button == "left" and state == "up" then
		local row, col = guiGridListGetSelectedItem(monitorList)
		
		if (row==-1) or (col==-1) then
			outputChatBox("Please select a player first!", 255, 0, 0)
		else
			local name = tostring(guiGridListGetItemText(monitorList, guiGridListGetSelectedItem(monitorList), 2))
			local player = getPlayerFromName(name:gsub(" ", "_"))
			if player then
				triggerServerEvent("monitor:remove", player)
			else
				outputChatBox("No such player (anymore)...", 255, 0, 0)
			end
		end
	end
end

function closeMonitor(button, state)
	if button == "left" and state == "up" then
		destroyElement(wMonitor)
		wMonitor = nil
		showCursor(false)
	end
end


local guiLogIn = nil
 -- log in window
 function showoMonitorAdd()
	if guiLogIn then
		return
	end
	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 250
	local Height = 150
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	guiLogIn = guiCreateWindow ( X , Y , Width , Height , "Add someone to the monitor system" , false )
	
	guiUserLabel  = guiCreateLabel(0.05, 0.15, 0.9, 0.2, "Exact Username:", true, guiLogIn)
	guiUserNameEdit = guiCreateEdit(0.05, 0.25, 0.9, 0.2, "", true, guiLogIn)
	guiPasswordLabel  = guiCreateLabel(0.05, 0.45, 0.9, 0.2, "Reason:", true, guiLogIn)
	guiPasswordEdit = guiCreateEdit(0.05, 0.55, 0.9, 0.2, "", true, guiLogIn)

	guiLogInSubmitButton = guiCreateButton(0.15, 0.8, 0.3, 0.2, "Save", true, guiLogIn)
	guiLogInBackButton = guiCreateButton(0.55, 0.8, 0.3, 0.2, "Close", true, guiLogIn)
 	
	guiSetInputEnabled ( true)
	-- if the player has clicked back, just close the windows
	addEventHandler ( "onClientGUIClick", guiLogInBackButton,  function(button, state)
		if(button == "left") then
			destroyElement(guiLogIn)
			guiSetInputEnabled ( false)
			guiLogIn = nil
		end
	end, false)
	
	-- if the player has clicked log in, get the name and password details, and send it to the server
	addEventHandler ( "onClientGUIClick", guiLogInSubmitButton,  function(button, state)
		if(button == "left") then
			triggerServerEvent("monitor:add", getLocalPlayer(), guiGetText(guiUserNameEdit),  guiGetText(guiPasswordEdit))
			destroyElement(guiLogIn)
			guiSetInputEnabled ( false)
			 guiLogIn = nil
		end
	end, false)
	
end
addEvent("monitor:oadd", true)
addEventHandler("monitor:oadd", getRootElement(), showoMonitorAdd)