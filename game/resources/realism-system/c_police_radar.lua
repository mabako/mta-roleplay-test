local lawVehicles = { [416]=true, [433]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [598]=true, [596]=true, [597]=true, [599]=true, [432]=true, [601]=true }
local enabled = false

local counter = 0
local radarTimer = nil

local function policeRadar( )
	if enabled then
		local x, y, z = getElementPosition( getLocalPlayer( ) )
		local dimension = getElementDimension( getLocalPlayer( ) )
		
		local maxdist = 200
		
		for _, theVehicle in ipairs( getElementsByType( "vehicle" ) ) do
			if isElementStreamedIn( theVehicle ) and getElementDimension( theVehicle ) == dimension then
				if lawVehicles[ getElementModel( theVehicle ) ] then
					local dist = getDistanceBetweenPoints3D( x, y, z, getElementPosition( theVehicle ) )
					if dist < maxdist then
						maxdist = dist
					end
				end
			end
		end
		
		if maxdist < 200 then
			if maxdist < 50 or ( maxdist < 100 and ( counter == 0 or counter == 2 ) ) or counter == 0 then
				playSound( "policebeep.mp3" )
			end
		end
		counter = ( counter + 1 ) % 4
	end
end

addEventHandler( "onClientPlayerVehicleEnter", getLocalPlayer( ),
	function( )
		enabled = false
	end
)

addEventHandler( "onClientPlayerVehicleExit", getLocalPlayer( ),
	function( )
		enabled = false
	end
)

addEventHandler( "onClientResourceStart", getResourceRootElement(), 
	function( )
		radarTimer = setTimer( policeRadar, 500, 0 )
	end
)

addEvent( "enablePoliceRadar", true )
addEventHandler( "enablePoliceRadar", getLocalPlayer( ),
	function( )
		enabled = true
	end
)

addCommandHandler( "togglecradar",
	function( )
		if enabled then
			if isTimer( radarTimer ) then
				killTimer( radarTimer )
				radarTimer = nil
				outputChatBox( "You've turned your Escort 9500ci Radar Detector off!", 255, 0, 0 )
			else
				radarTimer = setTimer( policeRadar, 500, 0 )
				outputChatBox( "You've turned your Escort 9500ci Radar Detector on!", 255, 0, 0 )
			end
		end
	end
)