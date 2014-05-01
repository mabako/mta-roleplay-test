-- keep track of all clothing items, used in shops afterwards
savedClothing = {}

addEventHandler('onResourceStart', resourceRoot,
	function()
		local result = exports.mysql:query("SELECT * FROM clothing")
		if result then
			while true do
				row = exports.mysql:fetch_assoc(result)
				if not row then break end

				savedClothing[row.id] = row
			end
		end
		exports.mysql:free_result(result)
	end)

--
local function getPath(clothing)
	return 'cache/' .. tostring(clothing) .. '.tex'
end

-- loads a skin from an url
function loadFromURL(url, id)
	fetchRemote(url, function(str, errno)
			if str == 'ERROR' then
				-- outputDebugString('clothing:stream - unable to fetch ' .. url)
			else
				local file = fileCreate(getPath(id))
				fileWrite(file, str)
				fileClose(file)

				local data = savedClothing[id]
				if data and data.pending then
					triggerLatentClientEvent(data.pending, 'clothing:file', resourceRoot, id, str, #str)
					data.pending = nil
				end
			end
		end)
end


-- send clothing to the client
addEvent( 'clothing:stream', true )
addEventHandler( 'clothing:stream', resourceRoot,
	function(id)
		local id = tonumber(id)
		-- if its not a number, this'll fail
		if type(id) == 'number' then
			local data = savedClothing[id]
			if data then
				local path = getPath(id)
				if fileExists(path) then
					local file = fileOpen(path, true)
					if file then
						local size = fileGetSize(file)
						local content = fileRead(file, size)

						if #content == size then
							triggerLatentClientEvent(client, 'clothing:file', resourceRoot, id, content, size)
						else
							outputDebugString('clothing:stream - file ' .. path .. ' read ' .. #content .. ' bytes, but is ' .. size .. ' bytes long')
						end
						fileClose(file)
					else
						outputDebugString('clothing:stream - file ' .. path .. ' existed but could not be opened?')
					end
				else
					-- try to reload the file from the given url
					if data.pending then
						table.insert(data.pending, client)
					else
						data.pending = { client }
						loadFromURL(data.url, id)
					end
				end
			else
				outputDebugString('clothing:stream - clothes #' .. id .. ' do not exist.')
			end
		end
	end, false)
