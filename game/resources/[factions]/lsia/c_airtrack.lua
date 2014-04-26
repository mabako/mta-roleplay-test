
blips = { }



local watchedAreas = {
	createColRectangle(1153, -2822, 1119, 680)
}
function inAnyColShape( element )
	for k, v in ipairs( watchedAreas ) do
		if isElementWithinColShape( element, v ) then
			return true
		end
	end
end

--createRadarArea(1153, -2822, 1119, 680, 255, 0, 0, 127)

--

local areWeVisible = false
local startedInWatchedArea = false
setTimer(
	function( )
		local vehicle = getPedOccupiedVehicle( localPlayer )
		if vehicle and getVehicleOccupant( vehicle ) == localPlayer then
			local distance = trackingMinHeight[ getElementModel( vehicle ) ]
			if distance then
				local vx, vy, vz = getElementPosition( vehicle )
				local gz = getGroundPosition( vx, vy, vz ) or vz
				
				if getVehicleEngineState( vehicle ) and ( vz - gz > ( startedInWatchedArea and 3 or distance ) ) then
					if not areWeVisible then
						triggerServerEvent( "lsia:airtrack:on", vehicle )
						areWeVisible = true
					end
					return
				end
			end
		end
		
		if areWeVisible then
			triggerServerEvent( "lsia:airtrack:off", localPlayer )
			areWeVisible = false
			
			for vehicle, blip in pairs( blips ) do
				destroyElement( blip )
				blips[ vehicle ] = nil
			end
		end
	end,
	5000,
	0
)

addEventHandler( "onClientPlayerVehicleEnter", localPlayer,
	function( vehicle, seat )
		if seat == 0 then
			startedInWatchedArea = inAnyColShape
		end
	end
)

--
-- the blips
--

addEvent( "lsia:airtrack:blips", true )
addEventHandler( "lsia:airtrack:blips", root,
	function( t )
		for player, vehicle in pairs( t ) do
			if not blips[ vehicle ] then
				blips[ vehicle ] = createBlipAttachedTo( vehicle, 0, 3, 0, 255, 255, 127 )
			end
		end
	end
)

addEvent( "lsia:airtrack:on", true )
addEventHandler( "lsia:airtrack:on", root,
	function( )
		if not blips[ source ] then
			blips[ source ] = createBlipAttachedTo( source, 0, 3, 0, 255, 255, 127 )
		end
	end
)

addEvent( "lsia:airtrack:off", true )
addEventHandler( "lsia:airtrack:off", root,
	function( )
		if blips[ source ] then
			destroyElement( blips[ source ] )
			blips[ source ] = nil
		end
	end
)
