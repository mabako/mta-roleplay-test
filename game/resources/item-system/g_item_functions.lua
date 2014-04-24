function getItemRotInfo(id)
	if not g_items[id] then
		return 0, 0, 0, 0
	else
		return  g_items[id][5], g_items[id][6], g_items[id][7], g_items[id][8]
	end
end

local _vehiclecache = {}
local function findVehicleName( value )
	if _vehiclecache[value] then
		return _vehiclecache[value]
	end
	
	for _, theVehicle in pairs( getElementsByType( "vehicle" ) ) do
		if getElementData( theVehicle, "dbid" ) == value then
			_vehiclecache[value] = getVehicleName( theVehicle )
			return _vehiclecache[value]
		end
	end
	return "?"
end

function getItemName(id, value)
	if id == -100 then
		return "Body Armor"
	elseif id == -46 then -- MTA Client bug
		return "Parachute"
	elseif id < 0 then
		return getWeaponNameFromID( -id )
	elseif not g_items[id] then
		return "?"
	elseif id == 3 and value then
		return g_items[id][1] .. " (" .. findVehicleName(value) .. ")", findVehicleName(value)
	elseif ( id == 4 or id == 5 ) and value then
		local pickup = exports['interior-system']:findParent( nil, value )
		local name = pickup and getElementData( pickup, "name" )
		return g_items[id][1] .. ( name and ( " (" .. name .. ")" ) or "" ), name
	elseif ( id == 80 ) and value then
		return value
	elseif ( id == 96 ) and value and value ~= 1 then
		return value
	elseif ( id == 89 or id == 95 or id == 109 or id == 110 ) and value and value:find( ";" ) ~= nil then
		return value:sub( 1, value:find( ";" ) - 1 )
	elseif id == 115 and value then
		--return value
		local itemExploded = explode(":", value )
		return itemExploded[3]
	else
		return g_items[id][1]
	end
end

function getItemValue(id, value)
	if id == 80 then
		return ""
	elseif id == 96 then
		return 1
	elseif (id == 89 or id == 95 or id == 109 or id == 110) and value and value:find( ";" ) ~= nil then
		return value:sub( value:find( ";" ) + 1 )
	elseif (id == 115 and value) then
		return explode(":", value)[2]
	elseif id == 116 and value then
		return value:gsub("^(%d+):(%d+):", "%2 ")
	else
		return value
	end
end

	
function getItemDescription(id, value)
	local i = g_items[id]
	if i then
		local desc = i[2]
		if id == 96 and value ~= 1 then
			return desc:gsub("PDA","Laptop")
		elseif id == 114 then
			local v = value - 999
			return desc:gsub("#v", vehicleupgrades[v] or "?")
		else
			return desc:gsub("#v",value)
		end
	end
end

function getItemType(id)
	return ( g_items[id] or { nil, nil, 4 } )[3]
end

function getItemModel(id, value)
	if id == 115 and value then
		--return value
		local itemExploded = explode(":", value )
		return weaponmodels[ tonumber(itemExploded[1]) ] or 1271
	else

		return ( g_items[id] or { nil, nil, nil, 1271 } )[4]
	end
end

function explode(div,str) -- credit: http://richard.warburton.it
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
	table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
	pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end

function getItemTab(id)
	if getItemType( id ) == 2 then
		return 2
	elseif getItemType( id ) == 8 or getItemType( id ) == 9 then
		return 3
	else
		return 1
	end
end

function getItemWeight( itemID, itemValue )
	local weight = g_items[ itemID ] and g_items[ itemID ].weight
	return type(weight) == "function" and weight( tonumber(itemValue) or itemValue ) or weight 
end
