local seat = -1

function storeSeat(vehicle, theSeat)
	seat = theSeat
end
addEventHandler("onClientVehicleEnter", getLocalPlayer(), storeSeat)

function fastRope()
	local localPlayer = getLocalPlayer()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	
	if (vehicle) then
		local model = getElementModel(vehicle)
		
		if (model==497) then
			local x, y, z = getElementPosition(localPlayer)
			local r = getPedRotation(localPlayer)

			local gz = getGroundPosition(x, y, z)
			
			addRope(x, y, z, gz)
			triggerServerEvent("startRappel", localPlayer, x, y, z, gz)
		end
	end
end
addCommandHandler("fastrope", fastRope, false)

local ropes = { }

function destroyRope(x, y, z, gz)
	for i = 1, 10 do
		if (ropes[i]~=nil) then
			local ropex = ropes[i][1]
			local ropey = ropes[i][2]
			local ropez = ropes[i][3]
			local ropegz = ropes[i][4]
			
			if (x==ropex and y==ropey and z==ropez and gz==ropegz) then
				ropes[i][1] = nil
				ropes[i][2] = nil
				ropes[i][3] = nil
				ropes[i][4] = nil
				ropes[i] = nil
				break
			end
		end
	end
end

function addRope(x, y, z, gz)
	-- only supports 10 ropes at one time =[
	for i = 1, 10 do
		if (ropes[i]==nil) then
			ropes[i] = { }
			ropes[i][1] = x
			ropes[i][2] = y
			ropes[i][3] = z
			ropes[i][4] = gz
			setTimer(destroyRope, 2100, 1, x, y, z, gz)
			break
		end
	end
end
addEvent("createRope", true)
addEventHandler("createRope", getRootElement(), addRope)

function showRopes()
	for i = 1, 10 do
		if (ropes[i]~=nil) then
			local x = ropes[i][1]
			local y = ropes[i][2]
			local z = ropes[i][3]
			local gz = ropes[i][4]
			local vehicle = ropes[i][5]
			
			dxDrawLine3D(x, y, z-3, x+0.5, y+0.5, gz, tocolor(0,0,0,255), 300, false, 1)
		end
	end
end
addEventHandler("onClientRender", getRootElement(), showRopes)