local wStats

addEvent( "admin:stats", true )
addEventHandler( "admin:stats", localPlayer,
	function( results )
		if wStats then
			destroyElement( wStats )
			wStats = nil
			
			showCursor( false )
		end
		
		local sx, sy = guiGetScreenSize()
		wStats = guiCreateWindow( sx / 2 - 150, sy / 2 - 250, 300, 500, "Admin Stats", false )
		
		local gStats = guiCreateGridList( 0.03, 0.04, 0.94, 0.88, true, wStats )
		local colName = guiGridListAddColumn( gStats, "Name", 0.43 )
		local colTime = guiGridListAddColumn( gStats, "Reports", 0.23 )
		local colOnline = guiGridListAddColumn( gStats, "Last Online", 0.5 )
		
		local oldLevel = false
		for _, res in pairs( results ) do
			local level = res[2]
			if level ~= oldLevel then
				guiGridListSetItemText( gStats, guiGridListAddRow( gStats ), colName, levels[level], true, false )
				oldLevel = level
			end
			
			local row = guiGridListAddRow( gStats )
			guiGridListSetItemText( gStats, row, colName, tostring( res[1] ), false, false )
			guiGridListSetItemText( gStats, row, colTime, tostring( res[3] ), false, true )
			guiGridListSetItemText( gStats, row, colOnline, tostring( res[4] ), false, true )
		end
		
		bClose = guiCreateButton( 0.03, 0.93, 0.94, 0.07, "Close", true, wStats )
		addEventHandler( "onClientGUIClick", bClose,
			function( button, state )
				if button == "left" and state == "up" then
					destroyElement( wStats )
					wStats = nil
					
					showCursor( false )
				end
			end, false
		)
		
		showCursor( true )
	end
)