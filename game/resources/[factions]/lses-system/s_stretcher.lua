local stretcherArray = { }

function hasPlayerStretcherSpawned( playerElement )
	return isElement(playerElement) and stretcherArray[playerElement] and true or false
end
addEvent( "stretcher:hasPlayerStretcherSpawned", true )
addEventHandler( "stretcher:hasPlayerStretcherSpawned", getRootElement( ), hasPlayerStretcherSpawned )

function isPedStretcherOccupied( playerElement )
	return (getElementData(  stretcherArray[ playerElement ], "realism:stretcher:playerOnIt") and isElement(getElementData(  stretcherArray[ playerElement ], "realism:stretcher:playerOnIt")) and getElementAttachedTo ( stretcherArray[ playerElement ] ) == getElementData(  stretcherArray[ playerElement ], "realism:stretcher:playerOnIt"))
end
addEvent( "stretcher:isPedStretcherOccupied", true )
addEventHandler( "stretcher:isPedStretcherOccupied", getRootElement( ), isPedStretcherOccupied )

function destroyStretcher( playerElement )

	if not playerElement and source then
		playerElement = source
	end
	
	if  stretcherArray[ playerElement ] then
		detachElements( stretcherArray[ playerElement ], playerElement )
		destroyElement( stretcherArray[ playerElement ] )
		stretcherArray[ playerElement ] = false
		setElementData(playerElement, "realism:stretcher:hasStretcher", false, true)
		return true
	end
	return false
end
addEvent( "stretcher:destroyStretcher", true )
addEventHandler( "stretcher:destroyStretcher", getRootElement( ), destroyStretcher )

function createStretcher( playerElement )
	if not playerElement and source then
		playerElement = source
	end
	
	if (getPedOccupiedVehicle(playerElement)) then
		return
	end	

	if hasPlayerStretcherSpawned( playerElement ) then
		destroyStretcher( playerElement )
	else
		triggerClientEvent( playerElement, "stretcher:getPositionInFrontOfElement", getRootElement( ), playerElement ) 
	end
end
addEvent( "stretcher:createStretcher", true )
addEventHandler( "stretcher:createStretcher", getRootElement( ), createStretcher )

function getPositionInFrontOfElement( playerElement, x, y, z )
	if not hasPlayerStretcherSpawned( playerElement ) then
		stretcherArray[ playerElement ] = createObject ( 2146, x, y, z - 0.5, 0, 0, 0 )
		attachElements( stretcherArray[ playerElement ], playerElement, 0, 0, -0.5 )
		local attach_x, attach_y, attach_z = getElementPosition( stretcherArray[ playerElement ] )
		detachElements( stretcherArray[ playerElement ], playerElement )
		distance = getDistanceBetweenPoints2D( x, y, attach_x, attach_y )
		attachElements( stretcherArray[ playerElement ], playerElement, 0, distance, -0.5 )
		setElementCollisionsEnabled(stretcherArray[ playerElement ], false)
		-- Used for tracking clientside
		setElementData(playerElement, "realism:stretcher:hasStretcher",  stretcherArray[ playerElement ], true)
		setElementData(  stretcherArray[ playerElement ], "realism:stretcher:ownedBy", playerElement, true)
	end
end
addEvent( "stretcher:getPositionInFrontOfElement", true )
addEventHandler( "stretcher:getPositionInFrontOfElement", getRootElement( ), getPositionInFrontOfElement )

function checkPedEnterVehicleWithStretcher( clientid )
	if hasPlayerStretcherSpawned( clientid ) then
		cancelEvent( ) -- Cannot enter a vehicle with a stretcher
	end
end
addEventHandler ( "onVehicleStartEnter", getRootElement(), checkPedEnterVehicleWithStretcher )

function movePedOntoStretcher(	targetElement )
	if not targetElement or not isElement(targetElement) then 
		return false -- Target player does not exist
	end
	
	if not hasPlayerStretcherSpawned( source ) then 
		return false -- Stretcher does not exist
	end
	if getPedOccupiedVehicle( targetElement ) then
		return false -- Target player is in a vehicle :(
	end
	if isPedStretcherOccupied( source ) then
		return false -- Stretcher already in use.
	end


	local sourceX, sourceY, sourceZ = getElementPosition(source)
	local targetX, targetY, targetZ = getElementPosition(targetElement)
	if getDistanceBetweenPoints3D(sourceX, sourceY, sourceZ, targetX, targetY, targetZ ) > 10 then
		return false -- Far distance between the two players
	end
	
	attachElements( targetElement, stretcherArray[ source ], 0, 0, 1.5 )
	exports.global:applyAnimation( targetElement, "CRACK", "crckdeth2", -1, true )
	setElementData(  stretcherArray[ source ], "realism:stretcher:playerOnIt", targetElement, true )
	
end
addEvent( "stretcher:movePedOntoStretcher", true )
addEventHandler( "stretcher:movePedOntoStretcher", getRootElement( ), movePedOntoStretcher )

function takePedFromStretcher(	targetElement )
	if not targetElement or not isElement(targetElement) then 
		return false -- Target player does not exist
	end
	
	if not hasPlayerStretcherSpawned( source ) then 
		return false -- Stretcher does not exist
	end
	
	if getPedOccupiedVehicle( targetElement ) then
		return false -- Target player is in a vehicle :(
	end
	
	local sourceX, sourceY, sourceZ = getElementPosition(source)
	local targetX, targetY, targetZ = getElementPosition(targetElement)
	if getDistanceBetweenPoints3D(sourceX, sourceY, sourceZ,  targetX, targetY, targetZ ) > 10 then
		return false -- Far distance between the two players
	end
	
	detachElements( targetElement, stretcherArray[ source ], 0, 0, 1.5 )
	exports.global:removeAnimation(targetElement)
	setElementData(  stretcherArray[ source ], "realism:stretcher:playerOnIt", false, false )
end
addEvent( "stretcher:takePedFromStretcher", true )
addEventHandler( "stretcher:takePedFromStretcher", getRootElement( ), takePedFromStretcher )
