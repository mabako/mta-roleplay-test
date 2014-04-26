addEventHandler('onResourceStart', resourceRoot,
	function()
		-- delete items too old
		exports.mysql:query_free("DELETE FROM `worlditems` WHERE DATEDIFF(NOW(), created_at) > 14 AND `itemID` != 80 AND `itemID` != 81 AND `itemID` != 103 AND protected = 0" )

		-- actually load items
		local result = exports.mysql:select('worlditems')
		for key, value in ipairs(result) do
			createItem(value)
		end
	end
)
