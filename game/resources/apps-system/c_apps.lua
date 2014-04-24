local appsbutton = nil
local localPlayer = getLocalPlayer( )

local function updateButton( )
	if getResourceFromName ( 'global' ) then
		if (exports.global:isPlayerAdmin( localPlayer ) and getElementData( localPlayer, "adminduty" ) == 1) or getElementData(localPlayer, "account:gmduty") then
			local apps = getElementData( getResourceRootElement( ), "openapps" )
			if apps and apps > 0 then
				if not appsbutton then
					local screenWidth, screenHeight = guiGetScreenSize()
					appsbutton = guiCreateButton( screenWidth-40, screenHeight-70, 30, 30, tostring( apps ), false )
					addEventHandler( "onClientGUIClick", appsbutton,
						function( )
							triggerServerEvent( "apps:show", localPlayer )
						end, false
					)
					guiSetAlpha( appsbutton, 0.80 )
				else
					guiSetText( appsbutton, tostring( apps ) )
				end
				return
			end
		end
		if appsbutton then
			destroyElement( appsbutton )
			appsbutton = nil
		end
	end
end

addEventHandler( "onClientResourceStart", getResourceRootElement( ), updateButton )
addEventHandler( "onClientElementDataChange", getResourceRootElement( ), updateButton )
addEventHandler( "onClientElementDataChange", localPlayer,
	function( name ) 
		if name == "adminlevel" or name == "adminduty" or name == "account:gmlevel" then
			updateButton( )
		end
	end
)

--

local wAllApps = nil

addEvent( "apps:showall", true )
addEventHandler( "apps:showall", localPlayer,
	function( results )
		if wAllApps then
			destroyElement( wAllApps )
			wAllApps = nil
			
			showCursor( false )
		else
			local sx, sy = guiGetScreenSize()
			wAllApps = guiCreateWindow( sx / 2 - 150, sy / 2 - 250, 300, 500, "Open Applications", false )
			
			gAllApps = guiCreateGridList( 0.03, 0.04, 0.94, 0.88, true, wAllApps )
			local colName = guiGridListAddColumn( gAllApps, "Name", 0.50 )
			local colTime = guiGridListAddColumn( gAllApps, "Time", 0.45 )
			for _, res in pairs( results ) do
				local row = guiGridListAddRow( gAllApps )
				guiGridListSetItemText( gAllApps, row, colName, res[2], false, true )
				guiGridListSetItemData( gAllApps, row, colName, tostring( res[1] ) )
				guiGridListSetItemText( gAllApps, row, colTime, res[3], false, true )
				guiGridListSetItemData( gAllApps, row, colTime, tostring( res[1] ) )
			end
			
			addEventHandler( "onClientGUIDoubleClick", gAllApps,
				function( button )
					if button == "left" then
						local row, col = guiGridListGetSelectedItem( gAllApps )
						if row ~= -1 and col ~= -1 then
							local id = guiGridListGetItemData( gAllApps, row, col )
							triggerServerEvent( "apps:show", localPlayer, tonumber( id ) )
							
							destroyElement( wAllApps )
							wAllApps = nil
							
							showCursor( false )
						else
							outputChatBox( "You need to pick an Application.", 255, 0, 0 )
						end
					end
				end,
				false
			)
			
			bClose = guiCreateButton( 0.03, 0.93, 0.94, 0.07, "Close", true, wAllApps )
			addEventHandler( "onClientGUIClick", bClose,
				function( button, state )
					if button == "left" and state == "up" then
						destroyElement( wAllApps )
						wAllApps = nil
						
						showCursor( false )
					end
				end, false
			)
			
			showCursor( true )
		end
	end
)

--

local wApp = nil
local texts = {}
local account = nil
local accept, deny, close, back, history, past

addEvent( "apps:showsingle", true )
addEventHandler( "apps:showsingle", localPlayer,
	function( info )
		account = { id = tonumber( info.accountID ), name = info.username, appid = tonumber(info.applicationID) }
		if not wApp then
			local sx, sy = guiGetScreenSize()
			wApp = guiCreateWindow( sx / 2 - 365, sy / 2 - 280, 730, 560, "Review Application", false )
			guiWindowSetSizable( wApp, false )
			
			texts.username = { guiCreateLabel( 10, 22, 170, 16, "", false, wApp ), "Username: " }
			texts.accountID = { guiCreateLabel( 160, 22, 110, 16, "", false, wApp ), "Account ID: " }
			texts.history = { guiCreateButton( 410, 22, 80, 20, "History", false, wApp ), "History: " }

			texts.content = { guiCreateMemo( 10, 50, 700, 350, "", false, wApp ), nil, guiCreateLabel( 10, 300, 350, 16, "", false, wApp ) }

			texts.appreason = { guiCreateMemo( 10, 416, 350, 110, "", false, wApp ), nil, guiCreateLabel( 10, 400, 350, 16, "Reason for denying (please on a formal way)", false, wApp ) }
			texts.adminnote = { guiCreateMemo( 365, 416, 350, 110, "", false, wApp ), nil, guiCreateLabel( 365, 400, 350, 16, "Admin Note", false, wApp ) }
			
			texts.past = { guiCreateButton( 310, 22, 100, 20, "Earlier apps", false, wApp ), "Earlier apps: " }

			past = texts.past
			history = texts.history
			addEventHandler( "onClientGUIClick", history,
				function( button, state )
					if button == "left" and state == "up" then
						triggerServerEvent( "apps:showappspast", localPlayer, account )
					end
				end, false
			)
			
			
			accept = guiCreateButton( 490, 22, 80, 20, "Accept", false, wApp )
			addEventHandler( "onClientGUIClick", accept,
				function( button, state )
					if button == "left" and state == "up" then
						guiSetVisible( wApp, false )
						guiSetInputEnabled( false )
						triggerServerEvent( "apps:update", localPlayer, account, 3, guiGetText( texts.appreason[1] ) or "" )
					end
				end, false
			)
			
			deny = guiCreateButton( 570, 22, 80, 20, "Deny", false, wApp )
			addEventHandler( "onClientGUIClick", deny,
				function( button, state )
					if button == "left" and state == "up" then
						guiSetVisible( wApp, false )
						guiSetInputEnabled( false )
						triggerServerEvent( "apps:update", localPlayer, account, 2, guiGetText( texts.appreason[1] ) or "" )
					end
				end, false
			)
			
			close = guiCreateButton( 650, 22, 80, 20, "Close", false, wApp )
			addEventHandler( "onClientGUIClick", close,
				function( button, state )
					if button == "left" and state == "up" then
						guiSetVisible( wApp, false )
						guiSetInputEnabled( false )
					end
				end, false
			)

			history = texts.history
			addEventHandler( "onClientGUIClick", history,
				function( button, state )
					if button == "left" and state == "up" then
						triggerServerEvent( "apps:showhistory", localPlayer, account )
					end
				end, false
			)
			
		else
			guiSetVisible( wApp, true )
		end
		guiSetInputEnabled( true )
		
		for key, value in pairs( texts ) do
			guiSetText( value[1], ( value[2] or "" ) .. ( info[key] or "" ) )
		end

	end
)


--

local wPastApps = nil

addEvent( "apps:showpast", true )
addEventHandler( "apps:showpast", localPlayer,
	function( results )
		if wPastApps then
			destroyElement( wPastApps )
			wPastApps = nil
			
			showCursor( false )
		else
			local sx, sy = guiGetScreenSize()
			wAllApps = guiCreateWindow( sx / 2 - 150, sy / 2 - 250, 300, 500, "Past Applications", false )
			
			--[[gAllApps = guiCreateGridList( 0.03, 0.04, 0.94, 0.88, true, wAllApps )
			local colName = guiGridListAddColumn( gAllApps, "Name", 0.50 )
			local colTime = guiGridListAddColumn( gAllApps, "Time", 0.45 )
			for _, res in pairs( results ) do
				local row = guiGridListAddRow( gAllApps )
				guiGridListSetItemText( gAllApps, row, colName, res[2], false, true )
				guiGridListSetItemData( gAllApps, row, colName, tostring( res[1] ) )
				guiGridListSetItemText( gAllApps, row, colTime, res[3], false, true )
				guiGridListSetItemData( gAllApps, row, colTime, tostring( res[1] ) )
			end
			
			addEventHandler( "onClientGUIDoubleClick", gAllApps,
				function( button )
					if button == "left" then
						local row, col = guiGridListGetSelectedItem( gAllApps )
						if row ~= -1 and col ~= -1 then
							local id = guiGridListGetItemData( gAllApps, row, col )
							triggerServerEvent( "apps:show", localPlayer, tonumber( id ) )
							
							destroyElement( wAllApps )
							wAllApps = nil
							
							showCursor( false )
						else
							outputChatBox( "You need to pick an Application.", 255, 0, 0 )
						end
					end
				end,
				false
			)]]
			
			bClose = guiCreateButton( 0.03, 0.93, 0.94, 0.07, "Close", true, wPastApps )
			addEventHandler( "onClientGUIClick", bClose,
				function( button, state )
					if button == "left" and state == "up" then
						destroyElement( wPastApps )
						wPastApps = nil
						
						showCursor( false )
					end
				end, false
			)
			
			showCursor( true )
		end
	end
)

--