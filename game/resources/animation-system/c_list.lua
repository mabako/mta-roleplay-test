local actual_block = nil
ani_all = {}

function xmlToTable(xmlFile, index)
	local xml = getResourceConfig(xmlFile)
	if not xml then
		return false
	end
	local result
	if index then
		result = dumpXMLToTable(xmlFindChild(xml, "group", index), "anim")
	else
		result = dumpXMLToTable(xml, "group")
	end
	
	xmlUnloadFile(xml)
	return result
end

function dumpXMLToTable(parentNode, key)
	local results = {}
	local i = 0
	local groupNode = xmlFindChild(parentNode, key, i)
	while groupNode do
		local group = {'group', name=xmlNodeGetAttribute(groupNode, 'name'), index=i}
		table.insert(results, group)
		i = i + 1
		groupNode = xmlFindChild(parentNode, key, i)
	end
	return results
end

function ani_start()
	ani_window = guiCreateWindow(0.8,0.30,0.20,0.40,"Animations",true)
		guiWindowSetSizable(ani_window,false)

	ani_tab_panel = guiCreateTabPanel(0.05, 0.07, 0.90, 0.90, true, ani_window)

	ani_tab_all = guiCreateTab("All", ani_tab_panel)
		ani_grid = guiCreateGridList(0.02,0.02,0.96,0.77,true,ani_tab_all)
			guiGridListAddColumn(ani_grid, "", 0.85)
			guiGridListSetSelectionMode(ani_grid, 0)
			addEventHandler("onClientGUIDoubleClick", ani_grid, ani_animation, false)
		
		ani_loop = guiCreateCheckBox(0.10,0.83,0.45,0.08,"repeat",true,true,ani_tab_all)

		ani_button = guiCreateButton(0.10,0.92,0.25,0.06, "Start",true,ani_tab_all)
			addEventHandler("onClientGUIClick", ani_button, ani_animation, false)
			
		ani_add_favourites = guiCreateButton(0.40,0.92,0.25,0.06, "Add",true,ani_tab_all)
			addEventHandler("onClientGUIClick", ani_add_favourites, ani_add, false)
		
		ani_close = guiCreateButton(0.70,0.92,0.25,0.06,"Close",true,ani_tab_all)
			addEventHandler("onClientGUIClick", ani_close, ani_zamknij, false)

	ani_tab_favourites = guiCreateTab("Favourites", ani_tab_panel)
		addEventHandler("onClientGUITabSwitched", ani_tab_favourites, ani_getfavourites)
		ani_grid_fav = guiCreateGridList(0.02,0.02,0.96,0.77,true,ani_tab_favourites)
			guiGridListAddColumn(ani_grid_fav, "", 0.40)
			guiGridListAddColumn(ani_grid_fav, "", 0.45)
			guiGridListSetSelectionMode(ani_grid_fav, 0)
			addEventHandler("onClientGUIDoubleClick", ani_grid_fav, ani_animation, false)

		ani_loop_fav = guiCreateCheckBox(0.10,0.83,0.45,0.08,"repeat",true,true,ani_tab_favourites)

		ani_button_fav = guiCreateButton(0.10,0.92,0.25,0.06, "Start",true,ani_tab_favourites)
			addEventHandler("onClientGUIClick", ani_button_fav, ani_animation, false)
			
		ani_add_favourites_fav = guiCreateButton(0.40,0.92,0.25,0.06, "Delete",true,ani_tab_favourites)
			addEventHandler("onClientGUIClick", ani_add_favourites_fav, ani_del, false)
		
		ani_close_fav = guiCreateButton(0.70,0.92,0.25,0.06,"Close",true,ani_tab_favourites)
			addEventHandler("onClientGUIClick", ani_close_fav, ani_zamknij, false)

	guiSetVisible(ani_window,false)
	
	ani_getall()
	
	xmlFile = ani_loadfile()
	ani_aktualizuj(true)
end

function ani_loadfile()
	local file = xmlLoadFile("favourite.xml")
	if not file then
		file = xmlCreateFile("favourite.xml", "favourites")
	end
	
	xmlSaveFile(file)
	
	if xmlFindChild(file, "animation", 0) then
		local childrens = xmlNodeGetChildren(file)
		
		for key, node in pairs(childrens) do
			local anim = xmlNodeGetAttribute(node, "animation")
			local block = xmlNodeGetAttribute(node, "block")
			
			if not isAnimation(block, anim) then
				xmlDestroyNode(node)
				xmlSaveFile(file)
			end
		end
	end

	return file
end

function isAnimation(block, name)
	for key, value in pairs(ani_all) do
		if value.group == block and value.anim == name then
			return true
		end
	end
	return false
end

function ani_zamknij()
	if guiGetVisible(ani_window) then
		guiSetVisible(ani_window, false)
		showCursor(false)	
	end
end

function ani_otworz()
	if not guiGetVisible(ani_window) then
		guiSetVisible(ani_window, true)
		showCursor(true)
	end
end
	
function ani_add()
	local tekst = guiGridListGetItemText(ani_grid, guiGridListGetSelectedItem(ani_grid), 1)
	if tekst ~= "" then
		if tekst ~= "..." then
			if actual_block and tekst then
				if isAnimation(actual_block, tekst) then
					local child = xmlCreateChild(xmlFile, "animation")
				
					xmlNodeSetAttribute(child, "block", actual_block)
					xmlNodeSetAttribute(child, "animation", tekst)
					
					xmlSaveFile(xmlFile)
				end
			end
		end
	end
end

function ani_del()
	local selected = guiGridListGetSelectedItem(ani_grid_fav)
	if tekst ~= -1 then
		local tekst = guiGridListGetItemText(ani_grid_fav, selected, 1)
		if tekst ~= "" then
			if tekst ~= "..." then
				local block = guiGridListGetItemText(ani_grid_fav, selected, 1)
				local index = tonumber(guiGridListGetItemData(ani_grid_fav, selected, 1))
				local animation = guiGridListGetItemText(ani_grid_fav, selected, 2)
				
				if block and animation then
					local node = xmlFindChild(xmlFile, "animation", index-1)
					if node then
						xmlDestroyNode(node)
					end
					xmlSaveFile(xmlFile)
					ani_getfavourites()
				end
			end
		end
	end
end

function ani_getfavourites()
	if xmlFile then
		if guiGridListClear(ani_grid_fav) then
			for key, node in pairs(xmlNodeGetChildren(xmlFile)) do
				local block = xmlNodeGetAttribute(node, "block")
				local anim = xmlNodeGetAttribute(node, "animation")
			
				local row = guiGridListAddRow(ani_grid_fav)
				guiGridListSetItemText(ani_grid_fav, row, 1, tostring(block), false, false)
				guiGridListSetItemData(ani_grid_fav, row, 1, tostring(key))
				guiGridListSetItemText(ani_grid_fav, row, 2, tostring(anim), false, false)
			end
		end
	end
end

function ani_animation()
	if source == ani_grid then
		local tekst = guiGridListGetItemText(ani_grid, guiGridListGetSelectedItem(ani_grid), 1)
		if teskt ~= "" then
			if tekst == "..." then
				ani_aktualizuj(true)
				actual_block = nil
			else
				if guiGridListGetItemText(ani_grid, 0, 1) ~= "..." then
					actual_block = tekst
					ani_aktualizuj(false,tonumber(guiGridListGetItemData(ani_grid, guiGridListGetSelectedItem(ani_grid), 1)))
				else
					if tekst == "" then
						applyAnimation()
					else
						applyAnimation(actual_block,tekst,guiCheckBoxGetSelected(ani_loop))
					end
				end
			end
		end
	else
		local block = guiGridListGetItemText(ani_grid_fav, guiGridListGetSelectedItem(ani_grid_fav), 1)
		local anim = guiGridListGetItemText(ani_grid_fav, guiGridListGetSelectedItem(ani_grid_fav), 2)
		if teskt ~= "" then
			applyAnimation(block,anim,guiCheckBoxGetSelected(ani_loop_fav))
		end
	end
end

function ani_getall()
	for key, node in pairs(xmlToTable("animations.xml")) do
		for index, grupa in pairs(xmlToTable("animations.xml", node.index)) do
			table.insert(ani_all, { ["group"] = node.name, ["anim"] = grupa.name } )
		end
	end
end

function ani_aktualizuj(stan,index)
	if guiGridListClear(ani_grid) then
		if stan then
			for _, grupa in pairs(xmlToTable("animations.xml")) do
				local row = guiGridListAddRow(ani_grid)
				guiGridListSetItemText(ani_grid, row, 1, tostring(grupa["name"]), false, false)
				guiGridListSetItemData(ani_grid, row, 1, tostring(grupa["index"]))
			end
		else
			if index then
				local row = guiGridListAddRow(ani_grid)
				guiGridListSetItemText(ani_grid, row, 1, "...", false, false)
				
				for _, grupa in pairs(xmlToTable("animations.xml", index)) do
					local row = guiGridListAddRow(ani_grid)
					guiGridListSetItemText(ani_grid, row, 1, tostring(grupa["name"]), false, false)
					guiGridListSetItemData(ani_grid, row, 1, tostring(grupa["index"]))
				end
			end
		end
	end
end

function applyAnimation(block,ani,loop)
	triggerServerEvent("AnimationSet", getLocalPlayer(), tostring(block), tostring(ani), loop)
end

function ani_init()
	if not guiGetVisible(ani_window) then
		ani_otworz()
	else
		ani_zamknij()
	end
end
addCommandHandler("animselect", ani_init)

function ani_stop()
	applyAnimation()
end
addCommandHandler("animstop", ani_stop)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), ani_start)