local loaded = { --[[ [clothing] = {tex = texture, shader = shader} ]] }
local streaming = { --[[ [clothing] = {players} ]] }

local players = {}

-- skins with 2+ texture names:	12, 19, 21, 28, 30, 40, 46, 47, 55, 91, 93, 98, 100, 107, 110, 115, 116, 141, 156, 174, 223, 233, 249
local accessoires = { watchcro = true, neckcross = true, earing = true, glasses = true, specsm = true }
local function getPrimaryTextureName(model)
	for k, v in ipairs(engineGetModelTextureNames(model)) do
		if not accessoires[v] then
			return v
		end
	end
end

addCommandHandler('getclothingtexture',
	function(command, model)
		local model = tonumber(model) or getElementModel(localPlayer)
		outputChatBox('Model ' .. model .. ' has ' .. (getPrimaryTextureName(model) or 'N/A') .. ' as primary texture.', 255, 127, 0)
	end)

-- returns the file path for a texture file
local function getPath(clothing)
	return '@cache/' .. tostring(clothing) .. '.tex'
end

-- adds clothing to a player, possibly streaming it from the server if needed
function addClothing(player, clothing)
	removeClothing(player)

	local texName = getPrimaryTextureName(getElementModel(player))

	-- does the shader for the relevant skin already exist?
	local L = loaded[clothing]
	if L then
		players[player] = { id = clothing, texName = texName }

		engineApplyShaderToWorldTexture(L.shader, texName, player)
	else
		-- shader not yet created, do we have the file available locally?
		local path = getPath(clothing)
		if fileExists(path) then
			-- file available locally, just need to really create it
			local texture = dxCreateTexture(path)
			if texture then
				local shader, t = dxCreateShader('tex.fx', 0, 0, true, 'ped')
				if shader then
					dxSetShaderValue(shader, 'tex', texture)

					local texName = getPrimaryTextureName(getElementModel(player))
					engineApplyShaderToWorldTexture(shader, texName, player)

					loaded[clothing] = { texture = texture, shader = shader }
					players[player] = { id = clothing, texName = texName }
				else
					outputDebugString('creating shader for player ' .. getPlayerName(player) .. ' failed.', 2)
					destroyElement(texture)
				end
			else
				outputDebugString('creating texture for player ' .. getPlayerName(player) .. ' failed', 2)
			end
		else
			-- clothing not yet downloaded
			if streaming[clothing] then
				table.insert(streaming[clothing], player)
			else
				streaming[clothing] = { player }
				triggerServerEvent('clothing:stream', resourceRoot, clothing)
			end
			players[player] = { id = clothing, texName = texName, pending = true }
		end
	end
end

-- remove the clothes - that's rather easy
function removeClothing(player)
	local clothes = players[player]
	if clothes and loaded[clothes.id] and isElement(loaded[clothes.id].shader) then
		-- possibly clean up shaders
		local stillUsed = false
		for p, data in pairs(players) do
			if p ~= player and data.id == clothes.id then
				stillUsed = true
				break
			end
		end

		if stillUsed then
			if not clothes.pending then
				-- just remove the shader from that one player
				engineRemoveShaderFromWorldTexture(loaded[clothes.id].shader, clothes.texName, player)
			end
		else
			-- destroy the shader and texture since no player uses it
			local L = loaded[clothes.id]
			if L then
				destroyElement(L.texture)
				destroyElement(L.shader)

				loaded[clothes.id] = nil
			end
		end
		players[player] = nil
	end
end

-- file we asked for is there
addEvent('clothing:file', true)
addEventHandler( 'clothing:file', resourceRoot,
	function(id, content, size)
		local file = fileCreate(getPath(id))
		local written = fileWrite(file, content)
		fileClose(file)

		if written ~= size then
			fileDelete(getPath(id))
		else
			for _, player in ipairs(streaming[id]) do
				addClothing(player, id)
			end

			streaming[id] = nil
		end
	end, false)

-- initialize all skins upon resource startup
addEventHandler( 'onClientResourceStart', resourceRoot,
	function()
		for _, name in ipairs({'player', 'ped'}) do
			for _, p in ipairs(getElementsByType(name)) do
				if isElementStreamedIn(p) then
					local clothing = getElementData(p, 'clothing:id')
					if clothing then
						addClothing(p, clothing)
					end
				end
			end
		end
	end)

-- apply skins when people are to be streamed in.
addEventHandler( 'onClientElementStreamIn', root,
	function()
		if getElementType(source) == 'player' or getElementType(source) == 'ped' then
			local clothing = getElementData(source, 'clothing:id')
			if clothing then
				addClothing(source, clothing)
			end
		end
	end)

-- remove them when streamed out
addEventHandler( 'onClientElementStreamOut', root,
	function()
		if getElementType(source) == 'player' or getElementType(source) == 'ped' then
			removeClothing(source)
		end
	end)

-- remove them when they quit
addEventHandler( 'onClientPlayerQuit', root,
	function()
		removeClothing(source)
	end)

addEventHandler( 'onClientElementDestroy', root,
	function()
		if getElementType(source) == 'ped' then
			removeClothing(source)
		end
	end)

-- apply changed clothing
addEventHandler( 'onClientElementDataChange', root,
	function(name)
		if (getElementType(source) == 'player' or getElementType(source) == 'ped') and isElementStreamedIn(source) and name == 'clothing:id' then
			removeClothing(source)

			if getElementData(source, 'clothing:id') then
				addClothing(source, getElementData(source, 'clothing:id'))
			end
		end
	end)

