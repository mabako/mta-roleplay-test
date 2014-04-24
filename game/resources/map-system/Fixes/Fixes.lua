_cx=createObject

function createObjectX(m,x,y,z,a,b,c,l,w)
	local t=_cx(m,x,y,z,a,b,c)
	if l then
		setElementAlpha(t,l)
	end
	
	local col = createColSphere(x,y,z,100)
	
	local function watchChanges( )
		if getElementDimension( getLocalPlayer( ) ) ~= getElementDimension(t) and getElementInterior(t) == getElementInterior( getLocalPlayer( ) ) then
			setElementDimension( t, getElementDimension( getLocalPlayer( ) ) )
		end
	end
	addEventHandler( "onClientColShapeHit", col,
		function( element )
			if element == getLocalPlayer( ) then
				addEventHandler( "onClientRender", root, watchChanges )
			end
		end
	)
	addEventHandler( "onClientColShapeLeave", col,
		function( element )
			if element == getLocalPlayer( ) then
				removeEventHandler( "onClientRender", root, watchChanges )
			end
		end
	)
	addEventHandler( "onClientColShapeHit", col,
		function( element )
			if element == getLocalPlayer( ) then
				if not w or getElementInterior( element ) == w then
					setElementDimension( t, getElementDimension( element ) )
				else
					setElementDimension( t, getElementDimension( element ) + 1 )
				end
			end
		end
	)
	return t
end


createObjectX(2963,-791.77386474609,496.99490356445,1368.4364013672,0,0,269.17565917969,0) -- Marco's Bistro
createObjectX(9093,681.64575195313,-447.3166809082,-26.669584274292,0,89.999969482422,0,0) -- Steakhouse
createObjectX(8171,608.9248,-75.0812,1000.9953,0,270,0,0,2) -- Garage 111
createObjectX(8171,603.5,-75.0812,1000.9953,0,270,0,0,1) -- Garage 29
createObjectX(8171,603.5,-80.0812,1000.9953,0,270,0,0,1) -- Garage 29
createObjectX(8171,9.6639270782471,-27.395286560059,1002.5494384766,0,90,0,0,10) -- Vinewood 24/7