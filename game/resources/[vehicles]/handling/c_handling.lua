local vehicle = nil
local window, buttonSave, buttonClose = nil
local fields = {}

local _type = type

local width, height = 270, 420
local screen_width, screen_height = guiGetScreenSize()

local validColor = 'FF009900' -- valid input in an editbox

--

function check()
	if not vehicle or getPedOccupiedVehicle(localPlayer) ~= vehicle then
		vehicle = nil
		removeEventHandler('onClientRender', root, check)

		guiSetVisible(window, false)
		guiSetVisible(buttonSave, false)
		guiSetVisible(buttonClose, false)
		guiSetInputMode('allow_binds')
	end
end

--

local function count(t)
	local x = 0
	for _, _ in pairs(t) do
		x = x + 1
	end
	return x
end


-- update gui values

local savedValues = {}

local function updateValue(k, v)
	local element = fields[k]
	if element then
		local type = getElementData(element, 'type')
		if type == 'int' or type == 'string' then
			savedValues[k] = tostring(v)
			guiSetText(element, savedValues[k])
			guiSetProperty(element, 'NormalTextColour', 'FF000000')
		elseif type == 'float' then
			savedValues[k] = string.format("%.3f", v):gsub("(0+)$", ''):gsub("%.$", '')
			guiSetText(element, savedValues[k])
			guiSetProperty(element, 'NormalTextColour', 'FF000000')
		elseif type == 'select' then
			local options = getElementData(element, 'limit')
			for k_, v_ in pairs(options) do
				if k_ == v then
					for i = 0, count(options) - 1 do
						if guiComboBoxGetItemText(element, i) == v_ then
							guiComboBoxSetSelected(element, i)
							savedValues[k] = i
							break
						end
					end
					break
				end
			end
		end
	end
end

local function updateValues()
	handling = getVehicleHandlingEx(vehicle)
	savedValues = {}
	for k, v in pairs(handling) do
		updateValue(k, v)
	end
end

--

function initGUI()
	if window then
		return
	end

	-- build the gui
	window = guiCreateTabPanel(screen_width - width, screen_height - height - 20, width, height, false)
	guiSetAlpha(window, 0.7)

	local y = 0
	for k, v in ipairs(mta_values) do
		if type(v) == 'string' then
			parent = guiCreateTab(v, window)
			y = -10
		elseif v == false then
			y = y + 40
		else
			local name, type, limit, text, elementdata = unpack(v)

			y = y + 22
			local label = guiCreateLabel(10, y, 120, 20, text .. ':', false, parent)
			guiLabelSetHorizontalAlign(label, 'right')

			local element = nil

			-- casual values
			if type == 'string' or type == 'int' or type == 'float' then
				element = guiCreateEdit(140, y - 2, 120, 20, '', false, parent)

				-- simply highlight that this edit box content was changed
				addEventHandler('onClientGUIChanged', element,
					function()
						local value = guiGetText(element)
						if not savedValues[name] or savedValues[name] == value then
							guiSetProperty(element, 'NormalTextColour', 'FF000000')
						else
							guiSetProperty(element, 'NormalTextColour', isValidValue(name, value) and validColor or 'FFFF0000')
						end
					end, false
				)

				-- pressing enter to save
				addEventHandler('onClientGUIAccepted', element,
					function()
						local value = guiGetText(element)
						local requiresChange = guiGetProperty(element, 'NormalTextColour') == validColor
						if requiresChange then
							triggerServerEvent('handling:modify', vehicle, name, value)
						end
					end, false)

			-- something slightly more complex.
			elseif type == 'select' then
				element = guiCreateComboBox(140, y - 2, 120, 20, '<?>', false, parent)
				for k, v in pairs(limit) do
					guiComboBoxAddItem(element, v)
				end
				guiSetSize(element, 120, 40 + count(limit) * 20, false)

				addEventHandler('onClientGUIComboBoxAccepted', element,
					function()
						local item = guiComboBoxGetSelected(element)
						if item and item >= 0 then
							-- try to figure out what's actually selected
							local value = guiComboBoxGetItemText(element, item)
							for key, v_ in pairs(limit) do
								if v_ == value then
									-- text in the combobox matches with the one of the option, use the option's key
									triggerServerEvent('handling:modify', vehicle, name, key)
									break
								end
							end
						end
					end, false)
			end
			fields[name] = element
			setElementData(element, 'limit', limit, false)
			setElementData(element, 'type', type, false)
		end
	end

	-- save button
	buttonSave = guiCreateButton(screen_width - 2/3*width, screen_height - 20, 1/3*width, 20, 'Save', false)
	addEventHandler('onClientGUIClick', buttonSave,
		function(button)
			if button == 'left' then
				-- saves all current stats, not ones possibly pending (i.e. changed recently and not transmitted)
				triggerServerEvent('handling:save', vehicle)
			end
		end, false)

	buttonClose = guiCreateButton(screen_width - 1/3*width, screen_height - 20, 1/3*width, 20, '/delthisveh', false)
	addEventHandler('onClientGUIClick', buttonClose,
		function(button)
			if button == 'left' then
				-- saves all current stats, not ones possibly pending (i.e. changed recently and not transmitted)
				triggerServerEvent('handling:delete', vehicle)
			end
		end, false)

	-- show the gui
	local v = getPedOccupiedVehicle(localPlayer)
	if v and getElementData(v, 'handling:editable') and canEdit(localPlayer) then
		addEventHandler('onClientRender', root, check)
		vehicle = v
		updateValues()
		guiSetInputMode('no_binds_when_editing')
	end
	guiSetVisible(window, vehicle ~= nil)
	guiSetVisible(buttonSave, vehicle ~= nil)
	guiSetVisible(buttonClose, vehicle ~= nil)
end

--

addEventHandler('onClientPlayerVehicleEnter', localPlayer,
	function(v)
		if getElementData(v, 'handling:editable') and canEdit(localPlayer) then
			if not vehicle then
				addEventHandler('onClientRender', root, check)
			end
			vehicle = v
			updateValues()
			guiSetInputMode('no_binds_when_editing')
		else
			vehicle = nil
		end
		guiSetVisible(window, vehicle ~= nil)
		guiSetVisible(buttonSave, vehicle ~= nil)
		guiSetVisible(buttonClose, vehicle ~= nil)
	end
)

--

addEvent('handling:update', true)
addEventHandler('handling:update', resourceRoot,
	function(v, key, value)
		if v == vehicle then
			updateValue(key, value)
		end
	end
)
