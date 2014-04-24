----*******************----
----*INTERIOR STREAMER*----
----* STEAMS  PICKUPS *----
----*******************----
local streamdistance = 50
local interiorsSpawned = {}
local elevatorsSpawned = { }
local colShapesSpawned = {}
local elevatorsColShapesSpawned = { }
local done = 0
local debugmode = false
function applyPickupClientConfigSettings()
	local streamerDistance = tonumber( exports['account-system']:loadSavedData("streamer-pickup", "25") )
	if (streamerDistance) then
		streamdistance = streamerDistance
	end
end
addEventHandler("accounts:options:settings:updated", getRootElement(), applyPickupClientConfigSettings)

addCommandHandler("interiordiff", function()
	local countItems = #getElementsByType("interior") + #getElementsByType("elevator")
	outputChatBox("Total: "..tostring(countItems))
	outputChatBox("Loaded: "..tostring(done))
end)

function resetme()
	done = 0
	outputChatBox("done.")
end
addCommandHandler("resetme",resetme)

function debugme()
	debugmode = not debugmode
	outputChatBox("done. (".. tostring(debugmode)..")")
end
addCommandHandler("debugme",debugme)
-- Lagcode
local lagcatcherenabled = false
local firsttime = true
function checkNearbyPickups(first)
	if first then
		firsttime = true
		showLagCatcher()
		firsttime = false
		setTimer(checkNearbyPickups, 2000, 0)
		if debugmode then
			outputDebugString("checkNearbyPickups returning 0" )
		end
		return 0
	end
	
	local countItems = #getElementsByType("interior") + #getElementsByType("elevator")
	
	--[[if (countItems == done) then
		if debugmode then
			outputDebugString("checkNearbyPickups returning 1" )
		end
		return 1
	end]]
	
	local possibleInteriors = getElementsByType("interior")
	for _, interior in ipairs(possibleInteriors) do
		local dbid = getElementData(interior, "dbid")
		if not interiorsSpawned[dbid] then 
			if not lagcatcherenabled then
				showLagCatcher()
			end
			if debugmode then
				outputDebugString("checkNearbyPickups/interiorloop: interiorShowPickups ".. tostring(dbid) )
			end
			interiorShowPickups(interior)
		end
	end
	
	local possibleElevators = getElementsByType("elevator")
	for _, elevator in ipairs(possibleElevators) do
		--local dbid = getElementData(elevator, "dbid")
		if getElementChildrenCount(elevator) ~= 2 then ---if not elevatorsSpawned[dbid] then 
			if not lagcatcherenabled then
				showLagCatcher()
			end
			if debugmode then
				outputDebugString("checkNearbyPickups/elevatorloop: interiorShowPickups ".. tostring(dbid) )
			end
			interiorShowPickups(elevator)
			
		end
	end
	updateLagCatcher()
	
	if debugmode then
		outputDebugString("checkNearbyPickups returning 2" )
	end
	return 2
end
setTimer(checkNearbyPickups, 500, 1, true)

function interiorCreateColshape(interiorElement)
	local dbid = getElementData(interiorElement, "dbid")
	if debugmode then
		outputDebugString("interiorCreateColshape running with  "..tostring(dbid) .." ".. getElementType( interiorElement ) == "elevator" and  "(elevator)" or "(interior)" )
	end
	local entrance = getElementData(interiorElement, "entrance")
	
	local outsideColShape = createColSphere ( entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z], 1 )
	
	if getElementType( interiorElement ) == "elevator" then
		setElementParent(outsideColShape, elevatorsSpawned[dbid][1])
	else
		setElementParent(outsideColShape, interiorsSpawned[dbid][1])
	end
	
	setElementInterior(outsideColShape, entrance[INTERIOR_INT])
	setElementDimension(outsideColShape, entrance[INTERIOR_DIM])
	setElementData(outsideColShape, "entrance", true, false)
	
	local exit = getElementData(interiorElement, "exit")
	local insideColShape = createColSphere ( exit[INTERIOR_X], exit[INTERIOR_Y], exit[INTERIOR_Z], 1 )
	if getElementType( interiorElement ) == "elevator" then
		setElementParent(insideColShape, elevatorsSpawned[dbid][2])
	else
		setElementParent(insideColShape, interiorsSpawned[dbid][2])
	end
	setElementInterior(insideColShape, exit[INTERIOR_INT])
	setElementDimension(insideColShape, exit[INTERIOR_DIM])
	setElementData(insideColShape, "entrance", false, false)
	if getElementType( interiorElement ) == "elevator" then
		elevatorsColShapesSpawned[dbid] = { outsideColShape, insideColShape }
	else
		colShapesSpawned[dbid] = { outsideColShape, insideColShape }
	end
	if debugmode then
		outputDebugString("interiorCreateColshape done with  "..tostring(dbid) .." ".. getElementType( interiorElement ) == "elevator" and  "(elevator)" or "(interior)" )
	end
end

function interiorRemoveColshape(interiorElement)
	local dbid = getElementData(interiorElement, "dbid")
	if debugmode then
		outputDebugString("interiorRemoveColshape running with  "..tostring(dbid) .." ".. getElementType( interiorElement ) == "elevator" and  "(elevator)" or "(interior)" )
	end
	if getElementType( interiorElement ) == "interior" then
		if not colShapesSpawned[dbid] then 
			return
		end
		
		destroyElement( colShapesSpawned[dbid][1])
		destroyElement( colShapesSpawned[dbid][2])
		colShapesSpawned[dbid] = false
	elseif getElementType( interiorElement ) == "elevator" then
		if not elevatorsColShapesSpawned[dbid] then 
			return
		end
		
		destroyElement( elevatorsColShapesSpawned[dbid][1])
		destroyElement( elevatorsColShapesSpawned[dbid][2])
		elevatorsColShapesSpawned[dbid] = false
	end
end

function interiorShowPickups(interiorElement)

	local dbid = getElementData(interiorElement, "dbid")
if debugmode then
		outputDebugString("interiorShowPickups running with  "..tostring(dbid) .." ".. getElementType( interiorElement ) == "elevator" and  "(elevator)" or "(interior)" )
	end	
	if getElementType( interiorElement ) == "elevator" then
		if getElementChildrenCount(interiorElement) == 2 then --if elevatorsSpawned[dbid] then 
			if debugmode then
			outputDebugString("interiorShowPickups returning with  "..tostring(dbid) ..": false, 1" )
			end	
			return false, 1
		end
	else
		if interiorsSpawned[dbid] then 
			if debugmode then
			outputDebugString("interiorShowPickups returning with  "..tostring(dbid) ..": false, 2" )
			end	
			return false, 2
		end
	end
	
	local entrance = getElementData(interiorElement, "entrance")
	local exit = getElementData(interiorElement, "exit")
	local int = getElementData(interiorElement, "status")
	
	if not entrance  then 
		if debugmode then
			outputDebugString("interiorShowPickups returning with  "..tostring(dbid) ..": false, 3" )
		end	
		return false, 3 
	end
	
	if not exit  then 
		if debugmode then
			outputDebugString("interiorShowPickups returning with  "..tostring(dbid) ..": false, 4" )
		end	
		return false, 4
	end
	
	if not int  then 
		if debugmode then
			outputDebugString("interiorShowPickups returning with  "..tostring(dbid) ..": false, 5" )
		end	
		return false, 5 
	end
	
	local outsidePickup = createPickup( entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z], 3, int[INTERIOR_DISABLED] and 1314 or ( getElementType(interiorElement) == "elevator" and 1318 or ( int[INTERIOR_TYPE] == 2 and 1318 or ( int[INTERIOR_OWNER] < 1 and ( int[INTERIOR_TYPE] == 1 and 1272 or 1273 ) or 1318 ) ) ) )
	setElementParent(outsidePickup, interiorElement)
	setElementInterior(outsidePickup, entrance[INTERIOR_INT])
	setElementDimension(outsidePickup, entrance[INTERIOR_DIM])
	setElementData(outsidePickup, "dim", entrance[INTERIOR_DIM], false)
	
	local insidePickup = createPickup( exit[INTERIOR_X], exit[INTERIOR_Y], exit[INTERIOR_Z], 3,  1318 )
	setElementParent(insidePickup, interiorElement)
	setElementInterior(insidePickup, exit[INTERIOR_INT])
	setElementDimension(insidePickup, exit[INTERIOR_DIM])
	setElementData(insidePickup, "dim", exit[INTERIOR_DIM], false)
	
	setElementData(insidePickup, "other", outsidePickup, false)
	setElementData(outsidePickup, "other", insidePickup, false)
	
	if getElementType(interiorElement) == "elevator" then
		elevatorsSpawned[dbid] = { outsidePickup, insidePickup }
	else
		interiorsSpawned[dbid] = { outsidePickup, insidePickup }
	end
	interiorCreateColshape(interiorElement)
	done = done + 1
	if debugmode then
		outputDebugString("interiorShowPickups returning with  "..tostring(dbid) ..": true, "..getElementType(interiorElement) == "interior" and 1 or 2 )
	end	
	return true, getElementType(interiorElement) == "interior" and 1 or 2
end

function interiorRemovePickups(interiorElement)
	local dbid = getElementData(interiorElement, "dbid")
	
	if debugmode then
		outputDebugString("interiorRemovePickups running with  "..tostring(dbid) .." ".. getElementType( interiorElement ) == "elevator" and  "(elevator)" or "(interior)" )
	end	
	
	if getElementType( interiorElement ) == "interior" then
		if not interiorsSpawned[dbid] then 
			if debugmode then
				outputDebugString("interiorRemovePickups returning with  "..tostring(dbid) ..": false,  1" )
			end	
			return false, 1
		end
		
		destroyElement( interiorsSpawned[dbid][1])
		destroyElement( interiorsSpawned[dbid][2])
		interiorsSpawned[dbid] = false
		done = done - 1
		if debugmode then
			outputDebugString("interiorRemovePickups finished resulting on  "..tostring(dbid) .." true, 1" )
		end
		
		return true, 1
	elseif getElementType( interiorElement ) == "elevator" then
		if getElementChildrenCount(interiorElement) == 2 then 
			if debugmode then
				outputDebugString("interiorRemovePickups returning with  "..tostring(dbid) ..": false,  2" )
			end	
			return false, 2
		end
		
		destroyElement( elevatorsSpawned[dbid][1])
		destroyElement( elevatorsSpawned[dbid][2])
		elevatorsSpawned[dbid] = false
		done = done - 1
		if debugmode then
			outputDebugString("interiorRemovePickups finished resulting on  "..tostring(dbid) .." true, 2" )
		end
		return true, 2
	else
		outputDebugString(" interiorRemovePickupsFail? ")
		outputDebugString("---")
		outputDebugString(tostring(interiorElement))
		outputDebugString(tostring(getElementType(interiorElement)))
		outputDebugString(tostring(dbid))
		outputDebugString("---")
	end
	
	if debugmode then
		outputDebugString("interiorRemovePickups finished without result on  "..tostring(dbid) )
	end	
	return true
end


function deleteInteriorElement(databaseID)
	if debugmode then
		outputDebugString("interiorRemovePickups running with  "..tostring(databaseID) .." ".. getElementType( source ) == "elevator" and  "(elevator)" or "(interior)" )
	end
	if getElementType(source) == "interior" then
		interiorRemovePickups(source)
		interiorRemoveColshape(source)
		interiorsSpawned[databaseID] = nil
		colShapesSpawned[databaseID] = nil
	elseif getElementType(source) == "elevator" then
		interiorRemovePickups(source)
		interiorRemoveColshape(source)
		elevatorsSpawned[databaseID] = nil
		elevatorsColShapesSpawned[databaseID] = nil
	end
end
addEvent("deleteInteriorElement", true)
addEventHandler("deleteInteriorElement", getRootElement(), deleteInteriorElement)
----********END********----
----*INTERIOR STREAMER*----
----********END********----

----*******************----
----*  PICKUP HANDLER *----
----*******************----
local lastSource = nil
local lastCol = nil
local lastSourceIsEntrance = false
function enterInterior()
	local localElement = getLocalPlayer()
	local localDimension = getElementDimension( getLocalPlayer() )
	local vehicleElement = false
	local theVehicle = getPedOccupiedVehicle( getLocalPlayer() )
	if theVehicle and getVehicleOccupant ( theVehicle, 0 ) == getLocalPlayer() then
		vehicleElement = theVehicle
	end	
	local found, foundInterior, foundColShape, foundIsEntrance = false	
	for _, interior in ipairs( getElementsByType('interior') ) do
		local dbid = getElementData(interior, "dbid")
		local intEntrance = getElementData(interior, "entrance")
		local intExit = getElementData(interior, "exit")
		if colShapesSpawned[dbid] then
			if (isElementWithinColShape ( localElement, colShapesSpawned[dbid][1] ) or vehicleElement and isElementWithinColShape ( vehicleElement, colShapesSpawned[dbid][1] ) ) and localDimension == intEntrance[INTERIOR_DIM] then
				found = true
				foundInterior = interior
				foundColShape = colShapesSpawned[dbid][1]
				foundIsEntrance = true
				break
			elseif (isElementWithinColShape ( localElement, colShapesSpawned[dbid][2] ) or vehicleElement and isElementWithinColShape ( vehicleElement, colShapesSpawned[dbid][1] ) ) and localDimension == intExit[INTERIOR_DIM] then
				found = true
				foundInterior = interior
				foundColShape = colShapesSpawned[dbid][2]
				foundIsEntrance = false
				break	
			end
		end
	end
	
	if not found then
		for _, elevator in ipairs( getElementsByType('elevator') ) do
			local dbid = getElementData(elevator, "dbid")
			local eleEntrance = getElementData(elevator, "entrance")
			local eleExit = getElementData(elevator, "exit")
			if elevatorsColShapesSpawned[dbid] then
				if (isElementWithinColShape ( localElement, elevatorsColShapesSpawned[dbid][1] ) or vehicleElement and isElementWithinColShape ( vehicleElement, colShapesSpawned[dbid][1] ) ) and localDimension == eleEntrance[INTERIOR_DIM] then
					found = true
					foundInterior = elevator
					foundColShape = elevatorsColShapesSpawned[dbid][1]
					foundIsEntrance = true
					break
				elseif (isElementWithinColShape ( localElement, elevatorsColShapesSpawned[dbid][2] ) or vehicleElement and isElementWithinColShape ( vehicleElement, colShapesSpawned[dbid][1] ) ) and localDimension == eleExit[INTERIOR_DIM] then
					found = true
					foundInterior = elevator
					foundColShape = elevatorsColShapesSpawned[dbid][2]
					foundIsEntrance = false
					break	
				end
			end
		end
	end
	
	if not found then 
		return
	end
	
	local interiorID = getElementData(foundInterior, "dbid")
	if interiorID then
		local interiorEntrance = getElementData(foundInterior, "entrance")
		local interiorExit = getElementData(foundInterior, "exit")
		
		local canEnter, errorCode, errorMsg = canEnterInterior(foundInterior)
		if canEnter or isInteriorForSale( foundInterior ) then
			if getElementType(foundInterior) == "interior" then
				triggerServerEvent("interior:enter", foundInterior)
			else
				triggerServerEvent("elevator:enter", foundInterior, foundIsEntrance)
			end
		else
			outputChatBox(errorMsg, 255, 0, 0)
		end
	end
end

function bindKeys(int)
	bindKey("enter", "down", enterInterior)
	bindKey( "f", "down", enterInterior)
	toggleControl("enter_exit", false)
	triggerServerEvent("int:updatemarker", getLocalPlayer(), true)
end

function unbindKeys(int)
	unbindKey("enter", "down", enterInterior)
	unbindKey("f", "down", enterInterior)
	toggleControl("enter_exit", true)
	triggerServerEvent("int:updatemarker", getLocalPlayer(), false)
	
	triggerEvent("displayInteriorName", getLocalPlayer() )
end

function checkLeavePickupStart(var1)
	if var1 then
		bindKeys(  source )
		lastSource = source
	end
end
addEventHandler("displayInteriorName", getRootElement(), checkLeavePickupStart)

function hitInteriorPickup(theElement, matchingdimension)
	local colshape = getElementParent(getElementParent(source))
	if getElementType(colshape) == "interior" or getElementType(colshape) == "elevator" then
		local isVehicle = false
		local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
		if theVehicle and theVehicle == theElement and getVehicleOccupant ( theVehicle, 0 ) == getLocalPlayer() then
			isVehicle = true
		end		
		
		if matchingdimension and (theElement == getLocalPlayer() or isVehicle)  then
			if getElementType(colshape) == "interior" or getElementType(colshape) == "elevator" then
				lastSource = false
				triggerServerEvent("interior:requestHUD", colshape)
				lastSourceIsEntrance = getElementData(source,"entrance") or false
				lastCol = source
			end
		end
		cancelEvent()
	end
end
addEventHandler("onClientColShapeHit", getRootElement(), hitInteriorPickup)

function leaveInteriorPickup(thePlayer, matchingdimension)
	if lastSource and lastCol == source then
		unbindKeys(lastSource)
		lastSource = false
	end
end
addEventHandler("onClientColShapeLeave", getRootElement(), leaveInteriorPickup)
addEvent("manual-onClientColShapeLeave", true)
addEventHandler("manual-onClientColShapeLeave", getRootElement(), leaveInteriorPickup)

function vehicleStartEnter(thePlayer)
	if thePlayer == getLocalPlayer() then
		if getElementData(thePlayer, "interiormarker") then
			cancelEvent()
		end
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), vehicleStartEnter)
----********END********----
----*  PICKUP HANDLER *----
----********END********----

----*******************----
----*   Lag catcher   *----
----*******************----
local lagCatcherWindow, lagCatcherMessage = nil
function showLagCatcher()
	if not firsttime then return end
	
	lagcatcherenabled = true
	setTimer(hideLagCatcher, 5000, 1, 1)
	
	if (isElement(lagCatcherWindow)) then
		destroyElement(lagCatcherWindow)
	end
	
	local x, y = guiGetScreenSize()
	lagCatcherWindow = guiCreateWindow( x*.5-150, y*.5-65, 300, 120, "Attention!", false )
	guiWindowSetSizable( lagCatcherWindow, false )
	lagCatcherMessage = guiCreateLabel( 40, 30, 260, 80, "The server is sending all the interiors\nto your game, please standby. Your game\nmay hang for a few seconds in the process.\n", false, lagCatcherWindow )
	guiBringToFront( lagCatcherWindow )
	
	updateLagCatcher()
end

function updateLagCatcher()
	if lagcatcherenabled then
		local total = #getElementsByType("interior") + #getElementsByType("elevator")
		local str = "Process: "..tostring(done).."/"..tostring(total)
		guiSetText(lagCatcherMessage, "The server is sending interiors to your game,\nplease standby. Your game may hang for a\nfew seconds in the process.\n\n"..str)
	end
end

function hideLagCatcher(step)
	if step < 3 then
		setTimer(hideLagCatcher, 1000, 1, step+1)
		return
	end
	lagcatcherenabled = false
	destroyElement(lagCatcherMessage)
	destroyElement(lagCatcherWindow)
end

----********END********----
----*   Lag catcher   *----
----********END********----