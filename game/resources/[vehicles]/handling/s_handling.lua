local handlings = {}
local byShops = nil

addEventHandler('onResourceStart', resourceRoot,
	function()
		local temp = exports.mysql:select('handlings')
		for k, v in ipairs(temp) do
			handlings[v.id] = v
		end
		outputDebugString('Loaded ' .. #temp .. ' handling configurations.')

		-- apply reloaded handling to all vehicles
		for k, v in ipairs(getElementsByType"vehicle") do
			apply(v)
		end
	end
)

--

function apply(vehicle)
	local id = getElementData(vehicle, 'handling:id')
	if id then
		local handling = handlings[id]
		if handling then
			for key, value in pairs(handling) do
				local entry = lookupMTAValue(key)
				if entry and isValidValue(key, value) then
					value = (entry[2] == 'float' or entry[2] == 'int') and tonumber(value) or tostring(value)

					if not entry[5] then
						setVehicleHandling(vehicle, key, value)
					end
				end
			end

			setElementData(vehicle, 'name', { year = handling.year, name = tostring(handling.name), brand = tostring(handling.brand)})
		end
	end
end

--

addEvent('handling:save', true)
addEvent('handling:modify', true)
addEvent('handling:delete', true)

local function saveHandling()
	if not canEdit(client) or not getElementData(source, 'handling:editable') then
		outputDebugString(getPlayerName(client) .. ' called handling:save but has no permission to.')
	else
		-- there's just two options really - either it's a new record, or an update to an older one.
		-- build the existing record.
		local record = {}
		local handling = getVehicleHandling(source)

		for k, v in ipairs(mta_values) do
			if type(v) == 'table' then
				if v[5] then
					record[v[1]] = getElementData(source, v[5])[v[1]]
				else
					record[v[1]] = handling[v[1]]
				end
			end
		end

		record.updated_at = 'NOW()'
		record.model = getElementModel(source)

		local id = getElementData(source, 'handling:id')
		if id then
			-- update existing record
			if exports.mysql:update('handlings', record, { id = id, model = record.model }) == 1 then
				record.id = id

				outputChatBox('Saved handling.', client, 0, 255, 0)

				handlings[id] = record
				byShops = nil
				
				for k, v in ipairs( getElementsByType( 'vehicle' ) ) do
					if getElementData(v, 'handling:id') == id then
						apply(v)
					end
				end
			else
				outputChatBox('Failed to update handling.', client, 255, 0, 0)
			end
		else
			-- new record
			record.created_at = 'NOW()'

			local id = exports.mysql:insert('handlings', record)
			if id then
				setElementData(source, 'handling:id', id, false)
				outputChatBox('Saved as new handling #' .. id .. '.', client, 0, 255, 0)

				record.id = id
				handlings[id] = record
				byShops = nil
			else
				outputChatBox('Failed to save handling.', client, 255, 0, 0)
			end
		end
	end
end

-- this just applies to one vehicle. you'd have to press 'save' to save it for all of the same type
local function modifyHandling(key, value)
	if not canEdit(client) or not getElementData(source, 'handling:editable') then
		outputDebugString(getPlayerName(client) .. ' called handling:modify but has no permission to.')
	else
		outputDebugString('modify handling value -> ' .. key .. ' to ' .. value)
		local entry = lookupMTAValue(key)
		if entry and isValidValue(key, value) then
			value = (entry[2] == 'float' or entry[2] == 'int') and tonumber(value) or value

			if entry[5] then
				-- it's just a userdata value, boring.
				local data = getElementData(source, entry[5])
				data[key] = value
				setElementData(source, entry[5], data)
			else
				setVehicleHandling(source, key, value)
			end

			-- notify all players who could possibly edit this.
			for _, player in ipairs(getElementsByType('player')) do
				if getPedOccupiedVehicle(player) == source and canEdit(player) then
					triggerClientEvent('handling:update', resourceRoot, source, key, value)
				end
			end
		end
	end
end

local function deleteVehicle()
	if not canEdit(client) or not getElementData(source, 'handling:editable') then
		outputDebugString(getPlayerName(client) .. ' called handling:delete but has no permission to.')
	elseif getElementData(source, 'dbid') < 0 then
		destroyElement(source)
	end
end

-- exported
function new(player, model, shop)
	local x, y, z = getElementPosition(player)
	local _, _, r = getElementRotation(player)
	local veh = exports.tempvehicles:create(model, x, y, z, r, player, -1, -1)
	if veh then
		setElementData(veh, 'handling:editable', {shop = shop, price = 20000, disabled = 1 })
		setElementData(veh, 'handling:id', false, false)
		setElementData(veh, 'name', { brand = 'Temporary', name = 'Vehicle', year = '2020' })

		addEventHandler('handling:save', veh, saveHandling, false)
		addEventHandler('handling:modify', veh, modifyHandling, false)
		addEventHandler('handling:delete', veh, deleteVehicle, false)
	end
end

function edit(player, id)
	local handling = handlings[id]
	if handling then
		local x, y, z = getElementPosition(player)
		local _, _, r = getElementRotation(player)
		local veh = exports.tempvehicles:create(handling.model, x, y, z, r, player, -1, -1)
		if veh then
			setElementData(veh, 'handling:editable', {shop = handling.shop, price = handling.price, disabled = handling.disabled })
			setElementData(veh, 'handling:id', id, false)
			setElementData(veh, 'name', { brand = handling.brand, name = handling.name, year = handling.year })

			addEventHandler('handling:save', veh, saveHandling, false)
			addEventHandler('handling:modify', veh, modifyHandling, false)
			addEventHandler('handling:delete', veh, deleteVehicle, false)

			apply(veh)
		end
	end

end

addEventHandler('onResourceStart', resourceRoot,
	function()
		-- fix possible missing links
		local tempvehicles = getResourceRootElement(getResourceFromName('tempvehicles'))
		if tempvehicles then
			for _, veh in ipairs(getElementsByType('vehicle', tempvehicles)) do
				if getElementData(veh, 'handling:editable') then
					addEventHandler('handling:save', veh, saveHandling, false)
					addEventHandler('handling:modify', veh, modifyHandling, false)
					addEventHandler('handling:delete', veh, deleteVehicle, false)
				end
			end
		end
	end
)

-- exported
function getHandlingsByShop(shopID)
	if not byShops then
		byShops = {}
		-- sort all by [shopID]
		for _, value in pairs(handlings) do
			local copy = { id = value.id, model = value.model, brand = value.brand, name = value.name, price = value.price, year = value.year, disabled = value.disabled }
			if not byShops[value.shop] then
				byShops[value.shop] = { copy }
			else
				table.insert(byShops[value.shop], copy)
			end
		end
	end
	return byShops[shopID] or {}
end

-- returns a specific handling configuration
function get(id)
	return handlings[id] or {disabled = 1}
end