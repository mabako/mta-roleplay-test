governmentVehicle = { [407]=true, [416]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [596]=true, [597]=true, [598]=true, [599]=true, [601]=true, [428]=true }
orangeVehicle = { [525]=true, [524]=true, [486]=true, [552]=true, [578]=true }

local factions = 
{
	-- faction types
	[-2] = {1, 61, governmentVehicle}, -- Law
	[-3] = {1, 61, governmentVehicle}, -- Government
	[-4] = {3, 61, governmentVehicle}, -- Medical
	
	-- 0 = civilian vehicles OR no other strobes
	[0] = {2, false, orangeVehicle},
	
	-- factions
	[64] = {2, false, governmentVehicle}, -- Los Santos International Airport
}

function vehicleBlown()
	exports['anticheat-system']:changeProtectedElementDataEx(source, "lspd:flashers", nil, true)
end
addEventHandler("onVehicleRespawn", getRootElement(), vehicleBlown)

local function getFactionType(vehicle)
	local vehicleFactionID = getElementData(vehicle, "faction")
	local vehicleFactionElement = exports.pool:getElement("team", vehicleFactionID)
	if vehicleFactionElement then
		return getElementData(vehicleFactionElement, "type"), vehicleFactionID
	end
	return 100, 100
end

local function canUseStrobes(vehicle, data)
	if data then
		if data[2] and exports.global:hasItem(vehicle, data[2]) then
			return data[1]
		end
		for i = 3, #data do
			if data[i][getElementModel(vehicle)] then
				return data[1]
			end
		end
	end
	return false
end

function toggleFlasherState()
	if not (client) then
		return false
	end
	local theVehicle = getPedOccupiedVehicle(client)
	if not theVehicle then
		return false
	end
	
	if (theVehicle) then
		local currentFlasherState = getElementData(theVehicle, "lspd:flashers") or 0
		if currentFlasherState ~= 0 then
			exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "lspd:flashers", nil, true)
		else
			local type, id = getFactionType(theVehicle)
			local color = canUseStrobes(theVehicle, factions[-type]) or canUseStrobes(theVehicle, factions[id]) or canUseStrobes(theVehicle, factions[0])
			if color then
				exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "lspd:flashers", color, true)
			else
				outputChatBox("Strobes don't seem to work in this car...", client, 255, 0, 0)
			end
		end
	end
end
addEvent( "lspd:toggleFlashers", true )
addEventHandler( "lspd:toggleFlashers", getRootElement(), toggleFlasherState )