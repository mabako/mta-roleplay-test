addEventHandler( "onVehicleRespawn", getRootElement( ),
	function( )
		if isVehicleTaxiLightOn( source ) then
			setVehicleTaxiLightOn( source, false )
		end
	end
)

addEventHandler( "onVehicleStartExit", getRootElement( ),
	function( player, seat, jacked )
		if isVehicleTaxiLightOn( source ) then
			setVehicleTaxiLightOn( source, false )
		end
	end
)

addEvent( "toggleTaxiLights", true )
addEventHandler( "toggleTaxiLights", getRootElement( ), 
	function( vehicle )
		setVehicleTaxiLightOn( vehicle, not isVehicleTaxiLightOn( vehicle ) )
	end
)