local backboneItems = { }

function removeBackboneOnExit()
	removeBackboneItem(source)
	backboneItems[source] = nil
end
addEventHandler("onPlayerQuit", getRootElement(), removeBackboneOnExit)

function addBackboneItem(player, itemID)
	if not (backboneItems[player]) then
		backboneItems[player] = { }
	end
	local tempObj = createBackboneModel(player, itemID)
	if tempObj then
		table.insert(backboneItems[player], tempObj)
	end
end

function removeBackboneItem(player, itemID)
	if (backboneItems[player]) then
		
		for theIndex, theObject in pairs(backboneItems[player]) do
			if not itemID then -- remove them all anyways
				destroyElement(theObject)
			else
				if (getElementModel(theObject) == itemID) then
					destroyElement(theObject)
					backboneItems[player][theIndex] = nil
				end	
			end
		end
		if not itemID then -- remove them all anyways
			backboneItems[player] = nil
		end
	end
end

function createBackboneModel(player, modelid)
	if (backboneItems[player] == nil) then
		backboneItems[player] = { }
	end
	
	for theIndex, theObject in pairs(backboneItems[player]) do
		if (getElementModel(theObject) == itemID) then
			destroyElement(theObject)
		end	
	end

	local px, py, pz = getElementPosition(player)
	
	local offx, offy, offz, roffx, roffy, roffz= returnModelOffsets(modelid)

	local object = createObject(modelid, px+offx,py+offy,pz+offz, roffx, roffy, roffz)
	attachElements(object, player, offx, offy, offz, roffx, roffy, roffz)

	setElementCollisionsEnabled(object, false)
	return object
end

function updateBackBone()
	local thePlayerTable = getElementsByType ( "player", getRootElement(), false )
	for _, thePlayer in pairs(thePlayerTable) do
		if (isElement(thePlayer)) then
			if (backboneItems[thePlayer]) then
				local int = getElementInterior(thePlayer)
				local dim = getElementDimension(thePlayer)
				for theIndex, theObject in pairs(backboneItems[thePlayer]) do
					local modelID = getElementModel(theObject)
					local crouched = isPedDucked(thePlayer)
					local offx, offy, offz, roffx, roffy, roffz = returnModelOffsets(modelID, crouched)
						
					setElementAttachedOffsets(theObject,offx, offy,offz, roffx, roffy, roffz)
					setElementDimension(theObject, dim)
					setElementInterior(theObject, int)
				end
			end
		end
	end
	
end

addEventHandler("onClientRender", getRootElement(), updateBackBone)

function returnModelOffsets(modelID, crouched)
	if (modelID == 2918) then -- Deagle
		local cr = crouched and -0.525 or 0.09
		return 0.19, 0, cr, 0, 90, 90
	--		AK-47				M4				Shotgun			Combat shotgun		Rifle			Sniper
	elseif (modelID == 355 or modelID == 356 or modelID == 349 or modelID == 351 or modelID == 357 or modelID == 358) then
		local cr = crouched and -0.015 or 0.35
		return -0.13, -0.25, cr, 0,20, 0
	end
	
	return 0, 0, 0, 0, 0, 0
end

addEventHandler( "onClientResourceStart", getResourceRootElement(),
	function ( startedRes )
		triggerServerEvent("realism:backbone.request", getLocalPlayer())
	end
);

addEvent("realism:backbone.addBackboneItem", true)
addEventHandler( "realism:backbone.addBackboneItem", getRootElement(), addBackboneItem )

addEvent("realism:backbone.removeBackboneItem", true)
addEventHandler( "realism:backbone.removeBackboneItem", getRootElement(), removeBackboneItem )