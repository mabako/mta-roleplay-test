local mysql = exports.mysql
local serverRegFee = 5500

function getPlateList()
	local allVehicles = getElementsByType("vehicle")
	local vehicleTable = { }
	local playerDBID = getElementData(client,"dbid")
	if not playerDBID then
		return
	end
	for _,vehicleElement in ipairs( exports.pool:getPoolElementsByType("vehicle") ) do
		if (getElementData(vehicleElement, "owner")) and (tonumber(getElementData(vehicleElement, "owner")) == tonumber(playerDBID)) and exports['vehicle-system']:hasVehiclePlates(vehicleElement) then
			local vehicleID = getElementData(vehicleElement, "dbid")
			table.insert(vehicleTable, { vehicleID, vehicleElement } )
		end
	end
	triggerClientEvent(client, "vehicle-plate-system:clist", client, vehicleTable)
end
addEvent("vehicle-plate-system:list", true)
addEventHandler("vehicle-plate-system:list", getRootElement(), getPlateList)

function pedTalk(state)
	if (state == 1) then
		exports.global:sendLocalText(source, "Gabrielle McCoy says: Welcome! Would you be registering new vehicle plates today?", nil, nil, nil, 10)
		outputChatBox("The registration fee is $".. exports.global:formatMoney(serverRegFee) .. " per vehicle.", source)
	elseif (state == 2) then
		exports.global:sendLocalText(source, "Gabrielle McCoy says: Sorry but the fee to register new plates is $" .. exports.global:formatMoney(serverRegFee) .. ". Please come back once you have the money.", nil, nil, nil, 10)
	elseif (state == 3) then
		exports.global:sendLocalText(source, "Gabrielle McCoy says: That is great! Lets get everything set up for you in our system.", nil, nil, nil, 10)
	elseif (state == 4) then
		exports.global:sendLocalText(source, "Gabrielle McCoy says: No? Well I hope you change your mind later. Have a nice day!", nil, nil, nil, 10)
	elseif (state == 5) then
		exports.global:sendLocalText(source, " *Gabrielle McCoy begins inputting the information into her computer.", 255, 51, 102)
		exports.global:sendLocalText(source, "Gabrielle McCoy says: Alright, you should be good to go. Have a nice day!", nil, nil, nil, 10)
	elseif (state == 6) then
		exports.global:sendLocalText(source, "Gabrielle McCoy says: Hmmm. According to our records, that is already a registered license plate.", nil, nil, nil, 10)
	end
end
addEvent("platePedTalk", true)
addEventHandler("platePedTalk", getRootElement(), pedTalk)

function setNewInfo(data, car)
	if (data) and (car) then
		local cquery = mysql:query_fetch_assoc("SELECT COUNT(*) as no FROM `vehicles` WHERE `plate`='".. mysql:escape_string(data).."'")
		if (tonumber(cquery["no"]) > 0) then
			triggerEvent("platePedTalk", source, 6)
		else
			local townerid = getElementData(source, "dbid")
			local tvehicle = exports.pool:getElement("vehicle", car)
			local owner = getElementData(tvehicle, "owner")
			if (townerid==owner) then
				if (checkPlate(data)) and exports['vehicle-system']:hasVehiclePlates(tvehicle) then
					local insertnplate = mysql:query_free("UPDATE vehicles SET plate='" .. mysql:escape_string(data) .. "' WHERE id = '" .. mysql:escape_string(car) .. "'")
					if (insertnplate) then
						if (exports.global:takeMoney(source, serverRegFee)) then
							local x, y, z = getElementPosition(tvehicle)
							local int = getElementInterior(tvehicle)
							local dim = getElementDimension(tvehicle)
							exports['vehicle-system']:reloadVehicle(tonumber(car))
							local tnvehicle = exports.pool:getElement("vehicle", car)
							setElementPosition(tnvehicle, x, y, z)
							setElementInterior(tnvehicle, int)
							setElementDimension(tnvehicle, dim)
							triggerEvent("platePedTalk", source, 5)
						else
							triggerEvent("platePedTalk", source, 2)
						end
					else
						outputChatBox("ERROR VPS0-001. Please report on the mantis.", source, 255,0,0)
					end
				else
					outputChatBox("ERROR VPS0-003. Please report on the mantis.", source, 255,0,0)
				end
			end
		end
	else
		outputChatBox("ERROR VPS0-002. Please report on the mantis.", source, 255,0,0)
	end
end
addEvent("sNewPlates", true)
addEventHandler("sNewPlates", getRootElement(), setNewInfo)
