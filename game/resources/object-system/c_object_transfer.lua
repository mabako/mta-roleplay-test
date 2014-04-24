local objects = { }
local oldDimension = 65535
local safeToSpawn = true
local safeTimer = nil

function receiveSync(dimensionObjects, theDimension)
	clearObjects(theDimension)
	objects[theDimension] = dimensionObjects
	streamDimensionIn(theDimension)	
end
addEvent( "object:sync", true )

addEventHandler( "object:sync", getRootElement(), receiveSync )

function receiveSyncStart()
	safeToSpawn = false
	safeTimer = setTimer(resetSpawnTimer, 5000, 1)
end
addEvent( "object:sync:start", true )
addEventHandler( "object:sync:start", getRootElement(), receiveSyncStart )

function resetSpawnTimer()
	safeToSpawn = true
end

function isSafeToSpawn()
	return safeToSpawn
end

function clearObjects(theDimension)
	local t = theDimension and { [theDimension] = objects[theDimension] } or objects
	for dimension, objs in pairs(t) do
		for id, object in ipairs(objs) do
			if object.o then
				destroyElement( object.o )
				object.o = nil
			end
		end
	end
end

function clearCache(theDimension)
	clearObjects(theDimension)
	if theDimension then
		objects[ tonumber(theDimension) ] = nil
	else
		objects = { }
	end
end
addEvent( "object:clear", true )
addEventHandler( "object:clear", getRootElement(), clearCache )

function createObjectEx(m,x,y,z,a,b,c,i,d)
	local t=createObject(m,x,y,z,a,b,c)
	setElementDimension(t,d)
	setElementInterior(t,i)
	return t
end

function streamDimensionIn(theDimension)
	if objects[theDimension] then
		for id, data in ipairs(objects[theDimension]) do
			data.o = createObjectEx(data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8], theDimension)
			setElementCollisionsEnabled ( data.o, data[9] )
			setElementDoubleSided ( data.o, data[10] )
			setElementData(data.o, "object:dbid", data[11], false)
		end
	end
	if safeTimer then
		setTimer(resetSpawnTimer, 500, 1)
		killTimer(safeTimer)
	end
end

function detectInteriorChange()
	local currentDimension = getElementDimension( getLocalPlayer() )
	if (currentDimension ~= oldDimension) and (currentDimension ~= 65535) then
		clearObjects()
		if not objects[currentDimension] then
			triggerServerEvent("object:requestsync", getLocalPlayer(), currentDimension)
		else
			safeToSpawn = false
			safeTimer = setTimer(resetSpawnTimer, 10000, 1)
			streamDimensionIn(currentDimension)
		end
		oldDimension = currentDimension
	end
end
addEventHandler ("onClientPreRender", getRootElement(), detectInteriorChange)