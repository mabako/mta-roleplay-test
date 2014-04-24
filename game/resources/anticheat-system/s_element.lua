local secretHandle = ''

function allowElementData(thePlayer, index)
	setElementData(thePlayer, secretHandle.."p:"..index, false, false)
end

function protectElementData(thePlayer, index)
	setElementData(thePlayer, secretHandle.."p:"..index, true, false)
end

function changeProtectedElementData(thePlayer, index, newvalue)
	allowElementData(thePlayer, index)
	setElementData(thePlayer, index, newvalue)
	protectElementData(thePlayer, index)
end

function changeProtectedElementDataEx(thePlayer, index, newvalue, sync, nosyncatall)
	if (thePlayer) and (index) then
		if not newvalue then
			newvalue = nil
		end
		if not nosyncatall then
			nosyncatall = false
		end
	
		allowElementData(thePlayer, index)
		if not setElementData(thePlayer, index, newvalue, sync) then
		--	if not thePlayer or not isElement(thePlayer) then
		--	outputDebugString("changeProtectedElementDataEx")
		-- --	outputDebugString(tostring(thePlayer))
		--  outputDebugString("index: "..index)
		--	outputDebugString("newvalue: "..tostring(newvalue))
		--	outputDebugString("sync: "..tostring(sync))
		--	end
		end
		if not sync then
			if not nosyncatall then
				if getElementType ( thePlayer ) == "player" then
					triggerClientEvent(thePlayer, "edu", getRootElement(), thePlayer, index, newvalue)
				end
			end
		end
		protectElementData(thePlayer, index)
		return true
	end
	return false
end

function fetchH()
	return secretHandle
end
