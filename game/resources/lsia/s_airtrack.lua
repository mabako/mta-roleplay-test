--
-- people with blips
--
local blips = { }

addEvent( "lsia:airtrack:on", true )
addEventHandler( "lsia:airtrack:on", root,
	function( )
		if getElementType( source ) == "vehicle" then
			triggerClientEvent( client, "lsia:airtrack:blips", client, blips )
			
			blips[ client ] = source
			for player in pairs( blips ) do
				triggerClientEvent( player, "lsia:airtrack:on", source )
			end
		end
	end
)

function off( player )
	local vehicle = blips[ player ]
	blips[ player ] = nil
	
	for player in pairs( blips ) do
		triggerClientEvent( player, "lsia:airtrack:off", vehicle )
	end
end

addEvent( "lsia:airtrack:off", true )
addEventHandler( "lsia:airtrack:off", root,
	function( )
		off( client )
	end
)
addEventHandler( "onPlayerQuit", root,
	function( )
		off( source )
	end
)

--
-- exported for chat-system
--
function getPlayersInAircraft( )
	local t = {}
	for k, v in ipairs( getElementsByType( "player" ) ) do
		local vehicle = getPedOccupiedVehicle( v )
		if vehicle then
			if trackingMinHeight[ getElementModel( vehicle ) ] then
				table.insert( t, value )
			end
		end
	end
	return t
end
