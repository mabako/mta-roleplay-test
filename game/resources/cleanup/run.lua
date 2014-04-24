function doCleanUp(thePlayer)
	if not exports.global:isPlayerHeadAdmin(thePlayer) then return end
	local mysql = exports.mysql
	
	-- Inactive houses - 1 month
	--[[local mQuery1 = mysql:query("select interiors.id from interiors left join characters on characters.`id` = interiors.`owner` where (characters.lastlogin < ( NOW() - interval 30 day) or characters.cked != 0) and interiors.cost != 0 and interiors.cost < 300000")
	]]
	local count1 = 0
	--[[if (mQuery1) then
		while true do
			local row = mysql:fetch_assoc(mQuery1)
			if not row then break end
			
			local interiorID = tonumber(row["id"])
			exports['interior-system']:publicSellProperty(thePlayer, interiorID, true, true)
			exports['interior-system']:cleanupProperty(interiorID)
			outputDebugString("Deleting ID "..interiorID)
			count1 = count1 + 1
		end
	end
	mysql:free_result(mQuery1)]]
	
	-- Impounded vehicles - 2 weeks
	local mQuery2 = mysql:query("select vehicles.id from vehicles where vehicles.Impounded != 0 and vehicles.Impounded < (".. getRealTime().yearday .."- 13)")
	local count2 = 0
	if (mQuery2) then
		while true do
			local row = mysql:fetch_assoc(mQuery2)
			if not row then break end
			
			local vehicleID = tonumber(row["id"])
			mysql:query_free("DELETE FROM `vehicles` WHERE `id`='".. vehicleID .."'") -- Delete the vehicle
			mysql:query_free("DELETE FROM `items` WHERE `type`='2' AND `owner`='".. vehicleID .."'") -- Delete its contents
			exports['item-system']:deleteAll( 3, vehicleID ) -- Delete all the vehicle keys
			
			exports['vehicle-system']:reloadVehicle(vehicleID)
			count2 = count2 + 1
		end
	end
	mysql:free_result(mQuery2)
	
	-- Inactive vehicles - 1 month
	local mQuery3 = mysql:query("select vehicles.id from vehicles left join characters on characters.`id` = vehicles.`owner` where (characters.lastlogin < ( NOW() - interval 45 day) or characters.cked != 0)")
	local count3 = 0
	if (mQuery3) then
		while true do
			local row = mysql:fetch_assoc(mQuery3)
			if not row then break end
			
			local vehicleID = tonumber(row["id"])
			mysql:query_free("DELETE FROM `vehicles` WHERE `id`='".. vehicleID .."'") -- Delete the vehicle
			mysql:query_free("DELETE FROM `items` WHERE `type`='2' AND `owner`='".. vehicleID .."'") -- Delete its contents
			exports['item-system']:deleteAll( 3, vehicleID ) -- Delete all the vehicle keys
			
			exports['vehicle-system']:reloadVehicle(vehicleID)
			count3 = count3 + 1
		end
	end
	mysql:free_result(mQuery3)

	-- Show some stats
	outputChatBox("/sellpropertied "..count1.." interiors", thePlayer)
	outputChatBox("Deleted "..count2.." impounded vehicles", thePlayer)		
	outputChatBox("Deleted "..count3.." inactive vehicles", thePlayer)		
end
addCommandHandler("startcleanup", doCleanUp)


function doItemCleanUp(thePlayer)
	if not exports.global:isPlayerHeadAdmin(thePlayer) then return end
	local mysql = exports.mysql
	
	-- Selecting unowned interiors with items in the safe
	local mQuery1 = mysql:query("select items.index from items left join interiors on items.owner=interiors.id where items.type=4 and items.owner < 20000 and (interiors.owner=-1 or interiors.owner=null) order by items.owner desc")
	local count1 = 0
	if (mQuery1) then
		while true do
			local row = mysql:fetch_assoc(mQuery1)
			if not row then break end
			mysql:query_free("DELETE FROM `items` WHERE `index`='".. row["index"] .."'")
			count1 = count1 + 1
		end
	end
	mysql:free_result(mQuery1)
	
	-- find items in safes from interiors that dont exist anymore
	local mQuery2 = mysql:query("select items.index from items where not exists (select id from interiors where interiors.id=items.owner) and items.owner > 0 and items.type=4 and items.owner < 20000")
	local count2 = 0
	if (mQuery2) then
		while true do
			local row = mysql:fetch_assoc(mQuery2)
			if not row then break end
			mysql:query_free("DELETE FROM `items` WHERE `index`='".. row["index"] .."'")

			count2 = count2 + 1
		end
	end
	mysql:free_result(mQuery2)
	
	-- find items in non-existing vehicles
	local mQuery3 = mysql:query("select items.index,items.owner from items where not exists (select id from vehicles where vehicles.id=items.owner) and items.owner > 0 and items.type=2 and items.owner < 20000")
	local count3 = 0
	if (mQuery3) then
		while true do
			local row = mysql:fetch_assoc(mQuery3)
			if not row then break end
			mysql:query_free("DELETE FROM `items` WHERE `index`='".. row["index"] .."'")

			count3 = count3 + 1
		end
	end
	mysql:free_result(mQuery3)

	-- Show some stats
	outputChatBox("Removed "..count1.." safe items from unowned properties", thePlayer)
	outputChatBox("Removed "..count2.." safe items from non existant interiors", thePlayer)			
	outputChatBox("Removed "..count3.." items from non existant vehicles", thePlayer)			

end
addCommandHandler("startitemcleanup", doItemCleanUp)