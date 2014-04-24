local wPhoneMenu, gRingtones, ePhoneNumber, bCall, bOK, bCancel, bSettings, gPhoneBook

local sx, sy = guiGetScreenSize()
local openedPhoneNumber = nil
local iitemValue = nil

local p_Sound = {}
local stopTimer = {}

function showPhoneGui(thePhoneNumber, contactList)
	-- itemValue
	if (wPhoneMenu) then
		hidePhoneGUI()
	end
	guiSetInputEnabled(true)
	openedPhoneNumber = tostring(thePhoneNumber)
	iitemValue = 1

	addEventHandler("onClientGUIClick", getRootElement(), onGuiClick)
	showCursor(true)
	local gamehour, gametime = getTime ()
	wPhoneMenu = guiCreateWindow(sx/2 - 150,sy/2 - 175,300,350,"Phone  "..openedPhoneNumber.." - "..tostring(gamehour)..":"..tostring(gametime),false)
	bCall = guiCreateButton(0.0424,0.0831,0.2966,0.0855,"Call",true,wPhoneMenu)
	ePhoneNumber = guiCreateEdit(0.3559,0.0831,0.5975,0.0855,"",true,wPhoneMenu)
	
	gPhoneBook = guiCreateGridList(0.0381,0.1977,0.9153,0.6706,true,wPhoneMenu)
	local colName = guiGridListAddColumn(gPhoneBook,"Name",0.6)
	local colNumber = guiGridListAddColumn(gPhoneBook,"Number",0.4)
	
	local row = guiGridListAddRow(gPhoneBook)
	guiGridListSetItemText(gPhoneBook, row, colName, "New contact", false, false)
	guiGridListSetItemText(gPhoneBook, row, colNumber, "-1", false, false)
	
	if (contactList) then
		for _, record in ipairs(contactList) do
			local row = guiGridListAddRow(gPhoneBook)
			guiGridListSetItemText(gPhoneBook, row, colName, record[1], false, false)
			guiGridListSetItemText(gPhoneBook, row, colNumber, record[2], false, false)

		end
	end
	bSettings = guiCreateButton(0.0381,0.8821,0.4492,0.0742,"Settings",true,wPhoneMenu)
	bCancel = guiCreateButton(0.5212,0.8821,0.4322,0.0742,"Close",true,wPhoneMenu)
	
	addEventHandler( "onClientGUIDoubleClick", gPhoneBook,
		function( button )
			if button == "left" then
				local row, col = guiGridListGetSelectedItem( gPhoneBook )
				if row ~= -1 and col ~= -1 then
					local gridID = guiGridListGetItemText( source , row, 2 )
					
					if (tonumber(gridID) ~= -1) then
						guiSetText(ePhoneNumber, gridID)
					else
						guiNewContact()
					end
				end
			end
		end,
		false
	)
	addEventHandler("onClientGUIClick", gPhoneBook, 
		function ( button )
			if button == "right" then
				local row, col = guiGridListGetSelectedItem( gPhoneBook )
				if row ~= -1 and col ~= -1 then
					local gridName = guiGridListGetItemText( source , row, 1 )
					local gridNumber = guiGridListGetItemText( source , row, 2 )
					
					if (tonumber(gridNumber) ~= -1) then
						guiConfirmDelete(gridName, gridNumber)
					end
				end
			end
		end,
		false
	)
end
addEvent("phone:showPhoneGUI", true)
addEventHandler("phone:showPhoneGUI", getRootElement(), showPhoneGui)

local wDelete, lQuestion, bButtonDeleteYes, bButtonDeleteNo, saveDeleteName, saveDeleteNumber = nil
function guiConfirmDelete(name, number)
	guiSetEnabled( wPhoneMenu, false )
	local sx, sy = guiGetScreenSize() 
	wDelete = guiCreateWindow(sx/2 - 150,sy/2 - 50,300,100,"Delete entry", false)
	lQuestion = guiCreateLabel(0.05,0.25,0.9,0.3, "Are you sure you want to delete '"..name.."' from your contacts list?",true,wDelete)
	guiLabelSetHorizontalAlign (lQuestion,"center",true)
	bButtonDeleteYes = guiCreateButton(0.1,0.65,0.37,0.23,"Yes",true,wDelete)
	bButtonDeleteNo = guiCreateButton(0.53,0.65,0.37,0.23,"No",true,wDelete)
	saveDeleteName = name
	saveDeleteNumber = number
end


function guiConfirmDeleteClose()
	if wDelete then
		destroyElement(wDelete)
	end
	guiSetEnabled( wPhoneMenu, true )
end

local wNewContact, fName, fNumber, bAddContact, bCancelContact, lName, lNumber = nil
function guiNewContact()
	guiSetEnabled( wPhoneMenu, false )
	local width, height = 300, 200
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
	
	wNewContact = guiCreateWindow(x, y, width, height, "Add new contact", false)
	
	lName = guiCreateLabel(0.1, 0.2, 0.55, 0.2, "Name:", true, wNewContact)
	fName = guiCreateEdit(0.3, 0.2, 0.55, 0.1, "", true, wNewContact)
	
	lNumber = guiCreateLabel(0.1, 0.4, 0.55, 0.1, "Number:", true, wNewContact)
	fNumber = guiCreateEdit(0.3, 0.4, 0.55, 0.1, "", true, wNewContact)

	bAddContact = guiCreateButton(0.1, 0.6, 0.85, 0.15, "Add contact", true, wNewContact)
	bCancelContact = guiCreateButton(0.1, 0.775, 0.85, 0.15, "Cancel", true, wNewContact)
end

function guiNewContactClose()
	if wNewContact then
		destroyElement(wNewContact)
	end
	guiSetEnabled( wPhoneMenu, true )
end

function onGuiClick(button)
	if button == "left" then
		if p_Sound["playing"] then
			stopSound(p_Sound["playing"])
		end
		if source == bCall then
			local phoneNumber = guiGetText(ePhoneNumber)
			triggerServerEvent("remoteCall", getLocalPlayer(), getLocalPlayer(), "call", tostring(phoneNumber), openedPhoneNumber or "-1")
			hidePhoneGUI()
		elseif source == bAddContact then
			local name = guiGetText(fName)
			local phoneNumber = guiGetText(fNumber)
			triggerServerEvent("phone:addContact", getLocalPlayer(), name, phoneNumber, openedPhoneNumber or "-1")
			guiNewContactClose()
		elseif source == gRingtones then
			if guiGridListGetSelectedItem(gRingtones) ~= -1 then
				p_Sound["playing"] = playSound(ringtones[guiGridListGetSelectedItem(gRingtones)])
			end
		elseif source == bCancel then
			hidePhoneGUI()
		elseif source == bSettings then
			hidePhoneGUI()
			setTimer(showSettingsGui, 300, 1, iitemValue)
		elseif source == bOK then
			if guiGridListGetSelectedItem(gRingtones) ~= -1 then
				triggerServerEvent("saveRingtone", getLocalPlayer(), guiGridListGetSelectedItem(gRingtones), tonumber(openedPhoneNumber) or 1)
			end
			hidePhoneGUI()
		elseif source == bButtonDeleteYes then
			triggerServerEvent("phone:deleteContact", getLocalPlayer(), saveDeleteName, saveDeleteNumber, tonumber(openedPhoneNumber) or 1)
			guiConfirmDeleteClose()
		elseif source == bButtonDeleteNo then
			guiConfirmDeleteClose()
		elseif source == bCancelContact then
			guiNewContactClose()
		end
	end
end

function hidePhoneGUI()
	guiConfirmDeleteClose()
	guiNewContactClose()
	if wPhoneMenu then
		destroyElement(wPhoneMenu)
	end
	removeEventHandler("onClientGUIClick", getRootElement(), onGuiClick)
	--openedPhoneNumber = nil
	wPhoneMenu = nil
	showCursor(false)
	guiSetInputEnabled(false)
end


function showSettingsGui(itemValue)
	addEventHandler("onClientGUIClick", getRootElement(), onGuiClick)
	showCursor(true)

	wPhoneMenu = guiCreateWindow(sx/2 - 125,sy/2 - 175,250,310,"Phone Settings Menu",false)
	gRingtones = guiCreateGridList(0.0381,0.1977,0.9153,0.6706,true,wPhoneMenu)
	guiGridListAddColumn(gRingtones,"ringtones",0.85)
	guiGridListSetItemText(gRingtones, guiGridListAddRow(gRingtones), 1, "vibrate mode", false, false)
	for i, filename in ipairs(ringtones) do
		guiGridListSetItemText(gRingtones, guiGridListAddRow(gRingtones), 1, filename:sub(1,-5), false, false)
	end
	guiGridListSetSelectedItem(gRingtones, itemValue, 1)
	bOK = guiCreateButton(0.0381,0.8821,0.4492,0.0742,"OK",true,wPhoneMenu)
	bCancel = guiCreateButton(0.5212,0.8821,0.4322,0.0742,"Cancel",true,wPhoneMenu)
end

function startPhoneRinging(ringType, itemValue)
	if ringType == 1 then -- phone call
		local x, y, z = getElementPosition(source)
		if not itemValue or itemValue < 0 then itemValue = 1 end
		p_Sound[source] = playSound3D(ringtones[itemValue], x, y, z, true)
		setSoundVolume(p_Sound[source], 0.4)
		setSoundMaxDistance(p_Sound[source], 20)
		setElementDimension(p_Sound[source], getElementDimension(source))
		setElementInterior(p_Sound[source], getElementInterior(source))
		stopTimer[source] = setTimer(triggerEvent, 15000, 1, "stopRinging", source)
	elseif ringType == 2 then -- sms
		p_Sound[source] = playSound3D("sms.mp3",getElementPosition(source))
	else
		outputDebugString("Ring type "..tostring(ringType).. " doesn't exist!", 2)
	end
	attachElements(p_Sound[source], source)
end
addEvent("startRinging", true)
addEventHandler("startRinging", getRootElement(), startPhoneRinging)

function stopPhoneRinging()
	if p_Sound[source] then
		destroyElement(p_Sound[source])
		p_Sound[source] = nil
	end
	if stopTimer[source] then
		killTimer(stopTimer[source])
		stopTimer[source] = nil
	end
end
addEvent("stopRinging", true)
addEventHandler("stopRinging", getRootElement(), stopPhoneRinging)