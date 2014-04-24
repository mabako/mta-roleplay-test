localPlayer = getLocalPlayer()
localPed = nil 

function toggleHelp( show )
	if show then
		-- create a ped sitting on a bench with the player's skin
		localPed = createPed( getElementModel( localPlayer ), 1480, -1625.35, 14.04 )
		setPedAnimation( localPed, "PED", "SEAT_idle", -1, true, false, false )
		setElementDimension( localPed, 20 )
		
		-- fix for streaming in the anim
		addEventHandler( "onClientElementStreamIn", localPed, 
			function( )
				setPedAnimation( localPed, "PED", "SEAT_idle", -1, true, false, false )
			end
		)
		
		-- show the cursor
		showCursor( true )
		
		-- create the main menu
		createMenu( help_menu )
		
		-- cancel any damage
		addEventHandler( "onClientPlayerDamage", localPlayer, cancelEvent )
	else
		-- destroy the menu
		destroyMenu( )
		
		-- destroy our helping ped
		if localPed then
			destroyElement( localPed )
			localPed = nil
		end
		
		-- allow damage
		removeEventHandler( "onClientPlayerDamage", localPlayer, cancelEvent )
		
		-- kill fancy camera timer
		if cameraupdatetimer then
			killTimer( cameraupdatetimer )
			cameraupdatetimer = nil
			
			fadeCamera( true )
		end
	end
end
addEvent( "showHelp", true )
addEventHandler( "showHelp", getLocalPlayer( ), toggleHelp, false )