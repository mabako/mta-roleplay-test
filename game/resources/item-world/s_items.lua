function createItem(id, itemID, itemValue, ...)
	local o = createObject(...)
	exports['anticheat-system']:changeProtectedElementDataEx(o, "id", id, false)
	exports['anticheat-system']:changeProtectedElementDataEx(o, "itemID", itemID)
	exports['anticheat-system']:changeProtectedElementDataEx(o, "itemValue", itemValue, itemValue ~= 1)
	return o
end
