local thePlayer = getLocalPlayer()

function openDutyWindow()
	local availablePackages = fetchAvailablePackages( thePlayer )
		
	if #availablePackages > 0 then
		local dutyLevel = getElementData( thePlayer, "duty")
		if not dutyLevel or dutyLevel == 0 then
			selectPackageGUI_open(availablePackages)
		else
			triggerServerEvent("duty:offduty", thePlayer)
		end
	else
		outputChatBox("There is no duty available for you at this spot!")
	end
end
addCommandHandler("duty", openDutyWindow)

-- --- --
-- GUI --
-- --- --
local gAvailablePackages = nil
local gChks = { }
local gButtons = { }
local gui = { }

function selectPackageGUI_open(availablePackages)
	gAvailablePackages = availablePackages
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 680, 516
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	gui["_root"] = guiCreateWindow(left, top, windowWidth, windowHeight, "Duty Selection", false)
	guiWindowSetSizable(gui["_root"], false)
	
	gui["tabSelection"] = guiCreateTabPanel(10, 25, 651, 471, false, gui["_root"])
	for pIndex, packageDetails in ipairs(availablePackages) do
		local guiTabName = "package"..tostring(packageDetails["grantID"])
		gui[guiTabName] = guiCreateTab(packageDetails["packageName"], gui["tabSelection"])

		local xAxis = 10 -- Start at 10
		local yAxis = 20 -- Start at 10
		
		-- Regular items
		for index, itemDetails in ipairs(packageDetails["items"]) do
			local guiPrefix = guiTabName.."-package"..tostring(index).."-"
			
			gui[guiPrefix.."chk1"] = guiCreateCheckBox(xAxis + 30, yAxis+50, 16, 17, "chk", false, false, gui[guiTabName])
			setElementData(gui[guiPrefix.."chk1"], "button:action", "Push")
			setElementData(gui[guiPrefix.."chk1"], "button:itemDetails", itemDetails)
			setElementData(gui[guiPrefix.."chk1"], "button:itemID", index)
			setElementData(gui[guiPrefix.."chk1"], "button:grantID", packageDetails["grantID"])
			setElementData(gui[guiPrefix.."chk1"], "button:chk", gui[guiPrefix.."chk1"])
			addEventHandler("onClientGUIClick", gui[guiPrefix.."chk1"], selectPackageGUI_process)
			addEventHandler("onClientGUIDoubleClick", gui[guiPrefix.."chk1"], selectPackageGUI_process)
			table.insert(gChks, gui[guiPrefix.."chk1"])
			
			gui[guiPrefix.."pushButton1"] = guiCreateButton(xAxis, yAxis, 71, 51, exports['item-system']:getItemName(itemDetails[1]), false, gui[guiTabName])
			setElementData(gui[guiPrefix.."pushButton1"], "button:action", "Push")
			setElementData(gui[guiPrefix.."pushButton1"], "button:chk", gui[guiPrefix.."chk1"])
			addEventHandler("onClientGUIClick", gui[guiPrefix.."pushButton1"], selectPackageGUI_process)
			gButtons[ gui[guiPrefix.."chk1"] ] = gui[guiPrefix.."pushButton1"]
			
			gui[guiPrefix.."label_3"] = guiCreateLabel(xAxis, yAxis+6, 71, 13, itemDetails[2], false, gui[guiTabName])
			guiLabelSetHorizontalAlign(gui[guiPrefix.."label_3"], "left", false)
			guiLabelSetVerticalAlign(gui[guiPrefix.."label_3"], "center")
			guiSetProperty(gui[guiPrefix.."label_3"], "AlwaysOnTop", "True")

			xAxis = xAxis + 80 -- prepare next row
			
			if xAxis >= 650 then
				xAxis = 10
				yAxis = yAxis + 70
			end
		end
		
		-- Skins
		local skinTable = { }
		
		-- show current skin?
		if not packageDetails["forceSkinChange"] then
			local currentSkin = getElementModel( thePlayer )
			table.insert(skinTable, tonumber(currentSkin))
		end
		
		-- add package skins
		if packageDetails["skins"] then
			for i, a in ipairs(packageDetails["skins"]) do
				table.insert(skinTable, tonumber(a))
			end
		end
		
		local xAxis = 0 -- Start at 10
		local yAxis = 200 -- Start at 10
		
		local count = 0
		for skinIndex, skinID in ipairs(skinTable) do
			count = count + 1
			local skinImg = skinID
			if(skinID<10) then
				skinImg = tostring("00"..skinID)
			elseif(skinID < 100) then
				skinImg = tostring("0"..skinID)
			else
				skinImg = tostring(skinImg)
			end

			gui[guiTabName.."-radio-"..skinID] = guiCreateRadioButton (xAxis + 30, yAxis+80, 15, 15, "", false, gui[guiTabName] )
			setElementData(gui[guiTabName.."-radio-"..skinID], "button:skinID", skinID)
			setElementData(gui[guiTabName.."-radio-"..skinID], "button:grantID", packageDetails["grantID"])
			table.insert(gChks, gui[guiTabName.."-radio-"..skinID])
			if skinIndex == 1 then
				guiRadioButtonSetSelected(gui[guiTabName.."-radio-"..skinID], true)
			end
			
			gui[guiTabName.."-skin-"..skinID] = guiCreateStaticImage (xAxis, yAxis, 75, 75, ":account-system/img/" .. skinImg..".png", false, gui[guiTabName] )
			setElementData(gui[guiTabName.."-skin-"..skinID], "button:action", "Radio")
			setElementData(gui[guiTabName.."-skin-"..skinID], "button:element", gui[guiTabName.."-radio-"..skinID])
			addEventHandler("onClientGUIClick", gui[guiTabName.."-skin-"..skinID], selectPackageGUI_process)
			xAxis = xAxis + 80 -- prepare next row
			if count == 8 then
				count = 0
				xAxis = 10
				yAxis = yAxis + 100
			end
		end

		gui[guiTabName.."-cancel"] = guiCreateButton(10, 400, 200, 35, "Cancel", false, gui[guiTabName])
		setElementData(gui[guiTabName.."-cancel"], "button:action", "Cancel")
		addEventHandler("onClientGUIClick", gui[guiTabName.."-cancel"], selectPackageGUI_process)
		
		gui[guiTabName.."-spawn"] = guiCreateButton(440, 400, 200, 35, "Spawn", false, gui[guiTabName])
		setElementData(gui[guiTabName.."-spawn"], "button:action", "Go")
		setElementData(gui[guiTabName.."-spawn"], "button:grantID", packageDetails["grantID"])
		addEventHandler("onClientGUIClick", gui[guiTabName.."-spawn"], selectPackageGUI_process)
	end
end

function selectPackageGUI_process(mouseButton, mouseState, absoluteX, absoluteY)
	if source and isElement(source) and mouseButton == "left" and mouseState == "up" then
		local theGUIelement = source
		local btnAction = getElementData(theGUIelement, "button:action")
		if btnAction then
			if btnAction == "Cancel" then
				destroyElement(gui["_root"])
				gui = { }
				gChks = { }
				gAvailablePackages = { }
			elseif btnAction == "Radio" then 
				local victimElement = getElementData(theGUIelement, "button:element")
				if victimElement then
					guiRadioButtonSetSelected(victimElement, true)
				end
			elseif btnAction == "Go" then
				local grantID = getElementData(theGUIelement, "button:grantID")
				if grantID then
					local spawnRequest = { }
					local spawnSkin = -1
					-- Make spawn request for server
					for tableIndex, chkBox in ipairs(gChks) do
						local rowGrantID = getElementData(chkBox, "button:grantID")
						if rowGrantID == grantID then
							local rowItemDetails = getElementData(chkBox, "button:itemDetails")
							if rowItemDetails then
								if guiCheckBoxGetSelected(chkBox) then
									table.insert(spawnRequest, rowItemDetails)
								end
							end
							local rowSkinDetails = getElementData(chkBox, "button:skinID")
							if rowSkinDetails then
								if guiRadioButtonGetSelected(chkBox) then
									spawnSkin = tonumber(rowSkinDetails)
								end
							end
						end
					end
					destroyElement(gui["_root"])
					gui = { }
					gChks = { }
					gAvailablePackages = { }
					
					--outputChatBox("Spawnrequest for package "..grantID)
					--for i, a in ipairs(spawnRequest) do
					--	outputChatBox("i: "..a[1].." (".. exports['item-system']:getItemName(a[1]) ..") v:"..a[2])
					--end
					--outputChatBox("Spawnskin: "..spawnSkin)
					--outputChatBox("---")
					
					if spawnSkin == -1 then
						return
					end
					triggerServerEvent("duty:request", thePlayer, grantID, spawnRequest, spawnSkin)
				end
				
			elseif btnAction == "Push" then
				local guiChk = getElementData(theGUIelement, "button:chk")
				if guiChk then
					local newstate =  not guiCheckBoxGetSelected ( guiChk )
					chkItemDetails = getElementData(guiChk, "button:itemDetails")
					if chkItemDetails and chkItemDetails[3] then
						for tableIndex, chkBox in ipairs(gChks) do
							cchkItemDetails = getElementData(chkBox, "button:itemDetails")
							if cchkItemDetails and cchkItemDetails[3] then
								if (cchkItemDetails[3] == chkItemDetails[3]) then
									guiCheckBoxSetSelected ( chkBox, false )
									guiSetEnabled( gButtons[chkBox], not newstate )
								end
							end
						end	
					end
					
					
					guiCheckBoxSetSelected ( guiChk, newstate )
					guiSetEnabled( gButtons[guiChk], true )
				end
			elseif btnAction == "Block" then
				guiCheckBoxSetSelected ( theGUIelement, not guiCheckBoxGetSelected ( theGUIelement ) )
			end
		end
	end
end
