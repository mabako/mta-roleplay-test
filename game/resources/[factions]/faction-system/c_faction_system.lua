gFactionWindow, gMemberGrid, gMOTDLabel, colName, colRank, colWage, colLastLogin, colLocation, colLeader, colOnline, gButtonKick, gButtonPromote, gButtonDemote, gButtonEditRanks, gButtonEditMOTD, gButtonInvite, gButtonLeader, gButtonQuit, gButtonExit, wConfirmQuit, eNote = nil
theMotd, theTeam, arrUsernames, arrRanks, arrPerks, arrLeaders, arrOnline, arrFactionRanks, arrLocations, arrFactionWages, arrLastLogin, membersOnline, membersOffline, gButtonRespawn, gButtonPerk = nil

local function checkF3( )
	if not f3state and getKeyState( "f3" ) then
		hideFactionMenu( )
	else
		f3state = getKeyState( "f3" )
	end
end

function showFactionMenu(motd, memberUsernames, memberRanks, memberPerks, memberLeaders, memberOnline, memberLastLogin, memberLocation, factionRanks, factionWages, factionTheTeam, note)
	if (gFactionWindow==nil) then
		invitedPlayer = nil
		arrUsernames = memberUsernames
		arrRanks = memberRanks
		arrLeaders = memberLeaders
		arrPerks = memberPerks
		arrOnline = memberOnline
		arrLastLogin = memberLastLogin
		--arrLocations = memberLocation
		arrFactionRanks = factionRanks
		arrFactionWages = factionWages
		
		if (motd) == nil then motd = "" end
		theMotd = motd
	
	
		local thePlayer = getLocalPlayer()
		theTeam = factionTheTeam
		local teamName = getTeamName(theTeam)
		local playerName = getPlayerName(thePlayer)

		gFactionWindow = guiCreateWindow(0.1, 0.25, 0.85, 0.525, tostring(teamName), true)
		local width, height = guiGetSize(gFactionWindow, false)
		if height < 500 then
			guiSetSize(gFactionWindow, width, 500, false)
			local posx, posy = guiGetPosition(gFactionWindow, false)
			local screenx, screeny = guiGetScreenSize( )
			guiSetPosition(gFactionWindow, posx, (screeny - 500) / 2, false)
		end
		guiWindowSetSizable(gFactionWindow, false)
		guiSetInputEnabled(true)
		
		tabs = guiCreateTabPanel(0, 0.04, 1, 1, true, gFactionWindow)
		tabOverview = guiCreateTab("Overview", tabs)
		
		-- Make members list
		gMemberGrid = guiCreateGridList(0.01, 0.015, 0.8, 0.905, true, tabOverview)
		
		colName = guiGridListAddColumn(gMemberGrid, "Name", 0.23)
		colRank = guiGridListAddColumn(gMemberGrid, "Rank", 0.20)
		colOnline = guiGridListAddColumn(gMemberGrid, "Status", 0.115)
		colLastLogin = guiGridListAddColumn(gMemberGrid, "Last Login", 0.17)
		colLeader = guiGridListAddColumn(gMemberGrid, "Level", 0.1)
		
		
		local factionType = tonumber(getElementData(theTeam, "type"))
		
		if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) then
			--colLocation = guiGridListAddColumn(gMemberGrid, "Location", 0.25)
			colWage = guiGridListAddColumn(gMemberGrid, "Wage ($)", 0.1)
		else
			--colLocation = guiGridListAddColumn(gMemberGrid, "Location", 0.35)
		end
		
		
		local localPlayerIsLeader = nil
		local counterOnline, counterOffline = 0, 0
		
		for k, v in ipairs(memberUsernames) do
			local row = guiGridListAddRow(gMemberGrid)
			guiGridListSetItemText(gMemberGrid, row, colName, string.gsub(tostring(memberUsernames[k]), "_", " "), false, false)
			
			local theRank = tonumber(memberRanks[k])
			local rankName = factionRanks[theRank]
			guiGridListSetItemText(gMemberGrid, row, colRank, tostring(rankName), false, false)
			guiGridListSetItemData(gMemberGrid, row, colRank, tostring(theRank))
			
			local login = "Never"
			if (not memberLastLogin[k]) then
				login = "Never"
			else
				if (memberLastLogin[k]==0) then
					login = "Today"
				elseif (memberLastLogin[k]==1) then
					login = tostring(memberLastLogin[k]) .. " day ago"
				else
					login = tostring(memberLastLogin[k]) .. " days ago"
				end
			end
			guiGridListSetItemText(gMemberGrid, row, colLastLogin, login, false, false)
			--guiGridListSetItemText(gMemberGrid, row, colLocation, memberLocation[k], false, false)

			if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6)then
				local rankWage = factionWages[theRank]
				guiGridListSetItemText(gMemberGrid, row, colWage, tostring(rankWage), false, true)
			end
			
			if (memberOnline[k]) then
				guiGridListSetItemText(gMemberGrid, row, colOnline, "Online", false, false)
				guiGridListSetItemColor(gMemberGrid, row, colOnline, 127, 255, 127)
				counterOnline = counterOnline + 1
			else
				guiGridListSetItemText(gMemberGrid, row, colOnline, "Offline", false, false)
				guiGridListSetItemColor(gMemberGrid, row, colOnline, 255, 127, 127)
				counterOffline = counterOffline + 1
			end

			if (memberLeaders[k]) then
				guiGridListSetItemText(gMemberGrid, row, colLeader, "Leader", false, false)
			else
				guiGridListSetItemText(gMemberGrid, row, colLeader, "Member", false, false)
			end
			
			-- Check if this is the local player
			if (tostring(memberUsernames[k])==playerName) then
				localPlayerIsLeader = memberLeaders[k]
			end
		end
		
		membersOnline = counterOnline
		membersOffline = counterOffline
		
		-- Update the window title
		guiSetText(gFactionWindow, tostring(teamName) .. " (" .. counterOnline .. " of " .. (counterOnline+counterOffline) .. " Members Online)")
		
		-- Make the buttons
		if (localPlayerIsLeader) then
			gButtonKick = guiCreateButton(0.825, 0.076, 0.16, 0.06, "Boot player", true, tabOverview)
			gButtonLeader = guiCreateButton(0.825, 0.1526, 0.16, 0.06, "Toggle leader status", true, tabOverview)
			gButtonPromote = guiCreateButton(0.825, 0.2292, 0.16, 0.06, "Promote player", true, tabOverview)
			gButtonDemote = guiCreateButton(0.825, 0.3058, 0.16, 0.06, "Demote player", true, tabOverview)
			
			if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) then
				gButtonEditRanks = guiCreateButton(0.825, 0.3824, 0.16, 0.06, "Edit ranks and wages", true, tabOverview)
			else
				gButtonEditRanks = guiCreateButton(0.825, 0.3824, 0.16, 0.06, "Edit ranks", true, tabOverview)
			end
			
			gButtonEditMOTD = guiCreateButton(0.825, 0.459, 0.16, 0.06, "Edit MOTD", true, tabOverview)
			gButtonInvite = guiCreateButton(0.825, 0.5356, 0.16, 0.06, "Invite player to faction", true, tabOverview)
			gButtonRespawn = guiCreateButton(0.825, 0.6122, 0.16, 0.06, "Respawn vehicles", true, tabOverview)
			
			local factionID = getElementData(getLocalPlayer(), "faction")
			local factionPackages = exports.duty:getFactionPackages(factionID)
			--outputDebugString(tostring(factionPackages))
			if factionPackages and #factionPackages > 0 then
				gButtonPerk = guiCreateButton(0.825, 0.6878, 0.16, 0.06, "Manage /duty", true, tabOverview)
				addEventHandler("onClientGUIClick", gButtonPerk, btButtonPerk, false)
			end
			
			addEventHandler("onClientGUIClick", gButtonKick, btKickPlayer, false)
			addEventHandler("onClientGUIClick", gButtonLeader, btToggleLeader, false)
			addEventHandler("onClientGUIClick", gButtonPromote, btPromotePlayer, false)
			addEventHandler("onClientGUIClick", gButtonDemote, btDemotePlayer, false)
			
			addEventHandler("onClientGUIClick", gButtonEditRanks, btEditRanks, false)
			addEventHandler("onClientGUIClick", gButtonEditMOTD, btEditMOTD, false)
			addEventHandler("onClientGUIClick", gButtonInvite, btInvitePlayer, false)
			addEventHandler("onClientGUIClick", gButtonRespawn, btRespawnVehicles, false)
			
			tabNote = guiCreateTab("(Leader) Note", tabs)
			eNote = guiCreateMemo(0.01, 0.02, 0.98, 0.87, note or "", true, tabNote)
			gButtonSaveNote = guiCreateButton(0.79, 0.90, 0.2, 0.08, "Save", true, tabNote)
			addEventHandler("onClientGUIClick", gButtonSaveNote, btUpdateNote, false)
	end
			
			gButtonQuit = guiCreateButton(0.825, 0.7834, 0.16, 0.06, "Leave Faction", true, tabOverview)
			gButtonExit = guiCreateButton(0.825, 0.86, 0.16, 0.06, "Exit Menu", true, tabOverview)
			gMOTDLabel = guiCreateLabel(0.015, 0.935, 0.95, 0.15, tostring(motd), true, tabOverview)
			guiSetFont(gMOTDLabel, "default-bold-small")
			
			addEventHandler("onClientGUIClick", gButtonQuit, btQuitFaction, false)
			addEventHandler("onClientGUIClick", gButtonExit, hideFactionMenu, false)
			
			addEventHandler("onClientRender", getRootElement(), checkF3)
			f3state = getKeyState( "f3" )
	else
		hideFactionMenu()
	end
	showCursor(true)
end
addEvent("showFactionMenu", true)
addEventHandler("showFactionMenu", getRootElement(), showFactionMenu)

-- BUTTON EVENTS

-- RANKS/WAGES

lRanks = { }
tRanks = { }
tRankWages = { }
wRanks = nil
bRanksSave, bRanksClose = nil

function btEditRanks(button, state)
	if (source==gButtonEditRanks) and (button=="left") and (state=="up") then
		local factionType = tonumber(getElementData(theTeam, "type"))
		lRanks = { }
		tRanks = { }
		tRankWages = { }
		
		guiSetInputEnabled(true)
		
		local wages = (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6)
		local width, height = 400, 540
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)
		
		wRanks = guiCreateWindow(x, y, width, height, "Ranks & Wages", false)
		
		local y = 0
		for i=1, 20 do
			y = ( y or 0 ) + 23
			lRanks[i] = guiCreateLabel(0.05 * width, y + 3, 0.4 * width, 20, "Rank #" .. i .. " Title & Wage: ", false, wRanks)
			guiSetFont(lRanks[i], "default-bold-small")
			tRanks[i] = guiCreateEdit(0.4 * width, y, ( wages and 0.33 or 0.55 ) * width, 20, arrFactionRanks[i], false, wRanks)
			if wages then
				tRankWages[i] = guiCreateEdit(0.75 * width, y, 0.2 * width, 20, tostring(arrFactionWages[i]), false, wRanks)
			end
		end
		
		bRanksSave = guiCreateButton(0.05, 0.900, 0.9, 0.045, "Save!", true, wRanks)
		bRanksClose = guiCreateButton(0.05, 0.950, 0.9, 0.045, "Close", true, wRanks)
		
		addEventHandler("onClientGUIClick", bRanksSave, saveRanks, false)
		addEventHandler("onClientGUIClick", bRanksClose, closeRanks, false)
	end
end

function saveRanks(button, state)
	if (source==bRanksSave) and (button=="left") and (state=="up") then
		local found = false
		local isNumber = true
		for key, value in ipairs(tRanks) do
			if (string.find(guiGetText(tRanks[key]), ";")) or (string.find(guiGetText(tRanks[key]), "'")) then
				found = true
			end
		end
		
		local factionType = tonumber(getElementData(theTeam, "type"))
		if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) then
			for key, value in ipairs(tRankWages) do
				if not (tostring(type(tonumber(guiGetText(tRankWages[key])))) == "number") then
					isNumber = false
				end
			end
		end
		
		if (found) then
			outputChatBox("Your ranks contain invalid characters, please ensure it does not contain characters such as '@.;", 255, 0, 0)
		elseif not (isNumber) then
			outputChatBox("Your wages are not numbers, please ensure you entered a number and no currency symbol.", 255, 0, 0)
		else
			local sendRanks = { }
			local sendWages = { }
			
			for key, value in ipairs(tRanks) do
				sendRanks[key] = guiGetText(tRanks[key])
			end
			
			if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) then
				for key, value in ipairs(tRankWages) do
					sendWages[key] = guiGetText(tRankWages[key])
				end
			end
			
			hideFactionMenu()
			if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) then
				triggerServerEvent("cguiUpdateRanks", getLocalPlayer(), sendRanks, sendWages)
			else
				triggerServerEvent("cguiUpdateRanks", getLocalPlayer(), sendRanks)
			end
		end
	end
end

function closeRanks(button, state)
	if (source==bRanksClose) and (button=="left") and (state=="up") then
		if (wRanks) then
			destroyElement(wRanks)
			lRanks, tRanks, tRankWages, wRanks, bRanksSave, bRanksClose = nil, nil, nil, nil, nil, nil
			guiSetInputEnabled(false)
		end
	end
end

-- MOTD
wMOTD, tMOTD, bUpdate, bMOTDClose = nil
function btEditMOTD(button, state)
	if (source==gButtonEditMOTD) and (button=="left") and (state=="up") then
		if not (wMOTD) then
			local width, height = 300, 200
			local scrWidth, scrHeight = guiGetScreenSize()
			local x = scrWidth/2 - (width/2)
			local y = scrHeight/2 - (height/2)
			
			wMOTD = guiCreateWindow(x, y, width, height, "Message of the Day", false)
			tMOTD = guiCreateEdit(0.1, 0.2, 0.85, 0.1, tostring(theMotd), true, wMOTD)
			
			guiSetInputEnabled(true)
			
			bUpdate = guiCreateButton(0.1, 0.6, 0.85, 0.15, "Update!", true, wMOTD)
			addEventHandler("onClientGUIClick", bUpdate, sendMOTD, false)
			
			bMOTDClose= guiCreateButton(0.1, 0.775, 0.85, 0.15, "Close Window", true, wMOTD)
			addEventHandler("onClientGUIClick", bMOTDClose, closeMOTD, false)
		else
			guiBringToFront(wInvite)
		end
	end
end

function closeMOTD(button, state)
	if (source==bMOTDClose) and (button=="left") and (state=="up") then
		if (wMOTD) then
			destroyElement(wMOTD)
			wMOTD, tMOTD, bUpdate, bMOTDClose = nil, nil, nil, nil
		end
	end
end

function sendMOTD(button, state)
	if (source==bUpdate) and (button=="left") and (state=="up") then
		local motd = guiGetText(tMOTD)
		
		local found1 = string.find(motd, ";")
		local found2 = string.find(motd, "'")
		
		if (found1) or (found2) then
			outputChatBox("Your message contains invalid characters.", 255, 0, 0)
		else
			guiSetText(gMOTDLabel, tostring(motd))
			theMOTD = motd -- Store it clientside
			triggerServerEvent("cguiUpdateMOTD", getLocalPlayer(), motd)
		end
	end
end

-- NOTE
function btUpdateNote(button, state)
	if button == "left" and state == "up" then
		triggerServerEvent("faction:note", getLocalPlayer(), guiGetText(eNote))
	end
end

-- INVITE
wInvite, tInvite, lNameCheck, bInvite, bInviteClose, invitedPlayer = nil
function btInvitePlayer(button, state)
	if (source==gButtonInvite) and (button=="left") and (state=="up") then
		if not (wInvite) then
			local width, height = 300, 200
			local scrWidth, scrHeight = guiGetScreenSize()
			local x = scrWidth/2 - (width/2)
			local y = scrHeight/2 - (height/2)
			
			wInvite = guiCreateWindow(x, y, width, height, "Invite a Player", false)
			tInvite = guiCreateEdit(0.1, 0.2, 0.85, 0.1, "Partial Player Name", true, wInvite)
			addEventHandler("onClientGUIChanged", tInvite, checkNameExists)
					
			lNameCheck = guiCreateLabel(0.1, 0.325, 0.8, 0.3, "Player not found or multiple were found.", true, wInvite)
			guiSetFont(lNameCheck, "default-bold-small")
			guiLabelSetColor(lNameCheck, 255, 0, 0)
			guiLabelSetHorizontalAlign(lNameCheck, "center")
			
			guiSetInputEnabled(true)
			
			bInvite = guiCreateButton(0.1, 0.6, 0.85, 0.15, "Invite!", true, wInvite)
			guiSetEnabled(bInvite, false)
			addEventHandler("onClientGUIClick", bInvite, sendInvite, false)
			
			bCloseInvite = guiCreateButton(0.1, 0.775, 0.85, 0.15, "Close Window", true, wInvite)
			addEventHandler("onClientGUIClick", bCloseInvite, closeInvite, false)
		else
			guiBringToFront(wInvite)
		end
	end
end

function closeInvite(button, state)
	if (source==bCloseInvite) and (button=="left") and (state=="up") then
		if (wInvite) then
			destroyElement(wInvite)
			wInvite, tInvite, lNameCheck, bInvite, bInviteClose, invitedPlayer = nil, nil, nil, nil, nil, nil
		end
	end
end

function sendInvite(button, state)
	if (source==bInvite) and (button=="left") and (state=="up") then
		triggerServerEvent("cguiInvitePlayer", getLocalPlayer(), invitedPlayer)
	end
end

function checkNameExists(theEditBox)
	local found = nil
	local foundstr = ""
	local count = 0
	
	local players = getElementsByType("player")
	for key, value in ipairs(players) do
		local username = string.lower(tostring(getPlayerName(value)))
		if (string.find(username, string.lower(tostring(guiGetText(theEditBox))))) and (guiGetText(theEditBox)~="") then
			count = count + 1
			found = value
			foundstr = username
		end
	end
	
	if (count>1) then
		guiSetText(lNameCheck, "Multiple Found.")
		guiLabelSetColor(lNameCheck, 255, 255, 0)
		guiMemoSetReadOnly(tInvite, true)
		guiSetEnabled(bInvite, false)
	elseif (count==1) then
		guiSetText(lNameCheck, "Player Found. ("..foundstr..")")
		guiLabelSetColor(lNameCheck, 0, 255, 0)
		invitedPlayer = found
		guiMemoSetReadOnly(tInvite, false)
		guiSetEnabled(bInvite, true)
	elseif (count==0) then
		guiSetText(lNameCheck, "Player not found or multiple were found.")
		guiLabelSetColor(lNameCheck, 255, 0, 0)
		guiMemoSetReadOnly(tInvite, true)
		guiSetEnabled(bInvite, false)
	end
	guiLabelSetHorizontalAlign(lNameCheck, "center")
end

function btQuitFaction(button, state)
	if (button=="left") and (state=="up") and (source==gButtonQuit) then
		local numLeaders = 0
		local isLeader = false
		local localUsername = getPlayerName(getLocalPlayer())
		
		for k, v in ipairs(arrUsernames) do -- Find the player
			if (v==localUsername) then -- Found
				isLeader = arrLeaders[k]
			end
		end
		
		for k, v in ipairs(arrLeaders) do
			numLeaders = numLeaders + 1
		end
		
		if (numLeaders==1) and (isLeader) then
			outputChatBox("You must promote someone to lead this faction before quitting. You are the only leader.", 255, 0, 0)
		else
			local sx, sy = guiGetScreenSize() 
			wConfirmQuit = guiCreateWindow(sx/2 - 125,sy/2 - 50,250,100,"Leaving Confirmation", false)
			local lQuestion = guiCreateLabel(0.05,0.25,0.9,0.3,"Do you really want to leave " .. getTeamName(theTeam) .. "?",true,wConfirmQuit)
			guiLabelSetHorizontalAlign (lQuestion,"center",true)
			local bYes = guiCreateButton(0.1,0.65,0.37,0.23,"Yes",true,wConfirmQuit)
			local bNo = guiCreateButton(0.53,0.65,0.37,0.23,"No",true,wConfirmQuit)
			addEventHandler("onClientGUIClick", getRootElement(), 
				function(button)
					if button=="left" and ( source == bYes or source == bNo ) then
						if source == bYes then
							hideFactionMenu()
							triggerServerEvent("cguiQuitFaction", getLocalPlayer())
						end
						if wConfirmQuit then
							destroyElement(wConfirmQuit)
							wConfirmQuit = nil
						end
					end
				end
			)
		end
	end
end

function btKickPlayer(button, state)
	if (button=="left") and (state=="up") and (source==gButtonKick) then
		local playerName = string.gsub(guiGridListGetItemText(gMemberGrid, guiGridListGetSelectedItem(gMemberGrid), 1), " ", "_")
			
		if (playerName==getPlayerName(getLocalPlayer())) then
			outputChatBox("You cannot kick yourself, quit instead.", thePlayer)
		elseif (playerName~="") then
			local row = guiGridListGetSelectedItem(gMemberGrid)
			guiGridListRemoveRow(gMemberGrid, row)
			
			local theTeamName = getTeamName(theTeam)
			
			outputChatBox("You removed " .. playerName .. " from the faction '" .. tostring(theTeamName) .. "'.", 0, 255, 0)
			triggerServerEvent("cguiKickPlayer", getLocalPlayer(), playerName)
		else
			outputChatBox("Please select a member to kick.")
		end
	end
end

wPerkWindow, bPerkSave, bPerkClose, bPerkChkTable, bPerkActivePlayer = nil
function btButtonPerk(button, state)
	if (button=="left") and (state=="up") and (source==gButtonPerk) then
		bPerkChkTable = { }
		local bPerkActivePlayer = guiGridListGetItemText(gMemberGrid, guiGridListGetSelectedItem(gMemberGrid), 1)
		local playerName = string.gsub(bPerkActivePlayer, " ", "_")
		
		local factionID = getElementData(getLocalPlayer(), "faction")
		local factionPackages = exports.duty:getFactionPackages(factionID)
		if (#factionPackages == 0) then
			outputChatBox("This option is not available for your faction.")
			return
		end
		
		if (playerName == "") then
			outputChatBox("Please select a member to manage.")
			return
		end
				
		guiSetInputEnabled(true)
		
		local width, height = 500, 540
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)
		
		wPerkWindow = guiCreateWindow(x, y, width, height, "Faction perks for "..playerName, false)
		
		local factionPerks = false

		for k, v in ipairs(arrUsernames) do -- Find the player
			if (v==playerName) then -- Found
				factionPerks = arrPerks[k]
				--outputDebugString(getElementType(factionPerks))
				--outputDebugString(tostring(factionPerks))
			end
		end
		
		if not factionPerks then
			outputChatBox("Failed to load "..playerName.. " his faction perks")
			factionPerks = { }
		end
		
		local y = 0
		for index, factionPackage in ipairs ( factionPackages ) do
			y = ( y or 0 ) + 20
			local tmpChk = guiCreateCheckBox(0.05 * width, y + 3, 0.4 * width, 17, factionPackage["packageName"], false, false, wPerkWindow)
			guiSetFont(tmpChk, "default-bold-small")
			setElementData(tmpChk, "factionPackage:ID", factionPackage["grantID"], false)
			setElementData(tmpChk, "factionPackage:selected", bPerkActivePlayer, false)
			
			for index, permissionID in ipairs(factionPerks) do
				--outputDebugString(tostring(factionPackage["grantID"]) .. " vs "..tostring(permissionID))
				if (permissionID == factionPackage["grantID"]) then
					--outputDebugString("win!")
					guiCheckBoxSetSelected (tmpChk, true)
				end
			end
			
			table.insert(bPerkChkTable, tmpChk)
		end
		
		bPerkSave = guiCreateButton(0.05, 0.900, 0.9, 0.045, "Save", true, wPerkWindow)
		bPerkClose = guiCreateButton(0.05, 0.950, 0.9, 0.045, "Close", true, wPerkWindow)
		addEventHandler("onClientGUIClick", bPerkSave, 
			function (button, state)
				if (source == bPerkSave) and (button=="left") and (state=="up") then
					if (wPerkWindow) then
						local collectedPerks = { }
						for _, checkBox in ipairs ( bPerkChkTable ) do
							if ( guiCheckBoxGetSelected( checkBox ) ) then
								table.insert(collectedPerks, getElementData(checkBox, "factionPackage:ID") or -1 )
							end
						end
						
						triggerServerEvent("faction:perks:edit", getLocalPlayer(), collectedPerks, playerName)
						destroyElement(wPerkWindow)
						wPerkWindow, bPerkSave, bPerkClose, bPerkChkTable, bPerkActivePlayer = nil
						guiSetInputEnabled(false)
					end
				end
			end
		, false)
		addEventHandler("onClientGUIClick", bPerkClose, 
			function (button, state)
				if (source == bPerkClose) and (button=="left") and (state=="up") then
					if (wPerkWindow) then
						destroyElement(wPerkWindow)
						wPerkWindow, bPerkSave, bPerkClose, bPerkChkTable, bPerkActivePlayer = nil
						guiSetInputEnabled(false)
					end
				end
			end
		, false)
	end
end


function btToggleLeader(button, state)
	if (button=="left") and (state=="up") and (source==gButtonLeader) then
		local playerName = string.gsub(guiGridListGetItemText(gMemberGrid, guiGridListGetSelectedItem(gMemberGrid), 1), " ", "_")
		local currentLevel = guiGridListGetItemText(gMemberGrid, guiGridListGetSelectedItem(gMemberGrid), 5)

		if (playerName==getPlayerName(getLocalPlayer())) then
			outputChatBox("You cannot un-leader yourself.", thePlayer)
		elseif (playerName~="") then
			local row = guiGridListGetSelectedItem(gMemberGrid)
			
			if (currentLevel=="Leader") then
				guiGridListSetItemText(gMemberGrid, row, tonumber(colLeader), "Member", false, false)
				guiGridListSetSelectedItem(gMemberGrid, 0, 0)
				triggerServerEvent("cguiToggleLeader", getLocalPlayer(), playerName, false) -- false = not leader
			else
				guiGridListSetItemText(gMemberGrid, row, tonumber(colLeader), "Leader", false, false)
				guiGridListSetSelectedItem(gMemberGrid, 0, 0)
				triggerServerEvent("cguiToggleLeader", getLocalPlayer(), playerName, true) -- true = leader
			end
		else
			outputChatBox("Please select a member to toggle leader on.")
		end
	end
end

function btPromotePlayer(button, state)
	if (button=="left") and (state=="up") and (source==gButtonPromote) then
		local row = guiGridListGetSelectedItem(gMemberGrid)
		local playerName = string.gsub(guiGridListGetItemText(gMemberGrid, row, 1), " ", "_")
		local currentRank = guiGridListGetItemText(gMemberGrid, row, 2)
		
		if (playerName~="") then
			local currRankNumber = tonumber( guiGridListGetItemData(gMemberGrid, row, colRank) )
			if (currRankNumber==20) then
				outputChatBox(playerName .. " is already at the highest rank.", 255, 0, 0)
			else
				guiGridListSetSelectedItem(gMemberGrid, 0, 0)
				guiGridListSetItemText(gMemberGrid, row, colRank, arrFactionRanks[currRankNumber+1], false, false)
				if colWage then
					guiGridListSetItemText(gMemberGrid, row, colWage, arrFactionWages[currRankNumber+1], false, true)
				end
				guiGridListSetItemData(gMemberGrid, row, colRank, tostring(currRankNumber+1))
				triggerServerEvent("cguiPromotePlayer", getLocalPlayer(), playerName, currRankNumber+1, arrFactionRanks[currRankNumber], arrFactionRanks[currRankNumber+1])
				guiGridListSetSelectedItem(gMemberGrid, row, colRank)
			end
		else
			outputChatBox("Please select a member to promote.")
		end
	end
end

function btDemotePlayer(button, state)
	if (button=="left") and (state=="up") and (source==gButtonDemote) then
		local row = guiGridListGetSelectedItem(gMemberGrid)
		local playerName = string.gsub(guiGridListGetItemText(gMemberGrid, row, 1), " ", "_")
		local currentRank = guiGridListGetItemText(gMemberGrid, row, 2)
		
		if (playerName~="") then
			local currRankNumber = tonumber( guiGridListGetItemData(gMemberGrid, row, colRank) )
			if (currRankNumber==1) then
				outputChatBox(playerName .. " is already at the lowest rank.", 255, 0, 0)
			else
				guiGridListSetSelectedItem(gMemberGrid, 0, 0)
				guiGridListSetItemText(gMemberGrid, row, colRank, arrFactionRanks[currRankNumber-1], false, false)
				if colWage then
					guiGridListSetItemText(gMemberGrid, row, colWage, arrFactionWages[currRankNumber-1], false, true)
				end
				guiGridListSetItemData(gMemberGrid, row, colRank, tostring(currRankNumber-1))
				triggerServerEvent("cguiDemotePlayer", getLocalPlayer(), playerName, currRankNumber-1, arrFactionRanks[currRankNumber], arrFactionRanks[currRankNumber-1])
				guiGridListSetSelectedItem(gMemberGrid, row, colRank)
			end
		else
			outputChatBox("Please select a member to demote.")
		end
	end
end

function reselectItem(grid, row, col)
	guiGridListSetSelectedItem(grid, row, col)
end

function hideFactionMenu()
	showCursor(false)
	guiSetInputEnabled(false)
	
	if (gFactionWindow) then
		destroyElement(gFactionWindow)
	end
	
	gFactionWindow, gMemberGrid = nil
	triggerServerEvent("factionmenu:hide", getLocalPlayer())
	
	if (wInvite) then
		destroyElement(wInvite)
		wInvite, tInvite, lNameCheck, bInvite, bInviteClose, invitedPlayer = nil, nil, nil, nil, nil, nil
	end
	
	if (wMOTD) then
		destroyElement(wMOTD)
		wMOTD, tMOTD, bUpdate, bMOTDClose = nil, nil, nil, nil
	end
	
	if (wRanks) then
		destroyElement(wRanks)
		lRanks, tRanks, tRankWages, wRanks, bRanksSave, bRanksClose = nil, nil, nil, nil, nil, nil
	end
	
	-- Clear variables (should reduce lag a tiny bit clientside)
	gFactionWindow, gMemberGrid, gMOTDLabel, colName, colRank, colWage, colLastLogin, colLocation, colLeader, colOnline, gButtonKick, gButtonPromote, gButtonDemote, gButtonEditRanks, gButtonEditMOTD, gButtonInvite, gButtonLeader, gButtonQuit, gButtonExit = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	theMotd, theTeam, arrUsernames, arrRanks, arrLeaders, arrOnline, arrFactionRanks, arrLocations, arrFactionWages, arrLastLogin, membersOnline, membersOffline = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	removeEventHandler("onClientRender", getRootElement(), checkF3)
end
addEvent("hideFactionMenu", true)
addEventHandler("hideFactionMenu", getRootElement(), hideFactionMenu)

function resourceStopped()
	showCursor(false)
	guiSetInputEnabled(false)
end
addEventHandler("onClientResourceStop", getResourceRootElement(), resourceStopped)

function btRespawnVehicles(button, state)
	if (button=="left") then
		hideFactionMenu()
		triggerServerEvent("cguiRespawnVehicles", getLocalPlayer())
	end
end
