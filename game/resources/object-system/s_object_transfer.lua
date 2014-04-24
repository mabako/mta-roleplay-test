function transferDimension(thePlayer, theDimension)
	if theDimension and objects[theDimension] then
		triggerClientEvent(thePlayer, "object:sync:start", getRootElement(), theDimension)
		triggerClientEvent(thePlayer, "object:sync", getRootElement(), objects[theDimension], theDimension)
	end
end

function tranferDimension2(theDimension)
	transferDimension(source, theDimension)
end
addEvent( "object:requestsync", true )
addEventHandler( "object:requestsync", getRootElement(), tranferDimension2 )

function syncDimension(theDimension)
	if (theDimension ~= -1) then
		local players = exports.pool:getPoolElementsByType("player")
		for k, thePlayer in ipairs(players) do
			local playerDimension = getElementDimension(thePlayer)
			if (theDimension == playerDimension) then
				transferDimension(thePlayer, theDimension)
			end
		end
	end
end