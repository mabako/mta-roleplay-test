mysql = exports.mysql

local function updateAppCount( )
	local result = mysql:query_fetch_assoc( "SELECT COUNT(*) AS count FROM applications WHERE adminAction = 1" )
	if result then
		exports['anticheat-system']:changeProtectedElementDataEx( getResourceRootElement( ), "openapps", tonumber( result.count ) )
		return tonumber( result.count )
	end
	return -1
end

addEventHandler( "onResourceStart", getResourceRootElement( ),
	function( )
		updateAppCount( )
		setTimer( updateAppCount, 60000, 0 )
	end
)

--

addEvent( "apps:show", true )
addEventHandler( "apps:show", getRootElement( ), 
	function( id )
		if exports.global:isPlayerAdmin( client ) or  exports.global:isPlayerGameMaster( client ) then
			if id and tonumber( id ) then
				local result = mysql:query_fetch_assoc( "SELECT app.`id` AS 'applicationID', acc.id AS 'accountID', acc.`username`, acc.`appstate`, acc.`adminnote`, app.`content`, ( SELECT COUNT(*) FROM adminhistory WHERE user = acc.id ) AS history, (SELECT COUNT(*) FROM `applications` agr WHERE agr.accountID=app.accountID) as 'past'  FROM `applications` app LEFT JOIN `accounts` acc on acc.`id`=app.`accountid` WHERE app.`id` = " .. id )
				if result then
					if tonumber( result.appstate ) == 1 then -- application is open
						for key, value in pairs( result ) do
							if value == mysql_null( ) then
								result[ key ] = ""
							else
								result[ key ] = tonumber( value ) or value
							end
						end
						triggerClientEvent( client, "apps:showsingle", client, result )
						return
					else
						outputChatBox( "The application of " .. result.username .. " has been processed already.", client, 255, 0, 0 )
					end
				end
			end
			
		
			local result = mysql:query( "SELECT app.`id`, acc.`username`, app.`dateposted` - INTERVAL 1 HOUR AS 'daterealposted' FROM `applications` app LEFT JOIN `accounts` acc on acc.`id`=app.`accountid` WHERE app.`adminAction` = 1 ORDER BY app.`dateposted` ASC" )
			if result then
				local table = { }
				while true do
					local row = mysql:fetch_assoc( result )
					if row then
						table[ #table + 1 ] = { tonumber( row.id ), row.username, row.daterealposted }
					else
						break
					end
				end
				if #table == 0 then
					outputChatBox( "There are no new applications.", client, 0, 255, 0 )
				else
					triggerClientEvent( client, "apps:showall", client, table )
				end
				mysql:free_result( result )
			end
		end
	end
)

-- 3 = accepted
-- 2 = denied
-- 1 = pending

addEvent( "apps:update", true )
addEventHandler( "apps:update", getRootElement( ),
	function( account, state, reason )
		if (exports.global:isPlayerAdmin( client ) or exports.global:isPlayerGameMaster( client )) and ( state == 2 or state == 3 ) and tonumber( account.id ) and tonumber(account.appid )then
			mysql:query_free( "UPDATE accounts SET appstate = " .. mysql:escape_string(state) .. ", appreason = '" .. mysql:escape_string( reason ) .. "', appdatetime=NOW() + INTERVAL 3 HOUR WHERE id = " .. mysql:escape_string(account.id) .. " LIMIT 1"  ) -- , appdatetime=NOW() + INTERVAL 1 DAY
			mysql:query_free( "UPDATE `applications` SET `datereviewed`=NOW(), `adminNote`='"..  mysql:escape_string( reason ) .."', adminAction = " .. mysql:escape_string(state) .. ", `adminID` = '".. getElementData( client, "account:id" ) .."' WHERE `id`='"..tostring(account.appid).."'" ) --
			outputChatBox( "You have now " .. ( state == 3 and "accepted " or "denied " ) .. account.name .. "'s application ("..tostring(account.appid)..").", client, 0, 255, 0 )
			if updateAppCount( ) > 0 then
				triggerEvent( "apps:show", client )
			end
		end
	end
)

addEvent( "apps:showhistory", true )
addEventHandler( "apps:showhistory", getRootElement( ),
	function( account )
		if (exports.global:isPlayerAdmin( client ) or exports.global:isPlayerGameMaster( client )) and tonumber(account.id) then
			local targetID = account.id
			local result = mysql:query("SELECT date, action, reason, duration, a.username, user_char FROM adminhistory h LEFT JOIN accounts a ON a.id = h.admin WHERE user = " .. mysql:escape_string(targetID) .. " ORDER BY h.id DESC" )
			if result then
				local info = {}
				local continue = true
				while continue do
					local row = mysql:fetch_assoc(result)
					if not row then break end
					local record = {}
					record[1] = row["date"]
					record[2] = row["action"]
					record[3] = row["reason"]
					record[4] = row["duration"]
					record[5] = row["username"]
					record[6] = row["user_char"]
					
					table.insert( info, record )
				end
				triggerClientEvent( source, "cshowAdminHistory", source, info )
				mysql:free_result( result )
			else
				outputDebugString( "apps-system\apps:showhistory: Error." )
				outputChatBox( "Failed to retrieve history.", source, 255, 0, 0)
			end
		end
	end
)

addEvent( "apps:showappspast", true )
addEventHandler( "apps:showappspast", getRootElement( ), 
	function( id )
		if exports.global:isPlayerAdmin( client ) or  exports.global:isPlayerGameMaster( client ) then
			if id and tonumber( id ) then
				local result = mysql:query_fetch_assoc( "SELECT `id`, `dateposted` as 'date', `content`, `adminAction`, `adminNote`, (select username from accounts where accounts.id=applications.adminID) as 'adminName' FROM applications WHERE `accountID`= " .. id )
				if result then
					local table = { }
					while true do
						local row = mysql:fetch_assoc( result )
						if row then
							table[ #table + 1 ] = { tonumber( row.id ), row.date, row.content, row.adminAction, row.adminNote, row.adminName }
						else
							break
						end
					end
					
					if #table <= 1 then
						outputChatBox( "This player has only one application.", client, 0, 255, 0 )
					else
						triggerClientEvent( client, "apps:showpast", client, table )
					end
				end
			end
		end
	end
)

--[[
addEvent( "apps:show", true )
addEventHandler( "apps:show", getRootElement( ), 
	function( id )
		if exports.global:isPlayerAdmin( client ) or  exports.global:isPlayerGameMaster( source ) then
			
			
			if id and tonumber( id ) then
				local result = mysql:query_fetch_assoc( "SELECT app.`id` AS 'applicationID', acc.id AS 'accountID', acc.`username`, acc.`appstate`, acc.`adminnote`, app.`content`, ( SELECT COUNT(*) FROM adminhistory WHERE user = acc.id ) AS history FROM `applications` app LEFT JOIN `accounts` acc on acc.`id`=app.`accountid` WHERE app.`id` = " .. id )
				if result then
					if tonumber( result.appstate ) == 1 then -- application is open
						for key, value in pairs( result ) do
							if value == mysql_null( ) then
								result[ key ] = ""
							else
								result[ key ] = tonumber( value ) or value
							end
						end
						triggerClientEvent( client, "apps:showsingle", client, result )
						return
					else
						outputChatBox( "The application of " .. result.username .. " has been processed already.", client, 255, 0, 0 )
					end
				end
			end
			
		
			local result = mysql:query( "SELECT app.`id`, acc.`username`, app.`dateposted` - INTERVAL 1 HOUR AS 'daterealposted' FROM `applications` app LEFT JOIN `accounts` acc on acc.`id`=app.`accountid` WHERE app.`adminAction` = 1 ORDER BY app.`dateposted` ASC" )
			if result then
				local table = { }
				while true do
					local row = mysql:fetch_assoc( result )
					if row then
						table[ #table + 1 ] = { tonumber( row.id ), row.username, row.daterealposted }
					else
						break
					end
				end
				if #table == 0 then
					outputChatBox( "There are no new applications.", client, 0, 255, 0 )
				else
					triggerClientEvent( client, "apps:showall", client, table )
				end
				mysql:free_result( result )
			end
		end
	end
)]]

