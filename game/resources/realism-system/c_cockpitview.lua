local root = getRootElement()
local localPlayer = getLocalPlayer()

local isEnabled = false

local mouseSensitivity = 0.3
local rotX, rotY = 0,0
local mouseFrameDelay = 0

function toggleCockpitView ()
	if (not isEnabled) then
		if (isPedInVehicle(localPlayer)) then
			isEnabled = true
			addEventHandler ("onClientPreRender", root, updateCamera)
			addEventHandler ("onClientCursorMove",root, freecamMouse)
			setElementAlpha (localPlayer, 0)
		end
	else --reset view
		isEnabled = false
		setCameraTarget (localPlayer, localPlayer)
		removeEventHandler ("onClientPreRender", root, updateCamera)
		removeEventHandler ("onClientCursorMove", root, freecamMouse)
		setElementAlpha (localPlayer, 255)
	end
end

addCommandHandler("cview", toggleCockpitView)
addCommandHandler("cockpit", toggleCockpitView)

function vehicleExit()
	if (source == localPlayer) then
		isEnabled = false
		setCameraTarget (localPlayer, localPlayer)
		removeEventHandler ("onClientRender", root, updateCamera)
		removeEventHandler ("onClientCursorMove", root, freecamMouse)
		setElementAlpha (localPlayer, 255)
	end
end

addEventHandler ("onClientPlayerVehicleExit", getRootElement(), vehicleExit)

function updateCamera ()
	if (isEnabled) then
		local camPosX, camPosY, camPosZ = getPedBonePosition (localPlayer, 6)
		
		
		-- note the vehicle rotation
		local rx,ry,rz = getElementRotation(getPedOccupiedVehicle(localPlayer))
		local roll = -ry
		if rx > 90 and rx < 270 then
			roll = ry - 180
		end
		local rotX = rotX - math.rad(rz)
		local rotY = rotY + math.rad(rx)
		
		--Taken from the freecam resource made by eAi
		
		-- work out an angle in radians based on the number of pixels the cursor has moved (ever)
		local cameraAngleX = rotX
		local cameraAngleY = rotY

		local freeModeAngleZ = math.sin(cameraAngleY)
		local freeModeAngleY = math.cos(cameraAngleY) * math.cos(cameraAngleX)
		local freeModeAngleX = math.cos(cameraAngleY) * math.sin(cameraAngleX)

		-- calculate a target based on the current position and an offset based on the angle
		local camTargetX = camPosX + freeModeAngleX * 100
		local camTargetY = camPosY + freeModeAngleY * 100
		local camTargetZ = camPosZ + freeModeAngleZ * 100

		-- Work out the distance between the target and the camera (should be 100 units)
		local camAngleX = camPosX - camTargetX
		local camAngleY = camPosY - camTargetY
		local camAngleZ = 0 -- we ignore this otherwise our vertical angle affects how fast you can strafe

		-- Calulcate the length of the vector
		local angleLength = math.sqrt(camAngleX*camAngleX+camAngleY*camAngleY+camAngleZ*camAngleZ)

		-- Normalize the vector, ignoring the Z axis, as the camera is stuck to the XY plane (it can't roll)
		local camNormalizedAngleX = camAngleX / angleLength
		local camNormalizedAngleY = camAngleY / angleLength
		local camNormalizedAngleZ = 0

		-- We use this as our rotation vector
		local normalAngleX = 0
		local normalAngleY = 0
		local normalAngleZ = 1

		-- Perform a cross product with the rotation vector and the normalzied angle
		local normalX = (camNormalizedAngleY * normalAngleZ - camNormalizedAngleZ * normalAngleY)
		local normalY = (camNormalizedAngleZ * normalAngleX - camNormalizedAngleX * normalAngleZ)
		local normalZ = (camNormalizedAngleX * normalAngleY - camNormalizedAngleY * normalAngleX)

		-- Update the target based on the new camera position (again, otherwise the camera kind of sways as the target is out by a frame)
		camTargetX = camPosX + freeModeAngleX * 100
		camTargetY = camPosY + freeModeAngleY * 100
		camTargetZ = camPosZ + freeModeAngleZ * 100
		camPosZ = camPosZ + 5
		camTargetZ = camTargetZ + 5
		-- Set the new camera position and target
		setCameraMatrix ( camPosX, camPosY, camPosZ, camTargetX, camTargetY, camTargetZ, roll)
	end
end

function freecamMouse (cX,cY,aX,aY)
	--ignore mouse movement if the cursor or MTA window is on
	--and do not resume it until at least 5 frames after it is toggled off
	--(prevents cursor mousemove data from reaching this handler)
	if isCursorShowing() or isMTAWindowActive() then
		mouseFrameDelay = 5
		return
	elseif mouseFrameDelay > 0 then
		mouseFrameDelay = mouseFrameDelay - 1
		return
	end
	
	-- how far have we moved the mouse from the screen center?
	local width, height = guiGetScreenSize()
	aX = aX - width / 2 
	aY = aY - height / 2
	
	rotX = rotX + aX * mouseSensitivity * 0.01745
	rotY = rotY - aY * mouseSensitivity * 0.01745
	
	local PI = math.pi
	local pRotX, pRotY, pRotZ = getElementRotation (localPlayer)
	pRotZ = math.rad(pRotZ)
	
	if rotX > PI then
		rotX = rotX - 2 * PI
	elseif rotX < -PI then
		rotX = rotX + 2 * PI
	end
	
	if rotY > PI then
		rotY = rotY - 2 * PI
	elseif rotY < -PI then
		rotY = rotY + 2 * PI
	end
	-- limit the camera to stop it going too far up or down - PI/2 is the limit, but we can't let it quite reach that or it will lock up
	-- and strafeing will break entirely as the camera loses any concept of what is 'up'
	
	if rotY < -PI / 2 then
	   rotY = -PI / 2
	elseif rotY > PI / 2 then
		rotY = PI / 2
	end
end
