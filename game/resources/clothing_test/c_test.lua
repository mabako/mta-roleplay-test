local accessoires = { watchcro = true, neckcross = true, earing = true, glasses = true, specsm = true }
local function getPrimaryTextureName(model)
	for k, v in ipairs(engineGetModelTextureNames(model)) do
		if not accessoires[v] then
			return v
		end
	end
end

addEventHandler('onClientResourceStart', resourceRoot,
	function()
		local texture = dxCreateTexture('test.png')
		local shader, t = dxCreateShader('tex.fx', 0, 0, true, 'ped')

		dxSetShaderValue(shader, 'tex', texture)
		engineApplyShaderToWorldTexture(shader, getPrimaryTextureName(getElementModel(localPlayer)), localPlayer)
	end)