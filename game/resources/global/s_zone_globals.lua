gezn = getElementZoneName

-- caching to improve efficiency
local cache = { [true] = {}, [false] = {} }

function getElementZoneName( element, citiesonly )
	if citiesonly ~= true and citiesonly ~= false then citiesonly = false end
		
	if getElementDimension( element ) >= 19000 then
		local vehicle = exports.pool:getElement( "vehicle", getElementDimension( element ) - 20000 )
		if vehicle then
			return ( getElementZoneName( vehicle, citiesonly ) or "?" ) .. " [" .. getVehicleName( vehicle ) .. "]"
		end
	elseif not cache[citiesonly][ getElementDimension( element ) ] then
		name = ''
		if getElementDimension( element ) > 0 then
			--[[if citiesonly then
				local parent = exports['interior-system']:findParent( element )
				if parent then
					name = getElementZoneName( parent, citiesonly, true )
				end
			else]]
				local dimension, entrance, exit, interiorType, interiorElement = exports['interior-system']:findProperty( element )
				if entrance then
					name = getElementData( interiorElement, 'name' ) .. ", "..getZoneName ( entrance[1], entrance[2], entrance[3], false )
				end
			--end
			cache[citiesonly][ getElementDimension( element ) ] = name
		else
			name = gezn( element, citiesonly ), gezn( element, not citiesonly )
		end
		
		return name
	else
		return cache[citiesonly][ getElementDimension( element ) ]
	end
end

-- getZoneName ( float x, float y, float z, [bool citiesonly=false] )