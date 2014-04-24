function toggleHelp( thePlayer, commandName )
	if getElementData( thePlayer, "dbid" ) then
		if getElementData( thePlayer, "help" ) then
			-- hide the window
			if commandName then
				triggerClientEvent( thePlayer, "showHelp", thePlayer, false )
			end
			
			-- unfreeze and show the own player
			setElementFrozen( thePlayer, false )
			setElementAlpha( thePlayer, 255 )
			
			-- set the camera target back
			setCameraTarget( thePlayer, thePlayer )
			
			-- reset his position
			local dimension, interior, x, y, z = unpack( getElementData( thePlayer, "help" ) )
			
			setElementPosition( thePlayer, x, y, z )
			setElementDimension( thePlayer, dimension )
			
			-- make sure int is loaded
			setElementInterior( thePlayer, interior + 1 )
			setElementInterior( thePlayer, interior )
			setCameraInterior( thePlayer, interior + 1 )
			setCameraInterior( thePlayer, interior )
			
			exports['anticheat-system']:changeProtectedElementDataEx( thePlayer, "help", false, false )
			
			-- show the radar, zone name and chat again
			--showPlayerHudComponent( thePlayer, "radar", true )
			--showPlayerHudComponent( thePlayer, "area_name", true )
			showChat( thePlayer, true )
			
			-- hide the cursor
			showCursor( thePlayer, false )
		else
			-- save the old position
			exports['anticheat-system']:changeProtectedElementDataEx( thePlayer, "help", { getElementDimension( thePlayer ), getElementInterior( thePlayer ), getElementPosition( thePlayer ) }, false )
			
			setElementDimension( thePlayer, 20 )
			
			-- freeze the player and hide him
			setElementAlpha( thePlayer, 0 )
			setElementFrozen( thePlayer, true )
			
			-- hide the chat, zone name and radar
			--showPlayerHudComponent( thePlayer, "radar", false )
			--showPlayerHudComponent( thePlayer, "area_name", false )
			showChat( thePlayer, false )
			
			-- show the cursor to navigate
			showCursor( thePlayer, true )
			
			-- open the window
			triggerClientEvent( thePlayer, "showHelp", thePlayer, true )
		end
	end
end
addCommandHandler( "?", toggleHelp )

--[[
-- bind keys for the player
addEventHandler( "onResourceStop", getResourceRootElement( ),
	function( )
		for key, value in pairs( getElementsByType( "player" ) ) do
			if isElement( value ) then
				bindKey( value, "F1", "down", "?" )
			end
		end
	end
)

addEventHandler( "onPlayerJoin", getRootElement( ),
	function( )
		bindKey( source, "F1", "down", "?" )
	end
)]]

-- make sure we close all help windows on exit
addEventHandler( "onResourceStop", getResourceRootElement( ),
	function( )
		for key, value in pairs( getElementsByType( "player" ) ) do
			if isElement( value ) and getElementData( value, "help" ) then
				toggleHelp( value )
			end
		end
	end
)

-- allow the client's exit button to close the menu
addEvent( "exitHelp", true )
addEventHandler( "exitHelp", getRootElement( ), function( ) toggleHelp( source, "" ) end )