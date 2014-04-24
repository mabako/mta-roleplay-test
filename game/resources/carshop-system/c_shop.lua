function carshop_showInfo(carPrice, taxPrice)
	outputChatBox("")
	outputChatBox("As you walk by the vehicle, you notice a card in the sidewindow. It reads the following:")
	--outputChatBox(" --------------------------------------")
	outputChatBox("| "..getVehicleNameFromModel( getElementModel( source ) ) )
	outputChatBox("| Now available for $"..exports.global:formatMoney(carPrice).."!" )
	outputChatBox("| Tax costs: $"..tostring(taxPrice) )
	--outputChatBox(" --------------------------------------")
	outputChatBox("Press F or Enter to buy this vehicle")
end
addEvent("carshop:showInfo", true)
addEventHandler("carshop:showInfo", getRootElement(), carshop_showInfo)

local gui, theVehicle = {}
function carshop_buyCar(carPrice, cashEnabled, bankEnabled)
	if gui["_root"] then
		return
	end
	
	theVehicle = source
	
	guiSetInputEnabled(true)
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 350, 190
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	gui["_root"] = guiCreateWindow(left, top, windowWidth, windowHeight, "Buy Vehicle", false)
	guiWindowSetSizable(gui["_root"], false)
		
	gui["lblText1"] = guiCreateLabel(10, 25, 320, 16, "You're about to buy the following vehicle:", false, gui["_root"])
	gui["lblVehicleName"] = guiCreateLabel(20, 45, 80, 13, getVehicleNameFromModel( getElementModel( source ) ), false, gui["_root"])
	gui["lblVehicleCost"] = guiCreateLabel(150, 45, 80, 13, "$ "..tostring(carPrice), false, gui["_root"])
	
	gui["lblText2"] = guiCreateLabel(10, 75, 320, 70, "You can confirm the payment by clicking on one of the\nfollowing buttons in the bottom of the screen. With\nclicking on a payment button, you agree that a refund\nis not possible. Thanks for choosing us!", false, gui["_root"])
	
	gui["btnCash"] = guiCreateButton(10, 145, 105, 41, "Pay by cash", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["btnCash"], carshop_buyCar_click, false)
	guiSetEnabled(gui["btnCash"], cashEnabled)
	
	gui["btnBank"] = guiCreateButton(120, 145, 105, 41, "Pay by bank", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["btnBank"], carshop_buyCar_click, false)
	guiSetEnabled(gui["btnBank"], bankEnabled)
	
	gui["btnCancel"] = guiCreateButton(232, 145, 105, 41, "Cancel", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["btnCancel"], carshop_buyCar_close, false)
end
addEvent("carshop:buyCar", true)
addEventHandler("carshop:buyCar", getRootElement(), carshop_buyCar)

function carshop_buyCar_click()
	if exports.global:hasSpaceForItem(getLocalPlayer(), 3, 1) then
		local sourcestr = "cash"
		if (source == gui["btnBank"]) then
			sourcestr = "bank"
		end
		triggerServerEvent("carshop:buyCar", theVehicle, sourcestr)
	else
		outputChatBox("You don't have space in your inventory for a key", 0, 255, 0)
	end
	carshop_buyCar_close()
end


function carshop_buyCar_close()
	destroyElement(gui["_root"])
	gui = { }
	guiSetInputEnabled(false)
end

local myadminWindow = nil

function carGrid (shops)
	if (myadminWindow == nil) then
		guiSetInputEnabled(true)
		local screenx, screeny = guiGetScreenSize()
		myadminWindow = guiCreateWindow ((screenx-700)/2, (screeny-500)/3, 700, 500, "Index of car prices", false)
		local tabPanel = guiCreateTabPanel (0, 0.1, 1, 1, true, myadminWindow)
		local lists = {}
		local tlBackButton = guiCreateButton(0.8, 0.05, 0.2, 0.07, "Close", true, myadminWindow) -- close button
		
		for int, carshop in ipairs(shops) do
			local modelsSpawned = { }
			for spotIndex, spawnPoint in ipairs(carshop["spawnpoints"]) do
				if spawnPoint["vehicle"] and isElement(spawnPoint["vehicle"]) then
					table.insert( modelsSpawned,  getElementModel(spawnPoint["vehicle"]), true)
				end
			end
			local tab = guiCreateTab(carshop["name"], tabPanel)
			lists[int] = guiCreateGridList(0.02, 0.02, 0.96, 0.96, true, tab) -- commands for level one admins 
			guiGridListAddColumn (lists[int], "Name", 0.15)
			guiGridListAddColumn (lists[int], "Price", 0.35)
			guiGridListAddColumn (lists[int], "Remarks", 1.3)
			
			for id, carDetails in ipairs(carshop["prices"]) do
				local row = guiGridListAddRow ( lists[int] )
				local remark = ""
				local carModel = getVehicleModelFromName(carDetails[1]) or -1
				if (modelsSpawned[carModel]) then
					remark = " - Spawned"
				end
				guiGridListSetItemText ( lists[int], row, 1, carDetails[1] .. "(" .. tostring(carModel) .. ")", false, false)
				guiGridListSetItemText ( lists[int], row, 2, carDetails[2], false, false)
				guiGridListSetItemText ( lists[int], row, 3, carDetails[3] and "Secondhand" or "Brand new"..remark, false, false)
			end
		end
		addEventHandler ("onClientGUIClick", tlBackButton, function(button, state)
			if (button == "left") then
				if (state == "up") then
					guiSetVisible(myadminWindow, false)
					showCursor (false)
					guiSetInputEnabled(false)
					myadminWindow = nil
				end
			end
		end, false)
		
		guiBringToFront (tlBackButton)
		guiSetVisible (myadminWindow, true)
	else
		local visible = guiGetVisible (myadminWindow)
		if (visible == false) then
			guiSetVisible( myadminWindow, true)
			showCursor (true)
		else
			showCursor(false)
		end
	end
end
addEvent("carshop:cargrid", true)
addEventHandler("carshop:cargrid", getRootElement(), carGrid)