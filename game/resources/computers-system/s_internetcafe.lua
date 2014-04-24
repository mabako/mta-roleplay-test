function startObjectSystem()
	local result = mysql:query("SELECT * FROM `computers` ORDER BY `id` ASC")
	if (result) then
		while true do
			local row = mysql:fetch_assoc(result)
			if not row then	break end
			
			for key, value in pairs( row ) do
				row[key] = tonumber(value)
			end
			
			local temporaryObject = createObject(row.model,row.posX,row.posY,row.posZ,row.rotX,row.rotY,row.rotZ)
			setElementDimension(temporaryObject, row.dimension)
			setElementInterior(temporaryObject, row.interior)		
			exports['anticheat-system']:changeProtectedElementDataEx( temporaryObject, "computer:clickable", true, true )
		end
		mysql:free_result(result)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), startObjectSystem)

addEvent("computers:on", true)
addEventHandler("computers:on", root,
	function()
		exports.global:sendLocalMeAction(client, "turns the computer on.")
	end
)