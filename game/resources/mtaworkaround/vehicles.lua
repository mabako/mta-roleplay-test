local element = "vehicle"
local enabled = true
local streamdistance = 60

local root = getRootElement()
local localPlayer = getLocalPlayer()

local function checkStreamIn()
	if ( enabled ) then
		local x, y, z = getElementPosition(localPlayer)
		local playerdimension = getElementDimension (localPlayer)
		
		for key, value in pairs(getElementsByType(element)) do
			if ( getVehicleOccupant ( value ) ) then
				streamInElement( value )
			else
				local vx, vy, vz = getElementPosition(value)
				local distx = x - vx
				local disty = y - vy
					
				if (distx < 0) then
					distx = distx - distx - distx
				end
				if (disty < 0) then
					disty = disty - disty - disty
				end
					
				if (distx < streamdistance) and (disty < streamdistance) then
					streamInElement( value )
				else
					streamOutElement(value)
				end
			end
		end
	end
end
setTimer(checkStreamIn, 500, 0)

local function isElementStreamedOut ( theElement )
	return getElementDimension( theElement ) == 65256
end

function streamOutElement( theElement )
	if  (getElementType(theElement) == element ) and not (isElementStreamedOut(theElement)) then
		local currentDimension = getElementDimension( theElement )
		setElementDimension(theElement, 65256)
		setElementData(theElement, "streamer:"..element..":dimension", currentDimension, false)
	end
end

function streamInElement( theElement )
	if  (getElementType(theElement) == element ) and (isElementStreamedOut(theElement)) then
		local destinationDimension = getElementData(theElement, "streamer:"..element..":dimension") or 0
		setElementDimension(theElement, destinationDimension)
		setElementData(theElement, "streamer:"..element..":dimension", false, false)
	end
end

addEventHandler("onClientElementStreamOut", root,
	function ()
		if (getElementType(source) == element and enabled) then
			 streamOutElement( source )
		end
	end
);

local function streamerStop(resource)
	if (resource == getThisResource()) then
		for key, value in pairs(getElementsByType(element)) do
			streamInElement(value)
		end
	end
end
addEventHandler("onClientResourceStop", getRootElement(), streamerStop)

function applyVehicleClientConfigSettings()
	local streamerEnabled = tonumber( exports['account-system']:loadSavedData("streamer-"..element.."-enabled", "1") )
	if (streamerEnabled == 1) then
		enabled = true
	else
		enabled = false
		streamerStop( getThisResource() )
	end
	local streamerDistance = tonumber( exports['account-system']:loadSavedData("streamer-"..element, "60") )
	if (streamerDistance) then
		streamdistance = streamerDistance
	end
end
addEventHandler("accounts:options:settings:updated", getRootElement(), applyVehicleClientConfigSettings)