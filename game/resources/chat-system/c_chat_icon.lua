chaticon = true
local chatting = false
local chatters = { }

function checkForChat()
	if not (getElementAlpha(getLocalPlayer()) == 0) then
		if (isChatBoxInputActive() and not chatting) then
			chatting = true
			triggerServerEvent("chat1", getLocalPlayer())
		elseif (not isChatBoxInputActive() and chatting) then
			chatting = false
			triggerServerEvent("chat0", getLocalPlayer())
		end
	end
end
setTimer(checkForChat, 200, 0)

function addChatter()
	for key, value in ipairs(chatters) do
		if ( value == source ) then
			return
		end
	end
	table.insert(chatters, source)
end
addEvent("addChatter", true)
addEventHandler("addChatter", getRootElement(), addChatter)

function delChatter()
	for key, value in ipairs(chatters) do
		if ( value == source ) then
			table.remove(chatters, key)
		end
	end
end
addEvent("delChatter", true)
addEventHandler("delChatter", getRootElement(), delChatter)
addEventHandler("onClientPlayerQuit", getRootElement(), delChatter)

function render()
	local x, y, z = getElementPosition(getLocalPlayer())
	local reconx = getElementData(getLocalPlayer(), "reconx")
	for key, value in ipairs(chatters) do
		if (isElement(value)) then
			if getElementType(value) == "player" then
				local px, py, pz = getPedBonePosition(value, 6)
				
				local dist = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
				if isElementOnScreen(value) and getElementAlpha(value) ~= 0 and not getElementData(value, "freecam:state") then
					if (dist>25) then
						chatters[value] = nil
						return
					end
				
					local lx, ly, lz = getCameraMatrix()
					local vehicle = getPedOccupiedVehicle(value) or nil
					local collision, cx, cy, cz, element = processLineOfSight(lx, ly, lz, px, py, pz+1, true, true, true, true, false, false, true, false, vehicle)
					if not (collision) or (reconx) then
						local screenX, screenY = getScreenFromWorldPosition(px, py, pz+0.5)
						if (screenX and screenY) then
							dist = dist / 5
								
							if (dist<1) then dist = 1 end
							if (dist>4 and reconx) then dist = 4 end
							
							
							local offset = 70 / dist
							
							local draw = dxDrawImage(screenX, screenY, 60 / dist, 60 / dist, "chat.png")
						end
					end
				end
			else
				chatters[key] = nil
			end
		else
			chatters[key] = nil
		end
	end
end
addEventHandler("onClientRender", getRootElement(), render)

function applyClientConfigSettings()	
	local chatIconsEnabled = tonumber( exports['account-system']:loadSavedData("chaticons", "1") )
	if (chatIconsEnabled == 1) then
		if not chaticon then
			triggerServerEvent("chaticon1", getLocalPlayer())
			chaticon = true
			addEventHandler("onClientRender", getRootElement(), render)
		end
	else
		if chaticon then
			triggerServerEvent("chaticon0", getLocalPlayer())
			chaticon = false
			removeEventHandler("onClientRender", getRootElement(), render)
		end
	end
end
addEventHandler("accounts:options:settings:updated", getRootElement(), applyClientConfigSettings)