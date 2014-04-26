addEvent( "fixRecon", true )
addEventHandler( "fixRecon", getRootElement( ), 
	function( element )
		setElementDimension( client, getElementDimension( element ) )
		setElementInterior( client, getElementInterior( element ) )
		setCameraInterior( client, getElementInterior( element ) )
	end
)

-- recon fix for interior changing
function interiorChanged()
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		if isElement(value) then
			local cameraTarget = getCameraTarget(value)
			if (cameraTarget) then
				if (cameraTarget==source) then
					local interior = getElementInterior(source)
					local dimension = getElementDimension(source)
					setCameraInterior(value, interior)
					setElementInterior(value, interior)
					setElementDimension(value, dimension)
				end
			end
		end
	end
end
addEventHandler("onPlayerInteriorChange", getRootElement(), interiorChanged)

-- stop recon on quit of the player
function removeReconning()
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		if isElement(value) then
			local cameraTarget = getCameraTarget(value)
			if (cameraTarget) then
				if (cameraTarget==source) then
					reconPlayer(value)
				end
			end
		end
	end
end
addEventHandler("onPlayerQuit", getRootElement(), removeReconning)

-- RECON
function reconPlayer(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerLeadGameMaster(thePlayer)) then
		if not (targetPlayer) then
			local rx = getElementData(thePlayer, "reconx")
			local ry = getElementData(thePlayer, "recony")
			local rz = getElementData(thePlayer, "reconz")
			local reconrot = getElementData(thePlayer, "reconrot")
			local recondimension = getElementData(thePlayer, "recondimension")
			local reconinterior = getElementData(thePlayer, "reconinterior")
			
			if not (rx) or not (ry) or not (rz) or not (reconrot) or not (recondimension) or not (reconinterior) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick]", thePlayer, 255, 194, 14)
			else
				detachElements(thePlayer)
			
				setElementPosition(thePlayer, rx, ry, rz)
				setPedRotation(thePlayer, reconrot)
				setElementDimension(thePlayer, recondimension)
				setElementInterior(thePlayer, reconinterior)
				setCameraInterior(thePlayer, reconinterior)
				
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconx", nil, false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "recony", nil, false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconz", nil, false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconrot", nil, false)
				setCameraTarget(thePlayer, thePlayer)
				setElementAlpha(thePlayer, 255)
				outputChatBox("Recon turned off.", thePlayer, 255, 194, 14)
			end
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local freecamEnabled = exports.freecam:isPlayerFreecamEnabled (thePlayer)
			if freecamEnabled then
				toggleFreecam(thePlayer)
			end
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
				
					if exports.global:isPlayerLeadGameMaster(thePlayer) then
						if exports.global:isPlayerAdmin(targetPlayer) or exports.global:getPlayerGameMasterLevel(targetPlayer) >= exports.global:getPlayerGameMasterLevel(thePlayer) or exports.global:getPlayerGameMasterLevel(targetPlayer) == 0 then
							outputChatBox("You can only /recon lower level GMs, tyvm.", thePlayer)
							exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " tried reconning " .. targetPlayerName .. " but FAILED (due to GM level).")
							return
						end
					end
					-- avoid circular reconning
					--local attached = { [thePlayer] = targetPlayer }
					--local a = targetPlayer
					--while true do
					--	local b = getElementAttachedTo(a)
					--	if b then
					--		if attached[b] then
					--			outputChatBox("Unable to attach (circular reference).", thePlayer, 255, 0, 0)
					--			return
					--		end
					--		attached[a] = b
					--	else
					--		-- not attached to anything
					--		break
					--	end
					--end
					setElementAlpha(thePlayer, 0)
					
					if getPedOccupiedVehicle ( thePlayer ) then
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "realinvehicle", 0, false)
						removePedFromVehicle(thePlayer)
					end
					
					if ( not getElementData(thePlayer, "reconx") or getElementData(thePlayer, "reconx") == true ) and not getElementData(thePlayer, "recony") then
						local x, y, z = getElementPosition(thePlayer)
						local rot = getPedRotation(thePlayer)
						local dimension = getElementDimension(thePlayer)
						local interior = getElementInterior(thePlayer)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconx", x, false)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "recony", y, false)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconz", z, false)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconrot", rot, false)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "recondimension", dimension, false)
						exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconinterior", interior, false)
					end
					setPedWeaponSlot(thePlayer, 0)
					
					local playerdimension = getElementDimension(targetPlayer)
					local playerinterior = getElementInterior(targetPlayer)
					
					setElementDimension(thePlayer, playerdimension)
					setElementInterior(thePlayer, playerinterior)
					setCameraInterior(thePlayer, playerinterior)
					
					local x, y, z = getElementPosition(targetPlayer)
					setElementPosition(thePlayer, x - 10, y - 10, z - 5)
					local success = attachElements(thePlayer, targetPlayer, -10, -10, -5)
					if not (success) then
						success = attachElements(thePlayer, targetPlayer, -5, -5, -5)
						if not (success) then
							success = attachElements(thePlayer, targetPlayer, 5, 5, -5)
						end
					end
					
					if not (success) then
						outputChatBox("Failed to attach the element.", thePlayer, 0, 255, 0)
					else
						setCameraTarget(thePlayer, targetPlayer)
						outputChatBox("Now reconning " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
						
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						
						if hiddenAdmin == 0 and not exports.global:isPlayerLeadAdmin(thePlayer) then
							local adminTitle = exports.global:getPlayerGMTitle(thePlayer)
							exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " started reconning " .. targetPlayerName .. ".")
						end
					end
				end
			end
		end
	end
end
addCommandHandler("recon", reconPlayer, false, false)

function fuckRecon(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerLeadGameMaster(thePlayer)) then
		local rx = getElementData(thePlayer, "reconx")
		local ry = getElementData(thePlayer, "recony")
		local rz = getElementData(thePlayer, "reconz")
		local reconrot = getElementData(thePlayer, "reconrot")
		local recondimension = getElementData(thePlayer, "recondimension")
		local reconinterior = getElementData(thePlayer, "reconinterior")
		
		detachElements(thePlayer)
		setCameraTarget(thePlayer, thePlayer)
		setElementAlpha(thePlayer, 255)
		
		if rx and ry and rz then
			setElementPosition(thePlayer, rx, ry, rz)
			if reconrot then
				setPedRotation(thePlayer, reconrot)
			end
			
			if recondimension then
				setElementDimension(thePlayer, recondimension)
			end
			
			if reconinterior then
					setElementInterior(thePlayer, reconinterior)
					setCameraInterior(thePlayer, reconinterior)
			end
		end
		
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconx", false, false)
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "recony", false, false)
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconz", false, false)
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconrot", false, false)
		outputChatBox("Recon turned off.", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("fuckrecon", fuckRecon, false, false)
addCommandHandler("stoprecon", fuckRecon, false, false)


-- FREECAM
function toggleFreecam(thePlayer)
	if exports.global:isPlayerAdmin(thePlayer) then
	
		local reconning = getElementData(thePlayer, "reconx")
		if reconning then
			reconPlayer(thePlayer, "recon")
		end
	
		local enabled = exports.freecam:isPlayerFreecamEnabled (thePlayer)
		
		if (enabled) then
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconx", false, false)
			setElementAlpha(thePlayer, 255)
			setElementFrozen(thePlayer, false)
			exports.freecam:setPlayerFreecamDisabled (thePlayer)
		else
			removePedFromVehicle(thePlayer)
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconx", 0, false)
			setElementAlpha(thePlayer, 0)
			setElementFrozen(thePlayer, true)
			exports.freecam:setPlayerFreecamEnabled (thePlayer)
		end
	end
end
addCommandHandler("freecam", toggleFreecam)

-- DROP ME

function dropOffFreecam(thePlayer)
	if exports.global:isPlayerAdmin(thePlayer) then
		local enabled = exports.freecam:isPlayerFreecamEnabled (thePlayer)
		if (enabled) then
			local x, y, z = getElementPosition(thePlayer)
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconx", false, false)
			setElementAlpha(thePlayer, 255)
			setElementFrozen(thePlayer, false)
			exports.freecam:setPlayerFreecamDisabled (thePlayer)
			setElementPosition(thePlayer, x, y, z)
		else
			outputChatBox("This command only works while freecam is on.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("dropme", dropOffFreecam)

-- DISAPPEAR

function toggleInvisibility(thePlayer)
	if exports.global:isPlayerAdmin(thePlayer) then
		local enabled = getElementData(thePlayer, "invisible")
		if (enabled == true) then
			setElementAlpha(thePlayer, 255)
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconx", false, false)
			outputChatBox("You are now visible.", thePlayer, 255, 0, 0)
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "invisible", false, false)
		elseif (enabled == false or enabled == nil) then
			setElementAlpha(thePlayer, 0)
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconx", true, false)
			outputChatBox("You are now invisible.", thePlayer, 0, 255, 0)
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "invisible", true, false)
		else
			outputChatBox("Please disable recon first.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("disappear", toggleInvisibility)

					
-- TOGGLE NAMETAG

function toggleMyNametag(thePlayer)
	local visible = getElementData(thePlayer, "reconx")
	if exports.global:isPlayerAdmin(thePlayer) then
		if (visible == true) then
			setPlayerNametagShowing(thePlayer, false)
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconx", false, false)
			outputChatBox("Your nametag is now visible.", thePlayer, 255, 0, 0)
		elseif (visible == false or visible == nil) then
			setPlayerNametagShowing(thePlayer, false)
			exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reconx", true, false)
			outputChatBox("Your nametag is now hidden.", thePlayer, 0, 255, 0)
		else
			outputChatBox("Please disable recon first.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("togmytag", toggleMyNametag)
