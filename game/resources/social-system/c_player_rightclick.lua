wRightClick = nil
bAddAsFriend, bFrisk, bRestrain, bCloseMenu, bInformation, bBlindfold, bStabilize = nil
sent = false
ax, ay = nil
player = nil
gotClick = false
closing = false

function clickPlayer(button, state, absX, absY, wx, wy, wz, element)
	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return
	end
	if (element) and (getElementType(element)=="player") and (button=="right") and (state=="down") and (sent==false) and (element~=getLocalPlayer()) then
		local x, y, z = getElementPosition(getLocalPlayer())
		
		if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=5) then
			if (wRightClick) then
				hidePlayerMenu()
			end
			showCursor(true)
			ax = absX
			ay = absY
			player = element
			sent = true
			closing = false
			
			showPlayerMenu(player, isFriendOf(getElementData(player, "account:id")))
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickPlayer, true)

function showPlayerMenu(targetPlayer, friend)
	wRightClick = guiCreateWindow(ax, ay, 150, 200, string.gsub(getPlayerName(targetPlayer), "_", " "), false)
	
	if not friend then
		bAddAsFriend = guiCreateButton(0.05, 0.13, 0.87, 0.1, "Add as friend", true, wRightClick)
		addEventHandler("onClientGUIClick", bAddAsFriend, caddFriend, false)
	else
		bAddAsFriend = guiCreateButton(0.05, 0.13, 0.87, 0.1, "Remove friend", true, wRightClick)
		addEventHandler("onClientGUIClick", bAddAsFriend, cremoveFriend, false)
	end
	
	-- FRISK
	bFrisk = guiCreateButton(0.52, 0.25, 0.43, 0.1, "Frisk", true, wRightClick)
	addEventHandler("onClientGUIClick", bFrisk, cfriskPlayer, false)
	
	-- RESTRAIN
	local cuffed = getElementData(player, "restrain")
	
	if cuffed == 0 then
		bRestrain = guiCreateButton(0.05, 0.25, 0.43, 0.1, "Restrain", true, wRightClick)
		addEventHandler("onClientGUIClick", bRestrain, crestrainPlayer, false)
	else
		bRestrain = guiCreateButton(0.05, 0.25, 0.43, 0.1, "Unrestrain", true, wRightClick)
		addEventHandler("onClientGUIClick", bRestrain, cunrestrainPlayer, false)
	end
	
	-- BLINDFOLD
	local blindfold = getElementData(player, "blindfold")
	
	if (blindfold) and (blindfold == 1) then
		bBlindfold = guiCreateButton(0.05, 0.51, 0.87, 0.1, "Remove Blindfold", true, wRightClick)
		addEventHandler("onClientGUIClick", bBlindfold, cremoveBlindfold, false)
	else
		bBlindfold = guiCreateButton(0.05, 0.51, 0.87, 0.1, "Blindfold", true, wRightClick)
		addEventHandler("onClientGUIClick", bBlindfold, cBlindfold, false)
	end
	
	-- STABILIZE
	y = 0.64
	if exports.global:hasItem(getLocalPlayer(), 70) and getElementData(player, "injuriedanimation") then
		bStabilize = guiCreateButton(0.05, y, 0.87, 0.1, "Stabilize", true, wRightClick)
		addEventHandler("onClientGUIClick", bStabilize, cStabilize, false)
		y = y + 0.13
	end
	
	-- Stretcher system
	local stretcherElement = getElementData(getLocalPlayer(), "realism:stretcher:hasStretcher") 
	if stretcherElement then
		local stretcherPlayer =  getElementData( stretcherElement, "realism:stretcher:playerOnIt" )
		if stretcherPlayer and stretcherPlayer == player then
			bStabilize = guiCreateButton(0.05, y, 0.87, 0.1, "Take from stretcher", true, wRightClick)
			addEventHandler("onClientGUIClick", bStabilize, fTakeFromStretcher, false)
			y = y + 0.13
		end
		
		if not stretcherPlayer then
			bStabilize = guiCreateButton(0.05, y, 0.87, 0.1, "Lay on stretcher", true, wRightClick)
			addEventHandler("onClientGUIClick", bStabilize, fLayOnStretcher, false)
			y = y + 0.13
		end
	end
	
	
	
	
	
	bCloseMenu = guiCreateButton(0.05, y, 0.87, 0.1, "Close Menu", true, wRightClick)
	addEventHandler("onClientGUIClick", bCloseMenu, hidePlayerMenu, false)
	sent = false
	
	bInformation = guiCreateButton(0.05, 0.38, 0.87, 0.1, "Information", true, wRightClick)
	addEventHandler("onClientGUIClick", bInformation, showPlayerInfo, false)
end
addEvent("displayPlayerMenu", true)
addEventHandler("displayPlayerMenu", getRootElement(), showPlayerMenu)

function fTakeFromStretcher(button, state)
	if button == "left" and state == "up" then
		triggerServerEvent("stretcher:takePedFromStretcher", getLocalPlayer(), player)
		hidePlayerMenu()
	end
end

function fLayOnStretcher(button, state)
	if button == "left" and state == "up" then
		triggerServerEvent("stretcher:movePedOntoStretcher", getLocalPlayer(), player)
		hidePlayerMenu()
	end
end

function showPlayerInfo(button, state)
	if (button=="left") then
		triggerServerEvent("social:look", player)
		hidePlayerMenu()
	end
end


--------------------
--   STABILIZING  --
--------------------

function cStabilize(button, state)
	if button == "left" and state == "up" then
		if (exports.global:hasItem(getLocalPlayer(), 70)) then -- Has First Aid Kit?
			local knockedout = getElementData(player, "injuriedanimation")
			
			if not knockedout then
				outputChatBox("This player is not knocked out.", 255, 0, 0)
				hidePlayerMenu()
			else
				triggerServerEvent("stabilizePlayer", getLocalPlayer(), player)
				hidePlayerMenu()
			end
		else
			outputChatBox("You do not have a First Aid Kit.", 255, 0, 0)
		end
	end
end

--------------------
--  BLINDFOLDING  --
-------------------
function cBlindfold(button, state, x, y)
	if (button=="left") then
		if (exports.global:hasItem(getLocalPlayer(), 66)) then -- Has blindfold?
			local blindfolded = getElementData(player, "blindfold")
			local restrained = getElementData(player, "restrain")
			
			if (blindfolded==1) then
				outputChatBox("This player is already blindfolded.", 255, 0, 0)
				hidePlayerMenu()
			elseif (restrained==0) then
				outputChatBox("This player must be restrained in order to blindfold them.", 255, 0, 0)
				hidePlayerMenu()
			else
				triggerServerEvent("blindfoldPlayer", getLocalPlayer(), player)
				hidePlayerMenu()
			end
		else
			outputChatBox("You do not have a blindfold.", 255, 0, 0)
		end
	end
end

function cremoveBlindfold(button, state, x, y)
	if (button=="left") then
		local blindfolded = getElementData(player, "blindfold")
		if (blindfolded==1) then
			triggerServerEvent("removeBlindfold", getLocalPlayer(), player)
			hidePlayerMenu()
		else
			outputChatBox("This player is not blindfolded.", 255, 0, 0)
			hidePlayerMenu()
		end
	end
end

--------------------
--  RESTRAINING   --
--------------------
function crestrainPlayer(button, state, x, y)
	if (button=="left") then
		if (exports.global:hasItem(getLocalPlayer(), 45) or exports.global:hasItem(getLocalPlayer(), 46)) then
			local restrained = getElementData(player, "restrain")
			
			if (restrained==1) then
				outputChatBox("This player is already restrained.", 255, 0, 0)
				hidePlayerMenu()
			else
				local restrainedObj
				
				if (exports.global:hasItem(getLocalPlayer(), 45)) then
					restrainedObj = 45
				elseif (exports.global:hasItem(getLocalPlayer(), 46)) then
					restrainedObj = 46
				end
					
				triggerServerEvent("restrainPlayer", getLocalPlayer(), player, restrainedObj)
				hidePlayerMenu()
			end
		else
			outputChatBox("You have no items to restrain with.", 255, 0, 0)
			hidePlayerMenu()
		end
	end
end

function cunrestrainPlayer(button, state, x, y)
	if (button=="left") then
		local restrained = getElementData(player, "restrain")
		
		if (restrained==0) then
			outputChatBox("This player is not restrained.", 255, 0, 0)
			hidePlayerMenu()
		else
			local restrainedObj = getElementData(player, "restrainedObj")
			local dbid = getElementData(player, "dbid")
			
			if (exports.global:hasItem(getLocalPlayer(), 47, dbid)) or (restrainedObj==46) then -- has the keys, or its a rope
				triggerServerEvent("unrestrainPlayer", getLocalPlayer(), player, restrainedObj)
				hidePlayerMenu()
			else
				outputChatBox("You do not have the keys to these handcuffs.", 255, 0, 0)
			end
		end
	end
end
--------------------
-- END RESTRAINING--
--------------------

--------------------
--    FRISKING    --
--------------------

gx, gy, wFriskItems, bFriskTakeItem, bFriskClose, gFriskItems, FriskColName = nil
function cfriskPlayer(button, state, x, y)
	if (button=="left") then
		destroyElement(wRightClick)
		wRightClick = nil
		
		local restrained = getElementData(player, "restrain")
		local injured = getElementData(player, "injuriedanimation")
		
		if restrained ~= 1 and not injured then
			outputChatBox("This player is not restrained or injured.", 255, 0, 0)
			hidePlayerMenu()
		elseif getElementHealth(getLocalPlayer()) < 50 then
			outputChatBox("You need at least half health to frisk someone.", 255, 0, 0)
			hidePlayerMenu()
		else
			gx = x
			gy = y
			triggerServerEvent("friskShowItems", getLocalPlayer(), player)
		end
	end
end

function friskShowItems(items)
	if wFriskItems then
		destroyElement( wFriskItems )
	end
	
	addEventHandler("onClientPlayerQuit", source, hidePlayerMenu)
	local playerName = string.gsub(getPlayerName(source), "_", " ")
	triggerServerEvent("sendLocalMeAction", getLocalPlayer(), getLocalPlayer(), "frisks " .. playerName .. ".")
	local width, height = 300, 200
	
	wFriskItems = guiCreateWindow(gx, gy, width, height, "Frisk: " .. playerName, false)
	guiSetText(wFriskItems, "Frisk: " .. playerName)
	guiWindowSetSizable(wFriskItems, false)
	
	gFriskItems = guiCreateGridList(0.05, 0.1, 0.9, 0.7, true, wFriskItems)
	FriskColName = guiGridListAddColumn(gFriskItems, "Name", 0.9)
	
	for k, v in ipairs(items) do
		local itemName = v[1] ~= 80 and exports.global:getItemName(v[1]) or v[2]
		local row = guiGridListAddRow(gFriskItems)
		guiGridListSetItemText(gFriskItems, row, FriskColName, tostring(itemName), false, false)
		guiGridListSetSortingEnabled(gFriskItems, false)
	end
	
	-- WEAPONS
	for i = 0, 12 do
		if (getPedWeapon(source, i)>0) then
			local ammo = getPedTotalAmmo(source, i)
			
			if (ammo>0) then
				local itemName = getWeaponNameFromID(getPedWeapon(source, i))
				local row = guiGridListAddRow(gFriskItems)
				guiGridListSetItemText(gFriskItems, row, FriskColName, tostring(itemName), false, false)
				guiGridListSetSortingEnabled(gFriskItems, false)
			end
		end
	end
	
	bFriskClose = guiCreateButton(0.05, 0.85, 0.9, 0.1, "Close", true, wFriskItems)
	addEventHandler("onClientGUIClick", bFriskClose, hidePlayerMenu, false)
end
addEvent("friskShowItems", true)
addEventHandler("friskShowItems", getRootElement(), friskShowItems)
--------------------
--  END FRISKING  --
--------------------

function caddFriend()
	triggerServerEvent("addFriend", getLocalPlayer(), player)
	hidePlayerMenu()
end

function cremoveFriend()
	triggerServerEvent("social:remove", getLocalPlayer(), getElementData(player, "account:id"))
	hidePlayerMenu()
end

function hidePlayerMenu()
	if (isElement(bAddAsFriend)) then
		destroyElement(bAddAsFriend)
	end
	bAddAsFriend = nil
	
	if (isElement(bCloseMenu)) then
		destroyElement(bCloseMenu)
	end
	bCloseMenu = nil

	if (isElement(wRightClick)) then
		destroyElement(wRightClick)
	end
	wRightClick = nil

	if (isElement(wFriskItems)) then
		destroyElement(wFriskItems)
	end
	wFriskItems = nil
	
	ax = nil
	ay = nil
	
	description = nil
	age = nil
	weight = nil
	height = nil
	
	if player then
		removeEventHandler("onClientPlayerQuit", player, hidePlayerMenu)
	end
	
	sent = false
	player = nil
	
	showCursor(false)
end

function checkMenuWasted()
	if source == getLocalPlayer() or source == player then
		hidePlayerMenu()
	end
end

addEventHandler("onClientPlayerWasted", getRootElement(), checkMenuWasted)