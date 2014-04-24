-- Configuration
local background_color = tocolor( 0, 0, 0, 127 )
local background_error_color = tocolor( 255, 0, 0, 127 )
local background_movetoelement_color = tocolor( 127, 127, 255, 63 )
local empty_color = tocolor( 127, 127, 127, 10 )
local full_color = tocolor( 255, 255, 255, 10 )
local tooltip_text_color = tocolor( 255, 255, 255, 255 )
local tooltip_background_color = tocolor( 0, 0, 0, 190 )
local active_tab_color = tocolor( 127, 255, 127, 127 )

--

local rows = 5

local box = 80
local spacer = 10
local sbox = spacer + box

local sx, sy = guiGetScreenSize()

local localPlayer = getLocalPlayer( )

local inventory = false -- elements to display
local show = false -- defines wherever to show the inventory or not
local useHQimages = nil

--

local clickDown = false
waitingForItemDrop = false
local hoverElement = false

local hoverItemSlot = false
local clickItemSlot = false

local hoverWorldItem = false
local clickWorldItem = false

local TAB_ITEMS, TAB_KEYS, TAB_WEAPONS = 1, 2, 3
local ACTION_DROP, ACTION_SHOW, ACTION_DESTROY = 10, 11, 12

local isCursorOverInventory = false
local activeTab = TAB_ITEMS
local activeTabItem = nil
local hoverAction = false
local actionIcons =
{
	[TAB_ITEMS] = { 48, tocolor( 255, 255, 127, 63 ), "Items" },
	[TAB_KEYS] = { 4, tocolor( 255, 255, 127, 63 ), "Keys" },
	[TAB_WEAPONS] = { -28, tocolor( 255, 255, 127, 63 ), "Weapons" },
	
	[ACTION_DROP] = { -202, tocolor( 127, 255, 127, 63 ), "Drop Item", "Press CTRL while selecting an item to automatically drop it." },
	[ACTION_SHOW] = { -201, tocolor( 127, 127, 255, 63 ), "Show Item" },
	[ACTION_DESTROY] = { -200, tocolor( 255, 127, 127, 63 ), "Destroy Item", "Press DELETE while selecting an item to automatically delete it." }
}

local savedArmor = false
local rotate = false

--

local function getHoverElement( resource, force )
	if isWatchingTV() and not force then
		return
	end
	local cursorX, cursorY, absX, absY, absZ = getCursorPosition( )
	local cameraX, cameraY, cameraZ = getWorldFromScreenPosition( cursorX, cursorY, 0.1 )
	local a, b, c, d, element = processLineOfSight( cameraX, cameraY, cameraZ, absX, absY, absZ )
	if element and getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName(resource or "item-world")) then
		return element
	elseif b and c and d and not resource then
		element = nil
		local x, y, z = nil
		local maxdist = 0.34
		for key, value in ipairs(getElementsByType("object",getResourceRootElement(getResourceFromName(resource or "item-world")))) do
			if isElementStreamedIn(value) and isElementOnScreen(value) then
				x, y, z = getElementPosition(value)
				local dist = getDistanceBetweenPoints3D(x, y, z, b, c, d)
				
				if dist < maxdist then
					element = value
					maxdist = dist
				end
			end
		end
		if element then
			local px, py, pz = getElementPosition( localPlayer )
			return getDistanceBetweenPoints3D( px, py, pz, getElementPosition( element ) ) < 10 and element
		end
	end
end

local tooltipYet = false
local function tooltip( x, y, text, text2 )
	tooltipYet = true
	
	text = tostring( text )
	if text2 then
		text2 = tostring( text2 )
	end
	
	if text == text2 then
		text2 = nil
	end
	
	local width = dxGetTextWidth( text, 1, "clear" ) + 20
	if text2 then
		width = math.max( width, dxGetTextWidth( text2, 1, "clear" ) + 20 )
		text = text .. "\n" .. text2
	end
	local height = 10 * ( text2 and 5 or 3 )
	x = math.max( 10, math.min( x, sx - width - 10 ) )
	y = math.max( 10, math.min( y, sy - height - 10 ) )
	
	dxDrawRectangle( x, y, width, height, tooltip_background_color, true )
	dxDrawText( text, x, y, x + width, y + height, tooltip_text_color, 1, "clear", "center", "center", false, false, true )
end

local function isInBox( x, y, xmin, xmax, ymin, ymax )
	return x >= xmin and x <= xmax and y >= ymin and y <= ymax
end

local function getImage( itemID, itemValue )
	if itemID == 16 then -- Clothes
		return ":account-system/img/" .. ("%03d"):format(itemValue) .. ".png"
	elseif itemID == 115 then -- Weapon
		local itemValueExploded = explode(':', itemValue)
		return "images/-" .. itemValueExploded[1] .. ".png"
	else
		return "images/" .. itemID .. ".png"
	end
end

local function counterIDHelper( itemID, itemValue )
	if itemID == 16 then
		return -100-(tonumber(itemValue) or 0)
	elseif itemID == 115 then
		return -(tonumber(explode(':', itemValue)[1]) or 0)
	elseif itemID == 116 then
		return -50-(tonumber(explode(':', itemValue)[1]) or 0)
	else
		return itemID
	end
end

local function getOverlayText( itemID, itemValue, isGrouped )
	local v = tostring(itemValue)
	local text = nil
	if itemID == 115 then
		text = getItemName( itemID, v )
	elseif itemID == 116 then
		local s = explode(':', v)
		text = isGrouped and "" or ( s[2] .. " " )
		text = text .. s[3]:gsub("Ammo for ", "") .. " Ammo"
	end
	
	if isGrouped then
		text = isGrouped .. "x\n" .. ( text or "" )
	elseif itemID == 72 or itemID == 80 then
		text = v:sub( 1, 35 ) .. ( #v > 35 and "..." or "")
	elseif itemID == 71 then
		text = tostring(v)
	end
	return text or ""
end

local function getTooltipFor( itemID, itemValue, isGrouped )
	local name, x = getItemName( itemID, itemValue )
	local desc = getItemDescription( itemID, getItemValue( itemID, itemValue ) )
	
	if x then
		name = g_items[itemID][1]
		desc = x
	end
	
	if itemID == 80 and isGrouped then
		return isGrouped .. " Generic Items", ""
	end
	
	if isGrouped then
		return isGrouped .. "x " .. name, "Click to show all of these items."
	end
	
	if itemValue and itemValue ~= 1 and #tostring(itemValue) > 0 and not g_items[itemID][2]:find("#v") and itemValue ~= itemName then -- if #v is there, it's put into the description already
		name = name .. " (" .. itemValue .. ")"
	end
	return name, desc
end

addEventHandler( "onClientRender", getRootElement( ),
	function( )
		hoverItemSlot = false
		hoverWorldItem = false
		hoverAction = false
		isCursorOverInventory = false
		hoverElement = false
		tooltipYet = false
		
		if not isCursorShowing( ) and clickWorldItem then
			hideNewInventory( )
		elseif not guiGetInputEnabled( ) and not isMTAWindowActive( ) and isCursorShowing( ) then
			local cursorX, cursorY, cwX, cwY, cwZ = getCursorPosition( )
			local cursorX, cursorY = cursorX * sx, cursorY * sy
			
			-- background
			if not inventory then
				local items = getItems( localPlayer )
				if items then
					inventory = {}
					local counters = {}
					
					local retry = false
					repeat
						if activeTabItem then
							retry = true
						else
							retry = false
						end
						
						for k, v in ipairs( items ) do
							if activeTabItem then
								if counterIDHelper(v[1], v[2]) == activeTabItem then
									inventory[ #inventory + 1 ] = { v[1], v[2], v[3], k, false }
								end
							elseif getItemTab( v[1] ) == activeTab then
								inventory[ #inventory + 1 ] = { v[1], v[2], v[3], k, false }
								counters[ counterIDHelper( v[1], v[2] ) ] = 1 + ( counters[ counterIDHelper( v[1], v[2] ) ] or 0 )
								retry = false
							end
						end
						
						if activeTabItem then
							if #inventory == 0 then
								activeTabItem = nil
							else
								retry = false
							end
						end
					until not retry
					
					if not activeTabItem and activeTab ~= 2 then
						-- remove all items that are here 3 times or more
						for id, occurs in pairs(counters) do
							if occurs >= 3 then
								local first = {-1, -1}
								for i = #inventory, 1, -1 do
									if counterIDHelper( inventory[i][1], inventory[i][2] ) == id then
										first = {inventory[i][1], inventory[i][2]}
										table.remove( inventory, i )
									end
								end
								inventory[ #inventory + 1 ] = { first[1], first[2], nil, nil, occurs }
							end
						end
					end
				else
					return
				end
			end
			
			local isMove = clickDown and clickItemSlot and not clickItemSlot.group and ( getTickCount( ) - clickDown >= 200 ) -- dragging items from inv
			local columns = math.ceil( #inventory / 5 )
			local x = sx - columns * sbox - spacer
			local y = ( sy - rows * sbox - spacer ) / 2 + sbox + spacer
			
			if show then
				-- inventory buttons
				local x2 = x - sbox
				local irows = isMove and ACTION_DROP or TAB_ITEMS
				local jrows = isMove and ACTION_DESTROY or TAB_WEAPONS
				local y2 = y + sbox
				dxDrawRectangle( x2, y2, sbox, ( jrows - irows + 1 ) * sbox + spacer, background_color )
				for i = irows, jrows do
					local icon = actionIcons[ i ]
					local boxx = x2 + spacer
					local boxy = y2 + spacer + sbox * ( i - irows )
					dxDrawRectangle( boxx, boxy, box, box, i == activeTab and active_tab_color or icon[2] )
					dxDrawImage( boxx, boxy, box, box, getImage( icon[1] ) )
					
					if not clickWorldItem and isInBox( cursorX, cursorY, boxx, boxx + box, boxy, boxy + box ) then
						if i <= 3 then
							if not isMove then -- tabs
								tooltip( cursorX, cursorY, icon[3], icon[4] )
								hoverAction = i
							end
						elseif isMove then
							tooltip( cursorX, cursorY, icon[3], icon[4] )
							hoverAction = i
						end
					end
				end
				
				isCursorOverInventory = isInBox( cursorX, cursorY, x, sx, y, y + rows * sbox + spacer ) or isInBox( cursorX, cursorY, x2, x2 + sbox, y2, y2 + ( jrows - irows + 1 ) * sbox + spacer )
				
				-- actual inv
				dxDrawRectangle( x, y, columns * sbox + spacer, rows * sbox + spacer, background_color )
				for i = 1, columns * 5 do
					local col = math.floor( ( i - 1 ) / 5 )
					local row = ( i - 1 ) % 5
					
					local boxx = x + col * sbox + spacer
					local boxy = y + row * sbox + spacer
					
					local item = inventory[ i ]
					if item then
						if not isMove or item[4] ~= clickItemSlot.id then
							dxDrawRectangle( boxx, boxy, box, box, full_color )
							dxDrawImage( boxx, boxy, box, box, getImage( item[1], item[2] ) )
							
							-- overlay text for some items
							local text = getOverlayText( item[1], item[2], item[5] )
							if #text > 0 then
								dxDrawText( text, boxx + 2, boxy + 2, boxx + box - 2, boxy + box - 2, tooltip_text_color, 1, "clear", "right", "bottom", true, true, true )
							end
							
							if not isMove and not clickWorldItem and isInBox( cursorX, cursorY, boxx, boxx + box, boxy, boxy + box ) then
								tooltip( cursorX, cursorY, getTooltipFor( item[1], item[2], item[5] ) )
								hoverItemSlot = { invslot = i, id = item[4], x = boxx, y = boxy, group = item[5] }
							end
						end
					else
						dxDrawRectangle( boxx, boxy, box, box, empty_color )
					end
				end
			end
			
			if clickDown and ( getTickCount( ) - clickDown >= 200 ) and ( ( clickItemSlot and not clickItemSlot.group ) or clickWorldItem ) then
				local boxx, boxy, item
				local color = full_color
				local col, x, y, z
				if clickWorldItem then
					item = { getElementData( clickWorldItem, "itemID" ), getElementData( clickWorldItem, "itemValue" ) or 1, false, false }
					boxx = cursorX - spacer - box / 2
					boxy = cursorY - spacer - box / 2
					if isCursorOverInventory then
						if item[ 1 ] == 81 or item[ 1 ] == 103 then
							color = background_error_color
						elseif not hasSpaceForItem( localPlayer, item[1], item[2] ) then
							color = background_error_color
						end
					else
						-- check if we can drop there
						local cameraX, cameraY, cameraZ = getWorldFromScreenPosition( cursorX, cursorY, 0.1 )
						col, x, y, z, hoverElement = processLineOfSight( cameraX, cameraY, cameraZ, cwX, cwY, cwZ )
						if not col or getDistanceBetweenPoints3D( x, y, z, getElementPosition( localPlayer ) ) >= 10 then
							color = background_error_color
						elseif hoverElement then
							if item[ 1 ] == 81 or item[ 1 ] == 103 then
								color = hoverElement == clickWorldItem and full_color or background_error_color
							elseif getElementType( hoverElement ) == "vehicle" then
								color = background_movetoelement_color
							elseif getElementType( hoverElement ) == "ped" and  getElementData(hoverElement,"shopkeeper") and item [ 1 ] == 121 then
								color = background_movetoelement_color
							elseif getElementType( hoverElement ) == "player" then
								color = item[1] < 0 and background_error_color or background_movetoelement_color
							elseif getElementModel( hoverElement ) == 2332 then -- safe
								color = ( hasItem( localPlayer, 4, getElementDimension( localPlayer ) ) or hasItem( localPlayer, 5, getElementDimension( localPlayer ) ) ) and background_movetoelement_color or background_error_color
							elseif getElementModel( hoverElement ) == 2147 then -- fridge
								color = getItemType( item[ 1 ] ) == 1 and background_movetoelement_color or background_error_color
							else
								color = full_color
							end
						end
					end
				else
					item = inventory[ clickItemSlot.invslot ]
					boxx = clickItemSlot.rx + cursorX
					boxy = clickItemSlot.ry + cursorY

					if not isCursorOverInventory then
						-- check if we can drop there
						local cameraX, cameraY, cameraZ = getWorldFromScreenPosition( cursorX, cursorY, 0.1 )
						col, x, y, z, hoverElement = processLineOfSight( cameraX, cameraY, cameraZ, cwX, cwY, cwZ )
						if not col or getDistanceBetweenPoints3D( x, y, z, getElementPosition( localPlayer ) ) >= 10 or isWatchingTV() then
							color = background_error_color
						elseif hoverElement then
							if getElementType( hoverElement ) == "vehicle" then
								color = background_movetoelement_color
							elseif getElementType( hoverElement ) == "player" then
								color = item[1] < 0 and background_error_color or background_movetoelement_color
							elseif getElementModel( hoverElement ) == 2332 then -- safe
								color = ( hasItem( localPlayer, 4, getElementDimension( localPlayer ) ) or hasItem( localPlayer, 5, getElementDimension( localPlayer ) ) ) and background_movetoelement_color or background_error_color
							elseif getElementModel( hoverElement ) == 2147 then -- fridge
								color = getItemType( item[ 1 ] ) == 1 and background_movetoelement_color or background_error_color
							elseif getElementType( hoverElement ) == "ped"  and  getElementData(hoverElement,"shopkeeper") and item [ 1 ] == 121 then --and getElementData(hoverElement,"shopkeeper") then --  item [ 1 ] == 121
								color = background_movetoelement_color
							elseif getElementParent(getElementParent(hoverElement)) ~= getResourceRootElement(getResourceFromName("item-world")) or hoverElement == getHoverElement() then
								color = full_color
							else
								color = background_error_color
							end
						end

					end
				end
				
				dxDrawRectangle( boxx - spacer, boxy - spacer, box + 2 * spacer, box + 2 * spacer, background_color )
				dxDrawRectangle( boxx, boxy, box, box, color )
				dxDrawImage( boxx, boxy, box, box, getImage( item[1], item[2] ) )
				if hoverElement then
					if color == background_movetoelement_color then
						local name = ""
						if getElementType( hoverElement ) == "player" then
							name = getPlayerName( hoverElement ):gsub( "_", " " )
						elseif getElementType( hoverElement ) == "ped" then --and getElementData(hoverElement,"shopkeeper") then
							name = "Store"
						elseif getElementType( hoverElement ) == "vehicle" then
							name = getVehicleName( hoverElement ) .. " (#" .. getElementData( hoverElement, "dbid" ) .. ")"
						elseif getElementModel( hoverElement ) == 2147 then
							name = "Fridge"
						elseif getElementModel( hoverElement ) == 2332 then
							name = "Safe"
						elseif getElementModel ( hoverElement ) == 3761 then
							name = "Shelf"
						end
						tooltip( boxx + sbox, boxy + ( box - 50 ) / 2, getItemName( item[1], item[2] ), "Move to " .. name .. "." )
					elseif color == full_color then
						hoverElement = nil
					else
						hoverElement = false
					end
				else
					hoverElement = nil
				end
			end
			
			if show then
				-- hide any tooltips while over the inventory
				if isCursorOverInventory or clickWorldItem then
					return
				end
			end
			
			local element = getHoverElement(nil, true)
			if element then
				local itemID = getElementData( element, "itemID" )
				local itemValue = getElementData( element, "itemValue" ) or 1

				if itemID ~= 81 and itemID ~= 103 and not getElementData ( localPlayer, "exclusiveGUI" ) then
					tooltip( cursorX, cursorY, getTooltipFor( itemID, itemValue ) )
				end
				hoverWorldItem = getHoverElement()
			elseif not tooltipYet and getPedOccupiedVehicle( localPlayer )then
				-- this code is prolly HORRIBLY wrong here. As this has to do with inventory, not with other people's cars.
				-- Yet figured it's easier.
				--
				-- What it does: If you're near a car and hover your mouse over it AND are in a car yourself - shows its plates.
				element = getHoverElement("vehicle-system") or getHoverElement("admin-system")
				if element then
					-- check if we have any visible gui windows
					local any = false
					for _, v in ipairs( getElementsByType( "gui-window" ) ) do
						if guiGetVisible( v ) then
							any = true
							break
						end
					end
					
					local px, py, pz = getElementPosition( localPlayer )
					-- outputDebugString( "D:" .. getDistanceBetweenPoints3D( px, py, pz, getElementPosition( element ) ) )
					if not any and getElementType(element) == "vehicle" and element ~= getPedOccupiedVehicle( localPlayer ) and exports['vehicle-system']:hasVehiclePlates( element ) and getDistanceBetweenPoints3D( px, py, pz, getElementPosition( element ) ) < 10 then
						tooltip( cursorX, cursorY, "Plate: " .. getVehiclePlateText( element ) )
					end
				end
			end
		end
	end
)

addEventHandler( "recieveItems", getRootElement( ), 
	function( )
		inventory = false
	end
)

addEventHandler( "onClientClick", getRootElement( ),
	function( button, state, cursorX, cursorY, worldX, worldY, worldZ )
		if not waitingForItemDrop then
			if button == "left" or ( button == "middle" and exports.global:isPlayerAdmin( getLocalPlayer( ) ) ) then
				if button == "left" and ( hoverItemSlot or clickItemSlot ) then
					if state == "down" then
						clickDown = getTickCount( )
						clickItemSlot = hoverItemSlot
						clickItemSlot.rx = clickItemSlot.x - cursorX
						clickItemSlot.ry = clickItemSlot.y - cursorY
					end
					
					if state == "down" and getKeyState( "delete" ) then -- quick delete
						state = "up"
						clickDown = 0
						hoverAction = ACTION_DESTROY
					elseif state == "down" and ( getKeyState( "lctrl" ) or getKeyState( "rctrl" ) ) then -- quick drop
						state = "up"
						clickDown = 0
						hoverAction = ACTION_DROP
					end
					
					if state == "up" and clickItemSlot then
						if getTickCount( ) - clickDown < 200 then
							if isCursorOverInventory then
								if clickItemSlot.group then
									activeTabItem = counterIDHelper( inventory[ clickItemSlot.invslot ][1], inventory[ clickItemSlot.invslot ][2] )
									inventory = false
								else
									useItem( inventory[ clickItemSlot.invslot ][ 1 ] < 0 and inventory[ clickItemSlot.invslot ][ 3 ] or clickItemSlot.id )
								end
							end
						elseif not clickItemSlot.group then
							if not isCursorOverInventory then
								if isWatchingTV() then
									clickItemSlot = nil
									return
								end
								
								-- Drag&Drop
								if getDistanceBetweenPoints3D( worldX, worldY, worldZ, getElementPosition( localPlayer ) ) < 10 then
									local item = inventory[ clickItemSlot.invslot ]
									local itemID = item[1]
									local itemValue = item[2]
									if hoverElement == nil then
										if itemID > 0 then
											if itemID == 48 and countItems( localPlayer, 48 ) == 1 and getCarriedWeight( localPlayer ) - getItemWeight( 48, 1 ) > 10 then
												outputChatBox( "You have too much stuff in your inventory.", 255, 0, 0 )
											else
												waitingForItemDrop = true
												triggerServerEvent( "dropItem", localPlayer, clickItemSlot.id, worldX, worldY, worldZ )
											end
										elseif itemID == -100 then
											waitingForItemDrop = true
											triggerServerEvent( "dropItem", localPlayer, 100, worldX, worldY, worldZ, savedArmor )
										end
									elseif hoverElement then
										if itemID > 0 then
											waitingForItemDrop = true
											triggerServerEvent( "moveToElement", localPlayer, hoverElement, clickItemSlot.id, nil, "finishItemDrop" )
										elseif itemID == -100 then
											triggerServerEvent( "moveToElement", localPlayer, hoverElement, clickItemSlot.id, true, "finishItemDrop" )
										end
									end
								end
							elseif hoverAction == ACTION_DROP then
								if isWatchingTV() then
									outputChatBox( "You aren't IN your TV. Just sitting in front of it.", 255, 0, 0 )
									clickItemSlot = nil
									return
								end
								local item = inventory[ clickItemSlot.invslot ]
								local itemID = item[ 1 ]
								local itemValue = item[2]
								
								local matrix = getElementMatrix(getLocalPlayer())
								local oldX = 0
								local oldY = 1
								local oldZ = 0
								local x = oldX * matrix[1][1] + oldY * matrix [2][1] + oldZ * matrix [3][1] + matrix [4][1]
								local y = oldX * matrix[1][2] + oldY * matrix [2][2] + oldZ * matrix [3][2] + matrix [4][2]
								local z = oldX * matrix[1][3] + oldY * matrix [2][3] + oldZ * matrix [3][3] + matrix [4][3]
								
								local z = getGroundPosition( x, y, z + 2 )
								
								if itemID > 0 then
									waitingForItemDrop = true
									triggerServerEvent( "dropItem", localPlayer, clickItemSlot.id, x, y, z )
								elseif itemID == -100 then
									waitingForItemDrop = true
									triggerServerEvent( "dropItem", localPlayer, 100, x, y, z, savedArmor )
								else
									-- weapon
									local slot = -item[3]
									if slot >= 2 and slot <= 9 then
										openWeaponDropGUI(-itemID, itemValue, x, y, z)
									else
										waitingForItemDrop = true
										triggerServerEvent( "dropItem", localPlayer, -itemID, x, y, z, itemValue )
									end
								end
							elseif hoverAction == ACTION_SHOW then
								-- Show Item
								local item = inventory[ clickItemSlot.invslot ]
								local itemName, itemValue = getItemName( item[1], item[2] ), getItemValue( item[1], item[2] )
								if itemName == "Note" then
									itemName = itemName .. ", reading " .. itemValue
								elseif itemName == "Porn Tape" then
									itemName = itemName .. ", " .. itemValue
								elseif item[1] == 64 or item[1] == 65 or item[1] == 86 or item[1] == 87 or item[1] == 82 or item[1] == 112 then
									itemName = itemName .. ", reading " .. itemValue
								end
								triggerServerEvent( "showItem", localPlayer, itemName )
							elseif hoverAction == ACTION_DESTROY then
								local item = inventory[ clickItemSlot.invslot ]
								local itemID = item[ 1 ]
								local itemSlot = itemID < 0 and itemID or clickItemSlot.id
								if itemID == 48 and countItems( localPlayer, 48 ) == 1 then -- backpack
									if getCarriedWeight( localPlayer ) - getItemWeight( 48, 1 ) > 10 then
										outputChatBox("You have too much stuff in your inventory.")
									else
										triggerServerEvent( "destroyItem", localPlayer, itemSlot )
									end
								else
									triggerServerEvent( "destroyItem", localPlayer, itemSlot )
								end
							end
						end
						hoverItemSlot = false
						clickItemSlot = false
						clickDown = false
					end
				elseif hoverWorldItem or clickWorldItem then
					if state == "down" then
						if button == "left" and ( getElementData( hoverWorldItem, "itemID" ) == 81 or getElementData ( hoverWorldItem, "itemID" ) == 103 ) then
							if not getElementData ( localPlayer, "exclusiveGUI" ) then
								triggerServerEvent( "openFreakinInventory", getLocalPlayer(), hoverWorldItem, cursorX, cursorY )
							end
						elseif button == "left" or ( getElementData( hoverWorldItem, "itemID" ) == 81 or getElementData ( hoverWorldItem, "itemID" ) == 103 ) then
							for _, value in ipairs( getElementsByType( "player" ) ) do
								if getPedContactElement( value ) == hoverWorldItem then
									return
								end
							end

							clickDown = getTickCount( )
							clickWorldItem = hoverWorldItem
							setElementAlpha( clickWorldItem, 127 )
							setElementCollisionsEnabled( clickWorldItem, false )
						end
					elseif state == "up" and clickWorldItem then
						setElementAlpha( clickWorldItem, 255 )
						setElementCollisionsEnabled( clickWorldItem, true )
						local canBePickedUp = not ( getElementData( clickWorldItem, "itemID" ) == 81 or getElementData ( clickWorldItem, "itemID" ) == 103 )

						if getTickCount( ) - clickDown < 200 then
							if canBePickedUp then
								pickupItem( "left", "down", clickWorldItem )
							end
						else
							if isCursorOverInventory then
								if canBePickedUp then
									pickupItem( "left", "down", clickWorldItem )
								end
							elseif rotate then
								local rx, ry, rz = getElementRotation( clickWorldItem )
								setElementRotation( clickWorldItem, rx, ry, rz - rotate )
								triggerServerEvent( "rotateItem", localPlayer, clickWorldItem, rotate )
							else
								-- Drag&Drop, bitches
								if getDistanceBetweenPoints3D( worldX, worldY, worldZ, getElementPosition( localPlayer ) ) < 10 then
									if hoverElement == nil then
										for _, value in ipairs( getElementsByType( "player" ) ) do
											if getPedContactElement( value ) == clickWorldItem then
												return
											end
										end
										triggerServerEvent( "moveItem", localPlayer, clickWorldItem, worldX, worldY, worldZ )
									else
										if button == "left" then
											triggerServerEvent( "moveWorldItemToElement", localPlayer, clickWorldItem, hoverElement )
										end
									end
								end
							end
						end
						
						clickWorldItem = false
						cursorDown = false
						rotate = false
					end
				elseif button == "left" and isCursorOverInventory and hoverAction and state == "down" then
					if show then
						if activeTabItem then
							activeTabItem = nil
							activeTab = hoverAction
						elseif activeTab == hoverAction then
							show = false
							showCursor( false )
							exports["realism-system"]:showSpeedo()
						else
							activeTab = hoverAction
						end
					else
						activeTab = hoverAction
						show = true
					end
					inventory = false
				end
			elseif button == "right" then
				if clickItemSlot then
					clickItemSlot = false
					clickDown = false
				end
				if clickWorldItem then
					setElementAlpha( clickWorldItem, 255 )
					setElementCollisionsEnabled( clickWorldItem, true )
					clickWorldItem = false
					clickDown = false
				end
				if state == "up" and hoverWorldItem then
					if getElementData ( hoverWorldItem, "itemID" ) == 103 or getElementData ( hoverWorldItem, "itemID" ) == 81 then -- Shelf/Fridge
						if not getElementData ( localPlayer, "exclusiveGUI" ) then
							triggerServerEvent( "openFreakinInventory", getLocalPlayer(), hoverWorldItem, cursorX, cursorY )
						end
					elseif getElementData( hoverWorldItem, "itemID" ) == 54 then -- Ghettoblaster
						item = hoverWorldItem
						ax, ay = cursorX, cursorY
						showItemMenu( )
					end
				end
			end
		end
	end
)

bindKey( "mouse_wheel_up", "down",
	function( )
		if not guiGetInputEnabled( ) and not isMTAWindowActive( ) and isCursorShowing( ) and clickWorldItem and exports.global:isPlayerAdmin( getLocalPlayer( ) ) then
			if getElementData( clickWorldItem, "itemID" ) == 103 or getElementData( clickWorldItem, "itemID" ) == 81 then
				rotate = ( rotate or 0 ) + 5
				local rx, ry, rz = getElementRotation( clickWorldItem )
				setElementRotation( clickWorldItem, rx, ry, rz + 5 )
			end
		end
	end
)

bindKey( "mouse_wheel_down", "down",
	function( )
		if not guiGetInputEnabled( ) and not isMTAWindowActive( ) and isCursorShowing( ) and clickWorldItem and exports.global:isPlayerAdmin( getLocalPlayer( ) ) then
			if getElementData( clickWorldItem, "itemID" ) == 103 or getElementData( clickWorldItem, "itemID" ) == 81 then
				rotate = ( rotate or 0 ) - 5
				local rx, ry, rz = getElementRotation( clickWorldItem )
				setElementRotation( clickWorldItem, rx, ry, rz - 5 )
			end
		end
	end
)

bindKey( "i", "down",
	function( )
		if show then
			hideNewInventory( )
		elseif not getElementData(localPlayer, "adminjailed") and not getElementData(localPlayer, "pd.jailstation") then
			show = true
			activeTabItem = nil
			inventory = false
			showCursor( true )
			exports["realism-system"]:hideSpeedo()
		else
			outputChatBox("You can't access your inventory in jail", 255, 0, 0)
		end
	end
)

addEvent( "finishItemDrop", true )
addEventHandler("finishItemDrop", getLocalPlayer(),
	function( )
		waitingForItemDrop = false
		inventory = false
	end
)

--

function hideNewInventory( )
	clickDown = false
	clickItemSlot = false
	rotate = false
	if clickWorldItem then
		setElementAlpha( clickWorldItem, 255 )
		setElementCollisionsEnabled( clickWorldItem, true )
		clickWorldItem = false
	end
	
	if show then
		show = false
		showCursor( false )
		exports["realism-system"]:showSpeedo()
	end
end
