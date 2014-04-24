-- made by dragon and flobu
local textsToDraw = {}

local showtime = 8000
local characteraddition = 50
local bubblesEnabled = true

function income(text, r, g, b)
	if bubblesEnabled then
		--outputDebugString("1")
		if text:sub( 1, 1 ) == " " then
			text = text:sub( 2 )
			--outputDebugString("2")
		end
		local newtext = text:gsub("%[%w+%] (.*) (%w+): ","%1|%2|")
		if newtext then
			--outputDebugString("3")
			local pos1 = newtext:find("|")
			if pos1 then
				--outputDebugString("4")
				local pos2 = newtext:find("|", pos1+1)
				if pos2 then
					--outputDebugString("5")
					--outputDebugString(newtext)
					local name = newtext:sub( 0, pos1 - 1 )
					--outputDebugString(name)
					local what = newtext:sub( pos1 + 1, pos2 - 2 ) -- strips the last 's'
					--outputDebugString(what)
					local newtext = newtext:sub( pos2 + 1 )

					if what ~= "say" then
					--	outputDebugString("6")
						newtext = "(" .. what .. ") " .. newtext
					end
					
					local player = getPlayerFromName( name:gsub(" ", "_") )
					if (isElement(player)) then
						--return
						addText(player, newtext, {r, g, b})
					end
				end
			end
		end
	end
end

function addText(source,message,color)
	local notfirst = false
	for i,v in ipairs(textsToDraw) do
		if v[1] == source then
			v[3] = v[3] + 1
			notfirst = true
		end
	end
	local infotable = {source,message,0,color}
	table.insert(textsToDraw,infotable)
	if not notfirst then
		setTimer(removeText,showtime + (#message * characteraddition),1,infotable)
	end
end

function removeText(infotable)
	for i,v in ipairs(textsToDraw) do
		if v[1] == infotable[1] and v[2] == infotable[2] then
			for i2,v2 in ipairs(textsToDraw) do
				if v2[1] == v[1] and v[3] - v2[3] == 1 then
					setTimer(removeText,showtime + (#v[2] * characteraddition),1,v2)
				end
			end
			table.remove(textsToDraw,i)
			break
		end
	end
end

function getTextsToRemove()
	for i,v in ipairs(textsToDraw) do
		if v[1] == source then
			removeText(v)
		end
	end
end

function handleDisplay()
	if bubblesEnabled then
		for i,v in ipairs(textsToDraw) do
			local camPosXl, camPosYl, camPosZl = getPedBonePosition (v[1], 6)
			local camPosXr, camPosYr, camPosZr = getPedBonePosition (v[1], 7)
			local x,y,z = (camPosXl + camPosXr) / 2, (camPosYl + camPosYr) / 2, (camPosZl + camPosZr) / 2
			--local posx,posy = getScreenFromWorldPosition(x,y,z+0.25)
			local cx,cy,cz = getCameraMatrix()
			local px,py,pz = getElementPosition(v[1])
			local distance = getDistanceBetweenPoints3D(cx,cy,cz,px,py,pz)
			local posx,posy = getScreenFromWorldPosition(x,y,z+0.020*distance+0.10)
			local blocking = getPedOccupiedVehicle(getLocalPlayer()) or getPedOccupiedVehicle(v[1]) or nil
			if posx and distance <= 45 and isLineOfSightClear(cx,cy,cz,px,py,pz,true,true,false,true,false,true,true, blocking) then -- change this when multiple ignored elements can be specified
				local width = dxGetTextWidth(v[2],1,"default")
				
				dxDrawRectangle(posx - (3 + (0.5 * width)),posy - (2 + (v[3] * 20)),width + 5,19,tocolor(0,0,0,255))
				dxDrawRectangle(posx - (6 + (0.5 * width)),posy - (2 + (v[3] * 20)),width + 11,19,tocolor(0,0,0,40))
				dxDrawRectangle(posx - (8 + (0.5 * width)),posy - (1 + (v[3] * 20)),width + 15,17,tocolor(0,0,0,255))
				dxDrawRectangle(posx - (10 + (0.5 * width)),posy - (1 + (v[3] * 20)),width + 19,17,tocolor(0,0,0,40))
				dxDrawRectangle(posx - (10 + (0.5 * width)),posy - (v[3] * 20) + 1,width + 19,13,tocolor(0,0,0,255))
				dxDrawRectangle(posx - (12 + (0.5 * width)),posy - (v[3] * 20) + 1,width + 23,13,tocolor(0,0,0,40))
				dxDrawRectangle(posx - (12 + (0.5 * width)),posy - (v[3] * 20) + 4,width + 23,7,tocolor(0,0,0,255))

				dxDrawText(v[2],posx - (0.5 * width),posy - (v[3] * 20),posx - (0.5 * width),posy - (v[3] * 20),tocolor(unpack(v[4])),1,"default","left","top",false,false,false)
			end
		end
	end
end

addEventHandler("onClientPlayerQuit",getRootElement(),getTextsToRemove)
addEventHandler("onClientRender",getRootElement(),handleDisplay)
addEventHandler("onClientChatMessage",getRootElement(),income)

function applyClientConfigSettings()	
	local chatBubblesEnabled = tonumber( exports['account-system']:loadSavedData("chatbubbles", "1") )
	if (chatBubblesEnabled == 1) then
		if not bubblesEnabled then
			addEventHandler("onClientPlayerQuit",getRootElement(),getTextsToRemove)
			addEventHandler("onClientRender",getRootElement(),handleDisplay)
			addEventHandler("onClientChatMessage",getRootElement(),income)
			bubblesEnabled = true
		end
	else
		if bubblesEnabled then
			removeEventHandler("onClientPlayerQuit",getRootElement(),getTextsToRemove)
			removeEventHandler("onClientRender",getRootElement(),handleDisplay)
			removeEventHandler("onClientChatMessage",getRootElement(),income)
			bubblesEnabled = false
		end
	end
end
addEventHandler("accounts:options:settings:updated", getRootElement(), applyClientConfigSettings)