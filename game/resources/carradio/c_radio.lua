radio = 0
lawVehicles = { [416]=true, [433]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [470]=true, [598]=true, [596]=true, [597]=true, [599]=true, [432]=true, [601]=true }

local streams = { }
--table.insert(streams, "http://81.173.3.20:80/")
--table.insert(streams, "http://78.159.104.139:80/")
--table.insert(streams, "http://78.159.104.191:80/")
--table.insert(streams, ":adnim-system\hi.mp3")
--table.insert(streams, "http://scfire-ntc-aa04.stream.aol.com/stream/1003")
--table.insert(streams, "http://80.94.69.106:6374")
--table.insert(streams, "http://scfire-dtc-aa06.stream.aol.com/stream")
--table.insert(streams, "http://207.200.96.229:8030")
--table.insert(streams, "http://svr1.mount.cc:22125/stream.mp3")
--table.insert(streams, "http://svr1.mount.cc:22125/stream4")
--table.insert(streams, "http://svr1.mount.cc:22125/stream2") 
--table.insert(streams, "http://svr1.mount.cc:22125/stream1")
table.insert(streams, "http://u12.sky.fm/sky_urbanjamz")
table.insert(streams, "http://80.94.69.106:6694")
table.insert(streams, "http://80.94.69.106:6374/")
table.insert(streams, "http://80.94.69.106:6344")
table.insert(streams, "http://80.94.69.106:6104")
table.insert(streams, "http://shoutcast.gmgradio.com:10040/")
--table.insert(streams, "http://listen.radionomy.com/happychristmasradio")
local soundElement = nil
local soundElementsOutside = { }

function setVolume(commandname, val)
	if tonumber(val) then
		val = tonumber(val)
		if (val >= 0 and val <= 100) then
			triggerServerEvent("car:radio:vol", getLocalPlayer(), val)
			return
		end
	end
	outputChatBox("Fail")
end
addCommandHandler("setvol", setVolume)

function saveRadio(station)
	if not (getPlayerName(getLocalPlayer()) == "Elias_Pax") then
		return
	end
	outputDebugString("here?")
	local radios = 0
	if (station == 0) then
		return
	end

	if exports.vgscoreboard:isVisible() then
		cancelEvent()
		return
	end
	
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	
	if (vehicle) then
		if getVehicleOccupant(vehicle) == getLocalPlayer() or getVehicleOccupant(vehicle, 1) == getLocalPlayer() then
			if (station == 12) then	
				if (radio == 0) then
					radio = #streams + 1
				end
				
				if (streams[radio-1]) then
					radio = radio-1
				else
					radio = 0
				end
			elseif (station == 1) then
				if (streams[radio+1]) then
					radio = radio+1
				else
					radio = 0
				end
			end
			triggerServerEvent("car:radio:sync", getLocalPlayer(), radio)
		end
		cancelEvent()
	end
end
addEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), saveRadio)


addEventHandler("onClientPlayerVehicleEnter", getLocalPlayer(),
	function(theVehicle)
		stopStupidRadio()
		radio = getElementData(theVehicle, "vehicle:radio") or 0
		updateLoudness(theVehicle)
	end
)

addEventHandler("onClientPlayerVehicleExit", getLocalPlayer(),
	function(theVehicle)
		stopStupidRadio()
		radio = getElementData(theVehicle, "vehicle:radio") or 0
		updateLoudness(theVehicle)
	end
)

function stopStupidRadio()
	removeEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), saveRadio)
	setRadioChannel(0)
	addEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), saveRadio)
end

addEventHandler ( "onClientElementDataChange", getRootElement(),
	function ( dataName )
		if getElementType ( source ) == "vehicle" and dataName == "vehicle:radio" then
			local newStation =  getElementData(source, "vehicle:radio")  or 0
			if (isElementStreamedIn (source)) then
				if newStation ~= 0 then
					stopSound(soundElementsOutside[source])
					local x, y, z = getElementPosition(source)
					newSoundElement = playSound3D(streams[newStation], x, y, z, true)
					soundElementsOutside[source] = newSoundElement
					updateLoudness(source)
					setElementDimension(newSoundElement, getElementDimension(source))
					setElementDimension(newSoundElement, getElementDimension(source))
				else
					if (soundElementsOutside[source]) then
						stopSound(soundElementsOutside[source])
						soundElementsOutside[source] = nil
					end
				end
			end
		elseif getElementType(source) == "vehicle" and dataName == "vehicle:windowstat" then
			if (isElementStreamedIn (source)) then
				if (soundElementsOutside[source]) then
					updateLoudness(source)
				end
			end
		elseif getElementType(source) == "vehicle" and dataName == "vehicle:radio:volume" then
			if (isElementStreamedIn (source)) then
				if (soundElementsOutside[source]) then
					updateLoudness(source)
				end
			end
		end
		
		--
	end 
)

addEventHandler( "onClientPreRender", getRootElement(),
	function()
		if soundElementsOutside ~= nil then
			for element, sound in pairs(soundElementsOutside) do
				if (isElement(sound) and isElement(element)) then
					local x, y, z = getElementPosition(element)
					setElementPosition(sound, x, y, z)
					setElementInterior(sound, getElementInterior(element))
					getElementDimension(sound, getElementDimension(element))
				end
			end
		end
	end	
)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function()	
		local vehicles = getElementsByType("vehicle")
		for _, theVehicle in ipairs(vehicles) do
			if (isElementStreamedIn(theVehicle)) then
				spawnSound(theVehicle)
			end
		end
	end
)

function spawnSound(theVehicle)
	local newSoundElement = nil
    if getElementType( theVehicle ) == "vehicle" then
		local radioStation = getElementData(theVehicle, "vehicle:radio") or 0
		if radioStation ~= 0 then
			if (soundElementsOutside[theVehicle]) then
				stopSound(soundElementsOutside[theVehicle])
			end
			local x, y, z = getElementPosition(theVehicle)
			newSoundElement = playSound3D(streams[radioStation], x, y, z, true)
			soundElementsOutside[theVehicle] = newSoundElement
			setElementDimension(newSoundElement, getElementDimension(theVehicle))
			setElementDimension(newSoundElement, getElementDimension(theVehicle))
			updateLoudness(theVehicle)
		end
    end
end

function updateLoudness(theVehicle)
	local windowState = getElementData(theVehicle, "vehicle:windowstat") or 1
	local carVolume = getElementData(theVehicle, "vehicle:radio:volume") or 60
	
	carVolume = carVolume / 100
	
	--  ped is inside
	if (getPedOccupiedVehicle( getLocalPlayer() ) == theVehicle) then
		setSoundMinDistance(soundElementsOutside[theVehicle], 8)
		setSoundMaxDistance(soundElementsOutside[theVehicle], 15)
		setSoundVolume(soundElementsOutside[theVehicle], 1*carVolume)
	elseif (windowState == 1) then -- window is open, ped outside
		setSoundMinDistance(soundElementsOutside[theVehicle], 25)
		setSoundMaxDistance(soundElementsOutside[theVehicle], 70)
		setSoundVolume(soundElementsOutside[theVehicle], 0.9*carVolume)
	else -- outside with closed windows
		setSoundMinDistance(soundElementsOutside[theVehicle], 3)
		setSoundMaxDistance(soundElementsOutside[theVehicle], 10)
		setSoundVolume(soundElementsOutside[theVehicle], 0.1*carVolume)
	end

end

addEventHandler( "onClientElementStreamIn", getRootElement( ),
    function ( )
		spawnSound(source)
    end
)

addEventHandler( "onClientElementStreamOut", getRootElement( ),
    function ( )
		local newSoundElement = nil
        if getElementType( source ) == "vehicle" then
			if (soundElementsOutside[source]) then
				stopSound(soundElementsOutside[source])
				soundElementsOutside[source] = nil
			end
        end
    end
)