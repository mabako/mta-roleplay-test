local x = 1479.455078125
local y = -1686.5869140625
local z = 11.046875

local tree = createObject(654, x, y, z)

createObject(3038, x-2, y-2, z+8, 0, 0, 45)
createObject(3038, x-2, y-2, z+12, 0, 0, 45)
createObject(3038, x-2, y-2, z+16, 0, 0, 45)

createObject(3038, x, y+3, z+8, 0, 0, 270)
createObject(3038, x, y+3, z+12, 0, 0, 270)
createObject(3038, x, y+3, z+16, 0, 0, 270)

createObject(3038, x+3, y, z+8, 0, 0, 180)
createObject(3038, x+3, y, z+12, 0, 0, 180)
createObject(3038, x+3, y, z+16, 0, 0, 180)

local markers = { }

function resStart(res)
	if (res==getThisResource()) then
		markers[1] = createMarker(x-3, y-3, z+8, "corona", 2, 255, 194, 15, 255)
		markers[2] = createMarker(x+3, y+3, z+8, "corona", 2, 255, 0, 0, 255)
		markers[3] = createMarker(x+3, y-3, z+8, "corona", 2, 0, 255, 0, 255)
		markers[4] = createMarker(x-3, y+3, z+8, "corona", 2, 0, 0, 255, 255)
		
		markers[5] = createMarker(x-1, y-3, z+10, "corona", 2, 255, 194, 15, 255)
		markers[6] = createMarker(x+1, y+3, z+9, "corona", 2, 255, 0, 0, 255)
		markers[7] = createMarker(x+1, y-3, z+10, "corona", 2, 0, 255, 0, 255)
		markers[8] = createMarker(x-1, y+3, z+11, "corona", 2, 0, 0, 255, 255)
		
		markers[9] = createMarker(x-3, y+3, z+13, "corona", 2, 255, 194, 15, 255)
		markers[10] = createMarker(x+3, y-3, z+13, "corona", 2, 255, 0, 0, 255)
		markers[11] = createMarker(x+3, y+3, z+13, "corona", 2, 0, 255, 0, 255)
		markers[12] = createMarker(x-3, y-3, z+13, "corona", 2, 0, 0, 255, 255)
		
		markers[13] = createMarker(x, y, z+20, "corona", 2, 255, 194, 15, 255)
	end
end
addEventHandler("onClientResourceStart", getRootElement(), resStart)

local fade = 0

function streamInTree()
	addEventHandler("onClientPreRender", getRootElement(), renderChangeColor)
end
addEventHandler("onClientElementStreamIn", tree, streamInTree)

function streamOutTree()
	removeEventHandler("onClientPreRender", getRootElement(), renderChangeColor)
end
addEventHandler("onClientElementStreamOut", tree, streamOutTree)

function renderChangeColor()
	for key, value in ipairs (markers) do
		local r, g, b, a = getMarkerColor(markers[key])
	
		if ( fade == 0 ) then
			r = r - key
		elseif ( fade == 1 ) then
			g = g - key
		elseif ( fade == 2 ) then
			b = b - key
		elseif ( fade == 3 ) then
			r = r + key
		elseif ( fade == 4 ) then
			g = g + key
		elseif ( fade == 5 ) then
			b = b + key
		end

		if ( r == 0 and fade == 0 ) then
			fade = 1
		elseif ( g == 0 and fade == 1 ) then
			fade = 2
		elseif ( b == 0 and fade == 2 ) then
			fade = 3
		elseif ( r == 255 and fade == 3 ) then
			fade = 4
		elseif ( g == 255 and fade == 4 ) then
			fade = 5
		elseif ( b == 255 and fade == 5 ) then
			fade = 0
		end
		
		setMarkerColor(markers[key], r, g, b, a)
	end
end