local sounds = { }

-- Bind Keys required
function bindKeys(res)
	bindKey("n", "down", toggleSirens)
	
	for key, value in ipairs(getElementsByType("vehicle")) do
		if isElementStreamedIn(value) then
			if getElementData(value, "lspd:siren") then
				sounds[value] = playSound3D("siren.wav", 0, 0, 0, true)
				attachElements( sounds[value], value )
				setSoundVolume(sounds[value], 0.6)
				setSoundMaxDistance(sounds[value], 45)
				setElementDimension(sounds[value], getElementDimension(value))
				setElementInterior(sounds[value], getElementInterior(value))
			end
		end
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), bindKeys)

function toggleSirens()
	local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
	
	if (theVehicle) then
		if getElementData(theVehicle, "lspd:siren") then
			triggerServerEvent("lspd:setSirenState", theVehicle, false)
		elseif (exports.global:hasItem(theVehicle, 85)) then
			triggerServerEvent("lspd:setSirenState", theVehicle, true)
		end
	end
end
addCommandHandler("togglecarsirens", toggleSirens, false)

function streamIn()
	if getElementType( source ) == "vehicle" and getElementData( source, "lspd:siren" ) and not sounds[ source ] then
		sounds[source] = playSound3D("siren.wav", 0, 0, 0, true)
		attachElements( sounds[source], source )
		setSoundVolume(sounds[source], 0.6)
		setSoundMaxDistance(sounds[source], 45)
		setElementDimension(sounds[source], getElementDimension(source))
		setElementInterior(sounds[source], getElementInterior(source))
	end
end
addEventHandler("onClientElementStreamIn", getRootElement(), streamIn)

function streamOut()
	if getElementType( source ) == "vehicle" and sounds[source] then
		destroyElement( sounds[ source ] )
		sounds[ source ] = nil
	end
end
addEventHandler("onClientElementStreamOut", getRootElement(), streamOut)

function updateSirens( name )
	if name == "lspd:siren" and isElementStreamedIn( source ) and getElementType( source ) == "vehicle" then
		local attached = getAttachedElements( source )
		if attached then
			for key, value in ipairs( attached ) do
				if getElementType( value ) == "sound" and value ~= sounds[ source ] then
					destroyElement( value )
				end
			end
		end
		
		if not getElementData( source, name ) then
			if sounds[ source ] then
				destroyElement( sounds[ source ] )
				sounds[ source ] = nil
			end
		else
			if not sounds[ source ] then
				sounds[source] = playSound3D("siren.wav", 0, 0, 0, true)
				attachElements( sounds[source], source )
				setSoundVolume(sounds[source], 0.6)
				setSoundMaxDistance(sounds[source], 45)
				setElementDimension(sounds[source], getElementDimension(source))
				setElementInterior(sounds[source], getElementInterior(source))
			end
		end
	end
end
addEventHandler("onClientElementDataChange", getRootElement(), updateSirens)