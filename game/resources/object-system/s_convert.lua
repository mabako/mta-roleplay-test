--[[ Used to convert the map to the real table ]]--
function moveTempToRealDimension(dimension, thePlayer)
	if dimension then
	
		mysql:query_free("DELETE FROM `objects` WHERE dimension='".. tostring(dimension) .."'")
	
		local result = mysql:query_free("INSERT INTO `objects` (`model`, `posX`, `posY`, `posZ`, `rotX`, `rotY`, `rotZ`, `interior`, `dimension`, `comment`, `solid`, `doublesided`) SELECT `model`, `posX`, `posY`, `posZ`, `rotX`, `rotY`, `rotZ`, `interior`, `dimension`, `comment`, `solid`, `doublesided` FROM `tempobjects` WHERE `dimension` =" .. tostring(dimension))
		if (result) then
			local result2 = mysql:query_free("DELETE FROM `tempobjects` WHERE `dimension` = " .. tostring(dimension))
			if (result2) then
				local result3 = mysql:query_fetch_assoc("SELECT * FROM `tempinteriors` WHERE `id`='".. tostring(dimension) .."'")
				if (result3) then
					local result4 = mysql:query_free("UPDATE `interiors` SET `interiorx`='".. result3["posX"] .."', `interiory`='".. result3["posY"] .."', `interiorz`='".. result3["posZ"] .."', `interior`='".. result3["interior"] .."' WHERE `id`='".. tostring(dimension) .."'")	
					local result5 = mysql:query_free("DELETE FROM `tempinteriors` WHERE `id` = " .. tostring(dimension))
					if (result4) and (result5) then
						exports['interior-system']:reloadInterior(thePlayer, "reloadinterior", tostring(dimension))
						loadDimension(dimension)
						return true
					end
				end
			end
		end
	end
	return false
end

--[[ Command to delete the interior ]]--
function deleteInterior(thePlayer, commandName, dimensionID)
	if exports.global:isPlayerLeadAdmin(thePlayer) or exports.donators:hasPlayerPerk(thePlayer, 13) then
		if dimensionID and  tonumber(dimensionID) then
			loadDimension(tonumber(dimensionID))
			exports['interior-system']:reloadInterior(thePlayer, "reloadinterior", dimensionID)
			local result1 = mysql:query_free("DELETE FROM `tempobjects` WHERE `dimension` = " .. tostring(dimensionID))
			local result2 = mysql:query_free("DELETE FROM `tempinteriors` WHERE `id` = " .. tostring(dimensionID))
			if result1 and result2 then
				outputChatBox( "Done, temporary interior deleted.", thePlayer, 0, 255, 0 )
			end
		end
	end
end
addCommandHandler("deltestinterior", deleteInterior, false, false)

--[[ Command to save the interior ]]--
function saveInterior(thePlayer, commandName, dimensionID)
	if exports.global:isPlayerLeadAdmin(thePlayer) or exports.donators:hasPlayerPerk(thePlayer, 13) then
		if dimensionID and  tonumber(dimensionID) then
			local result = moveTempToRealDimension(tonumber(dimensionID), thePlayer)
			if result then
				outputChatBox( "Done, interior saved if there were any objects.", thePlayer, 0, 255, 0 )
			else
				outputChatBox( "Something went wrong.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler("savetestinterior", saveInterior, false, false)

--[[ Test the uploaded interior ]]
function testInterior(thePlayer, commandName, dimensionID)
	if exports.global:isPlayerLeadAdmin(thePlayer) or exports.donators:hasPlayerPerk(thePlayer,13) then
		if dimensionID and  tonumber(dimensionID) then
			triggerClientEvent("object:clear", getRootElement(), dimensionID)
			local count = loadDimension(tonumber(dimensionID), true)
			if (count > 0) then
				outputChatBox( "Loaded " .. count .. " items in interior ".. dimensionID, thePlayer, 0, 255, 0 )
				local result = mysql:query_fetch_assoc("SELECT * FROM `tempinteriors` WHERE `id`='".. mysql:escape_string(dimensionID).."'")
				if (result) then
					transferDimension(thePlayer, tonumber(dimensionID))
					setElementPosition(thePlayer, tonumber(result["posX"]), tonumber(result["posY"]), tonumber(result["posZ"]))
					setElementInterior(thePlayer, tonumber(result["interior"]))
					setElementDimension(thePlayer, tonumber(result["id"]))
					outputChatBox( "Teleported to the marker.", thePlayer, 0, 255, 0 )
				end
			else
				outputChatBox( "No temporary objects found for interior ".. dimensionID, thePlayer, 0, 255, 0 )
			end
		end
	end
end
addCommandHandler("testinterior", testInterior, false, false)

--[[ Show the uploaded interiors ]]
function toCheckInterior(thePlayer, commandName, dimensionID)
	if exports.global:isPlayerLeadAdmin(thePlayer) or exports.donators:hasPlayerPerk(thePlayer, 13) then
		local result = mysql:query("SELECT distinct(`dimension`) FROM `tempobjects` ORDER BY `dimension` ASC")
		if (result) then
			while true do
				row = mysql:fetch_assoc(result)
				if not row then break end

				outputChatBox("> Interior ".. row.dimension, thePlayer)
			end
		end
		mysql:free_result(result)
		outputChatBox("> Done", thePlayer)
	end
end
addCommandHandler("checkinteriors", toCheckInterior, false, false)