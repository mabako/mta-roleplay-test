--[[ table is meant to be like
friends[accountID] = {
	name = name,
	message = message,
	lastOnline = timestamp,
	loadedFriends = false,
	player = nil
	[0] = first friend's account id,
	[1] = second friend's account id
]]
local friends = {}

--
-- Returns the current time
--
function now()
	return getRealTime().timestamp
end

--
-- loads data for an account
--
function loadAccountData( accountID )
	local data = exports.mysql:query_fetch_assoc( "SELECT username, UNIX_TIMESTAMP(lastlogin) AS time, friendsmessage, country FROM accounts WHERE id = " .. exports.mysql:escape_string( accountID ) )
	if data then
		friends[ accountID ].name = data.username
		friends[ accountID ].lastOnline = tonumber(data.time)
		friends[ accountID ].message = data.friendsmessage
		friends[ accountID ].country = data.country
		return true
	end
	return false
end

--
-- loads all friends from the database
--
function loadFriends( accountID )
	if not friends[ accountID ] then
		return false, "Invalid data structure"
	end
	
	local result = exports.mysql:query( "SELECT friend FROM friends WHERE id = " .. exports.mysql:escape_string( accountID ) )
	if result then
		-- remove all existing friends
		while #friends[ accountID ] > 0 do
			table.remove( friends[ accountID ], 1 )
		end
		
		-- parse query information
		while true do
			local row = exports.mysql:fetch_assoc(result)
			if not (row) then
				break
			end
			
			table.insert( friends[ accountID ], tonumber( row.friend ) )
		end
		friends[ accountID ].loadedFriends = true
	else
		outputDebugString( "social:loadFriends - bad query " .. tostring( accountID ) .. " " .. type( accountID ) )
	end
	return false, "Query failed"
end

--
-- sends all his friends to the player himself.
--
local maxTime = 14 * 24 * 60 * 60
function sendFriends( player, accountID )
	if not accountID or not friends[ accountID ]then -- that happens.
		outputDebugString( "social:sendFriends - tried to call on non-existent ID " .. tostring( getPlayerName( player )) .. " " .. tostring( accountID ) .. " " .. tostring( friends[ accountID ]))
		return
	end
	
	local t = { }
	
	-- hacky workaround to get the lowest time, ideally making time calculations client-side workey.
	for _, otherAccount in ipairs( friends[ accountID ] ) do
		if not friends[ otherAccount ] then
			friends[ otherAccount ] = { }
		end
		
		if not friends[ otherAccount ].name then
			loadAccountData( otherAccount )
		end
		
		local friend = friends[ otherAccount ]
		if friend.name then
			-- this is a hack for horrible mta precision.
			local timestr = nil
			local la = friend.lastOnline
			if now( ) - la > maxTime then
				timestr = formatTimeInterval( la )
			else
				la = maxTime - now( ) + la
			end
			
			table.insert( t, { otherAccount, friend.name, friend.message, friend.country, friend.player or timestr or la } )
		else
			outputDebugString( "social:sendFriends: Account " .. otherAccount .. " does not exist?" )
			friends[ otherAccount ] = nil
		end
	end
	
	triggerClientEvent( player, "social:friends", player, t, friends[ accountID ].message, friends[ accountID ].country, maxTime )
end

--
-- notifies all friends of his.
--
function notifyFriendsOf( player, accountID, event, ... )
	for _, friend in ipairs( getElementsByType( "player" ) ) do
		local friendID = getElementData( friend, "account:id" )
		if friendID and friends[ friendID ] then
			for k, v in ipairs( friends[ friendID ] ) do
				if v == accountID then
					triggerClientEvent( friend, event, player, accountID, ... )
					break
				end
			end
		end
	end
end

--
-- Logs into an account
--
addEvent("social:account")
addEventHandler("social:account", root,
	function( accountID )
		if not friends[ accountID ] then
			friends[ accountID ] = { }
		end
		
		-- load needed data name/message/lastonline, while maybe weird to load it -here- the same formula applies for all not-loggedin-yet accounts.
		if not friends[ accountID ].name then
			loadAccountData( accountID )
		end
		
		-- make sure a palyer's friends are loaded
		if not friends[ accountID ].loadedFriends then
			loadFriends( accountID )
		end
		
		friends[ accountID ].lastOnline = now( )
		friends[ accountID ].player = source
		
		sendFriends( source, accountID )
		notifyFriendsOf( source, accountID, "social:account" )
	end
)

addEvent("social:character") -- unused, maybe as friends messages? iunno.
--
-- Log everyone who's ingame when starting this in
--
addEventHandler( "onResourceStart", resourceRoot,
	function( )
		for _, player in ipairs( getElementsByType( "player" ) ) do
			local accountID = getElementData( player, "account:id" )
			if accountID then
				friends[ accountID ] = { player = player, lastOnline = now( ) }
				loadAccountData( accountID )
				loadFriends( accountID )
			end
		end
	end
)

addEvent( "social:ready", true )
addEventHandler( "social:ready", root,
	function( )
		local accountID = getElementData( client, "account:id" )
		if accountID then
			sendFriends( client, accountID )
			notifyFriendsOf( client, accountID, "social:account" )
		end
	end
)

--
-- Delete old player references
--
addEventHandler( "onPlayerQuit", root,
	function( )
		local accountID = getElementData( source, "account:id" )
		if accountID and friends[ accountID ] then
			friends[ accountID ].player = nil
			friends[ accountID ].lastOnline = now( )
		end
	end
)

--
-- Updating your own friends message
--
addEvent( "social:message", true )
addEventHandler( "social:message", root,
	function( message )
		local accountID = getElementData( client, "account:id" )
		if accountID and friends[ accountID ] then
			if mysql:query_free("UPDATE accounts SET friendsmessage = '" .. mysql:escape_string(message) .. "' WHERE id = " .. mysql:escape_string(accountID) ) then
				friends[ accountID ].message = message
				notifyFriendsOf( client, accountID, "social:message", message )
				
				triggerClientEvent( client, "social:message", client, accountID, message )
			end
		end
	end
)

--
-- Removing one of your friends
--
addEvent( "social:remove", true )
addEventHandler( "social:remove", root,
	function( otherAccount )
		local accountID = getElementData( client, "account:id" )
		if accountID and friends[ accountID ] and friends[ otherAccount ] then
			local found = false
			for k, v in ipairs( friends[ accountID ] ) do
				if v == otherAccount then
					found = k
				end
			end
			
			if not found then
				outputChatBox( "Not your friend.", client, 255, 0, 0 )
			else
				-- update the database accordingly
				mysql:query_free("DELETE FROM friends WHERE id = " .. mysql:escape_string(accountID) .. " AND friend = " .. mysql:escape_string(otherAccount) )
				mysql:query_free("DELETE FROM friends WHERE id = " .. mysql:escape_string(otherAccount) .. " AND friend = " .. mysql:escape_string(accountID) )
				
				-- remove the entries
				table.remove( friends[ accountID ], k )
				for k, v in ipairs( friends[ otherAccount ] or { } ) do
					if v == accountID then
						table.remove( friends[ otherAccount ], k )
						break
					end
				end
				
				-- let the people know
				triggerClientEvent( client, "social:remove", client, otherAccount )
				outputChatBox( "You removed " .. friends[ otherAccount ].name .. " from your friends list.", client, 0, 255, 0 )
				local other = friends[ otherAccount ].player
				if other then
					triggerClientEvent( other, "social:remove", other, accountID )
				end
			end
		end
	end
)

--
-- adding a player
--
local pendingFriends = { }
function new_addFriend( from, to )
	local fromID = getElementData( from, "account:id" )
	local toID = getElementData( to, "account:id" )
	if not fromID or not toID then
		outputChatBox( "Flying Unicorn Dipshit error. Did you try to login?", from, 255, 0, 0 )
		return
	end
	
	for k, v in ipairs({fromID, toID}) do
		if not friends[ v ] then
			friends[ v ] = { }
			outputDebugString( "Fixed friends list at the point A" .. tostring( v ))
		end
		
		if not friends[ v ].name then
			loadAccountData( v )
			outputDebugString( "Fixed friends list at the point B" .. tostring( v ))
		end
		
		-- make sure a palyer's friends are loaded
		if not friends[ v ].loadedFriends then
			loadFriends( v )
			outputDebugString( "Fixed friends list at the point C" .. tostring( v ))
		end
	end
	
	if fromID and friends[ fromID ] and toID and friends[ toID ] then
		local onFromList = false
		for k, v in ipairs( friends[ fromID ] ) do
			if v == toID then
				onFromList = true
			end
		end
		
		if onFromList then
			outputChatBox( getPlayerName( to ):gsub("_", " ") .. " is on your friends list as " .. friends[ toID ].name .. ".", from, 255, 194, 14 )
		else
			local onToList = false
			for k, v in ipairs( friends[ toID ] ) do
				if v == fromID then
					onToList = true
				end
			end
			
			if onToList then -- the OTHER player has him on his friends list. shouldn't happen, but oh well.
				mysql:query_free("INSERT INTO friends VALUES(" .. mysql:escape_string(fromID) .. ", " .. mysql:escape_string(toID) .. ")" )
				outputChatBox( getPlayerName( to ):gsub("_", " ") .. " has been added to your friends list as " .. friends[ toID ].name .. ".", from, 0, 255, 0 )
				table.insert( friends[ fromID ], toID )
				sendFriends( from, fromID )
			else
				-- need permissiosn first
				triggerClientEvent( to, "askAcceptFriend", from )
				pendingFriends[ to ] = from
			end
		end
	else
		outputChatBox( "Theoretically Impossible Error.", from, 255, 0, 0 )
	end
end

addEvent( "social:acceptFriend", true )
addEventHandler( "social:acceptFriend", root,
	function( )
		local to = client
		local from = pendingFriends[ client ]
		if not from or not to then
			outputChatBox( "You screwed this one up.", client, 255, 0, 0 )
		else
			local fromID = getElementData( from, "account:id" )
			local toID = getElementData( to, "account:id" )
			mysql:query_free("INSERT INTO friends VALUES(" .. mysql:escape_string(toID) .. ", " .. mysql:escape_string(fromID) .. ")" )
			mysql:query_free("INSERT INTO friends VALUES(" .. mysql:escape_string(fromID) .. ", " .. mysql:escape_string(toID) .. ")" )
			table.insert( friends[ fromID ], toID )
			table.insert( friends[ toID ], fromID )
			sendFriends( from, fromID )
			sendFriends( to, toID )
			outputChatBox( getPlayerName( to ):gsub("_", " ") .. " has been added to your friends list as " .. friends[ toID ].name .. ".", from, 0, 255, 0 )
			outputChatBox( getPlayerName( from ):gsub("_", " ") .. " has been added to your friends list as " .. friends[ fromID ].name .. ".", to, 0, 255, 0 )
		end
	end
)

--
-- exported function: isFriendOf
-- returns true if the player with toID has fromID on his friends list
--
function isFriendOf( fromID, toID )
	for k, v in ipairs( friends[ toID ] or {} ) do
		if v == fromID then
			return true
		end
	end
	return false
end
