addEventHandler( "onClientPlayerVehicleEnter", getLocalPlayer(),
	function( vehicle )
		setElementData( vehicle, "groundoffset", 0.2 + getElementDistanceFromCentreOfMassToBaseOfModel( vehicle ) )
	end
)

addEvent( "CantFallOffBike", true )
addEventHandler( "CantFallOffBike", getLocalPlayer(),
	function( )
		setPedCanBeKnockedOffBike( getLocalPlayer(), false )
		setTimer( setPedCanBeKnockedOffBike, 1050, 1, getLocalPlayer(), true )
	end
)