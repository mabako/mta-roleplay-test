local pedTable = { }
local characterSelected, characterElementSelected, newCharacterButton = nil
function Characters_showSelection()
	triggerEvent("onSapphireXMBShow", getLocalPlayer())
	showPlayerHudComponent("radar", false)
	
	guiSetInputEnabled(false)
	if not isCursorShowing ( ) then
		showCursor(true)
	end
	setElementDimension ( getLocalPlayer(), 1 )
	setElementInterior( getLocalPlayer(), 0 )
	local x = 825.55703125
	local y = -2049.3876953125
	local z = 12.8671875
	local characterList = getElementData(getLocalPlayer(), "account:characters")
	if (characterList) then
		-- Prepare the peds
		for _, v in ipairs(characterList) do
			local thePed = createPed( tonumber( v[9]), x, y, z)
			setPedRotation(thePed, 180)
			setElementDimension(thePed, 1)
			setElementInterior(thePed, 0)
			setElementData(thePed,"account:charselect:id", v[1], false)
			setElementData(thePed,"account:charselect:name", v[2]:gsub("_", " "), false)
			setElementData(thePed,"account:charselect:cked", v[3], false)
			setElementData(thePed,"account:charselect:lastarea", v[4], false)
			setElementData(thePed,"account:charselect:lastseen", v[10], false)
			setElementData(thePed,"account:charselect:age", v[5], false)
			setElementData(thePed,"account:charselect:weight", v[11], false)
			setElementData(thePed,"account:charselect:height", v[12], false)
			setElementData(thePed,"account:charselect:desc", v[13], false)
			setElementData(thePed,"account:charselect:age", v[5], false)
			setElementData(thePed,"account:charselect:gender", v[6], false)
			setElementData(thePed,"account:charselect:faction", v[7] or "", false)
			setElementData(thePed,"account:charselect:factionrank", v[8] or "", false)
			
			
			local randomAnimation = getRandomAnim( v[3] == 1 and 4 or 2 )
			setPedAnimation ( thePed , randomAnimation[1], randomAnimation[2], -1, true, false, false, false )
			
			x = x + 3
			if x > 849 then
				x = 825.55703125
				y = y + 3
			end
			
			table.insert(pedTable, thePed)
		end
		-- Done!
		addEventHandler("onClientPreRender", getRootElement(), Characters_updateSelectionCamera)
		addEventHandler("onClientRender", getRootElement(), renderNametags)
	end
end

function Characters_characterSelectionVisisble()
	addEventHandler("onClientClick", getRootElement(), Characters_onClientClick)
	newCharacterButton = guiCreateButton(0.4, 0.02, 0.2, 0.1, "Create a new character!", true, nil)
	addEventHandler("onClientGUIClick", newCharacterButton, Characters_newCharacter)
end

local currposs = -10000
function Characters_updateSelectionCamera ()
	if (currposs > 10000) then -- Done
		removeEventHandler("onClientPreRender",getRootElement(),Characters_updateSelectionCamera)
		Characters_characterSelectionVisisble()
	end
	currposs = currposs + 140
	setCameraMatrix (837.90606689453, -2066.2963867188, 16.712882995605, 0, currposs, 0)
end

function renderNametags()
	for key, player in ipairs(getElementsByType("ped")) do
		if (isElement(player))then
			if (getElementData(player,"account:charselect:id")) then
				local lx, ly, lz = getElementPosition( getLocalPlayer() )
				local rx, ry, rz = getElementPosition(player)
				local distance = getDistanceBetweenPoints3D(lx, ly, lz, rx, ry, rz)
				if  (isElementOnScreen(player)) then
					local lx, ly, lz = getCameraMatrix()
					local collision, cx, cy, cz, element = processLineOfSight(lx, ly, lz, rx, ry, rz+1, true, true, true, true, false, false, true, false, nil)
					if not (collision) then	
						local x, y, z = getElementPosition(player)
						local sx, sy = getScreenFromWorldPosition(x, y, z+0.45, 100, false)
						if (sx) and (sy) then
							if (distance<=2) then
								sy = math.ceil( sy - ( 2 - distance ) * 40 )
							end
							sy = sy - 20
							if (sx) and (sy) then
								distance = 1.5 
								local offset = 75 / distance
								dxDrawText(getElementData(player,"account:charselect:name"), sx-offset+2, sy+2, (sx-offset)+130 / distance, sy+20 / distance, tocolor(0, 0, 0, 220), 0.6 / distance, "bankgothic", "center", "center", false, false, false)
								dxDrawText(getElementData(player,"account:charselect:name"), sx-offset, sy, (sx-offset)+130 / distance, sy+20 / distance, tocolor(255, 255, 255, 220), 0.6 / distance, "bankgothic", "center", "center", false, false, false)	
							end
						end
					end
				end
			end
		end
	end
end

function Characters_onClientClick(mouseButton, buttonState, alsoluteX, alsoluteY, worldX, worldY, worldZ, theElement)
	if (theElement) and (buttonState == "down") then
		if (getElementData(theElement,"account:charselect:id")) then
			characterSelected = getElementData(theElement,"account:charselect:id")			
			characterElementSelected = theElement			
			
			Characters_updateDetailScreen(theElement)
			
			local randomAnimation = nil
			for _, thePed in ipairs(pedTable) do
				local deceased = getElementData(thePed,"account:charselect:cked")
				if deceased ~= 1 then
					if thePed == theElement then
						randomAnimation = getRandomAnim( 1 )
					else
						randomAnimation = getRandomAnim( 2 )
					end
				else
					randomAnimation = getRandomAnim( 4 )
				end
				if randomAnimation then
					local anim1, anim2 = getPedAnimation(thePed)
					if randomAnimation[1] ~= anim1 or randomAnimation[2] ~= anim2 then
						setPedAnimation ( thePed , randomAnimation[1], randomAnimation[2], -1, true, false, false, false )
					end
				end
			end
		end
	end
end

--- Character detail screen
local wDetailScreen, lDetailScreen, iCharacterImage, bPlayAs,cFadeOutTime = nil
function Characters_createDetailScreen()
	if wDetailScreen  then
		return true
	end
	
	local width, height = guiGetScreenSize()
	
	wDetailScreen = guiCreateWindow(width/1.5, 0, math.min(width / 1.5, 300),400, "Character Detail", false)
	guiWindowSetSizable(wDetailScreen, false)
	
	lDetailScreen = {
		guiCreateLabel(0.03,0.07,0.95,0.0887,"Name: N/A",true,wDetailScreen),
		guiCreateLabel(0.03,0.11,0.96,0.0887,"Gender: N/A",true,wDetailScreen),
		guiCreateLabel(0.03,0.15,0.96,0.0887,"Status: N/A",true,wDetailScreen),
		guiCreateLabel(0.03,0.19,0.96,0.0887,"Age: N/A",true,wDetailScreen),
		guiCreateLabel(0.03,0.23,0.96,0.0887,"Faction: N/A",true,wDetailScreen),
		guiCreateLabel(0.03,0.30,0.96,0.0887,"Last seen: N/A",true,wDetailScreen),
	}
	bPlayAs = guiCreateButton(80, 322, 220, 78, "Play as N/A", false, wDetailScreen)
	addEventHandler("onClientGUIClick", bPlayAs, Characters_selectCharacter, false)
	return true
end

function Characters_updateDetailScreen(thePed)
	if Characters_createDetailScreen() then
		if (iCharacterImage ~= nil) then
			destroyElement(iCharacterImage)
		end
		local skin = getElementModel(thePed)
		iCharacterImage = guiCreateStaticImage ( 10, 322, 64, 78, "img/" .. ("%03d"):format(skin) .. ".png", false, wDetailScreen)
		
		guiSetText ( lDetailScreen[1], "Name: " .. getElementData(thePed,"account:charselect:name") )
		local characterGender = getElementData(thePed, "account:charselect:gender")
		local characterGenderStr = "Female"
		if (characterGender == 0) then
			characterGenderStr = "Male"
		end
		guiSetText ( lDetailScreen[2], "Gender: " .. characterGenderStr )
		
		local characterStatus = getElementData(thePed, "account:charselect:cked")
		local characterStatusStr = "Dead"
		if (characterStatus ~= 1) then
			characterStatusStr = "Alive"
		end
		
		guiSetText ( lDetailScreen[3], "Status: " .. characterStatusStr )
		guiSetText ( lDetailScreen[4], "Age: " .. tostring(getElementData(thePed, "account:charselect:age")) )
		guiSetText ( lDetailScreen[5], "Faction: " .. getElementData(thePed, "account:charselect:factionrank") .. " - " .. getElementData(thePed, "account:charselect:faction") )
		guiSetText ( lDetailScreen[6], "Last seen at " .. getElementData(thePed, "account:charselect:lastarea") )		
		guiSetText ( bPlayAs, "Play as "..getElementData(thePed,"account:charselect:name") )		
		if getElementData(thePed, "account:charselect:cked") == 1 then
			guiSetEnabled(bPlayAs, false)
		else
			guiSetEnabled(bPlayAs, true)
		end
	end
end

function Characters_deactivateGUI()
	if isElement(bPlayAs) then
		guiSetEnabled(bPlayAs, false)
		guiSetEnabled(wDetailScreen, false)
		guiSetEnabled( newCharacterButton, false )
	end
	removeEventHandler("onClientRender", getRootElement(), renderNametags)
	removeEventHandler("onClientClick", getRootElement(), Characters_onClientClick)
end

function Characters_selectCharacter()
	if (characterSelected ~= nil) then
		Characters_deactivateGUI()
		local randomAnimation = getRandomAnim(3)
		setPedAnimation ( characterElementSelected, randomAnimation[1], randomAnimation[2], -1, true, false, false, false )
		guiSetText ( bPlayAs, "Please wait.." )	
		cFadeOutTime = 254
		addEventHandler("onClientRender", getRootElement(), Characters_FadeOut)
		triggerServerEvent("accounts:characters:spawn", getLocalPlayer(), characterSelected)
	end 
end

function Characters_FadeOut()
	cFadeOutTime = cFadeOutTime -3
	if (cFadeOutTime <= 0) then
		removeEventHandler("onClientRender", getRootElement(), Characters_FadeOut)
	else
		for _, thePed in ipairs(pedTable) do
			if thePed ~= characterElementSelected then
				setElementAlpha(thePed, cFadeOutTime)
			end
		end
	end
end

function characters_destroyDetailScreen()
	lDetailScreen = { }
	if isElement(wDetailScreen) then
		destroyElement(iCharacterImage)
		destroyElement(bPlayAs)
		destroyElement(wDetailScreen)
		iCharacterImage = nil
		iPlayAs = nil
		wDetailScreen = nil
	end
	for _, thePed in ipairs(pedTable) do
		destroyElement(thePed)
	end
	pedTable = { }
	cFadeOutTime = 0
	destroyElement( newCharacterButton )
end
--- End character detail screen

function characters_onSpawn(fixedName, adminLevel, gmLevel, factionID, factionRank)
	clearChat()
	showCursor(false)
	outputChatBox("You are now playing as '" .. fixedName .. "'.", 0, 255, 0)
	outputChatBox("Need Help? /helpme", 255, 194, 14)
	outputChatBox("You can visit the Options menu by pressing 'F10' or /home.", 255, 194, 15)
	outputChatBox(" ")
	characters_destroyDetailScreen()
	setElementData(getLocalPlayer(), "adminlevel", adminLevel, false)
	setElementData(getLocalPlayer(), "account:gmlevel", gmLevel, false)
	setElementData(getLocalPlayer(), "faction", factionID, false)
	setElementData(getLocalPlayer(), "factionrank", factionrank, false)
	
	options_enable()
end
addEventHandler("accounts:characters:spawn", getRootElement(), characters_onSpawn)

function Characters_newCharacter()
	Characters_deactivateGUI()
	characters_destroyDetailScreen()
	newCharacter_init()
end