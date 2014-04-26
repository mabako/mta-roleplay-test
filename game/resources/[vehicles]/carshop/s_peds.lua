addEvent('carshop:new', true)

local function pedClicked(button, state, player)
	if button == 'left' and state == 'up' then
		local id = tonumber(getElementID(source):sub(#pedIDPrefix + 1))
		if id and shops[id] then
			triggerClientEvent(player, 'carshop:list', source, exports.handling:getHandlingsByShop(id))
		end
	end
end

local function newHandling(model)
	exports.handling:new(client, model, tonumber(getElementID(source):sub(#pedIDPrefix + 1)))
end

addEventHandler('onResourceStart', resourceRoot,
	function()
		for k, v in ipairs(shops) do
			local blip = createBlip(v.pos[1], v.pos[2], v.pos[3], 55, 2, 255, 255, 255, 255, 0, 300)
			setElementInterior(blip, v.pos[4])
			setElementDimension(blip, v.pos[5])

			if v.npc then
				local ped = createPed(v.npc.skin, v.pos[1], v.pos[2], v.pos[3])
				setElementID(ped, pedIDPrefix .. k)
				setElementRotation(ped, 0, 0, v.npc.rot)
				setElementInterior(ped, v.pos[4])
				setElementDimension(ped, v.pos[5])
				setElementFrozen(ped, true)
				setElementData(ped, 'name', v.npc.name)

				addEventHandler('onElementClicked', ped, pedClicked, false)
				addEventHandler('carshop:new', ped, newHandling, false)
			end
		end
	end
)
