local names =
{
	-- highways etc.
	{ { 786912, 786456, 786503, 852353, 852333, 852169 }, { 852161, 852231, 852221, 786493, 786477, 786745, 786908 }, { 786817 }, { 786818 }, { 786821 }, { 786822 }, { 786823 }, { 852347 }, { 852349 }, { 852351 }, { 852362 }, { 852363 }, { 786819 }, { 852346 }, { 852364 }, name = "Interstate 425 West - Los Santos Expressway" },
	{ { 852176, 852170 }, { 852162, 852168 }, name = "Interstate 425 West - Liberty Tunnel" },
	{ { 327793, 327781, 393270, 327794, 327797, 327773, 327791 }, name = "Interstate 425 West" },
	{ { 1310734, 1310778 }, { 1310813, 1310784 }, name = "Los Santos Tunnel" },
	{ { 2031790, 2031803, 1507786, 983294, 983316, 1507826, 1507801, 2031780 }, { 983641, 983640 }, { 1507953, 1507952 }, name = "Interstate 425 East - Red County Turnpike" },
	{ { 983604, 983580, 917998, 1442214 }, { 917556, 918012, 983576, 983558 }, name = "Interstate 125" },
	{ { 983517, -983356 }, name = "Interstate 125/Kennedy Ave" },
	{ { -983356, 983539 }, name = "Kennedy Ave/Interstate 125" },
	{ { 1442239, 1442240 }, name = "Interstate 125/Pasadena Blvd" },
	{ { 918129, 917961 }, name = "Washington St/Interstate 125" },
	{ { 917953, 917954 }, name = "Interstate 125/Grove St" },
	{ { 983627, 983258, 983269, 393247, 393282, 393299, 327733 }, { 327732, 393303, 393289, 393509, 983281, 983262, 983244 }, { 983614 }, { 458885 }, { 458879 }, { 393505 }, { 393601 }, { 393600 }, { 458884 }, { 458880 }, { 983635 }, { 983623, 983628 }, name = "Interstate 425 South" },
	{ { 327848, 327815, 852079, 917771, 917555 }, { 1441801, 1442287 }, { 1966135, 1966148 }, { 1966146, 1966136 }, { 1442288, 1441800 }, { 917554, 917788, 327870 }, name = "Interstate 25" },
	
	{ { -917555, -917556 }, { -1441800, -917556 }, name = "Interstate 25/125 - Central Interchange" },
	{ { -917555, -1441801 }, { -1441800, -917554 }, name = "Interstate 25 - Central Interchange" },
	{ { -1442214, -1441801 }, name = "Interstate 125/25 North - Central Interchange" },
	{ { -1442214, -917554 }, name = "Interstate 125/25 South - Central Interchange" },
	
	{ { -1442287, 1442679, 1442690, -1966135 }, { 1442613, -1966135 }, { -1442287, 1441818 }, { -1966136, 1441809, 1441806, -1442288 }, { -1966136, 1442510 }, { 1441805, -1442288 }, name = "Interstate 25 - Mulholland Intersection" },
	{ { -1441818, 1442560, 1442509, 1376730 }, { -1442510, -1442509 }, name = "Interstate 25/West Broadway - Mulholland Intersection" },
	{ { -1442510, -1442589, -1441804 }, { -1441818, -1442526 }, name = "Interstate 25/East Broadway - Mulholland Intersection" },
	{ { -1441804, 1442602 }, { 1442604 }, name = "East Broadway - Mulholland Intersection" },
	{ { -1442602, -1442613 }, { -1442602, -1441805 }, name = "East Broadway/Interstate 25 - Mulholland Intersection" },
	{ { -1376731, 1442464 }, name = "West Broadway - Mulholland Intersection" },
	{ { -1442464, -1442613 }, { -1442464, -1441805 }, name = "West Broadway/Interstate 25 - Mulholland Intersection" },
	{ { 1442350, 1442460 }, { 1442340, 1442341 }, name = "Mulholland Intersection" },

	
	{ { 786718, 1310891, 1311498, 1376621, 1376626, 1376669, 1442496 }, { 1376721, 1376845, 1376650, 1376508, 1376733, 1376609, 1311156, 1310927, 786508 }, { 786828 }, { 1311510 }, { 1311512 }, { 1311513 }, { 1376935 }, { 1376936 }, { 1311511 }, { 1376945 }, { 1376946 }, { 1376947 }, { 1376948 }, { 1376943 }, { 1376939 }, { 1376938 }, { 1376940 }, { 1376941 }, name = "West Broadway" },
	{ { 1442495, 1442075, 1507670, 1507768 }, name = "East Broadway" },

	-- Santa Maria Beach
	{ { 786752, 786761, 786777, 786792 }, name = "Beach Rd" },
	{ { 786567, 786705 }, name = "Carnival Rd" },
	{ { 852419, 852405, 786945 }, name = "Verona Beach Blvd" },
	{ { 786944, 786935 }, { 786927, 786918 }, name = "Santa Maria Blvd" },
	
	-- Rodeo
	{ { 852365, -786659, -786824, -786640, 786589, 786524, 1310900, 1310947, -1311009, -1311514, -1311010, -1376395, 1376371, 1376293 }, name = "Rodeo Drive" },
	{ { 786533, -786539, -786826, -786540, -786652, -786825, -786664, 852019 }, name = "Olympic Blvd" },
	{ { 786591, -786561, -1310907, -1311518, -1310906, 1310916 }, name = "Royal St" },
	{ { 786623, -786620, 1310978, 1310977 }, name = "Soho Drive" },
	{ { 1310981, -1310940, 1310949 }, name = "York St" },
	{ { 1311142, 1311148, 786722 }, name = "Curve St" },
	{ { 1311011, -1311052, -1311053, 786680, 786649 }, { 786661, 786668, 786686, -1311055, -1311054, 1311470 }, { 1311514 }, { 786825 }, { 786824 }, name = "Western Ave" },
	{ { 786546, 786609, 1311067, 1376817, 1376814, 1376540, -1376520, -1376914, -1376521, 1376600, 1376601, 1376408, 1442251, -1442188, 1442226, 1442183 }, { 1376584, 1376585, 1376577, -1376519, -1376913, -1376518, 1376524, 1376835, 1311091, 1310960, 786599, 786542 }, { 786826 }, { 1311518 }, { 1311517 }, { 1376908 }, { 1376907 }, { 1376900 }, { 1376899 }, { 1376898 }, { 1376910 }, { 1376909 }, { 1376912 }, { 1376298 }, { 1376299 }, name = "Pasadena Blvd" },
	
	-- Richman/Mulholland
	{ { 786802, 1311212, 1311446, 1311429 }, name = "Providence St" },
	{ { 1310732, 1311388, 1311416, 1311454, 1376446, 1900740, 1376772 }, { 1376795, 1442262 }, { 1900928, 1900926 }, name = "Rich St" },
	{ { 1311181, 1311175, 1311166 }, name = "Owl St" },
	{ { 1311201, 1311200 }, name = "Owl/Providence St" },
	{ { 1311215, -1311386, 1311120 }, name = "Belmont Drive" },
	{ { 1311117, 1835548 }, name = "Square Rd" },
	{ { 1311500, 1310854, 1311267 }, name = "Tory St" },
	{ { 1311312, 1310860, 1376503 }, name = "McCain St" },
	{ { 1376755, 1376764 }, name = "VGB Circle Drive" },
	{ { 1376897, 1900911, 1900867, 1900925 }, name = "Palin St" },
	{ { 1376877, 1376875, 1376735 }, name = "State Rd" },
	
	-- Temple
	{ { 1376389, 1376379 }, { 1376384, 852011 }, { 852380, 852371 }, name = "Giggles St" },
	{ { 1376362, 1376269 }, name = "West Vinewood Blvd" },
	{ { 1376455, 1376458 }, { 1376316, 1376313 }, { 1376382, 1376381 }, { 1376291, 852008 }, { 852391, 852198 }, name = "Liberty Ave" },
	{ { 1376351, 1376352 }, { 1376358, 1376359 }, name = "Penn St" },
	{ { 1376450, 1376336, 1442328, 1441822 }, name = "Sunset Blvd" },
	{ { 1376326, 1376325 }, { 1376342, 1376341 }, name = "Mint St" },
	{ { 1376347, 1376348 }, { 1376346, 1376343 }, name = "Vice St" },
	{ { 1376302, 1376263 }, name = "Holy Cross St" },
	{ { 1376273, 1376272 }, name = "Pawn St" },
	{ { 1376307, 1376306 }, name = "Shine St" },
	
	-- Central Los Santos/Marina
	{ { 852032, 852057, 852195, 917514, 917527 }, name = "Metropolitean Ave" },
	{ { 917533, 917534 }, name = "Church St" },
	{ { 918146, 917641, -917632, 918039, 852036 }, { 851986, 852005, 852027, 852020 }, name = "Panopticon Ave" },
	{ { 851997, 851993 }, { 852002, 1376285 }, { 1376281, 1376983 }, name = "Beverly Ave" },
	{ { 1376677, 1376676 }, { 1376694, 1376928, 1376550, 1376573, 852307, 852312 }, { 1376931 }, { 1376932 }, { 852267, 852284, 1376564, 1376558, 1376702 }, { 1376686, 1376685 }, { 1376913 }, { 1376914 }, { 1376920, 1376919 }, { 1376926 }, { 1376927 }, name = "St. Lawrence Blvd" },
	{ { 1376531, 1376532 }, name = "Light St" },
	{ { 1376262, 1376259 }, name = "Saint St" },
	{ { 1376287, 1376286 }, name = "Hell St" },
	{ { 1376256, 852001 }, name = "Benedict XVI St" },
	{ { 851978, 851979 }, name = "Pius IX St" },
	{ { 852051, 852050 }, name = "Wells St" },
	{ { 852213, 852203 }, name = "Constitution Ave" },
	{ { 917598, 917599 }, name = "Pine St" },
	{ { 917506, 917809 }, { 918067, 918070, 918049, 918052 }, name = "Police Plaza" },
	{ { 851974, 851972 }, { 852062, 917605, 917607 }, { 917541, 917542 }, { 917832, 917684, 917939, 917630, 1441946 }, { 852065 }, { 917930 }, { 917936 }, name = "San Andreas Blvd" },
	{ { 852066, 852067 }, { 852190, 1376469 }, { 1376397, 1376421 }, name = "Central Ave" },
	{ { 1376415, 1376410 }, name = "Elm St" },
	{ { 1376425, 1376424 }, name = "Eye St" },
	{ { 917544, 917546 }, name = "White St" },
	{ { 918120, 1442695 }, { 1442698, 1442697 }, { 918123, 918124 }, name = "Apple St" },
	{ { 1442229, 1442717 }, name = "Peach St" },
	{ { 918030, 918031 }, name = "Sewers Rd" },
	
	-- South Los Santos
	{ { 852087, 852403 }, name = "Erp Rd" },
	{ { 983385, 458868, 393261, 458850, 458795, 458780, 458775, 458768, 983182, 917794, 917621 }, name = "Pacific Ave" },
	{ { 917893, -917797, 983403, 983409 }, name = "John Paul St" },
	{ { 917814, 983195 }, { 983201 }, name = "High St" },
	{ { 983424, 983416 }, { 983422 }, { 983415 }, { 983423 }, name = "Tar St" },
	{ { 983643, 983633 }, { 983061, 1507625 }, { 983552, 1507911 }, { 1507910 }, { 983458, 983468, 983482 }, { 983475 }, { 983467 }, name = "Atlantica Ave" },
	{ { 983549, 983073 }, name = "Yelp St" },
	{ { 917978, 917977 }, name = "Lombard St" },
	{ { 917696, -917698, 917706 }, { 917709 }, { 917705 }, { 917715 }, { 917713 }, { 917886 }, name = "Gates St" },
	{ { 917723, 917724 }, { 918163, 458886 }, { 918168, 393598 }, { 458759 }, { 458805, 458822, 458834 }, name = "Harbor Rd" },
	{ { 458793, 458792 }, name = "Mast Rd" },
	{ { 393216, 393222, 917926, -983117, 983142, -983125, 983192 }, name = "Industrial Blvd" },
	{ { 983166, 983435 }, name = "South St" },
	{ { 983434, 983448 }, { 983447 }, name = "St. Francis St" },
	{ { 983210, 983221 }, name = "Vernon Rd" },
	{ { 983488, 983490 }, { 983426, 983425 }, { 983429 }, name = "Sun St" }, -- last two routes = Owl St on the map
	{ { 983205, 983206 }, name = "Sand St" },
	{ { 917729, 917721, 917750 }, name = "Republican Ave" },
	{ { 917807, 917718 }, { 917869 }, name = "Reagen St" },
	{ { 917873, 917883 }, { 917881 }, { 917877 }, name = "Aces St" },
	{ { 918173, 917800 }, { 917803 }, { 917801 }, name = "Glendale St" },
	{ { 327681, 852141, 917853, 393398 }, name = "Hindenburg St North" },
	{ { 393399, 393418, 327698, 327710 }, name = "Hindenburg St South" },

	-- East Los Santos
	{ { 1376434, 1441954, 1442387, 1441992, 1442044, 1442254 }, name = "East Vinewood Blvd" },
	{ { 1441794, 1441799 }, { 1441798, 1441843 }, name = "Allerton St" },
	{ { 1376980, 1442709 }, { 1442319, 1442314 }, { 1441923, 1441902 }, name = "Park Ave" },
	{ { 1442031, 1442037, 1442024 }, name = "Park Ave North" },
	{ { 1442125, 1442193, 917651, 918083, 917908, 917818 }, { 917656, 917685 }, { 917658 }, { 917821 }, { 917914 }, { 917906 }, name = "Washington St" },
	{ { 1442013, -1442011, 1442006 }, name = "Green St" },
	{ { 1441966, 1442207 }, name = "Majestic St" },
	{ { 1442208, 1507719, 1507622, 1507614 }, name = "Carson St" },
	{ { 1441890, 1441884 }, { 1441886 }, { 1441882 }, name = "St. George St" },
	{ { 1442136, -1441866, -1442261, 1441892 }, name = "Rolland St" },
	{ { 1441868, 1507464 }, { 1441871 }, { 1441867 }, { 1441875 }, { 1441881 }, { 1507717, 1507718 }, name = "Belview Rd" },
	{ { 1441949, 1507475, 1441950 }, name = "Carson Quadrant" },
	{ { 1442056, 1441910 }, name = "Hill St" },
	{ { 1442101, 1442108, 1507357, 1507385, 1507750 }, { 1507343 }, { 1507338 }, { 1507350 }, { 1507351 }, { 1507335 }, { 1507329 }, { 1507345 }, { 1507332 }, name = "San Pedro Ave" },
	{ { 1507458, 1507942 }, { 1507715, 1507710 }, name = "Howard Blvd" },
	{ { 1507659, 1507658 }, name = "Peace Rd" },
	{ { 1507628, 1507638 }, name = "Fame St" },
	{ { 1507646, 1507571, -1507500, 1507517 }, name = "Caesar Rd" },
	{ { 1507553, 1507630 }, name = "Fremont St" },
	{ { 1507581, -1507566, 1507595 }, name = "St. Catherine St" },
	{ { 1507585, 1507586 }, name = "Freedom St" },
	{ { 1507575, -1507568, 1507904 }, name = "St. Joseph St" },
	{ { 1507903, 983091 }, name = "Pilon St" },
	{ { 1507649, 1507490, 983092, 983394 }, name = "Forum St" },
	{ { 2031889, 1507732, 1507523, 983084 }, name = "Santa Monica Blvd" },
	{ { 1507525, 1507921 }, name = "Bush St" },
	{ { 1507487, 1507855 }, name = "Sea St" },
	{ { 983085, 1507491 }, name = "Free Rd" },
	{ { 983609, 983106 }, name = "St. Anthony St" },
	{ { 983495, 1507843, 1507873, 1507870, 1507864 }, { 1507884, 1507542, 1507510, 983504 }, { 983634, 1507949 }, name = "Saints Blvd" },
	{ { 1507483, 983371, 983368 }, { 983329, 983330 }, name = "Kennedy Ave" },
	{ { 983053, 983044, 983048, 983346, 917614 }, { 917668, 918024, 918154 }, { 983351 }, name = "Grove St" },
	{ { 918155, 917647 }, { 917644 }, name = "Mason St" },
	{ { 917661, 917660 }, name = "Hawk St" },
	{ { 1441860, 1507448 }, name = "Forest Rd" },
	{ { 917693, 917678, 1442170 }, { 1442174, 1442173 }, name = "Guantanamo Ave" },
	{ { 1442725, 1442732 }, name = "County General Hospital" },
	{ { 1442722, 1441934 }, name = "Health St" },
	{ { 1441905, 1442410 }, name = "St. Mary St" },
	{ { 983229, -917615, 917616 }, { 917928 }, { 983629 }, { 983228 }, { 983223 }, name = "Liverpool Rd" },
}

for k, node in ipairs( names ) do
	for _, route in ipairs( node ) do
		if #route == 1 then
			local value = getNodeByID( vehicleNodes, route[1] )
			if value then
				if not value.streetname then
					value.streetname = node.name
				elseif value.streetname ~= node.name then
					value.streetname = value.streetname .. "/" .. node.name
				end
			end
		else
			for i = 1, #route - 1 do
				local path = calculatePathByNodeIDs( math.abs(route[i]), math.abs(route[i+1]) )
				for key, value in ipairs(path) do
					if value.id == -route[i] or value.id == -route[i+1] then
					
					elseif not value.streetname then
						value.streetname = node.name
					elseif value.streetname ~= node.name then
						value.streetname = value.streetname .. "/" .. node.name
					end
				end
			end
		end
	end
end

local cacheX, cacheY, cacheZ = 0, 0, 0

addEventHandler("onClientRender", getRootElement(),
	function()
		local x, y, z = getElementPosition(getLocalPlayer())
		if cacheX ~= x or cacheY ~= y or cacheZ ~= z then
			local node = findNodeClosestToPoint(vehicleNodes, x, y, z)
			setElementData(getLocalPlayer(), "speedo:street", node.streetname, false)
			cacheX = x
			cacheY = y
			cacheZ = z
		end
	end
)