mta_values =
{
	'MTA + Suspension',
	-- name, type, limits, friendly name, custom property
	{'brand',				'string', { }, 'Brand', 'name'},
	{'name',				'string', { }, 'Name', 'name' },
	{'year',				'int', { 1950, 2020 }, 'Year', 'name' },
	{'shop',				'select', { }, 'Shop', 'handling:editable' },
	{'price',				'int', { 100, 500000 }, 'Price ($)', 'handling:editable' },
	{'disabled',			'select', { [0] = 'Available', [1] = 'Not for Sale'}, 'For Sale', 'handling:editable'},

	false,
	{'suspensionForceLevel',		'float', { 0, 100 }, 'Force Level'},
	{'suspensionDamping',			'float', { 0, 100 }, 'Damping'},
	{'suspensionHighSpeedDamping',	'float', { 0, 600 }, 'High Speed Damping'},
	{'suspensionUpperLimit',		'float', { -50, 50 }, 'Upper Limit'},
	{'suspensionLowerLimit',		'float', { -50, 50 }, 'Lower Limit'},
	{'suspensionFrontRearBias',		'float', { 0, 1 }, 'Front/Rear Bias'},
	{'suspensionAntiDiveMultiplier','float', { 0, 30 }, 'Anti Dive Multiplier'},

	'General',
	{'mass',				'float', { 1, 100000 }, 'Mass'},
	{'dragCoeff',			'float', { -200, 200 }, 'Drag Multiplier'},
	{'turnMass',			'float', { 0, 1000000 }, 'Turn Mass'},
	{'percentSubmerged',	'int', { 1, 99999 }, 'Percent Submerged'},
	{'tractionMultiplier',	'float', { -100000, 100000 }, 'Traction Multiplier'},
	{'tractionLoss',		'float', { 0, 100 }, 'Traction Loss'},
	{'tractionBias',		'float', { 0, 1 }, 'Traction Bias'},
	{'numberOfGears',		'int', { 1, 5 }, 'No. of Gears'},
	{'maxVelocity',			'float', { 0.1, 300 }, 'Max. Velocity'},
	{'engineAcceleration',	'float', { 0, 100 }, 'Acceleration'},
	{'engineInertia',		'float', { -1000, 1000 }, 'Inertia'},
	{'driveType',			'select', {fwd = 'Front', rwd = 'Rear', awd = 'All'}, 'Drive Type'},
	{'engineType',			'select', {petrol = 'Petrol', diesel = 'Diesel', electric = 'Electric'}, 'Engine Type'},
	{'brakeDeceleration',	'float', { 0.1, 100 }, 'Brake Deceleration'},
	{'brakeBias',			'float', { 0, 1 }, 'Brake Bias'},
	{'steeringLock',		'float', { 0, 360 }, 'Steering Lock'},
	{'collisionDamageMultiplier', 'float', { 0, 10 }, 'Damage Multiplier'},
}

function getVehicleHandlingEx(vehicle)
	local handling = getVehicleHandling(vehicle)

	for k, v in ipairs(mta_values) do
		if type(v) == 'table' and v[5] then
			handling[v[1]] = getElementData(vehicle, v[5])[v[1]]
		end
	end

	return handling
end

local serverside = triggerServerEvent == nil
addEventHandler(serverside and 'onResourceStart' or 'onClientResourceStart', root,
	function(res)
		if getResourceName(res) == 'carshop' or source == resourceRoot then
			if getResourceFromName('carshop') and (not serverside or getResourceState(getResourceFromName('carshop')) == 'running') then
				mta_values[5][3] = exports.carshop:getShopNames()
			end
		end

		if not serverside then
			initGUI()
		end
	end
)

function lookupMTAValue(key)
	for k, v in ipairs(mta_values) do
		if type(v) == 'table' and v[1] == key then
			return v
		end
	end
end

function isValidValue(key, value)
	local entry = lookupMTAValue(key)
	if entry then
		-- check the limits if it's an int or float
		if entry[2] == 'int' or entry[2] == 'float' then
			local num = tonumber(value)
			local limit = entry[3]
			return num and num >= limit[1] and num <= limit[2]
		elseif entry[2] == 'string' then
			return #value < 40
		elseif entry[2] == 'select' then
			return entry[3][value] ~= nil -- value is available
		end
		return true
	end

	return false
end