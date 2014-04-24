local function checkLength( value )
	return value and #value >= 0 and #value <= 90
end

editables = {
	{ name = "Weight", index = "weight", verify = function( v ) return tonumber( v ) and tonumber( v ) >= 40 and tonumber( v ) <= 140 end },
	{ name = "Hair Color", index = 1, verify = checkLength },
	{ name = "Hair Style", index = 2, verify = checkLength },
	{ name = "Facial Features", index = 3, verify = checkLength },
	{ name = "Physical Features", index = 4, verify = checkLength },
	{ name = "Clothing", index = 5, verify = checkLength },
	{ name = "Accessoires", index = 6, verify = checkLength }
}