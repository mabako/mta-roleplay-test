function showLaser()
	for key, value in ipairs(getElementsByType("player")) do
		if (isElement(value)) and (isElementStreamedIn(value)) then
			local weapon = getPedWeapon(value)
			
			if (weapon==24 or weapon==29 or weapon==31 or weapon==34) then
				local laser = getElementData(value, "laser")
				local deaglemode = getElementData(value, "deaglemode")

				if (laser) and (deaglemode==nil or deaglemode==0) then
					local sx, sy, sz = getPedWeaponMuzzlePosition(value)
					local ex, ey, ez = getPedTargetEnd(value)
					local task = getPedTask(value, "secondary", 0)

					if (task=="TASK_SIMPLE_USE_GUN") then 
						local collision, cx, cy, cz, element = processLineOfSight(sx, sy, sz, ex, ey, ez, true, true, true, true, true, false, false, false)
						
						if not (collision) then
							cx = ex
							cy = ey
							cz = ez
						end
						
						dxDrawLine3D(sx, sy, sz-0.05, cx, cy, cz, tocolor(255,0,0,75), 2, false, 0)
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", getRootElement(), showLaser)
--[[
local tracers = { }
local id = 1
local tracersEnabled = false

function toggleTracers()
	if ( getTeamName(getPlayerTeam(getLocalPlayer())) == "Los Santos Police Department") then
		if (tracersEnabled) then
			outputChatBox("Tracers are now disabled", 255, 0, 0)
			tracersEnabled = false
		else
			outputChatBox("Tracers are now enabled", 0, 255, 0)
			tracersEnabled = true
		end
	end
end
--addCommandHandler("togtracers", toggleTracers)

function sendTracerRound(weapon, ammo, clipammo, hx, hy, hz)
	local player = source
	
	local x, y, z = getElementPosition(player)
	local zone = getZoneName(x, y, z)

	if (tracersEnabled) then
		local mx, my, mz = getPedWeaponMuzzlePosition(player)
		storeTracer(mx, my, mz, hx, hy, hz)
	end
end
addEventHandler("onClientPlayerWeaponFire", getRootElement(), sendTracerRound)

function resetTracers()
	tracers = { }
	id = 1
end
setTimer(resetTracers, 300000, 0)

function storeTracer(mx, my, mz, hx, hy, hz)
	tracers[id] = { }
	tracers[id][1] = mx
	tracers[id][2] = my
	tracers[id][3] = mz
	tracers[id][4] = hx
	tracers[id][5] = hy
	tracers[id][6] = hz
	
	math.randomseed(getRealTime().second)
	
	tracers[id][7] = math.ceil(math.random(0, 255))
	tracers[id][8] = math.ceil(math.random(0, 255))
	tracers[id][9] = math.ceil(math.random(0, 255))
	
	id = id + 1
end
addEvent("storeTracer", true)
addEventHandler("storeTracer", getRootElement(), storeTracer)

function displayTracers()
	for key, value in ipairs(tracers) do
		local mx = tracers[key][1]
		local my = tracers[key][2]
		local mz = tracers[key][3]
		local hx = tracers[key][4]
		local hy = tracers[key][5]
		local hz = tracers[key][6]
		local r = tracers[key][7]
		local g = tracers[key][8]
		local b = tracers[key][9]
		
		dxDrawLine3D(mx, my, mz, hx, hy, hz, tocolor(r, g,b, 175), 3)
	end
end
addEventHandler("onClientRender", getRootElement(), displayTracers)]]