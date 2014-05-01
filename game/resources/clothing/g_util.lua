function canEdit(player)
	return exports.global:hasItem(player, 5, getElementDimension(player))
end

function sortList(list_)
	table.sort(list_,
		function(a, b)
			if a.model == b.model then
				return a.description < b.description
			else
				return a.model < b.model
			end
		end)
end


function getInteriorOwner(player)
	local dbid, theEntrance, theExit, interiorType, interiorElement = exports["interior-system"]:findProperty(player)
	interiorStatus = getElementData(interiorElement, "status")
	local owner = interiorStatus[4]
	
	for key, value in ipairs(getElementsByType("player")) do
		local id = getElementData(value, "dbid")
		if (id==owner) then
			return owner, value
		end
	end
	return owner, nil -- no player found
end

local getPlayerName_ = getPlayerName
function getPlayerName(player)
	return getElementType(player) == 'player' and getPlayerName_(player):gsub('_', ' ') or getElementData(player, 'name') or '(ped)'
end
