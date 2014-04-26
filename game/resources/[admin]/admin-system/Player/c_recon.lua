local timer = false
local localPlayer = getLocalPlayer( )

local function requestFix( )
	triggerServerEvent( "fixRecon", localPlayer, getElementAttachedTo( localPlayer ) )
	setElementInterior( localPlayer, getElementInterior( getElementAttachedTo( localPlayer ) ) )
	setElementDimension( localPlayer, getElementDimension( getElementAttachedTo( localPlayer ) ) )
	timer = nil
end

addEventHandler( "onClientRender", getRootElement( ),
	function( )
		local element = getElementAttachedTo( localPlayer )
		if element then
			if getElementDimension( element ) ~= getElementDimension( localPlayer ) or getElementInterior( element ) ~= getElementInterior( localPlayer ) then
				if not timer then
					timer = setTimer( requestFix, 1000, 1 )
					return
				end
			end
		end
		if timer then
			killTimer( timer )
			timer = nil
		end
	end
)