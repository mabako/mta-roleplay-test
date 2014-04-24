local mysql = exports.mysql

addEventHandler("accounts:login:request", getRootElement(), 
	function ()
		local seamless = getElementData(client, "account:seamless:validated")
		if seamless == true then
			
			outputChatBox("-- Migrated your session after a system restart", client, 0, 200, 0)
			setElementData(client, "account:seamless:validated", false, false, true)
			triggerClientEvent(client, "accounts:options", client)
			triggerClientEvent(client, "item:updateclient", client)
			return
		end
		triggerClientEvent(client, "accounts:login:request", client)
	end
);

local function generateNewHash()
	local finalhash = ""
	local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	for i = 1, 64 do
		local rand = math.random(#chars)
		finalhash = finalhash .. chars:sub(rand, rand)
	end
	return finalhash
end

local function tryLogin(client, username, password, autologinHash, generateHashForAutoLogin)
	-- verify the login data sent, at least
	local account = exports.mysql:select_one('accounts', { username = username })
	if account then
		-- verify either the password or the login hash
		if password then
			if not bcrypt_verify(password, account.encrypted_password) then
				return false, 'Could not log you in. Please verify your username and password.'
			end
		else
			if account.mtaserial ~= getPlayerSerial( client ) then
				return false, 'This token is not valid on your current computer. Please log in again.'
			elseif account.loginhash == '' or #autologinHash ~= 64 then
				return false, 'Invalid saved token. Please log in again.'
			elseif account.loginhash ~= autologinHash then
				return false, 'Your saved token expired. Please log in again.'
			end
		end

		-- banned? bad.
		if account.banned == 1 then
			-- TODO notify admins of this?
			return false, "Account is banned."
		end

		-- noone cares about application

		-- can't login if another player is already logged in.
		for _, player in ipairs(getElementsByType('player')) do
			if getElementData(player, 'account:id') == account.id then
				return false, 'Another player is already logged in as ' .. account.username .. '.'
			end
		end

		-- set all respective account data
		local hash = generateNewHash()
		setElementDataEx(client, "account:seamlesshash", hash, false, true)

		setElementDataEx(client, 'account:loggedin', true, true)
		setElementDataEx(client, 'account:id', account.id, true)
		setElementDataEx(client, 'account:username', account.username, false)

		-- all things admin-y and gm-y, though simplified for not having GMs atm.
		setElementDataEx(client, 'adminreports', account.adminreports, false)
		setElementDataEx(client, 'hiddenadmin', account.hiddenadmin, false)
		setElementDataEx(client, 'adminlevel', account.admin, false)
		setElementDataEx(client, 'account:gmlevel', 0, false)
		setElementDataEx(client, 'adminduty', account.adminduty, false)
		setElementDataEx(client, 'account:gmduty', false, false)

		-- admin jail. oh what a nice place to be.
		-- todo make this a table really
		-- todo have this while not on a character
		local jailed = account.adminjail == 1
		setElementDataEx(client, 'adminjailed', jailed, false)
		if jailed then
			setElementDataEx(client, 'jailtime', account.adminjail_time, false)
			setElementDataEx(client, 'jailadmin', account.adminjail_by, false)
			setElementDataEx(client, 'jailreason', account.adminjail_reason, false)
		end

		if account.monitored and account.monitored ~= '' then
			setElementDataEx(client, 'admin:monitor', account.monitored, false)
		end

		-- options to be sent to the client
		local options = { characters = characterList( client ) }
		if autologinHash or generateHashForAutoLogin then
			options.hash = exports.global:customBase64Encode(toJSON({ username = account.username, hash = hash } ))
		else
			hash = ''
		end

		local ip = getPlayerIP( client )
		exports.mysql:update('accounts', { loginhash = hash, mtaserial = getPlayerSerial( client ), ip = ip, country = exports.global:getPlayerCountryByIP( ip ) }, { id = account.id })

		-- update friends list
		triggerEvent('social:account', client, account.id)

		-- todo logging
		return true, options
	else
		return false, 'Could not log you in. Please verify your username and password.'
	end


--[[
		exports.logs:dbLog("ac"..tostring(accountData["id"]), 27, "ac"..tostring(accountData["id"]), "Connected from "..getPlayerIP(client) .. " - "..getPlayerSerial(client) .. " (".. loginmethodstr ..")" )
		mysql:query_free("UPDATE `accounts` SET `ip`='" .. mysql:escape_string(getPlayerIP(client)) .. "', `mtaserial`='" .. mysql:escape_string(getPlayerSerial(client)) .. "' WHERE `id`='".. mysql:escape_string(tostring(accountData["id"])) .."'")	
		triggerEvent( "social:account", client, tonumber( accountData.id ) )
]]
end

addEvent('accounts:login', true)
addEventHandler('accounts:login', resourceRoot, 
	function(username, password, generateHashForAutoLogin)
		local result = { tryLogin(client, tostring(username), tostring(password), nil, generateHashForAutoLogin) }
		triggerClientEvent(client, 'accounts:login:result', resourceRoot, unpack( result ) )
	end, false
)

addEvent('accounts:login:with-hash', true)
addEventHandler('accounts:login:with-hash', resourceRoot,
	function(hash)
		local t = exports.global:customBase64Decode(hash)
		if t then
			t = fromJSON(t)
			if type(t) == 'table' and t.username and t.hash then
				local result = { tryLogin(client, tostring(t.username), nil, tostring(t.hash), true) }
				triggerClientEvent(client, 'accounts:login:result', resourceRoot, unpack( result ) )
			end
		end
	end, false
)

--[[
-- TODO logging
function quitPlayer(quitReason, reason)
	local accountID = tonumber(getElementData(source, "account:id"))
	if accountID then
		local affected = { "ac"..tostring(accountID) } 
		local dbID = getElementData(source,"dbid")
		if dbID then
			table.insert(affected, "ch"..tostring(dbID))
		end
		exports.logs:dbLog("ac"..tostring(accountID), 27, affected, "Disconnected ("..quitReason or "Unknown reason"..") (Name: "..getPlayerName(source)..")" )
	end
end
addEventHandler("onPlayerQuit",getRootElement(), quitPlayer)
]]