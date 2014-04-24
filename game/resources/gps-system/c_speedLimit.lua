addCommandHandler("speednode",
	function()
		if exports.global:isPlayerScripter(getLocalPlayer()) then
			outputChatBox(findNodeClosestToPoint(vehicleNodes, getElementPosition(getLocalPlayer())).id)
		end
	end
)

local speedlimits90 =
{
	-- node1, node2
	{ 786819, 1311230 },
	{ 786747, 852334 },
	{ 786741, 852258 },
	{ 786817, 786715 },
	{ 1311150, 786827 },
	{ 786827, 786818 },
	{ 786716, 1507768 },
	{ 786827, 1507768 },
	{ 1311487, 786623 },
	{ 786823, 1311512 },
	{ 786822, 1311513 },
	{ 786546, 786600 },
	{ 786600, 1376576 },
	{ 1376576, 1442183 },
	{ 786542, 786897 },
	{ 786897, 1376522 },
	{ 1376522, 1311054 },
	{ 1311054, 1376526 },
	{ 1376526, 1442183 },
	{ 1311514, 1376278 },
	{ 1376362, 1442123 },
	{ 1442123, 1441994 },
	{ 1441994, 1442260 },
	{ 1442123, 918080 },
	{ 1507456, 1507942 },
	{ 1507715, 1507708 },
	{ 1507862, 1507894 },
	{ 1507894, 983504 },
	{ 983495, 1507875 },
	{ 1507875, 1507864 },
	{ 983604, 983594 },
	{ 1442239, 1442238 },
	{ 983564, 983555 },
	{ 983531, 918022 },
	{ 983589, 983524 },
	{ 917953, 917954 },
	{ 917818, 917917 },
	{ 917917, 918079 },
	{ 918027, 918005 },
	{ 852267, 1376936 },
	{ 1376935, 852312 },
	{ 1441804, 1442490 },
	{ 1442490, 1376721 },
	{ 1442512, 1442509 },
	{ 1442566, 1442590 },
	{ 1441820, 1442335 },
	{ 1442464, 1441814 },
	{ 1442671, 1442650 },
	{ 1441802, 917569 },
	{ 917555, 917570 },
	{ 1441850, 1442298 },
	{ 1441847, 917554 },
	{ 327681, 852153 },
	{ 327821, 327818 },
	{ 327695, 327841 },
	{ 1376521, 1376589 },
	-- country road leading out of LS, near madd dogg's
	{ 1376948, 1835431 }
}

for _, node in ipairs( speedlimits90 ) do
	local path = calculatePathByNodeIDs( node[1], node[2] )
	for key, value in ipairs(path) do
		value.speedlimit = 90
		--createBlip( value.x, value.y, value.z, 0, 1, 0, 255, 0 )
	end
end

local speedlimits120 = 
{
	{ 786747, 721310 },
	{ 786741, 721310 },
	{ 983594, 983587 },
	{ 983587, 918112 },
	{ 918112, 1441850 },
	{ 917570, 918007 },
	{ 918007, 918017 },
	{ 918017, 983564 },
	{ 852334, 327806 },
	{ 327795, 852258 },
	{ 1966173, 918098 },
	{ 918098, 917780 },
	{ 917780, 327843 },
	{ 327843, 393296 },
	{ 393296, 393510 },
	{ 393510, 983263 },
	{ 983263, 2031776 },
	
	{ 2031800, 983256 },
	{ 983256, 393249 },
	{ 393249, 327752 },
	{ 327752, 327814 },
	{ 327814, 918106 },
	{ 918106, 1442674 },
	{ 1442674, 1966167 },

	{ 918113, 918116 },
	-- highway leaving LS through the tunnel
	-- in LS , outside
	{ 1310734, 1245263 },
	{ 1310784, 1245284 },
}

for _, node in ipairs( speedlimits120 ) do
	local path = calculatePathByNodeIDs( node[1], node[2] )
	for key, value in ipairs(path) do
		value.speedlimit = 120
		--createBlip( value.x, value.y, value.z, 0, 1 )
	end
end

setTimer(
	function()
		local x, y, z = getElementPosition(getLocalPlayer())
		setElementData( getLocalPlayer(), "speedo:limit", x > 50 and y < -650 and (findNodeClosestToPoint(vehicleNodes, x, y, z).speedlimit or 60), false)
	end, 500, 0
)