local suspectDetails = {}
local suspectCrime
local suspectWanted = {}
local user = {}
local accounts = {}
local allSuspects = {}
local savedTypeResult = 1
local pendingLogin = false
-- function to create the delete crime window
function createDeleteCrimeWindow()

	-- toggle controls so you can't walk around
	toggleAllControls ( false , true, false)
	triggerEvent("onClientPlayerWeaponCheck", localPlayer)
	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 200
	local Height = 100
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	guiDeleteCrimeWindow = guiCreateWindow ( X , Y , Width , Height , "Remove Crime" , false )
	
	guiDeleteCrimeLable = guiCreateLabel(0.05, 0.2, 0.9, 0.3, "Enter crime ID:", true, guiDeleteCrimeWindow)
	
	guiDeleteCrimeEditBox = guiCreateEdit(0.1, 0.4, 0.8, 0.3, "", true, guiDeleteCrimeWindow)
	guiEditSetMaxLength ( guiDeleteCrimeEditBox , 5)
	
	guiDeleteCrimeSubmit = guiCreateButton ( 0.15 , 0.75 , 0.3 , 0.3 , "Delete" , true ,guiDeleteCrimeWindow)
	guiDeleteCrimeBack = guiCreateButton ( 0.6 , 0.75 , 0.3, 0.3 , "Back" , true , guiDeleteCrimeWindow )
	
	guiSetVisible(guiDeleteCrimeWindow, false)

	-- on click the back button
	addEventHandler ( "onClientGUIClick", guiDeleteCrimeBack,  function(button, state)
	
		if(button == "left") then
			guiSetVisible(guiDeleteCrimeWindow, false)
		end
	
	end, false)
	
	-- if the player clicks on the submit buttons
	addEventHandler("onClientGUIClick", guiDeleteCrimeSubmit , function(button, state)
		
		if(button == "left") then
		
			-- hide the window
			guiSetVisible(guiDeleteCrimeWindow, false)
					
			local crimeID = guiGetText(guiDeleteCrimeEditBox)

			local same = false
			
			-- loop through all the crimes to do with the current suspect, and set same to true if one of them is the same
			for i, value in pairs(suspectCrime) do
				
				if(tonumber(value[1]) == tonumber(crimeID)) then
					same = true
				end
			end
						
			-- if none were the same, set CrimeID to nil
			if not (same) then
				crimeID = nil
			end
			
			if (guiPhotoImage) then
				destroyElement(guiPhotoImage)
			end
			
			if(crimeID) then
				if(triggerServerEvent("onDeleteCrime", getLocalPlayer(), crimeID)) then
										
					guiSetInputEnabled(false)
					
					if(crimeID) then
						guiSetText(guiMdcMemo, "~~~ Removing crime from "..suspectDetails[1].."'s permanant record. ~~~\n\nThis may take up to 10 seconds to process - Please Wait.")
						setTimer(function ()
							-- get the suspect details
							triggerServerEvent("onGetSuspectCrimes", getLocalPlayer(), suspectDetails[1])
					
							setTimer(function()
								-- delete the window, then create a new one
								hideMdc("left", "up")
								createMdcWindow(suspectDetails[1], nil)
								guiSetVisible(guiMdcWindow, true)
								guiSetInputEnabled(true)
							end, 2500 , 1)
					
						end, 2500, 1)
					end
				
				end
			else
				guiSetText(guiMdcMemo, "~~~ The crime ID given was not associated with the suspect you are looking at ~~~\n\nYou may only remove crimes for the suspect your are currently viewing.")
					
				setTimer(function()
					-- delete the window, then create a new one
					hideMdc("left", "up")
					createMdcWindow(suspectDetails[1], nil)
					guiSetVisible(guiMdcWindow, true)
					guiSetInputEnabled(true)
				end, 2500 , 1)
			end
		end
	end, false)
end




-- function to create the delete suspect
function createDeleteSuspectWindow()

	-- toggle controls so you can't walk around
	toggleAllControls ( false , true, false)
	triggerEvent("onClientPlayerWeaponCheck", localPlayer)
	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 200
	local Height = 100
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	guiDeleteSuspectWindow = guiCreateWindow ( X , Y , Width , Height , "Remove Suspect" , false )
	
	guiDeleteSuspectLable = guiCreateLabel(0.05, 0.2, 0.9, 0.3, "Enter Suspect Name:", true, guiDeleteSuspectWindow)
	
	guiDeleteSuspectEditBox = guiCreateEdit(0.1, 0.4, 0.8, 0.3, "", true, guiDeleteSuspectWindow)
	guiEditSetMaxLength ( guiDeleteSuspectEditBox , 20)
	
	guiDeleteSuspectSubmit = guiCreateButton ( 0.15 , 0.75 , 0.3 , 0.3 , "Remove" , true ,guiDeleteSuspectWindow)
	guiDeleteSuspectBack = guiCreateButton ( 0.6 , 0.75 , 0.3, 0.3 , "Back" , true , guiDeleteSuspectWindow )


	-- on click the back button
	addEventHandler ( "onClientGUIClick", guiDeleteSuspectBack,  function(button, state)
	
		if(button == "left") then
			guiSetVisible(guiDeleteSuspectWindow, false)
		end
	
	end, false)
	
	-- if the player clicks on the submit buttons
	addEventHandler("onClientGUIClick", guiDeleteSuspectSubmit, function(button, state)
		
		if(button == "left") then
		
			-- hide the window
			guiSetVisible(guiDeleteSuspectWindow, false)
					
			local name = guiGetText(guiDeleteSuspectEditBox)
	
			if (guiPhotoImage) then
				destroyElement(guiPhotoImage)
			end
			
			if not (name == "" ) then
				if(triggerServerEvent("onDeleteSuspect", getLocalPlayer(), name)) then
										
					guiSetInputEnabled(false)
					
					guiSetText(guiMdcMemo, "~~~ Removing the suspect '"..name.."' from the database if they exist. ~~~\n\nThis may take up to 10 seconds to process - Please Wait.")
					setTimer(function ()
						
						-- reset the suspect details
						suspectDetails = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
						suspectCrime = nil
						suspectWanted = {}
					
						setTimer(function()
							-- delete the window, then create a new one
							hideMdc("left", "up")
							createMdcWindow(nil, nil)
							guiSetVisible(guiMdcWindow, true)
							guiSetInputEnabled(true)
						end, 2500 , 1)
					
					end, 2500, 1)
				
				end
			end
		end
	
	end, false)
end





-- create the MDC window, which the player first sees with /mdc
function createMdcWindow(suspectName, vehiclePlate)

	-- toggle controls so you can't walk around
	toggleAllControls ( false , true, false)
triggerEvent("onClientPlayerWeaponCheck", localPlayer)
	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 614
	local Height = 537
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	guiMdcWindow = guiCreateWindow ( X , Y , Width , Height , "Mobile Data Computer" , false )
	
	guiMdcLogo = guiCreateStaticImage ( 0.08 , 0.05 , 0.9 , 0.18, "mdc.png", true, guiMdcWindow) 
	
	guiSearchLabel =  guiCreateLabel ( 0.05 , 0.23 , 0.3 , 0.1 , "Search criminal database:", true,  guiMdcWindow )
	
		
	-- check to see if the window has been given a suspect name, if not, just put default crap in
	if(suspectName == nil) and (vehiclePlate == nil) then
		guiMdcMemo = guiCreateMemo ( 0.05 , 0.35 , 0.7, 0.6, getDefaultMemoText() , true , guiMdcWindow)
		guiMemoSetReadOnly ( guiMdcMemo, true )
	else
		local memoText = getMemoText()
		guiMdcMemo = guiCreateMemo ( 0.05 , 0.35 , 0.7, 0.6, memoText , true , guiMdcWindow)
		guiMemoSetReadOnly ( guiMdcMemo, true )	
	end
	
	if(suspectName == nil) then
		guiSearchEditBox = guiCreateEdit ( 0.05 ,0.28 , 0.3 , 0.05 , "Firstname_Lastname" , true , guiMdcWindow)
	else
		guiSearchEditBox = guiCreateEdit ( 0.05 ,0.28 , 0.3 , 0.05 , suspectName , true , guiMdcWindow)
	end
	guiSearchButton = guiCreateButton ( 0.36 , 0.28 , 0.2 , 0.05 ,"Search" , true , guiMdcWindow )
	guiEditSetMaxLength ( guiSearchEditBox, 20 )
	
	guiSearchLabel =  guiCreateLabel ( 0.60 , 0.23 , 0.3 , 0.1 , "Search vehicle database:", true,  guiMdcWindow )
	
	if(vehiclePlate == nil) then
		guiSearchVehicleEditBox = guiCreateEdit ( 0.60 ,0.28 , 0.25 , 0.05 , "AAB 12345", true , guiMdcWindow)
	else	
		guiSearchVehicleEditBox = guiCreateEdit ( 0.60 ,0.28 , 0.25 , 0.05 , vehiclePlate, true , guiMdcWindow)
	end
	guiSearchVehicleButton = guiCreateButton ( 0.86 , 0.28 , 0.2 , 0.05 ,"Search" , true, guiMdcWindow )
	guiEditSetMaxLength ( guiSearchVehicleEditBox, 20 )
	
	if((suspectDetails[2] ~= nil) and suspectName) then
		guiPhotoImage = guiCreateStaticImage (0.72, 0, 0.23, 0.3, ":account-system/img/" .. suspectDetails[12]..".png", true, guiMdcMemo)
	end
	
	-- ONLY SHOW THE DELETE CRIME STUFF IS THE PLAYER IS IN THE HIGH COMMAND --
	if(user[3] == "1") then
		
		guiViewAllSuspectsButton = guiCreateButton ( 0.78 , 0.35 , 0.2 , 0.05 , "Show All Suspects" , true , guiMdcWindow )
		guiViewSuspectRemoveButton = guiCreateButton ( 0.78 , 0.42 , 0.2 , 0.05 , "Remove Suspect" , true , guiMdcWindow )
		guiAddPersonnelButton = guiCreateButton ( 0.78 , 0.49, 0.2 , 0.05 , "Add New Suspect" , true , guiMdcWindow )
		guiViewPersonnelButton = guiCreateButton ( 0.78 , 0.56 , 0.2 , 0.05 , "Edit Suspect Info" , true , guiMdcWindow )
		guiAddWantedButton = guiCreateButton ( 0.78 , 0.63 , 0.2 , 0.05 , "Warrant Details" , true , guiMdcWindow )
		guiAddCrimeButton = guiCreateButton ( 0.78 , 0.7 , 0.2 , 0.05 , "Add Crime" , true , guiMdcWindow )
		guiDeleteCrimeButton = guiCreateButton ( 0.78 , 0.77 , 0.2 , 0.05 , "Remove Crime" , true , guiMdcWindow )
		guiEditAccountsButton = guiCreateButton ( 0.78 , 0.84 , 0.2 , 0.05 , "Account Settings" , true , guiMdcWindow )
		
				-- event handler if the delete crime button was clicked
		addEventHandler("onClientGUIClick", guiDeleteCrimeButton , function(button, state)
			if(button == "left") then
				if(clearShowWindow()) then
					if not(guiGetVisible(guiAddCrimeWindow) or guiGetVisible(guiDetailsWindow) or guiGetVisible(guiDeleteCrimeWindow) or guiGetVisible(guiWarrantWindow) ) then
						if(suspectName) then
							if(suspectDetails[2]) then
							
								showDeleteCrimeWindow()

							else
								guiSetText(guiMdcMemo, "~~~ Cannot remove crime from "..suspectName.."'s record since it does not exist. ~~~\n\nPlease search for another suspect, or add the suspect to the database before adding a new crime.")
							end
						else
							guiSetText(guiMdcMemo, "~~~ You need to select a suspect before you can delete a crime ~~~\n\nEnter the name of the suspect that you want to add a crimt to in the text box above, and then click on search.")
						end
					end
				end
			end
		end, false)
		
		
		
		
	else
		guiAddPersonnelButton = guiCreateButton ( 0.78 , 0.35 , 0.2 , 0.05 , "Add New Suspect" , true , guiMdcWindow )
		guiViewPersonnelButton = guiCreateButton ( 0.78 , 0.42 , 0.2 , 0.05 , "Edit Suspect Info" , true , guiMdcWindow )
		guiAddWantedButton = guiCreateButton ( 0.78 , 0.49 , 0.2 , 0.05 , "Warrant Details" , true , guiMdcWindow )
		guiAddCrimeButton = guiCreateButton ( 0.78 , 0.56 , 0.2 , 0.05 , "Add Crime" , true , guiMdcWindow )
		guiEditAccountsButton = guiCreateButton ( 0.78 , 0.63 , 0.2 , 0.05 , "Account Settings" , true , guiMdcWindow )
	end
	
	-- if the player clicks on the account details button
	addEventHandler ( "onClientGUIClick", guiEditAccountsButton,  function(button, state) 
		if(clearShowWindow()) then
			if(button == "left") then -- set it visible
				createAccountWindow()
				guiSetVisibile(guiAccountWindow, true)
			end
		end
	end, false)
	
	-- if the player clicks on remove suspect
	if(user[3] == "1") then
		addEventHandler ( "onClientGUIClick", guiViewSuspectRemoveButton,  function(button, state) 
			if(clearShowWindow()) then
				if(button == "left") then -- set it visible
					createDeleteSuspectWindow()
					guiSetVisible(guiDeleteSuspectWindow,true)
				end
			end
		end, false)
	end
	
	
	
	guiBackButton = guiCreateButton ( 0.78 , 0.9 , 0.2 , 0.05 , "Log Off" , true , guiMdcWindow )
	
	guiSetVisible(guiMdcWindow, false)
	
	addEventHandler ( "onClientGUIClick", guiBackButton, function(button, state)
		if(button == "left") then
			hideMdc("left", "up")
			
			suspectDetails = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
			suspectCrime = nil
			suspectWanted = {}
			user = {nil, nil,nil}
			accounts = {}
			allSuspects = {}
			
		end
	end, false)
	
	-- if the search button is clicked, remake the window with the suspects information
	addEventHandler ( "onClientGUIClick", guiSearchButton,  function(button, state)
	
		if(button == "left") then
			if(clearShowWindow()) then
				-- get the suspect name from the edit box
				local suspectName = guiGetText ( guiSearchEditBox)
				
				if (guiPhotoImage) then
					destroyElement(guiPhotoImage)
				end
				-- get the suspects names and crimes from the database
				triggerServerEvent("onGetSuspectDetails", getLocalPlayer(), suspectName)
				triggerServerEvent("onGetSuspectCrimes", getLocalPlayer(), suspectName)
				
				guiSetInputEnabled(false)
				guiSetText(guiMdcMemo, "~~~ Searching database for "..suspectName.." - Please Wait ~~~ ")
				
				setTimer(function()
					-- delete the window, then create a new one
					hideMdc("left", "up")
					createMdcWindow(suspectDetails[1], nil)
					guiSetVisible(guiMdcWindow, true)
					guiSetInputEnabled(true)
				end, 2000 , 1)
			end
		end
		
	end, false)
	
	-- Search vehicles
	addEventHandler ( "onClientGUIClick", guiSearchVehicleButton,  function(button, state)
	
		if(button == "left") then
			if(clearShowWindow()) then
				-- get the suspect name from the edit box
				local suspectName = guiGetText ( guiSearchVehicleEditBox)
				
				if (guiPhotoImage) then
					destroyElement(guiPhotoImage)
				end
				-- get the suspects names and crimes from the database
				triggerServerEvent("onGetVehicleDetails", getLocalPlayer(), suspectName)
				--triggerServerEvent("onGetSuspectCrimes", getLocalPlayer(), suspectName)
				
				guiSetInputEnabled(false)
				guiSetText(guiMdcMemo, "~~~ Searching database for vehicle "..suspectName.." - Please Wait ~~~ ")
				
				setTimer(function()
					-- delete the window, then create a new one
					hideMdc("left", "up")
					createMdcWindow(nil, suspectDetails[1])
					guiSetVisible(guiMdcWindow, true)
					guiSetInputEnabled(true)
				end, 2000 , 1)
			end
		end
		
	end, false)
	
	addEventHandler ( "onClientGUIClick", guiAddPersonnelButton,  addSuspectShow, false)
	
	addEventHandler ( "onClientGUIClick", guiViewPersonnelButton,  function(button, state)
		if(button == "left") then
			if(clearShowWindow()) then
				if not(guiGetVisible(guiAddCrimeWindow) or guiGetVisible(guiDetailsWindow) or guiGetVisible(guiDeleteCrimeWindow) or guiGetVisible(guiWarrantWindow) ) then
					if(suspectName) then
						if (suspectDetails[2]) then
							viewSuspectShow()
						else
							guiSetText(guiMdcMemo, "~~~ Cannot show personal information for "..suspectName.." since they do not have a database record. ~~~\n\nPlease search for another suspect before trying to check personal records.")
						end
					else
						guiSetText(guiMdcMemo, "~~~ You need to select a suspect before you can view any personal information ~~~\n\nEnter the name of the suspect that you want to view in the text box above, and then click on search.")
					end
				end
			end
		end
	
	end, false)
	
	-- event handler for Warrant BUttons
	addEventHandler ( "onClientGUIClick", guiAddWantedButton,  function(button, state)
		if(button == "left") then
			if(clearShowWindow()) then
				if not(guiGetVisible(guiAddCrimeWindow) or guiGetVisible(guiDetailsWindow) or guiGetVisible(guiDeleteCrimeWindow) or guiGetVisible(guiWarrantWindow) ) then
					if(suspectName) then
						if(suspectDetails[2]) then
							viewWarrantShow()
						else
							guiSetText(guiMdcMemo, "~~~ Cannot show warant details for "..suspectName.." since they do not have a database record. ~~~\n\nPlease search for another suspect, or add the suspect to the database before viewing warrant details.")
						end
					else
						guiSetText(guiMdcMemo, "~~~ You need to select a suspect before you can view the warrant details ~~~\n\nEnter the name of the suspect that you want to view in the text box above, and then click on search.")
					end
				end
			end
		end
	end, false)
	
	addEventHandler ( "onClientGUIClick", guiAddCrimeButton,  function(button, state)
		if(button == "left") then
			if(clearShowWindow()) then
				if not(guiGetVisible(guiAddCrimeWindow) or guiGetVisible(guiDetailsWindow) or guiGetVisible(guiDeleteCrimeWindow) or guiGetVisible(guiWarrantWindow) ) then
					if(suspectName) then
						if(suspectDetails[2]) then
							addCrimeShow()
						else
							guiSetText(guiMdcMemo, "~~~ Cannot add crime to "..suspectName.."'s record since it does not exist. ~~~\n\nPlease search for another suspect, or add the suspect to the database before adding a new crime.")
						end
					else
						guiSetText(guiMdcMemo, "~~~ You need to select a suspect before you can add a crime ~~~\n\nEnter the name of the suspect that you want to add a crimt to in the text box above, and then click on search.")
					end
				end
			end
		end
	end, false)
	
	
	
	-- If  view all suspects button is pressed
	if(user[3] == "1") then
		addEventHandler ( "onClientGUIClick", guiViewAllSuspectsButton,  function(button, state)
			if(button == "left") then
			
				if(triggerServerEvent("onGetAllSuspects", getLocalPlayer(), details ) ) then
					
					if (guiPhotoImage) then
						destroyElement(guiPhotoImage)
					end
					
					guiSetInputEnabled(false)
					
					guiSetText(guiMdcMemo, "~~~ Searching for all of the suspects on the database ~~~\n\nPlease allow 5 seconds for this to process.")
					
					setTimer(function()
						guiSetText(guiMdcMemo, getAllSuspectsText())
						guiSetInputEnabled(true)
					end, 2500 , 1)
				end
			end
		end, false)
	end
	
	
	guiToggleButton = guiCreateButton ( 0.05 , 0.96 , 0.18 , 0.03 , "Toggle Input" , true , guiMdcWindow )
	guiToggleLabel = guiCreateLabel(0.25, 0.95, 0.8, 0.03, "(( Click this to toggle between that chatbox and this MDC window ))", true, guiMdcWindow)
	
	addEventHandler("onClientGUIClick", guiToggleButton ,  toggleInputEnabled)
	

end

-- function gets the text to show all of the suspects
function getAllSuspectsText()
	local text
	text = "--- Suspect Name ---\n\n"
	
	local tempsuspect
	for i, j in pairs(allSuspects) do
		tempsuspect = "  "..j[1].."      - Last updated by "..j[2].."\n"
		text = text..tempsuspect
	end
	return text
end



-- create the add crime GUI
function createAddCrimeWindow()

	-- toggle controls so you can't walk around
	toggleAllControls ( false , true, false)
	triggerEvent("onClientPlayerWeaponCheck", localPlayer)
	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 400
	local Height = 500
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2

	guiAddCrimeWindow = guiCreateWindow ( X , Y , Width , Height , "Add Crime" , false )
	
	local hour, minute = getTime()
	local realTime = getRealTime()
	
	if(minute<10) then
		minute = "0"..tostring(minute)
	end
	
	guiAddIntroLabel =  guiCreateLabel ( 0.05 , 0.03 , 0.6 , 0.05 , "Add a crime to the suspects record:", true,  guiAddCrimeWindow  )
	
	guiAddTimeLabel =  guiCreateLabel ( 0.05 , 0.08 , 0.3 , 0.05 , "Time of crime:", true,  guiAddCrimeWindow  )
	guiAddTimeEditBox = guiCreateEdit ( 0.3 ,0.08 , 0.3 , 0.05 , realTime.hour..":"..minute , true , guiAddCrimeWindow)
	guiEditSetMaxLength ( guiAddTimeEditBox, 5)
	
	guiAddDateLabel =  guiCreateLabel ( 0.05 , 0.14 , 0.3 , 0.05 , "Date of crime:", true,  guiAddCrimeWindow  )
	guiAddDateEditBox = guiCreateEdit ( 0.3 ,0.14 , 0.3 , 0.05 , realTime.monthday.."/"..(realTime.month+1).."/"..1900+realTime.year , true , guiAddCrimeWindow)
	guiEditSetMaxLength ( guiAddDateEditBox, 10)
	
	guiAddOfficerLabel =  guiCreateLabel ( 0.05 , 0.2 , 0.3 , 0.05 , "Officer(s) involved:", true,  guiAddCrimeWindow  )
	guiAddOfficerEditBox = guiCreateEdit ( 0.05 ,0.25 , 0.9 , 0.05 , "" , true , guiAddCrimeWindow)
	guiEditSetMaxLength ( guiAddOfficerEditBox, 100)
	
	
	guiAddPunishmentLabel =  guiCreateLabel ( 0.05 , 0.32 , 0.4 , 0.05 , "Punishment details:", true,  guiAddCrimeWindow  )
	guiAddTicketCheck = guiCreateCheckBox ( 0.05 , 0.35 , 0.4 , 0.05 , "Ticket Issued?",false , true ,guiAddCrimeWindow )
	guiAddArrestedCheck = guiCreateCheckBox ( 0.4 , 0.35 , 0.4 , 0.05 , "Arrested?",false , true ,guiAddCrimeWindow )
	guiAddFineCheck = guiCreateCheckBox ( 0.73 , 0.35 , 0.4 , 0.05 , "Fined?",false , true ,guiAddCrimeWindow )
	
	guiAddTicketLabel =  guiCreateLabel ( 0.05 , 0.41 , 0.3 , 0.05 , "Ticket price:", true,  guiAddCrimeWindow  )
	guiAddTicketEditBox = guiCreateEdit ( 0.25 ,0.41 , 0.15 , 0.05 , "$xx.xx" , true , guiAddCrimeWindow)
	guiEditSetMaxLength ( guiAddTicketEditBox, 11)
	
	guiAddArrestTimeLabel =  guiCreateLabel ( 0.05 , 0.48 , 0.3 , 0.05 , "Arrest time:", true,  guiAddCrimeWindow  )
	guiAddArrestTimeBox = guiCreateEdit ( 0.25 ,0.48 , 0.2 , 0.05 , "x minutes" , true , guiAddCrimeWindow)
	guiEditSetMaxLength ( guiAddArrestTimeBox, 15)
	
	guiAddFineLabel =  guiCreateLabel ( 0.5 , 0.48, 0.3 , 0.05 , "Arrest fine:", true,  guiAddCrimeWindow  )
	guiAddFineEditBox = guiCreateEdit ( 0.68 ,0.48 , 0.15 , 0.05 , "$xx.xx" , true , guiAddCrimeWindow)
	guiEditSetMaxLength (guiAddFineEditBox, 11)
	
	guiAddIllegalItemsLabel =  guiCreateLabel ( 0.05 , 0.55, 0.7 , 0.05 , "Was the suspect carrying any illegal items?", true,  guiAddCrimeWindow  )
	guiAddIllegalItemsMemo = guiCreateEdit ( 0.05 , 0.58, 0.9 , 0.05 , "Include details of all illegal items here...",true ,  guiAddCrimeWindow )
	guiEditSetMaxLength (guiAddIllegalItemsMemo, 150)
	
	guiAddCrimeDetailsLabel =  guiCreateLabel ( 0.05 , 0.65, 0.7 , 0.05 , "Details of crime:", true,  guiAddCrimeWindow  )
	guiAddCrimeDetailsWarningLabel =  guiCreateLabel ( 0.3 , 0.65, 0.7 , 0.05 , "350 characters remaining.", true,  guiAddCrimeWindow  )
	guiLabelSetColor ( guiAddCrimeDetailsWarningLabel, 0, 255, 0)
	guiAddCrimeDetailsMemo = guiCreateMemo ( 0.05 , 0.68, 0.9 , 0.2 , "Include all details of the crime - where, when, how, what, who etc.",true ,  guiAddCrimeWindow )
		
	guiAddCrimeSubmitButton = guiCreateButton ( 0.2 , 0.9 , 0.2 , 0.05 , "Submit" , true ,guiAddCrimeWindow )
	guiAddCrimeBackButton = guiCreateButton ( 0.6 , 0.9 , 0.2 , 0.05 , "Back" , true , guiAddCrimeWindow  )
	
	guiSetVisible(guiAddCrimeWindow, false)
	
	addEventHandler ( "onClientGUIClick", guiAddCrimeBackButton,  function(button, state)
		if(button == "left") then
			guiSetVisible(guiAddCrimeWindow, false)
		end
	end, false)

	
	addEventHandler ( "onClientGUIClick", guiAddCrimeSubmitButton,  function()
	
		local crimeDetails = {}
		
		local crimeTime = guiGetText(guiAddTimeEditBox)
		local crimeDate = guiGetText(guiAddDateEditBox)
		local officers = guiGetText(guiAddOfficerEditBox)
		
		local ticket
		local arrest
		local fined
		
		if(guiCheckBoxGetSelected ( guiAddTicketCheck)) then
			ticket = 1
		else
			ticket = 0
		end
		
		if(guiCheckBoxGetSelected ( guiAddArrestedCheck)) then
			arrest = 1
		else
			arrest = 0
		end
		
		if(guiCheckBoxGetSelected ( guiAddFineCheck)) then
			fined = 1
		else
			fined = 0
		end
		
		local ticketPrice = guiGetText(guiAddTicketEditBox)
		local arrestTime = guiGetText(guiAddArrestTimeBox)
		local finePrice = guiGetText(guiAddFineEditBox)
		
		local illegalItems = guiGetText(guiAddIllegalItemsMemo)
		local details = guiGetText(guiAddCrimeDetailsMemo)
		
		local done_by = user[1]
		
		crimeDetails = {suspectDetails[1], crimeTime, crimeDate, officers, tonumber(ticket), tonumber(arrest), tonumber(fined), ticketPrice, arrestTime, finePrice, illegalItems, details, done_by}
	
		guiSetVisible(guiAddCrimeWindow, false)
			
		if(triggerServerEvent("onSaveSuspectCrime", getLocalPlayer(), crimeDetails)) then
				
			if (guiPhotoImage) then
				destroyElement(guiPhotoImage)
			end
		
			guiSetInputEnabled(false)
			guiSetText(guiMdcMemo, "~~~ Adding the crime to "..suspectDetails[1].."'s permanent record. ~~~ \n\nThis may take up to 10 seconds to process - Please Wait.")
		
			setTimer(function ()
				-- get the suspect details
				triggerServerEvent("onGetSuspectCrimes", getLocalPlayer(), suspectDetails[1])
		
				setTimer(function()
					-- delete the window, then create a new one
					hideMdc("left", "up")
					createMdcWindow(suspectDetails[1])
					guiSetVisible(guiMdcWindow, true)
					guiSetInputEnabled(true)
				end, 2500 , 1)
			
			end, 2500, 1)
		
		
		end
		
	
	end, false)
	
	-- check to see if the limit of the edit box is too much
	addEventHandler("onClientGUIChanged", guiAddCrimeDetailsMemo, function(element) 
		local text = guiGetText(element)
		
		if(string.len (text) > 350) then
			guiSetText(guiAddCrimeDetailsWarningLabel, "Too many characters in details window")
			guiLabelSetColor ( guiAddCrimeDetailsWarningLabel, 255, 0, 0)
		else
			guiSetText(guiAddCrimeDetailsWarningLabel, (350 - string.len(text)).." characters remaining")
			guiLabelSetColor ( guiAddCrimeDetailsWarningLabel, 0, 255, 0)
		end
	end)
	
	
end






function createDetailsWindow(details)

	-- toggle controls so you can't walk around
	toggleAllControls ( false , true, false)
triggerEvent("onClientPlayerWeaponCheck", localPlayer)
	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 300
	local Height = 400
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2

	guiDetailsWindow = guiCreateWindow ( X , Y , Width , Height , "Personnel Details" , false )
	
	guiDetailsIntroLabel =  guiCreateLabel ( 0.05 , 0.05 , 0.9 , 0.05 , "Personnel details for the suspect", true,  guiDetailsWindow )
	
	guiDetailsNameLabel =  guiCreateLabel ( 0.05 , 0.1 , 0.15 , 0.05 , "Name:", true,  guiDetailsWindow )
	guiDetailsNameEditBox = guiCreateEdit ( 0.2  ,0.1 , 0.7 , 0.05 , "Firstname_Lastname" , true , guiDetailsWindow)
	guiEditSetMaxLength (guiDetailsNameEditBox, 20 )
	
	guiDetailsBirthLabel =  guiCreateLabel ( 0.05 , 0.18 , 0.3 , 0.05 , "Date of birth:", true,  guiDetailsWindow )
	guiDetailsBirthEditBox = guiCreateEdit ( 0.3  ,0.18 , 0.6 , 0.05 , "DD/MM/YYYY" , true , guiDetailsWindow)
	guiEditSetMaxLength (guiDetailsBirthEditBox, 10 )
	
	guiDetailsMaleRadio = guiCreateRadioButton ( 0.15 , 0.24, 0.3 , 0.05 , "Male", true,guiDetailsWindow)
	guiDetailsFemaleRadio = guiCreateRadioButton ( 0.5 , 0.24, 0.4 , 0.05 , "Female", true,guiDetailsWindow)
	
	guiDetailsEthnicyLabel =  guiCreateLabel ( 0.05 , 0.3 , 0.3 , 0.05 , "Ethnicity:", true,  guiDetailsWindow )
	guiDetailsEthnicyEditBox = guiCreateEdit ( 0.2  ,0.3 , 0.7 , 0.05 , "" , true , guiDetailsWindow)
	guiEditSetMaxLength (guiDetailsEthnicyEditBox, 20 )
	
	guiDetailsCellLabel =  guiCreateLabel ( 0.05 , 0.37 , 0.4 , 0.05 , "Cellphone number:", true,  guiDetailsWindow )
	guiDetailsCellEditBox = guiCreateEdit ( 0.4  ,0.37 , 0.5 , 0.05 , "" , true , guiDetailsWindow)
	guiEditSetMaxLength (guiDetailsCellEditBox, 20 )
	
	guiDetailsOccupationLabel =  guiCreateLabel ( 0.05 , 0.44 , 0.4 , 0.05 , "Occupation:", true,  guiDetailsWindow )
	guiDetailsOccupationEditBox = guiCreateEdit ( 0.3  ,0.44 , 0.6 , 0.05 , "" , true , guiDetailsWindow)
	guiEditSetMaxLength (guiDetailsOccupationEditBox, 20 )
	
	guiDetailsAddressLabel =  guiCreateLabel ( 0.05 , 0.5 , 0.4 , 0.05 , "Address:", true,  guiDetailsWindow )
	guiDetailsAddressMemo = guiCreateMemo ( 0.05 , 0.54, 0.85 , 0.15 , "",true ,  guiDetailsWindow )
	
	guiDetailsOtherLabel =  guiCreateLabel ( 0.05 , 0.7 , 0.4 , 0.05 , "Other details:", true,  guiDetailsWindow )
	guiDetailsOtherMemo = guiCreateMemo ( 0.05 , 0.75, 0.85 , 0.1 , "Clothes, facial features, etc.",true ,  guiDetailsWindow )
	
	guiAddBackButton = guiCreateButton ( 0.6 , 0.92 , 0.2 , 0.05 , "Back" , true , guiDetailsWindow )
	
	if(details == nil) then
		guiAddDetailsSubmitButton = guiCreateButton ( 0.2 , 0.92 , 0.2 , 0.05 , "Submit" , true ,guiDetailsWindow )
		guiDetailsPhotoRadio = guiCreateRadioButton(0.3, 0.85, 0.5, 0.05, "Attach Photo", true, guiDetailsWindow)
	else
		guiAddUpdateButton = guiCreateButton ( 0.2 , 0.92 , 0.2 , 0.05 , "Update" , true ,guiDetailsWindow )
		guiDetailsUpdatePhotoRadio = guiCreateRadioButton(0.3, 0.85, 0.5, 0.05, "Update Photo", true, guiDetailsWindow)
	end
	
	if(details) then
		guiSetText(guiDetailsNameEditBox, ""..details[1])
		guiSetText(guiDetailsBirthEditBox, ""..details[2])
		
		if(details[3] == "Female") then
			guiRadioButtonSetSelected (guiDetailsFemaleRadio, true)
		else
			guiRadioButtonSetSelected (guiDetailsMaleRadio, true)
		end
		
		
		guiSetText(guiDetailsEthnicyEditBox, ""..details[4])
		guiSetText(guiDetailsCellEditBox, ""..details[5])
		guiSetText(guiDetailsOccupationEditBox, ""..details[6])
		guiSetText(guiDetailsAddressMemo, ""..details[7])
		guiSetText(guiDetailsOtherMemo, ""..details[8])
		
		guiEditSetReadOnly ( guiDetailsNameEditBox,true )

	end
	
	guiSetVisible(guiDetailsWindow, false)
	
	
	addEventHandler ( "onClientGUIClick", guiAddBackButton,  hideSuspectShow, false)
	
	-- if the player clicked on submit, get all the info and put it in a table, to pass to the server later, to add to the SQL database
	addEventHandler ( "onClientGUIClick", guiAddDetailsSubmitButton,  function()
	
		-- get all of the text box values
		local name = guiGetText(guiDetailsNameEditBox)
		local birth = guiGetText(guiDetailsBirthEditBox)
		
		local gender
		if(guiRadioButtonGetSelected( guiDetailsFemaleRadio )) then
			gender = "Female"
		else
			gender = "Male"
		end
		
		local ethnicy = guiGetText(guiDetailsEthnicyEditBox)
		local cell = guiGetText(guiDetailsCellEditBox)
		local occupation = guiGetText(guiDetailsOccupationEditBox)
		local address = guiGetText(guiDetailsAddressMemo)
		local other = guiGetText(guiDetailsOtherMemo)
		
		local photo
		if(guiRadioButtonGetSelected( guiDetailsPhotoRadio )) then
			photo = true
		else
			photo = false
		end
		
		local done_by = user[1]
		
		local details = {name, birth, gender, ethnicy, cell, occupation, address, other, photo, done_by}
		
		-- if added to the database sucessfully
		if(triggerServerEvent("onAddNewSuspect", getLocalPlayer(), details ) ) then
			
			suspectCrime = nil
			
			if (guiPhotoImage) then
				destroyElement(guiPhotoImage)
			end
		
			guiSetInputEnabled(false)
			guiSetText(guiMdcMemo, " ~~~ Checking the database for "..name.." and adding a new suspect if they do not exist. ~~~\n\nThis may take up to 10 seconds to process - Please Wait.")
		
			setTimer(function ()
				-- get the suspect details
				triggerServerEvent("onGetSuspectDetails", getLocalPlayer(), name)
		
				setTimer(function()
					-- delete the window, then create a new one
					hideMdc("left", "up")
					createMdcWindow(suspectDetails[1])
					guiSetVisible(guiMdcWindow, true)
					guiSetInputEnabled(true)
				end, 2500 , 1)
			
			end, 2500, 1)
		end
		hideSuspectShow("left", "down", name)

	
	end, false)
	
	addEventHandler ("onClientGUIClick", guiAddUpdateButton,  function (button, state)
		
		if(button == "left") then
			-- get all of the text box values
			local name = guiGetText(guiDetailsNameEditBox)
			local birth = guiGetText(guiDetailsBirthEditBox)
			
			local gender
			if(guiRadioButtonGetSelected( guiDetailsFemaleRadio )) then
				gender = "Female"
			else
				gender = "Male"
			end
			
			local ethnicy = guiGetText(guiDetailsEthnicyEditBox)
			local cell = guiGetText(guiDetailsCellEditBox)
			local occupation = guiGetText(guiDetailsOccupationEditBox)
			local address = guiGetText(guiDetailsAddressMemo)
			local other = guiGetText(guiDetailsOtherMemo)
			
			local photo
			if(guiRadioButtonGetSelected( guiDetailsUpdatePhotoRadio )) then
				photo = true
			else
				photo = false
			end
			
			local done_by = user[1]
			
			local details = {name, birth, gender, ethnicy, cell, occupation, address, other, photo, done_by}
			
			if(triggerServerEvent("onUpdateSuspectDetails", getLocalPlayer(), details ) ) then
			
				if (guiPhotoImage) then
					destroyElement(guiPhotoImage)
				end
			
				guiSetInputEnabled(false)
				guiSetText(guiMdcMemo, " ~~~ Updating the records for "..name..". ~~~\n\nThis may take up to 10 seconds to process - Please Wait.")
			
				setTimer(function ()
					-- get the suspect details
					triggerServerEvent("onGetSuspectDetails", getLocalPlayer(), name)
					--triggerServerEvent("onGetSuspectCrimes", getLocalPlayer(), suspectName)

			
					setTimer(function()
						-- delete the window, then create a new one
						hideMdc("left", "up")
						createMdcWindow(suspectDetails[1])
						guiSetVisible(guiMdcWindow, true)
						guiSetInputEnabled(true)
					end, 2500 , 1)
				
				end, 2500, 1)
				
			end
			
			hideSuspectShow("left", "down", name)
			
		end
	
	end, false)
end


function createWarrantWindow()

	-- toggle controls so you can't walk around
	toggleAllControls ( false , true, false)
triggerEvent("onClientPlayerWeaponCheck", localPlayer)
	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 400
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2

	guiWarrantWindow = guiCreateWindow ( X , Y , Width , Height , "Warrant details for "..suspectDetails[1] , false )
		

	
	if(suspectDetails[9] == "1") then
		guiWarrant1Label = guiCreateLabel ( 0.05 ,0.1, 0.95, 0.1 , "Warrant "..suspectDetails[12], true , guiWarrantWindow )
		guiLabelSetColor ( guiWarrant1Label, 0, 255, 0 )
	else
		guiWarrantLabel = guiCreateLabel ( 0.05 ,0.1, 0.95, 0.1 , "No warrant has been issued", true , guiWarrantWindow )
		guiLabelSetColor ( guiWarrantLabel, 255, 0, 0)
	end
	
	guiWarrantReasonLabel = guiCreateLabel ( 0.05 ,0.2, 0.95, 0.1 , "Warrant details:", true , guiWarrantWindow )
	guiWarrantReasonText = guiCreateEdit ( 0.05 , 0.3 , 0.9, 0.15, suspectDetails[10] , true , guiWarrantWindow)
	guiEditSetMaxLength ( guiWarrantReasonText, 100)
	
	guiWarrantPunishmentLabel =  guiCreateLabel ( 0.05 ,0.5, 0.95, 0.1 , "Suggested punishment:", true , guiWarrantWindow )
	guiWarrantPunishmentText = guiCreateEdit ( 0.05 , 0.6 , 0.9, 0.15, suspectDetails[11] , true , guiWarrantWindow)
	guiEditSetMaxLength ( guiWarrantPunishmentText, 100)
	
	
	-- TEST TO SEE IF PLAYER IS IN HIGH COMMAND, IF SO, SHOW THEM UPDATE AND REMOVE BUTTONS
	if(user[3] == "1") then
		guiWarrantUpdateButton = guiCreateButton ( 0.15 , 0.85 , 0.2 , 0.1 , "Update", true , guiWarrantWindow )
		guiWarrantRemoveButton = guiCreateButton ( 0.4 , 0.85 , 0.2 , 0.1 , "Remove", true , guiWarrantWindow )
		guiWarrantBackButton = guiCreateButton ( 0.65, 0.85 , 0.2 , 0.1 , "Back", true , guiWarrantWindow )
		
			addEventHandler ( "onClientGUIClick", guiWarrantRemoveButton,  function(button, state)
		
				if(button == "left") then
					local warrantDetails = {suspectDetails[1], 0, "No details given", "No punishment required", "None"}
					triggerServerEvent("onUpdateSuspectWarrantDetails", getLocalPlayer(), warrantDetails)
					
					if (guiPhotoImage) then
						destroyElement(guiPhotoImage)
					end
					guiSetVisible(guiWarrantWindow, false)
						
					guiSetInputEnabled(false)
					guiSetText(guiMdcMemo, " ~~~ Removing "..suspectDetails[1].."'s warrant details ~~~\n\nThis may take up to 5 seconds to process - Please Wait.")
				
					setTimer(function ()
						-- get the suspect details
						triggerServerEvent("onGetSuspectDetails", getLocalPlayer(), suspectDetails[1])
				
						setTimer(function()
							-- delete the window, then create a new one
							hideMdc("left", "up")
							createMdcWindow(suspectDetails[1])
							guiSetVisible(guiMdcWindow, true)
							guiSetInputEnabled(true)
						end, 2500 , 1)
					
					end, 2500, 1)
				end
			end, false)
			
			
			addEventHandler ( "onClientGUIClick", guiWarrantUpdateButton,  function(button, state)
				
				if(button == "left") then
				
					local hour, minute = getTime()
					local realtime = getRealTime()
					
	
					if(minute<10) then
						minute = "0"..tostring(minute)
					end
				
					local warrantDetails = {suspectDetails[1], 1 , guiGetText(guiWarrantReasonText) , guiGetText(guiWarrantPunishmentText) , "issued by "..user[1].." on "..realtime.monthday.."/"..(realtime.month+1).."/"..(realtime.year+1900).." at "..realtime.hour..":"..minute }
					
					triggerServerEvent("onUpdateSuspectWarrantDetails", getLocalPlayer(), warrantDetails)
					
					if (guiPhotoImage) then
						destroyElement(guiPhotoImage)
					end
					guiSetVisible(guiWarrantWindow, false)
						
					guiSetInputEnabled(false)
					guiSetText(guiMdcMemo, " ~~~ Updating "..suspectDetails[1].."'s warrant details ~~~\n\nThis may take up to 5 seconds to process - Please Wait.")
				
					setTimer(function ()
						-- get the suspect details
						triggerServerEvent("onGetSuspectDetails", getLocalPlayer(), suspectDetails[1])
				
						setTimer(function()
							-- delete the window, then create a new one
							hideMdc("left", "up")
							createMdcWindow(suspectDetails[1])
							guiSetVisible(guiMdcWindow, true)
							guiSetInputEnabled(true)
						end, 2500 , 1)
					
					end, 2500, 1)
				end
			end, false)
			
		
	else -- PLAYER IS NOT IN HIGH COMMAND, ONLY MAKE THE BACK BUTTON
		guiWarrantBackButton  = guiCreateButton ( 0.4, 0.85 , 0.2 , 0.1 , "Back", true , guiWarrantWindow )
		guiEditSetReadOnly ( guiWarrantReasonText, true )
		guiEditSetReadOnly ( guiWarrantPunishmentText, true)
	end
	
	guiSetVisible(guiWarrantWindow, false)
	
	addEventHandler ( "onClientGUIClick", guiWarrantBackButton,  function(button, state)
		
		if(button == "left") then
			guiSetVisible(guiWarrantWindow, false)
		end
	end, false)

	
	
end


-- GUI WINDOW FOR THE ACCOUNT MANAGEMENT --
function createAccountWindow()

	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 200
	local Height = 330
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2

	guiAccountWindow = guiCreateWindow ( X , Y , Width , Height , "Account Details", false )

	guiAccountExistingPass  = guiCreateLabel(0.05, 0.1, 0.9, 0.1, "Current Password:", true, guiAccountWindow)
	guiAccountExistingPassEdit = guiCreateEdit(0.05, 0.15, 0.9, 0.1, "", true, guiAccountWindow)
	guiAccountNewPass  = guiCreateLabel(0.05, 0.25, 0.9, 0.1, "New Password:", true, guiAccountWindow)
	guiAccountNewPassEdit = guiCreateEdit(0.05, 0.3, 0.9, 0.1, "", true, guiAccountWindow)
	guiAccountUser  = guiCreateLabel(0.05, 0.4, 0.9, 0.1, "User Name:", true, guiAccountWindow)
	guiAccountUserEdit = guiCreateEdit(0.05, 0.45, 0.9, 0.1, user[1], true, guiAccountWindow)
	
	guiEditSetMasked ( guiAccountExistingPassEdit , true )
	guiEditSetMasked ( guiAccountNewPassEdit, true )
	
	guiEditSetMaxLength (guiAccountExistingPassEdit, 20 )
	guiEditSetMaxLength (guiAccountNewPassEdit, 20 )
	guiEditSetMaxLength (guiAccountUserEdit, 20 )

	-- if user is in high command, give them create, remove, update and back buttons
	if(user[3] == "1") then
	
		guiAccountHighCheck = guiCreateCheckBox ( 0.05 , 0.55, 0.9, 0.1 , "Full Access" , false , true , guiAccountWindow)
	
		guiAccountCreateButton = guiCreateButton(0.05, 0.65, 0.4, 0.1, "Create", true, guiAccountWindow)
		guiAccountUpdateButton = guiCreateButton(0.55, 0.65, 0.4, 0.1, "Update", true, guiAccountWindow)
		guiAccountRemoveButton = guiCreateButton(0.05, 0.77, 0.4, 0.1, "Remove", true, guiAccountWindow)
		guiAccountBackButton = guiCreateButton(0.55, 0.77, 0.4, 0.1, "Back", true, guiAccountWindow)
		guiAccountShowAllButton = guiCreateButton(0.05, 0.89, 0.9, 0.1, "Show all accounts", true, guiAccountWindow)
	
	
	else -- just update and back
	
		guiAccountUpdateButton = guiCreateButton(0.3, 0.7, 0.4, 0.1, "Update", true, guiAccountWindow)
		guiAccountBackButton = guiCreateButton(0.3, 0.85, 0.4, 0.1, "Back", true, guiAccountWindow)
		guiEditSetReadOnly (guiAccountUserEdit, true )
		
	end
	
	-- If back button is pressed, set the window hidden
	addEventHandler ( "onClientGUIClick", guiAccountBackButton,  function(button, state)
		
		if(button == "left") then
			guiSetVisible(guiAccountWindow, false)
		end
	end, false)
	
	-- If update button is triggered, trigger a server event to update the account
	addEventHandler ( "onClientGUIClick", guiAccountUpdateButton,  function(button, state)
		if(button == "left") then
		
			local NewUser = user[1]
			local NewPass = guiGetText(guiAccountNewPassEdit)
			local OldPass = guiGetText(guiAccountExistingPassEdit )
			
			if(NewPass == "") then NewPass = OldPass end 
			
			if(guiCheckBoxGetSelected ( guiAccountHighCheck ))then
				HighCommand = "1"
			else
				HighCommand = "0"
			end
			
			if(user[3] == "1") then
				HighCommand = "1"
			end
			
			local details = {NewUser, NewPass, HighCommand}
			
			guiSetVisible(guiAccountWindow, false)
			
			if(checkPassword(OldPass)) then
				-- if added to the database sucessfully
				if(triggerServerEvent("onUpdateAccount", getLocalPlayer(), details ) ) then
					if (guiPhotoImage) then
						destroyElement(guiPhotoImage)
					end
					
					guiSetInputEnabled(false)
					guiSetText(guiMdcMemo, " ~~~ Updating "..NewUser.."''s account. ~~~\n\nThis may take up to 5 seconds to process - Please Wait.")
					
					setTimer(function()
						-- delete the window, then create a new one
						hideMdc("left", "up")
						createMdcWindow(suspectDetails[1])
						guiSetVisible(guiMdcWindow, true)
						guiSetInputEnabled(true)
					end, 2500 , 1)
				end
				
				triggerServerEvent("onGetAccountInfo", getLocalPlayer(), user[1])
				
			else
				guiSetText(guiMdcMemo, "Unable to update the account information\n\nThe existing password you gave does not match the current password for your account.")
				
			end
			
			guiSetVisible(guiAccountWindow, false)
		end
	end, false)
	
	
	
	
	
	-- If create button is triggered, trigger a server event to update the account
	addEventHandler ( "onClientGUIClick", guiAccountCreateButton,  function(button, state)
		if(button == "left") then
		
			local NewUser = guiGetText(guiAccountUserEdit )
			local NewPass = guiGetText(guiAccountNewPassEdit)
			local OldPass = guiGetText(guiAccountExistingPassEdit )
			
			if(NewPass == "") then NewPass = NewUser end 
			
			if(guiCheckBoxGetSelected ( guiAccountHighCheck ))then
				HighCommand = "1"
			else
				HighCommand = "0"
			end
			
			local details = {NewUser, NewPass, HighCommand}
			
			guiSetVisible(guiAccountWindow, false)
			
			-- if the existing password is the same
			if(checkPassword(OldPass)) then
			
				-- if added to the database sucessfully
				if(triggerServerEvent("onCreateAccount", getLocalPlayer(), details ) ) then
					if (guiPhotoImage) then
						destroyElement(guiPhotoImage)
					end
				
					guiSetInputEnabled(false)
					guiSetText(guiMdcMemo, " ~~~ Creating "..NewUser.."''s account if it does not already exist. ~~~\n\nThis may take up to 5 seconds to process - Please Wait.")
					
					
					setTimer(function()
						-- delete the window, then create a new one
						hideMdc("left", "up")
						createMdcWindow(suspectDetails[1])
						guiSetVisible(guiMdcWindow, true)
						guiSetInputEnabled(true)
					end, 2500 , 1)
				end
			else
				guiSetText(guiMdcMemo, "Unable to add new account to the database.\
				\
				 The existing password you gave does not match the current password for your account.")
				
			end
			
			guiSetVisible(guiAccountWindow, false)
		end
	end, false)
	
	
	-- If remove button is triggered, trigger a server event to remove the account
	addEventHandler ( "onClientGUIClick", guiAccountRemoveButton,  function(button, state)
		if(button == "left") then
		
			local NewUser = guiGetText(guiAccountUserEdit )
			local OldPass = guiGetText(guiAccountExistingPassEdit )
			
			local details = {NewUser}
			
			guiSetVisible(guiAccountWindow, false)
			
			-- if the existing password is the same
			if(checkPassword(OldPass)) then
				if not (user[1] == NewUser) then
					-- if added to the database sucessfully
					if(triggerServerEvent("onRemoveAccount", getLocalPlayer(), details ) ) then
						if (guiPhotoImage) then
							destroyElement(guiPhotoImage)
						end
					
						guiSetInputEnabled(false)
						guiSetText(guiMdcMemo, " ~~~ Deleting "..NewUser.."''s account if it exist. ~~~ \n\nThis may take up to 5 seconds to process - Please Wait.")
						
						
						setTimer(function()
							-- delete the window, then create a new one
							hideMdc("left", "up")
							createMdcWindow(suspectDetails[1])
							guiSetVisible(guiMdcWindow, true)
							guiSetInputEnabled(true)
						end, 2500 , 1)
					end
				else
					guiSetText(guiMdcMemo, "Unable to remove account from the database.\
					\
					You cannot delete your own account.")
				end
			else
				guiSetText(guiMdcMemo, "Unable to add remove account from the database.\
				\
				 The existing password you gave does not match the current password for your account.")
				
			end
			
			guiSetVisible(guiAccountWindow, false)
		end
	end, false)
	
	
		-- If show al accounts buttons is triggered, do the following
	addEventHandler ( "onClientGUIClick", guiAccountShowAllButton,  function(button, state)
		if(button == "left") then
		
			-- hide the window
			guiSetVisible(guiAccountWindow, false)
			

			-- trigger server to send the client all of the accounts
			if(triggerServerEvent("onGetAllAccounts", getLocalPlayer(), details ) ) then
				
				-- destroy the photo if it exists
				if (guiPhotoImage) then
					destroyElement(guiPhotoImage)
				end
				
				guiSetInputEnabled(false)
				guiSetText(guiMdcMemo, " ~~~ Loading all of the active accounts. ~~~ \
				\
				\This may take up to 5 seconds to process - Please Wait.")
				
						
				setTimer(function()
					guiSetText(guiMdcMemo, getShowAllAccountsText())
					guiSetInputEnabled(true)
				end, 2500 , 1)
			end
			guiSetVisible(guiAccountWindow, false)
		end
	end, false)
	

	
	guiSetVisibile(guiAccountWindow, false)

end

-- function gets the text to show all of the accounts
function getShowAllAccountsText()


	local text
	
	text = "--- Account Name -------- Full Access ---\n"
	
	local tempaccount
	
	for i, j in pairs(accounts) do
			
		local full

		if(j[2] == "1") then
			full = "Yes"
		else
			full = "No"
		end
			
		tempaccount = "        "..j[1].."                 "..full.."\n"
				
		text = text..tempaccount
				
	end
	
	return text

end

-- Function sets the warant window visible
function viewWarrantShow()
	
	createWarrantWindow()
	guiSetVisible(guiWarrantWindow, true)

end

-- function is run when user types /mdc
function useMDC(thePlayer, Command)
	local thePlayer = getLocalPlayer()
		
	-- check to make sure that the player is in a car having it.
	if isPedInVehicle(thePlayer) then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		if (getElementData(vehicle, "faction") == 1) or (getElementData(vehicle, "faction") == 87) then
			showLoginWindow()
		elseif(vehicle == 596 or vehicle == 427 or vehicle == 490 or vehicle == 599 or vehicle == 601 or vehicle == 523 or vehicle == 597 or vehicle == 598) then
			showLoginWindow()
		else -- player is not in a police car
			outputChatBox("You need to be in a law enforcement vehicle.", 255, 0 , 0, true)
		end
	else
		outputChatBox("You need to be in a law enforcement vehicle to use the MDC.", 255, 0,0, true)
	end
end
addCommandHandler("mdc", useMDC)

function showMDC()
		-- toggle controls so you can't walk around
		toggleAllControls ( false , true, false)
					triggerEvent("onClientPlayerWeaponCheck", localPlayer)	
		-- create the MDC window
		createMdcWindow(nil)
						
		-- set the MDC window visible
		guiSetVisible(guiMdcWindow, true)
		guiSetInputEnabled(true)
		
		local count = 43
		
		-- set a timer to play a stupid little sound when you load the mdc
		setTimer( function()
			playSoundFrontEnd(count)
			count = count+1
		end ,125, 3 )

end

-- function hides the mdc window
function hideMdc(button, state)
	if(button == "left") then
			guiSetVisible(guiMdcWindow, false)
			guiSetVisible(guiAddCrimeWindow, false)
			guiSetVisible(guiDetailsWindow, false)
			guiSetVisible(guiDeleteCrimeWindow, false)
			guiSetVisible(guiWarrantWindow, false)
			guiSetVisible(guiAccountWindow, false)
						
			guiSetInputEnabled(false)
			toggleAllControls ( true, true, false)
			toggleControl ( "next_weapon", true)
			toggleControl ("previous_weapon", true)
	end
end




-- function shows the add suspectwindow
function addSuspectShow(button, state)
	if(button == "left") then
			if(clearShowWindow()) then
				if not (guiGetVisible(guiDetailsWindow)) then
					-- create the details window, withouth a suspect name
					createDetailsWindow(nil)
					guiSetVisible(guiDetailsWindow, true)
					guiBringToFront ( guiDetailsWindow )
					-- allow the user to input stuff
					guiSetInputEnabled(true)
				end
			end
	end
end

-- function hides the addSuspectShow gui
function hideSuspectShow(button, state)
	if(button == "left") then
			-- hide the mdc window
			guiSetVisible(guiMdcWindow, true)
			guiSetVisible(guiDetailsWindow, false)
			-- allow the user to input stuff
			guiSetInputEnabled(true)
	end
end

-- function shows the add suspectwindow
function addCrimeShow()
	if not (guiGetVisible(guiAddCrimeWindow)) then
		-- create the details window, withouth a suspect name
		createAddCrimeWindow()
		guiSetVisible(guiAddCrimeWindow, true)
		guiBringToFront ( guiAddCrimeWindow )
		-- allow the user to input stuff
		guiSetInputEnabled(true)
	end

end


function showDeleteCrimeWindow()
	if not (guiGetVisible(guiDeleteCrimeWindow))then
		createDeleteCrimeWindow()
		guiSetVisible(guiDeleteCrimeWindow, true)
		guiBringToFront ( guiDeleteCrimeWindow)
		guiSetInputEnabled(true)
	end
end

-- function contacts the server and gets the memo text from the sql database
function getMemoText()
	
	local text
	if savedTypeResult == 1 then
		if (suspectDetails[2] == nil ) then
		
			text = "--------  "..suspectDetails[1]..[[ does not exist in the database.  --------

This may mean that the suspect has not yet comitted any crimes - if so, please click 'Add Suspect' and fill in the personnel information that is required.

If you know that the suspect has comitted crimes before, check to make sure you typed the name out correctly.

~~ Thank you for using the LSMPD Mobile Data Computer ~~]]
			
		else
				
			local warrantText
			
			local intro = 
[[Name: ]]..suspectDetails[1]..[[ 
DOB: ]]..suspectDetails[2]..[[ 
Gender: ]]..suspectDetails[3]..[[ 
Ethnicity: ]]..suspectDetails[4]..[[ 
Occupation: ]]..suspectDetails[6]..[[ 

--- Contact Details ---
Address: ]]..suspectDetails[7]..[[ 
Phone: ]]..suspectDetails[5]..[[ 

-- Other Details --
]]..suspectDetails[8]..[[ 
-- Crimes Comitted--

]]
			
			local quickcrime = ""
			
			--if the suspect has comitted crimes before
			if (suspectCrime) then
			
				for i, j in ipairs(suspectCrime) do
			
					local quickcrimetemp = "["..j[4].."] - "..j[13]..""
					
					quickcrime = quickcrime..quickcrimetemp
			
				end
			else
				quickcrime = "No crimes comitted.\n"
			end
			
			intro = intro..quickcrime
			
			intro = intro.."\n-- Warrant Details --"
			
			if(suspectDetails[9] == "1") then
				warrantText = ("\nWarrant has been "..suspectDetails[12].."\nPlease click on warrant details to view more information.\n")
			else
				warrantText = ("\nThere are no outstanding warrants for this suspect\n")
			end
			
			intro = intro..warrantText

			if(user[3] == "1") then
				--intro = intro.."\
				--Users file was last updated by: "..suspectDetails[14].."\
				--"
			end
			
			local blank = ("\n------------------------------- PREVIOUS CRIMES -------------------------------\n")
			
			local crime = ""
			local tempcrime = ""
			local temppunishment = ""
			
			-- if the suspect has comitted crimes before
			if (suspectCrime) then
			
				for i, j in pairs(suspectCrime) do
				
					tempcrime = "--- Crime comitted on "..j[4].. " at "..j[3]..". Crime ID: "..j[1].." ---\n\nOfficers Involved: "..j[5].."\nIllegal Items: "..j[12].."\n\n-- Details of Crime --\n"..j[13].."\n-- Punishments Given --\n"
					
					local ticket = tonumber(j[6])
					local arrest = tonumber(j[7])
					local fine = tonumber(j[8])
					
					if (ticket == 1) then
						temppunishment = "Suspect was given a ticket, with cost of "..j[9]..".\n"
					end
					
					if(arrest == 1) then
						temppunishment = temppunishment.."Suspect was arrested, with jail time of "..j[10]..".\n"
					end
					
					if(fine == 1) then
						temppunishment = temppunishment.."Suspect was give a fine of "..j[11]..".\n"
					end
					
					local crimeAddedBy
					
					if(user[3] == "1") then
						crimeAddedBy = "\nCrime added by user: "..j[14].."\n"
					end
					
					tempcrime = tempcrime..temppunishment..tostring(crimeAddedBy)
					
					crime = crime..tempcrime.."\n\n\n"
				end
			else
				crime = "\nThis suspect has not been convicted for any previous offences."
			end
			
			text = intro..blank..crime
		end
	elseif savedTypeResult == 2 then
		-- Vehicle system
		if (suspectDetails[2] == nil ) then
			
				text = ("--------  vehicle with plate "..suspectDetails[1].." does not exist in the database.  -------- \
				\
				~~ Thank you for using the LSMPD Mobile Data Computer ~~")
		else
				intro = ("Vehicle name: "..suspectDetails[2].."\nRegistered Owner: "..suspectDetails[3].."\nVehicle colors: "..suspectDetails[4].."\nVehicle plate: "..suspectDetails[5].."\nChassis number: "..suspectDetails[6])
				crime = ""
				
				if (suspectCrime) then
					for i, j in pairs(suspectCrime) do
						tempcrime = ("\n\n--- Crime comitted on "..j[3].. ". Crime ID: "..j[1].." --- \n\nPlate: "..j[2].."\nSpeed: "..j[4].." KPH\nArea: "..j[5].."\n\n-- Person visible ((RP THIS AS A PICTURE)) --\n"..j[6])
						crime = crime..tempcrime
					end

				else
					crime = "\nThis vehicle has not been convicted for any previous offences."
				end
				
				text = intro..crime
			
		end
	end
	return text

end

-- function returns the default memo text on startup
function getDefaultMemoText() 

	local intro
	local warrants = ""
	
	intro = [[------------- CURRENT WARRANTS ISSUED ------------
Warrants have been issued for the arrest of the following people:

]]
	
		
		local count = 1
		
	while (count <= table.getn(suspectWanted)) do
		local wanted = suspectWanted[count]
		
		wanted = "  "..wanted.."\n"
		
		warrants = warrants..wanted

		count = count+1
	end
			
	local outro = ([[------ Welcome to the LSMPD Mobile Data Computer v1.3 ------\

You are logged in under the user name: ]]..user[1]..[[

The MDC system allows officers of the law to create, edit, manage and delete criminal records for any suspect.

To search for a suspects records, enter the suspects name in the box above and click search. All of the suspects criminal records will be shown in this text box. You can also view the suspects personal information, by clicking on the 'View Personal Info' button to the right. Information here can be changed if it needs updating at a later date.

You can only search for suspects that have a record stored on the database. If the search does not return any results then you need to create a new record for that suspect. Simply click on 'Add New Suspect', fill out the information required, and press submit. Now that the suspect has a record, you can add, delete and view any crimes that the suspect has comitted.

Members of the high command can also set warrants on suspects. This will set a message below this introduction to say that a suspect is wanted. For more details on a warrant, search for the suspects name and click 'Warrant Details'. This will tell you why the warrant has been issued, by whome, and what the suggested punishment is.

When you are finished, click 'log off'.

~~ Thank you for using the LSMPD Mobile Data Computer ~~
]])
			
	return intro..warrants..outro
end


function viewSuspectShow()
	if not (guiGetVisible(guiDetailsWindow)) then
		-- create the details window, withouth a suspect name
		createDetailsWindow(suspectDetails)
		guiSetVisible(guiDetailsWindow, true)
		-- allow the user to input stuff
		guiSetInputEnabled(true)
	end
end
addEvent("onShowSuspectDetailsClient", true)
addEventHandler("onShowSuspectDetailsClient", getLocalPlayer() , viewSuspectShow)



function saveSuspectDetails(suspectName, details, typeResult)
	savedTypeResult = typeResult
	if(details) and typeResult == 1 then
		suspectDetails = {details[1][1], details[1][2], details[1][3], details[1][4], details[1][5], details[1][6], details[1][7], details[1][8], details[1][9],details[1][10], details[1][11], details[1][12], details[1][13], details[1][14]}
	elseif(details) and typeResult == 2 then	
		suspectDetails = { suspectName, tostring(details[1][1]), tostring(details[1][2]), tostring(details[1][3]), tostring(details[1][4]), tostring(details[1][5]), details[1][6] }
	else
		suspectDetails = {suspectName, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
	end
		
end
addEvent("onSaveSuspectDetailsClient", true)
addEventHandler("onSaveSuspectDetailsClient", getLocalPlayer() , saveSuspectDetails)



-- saves the suspects wanted in table suspectWanted
function saveSuspectWantedDetails(result)

	if(result)then
			
		local count = 1
		
		for i, j in pairs(result) do
			 for key, value in pairs(result[i]) do
				 suspectWanted[count] = value
				 count = count+1				 
			 end
		end
				
	else
		suspectWanted= {nil}
	end
		
end
addEvent("onSaveSuspectWantedClient", true)
addEventHandler("onSaveSuspectWantedClient", getLocalPlayer() , saveSuspectWantedDetails)


-- saves the suspect crime to the client
function saveSuspectCrimes(result)


	if(result) then
		suspectCrime = result
	else
		suspectCrime= nil
	end


	
end
addEvent("onClientSaveSuspectCrimes", true)
addEventHandler("onClientSaveSuspectCrimes", getRootElement() , saveSuspectCrimes)



 function toggleInputEnabled( key, keyState)
 
	-- check to see if its m and down
	if(key == "left") then
		if(source == guiToggleButton) then
	
			if (guiGetInputEnabled( )) then
				guiSetInputEnabled(false)
				showCursor(false)
				outputChatBox("Chatbox active", 0, 255, 0, true)
				outputChatBox("Press M on the keyboard to toggle back and use the MDC")
			else 
				guiSetInputEnabled(true)
				showCursor(false)
				outputChatBox("MDC window active", 0, 255, 0, true)
			end
		end
	end
 end
 
 
 function toggleInputEnabled2(key, keyState)
 	-- check to see if its m and down
	if(key == "m") then
		if(isElement(guiMdcWindow) and guiGetVisible(guiMdcWindow)) then
			if (guiGetInputEnabled( )) then
				guiSetInputEnabled(false)
				outputChatBox("Chatbox active", 0, 255, 0, true)
				outputChatBox("Press M on the keyboard to toggle back and use the MDC")
			else 
				guiSetInputEnabled(true)
				outputChatBox("MDC window active", 0, 255, 0, true)
			end
		end
	end
end
 bindKey ( "m", "down", toggleInputEnabled2) 
 
 -- on resource stop, set the player back to proper setting
 function onResourceStop()
 
	-- disable input
	if (guiGetInputEnabled( )) then
		guiSetInputEnabled(false)
	end
 
	-- delete any visible GUI windows
	if isElement(guiMdcWindow) then
		guiSetVisible(guiMdcWindow, false)
		guiSetVisible(guiAddCrimeWindow, false)
		guiSetVisible(guiDetailsWindow, false)
		guiSetVisible(guiDeleteCrimeWindow, false)
		guiSetVisible(guiWarrantWindow, false)
	end
	-- toggle the controls back to normal
	toggleAllControls ( true, true, false)
	toggleControl ( "next_weapon", false)
	toggleControl ("previous_weapon", false)
	triggerEvent("onClientPlayerWeaponCheck", localPlayer)
 
end
addEventHandler( "onClientResourceStop", getResourceRootElement( getThisResource( ) ), onResourceStop ) 
  
 -- log in window
 function createLoginWindow()
	
	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 250
	local Height = 150
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	guiLogIn = guiCreateWindow ( X , Y , Width , Height , "Login to the Mobile Data Computer" , false )
	
	guiUserLabel  = guiCreateLabel(0.05, 0.15, 0.9, 0.2, "User name:", true, guiLogIn)
	guiUserNameEdit = guiCreateEdit(0.05, 0.25, 0.9, 0.2, "", true, guiLogIn)
	guiPasswordLabel  = guiCreateLabel(0.05, 0.45, 0.9, 0.2, "Password:", true, guiLogIn)
	guiPasswordEdit = guiCreateEdit(0.05, 0.55, 0.9, 0.2, "", true, guiLogIn)
	guiEditSetMasked ( guiPasswordEdit , true )
	
	guiEditSetMaxLength (guiPasswordEdit, 20 )
	guiEditSetMaxLength (guiUserNameEdit, 20 )
	
	guiLogInSubmitButton = guiCreateButton(0.15, 0.8, 0.3, 0.2, "Log In", true, guiLogIn)
	guiLogInBackButton = guiCreateButton(0.55, 0.8, 0.3, 0.2, "Close", true, guiLogIn)
 
	guiSetVisible(guiLogIn, false)
	
	-- if the player has clicked back, just close the windows
	addEventHandler ( "onClientGUIClick", guiLogInBackButton,  function(button, state)
		if(button == "left") then
			guiSetVisible(guiLogIn, false)
			guiSetInputEnabled ( false)
		end
	end, false)
	
	-- if the player has clicked log in, get the name and password details, and send it to the server
	addEventHandler ( "onClientGUIClick", guiLogInSubmitButton,  function(button, state)
		if(button == "left") then
			if not pendingLogin then
			
				pendingLogin = true
				-- get the log in details from the boxes
				local logInDetails = { guiGetText(guiUserNameEdit),  guiGetText(guiPasswordEdit)}
				
				-- trigger server event
				triggerServerEvent("onClientLogInToMDC", getLocalPlayer(), logInDetails)
			end
		end
	end, false)
	
end
 
 -- function shows the log in window to the player
 function showLoginWindow()
	
	createLoginWindow()
	guiSetVisible(guiLogIn, true)
	guiSetInputEnabled ( true )
	 
 end
 
 
  -- function is run when the correct log in details are given, it saves the user details and shows the mdc window
function falseLogIn(result)
	pendingLogin = false
	outputChatBox("Invalid username or password specified.", 255, 0, 0, true)
end
addEvent("onFalseLogInDetails", true)
addEventHandler("onFalseLogInDetails", getLocalPlayer() ,   falseLogIn)
 
 -- function is run when the correct log in details are given, it saves the user details and shows the mdc window
function correctLogIn(result)
	pendingLogin = false
	-- hide the log in window
	guiSetVisible(guiLogIn, false)

	-- save the users details to the client
	user = {tostring(result[1][1]), tostring(result[1][2]), tostring(result[1][3])}
	
	setTimer( showMDC, 2500, 1)
	
	outputChatBox("Logging into Mobile Data Computer with user "..result[1][1]..".", 0, 255, 0, true)
	outputChatBox("~~~ Loading the MDC, please wait ~~~")
	
	-- get all the current wanted suspects
	triggerServerEvent("onGetWantedSuspects", getLocalPlayer())
	triggerServerEvent("onGetAccountInfo", getLocalPlayer(), user[1])

end
addEvent("onCorrectLogInDetails", true)
addEventHandler("onCorrectLogInDetails", getLocalPlayer() ,   correctLogIn)

 
 -- function returns true if any other window is showing
 function clearShowWindow()
 
	if(guiGetVisible(guiDeleteCrimeWindow) or
	guiGetVisible(guiAddCrimeWindow) or
	guiGetVisible(guiDetailsWindow) or
	guiGetVisible(guiWarrantWindow) or
	guiGetVisible(guiDeleteSuspectWindow) or
	guiGetVisible(guiAccountWindow)) then
		return false
	else
		return true
	end
 
 end
 
 -- function saves the user account details
 function getUserDetails(details)
 
	user[1] = details[1][1]
	user[2] = details[1][2]
	user[3] = details[1][3]
	
 end
 addEvent("onSaveUserAccountDetails", true)
 addEventHandler("onSaveUserAccountDetails", getLocalPlayer() ,   getUserDetails)
 
 
  -- function saves the all of the user accounts
 function saveAllAccountsInfo(result)
	if(result) then
		accounts= result
	else
		accounts = {}
	end

 end
 addEvent("onSaveAllAccounts", true)
 addEventHandler( "onSaveAllAccounts", getLocalPlayer() ,   saveAllAccountsInfo)
 
 -- function saves the all of the user accounts
 function saveAllSuspects(result)
	
	if(result) then
		allSuspects = result
	else
		allSuspect = {}
	end
 end
 addEvent("onSaveAllSuspects", true)
 addEventHandler( "onSaveAllSuspects", getLocalPlayer() ,   saveAllSuspects)

 
 -- function checks the password against the encripted password and returns true if success
 function checkPassword(Password)
	
	local accountName = user[1]
	
	if (Password == user[2]) then
		return true
	else
		return false
	end
 
 end