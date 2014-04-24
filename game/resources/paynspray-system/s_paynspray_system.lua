mysql = exports.mysql

armoredCars = { [427]=true, [528]=true, [432]=true, [601]=true, [428]=true, [597]=true } -- Enforcer, FBI Truck, Rhino, SWAT Tank, Securicar, SFPD Car
governmentVehicle = { [416]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [596]=true, [597]=true, [598]=true, [599]=true, [601]=true, [428]=true }

function createSpray(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local x, y, z = getElementPosition(thePlayer)
		local interior = getElementInterior(thePlayer)
		local dimension = getElementDimension(thePlayer)
		
		local id = mysql:query_insert_free("INSERT INTO paynspray SET x='"  .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .. "', z='" .. mysql:escape_string(z) .. "', interior='" .. mysql:escape_string(interior) .. "', dimension='" .. mysql:escape_string(dimension) .. "'")
		
		if (id) then
			local shape = createColSphere(x, y, z, 5)
			exports.pool:allocateElement(shape)
			setElementInterior(shape, interior)
			setElementDimension(shape, dimension)
			exports['anticheat-system']:changeProtectedElementDataEx(shape, "dbid", id, false)
			
			local sprayblip = createBlip(x, y, z, 63, 2, 255, 0, 0, 255, 0, 300)
			exports['anticheat-system']:changeProtectedElementDataEx(sprayblip, "dbid", id, false)
			exports.pool:allocateElement(sprayblip)
			
			outputChatBox("Pay n Spray spawned with ID #" .. id .. ".", thePlayer, 0, 255, 0)
		else
			outputChatBox("Error 200000 - Report on forums.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("makepaynspray", createSpray, false, false)

function loadAllSprays(res)
	local result = mysql:query("SELECT id, x, y, z, interior, dimension FROM paynspray")
	local count = 0
	
	if (result) then
		local continue = true
		while continue do
			local row = mysql:fetch_assoc(result)
			if not row then
				break
			end
		
			local id = tonumber(row["id"])
				
			local x = tonumber(row["x"])
			local y = tonumber(row["y"])
			local z = tonumber(row["z"])
				
			local interior = tonumber(row["interior"])
			local dimension = tonumber(row["dimension"])
			
			local sprayblip = createBlip(x, y, z, 63, 2, 255, 0, 0, 255, 0, 300)
			exports['anticheat-system']:changeProtectedElementDataEx(sprayblip, "dbid", id, false)
			exports.pool:allocateElement(sprayblip)
			
			local shape = createColSphere(x, y, z, 5)
			exports.pool:allocateElement(shape)
			setElementInterior(shape, interior)
			setElementDimension(shape, dimension)
			exports['anticheat-system']:changeProtectedElementDataEx(shape, "dbid", id, false)
				
			count = count + 1
		end
		mysql:free_result(result)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllSprays)

function getNearbySprays(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Pay n Sprays:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theColshape in ipairs(getElementsByType("colshape", getResourceRootElement())) do
			local x, y = getElementPosition(theColshape)
			local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
			if (distance<=10) then
				local dbid = getElementData(theColshape, "dbid")
				outputChatBox("   Pay n Spray with ID " .. dbid .. ".", thePlayer, 255, 126, 0)
				count = count + 1
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbypaynsprays", getNearbySprays, false, false)

function delSpray(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local colShape = nil
		
		for key, value in ipairs(getElementsByType("colshape", getResourceRootElement())) do
			if (isElementWithinColShape(thePlayer, value)) then
				colShape = value
			end
		end
		
		if (colShape) then
			local id = getElementData(colShape, "dbid")
			mysql:query_free("DELETE FROM paynspray WHERE id='" .. mysql:escape_string(id) .. "'")
			
			outputChatBox("Pay n Spray #" .. id .. " deleted.", thePlayer)
			destroyElement(colShape)

			for key, value in ipairs(getElementsByType("blip", getResourceRootElement())) do
				if getElementData(value, "dbid") == id then
					destroyElement(value)
				end
			end
		else
			outputChatBox("You are not in a Pay n Spray.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("delpaynspray", delSpray, false, false)

function shapeHit(element, matchingDimension)
	if (isElement(element)) and (getElementType(element)=="vehicle") and (matchingDimension) then
		local thePlayer = getVehicleOccupant(element)
		
		if (thePlayer) then
			local faction = getPlayerTeam(thePlayer)
			local ftype = getElementData(faction, "type")
			local fid = getElementData(faction, "id")
			local free = false
			if (ftype==2 or ftype==3 or ftype==4 or fid==30) then
				free = true
			end
			
			local vehicleHealth = getElementHealth(element)
			
			if (vehicleHealth >= 1000) then
				outputChatBox("Welcome to the Hex Spray. Nice " .. getVehicleName(element) .. ", looks smooth. If you have any problems with it, you can come back with it!", thePlayer, 255, 194, 14)
			else
				local playerMoney = exports.global:getMoney(thePlayer, true)
				if playerMoney == 0 and not free then
					outputChatBox("You cannot afford to have your car worked on.", thePlayer, 255, 0, 0)
				else
					outputChatBox("Welcome to the Hex Spray. Please wait while we work on your " .. getVehicleName(element) .. ".", thePlayer, 255, 194, 14)
					setTimer(spraySoundEffect, 2000, 5, thePlayer, source)
					setTimer(sprayEffect, 10000, 1, element, thePlayer, source, free, faction)				
				end
			end
		end
	end
end
addEventHandler("onColShapeHit", getResourceRootElement(), shapeHit)

function spraySoundEffect(thePlayer, shape)
	if (isElementWithinColShape(thePlayer, shape)) then
		playSoundFrontEnd(thePlayer, 46)
	end
end

local costDamageRatio = 1.25

function sprayEffect(vehicle, thePlayer, shape, free, factionCharging)
	if (isElementWithinColShape(thePlayer, shape)) then
		outputChatBox(" ", thePlayer)
		outputChatBox(" ", thePlayer)
		outputChatBox("Thank you for visting a Hex PnS garage. Have a safe journey.", thePlayer, 255, 194, 14)
		local completefix = false
		local vehicleHealth = getElementHealth(vehicle)
		local toFix = 0
		
		local damage = 1000 - vehicleHealth
		damage = math.floor(damage)
		local estimatedCosts = math.floor(damage * costDamageRatio)
		
		if not free then
			completefix = false
			local playerMoney = exports.global:getMoney(thePlayer, true)
			if (estimatedCosts > playerMoney) then
				toFix = playerMoney / costDamageRatio
			else
				completefix = true
				toFix = damage
			end
			
			estimatedCosts =  math.floor ( toFix * costDamageRatio )
			
			exports.global:takeMoney(thePlayer, estimatedCosts, true)
			outputChatBox("BILL: Car Repair - ".. exports.global:formatMoney(estimatedCosts) .."$", thePlayer, 255, 194, 14)
		else
			completefix = true
			outputChatBox("The bill will be sent to your employer.", thePlayer, 255, 194, 14)
			exports.global:takeMoney(factionCharging, estimatedCosts, true)
		end
		
		exports.global:giveMoney(getTeamFromName("Hex Tow 'n Go"), estimatedCosts)
		
		if (completefix) then
			fixVehicle(vehicle)
			for i = 0, 5 do
				setVehicleDoorState(vehicle, i, 0)
			end
		else
			outputChatBox("As you can't afford a full vehicle fix, we patched your engine a bit up so it works again.", thePlayer, 255, 194, 14)
			setElementHealth(vehicle, vehicleHealth + toFix)
		end
		
		if armoredCars[ getElementModel( vehicle ) ] then
			setVehicleDamageProof(vehicle, true)
		else
			setVehicleDamageProof(vehicle, false)
		end
		if (getElementData(vehicle, "Impounded") == 0) then
			exports['anticheat-system']:changeProtectedElementDataEx(vehicle, "enginebroke", 0, false)
		end
		
		exports.logs:dbLog(thePlayer, 6, {  vehicle }, "REPAIR PAYNSPRAY")
	else
		outputChatBox("You forgot to wait for your repair!", thePlayer, 255, 0, 0)
	end
end

function pnsOnEnter(player, seat)
	if seat == 0 then
		for k, v in ipairs(getElementsByType("colshape", getResourceRootElement())) do
			if isElementWithinColShape(source, v) then
				triggerEvent( "onColShapeHit", v, source, getElementDimension(v) == getElementDimension(source))
			end
		end
	end
end
addEventHandler("onVehicleEnter", getRootElement(), pnsOnEnter)
