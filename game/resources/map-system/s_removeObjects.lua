function start()
	-- Idlewood Gas objects
	removeWorldModel(5397, 200, 1928, -1762, 25)
	removeWorldModel(5536, 200, 1928, -1762, 25)
	removeWorldModel(5409, 200, 1928, -1762, 25)
	removeWorldModel(5535, 200, 1928, -1762, 25)
	removeWorldModel(7312, 200, 1928, -1762, 25)
	removeWorldModel(995, 200, 1928, -1762, 25)
	removeWorldModel(1775, 200, 1928, -1762, 25)
	removeWorldModel(1676, 200, 1928, -1762, 25)
	removeWorldModel(712, 200, 1928, -1762, 25)
	removeWorldModel(620, 300, 1928, -1762, 25)
	removeWorldModel(1412, 50, 1929, -1810, 17)
	removeWorldModel(5489, 50, 1929, -1810, 17)
	removeWorldModel(1307, 50, 2072, -1879.687, 13)

	--[[ Bulding West of IGS
	removeWorldModel(4019, 200, 1928, -1762, 25)
	removeWorldModel(4025, 200, 1928, -1762, 25)	--]]

	--[[ Alhambra
	removeWorldModel(5408, 200, 1928, -1762, 25)
	removeWorldModel(5544, 200, 1928, -1762, 25)	--]]
end
addEventHandler("onResourceStart", getResourceRootElement(), start)