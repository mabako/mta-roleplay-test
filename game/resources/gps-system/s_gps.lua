-- Bind Keys required
function bindKeys()
	local players = exports.pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		if not(isKeyBound(arrayPlayer, "F5", "down", showGPS)) then
			bindKey(arrayPlayer, "F5", "down", showGPS)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "F5", "down", showGPS)
end
addEventHandler("onResourceStart", getResourceRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function showGPS(player)
	local vehicle = getPedOccupiedVehicle(player)

	if (vehicle) then -- In vehicle
		local seat = getPedOccupiedVehicleSeat(player)
		
		if (seat==0) then
			if (exports.global:hasItem(vehicle, 67, nil)) then -- has GPS?
				triggerClientEvent(player, "displayGPS", vehicle)
			end
		end
	end
end