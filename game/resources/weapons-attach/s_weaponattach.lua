local bonePositions = {
	
	[30] = { model = 355, bone = 3, x = 0.1, y = 0.25, z = 0, rx = 0, ry = 45, rz = 180 },
	[3]  = { model = 334, bone = 3, x = 0, y = 0, z = 0, rx = 0, ry = 0, rz = 0}
}

local attachedElements = { }

-- needs to listen to updating inventories, some day. happens when you login, change chars, etc.

addEventHandler( 'onPlayerJoin', root,
	function()
		attachedElements[source] = {}
	end)

addEventHandler( 'onResourceStart', resourceRoot,
	function()
		for _, player in ipairs(getElementsByType('player')) do
			attachedElements[player] = {}
		end
	end)

addEventHandler( 'onPlayerQuit', root,
	function()
		-- do items need to be destroyed?

		attachedElements[source] = nil
	end)

addEventHandler( "onPlayerWeaponSwitch", root,
	function(previousWeapon, currentWeapon)
		local new = bonePositions[previousWeapon]
		if new and not attachedElements[source][previousWeapon] then
			-- attach the old weapon
			local element = createObject(new.model, 0, 0, 0)
			exports.bone_attach:attachElementToBone(element, source, new.bone, new.x, new.y, new.z, new.rx, new.ry, new.rz)

			attachedElements[source][previousWeapon] = element

			-- todo set dimension/interior
			-- todo update dimensions/interiors when changing interiors
		end

		local oldElement = attachedElements[source][currentWeapon]
		if oldElement then
			-- was attached before, remove it now
			exports.bone_attach:detachElementFromBone(oldElement)
			destroyElement(oldElement)

			attachedElements[source][currentWeapon] = nil
		end
	end)
			