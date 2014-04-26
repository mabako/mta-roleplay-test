function createItem(v)
	local rx, ry, rz, zoffset = exports['item-system']:getItemRotInfo(v.itemid)
	local model = exports['item-system']:getItemModel(v.itemid, v.itemvalue)

	local o = createObject(model, v.x, v.y, v.z + (zoffset or 0), rx, ry, rz + v.rz)
	exports['anticheat-system']:changeProtectedElementDataEx(o, "id", v.id, false)
	exports['anticheat-system']:changeProtectedElementDataEx(o, "itemID", v.itemid)
	exports['anticheat-system']:changeProtectedElementDataEx(o, "itemValue", v.itemvalue, v.itemvalue ~= 1)
	exports['anticheat-system']:changeProtectedElementDataEx(o, "creator", v.creator, false)

	setElementDimension(o, v.dimension)
	setElementInterior(o, v.interior)

	return o
end
