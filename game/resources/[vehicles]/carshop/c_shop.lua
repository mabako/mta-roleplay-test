function carshop_showInfo(carPrice, taxPrice, name)
	outputChatBox("")
	outputChatBox("As you walk by the vehicle, you notice a card in the sidewindow. It reads the following:")
	--outputChatBox(" --------------------------------------")
	outputChatBox("| " .. name.year .. ' ' .. name.brand .. ' ' .. name.name)
	outputChatBox("| Now available for $"..exports.global:formatMoney(carPrice).."!" )
	outputChatBox("| Tax costs: $"..tostring(taxPrice) )
	--outputChatBox(" --------------------------------------")
	outputChatBox("Press F or Enter to buy this vehicle")
end
addEvent("carshop:showInfo", true)
addEventHandler("carshop:showInfo", resourceRoot, carshop_showInfo)

local gui, theVehicle = {}
function carshop_buyCar(carPrice, cashEnabled, bankEnabled, name)
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
	gui["lblVehicleName"] = guiCreateLabel(20, 45, 200, 13, name.year .. ' ' .. name.brand .. ' ' .. name.name, false, gui["_root"])
	gui["lblVehicleCost"] = guiCreateLabel(240, 45, 80, 13, "$"..exports.global:formatMoney(carPrice), false, gui["_root"])
	
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
