wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp, wHelp, lNameCheck, lLengthCheck, bSubmitReport, lPlayerName, reportedPlayer, tPlayerName, lReport, tReport, tHelpMessage,bGMHelp = nil

function resourceStop()
	guiSetInputEnabled(false)
	showCursor(false)
end
addEventHandler("onClientResourceStop", getResourceRootElement(), resourceStop)

function resourceStart()
	bindKey("F2", "down", toggleReport)
end
addEventHandler("onClientResourceStart", getResourceRootElement(), resourceStart)

function toggleReport()
	executeCommandHandler("report")
end

function checkBinds()
	if ( exports.global:isPlayerAdmin(getLocalPlayer()) or getElementData( getLocalPlayer(), "account:gmlevel" )  ) then
		if getBoundKeys("ar") or getBoundKeys("acceptreport") then
			--outputChatBox("You had keys bound to accept reports. Please delete these binds.", 255, 0, 0)
			triggerServerEvent("arBind", getLocalPlayer())
		end
	end
end
setTimer(checkBinds, 60000, 0)

local function scale(w)
	local width, height = guiGetSize(w, false)
	local screenx, screeny = guiGetScreenSize()
	local minwidth = math.min(700, screenx)
	if width < minwidth then
		guiSetSize(w, minwidth, height / width * minwidth, false)
		local width, height = guiGetSize(w, false)
		guiSetPosition(w, (screenx - width) / 2, (screeny - height) / 2, false)
	end
end

function showReportMainUI()
	local logged = getElementData(getLocalPlayer(), "loggedin")
	if (logged==1) then
		if (wReportMain==nil) and (wHelp==nil) then
			reportedPlayer = nil
			wReportMain = guiCreateWindow(0.2, 0.2, 0.6, 0.6, "Report System", true)
			scale(wReportMain)
			
			-- Controls within the window
			bClose = guiCreateButton(0.775, 0.05, 0.2, 0.05, "Close", true, wReportMain)
			addEventHandler("onClientGUIClick", bClose, clickCloseButton)
			
			lWelcome = guiCreateLabel(0.025, 0.1, 1.0, 0.3, "Welcome to the Report System.\n\n This system should provide you with a live assistant to chat to when and where you need it\nwhether its for a general roleplay enquiry, or you wish to report a hacker.", true, wReportMain)
			guiSetFont(lWelcome, "default-bold-small")
			guiLabelSetHorizontalAlign(lWelcome, "center", true)
			
			-- Admin help related
			pHelp = guiCreateStaticImage(0.075, 0.28, 0.04, 0.05, "help.png", true, wReportMain)
			lHelp = guiCreateLabel(0.15, 0.285, 1.0, 0.1, "Request Administrator Help", true, wReportMain)
			guiSetFont(lHelp, "default-bold-small")
			lHelpAbout = guiCreateLabel(0.15, 0.32, 0.75, 0.06, "General server, problems with players or other things should be sent via this system to our team of administrators whom are here to assist you.", true, wReportMain)
			guiLabelSetHorizontalAlign(lHelpAbout, "left", true)
			--  roleplay, gameplay and character
			bHelp = guiCreateButton(0.15, 0.380, 0.75, 0.05, "I require administrator assistance!", true, wReportMain)
			addEventHandler("onClientGUIClick", bHelp, adminReportUI)
			
			
			-- GM help related
			pGMHelp = guiCreateStaticImage(0.075, 0.48, 0.04, 0.05, "help.png", true, wReportMain)
			lGMHelp = guiCreateLabel(0.15, 0.485, 1.0, 0.1, "Request Gamemaster Help", true, wReportMain)
			guiSetFont(lGMHelp, "default-bold-small")
			lGMHelpAbout = guiCreateLabel(0.15, 0.52, 0.75, 0.06, "Questions about commands, roleplay, gameplay and character should be sent via this system to our team of game masters whom are here to assist you.", true, wReportMain)
			guiLabelSetHorizontalAlign(lGMHelpAbout, "left", true)
			--  
			bGMHelp = guiCreateButton(0.15, 0.580, 0.75, 0.05, "I require game master assistance!", true, wReportMain)
			addEventHandler("onClientGUIClick", bGMHelp, gmReportUI)
			
			-- Bug help
			pBug = guiCreateStaticImage(0.075, 0.645, 0.04, 0.05, "bug.png", true, wReportMain)
			lBug = guiCreateLabel(0.15, 0.645, 1.0, 0.1, "Report a script bug", true, wReportMain)
			guiSetFont(lBug, "default-bold-small")
			lBugAbout = guiCreateLabel(0.15, 0.70, 0.75, 0.5, "Flaws, mistakes, typos and all bugs related to the script should be reported via \nour bug tracking system at http://bugs.mta.vg.", true, wReportMain)
			guiLabelSetHorizontalAlign(lBugAbout, "left", true)
			
			guiWindowSetSizable(wReportMain, false)
			guiBringToFront(wReportMain)
			showCursor(true)
		elseif (wReportMain~=nil) then
			guiSetVisible(wReportMain, false)
			destroyElement(wReportMain)
			
			wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp = nil
			guiSetInputEnabled(false)
			showCursor(false)
		end
	end
end
addCommandHandler("report", showReportMainUI)



-- GM Report UI
function gmReportUI(button, state)
	local report = getElementData(getLocalPlayer(), "gmreport")
	
	if (report) then
		outputChatBox("You already have a pending report with ID #" .. report .. ". Please wait before submitting another.", getLocalPlayer(), 255, 0, 0)
		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end
		
		if (wHelp) then
			destroyElement(wHelp)
		end
		
		wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp, wHelp, lNameCheck, bSubmitReport, lPlayerName, reportedPlayer, tPlayerName, lReport, tReport, tHelpMessage = nil
		guiSetInputEnabled(false)
		showCursor(false)
	else
		if (source==bGMHelp) and (button=="left") and (state=="up") then
			if (wHelp==nil) then
				destroyElement(wReportMain)
				wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp, reportedPlayer = nil
				
				guiSetInputEnabled(true)
				
				wHelp = guiCreateWindow(0.2, 0.2, 0.6, 0.6, "Request GM help", true)
				scale(wHelp)
				
				-- Controls within the window
				bClose = guiCreateButton(0.775, 0.05, 0.2, 0.05, "Close", true, wHelp)
				addEventHandler("onClientGUIClick", bClose, clickCloseButton)
				
				
				lReport = guiCreateLabel(0.025, 0.3, 1.0, 0.3, "Report Information:", true, wHelp)
				guiSetFont(lPlayerName, "default-bold-small")
				
				tReport = guiCreateMemo(0.225, 0.29, 0.75, 0.5, "", true, wHelp)
				guiMemoSetReadOnly(tReport, false)
				addEventHandler("onClientGUIChanged", tReport, checkReportLength)
				
				lLengthCheck = guiCreateLabel(0.4, 0.81, 1.0, 0.3, "Length: " .. string.len(tostring(guiGetText(tReport)))-1 .. "/150 Characters.", true, wHelp)
				guiLabelSetColor(lLengthCheck, 0, 255, 0)
				guiSetFont(lLengthCheck, "default-bold-small")
				
				bSubmitReport = guiCreateButton(0.4, 0.875, 0.2, 0.05, "Submit Report", true, wHelp)
				addEventHandler("onClientGUIClick", bSubmitReport, gmSubmitReport)
				guiSetEnabled(bSubmitReport, true)
			end
		end
	end
end

function gmSubmitReport(button, state)
	if (source==bSubmitReport) and (button=="left") and (state=="up") then
		triggerServerEvent("GMclientSendReport", getLocalPlayer(), tostring(guiGetText(tReport))) 
		
		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end
		
		if (wHelp) then
			destroyElement(wHelp)
		end
		
		wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp, wHelp, lNameCheck, bSubmitReport, lPlayerName, reportedPlayer, tPlayerName, lReport, tReport, tHelpMessage = nil
		guiSetInputEnabled(false)
		showCursor(false)
	end
end

-- Admin Report UI
function adminReportUI(button, state)
	local report = getElementData(getLocalPlayer(), "report")
	
	if (report) then
		outputChatBox("You already have a pending report with ID #" .. report .. ". Please wait before submitting another.", getLocalPlayer(), 255, 0, 0)
		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end
		
		if (wHelp) then
			destroyElement(wHelp)
		end
		
		wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp, wHelp, lNameCheck, bSubmitReport, lPlayerName, reportedPlayer, tPlayerName, lReport, tReport, tHelpMessage = nil
		guiSetInputEnabled(false)
		showCursor(false)
	else
		if (source==bHelp) and (button=="left") and (state=="up") then
			if (wHelp==nil) then
				destroyElement(wReportMain)
				wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp, reportedPlayer = nil
				
				guiSetInputEnabled(true)
				
				wHelp = guiCreateWindow(0.2, 0.2, 0.6, 0.6, "Request administrator help", true)
				scale(wHelp)
				
				-- Controls within the window
				bClose = guiCreateButton(0.775, 0.05, 0.2, 0.05, "Close", true, wHelp)
				addEventHandler("onClientGUIClick", bClose, clickCloseButton)
				
				lPlayerName = guiCreateLabel(0.025, 0.15, 1.0, 0.3, "Player you wish to report (or yourself) (Partial Name):", true, wHelp)
				guiSetFont(lPlayerName, "default-bold-small")
				
				tPlayerName = guiCreateEdit(0.525, 0.14, 0.25, 0.05, "Firstname_Lastname", true, wHelp)
				
				lNameCheck = guiCreateLabel(0.525, 0.2, 1.0, 0.3, "Player not found or multiple were found.", true, wHelp)
				guiSetFont(lNameCheck, "default-bold-small")
				guiLabelSetColor(lNameCheck, 255, 0, 0)
				addEventHandler("onClientGUIChanged", tPlayerName, checkNameExists)
				
				lReport = guiCreateLabel(0.025, 0.3, 1.0, 0.3, "Report Information:", true, wHelp)
				guiSetFont(lPlayerName, "default-bold-small")
				
				tReport = guiCreateMemo(0.225, 0.29, 0.75, 0.5, "", true, wHelp)
				guiMemoSetReadOnly(tReport, true)
				addEventHandler("onClientGUIChanged", tReport, checkReportLength)
				
				lLengthCheck = guiCreateLabel(0.4, 0.81, 1.0, 0.3, "Length: " .. string.len(tostring(guiGetText(tReport)))-1 .. "/150 Characters.", true, wHelp)
				guiLabelSetColor(lLengthCheck, 0, 255, 0)
				guiSetFont(lLengthCheck, "default-bold-small")
				
				bSubmitReport = guiCreateButton(0.4, 0.875, 0.2, 0.05, "Submit Report", true, wHelp)
				addEventHandler("onClientGUIClick", bSubmitReport, submitReport)
				guiSetEnabled(bSubmitReport, false)
			end
		end
	end
end

function submitReport(button, state)
	if (source==bSubmitReport) and (button=="left") and (state=="up") then
		triggerServerEvent("clientSendReport", getLocalPlayer(), reportedPlayer, tostring(guiGetText(tReport))) 
		
		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end
		
		if (wHelp) then
			destroyElement(wHelp)
		end
		
		wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp, wHelp, lNameCheck, bSubmitReport, lPlayerName, reportedPlayer, tPlayerName, lReport, tReport, tHelpMessage = nil
		guiSetInputEnabled(false)
		showCursor(false)
	end
end

function checkReportLength(theEditBox)
	guiSetText(lLengthCheck, "Length: " .. string.len(tostring(guiGetText(tReport)))-1 .. "/150 Characters.")

	if (tonumber(string.len(tostring(guiGetText(tReport))))-1>150) then
		guiLabelSetColor(lLengthCheck, 255, 0, 0)
		guiSetEnabled(bSubmitReport, false)
	elseif (tonumber(string.len(tostring(guiGetText(tReport))))-1>130) then
		guiLabelSetColor(lLengthCheck, 255, 255, 0)
		guiSetEnabled(bSubmitReport, true)
	else
		guiLabelSetColor(lLengthCheck,0, 255, 0)
		guiSetEnabled(bSubmitReport, true)
	end
end
	

function checkNameExists(theEditBox)
	local found = nil
	local count = 0
	
	
	local text = guiGetText(theEditBox)
	if text and #text > 0 then
		local players = getElementsByType("player")
		if tonumber(text) then
			local id = tonumber(text)
			for key, value in ipairs(players) do
				if getElementData(value, "playerid") == id then
					found = value
					count = 1
					break
				end
			end
		else
			for key, value in ipairs(players) do
				local username = string.lower(tostring(getPlayerName(value)))
				if string.find(username, string.lower(text)) then
					count = count + 1
					found = value
					break
				end
			end
		end
	end
	
	if (count>1) then
		guiSetText(lNameCheck, "Multiple Found.")
		guiLabelSetColor(lNameCheck, 255, 255, 0)
		guiMemoSetReadOnly(tReport, true)
		guiSetEnabled(bSubmitReport, false)
	elseif (count==1) then
		guiSetText(lNameCheck, "Player Found: " .. getPlayerName(found) .. " (ID #" .. getElementData(found, "playerid") .. ")")
		guiLabelSetColor(lNameCheck, 0, 255, 0)
		reportedPlayer = found
		guiMemoSetReadOnly(tReport, false)
		guiSetEnabled(bSubmitReport, true)
	elseif (count==0) then
		guiSetText(lNameCheck, "Player not found.")
		guiLabelSetColor(lNameCheck, 255, 0, 0)
		guiMemoSetReadOnly(tReport, true)
		guiSetEnabled(bSubmitReport, false)
	end
end

-- Close button
function clickCloseButton(button, state)
	if (source==bClose) and (button=="left") and (state=="up") then
		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end
		
		if (wHelp) then
			destroyElement(wHelp)
		end
		
		wReportMain, lWelcome, bClose, pHelp, lHelp, lHelpAbout, bHelp, wHelp, lNameCheck, bSubmitReport, lPlayerName, reportedPlayer, tPlayerName, lReport, tReport, tHelpMessage = nil
		guiSetInputEnabled(false)
		showCursor(false)
	end
end