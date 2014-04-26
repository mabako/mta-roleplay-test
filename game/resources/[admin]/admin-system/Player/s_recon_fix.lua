addEvent( "fixRecon", true )
addEventHandler( "fixRecon", getRootElement( ), 
	function( element )
		setElementDimension( client, getElementDimension( element ) )
		setElementInterior( client, getElementInterior( element ) )
		setCameraInterior( client, getElementInterior( element ) )
	end
)