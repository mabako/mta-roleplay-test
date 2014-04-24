addCommandHandler( "adminstats",
	function( player )
		if exports.global:isPlayerLeadAdmin(player) then
			local result = mysql:query( "SELECT username, admin, lastlogin, adminreports FROM accounts WHERE admin != 0 AND admin < 10 ORDER BY admin DESC, username ASC" )
			if result then
				local t = { }
				while true do
					local row = mysql:fetch_assoc( result )
					if row then
						table.insert(t, { row.username, tonumber(row.admin), row.adminreports, row.lastlogin })
					else
						break
					end
				end
				mysql:free_result( result )
				triggerClientEvent( player, "admin:stats", player, t )
			end
		end
	end
)
