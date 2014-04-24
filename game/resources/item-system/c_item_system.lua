wItems, gItems, gKeys, colSlot, colName, colValue, items, lDescription, bDropItem, bUseItem, bShowItem, bDestroyItem, tabPanel, tabItems, tabWeapons = nil
gWeapons, colWSlot, colWName, colWValue = nil

wRightClick = nil
bPickup, bToggle, bPreviousTrack, bNextTrack, bCloseMenu = nil
ax, ay = nil
item = nil
showinvPlayer = nil
setElementData( getLocalPlayer(), "exclusiveGUI", false, false ) -- setting this to false prevents possible problems with fridge/shelf inv. 

showFood = true
showKeys = true
showDrugs = true
showOther = true
showBooks = true
showClothes = true
showElectronics = true
showEmpty = true
activeTab = 1

-- PLEASE WAIT window
local sx, sy = guiGetScreenSize( )
wWait = guiCreateButton( ( sx - 200 ) / 2, ( sy - 60 ) / 2, 200, 60, "Please wait a moment...", false )
guiSetEnabled( wWait, false )
guiSetVisible( wWait, false )
guiSetProperty( wWait, "AlwaysOnTop", "True" )

--[[function clickItem(button, state, absX, absY, x, y, z, element)
	if (button == "right") and (state=="down") then
		if getElementData(getLocalPlayer(), "exclusiveGUI") then
			return
		end
		
		local px, py, pz = getElementPosition(getLocalPlayer())
		if element and (getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("map-system")) or getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("interior-system"))) then
			element = nil
		end
		
		if not element then
			local wx, wy, wz = x, y, z
			local x, y, z = nil
			for key, value in ipairs(getElementsByType("object",getResourceRootElement())) do
				if isElementStreamedIn(value) then
					x, y, z = getElementPosition(value)
					local minx, miny, minz, maxx, maxy, maxz = getElementBoundingBox(value)
					
					local offset = 0.34
					
					minx = x + minx - offset
					miny = y + miny - offset
					minz = z + minz - offset
					
					maxx = x + maxx + offset
					maxy = y + maxy + offset
					maxz = z + maxz + offset
					
					local dist = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
					
					if (wx >= minx and wx <=maxx) and (wy >= miny and wy <=maxy) and (wz >= minz and wz <=maxz) then
						element = value
						break
					end
				end
			end
		end
			
		if element and getElementParent(getElementParent(element)) == getResourceRootElement() then
			if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 3 then
				if (wRightClick) then
					hideItemMenu()
				end
				ax = absX
				ay = absY
				item = element
				showItemMenu()
			else
				outputChatBox("You are too far away from that item.", 255, 0, 0)
			end
		else
			if (wRightClick) then
				hideItemMenu()
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickItem, true)]]

function showItemMenu()
	local itemID = getElementData(item, "itemID")
	local itemValue = getElementData(item, "itemValue") or 1
	local itemName = getItemName( itemID, itemValue )
	
	if itemID ~= 80 then
		itemName = itemName .. " (" .. getItemValue( itemID, itemValue ) .. ")"
	end
	wRightClick = guiCreateWindow(ax, ay, 150, 200, itemName, false)
	
	local y = 0.13
	if itemID == 81 or itemID == 103 then
		bPickup = guiCreateButton(0.05, y, 0.9, 0.1, "Open", true, wRightClick)
		addEventHandler("onClientGUIClick", bPickup,
			function(button)
				if button=="left" and not getElementData(localPlayer, "exclusiveGUI") then
					triggerServerEvent( "openFreakinInventory", getLocalPlayer(), item, ax, ay )
					hideItemMenu()
				end
			end,
			false
		)
	else
		bPickup = guiCreateButton(0.05, y, 0.9, 0.1, "Pick Item Up", true, wRightClick)
		addEventHandler("onClientGUIClick", bPickup, pickupItem, false)
	end
	y = y + 0.14
	
	if itemID == 54 then
		-- Ghettoblaster
		if itemValue > 0 then
			bToggle = guiCreateButton(0.05, y, 0.9, 0.1, "Turn Off", true, wRightClick)
			
			y = y + 0.14
			
			bPreviousTrack = guiCreateButton(0.05, y, 0.42, 0.1, "Previous", true, wRightClick)
			addEventHandler("onClientGUIClick", bPreviousTrack, function() triggerServerEvent("changeGhettoblasterTrack", getLocalPlayer(), item, -1) end, false)
			
			bNextTrack = guiCreateButton(0.53, y, 0.42, 0.1, "Next", true, wRightClick)
			addEventHandler("onClientGUIClick", bNextTrack, function() triggerServerEvent("changeGhettoblasterTrack", getLocalPlayer(), item, 1) end, false)
		else
			bToggle = guiCreateButton(0.05, y, 0.9, 0.1, "Turn On", true, wRightClick)
		end
		addEventHandler("onClientGUIClick", bToggle, toggleGhettoblaster, false)
	
		y = y + 0.14
	end
	
	bCloseMenu = guiCreateButton(0.05, y, 0.9, 0.1, "Close Menu", true, wRightClick)
	addEventHandler("onClientGUIClick", bCloseMenu, hideItemMenu, false)
end

function hideItemMenu()
	if (isElement(bPickup)) then
		destroyElement(bPickup)
	end
	bPickup = nil

	if (isElement(bToggle)) then
		destroyElement(bToggle)
	end
	bToggle = nil

	if (isElement(bPreviousTrack)) then
		destroyElement(bPreviousTrack)
	end
	bPreviousTrack = nil

	if (isElement(bNextTrack)) then
		destroyElement(bNextTrack)
	end
	bNextTrack = nil

	if (isElement(bCloseMenu)) then
		destroyElement(bCloseMenu)
	end
	bCloseMenu = nil

	if (isElement(wRightClick)) then
		destroyElement(wRightClick)
	end
	wRightClick = nil
	
	ax = nil
	ay = nil

	item = nil

	showCursor(false)
	triggerEvent("cursorHide", getLocalPlayer())
end

function updateMenu(dataname)
	if source == item and dataname == "itemValue" and getElementData(source, "itemID") == 54 then -- update the track while you're in menu
		guiSetText(wRightClick, "GHETTOBLASTER (" .. (getElementData(source, "itemValue") or 1) .. ")")
	end
end
addEventHandler("onClientElementDataChange", getRootElement(), updateMenu)

function toggleGhettoblaster(button, state, absX, absY, step)
	triggerServerEvent("toggleGhettoblaster", getLocalPlayer(), item)
	hideItemMenu()
end

local fp = -100
addCommandHandler("itemprotect",
	function(command, f)
		fp = tonumber(f) or -100
		outputChatBox("Protect set to faction: " .. ( fp == -100 and "admins only" or tostring(fp)))
	end
)
function pickupItem(button, state, item)
	if (button=="left") then
		local restrain = getElementData(getLocalPlayer(), "restrain")
		
		if (restrain) and (restrain==1) then
			outputChatBox("You are cuffed.", 255, 0, 0)
		elseif getElementData(item, "itemID") > 0 and not hasSpaceForItem(getLocalPlayer(), getElementData(item, "itemID"), getElementData(item, "itemValue")) then
			outputChatBox("Your Inventory is full.", 255, 0, 0)
		elseif isElement(item) then
			if wRightClick then
				showCursor(false)
				triggerEvent("cursorHide", getLocalPlayer())
			end
			
			if getKeyState("p") and exports.global:isPlayerAdmin(getLocalPlayer()) then
				triggerServerEvent("protectItem", item, fp)
			else
				triggerServerEvent("pickupItem", getLocalPlayer(), item)
			end
			if wRightClick then
				hideItemMenu()
			end
		end
	end
end
	
function toggleCategory()
	-- let's add the items again
	if (isElement(gItems)) then
		guiGridListClear(gItems)
	end
	
	if (isElement(gKeys)) then
		guiGridListClear(gKeys)
	end
	
	if (isElement(gWeapons)) then
		guiGridListClear(gWeapons)
	end
	
	local items = getItems( showinvPlayer )
	
	local tabs = {gItems, gKeys, gWeapons}
	for i,v in ipairs(items) do
		local itemid = v[1]
		local itemvalue = v[2]
		local tab = tabs[getItemTab(itemid)]
		local row = guiGridListAddRow(tab)
		guiGridListSetItemText(tab, row, colSlot, tostring(row+1), false, true)
		guiGridListSetItemData(tab, row, colSlot, tostring(i))
		guiGridListSetItemText(tab, row, colName, tostring(getItemName(itemid, itemvalue)), false, false)
		guiGridListSetItemText(tab, row, colValue, tostring(getItemValue(itemid, itemvalue)), false, false)
		guiGridListSetItemData(tab, row, colValue, tostring(itemvalue))
	end
end

function toggleInventory()
	if wItems and guiGetEnabled( wItems ) then
		hideInventory()
	end
end
bindKey("i", "down", toggleInventory)

function copyClipboard()
	local row, col = guiGridListGetSelectedItem(source)
	local text = guiGridListGetItemData(source, row, colValue)
	if setClipboard(text) then
		outputChatBox("Copied '" .. text .. "' to clipboard.")
	else
		outputChatBox("Failed copying '" .. text .. "' to clipboard.")
	end
end

function showInventory(player)
	if not (wChemistrySet) then
		showinvPlayer = player
		if wItems then
			hideInventory()
		end
		if getElementData(getLocalPlayer(), "exclusiveGUI") then
			return
		end
		setElementData(getLocalPlayer(), "exclusiveGUI", true, false)
		local width, height = 600, 500
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)
		
		local title = "Inventory"
		if player ~= getLocalPlayer() then
			title = title .. " of " .. getPlayerName(player)
		end
		wItems = guiCreateWindow(x, y, width, height, title, false)
		guiWindowSetSizable(wItems, false)
		
		tabPanel = guiCreateTabPanel(0.025, 0.05, 0.95, 0.7, true, wItems)
		tabItems = guiCreateTab("Items", tabPanel)
		tabKeys = guiCreateTab("Keys", tabPanel)
		tabWeapons = guiCreateTab("Weapons", tabPanel)
		
		if activeTab == 1 then
			guiSetSelectedTab(tabPanel, tabItems)
		elseif activeTab == 2 then
			guiSetSelectedTab(tabPanel, tabKeys)
		else
			guiSetSelectedTab(tabPanel, tabWeapons)
		end
		
		addEventHandler( "onClientGUITabSwitched", tabPanel,
			function( tab )
				if tab == tabItems then
					activeTab = 1
				elseif tab == tabKeys then
					activeTab = 2
				elseif tab == tabWeapons then
					activeTab = 3
				end
			end,
			false )
		
		-- ITEMS
		gItems = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabItems)
		addEventHandler("onClientGUIClick", gItems, showDescription, false)
		addEventHandler("onClientGUIDoubleClick", gItems, copyClipboard, false)
		
		colSlot = guiGridListAddColumn(gItems, "Slot", 0.1)
		colName = guiGridListAddColumn(gItems, "Name", 0.225)
		colValue = guiGridListAddColumn(gItems, "Value", 0.625)
		
		-- keys
		gKeys = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabKeys)
		addEventHandler("onClientGUIClick", gKeys, showDescription, false)
		addEventHandler("onClientGUIDoubleClick", gKeys, copyClipboard, false)
	
		colSlot = guiGridListAddColumn(gKeys, "Slot", 0.1)
		colName = guiGridListAddColumn(gKeys, "Name", 0.625)
		colValue = guiGridListAddColumn(gKeys, "Value", 0.225)

		-- WEAPONS
		gWeapons = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabWeapons)
		addEventHandler("onClientGUIClick", gWeapons, showDescription, false)
		addEventHandler("onClientGUIDoubleClick", gWeapons, copyClipboard, false)
		
		colWSlot = guiGridListAddColumn(gWeapons, "Slot", 0.1)
		colWName = guiGridListAddColumn(gWeapons, "Name", 0.225)
		colWValue = guiGridListAddColumn(gWeapons, "Ammo", 0.625)
		
		-- GENERAL
		lDescription = guiCreateLabel(0.025, 0.87, 0.95, 0.1, "Click an item to see it's description.", true, wItems)
		guiLabelSetHorizontalAlign(lDescription, "center", true)
		guiSetFont(lDescription, "default-bold-small")
		
		bClose = guiCreateButton(0.375, 0.91, 0.2, 0.15, "Close Inventory", true, wItems)
		addEventHandler("onClientGUIClick", bClose, hideInventory, false)
		
		source = nil
		toggleCategory()
		showCursor(true)
	end
end
addEvent("showInventory", true)
addEventHandler("showInventory", getRootElement(), showInventory)

function hideInventory()
	colSlot = nil
	colName = nil
	colValue = nil
	
	colWSlot = nil
	colWName = nil
	colWValue = nil
	
	if wItems then
		destroyElement(wItems)
	end
	wItems = nil
	
	showCursor(false)
	setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
	
	hideNewInventory()
end
addEvent("hideInventory", true)
addEventHandler("hideInventory", getRootElement(), hideInventory)

function showDescription(button, state)
	if (button=="left") then
		if (guiGetSelectedTab(tabPanel)==tabItems or guiGetSelectedTab(tabPanel)==tabKeys) then -- ITEMS
			local row, col = guiGridListGetSelectedItem(guiGetSelectedTab(tabPanel) == tabKeys and gKeys or gItems)
			
			if (row==-1) or (col==-1) then
				guiSetText(lDescription, "Click an item to see it's description.")
			else
				local slot = tonumber(guiGridListGetItemData(guiGetSelectedTab(tabPanel) == tabKeys and gKeys or gItems, row, 1))
				local items = getItems(showinvPlayer)
				if not items[slot] then
					guiSetText(lDescription, "An empty slot.")
				else
					local desc = tostring( getItemDescription( items[slot][1], items[slot][2] ) )
					local value = items[slot][2]
					
					-- percent operators
					desc = string.gsub((desc), "#v", tostring(value))
					
					if (desc=="A Dictionary.") then
						local res = getResourceFromName("language-system")
						local lang = call(res, "getLanguageName", tonumber(value))
						desc = "A " .. lang .. " dictionary."
					end
					
					guiSetText(lDescription, desc)
				end
			end
		elseif (guiGetSelectedTab(tabPanel)==tabWeapons) then -- WEAPONS
			local row, col = guiGridListGetSelectedItem(gWeapons)
			if (row==-1) or (col==-1) then
				guiSetText(lDescription, "Click an item to see it's description.")
			else
				local name = tostring(guiGridListGetItemText(gWeapons, row, 2))
				local ammo = tostring(guiGridListGetItemText(gWeapons, row, 3))
				local desc = "A " .. name .. " with " .. ammo .. " ammunition."
					
				guiSetText(lDescription, desc)
			end
		end
	end
end

function useItem(itemSlot)
--function useItem(button)
	showinvPlayer = getLocalPlayer()
	if getElementHealth(getLocalPlayer()) == 0 then return end
	local x, y, z = getElementPosition(getLocalPlayer())
	local groundz = getGroundPosition(x, y, z)
	if itemSlot > 0 then -- ITEMS
		local itemID = getItems( showinvPlayer )[itemSlot][1]
		local itemName = getItemName( itemID )
		local itemValue = getItems( showinvPlayer )[itemSlot][2]
		local additional = nil
		
		if (itemID==2) then -- cellphone
			hideInventory()
			triggerServerEvent("phone:requestShowPhoneGUI", getLocalPlayer(), tostring(itemValue))
			return
		elseif (itemID==6) then -- radio
			outputChatBox("Press Y to use this item. You can also use /tuneradio to tune your radio.", 255, 194, 14)
			return
		elseif (itemID==7) then -- phonebook
			outputChatBox("Use /phonebook to use this item.", 255, 194, 14)
			return
		elseif (itemID==18) then -- City Guide
			triggerEvent( "showCityGuide", getLocalPlayer( ) )
			return
		elseif (itemID==19) then -- MP3 PLayer
			if isPedInVehicle(getLocalPlayer()) or getElementData(getLocalPlayer(), "fishing") or getElementData(getLocalPlayer(), "jammed") then
				outputChatBox("Use the - and = keys to use the MP3 Player.", 255, 194, 14)
			else
				exports['realism-system']:toggleMP3("=", "down")
			end			return
		elseif (itemID==27) then -- Flashbang
			local x, y, z = getElementPosition(getLocalPlayer( ))
			local rot = getPedRotation(getLocalPlayer( ))
			x = x + math.sin(math.rad(-rot)) * 10
			y = y + math.cos(math.rad(-rot)) * 10
			z = getGroundPosition(x, y, z + 2)
			additional = { x, y, z }
		elseif (itemID==28 or itemID==54) then -- Glowstick or Ghettoblaster
			local x, y, z = getElementPosition(getLocalPlayer( ))
			local rot = getPedRotation(getLocalPlayer( ))
			x = x + math.sin(math.rad(-rot)) * 2
			y = y + math.cos(math.rad(-rot)) * 2
			z = getGroundPosition(x, y, z)
			additional = { x, y, z - 0.5 }
		elseif (itemID==30) or (itemID==31) or (itemID==32) or (itemID==33) then
			outputChatBox("Use the chemistry set purchasable from 24/7 to use this item.", 255, 0, 0)
			return
		elseif (itemID==34) then -- COCAINE
			doDrug1Effect()
		elseif (itemID==35) then
			doDrug2Effect()
		elseif (itemID==36) then
			doDrug3Effect()
		elseif (itemID==37) then
			doDrug4Effect()
		elseif (itemID==38) then
			if not getPedOccupiedVehicle(getLocalPlayer()) then
				doDrug5Effect()
			end
		elseif (itemID==39) then
			doDrug6Effect()
		elseif (itemID==40) then
			doDrug3Effect()
			doDrug1Effect()
		elseif (itemID==41) then
			doDrug4Effect()
			doDrug6Effect()
		elseif (itemID==42) then
			if not getPedOccupiedVehicle(getLocalPlayer()) then
				doDrug5Effect()
				doDrug2Effect()
			end
		elseif (itemID==43) then
			doDrug4Effect()
			doDrug1Effect()
			doDrug6Effect()
		elseif (itemID==44) then
			hideInventory()
			showChemistrySet()
			return
		elseif (itemID==45) or (itemID==46) or (itemID==47) or (itemID==66) then
			outputChatBox("Right click a player to use this item.", source, 255, 0, 0)
			return
		elseif (itemID==48) then
			outputChatBox("Your inventory is extended.", 0, 255, 0)
			return
		elseif (itemID==50) or (itemID==51) or (itemID==52) then
			hideInventory()
		elseif (itemID==53) then -- Breathalizer
			outputChatBox("Use /breathtest to use this item.", 255, 194, 15)
			return
		elseif (itemID==57) then -- FUEL CAN
			hideInventory()
		elseif (itemID==58) then
			setTimer(
				function()
					setElementData(getLocalPlayer(), "alcohollevel", ( getElementData(getLocalPlayer(), "alcohollevel") or 0 ) + 0.1, false)
				end, 15000, 1
			)
		elseif (itemID==61) then -- Emergency Light Becon
			outputChatBox("Put it in your car inventory and press 'P' to toggle it.", 255, 194, 14)
			return
		elseif (itemID==62) then
			setTimer(
				function()
					setElementData(getLocalPlayer(), "alcohollevel", ( getElementData(getLocalPlayer(), "alcohollevel") or 0 ) + 0.3, false)
				end, 5000, 1
			)
		elseif (itemID==63) then
			setTimer(
				function()
					setElementData(getLocalPlayer(), "alcohollevel", ( getElementData(getLocalPlayer(), "alcohollevel") or 0 ) + 0.2, false)
				end, 10000, 1
			)
		elseif (itemID==67) then -- GPS
			outputChatBox("Put it in your car inventory and Press 'F5'.", 255, 194, 14)
			return
		elseif (itemID==70) then -- First Aid Kit
			outputChatBox("Right click on a player who's knocked out to stabilize him.", 255, 194, 14)
			return
		elseif (itemID==71) then -- Notebook
			outputChatBox("Use /writenote [text] to write a note. There are " .. itemValue .. " pages left.", 255, 194, 14)
			return
		elseif (itemID==72) then -- Note
			outputChatBox("The Note reads: " .. itemValue, 255, 194, 14)
		elseif (itemID==78) then
			outputChatBox("This San Andreas Pilot License was issued for " .. itemValue .. ".", 255, 194, 14)
			return
		elseif (itemID==81) then
			outputChatBox("Drop this Fridge in an Interior.", 255, 194, 14)
			return
		elseif (itemID==84) then
			outputChatBox("Put it in a car or carry it to know when police is around.", 255, 194, 14)
			return
		elseif (itemID==85) then -- Emergency Light Becon
			outputChatBox("Put it in your car inventory and press 'N' to toggle it.", 255, 194, 14)
			return
		elseif (itemID==91) then
			setTimer(
				function()
					setElementData(getLocalPlayer(), "alcohollevel", ( getElementData(getLocalPlayer(), "alcohollevel") or 0 ) + 0.35, false)
				end, 15000, 1
			)
		elseif (itemID==96) then
			hideInventory()
		elseif (itemID==103) then
			outputChatBox ( "Drop this shelf in an interior.", 255, 194, 14 )
			return
		elseif (itemID==111) then
			outputChatBox( "A personal GPS, shiny. Got the latest maps installed.", 255, 0, 0 )
			return
		elseif itemID == 115 or itemID == 116 then
			outputChatBox("This item is (part of) a weapon, you cannot use it with clicking on it. If you have all the parts needed, the gun will appear in your scrollmenu.", 255, 194, 14)
			return
		elseif itemID == 117 then
			outputChatBox("Please place this item into a vehicle, then control it over the vehicles right mouse button menu.", 255, 194, 14)
			return
		elseif (itemID==118) then
			outputChatBox( "Put it in your car and approach a toll booth.", 255, 194, 14 )
			return
		elseif itemID == 121 then
			outputChatBox("A heavy box full of supplies!", 255, 194, 14)
			return
		end

			
		triggerServerEvent("useItem", getLocalPlayer(), itemSlot, additional)
	else
		if itemSlot == -100 then
			outputChatBox("You wear Body Armor.", 0, 255, 0)
		else
			setPedWeaponSlot( getLocalPlayer(), -itemSlot )
		end
	end
end

function stopGasmaskDamage(attacker, weapon)
	local gasmask = getElementData(getLocalPlayer(), "gasmask")

	if (weapon==17 or weapon==41) and (gasmask) then
		cancelEvent()
	end
end
addEventHandler("onClientPlayerDamage", getLocalPlayer(), stopGasmaskDamage)

-- /itemlist (admin command to get item IDs)
wItemList, bItemListClose = nil

function showItemList()
	if getElementData(getLocalPlayer(), "adminlevel") == 0 then
		return
	end
	if not (wItemsList) then
		wItemsList = guiCreateWindow(0.15, 0.15, 0.7, 0.7, "Items List", true)
		local gridItems = guiCreateGridList(0.025, 0.1, 0.95, 0.775, true, wItemsList)
		
		local colID = guiGridListAddColumn(gridItems, "ID", 0.1)
		local colName = guiGridListAddColumn(gridItems, "Item Name", 0.3)
		local colDesc = guiGridListAddColumn(gridItems, "Description", 0.6)
		
		for key, value in pairs(g_items) do
			if key ~= 74 and key ~= 75 then
				local row = guiGridListAddRow(gridItems)
				guiGridListSetItemText(gridItems, row, colID, tostring(key), false, true)
				guiGridListSetItemText(gridItems, row, colName, value[1], false, false)
				guiGridListSetItemText(gridItems, row, colDesc, value[2], false, false)
			end
		end

		bItemListClose = guiCreateButton(0.025, 0.9, 0.95, 0.1, "Close", true, wItemsList)
		addEventHandler("onClientGUIClick", bItemListClose, closeItemsList, false)
		
		showCursor(true)
	else
		guiSetVisible(wItemsList, true)
		guiBringToFront(wItemsList)
		showCursor(true)
	end
end
addCommandHandler("itemlist", showItemList)

function closeItemsList(button, state)
	if (source==bItemListClose) and (button=="left") and (state=="up") then
		showCursor(false)
		destroyElement(bItemListClose)
		destroyElement(wItemsList)
		bItemListClose = nil
		wItemsList = nil
	end
end

addEventHandler("onClientChangeChar", getRootElement(), hideInventory)

local function updateInv()
	if wItems and source == showinvPlayer then
		source = nil
		setTimer(toggleCategory, 50, 1)
	end
end
addEventHandler("recieveItems", getRootElement(), updateInv)

addEvent("finishItemDrop", true)
addEventHandler("finishItemDrop", getLocalPlayer(),
	function( )
		if wItems then
			guiSetVisible( wWait, false )
			guiSetEnabled( wItems, true )
		end
	end
)

--
-- Scuba Gear
--
addEventHandler( "onClientPlayerDamage", localPlayer,
	function( attacker, weapon )
		if weapon == 53 and getElementData( source, "scuba" ) then
			cancelEvent( )
		end
	end
)

--
-- Carried items weight.
--
addCommandHandler("carried",
	function( command, detailed )
		outputChatBox( ("%.2f/%.2f" ):format( getCarriedWeight( localPlayer ), getMaxWeight( localPlayer ) ) )
		if detailed == "detailed" then
			for k, v in ipairs( getItems( localPlayer ) ) do
				outputChatBox( "  %.2f %s; %s", getItemWeight( v[1], v[2] ), getItemName( v[1], v[2] ), getItemDescription( v[1], v[2] ) )
			end
		end
	end
)

--
-- are we watching TV?
--
function isWatchingTV()
	return exports['freecam-tv']:isFreecamEnabled()
end
