--[[
	@title
		Advanced Look System
	@author
		Cyanide (well, except for it has been changed altogether)
		mabako
	@copyright
		2012 - Valhalla Gaming
	@description
		http://bugs.mta.vg/view.php?id=559
--]]

function padTable( t, size )
	for i = 1, size do
		if not t[i] then
			t[i] = ""
		end
	end
end
	
addCommandHandler( "look",
	function( thePlayer, commandName, targetPlayer )
		if not targetPlayer then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				triggerEvent( "social:look", targetPlayer, thePlayer )
			end
		end
	end
)

addCommandHandler( "editlook",
	function( player, command )
		triggerEvent( "social:look", player, player, ":edit" )
	end
)

addEvent( "social:look", true )
addEventHandler( "social:look", root,
	function( targetPlayer, event )
		local targetPlayer = client or targetPlayer

		if getElementData( source, "loggedin" ) ~= 1 or getElementData( targetPlayer, "loggedin" ) ~= 1 then
			return
		end
		

		event = "social:look" .. ( event or "" )
		
		local look = getElementData( source, "look" )
		padTable( look, 6 )
		
		look[7] = {}
		-- add all badge info
		for itemID, badge in pairs( exports['item-system']:getBadges() ) do
			if getElementData( source, badge[1] ) then
				table.insert( look[7], badge[2]:sub( badge[2]:find( " " ) + 1 ) .. " reading " .. getElementData( source, badge[1] ) )
			end
		end
		
		-- add all mask info
		for itemID, mask in pairs( exports['item-system']:getMasks() ) do
			if getElementData( source, mask[1] ) then
				table.insert( look[7], mask[1]:sub(1,1):upper() .. mask[1]:sub(2) )
			end
		end
		
		if exports.global:hasItem( source, 48 ) then
			table.insert( look[7], "Backpack" )
		end
		
		triggerClientEvent( targetPlayer, event, source, getElementData( source, "age" ), getElementData( source, "race" ), getElementData( source, "gender" ), getElementData( source, "weight" ), getElementData( source, "height" ), look )
	end
)


addEvent( "social:look:update", true )
addEventHandler( "social:look:update", root,
	function( key, value )
		if getElementData( client, "loggedin" ) ~= 1 then
			return
		end
		
		local valid, stuff = false
		for k, v in ipairs( editables ) do
			if v.index == key then
				valid = v.verify( value )
				stuff = v
				break
			end
		end
		
		if not valid then
			outputChatBox( "Error LOOK-" .. tostring(key) .. "-" .. tostring(value) .. ".", client, 255, 0, 0 )
		else
			if key == "weight" then
				if exports.mysql:query_free("UPDATE characters SET " .. exports.mysql:escape_string( key ) .. " = '" .. exports.mysql:escape_string( value ) .. "' WHERE id = " .. exports.mysql:escape_string( getElementData( client, "dbid" ) ) ) then
					outputChatBox( "Set your " .. stuff.name .. " to " .. value .. ".", client, 0, 255, 0 )
					exports['anticheat-system']:changeProtectedElementDataEx( client, key, value, false)
				else
					outputChatBox( "Failed to update " .. stuff.name .. ".", client, 255, 0, 0 )
				end
			else
				local look = getElementData( client, "look" )
				look[ key ] = value
				padTable( look, 6 )
				
				if exports.mysql:query_free("UPDATE characters SET description = '" .. exports.mysql:escape_string( toJSON( look ) ) .. "' WHERE id = " .. exports.mysql:escape_string( getElementData( client, "dbid" ) ) ) then
					outputChatBox( "Set your " .. stuff.name .. " to " .. value, client, 0, 255, 0 )
					exports['anticheat-system']:changeProtectedElementDataEx( client, "look", look, false)
				else
					outputChatBox( "Failed to update " .. stuff.name .. ".", client, 255, 0, 0 )
				end
			end
		end
	end
)
