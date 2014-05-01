local window, editing_window = nil

-- creating the ped
local previewPed = nil
local defaultModel = 211

function createShopPed()
	local ped = createPed(defaultModel, 1468.5, 1532.9, 10.85)
	setElementFrozen(ped, true)
	setElementRotation(ped, 0, 0, 155)
	setElementDimension(ped, 241)
	setElementInterior(ped, 1)

	setElementData(ped, 'name', 'Julie Dupont', false)

	addEventHandler( 'onClientPedWasted', ped,
		function()
			setTimer(
				function()
					destroyElement(ped)
					createShopPed()
				end, 20000, 1)
		end, false)

	addEventHandler( 'onClientPedDamage', ped, cancelEvent, false )
	addEventHandler( 'onClientClick', root,
		function(button, state, absX, absY, wx, wy, wz, element)
			if button == 'right' and state == 'down' and element == ped and not window then
				local x, y, z = getElementPosition(element)
				if getDistanceBetweenPoints3D(x, y, z, getElementPosition(localPlayer)) < 3 then
					triggerServerEvent('clothing:list', resourceRoot)
				end
			end
		end, false)

	previewPed = ped
end

addEventHandler( 'onClientResourceStart', resourceRoot, createShopPed )

-- gui to show all clothing items
local screen_width, screen_height = guiGetScreenSize()
local width, height = 700, math.min(400, math.max(180, math.ceil(screen_height / 4)))
local list, checkbox, grid, editing_item = nil

local function resetPed()
	setElementModel(previewPed, defaultModel)
	setElementData(previewPed, 'clothing:id', nil, false)
end

local function closeEditingWindow()
	if editing_window then
		destroyElement(editing_window)
		editing_window = nil

		guiSetInputMode('allow_binds')

		editing_item = nil
	end
end

local function closeWindow()
	if window then
		destroyElement(window)
		window = nil
	end

	closeEditingWindow()

	resetPed()
end

-- forcibly close the window upon streaming out
addEventHandler('onClientElementStreamOut', resourceRoot, closeWindow)
addEventHandler('onClientResourceStop', resourceRoot, closeWindow)

-- returns the table by [skin] = true
local function getFittingSkins()
	local race, gender = getElementData(localPlayer, 'race'), getElementData(localPlayer, 'gender')
	local temp = exports['shop-system']:getFittingSkins()

	local t = {}
	for k, v in ipairs(temp[gender][race]) do
		t[v] = true
	end
	return t
end

-- called every once in a while when (de-)selecting the 'only show fitting' checkbox
local function updateGrid()
	-- clean up a little beforehand
	guiGridListClear(grid)

	local only_fitting = guiCheckBoxGetSelected(checkbox)
	local fitting_skins = getFittingSkins()

	for k, v in ipairs(list) do
		-- price 0 might be disabled, dont show it if the player doesnt have a key
		if v.price > 0 or canEdit(localPlayer) then
			-- either display all skins, or only those matching the race/gender
			if not only_fitting or fitting_skins[v.skin] then
				local row = guiGridListAddRow(grid)
				guiGridListSetItemText(grid, row, 1, tostring(v.id), false, false)
				guiGridListSetItemData(grid, row, 1, tostring(k)) -- index in [list]
				guiGridListSetItemText(grid, row, 2, tostring(v.description), false, false)
				guiGridListSetItemText(grid, row, 3, tostring(v.skin), false, false)
				guiGridListSetItemText(grid, row, 4, '$' .. exports.global:formatMoney(v.price), false, false)
			end
		end
	end
end

addEvent('clothing:list', true)
addEventHandler('clothing:list', resourceRoot,
	function(list_)
		closeWindow()

		window = guiCreateWindow(screen_width - width, screen_height - height, width, height, 'Dupont Fashion', false)
		guiWindowSetSizable(window, false)

		grid = guiCreateGridList(10, 25, width - 20, height - 60, false, window)
		guiGridListAddColumn(grid, 'ID', 0.07)
		guiGridListAddColumn(grid, 'Description', 0.7)
		guiGridListAddColumn(grid, 'Base Skin', 0.1)
		guiGridListAddColumn(grid, 'Price', 0.1)

		local close = guiCreateButton(width - 110, height - 30, 100, 25, 'Close', false, window)
		addEventHandler('onClientGUIClick', close, closeWindow, false)

		local buy = guiCreateButton(width - 220, height - 30, 100, 25, 'Buy', false, window)
		guiSetEnabled(buy, false)

		checkbox = guiCreateCheckBox(width - 380, height - 33, 155, 22, 'Only Skins you can wear', true, false, window)
		addEventHandler('onClientGUIClick', checkbox, updateGrid, false)

		local newedit = nil
		if canEdit(localPlayer) then
			newedit = guiCreateButton(10, height - 30, 100, 25, 'New', false, window)
		end


		-- fill the skins list
		sortList(list_)
		list = list_
		updateGrid()

		-- event handler for previewing items
		addEventHandler('onClientGUIClick', grid,
			function(button)
				if button == 'left' then
					-- update the preview ped to reflect actual clothing changes
					local row, column = guiGridListGetSelectedItem(grid)
					if row == -1 then
						resetPed()

						guiSetEnabled(buy, false)

						if newedit then
							guiSetText(newedit, 'New')
						end
					else
						local item = list[tonumber(guiGridListGetItemData(grid, row, 1))]
						if item then
							setElementModel(previewPed, item.skin)
							setElementData(previewPed, 'clothing:id', item.id, false)

							guiSetEnabled(buy, item.price == 0 or exports.global:hasMoney(localPlayer, item.price))

							if newedit then
								guiSetText(newedit, 'Edit')
							end
						else
							outputDebugString('Clothing preview broke, aw.')
							guiSetEnabled(buy, false)
						end
					end

					-- we selected another row, so tweak that a bit
					closeEditingWindow()
				end
			end, false)

		-- buying things
		addEventHandler('onClientGUIClick', buy,
			function(button)
				if button == 'left' then
					local row, column = guiGridListGetSelectedItem(grid)
					if row ~= -1 then
						local item = list[tonumber(guiGridListGetItemData(grid, row, 1))]
						if item then
							triggerServerEvent('clothing:buy', resourceRoot, item.id)
						end
					end
				end
			end, false)

		-- new/edit
		if newedit then
			addEventHandler('onClientGUIClick', newedit,
				function(button)
					if button == 'left' then
						createEditWindow()
					end
				end, false)
		end
	end, false)

-- editing window
local editing_width, editing_height = 400, 145
function createEditWindow()
	if editing_window then
		destroyElement(editing_window)
	end

	-- prepare the gui
	editing_window = guiCreateWindow((screen_width - editing_width) / 2, (screen_height - editing_height) / 2, editing_width, editing_height, 'Clothing', false)
	guiWindowSetSizable(editing_window, false)

	-- just really build a tiny list of elements
	local desc = { { 'skin', 'Base Skin' }, { 'url', 'URL'}, { 'description', 'Description'}, { 'price', 'Price ($)'} }
	for k, v in ipairs(desc) do
		v.label = guiCreateLabel(10, 22 * k + 3, 100, 22, v[2] .. ':', false, editing_window)
		guiLabelSetHorizontalAlign(v.label, 'right')

		v.edit = guiCreateEdit(115, 22 * k, editing_width - 125, 22, '', false, editing_window)
	end

	local row, column = guiGridListGetSelectedItem(grid)
	if row == -1 then
		editing_item = nil
	else
		editing_item = tonumber(guiGridListGetItemData(grid, row, 1))

		-- pre-select values
		for k, v in ipairs(desc) do
			guiSetText(v.edit, tostring(list[editing_item][v[1]]))

			-- can't edit the url afterwards, though it'll be copied to your clipboard
			if v[1] == 'url' then
				-- reduce the size of the original widget
				local copy_width = 70
				local width, height = guiGetSize(v.edit, false)
				guiSetSize(v.edit, width - copy_width, height, false)

				local x, y = guiGetPosition(v.edit, false)

				-- stick a button next to it
				local copy = guiCreateButton(x + width - copy_width, y, copy_width, height, 'Copy', false, editing_window)
				addEventHandler('onClientGUIClick', copy,
					function(button)
						if button == 'left' then
							local text = guiGetText(v.edit)
							setClipboard(text)
							outputChatBox('Copied \'' .. text .. '\' to clipboard.', 0, 255, 0)
						end
					end, false)
			end
		end
	end

	local discard = guiCreateButton(10, editing_height - 30, 100, 25, 'Discard', false, editing_window)
	addEventHandler('onClientGUIClick', discard, closeEditingWindow, false)

	local save = guiCreateButton(editing_width - 110, editing_height - 30, 100, 25, 'Save', false, editing_window)
	addEventHandler('onClientGUIClick', save,
		function()
			-- it's really only transferring edited values to the server
			local values = {}
			for k, v in ipairs(desc) do
				local value = guiGetText(v.edit)
				if k == 1 or k == 4 then
					value = tonumber(value)
				end
				values[v[1]] = value
			end
			values.id = editing_item

			triggerServerEvent('clothing:save', resourceRoot, values)

			closeEditingWindow()
		end, false)

	-- allow binds for editing
	guiSetInputMode('no_binds_when_editing')
end