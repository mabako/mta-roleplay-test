function CreateCheckWindow()
	local width, height = guiGetScreenSize()	
	Button = {}
	Window = guiCreateWindow(width-430,271,400,385,"Player check.",false)
	Button[3] = guiCreateButton(0.85,0.86,0.12, 0.125,"Close",true,Window)
	addEventHandler( "onClientGUIClick", Button[3], CloseCheck )
	Label = {
		guiCreateLabel(0.03,0.06,0.95,0.0887,"Name: N/A",true,Window),
		guiCreateLabel(0.03,0.10,0.66,0.0887,"IP: N/A",true,Window),
		guiCreateLabel(0.03,0.26,0.66,0.0887,"Money: N/A",true,Window),
		guiCreateLabel(0.03,0.30,0.17,0.0806,"Health: N/A",true,Window),
		guiCreateLabel(0.27,0.34,0.30,0.0806,"Armor: N/A",true,Window),
		guiCreateLabel(0.03,0.34,0.17,0.0806,"Skin: N/A",true,Window),
		guiCreateLabel(0.27,0.30,0.30,0.0806,"Weapon: N/A",true,Window),
		guiCreateLabel(0.03,0.38,0.66,0.0806,"Faction: N/A",true,Window),
		guiCreateLabel(0.03,0.18,0.66,0.0806,"Ping: N/A",true,Window),
		guiCreateLabel(0.03,0.42,0.66,0.0806,"Vehicle: N/A",true,Window),
		guiCreateLabel(0.03,0.46,0.66,0.0806,"Warns: N/A",true,Window),
		guiCreateLabel(0.03,0.50,0.97,0.0766,"Location: N/A",true,Window),
		guiCreateLabel(0.7,0.06,0.4031,0.0766,"X:",true,Window),
		guiCreateLabel(0.7,0.10,0.4031,0.0766,"Y: N/A",true,Window),
		guiCreateLabel(0.7,0.14,0.4031,0.0766,"Z: N/A",true,Window),
		guiCreateLabel(0.7,0.18,0.2907,0.0806,"Interior: N/A",true,Window),
		guiCreateLabel(0.7,0.22,0.2907,0.0806,"Dimension: N/A",true,Window),
		guiCreateLabel(0.03,0.14,0.66,0.0887,"Admin Level: N/A", true,Window),
		guiCreateLabel(0.7,0.26,0.4093,0.0806,"Hours Char: N/A\n~ Total: N/A",true,Window),
		guiCreateLabel(0.03,0.22,0.66,0.0887,"vPoints: N/A", true,Window),
		guiCreateLabel(0.03,0.50,0.66,0.0806,"",true,Window),
		guiCreateLabel(0.27,0.22,0.30,0.0806,"Stat Transfers: N/A",true,Window),
	}
	
	-- player notes
	memo = guiCreateMemo(0.03, 0.55, 0.8, 0.42, "", true, Window)
	addEventHandler( "onClientGUIClick", Window,
		function( button, state )
			if button == "left" and state == "up" then
				if source == memo then
					guiSetInputEnabled( true )
				else
					guiSetInputEnabled( false )
				end
			end
		end
	)
	Button[4] = guiCreateButton(0.85,0.55,0.12, 0.175,"Save\nNote",true,Window)
	addEventHandler( "onClientGUIClick", Button[4], SaveNote, false )
	
	Button[5] = guiCreateButton(0.7,0.375,0.4093,0.15,"History: N/A",true,Window)
	addEventHandler( "onClientGUIClick", Button[5], ShowHistory, false )
	
	Button[6] = guiCreateButton(0.85,0.73,0.12,0.125,"Inv.",true,Window)
	addEventHandler( "onClientGUIClick", Button[6], showInventory, false )

	guiSetVisible(Window, false)
end

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function ()
		CreateCheckWindow()
	end
)

levels = { "Trial Admin", "Admin", "Super Admin", "Lead Admin", "Head Admin", "Owner" }
levels[-1] = "Trainee Gamemaster"
levels[-2] = "Gamemaster"
levels[-3] = "Lead Gamemaster"
levels[-4] = "Head Gamemaster"
local actions = { [0] = "jail", [1] = "kick", [2] = "ban", [3] = "app", [4] = "warn", [5] = "aban", [6] = "other" }
function OpenCheck( ip, adminreports, vPoints, note, history, warns, transfers, bankmoney, money, adminlevel, hoursPlayed, accountname, hoursAcc )
	player = source

	-- accountname
	guiSetText ( Label[1], "Name: " .. getPlayerName(player):gsub("_", " ") .. " ("..accountname..")")
	if adminreports == nil then
		adminreports = "-1"
	end
	
	
	if vPoints == nil then
		vPoints = "Unknown"
	end
	
	if transfers == nil then
		transfers = "N/A"
	end
	
	if warns == nil then
		warns = "N/A"
	end
	
	if history == nil then
		history = "N/A"
	else
		local total = 0
		local str = {}
		for key, value in ipairs(history) do
			total = total + value[2]
			table.insert(str, value[2] .. " " .. actions[value[1]])
			if key % 2 == 0 and key < #history then
				table.insert( str, "\n" )
			end
		end
		history = table.concat(str, " ")
	end
	
	if bankmoney == nil then
		bankmoney = "-1"
	end
	
	guiSetText ( Label[2], "IP: " .. ip )
	guiSetText ( Label[18], "Admin Level: " .. ( levels[adminlevel or 0] or "Player" ) .. " (" .. adminreports .. " Reports)" )
	guiSetText ( Label[11], "Warns: " .. warns )
	guiSetText ( Label[3], "Money: $" .. exports.global:formatMoney(money) .. " (Bank: $" .. exports.global:formatMoney(bankmoney) .. ")")
	guiSetText ( Button[5], history )
	guiSetText ( Label[20], "vPoints: " .. vPoints )
	guiSetText ( Label[22], "Stat transfers: " .. transfers )
	guiSetText ( Label[19], "Hours Char: " .. ( hoursPlayed or "N/A" ) .. "\n~ Total: " .. ( hoursAcc or "N/A" ) )
	guiSetText ( memo, note or "ERROR: COULD NOT FETCH NOTE")

	if not guiGetVisible( Window ) then
		guiSetVisible(Window, true)
	end
end

addEvent( "onCheck", true )
addEventHandler( "onCheck", getRootElement(), OpenCheck )


addEventHandler( "onClientRender", getRootElement(),
	function()
		if guiGetVisible(Window) and isElement( player ) then
			local x, y, z = 0, 0, 0
			if (getElementAlpha(player) ~= 0 or exports.global:isPlayerHeadAdmin(getLocalPlayer())) then 
				x, y, z = getElementPosition(player)
				guiSetText ( Label[13], "X: " .. string.format("%.5f", x) )
				guiSetText ( Label[14], "Y: " .. string.format("%.5f", y) )
				guiSetText ( Label[15], "Z: " .. string.format("%.5f", z) )
			
			else
				guiSetText ( Label[13], "X: N/A" )
				guiSetText ( Label[14], "Y: N/A" )
				guiSetText ( Label[15], "Z: N/A" )
			end
			
			guiSetText ( Label[4], "Health: " .. math.floor( getElementHealth( player ) ) )
			guiSetText ( Label[5], "Armour: " .. math.floor( getPedArmor( player ) ) )
			guiSetText ( Label[6], "Skin: " .. getElementModel( player ) )
			
			local weapon = getPedWeapon( player )
			if weapon then
				weapon = getWeaponNameFromID( weapon )
			else
				weapon = "N/A"
			end
			guiSetText ( Label[7], "Weapon: " .. weapon )

			local team = getPlayerTeam(player)
			if team then
				guiSetText ( Label[8], "Faction: " .. getTeamName(team) )
			else
				guiSetText ( Label[8], "Faction: N/A")
			end
			guiSetText ( Label[9], "Ping: " .. getPlayerPing( player ) )
			
			local vehicle = getPedOccupiedVehicle( player )
			if vehicle then
				guiSetText ( Label[10], "Vehicle: " .. getVehicleName( vehicle ) .. " (" ..getElementData( vehicle, "dbid" ) .. ")" )
			else
				guiSetText ( Label[10], "Vehicle: N/A")
			end
			guiSetText ( Label[12], "Location: " .. getZoneName( x, y, z ) )
			guiSetText ( Label[16], "Interior: " .. getElementInterior( player ) )
			guiSetText ( Label[17], "Dimension: " .. getElementDimension( player ) )
		end
	end
)

function CloseCheck( button, state )
	if source == Button[3] and button == "left" and state == "up" then
		triggerEvent("cursorHide", getLocalPlayer())
		guiSetVisible( Window, false )
		guiSetInputEnabled( false )
		player = nil
	end
end

function SaveNote( button, state )
	if source == Button[4] and button == "left" and state == "up" then
		local text = guiGetText(memo)
		if text then
			triggerServerEvent("savePlayerNote", getLocalPlayer(), player, text)
		end
	end
end

function ShowHistory( button, state )
	if source == Button[5] and button == "left" and state == "up" then
		triggerServerEvent( "showAdminHistory", getLocalPlayer(), player )
	end
end

function showInventory( button, state )
	if source == Button[6] and button == "left" and state == "up" then
		triggerServerEvent( "admin:showInventory", player )
	end
end

local wHist, gHist, bClose, lastElement

-- window

function duration( d, a )
	if a == 6 then
		return tostring(d)
	elseif a == 1 or a == 3 or a == 4 then
		return ""
	elseif a == 0 then
		return d .. " min"
	elseif a == 2 and d ~= 0 then
		return d .. " hrs"
	else
		return "perm"
	end
end
addEvent( "cshowAdminHistory", true )
addEventHandler( "cshowAdminHistory", getRootElement(),
	function( info, targetID )
		if wHist then
			destroyElement( wHist )
			wHist = nil
			
			showCursor( false )
		else
			local sx, sy = guiGetScreenSize()
			
			local name
			if targetID == nil then
				name = getPlayerName( source )
			else
				name = "Account " .. tostring(targetID)
			end
			
			wHist = guiCreateWindow( sx / 2 - 350, sy / 2 - 250, 700, 500, "Admin History: ".. name, false )
			
			-- date, action, reason, duration, a.username, c.charactername, id
			
			gHist = guiCreateGridList( 0.03, 0.04, 0.94, 0.88, true, wHist )
			local colID = guiGridListAddColumn( gHist, "ID", 0.05 )
			local colAction = guiGridListAddColumn( gHist, "Action", 0.07 )
			local colChar = guiGridListAddColumn( gHist, "Character", 0.2 )
			local colReason = guiGridListAddColumn( gHist, "Reason", 0.25 )
			local colDuration = guiGridListAddColumn( gHist, "Time", 0.07 )
			local colAdmin = guiGridListAddColumn( gHist, "Admin", 0.15 )
			local colDate = guiGridListAddColumn( gHist, "Date", 0.15 )
			
			
			for _, res in pairs( info ) do
				local row = guiGridListAddRow( gHist )
				guiGridListSetItemText( gHist, row, colID,   res[7]  or "?", false, false )
				guiGridListSetItemText( gHist, row, colAction, actions[ tonumber( res[2] ) ] or "?", false, false )
				guiGridListSetItemText( gHist, row, colChar, res[6], false, false )
				guiGridListSetItemText( gHist, row, colReason, res[3], false, false )
				guiGridListSetItemText( gHist, row, colDuration, duration( res[4], tonumber( res[2] ) ), false, false )
				guiGridListSetItemText( gHist, row, colAdmin, res[5], false, false )
				guiGridListSetItemText( gHist, row, colDate, res[1], false, false )
			end
			
			addEventHandler( "onClientGUIDoubleClick", gHist,
				function( button )
					if button == "right" then
						local row, col = guiGridListGetSelectedItem( source )
						if row ~= -1 and col ~= -1 then
							local gridID = guiGridListGetItemText( source , row, col )
							triggerServerEvent("admin:removehistory", getLocalPlayer(), gridID, name)
							destroyElement( wHist )
							wHist = nil
							
							showCursor( false )
						else
							outputChatBox( "You need to pick a record.", 255, 0, 0 )
						end
					end
				end,
				false
			)
			
			bClose = guiCreateButton( 0.03, 0.93, 0.94, 0.07, "Close", true, wHist )
			addEventHandler( "onClientGUIClick", bClose,
				function( button, state )
					if button == "left" and state == "up" then
						destroyElement( wHist )
						wHist = nil
						
						showCursor( false )
					end
				end, false
			)
			
			showCursor( true )
		end
	end
)
 