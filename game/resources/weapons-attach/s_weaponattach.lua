local ak47s = {}
local nightsticks = {}

function checkForAK()
	if (getPedWeapon(source, 5) == 30) then
		if (getPedWeapon(source) == 30) then
			ak47 = createObject(355, 0, 0, 0)
			exports.bone_attach:attachElementToBone(ak47,source,3,0.1,0.25,0,0,45,180)
			ak47s[source] = ak47
			setElementData(source, "holdingAK", 1)
		elseif getElementData(source, "holdingAK") == 1 then
			exports.bone_attach:detachElementFromBone(ak47s[source])
			destroyElement(ak47s[source])
			setElementData(source, "holdingAK", 0)
		end
	end
end

function checkForNightstick()
	if (getPedWeapon(source, 1) == 3) then
		if (getPedWeapon(source) == 3) then
			nightstick = createObject(334, 0, 0, 0)
			exports.bone_attach:attachElementToBone(nightstick,source,3,1,0,0,0,0,0)
			nightsticks[source] = nightstick
			setElementData(source, "holdingNightstick", 1)
		elseif getElementData(source, "holdingNightstick") == 1 then
			exports.bone_attach:detachElementFromBone(nightsticks[source])
			destroyElement(nightsticks[source])
			setElementData(source, "holdingNightstick", 0)
		end
	end
end

addEventHandler("onPlayerWeaponSwitch", getRootElement(), checkForAK)
addEventHandler("onPlayerWeaponSwitch", getRootElement(), checkForNightstick)

