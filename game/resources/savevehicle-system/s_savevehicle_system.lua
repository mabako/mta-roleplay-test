mysql = exports.mysql

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function saveVehicle(source)
	local dbid = tonumber(getElementData(source, "dbid")) or -1
	
	if isElement(source) and getElementType(source) == "vehicle" and dbid >= 0 then
		--local owner = getElementData(source, "owner")
		--if (owner~=-1) then
			local x, y, z = getElementPosition(source)
			local rx, ry, rz = getElementRotation(source)
			local fuel = getElementData(source, "fuel")
			local engine = getElementData(source, "engine")
			local odometer = getElementData(source, "odometer") or 0
			local locked = isVehicleLocked(source) and 1 or 0		
			local lights = getVehicleOverrideLights(source)
			local sirens = getVehicleSirensOn(source) and 1 or 0
			local Impounded = getElementData(source, "Impounded") or 0
			local handbrake = getElementData(source, "handbrake") or 0
			local health = getElementHealth(source)
			local dimension = getElementDimension(source)
			local interior = getElementInterior(source)

			local wheel1, wheel2, wheel3, wheel4 = getVehicleWheelStates(source)
			local wheelState = toJSON( { wheel1, wheel2, wheel3, wheel4 } )
			
			local panel0 = getVehiclePanelState(source, 0)
			local panel1 = getVehiclePanelState(source, 1)
			local panel2 = getVehiclePanelState(source, 2)
			local panel3 = getVehiclePanelState(source, 3)
			local panel4 = getVehiclePanelState(source, 4)
			local panel5 = getVehiclePanelState(source, 5)
			local panel6 = getVehiclePanelState(source, 6)
			local panelState = toJSON( { panel0, panel1, panel2, panel3, panel4, panel5, panel6 } )
			
			local door0 = getVehicleDoorState(source, 0)
			local door1 = getVehicleDoorState(source, 1)
			local door2 = getVehicleDoorState(source, 2)
			local door3 = getVehicleDoorState(source, 3)
			local door4 = getVehicleDoorState(source, 4)
			local door5 = getVehicleDoorState(source, 5)
			local doorState = toJSON( { door0, door1, door2, door3, door4, door5 } )
			
			mysql:query_free("UPDATE vehicles SET `fuel`='" .. mysql:escape_string(fuel) ..
				"', `engine`='" .. mysql:escape_string(engine) ..
				"', `locked`='" .. mysql:escape_string(locked) ..
				"', `lights`='" .. mysql:escape_string(lights) ..
				"', `hp`='" .. mysql:escape_string(health) ..
				"', `sirens`='" .. mysql:escape_string(sirens) ..
				"', `Impounded`='" .. mysql:escape_string(tonumber(Impounded)) ..
				"', `handbrake`='" .. mysql:escape_string(tonumber(handbrake)) ..
				"', `currx`=" .. x .. 
				" , `curry`=" .. y ..
				" , `currz`=" .. z ..
				" , `currrx`=" .. rx ..
				" , `currry`=" .. ry ..
				" , `currrz`=" .. rz ..
				" WHERE id='" .. mysql:escape_string(dbid) .. "'")
			mysql:query_free("UPDATE vehicles SET `panelStates`='" .. mysql:escape_string(panelState) .. "', `wheelStates`='" .. mysql:escape_string(wheelState) .. "', `doorStates`='" .. mysql:escape_string(doorState) .. "', `hp`='" .. mysql:escape_string(health) .. "', sirens='" .. mysql:escape_string(sirens) .. "', Impounded='" .. mysql:escape_string(tonumber(Impounded)) .. "', handbrake='" .. mysql:escape_string(tonumber(handbrake)) .. "', `odometer`='"..mysql:escape_string(tonumber(odometer)).."' WHERE id='" .. mysql:escape_string(dbid) .. "'")
		--end
	end
end

local function saveVehicleOnExit(thePlayer, seat)
	saveVehicle(source)
end
addEventHandler("onVehicleExit", getRootElement(), saveVehicleOnExit)

function saveVehicleMods(source)
	local dbid = tonumber(getElementData(source, "dbid")) or -1
	local owner = tonumber(getElementData(source, "owner")) or -1
	if isElement(source) and getElementType(source) == "vehicle" and dbid >= 0 then -- and owner > 0 
		local col =  { getVehicleColor(source, true) }
		if getElementData(source, "oldcolors") then
			col = unpack(getElementData(source, "oldcolors"))
		end
		
		local color1 = toJSON( {col[1], col[2], col[3]} )
		local color2 = toJSON( {col[4], col[5], col[6]} )
		local color3 = toJSON( {col[7], col[8], col[9]} )
		local color4 = toJSON( {col[10], col[11], col[12]} )
		
		
		local hcol1, hcol2, hcol3 = getVehicleHeadLightColor( source )
		if getElementData(source, "oldheadcolors") then
			hcol1, hcol2, hcol3 = unpack(getElementData(source, "oldheadcolors"))
		end
		local headLightColors = toJSON( { hcol1, hcol2, hcol3 } )
		
		local upgrade0 = getElementData( source, "oldupgrade" .. 0 ) or getVehicleUpgradeOnSlot(source, 0)
		local upgrade1 = getElementData( source, "oldupgrade" .. 1 ) or getVehicleUpgradeOnSlot(source, 1)
		local upgrade2 = getElementData( source, "oldupgrade" .. 2 ) or getVehicleUpgradeOnSlot(source, 2)
		local upgrade3 = getElementData( source, "oldupgrade" .. 3 ) or getVehicleUpgradeOnSlot(source, 3)
		local upgrade4 = getElementData( source, "oldupgrade" .. 4 ) or getVehicleUpgradeOnSlot(source, 4)
		local upgrade5 = getElementData( source, "oldupgrade" .. 5 ) or getVehicleUpgradeOnSlot(source, 5)
		local upgrade6 = getElementData( source, "oldupgrade" .. 6 ) or getVehicleUpgradeOnSlot(source, 6)
		local upgrade7 = getElementData( source, "oldupgrade" .. 7 ) or getVehicleUpgradeOnSlot(source, 7)
		local upgrade8 = getElementData( source, "oldupgrade" .. 8 ) or getVehicleUpgradeOnSlot(source, 8)
		local upgrade9 = getElementData( source, "oldupgrade" .. 9 ) or getVehicleUpgradeOnSlot(source, 9)
		local upgrade10 = getElementData( source, "oldupgrade" .. 10 ) or getVehicleUpgradeOnSlot(source, 10)
		local upgrade11 = getElementData( source, "oldupgrade" .. 11 ) or getVehicleUpgradeOnSlot(source, 11)
		local upgrade12 = getElementData( source, "oldupgrade" .. 12 ) or getVehicleUpgradeOnSlot(source, 12)
		local upgrade13 = getElementData( source, "oldupgrade" .. 13 ) or getVehicleUpgradeOnSlot(source, 13)
		local upgrade14 = getElementData( source, "oldupgrade" .. 14 ) or getVehicleUpgradeOnSlot(source, 14)
		local upgrade15 = getElementData( source, "oldupgrade" .. 15 ) or getVehicleUpgradeOnSlot(source, 15)
		local upgrade16 = getElementData( source, "oldupgrade" .. 16 ) or getVehicleUpgradeOnSlot(source, 16)
		
		local paintjob =  getElementData(source, "oldpaintjob") or getVehiclePaintjob(source)
		local variant1, variant2 = getVehicleVariant(source)
		
		local upgrades = toJSON( { upgrade0, upgrade1, upgrade2, upgrade3, upgrade4, upgrade5, upgrade6, upgrade7, upgrade8, upgrade9, upgrade10, upgrade11, upgrade12, upgrade13, upgrade14, upgrade15, upgrade16 } )
		mysql:query_free("UPDATE vehicles SET `upgrades`='" .. mysql:escape_string(upgrades) .. "', paintjob='" .. mysql:escape_string(paintjob) .. "', color1='" .. mysql:escape_string(color1) .. "', color2='" .. mysql:escape_string(color2) .. "', color3='" .. mysql:escape_string(color3) .. "', color4='" .. mysql:escape_string(color4) .. "', `headlights`='"..mysql:escape_string(headLightColors).."',variant1="..variant1..",variant2="..variant2.." WHERE id='" .. mysql:escape_string(dbid) .. "'")
	end
end