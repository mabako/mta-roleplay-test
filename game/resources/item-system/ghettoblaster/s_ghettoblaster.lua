local function updateWorldItemValue(item, newvalue)
	if newvalue < 0 or newvalue > #tracks then return end
	exports['anticheat-system']:changeProtectedElementDataEx(item, "itemValue", newvalue)
	mysql:query_free( "UPDATE worlditems SET itemvalue='" .. newvalue .. "' WHERE id=" .. getElementData(item, "id"))
end

function toggleGhettoblaster(item)
	local state = tonumber(getElementData(item, "itemValue")) or 1
	if state > 0 then
		exports.global:sendLocalMeAction(source, "turns the Ghettoblaster off.")
	else
		exports.global:sendLocalMeAction(source, "turns the Ghettoblaster on.")
	end
	updateWorldItemValue(item, -state)
end

addEvent("toggleGhettoblaster", true)
addEventHandler("toggleGhettoblaster", getRootElement(), toggleGhettoblaster)

function changeTrack(item, step)
	local current = getElementData(item, "itemValue") or 1
	if current > 0 then
		current = current + step
		if current > #tracks then
			current = 1
		elseif current < 1 then
			current = #tracks
		end
		updateWorldItemValue(item, current)
		exports.global:sendLocalMeAction(source, "retunes the Ghettoblaster.")
	end
end
addEvent("changeGhettoblasterTrack", true)
addEventHandler("changeGhettoblasterTrack", getRootElement(), changeTrack)