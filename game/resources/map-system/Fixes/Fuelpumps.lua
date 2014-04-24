local gastanks = 
{
	-- IDLEWOOD GAS
	{ 1941.65625, -1774.3125, 14.640625 },
	{ 1941.65625, -1767.2890625, 14.640625 },
	{ 1941.65625, -1771.34375, 14.640625 },
	{ 1941.65625, -1778.453125, 14.640625 },
	
	-- Gas near delivery job
	{  -85.2421875, -1165.03125, 3.1328125 },
	{ -92.1015625, -1161.7890625, 3.4609375 },
	{ -97.0703125, -1173.75, 3.53125 },
	{ -90.140625, -1176.625, 3.1328125 }
}


function noDamageByGasStations(x, y, z, type)
	if type == 9 then
		for k, v in ipairs( gastanks ) do
			if x == v[1] and y == v[2] and z == v[3] then
				cancelEvent()
			end
		end
	end
end
addEventHandler( "onClientExplosion", getRootElement(), noDamageByGasStations )
