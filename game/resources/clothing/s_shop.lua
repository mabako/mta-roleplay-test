addEvent('clothing:list', true)
addEventHandler('clothing:list', resourceRoot,
	function()
		if type(savedClothing) == 'table' then
			triggerLatentClientEvent(client, 'clothing:list', resourceRoot, savedClothing)
		else
			outputChatBox('Clothing list is currently not available.', client, 255, 0, 0)
		end
	end, false)

-- buying stuff
addEvent('clothing:buy', true)
addEventHandler('clothing:buy', resourceRoot,
	function(id)
		local clothing = savedClothing[id]
		if clothing then
			-- enough money to steal?
			if clothing.price == 0 or exports.global:hasMoney(client, clothing.price) then
				-- enough backpack space?
				if exports.global:giveItem(client, 16, clothing.skin .. ':' .. clothing.id) then
					outputChatBox('You purchased some clothing for $' .. exports.global:formatMoney(clothing.price) .. '.', client, 0, 255, 0)

					-- take & give some money
					if clothing.price > 0 then
						exports.global:takeMoney(client, clothing.price)

						local dimension = getElementDimension(client)
						if dimension > 0 then
							local ownerID, ownerPlayer = getInteriorOwner(client)
							if ownerID > 0 then -- someone even owns it
								if ownerPlayer then
									local profits = getElementData(ownerPlayer, "businessprofit")
									exports['anticheat-system']:changeProtectedElementDataEx(ownerPlayer, "businessprofit", profits + clothing.price, false)
								else
									exports.mysql:query_free( "UPDATE characters SET bankmoney=bankmoney + " .. exports.mysql:escape_string(clothing.price) .. " WHERE id = " .. exports.mysql:escape_string(ownerID) .. " LIMIT 1")
								end
							end
						end
					end
				else
					outputChatBox('You do not have enough space in your inventory.', client, 255, 0, 0)
				end
			else
				outputChatBox('You do not have the required $' .. exports.global:formatMoney(clothing.price) .. '.')
			end
		end
	end, false)

-- saving new or old clothes
addEvent('clothing:save', true)
addEventHandler('clothing:save', resourceRoot,
	function(values)
		if canEdit(client) then
			if not values.id then
				-- new clothing stuff
				values.id = exports.mysql:query_insert_free("INSERT INTO clothing (skin, url, description, price) VALUES (" .. tonumber(values.skin) .. ", '" .. exports.mysql:escape_string(values.url) .. "', '" .. exports.mysql:escape_string(values.description) .. "', " .. tonumber(values.price) .. ")")
				if values.id then
					savedClothing[values.id] = values
					outputChatBox('Clothes added with id ' .. values.id .. '.', client, 0, 255, 0)
				else
					outputChatBox('Unable to add clothes.', client, 255, 0, 0)
				end
			else
				-- old clothing stuff
				local existing = savedClothing[values.id]
				if existing then
					if exports.mysql:query_free('UPDATE clothing SET skin = ' .. tonumber(values.skin) .. ', description = "' .. exports.mysql:escape_string(values.description) .. '", price = ' .. tonumber(values.price) .. ' WHERE id = ' .. tonumber(values.id)) then
						outputChatBox('Saved clothing.', client, 0, 255, 0)

						existing.skin = tonumber(values.skin)
						existing.description = tostring(values.description)
						existing.price = tonumber(values.price)
					else
						outputChatBox('Clothes couldn\'t be saved.', client, 255, 0, 0)
					end
				else
					outputChatBox('Unable to find clothes?', client, 255, 0, 0)
				end
			end
		end
	end, false)