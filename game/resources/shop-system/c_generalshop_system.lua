wGeneralshop, iClothesPreview  = nil

shop = nil
shop_type = nil

-- returns [item index in current shop], [actual item]
function getSelectedItem( grid )
	if grid then
		local row, col = guiGridListGetSelectedItem( grid )
		if row > -1 and col > -1 then
			local index = tonumber( guiGridListGetItemData( grid, row, 1 ) ) -- 1 = cName
			if index then
				local item = getItemFromIndex( shop_type, index )
				return index, item
			end
		end
	end
end

-- creates a shop window, hooray.
function showGeneralshopUI(shop_type, race, gender, discount)
	local ped = source
	if (wGeneralshop==nil) then
		shop = g_shops[ shop_type ]

		if not shop or #shop == 0 then
			outputChatBox("This is no store. Go away.")
			return
		end
		_G['shop_type'] = shop_type
		updateItems( shop_type, race, gender ) -- should modify /shop/ too, as shop is a reference to g_shops[type].
		
		--setElementData(getLocalPlayer(), "exclusiveGUI", true, false)
		
		local screenwidth, screenheight = guiGetScreenSize()
		
		local Width = 500
		local Height = 350
		local X = (screenwidth - Width)/2
		local Y = (screenheight - Height)/2

		
		wGeneralshop = guiCreateWindow( X, Y, Width, Height, shop.name, false )

		local lInstruction = guiCreateLabel( 0, 20, 500, 15, "Double click on an item to buy it.", false, wGeneralshop )
		guiLabelSetHorizontalAlign( lInstruction,"center" )
		
		local lIntro = guiCreateLabel( 0, 40, 500, 15, shop.description, false, wGeneralshop )
		guiLabelSetHorizontalAlign( lIntro,"center" )
		guiBringToFront (lIntro)
		guiSetFont ( lIntro, "default-bold-small" )
		
		local iImage =  guiCreateStaticImage ( 400, 20, 90, 80,"images/" .. shop.image, false,wGeneralshop )
		
		
		tabpanel = guiCreateTabPanel ( 15, 60, 470, 240, false,wGeneralshop )
		-- create the tab panel with all shoppy items
		local counter = 1
		for _, category in ipairs( shop ) do
			local tab = guiCreateTab( category.name, tabpanel )
			local grid =  guiCreateGridList ( 0.02, 0.05, 0.96, 0.9, true, tab)
			
			local cName = guiGridListAddColumn( grid, "Name", 0.25 )
			local cPrice = guiGridListAddColumn( grid, "Price", 0.1 )
			local cDescription = guiGridListAddColumn( grid, "Description", 0.62 )
			
			local hasSkins = false
			for _, item in ipairs( category ) do
				local row = guiGridListAddRow( grid )
				guiGridListSetItemText( grid, row, cName, item.name, false, false )
				guiGridListSetItemData( grid, row, cName, tostring( counter ) )
				
				guiGridListSetItemText( grid, row, cPrice, "$" .. tostring(exports.global:formatMoney(math.ceil(discount * item.price))), false, false )
				guiGridListSetItemText( grid, row, cDescription, item.description or "", false, false )
				
				if item.itemID == 16 then
					hasSkins = true
				end
				
				counter = counter + 1
			end
			
			if hasSkins then -- event handler for skin preview
				addEventHandler( "onClientGUIClick", grid, function( button, state )
					if button == "left" then
						local index, item = getSelectedItem( source )
						
						if iClothesPreview then
							destroyElement(iClothesPreview)
							iClothesPreview = nil
						end
						
						if item.itemID == 16 then
							iClothesPreview = guiCreateStaticImage( 320, 20, 100, 100, ":account-system/img/" .. ("%03d"):format( item.itemValue or 1 ) .. ".png", false, source)
						end
					end
				end, false )
			end
			
			addEventHandler( "onClientGUIDoubleClick", grid, function( button, state )
				if button == "left" then
					local index, item = getSelectedItem( source )
					if index then
						triggerServerEvent( "shop:buy", ped, index )
					end
				end
			end, false )
		end
		
		guiSetInputEnabled(true)
		guiSetVisible(wGeneralshop, true)
		
		bClose = guiCreateButton(200, 315, 100, 25, "Close", false, wGeneralshop)
		addEventHandler( "onClientGUIClick", bClose, hideGeneralshopUI, false )
	end
end

addEvent("showGeneralshopUI", true )
addEventHandler("showGeneralshopUI", getResourceRootElement(), showGeneralshopUI)

function hideGeneralshopUI()
	setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
	guiSetInputEnabled(false)
	showCursor(false)
	destroyElement(wGeneralshop)
	wGeneralshop = nil
end
addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), function() if wGeneralshop ~= nil then hideGeneralshopUI() end end)
