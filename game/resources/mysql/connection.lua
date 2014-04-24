local username = get( "username" ) or "mta"
local password = get( "password" ) or ""
local database = get( "database" ) or "mta"
local hostname = get( "hostname" ) or "localhost"
local port = tonumber( get( "port" ) ) or 3306

-- global things.
local MySQLConnection = nil
local resultPool = { }
local queryPool = { }
local resources = { }
local sqllog = false
local countqueries = 0

-- connectToDatabase - Internal function, to spawn a DB connection
function connectToDatabase(res)
	MySQLConnection = mysql_connect(hostname, username, password, database, port)
	
	if (not MySQLConnection) then
		if (res == getThisResource()) then
			cancelEvent(true, "Cannot connect to the database.")
		end
		return nil
	end
	
	return nil
end
addEventHandler("onResourceStart", resourceRoot, connectToDatabase, false)
	
-- destroyDatabaseConnection - Internal function, kill the connection if theres one.
function destroyDatabaseConnection()
	if (not MySQLConnection) then
		return nil
	end
	mysql_close(MySQLConnection)
	return nil
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), destroyDatabaseConnection, false)

-- do something usefull here
function logSQLError(str)
	local message = str or 'N/A'
	outputDebugString("MYSQL ERROR "..mysql_errno(MySQLConnection) .. ": " .. mysql_error(MySQLConnection))
end

function getFreeResultPoolID()
	local size = #resultPool
	if (size == 0) then
		return 1 
	end
	for index, query in ipairs(resultPool) do
		if (query == nil) then
			return index
		end
	end
	return (size + 1)
end

------------ EXPORTED FUNCTIONS ---------------

function ping()
	if (mysql_ping(MySQLConnection) == false) then
		-- FUU, NO MOAR CONNECTION
		destroyDatabaseConnection()
		connectToDatabase(nil)
		if (mysql_ping(MySQLConnection) == false) then
			logSQLError()
			return false
		end
		return true
	end

	return true
end

function escape_string(str)
	if (ping()) then
		return mysql_escape_string(MySQLConnection, str)
	end
	return false
end

function query(str, ...)
	countqueries = countqueries + 1
	
	if ( ... ) then
		local t = { ... }
		for k, v in ipairs( t ) do
			t[ k ] = escape_string( tostring( v ) ) or ""
		end
		str = str:format( unpack( t ) )
	end
	
	if (ping()) then
		local result = mysql_query(MySQLConnection, str)
		if (not result) then
			logSQLError(str)
			return false
		end

		local resultid = getFreeResultPoolID()
		resultPool[resultid] = result
		queryPool[resultid] = str
		resources[resultid] = getResourceName( sourceResource )
		return resultid
	end
	return false
end

function unbuffered_query(str)
	countqueries = countqueries + 1
	
	if (ping()) then
		local result = mysql_unbuffered_query(MySQLConnection, str)
		if (not result) then
			logSQLError(str)
			return false
		end

		local resultid = getFreeResultPoolID()
		resultPool[resultid] = result
		queryPool[resultid] = str
		resources[resultid] = getResourceName( sourceResource )
		return resultid
	end
	return false
end

function query_free(str, ...)
	if ( ... ) then
		local t = { ... }
		for k, v in ipairs( t ) do
			t[ k ] = escape_string( tostring( v ) ) or ""
		end
		str = str:format( unpack( t ) )
	end

	local queryresult = query(str)
	if  not (queryresult == false) then
		free_result(queryresult)
		return true
	end
	return false
end

function rows_assoc(resultid)
	if (not resultPool[resultid]) then
		return false
	end
	return mysql_rows_assoc(resultPool[resultid])
end

function fetch_row(resultid)
	if (not resultPool[resultid]) then
		return false
	end
	return mysql_fetch_row(resultPool[resultid])
end


function fetch_assoc(resultid)
	if (not resultPool[resultid]) then
		return false
	end
	local q = mysql_fetch_assoc(resultPool[resultid])
	if q then 
		for i, k in pairs( q ) do
			if q[i] == mysql_null() then
				q[i] = nil
			else
				q[ i ] = tonumber( q[ i ] ) or q[ i ]
			end
		end
	end
	return q
end

function free_result(resultid)
	if (not resultPool[resultid]) then
		return false
	end
	mysql_free_result(resultPool[resultid])
	table.remove(resultPool, resultid)
	table.remove(queryPool, resultid)
	table.remove(resources, resultid)
	return nil
end

-- incase a nub wants to use it, FINE
function result(resultid, row_offset, field_offset)
	if (not resultPool[resultid]) then
		return false
	end
	return mysql_result(resultPool[resultid], row_offset, field_offset)
end

function num_rows(resultid)
	if (not resultPool[resultid]) then
		return false
	end
	return mysql_num_rows(resultPool[resultid])
	
end

function insert_id()
	return mysql_insert_id(MySQLConnection) or false
end

function query_fetch_assoc(str)
	local queryresult = query(str)
	if  not (queryresult == false) then
		local result = fetch_assoc(queryresult)
		free_result(queryresult)
		return result
	end
	return false
end

function query_fetch_row(str)
	local queryresult = query(str)
	if  not (queryresult == false) then
		local result = fetch_row(queryresult)
		free_result(queryresult)
		return result
	end
	return false
end

function query_rows_assoc(str)
	local queryresult = query(str)
	if  not (queryresult == false) then
		local result = rows_assoc(queryresult)
		free_result(queryresult)
		return result
	end
	return false
end

function query_insert_free(str)
	local queryresult = query(str)
	if  not (queryresult == false) then
		local result = insert_id()
		free_result(queryresult)
		return result
	end
	return false
end

function escape_string(str)
	return mysql_escape_string(MySQLConnection, str)
end

function debugMode()
	if (sqllog) then
		sqllog = false
	else
		sqllog = true
	end
	return sqllog
end

function returnQueryStats()
	return countqueries
	-- maybe later more
end

function getOpenQueryStr( resultid )
	if (not queryPool[resultid]) then
		return false
	end
	
	return queryPool[resultid]
end

--Custom functions
local function alt_escape_string( string, key )
	if string == 'NOW()' and (key == 'created_at') then
		return string
	else
		return escape_string( string )
	end
end

local function createWhereClause( array, required )
	if not array then
		-- will cause an error if it's required and we wanna concat it.
		return not required and '' or nil
	end
	local strings = { }
	for i, k in pairs( array ) do
		table.insert( strings, "`" .. i .. "` = '" .. ( tonumber( k ) or alt_escape_string( k, i ) ) .. "'" )
	end
	return ' WHERE ' .. table.concat(strings, ' AND ')
end

function select( tableName, clause )
	local array = {}
	local result = query( "SELECT * FROM " .. tableName .. createWhereClause( clause ) )
	if result then
		while true do
			local a = fetch_assoc( result )
			if not a then break end
			table.insert(array, a)
		end
		free_result( result )
		return array
	end
	return false
end

function select_one( tableName, clause )
	local a
	local result = query( "SELECT * FROM " .. tableName .. createWhereClause( clause ) .. ' LIMIT 1' )
	if result then
		a = fetch_assoc( result )
		free_result( result )
		return a
	end
	return false
end

function insert( tableName, array )
	local keyNames = { }
	local values = { }
	for i, k in pairs( array ) do
		table.insert( keyNames, i )
		table.insert( values, tonumber( k ) or alt_escape_string( k, i ) )
	end
	
	local q = "INSERT INTO `"..tableName.."` (`" .. table.concat( keyNames, "`, `" ) .. "`) VALUES ('" .. table.concat( values, "', '" ) .. "')"
	
	return query_insert_free( q )
end

function update( tableName, array, clause )
	local strings = { }
	for i, k in pairs( array ) do
		table.insert( strings, "`" .. i .. "` = " .. ( k == mysql_null() and "NULL" or ( "'" .. ( tonumber( k ) or alt_escape_string( k, i ) ) .. "'" ) ) )
	end
	local q = "UPDATE `" .. tableName .. "` SET " .. table.concat( strings, ", " ) .. createWhereClause( clause, true )
	
	return query_free( q )
end

function delete( tableName, clause )
	return query_free( "DELETE FROM " .. tableName .. createWhereClause( clause, true ) )
end

-- Let's just pretend we have leaking connections... which we do, in all likeliness.
-- Hooray!

addCommandHandler( 'leaky',
	function( )
		local count = 0
		local res = {}
		local pretty = {}
		for k, v in pairs( resources ) do
			if not res[v] then
				res[v] = {}
			end
			table.insert(res[v], queryPool[k])
			count = count + 1
		end

		if count == 0 then
			outputDebugString('Not leaking anything.')
			return
		end

		outputDebugString('Only leaking a mere ' .. count .. ' result handles.')

		for k, v in pairs( res ) do
			outputDebugString(k .. ': ' .. #v .. "\n\t" .. table.concat(v, "\n\t"))
		end
	end
)
