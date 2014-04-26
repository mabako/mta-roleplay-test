local window = nil
local screen_width, screen_height = guiGetScreenSize()
local width, height = 700, 500
local left_space, top_space = (screen_width - width) / 2, (screen_height - height) / 2

local function closeWindow(button)
	if window ~= nil and (button == nil or button == 'left') then
		destroyElement(window)
		window = nil
		guiSetInputMode('allow_binds')
	end
end

addEvent("carshop:list", true)
addEventHandler("carshop:list", resourceRoot,
	function(vehicles)
		local ped = source
		closeWindow()

		local shopID = tonumber(getElementID(source):sub(#pedIDPrefix + 1))
		local shop = shops[shopID]
		if shop then
			window = guiCreateWindow(left_space, top_space, width, height, shop.name, false)
			guiWindowSetSizable(window, false)

			local close = guiCreateButton(width - 100, height - 30, 90, 25, 'Close', false, window)
			addEventHandler('onClientGUIClick', close, closeWindow, false)

			local grid = guiCreateGridList(10, 25, width - 20, height - 65, false, window)

			if canEditHandling(localPlayer) then
				local edit, new_model
				local new = guiCreateButton(10, height - 30, 90, 25, 'New Handling', false, window)
				addEventHandler('onClientGUIClick', new,
					function(button)
						if button == 'left' then
							local visible = guiGetVisible(edit)
							guiSetVisible(edit, not visible)
							guiSetVisible(new_model, visible)
							guiSetEnabled(new_model, visible)
							guiSetInputMode(visible and 'no_binds_when_editing' or 'allow_binds')
						end
					end, false)

				new_model = guiCreateEdit(110, height - 30, 90, 25, 'NRG-500', false, window)
				guiSetEnabled(new_model, false)
				guiSetVisible(new_model, false)
				addEventHandler('onClientGUIChanged', new_model,
					function()
						local text = guiGetText(new_model)
						guiSetProperty(new_model, 'NormalTextColour', #text > 0 and getVehicleModelFromName(text) and 'FF000000' or 'FFFF0000')
					end, false)

				addEventHandler('onClientGUIAccepted', new_model,
					function()
						local text = guiGetText(new_model)
						if #text > 0 then
							local model = getVehicleModelFromName(text)
							if model then
								triggerServerEvent('carshop:new', ped, model)
								closeWindow()
							end
						end
					end
				)


				edit = guiCreateButton(110, height - 30, 90, 25, 'Edit', false, window)
				guiSetEnabled(edit, false)
				addEventHandler('onClientGUIClick', edit,
					function(button)
						if button == 'left' then
							local selected = guiGridListGetSelectedItem(grid)
							local id = tonumber(guiGridListGetItemData(grid, selected, 1))
							if id then
								triggerServerEvent('carshop:edit', ped, id)
								closeWindow()
							end
						end
					end, false)

				addEventHandler('onClientGUIClick', grid,
					function(button)
						if button == 'left' then
							guiSetEnabled(edit, guiGridListGetSelectedItem(grid) ~= -1)
						end
					end, false)
			end

			local c_enabled = nil
			if canEditHandling(localPlayer) then
				c_enabled = guiGridListAddColumn(grid, 'Enabled', 0.05)
			end
			local c_name = guiGridListAddColumn(grid, 'Name', 0.3)
			local c_year = guiGridListAddColumn(grid, 'Year', 0.2)
			local c_price = guiGridListAddColumn(grid, 'Price', 0.2)
			local c_model = guiGridListAddColumn(grid, 'GTA Model', 0.2)

			for _, car in ipairs(vehicles) do
				if canEditHandling(localPlayer) or car.disabled == 0 then
					local row = guiGridListAddRow(grid)
					if canEditHandling(localPlayer) then
						guiGridListSetItemText(grid, row, c_enabled, car.disabled == 1 and 'No' or '', false, false)
						guiGridListSetItemData(grid, row, c_enabled, tostring(car.id)) -- handling id
					end

					guiGridListSetItemText(grid, row, c_name, car.brand .. ' ' .. car.name, false, false)
					guiGridListSetItemText(grid, row, c_year, car.year, false, true)
					guiGridListSetItemText(grid, row, c_price, '$' .. exports.global:formatMoney(car.price), false, false)
					guiGridListSetItemText(grid, row, c_model, getVehicleNameFromModel(car.model), false, true)
				end
			end
		end
	end
)
