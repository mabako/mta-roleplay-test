local ak47s = {}
local nightsticks = {}

function test (thePlayer)
	local bla1 = createObject(355, 0, 0, 0)
	exports.bone_attach:attachElementToBone(bla1,thePlayer,3,0.1,0.25,0,0,45,180)
	local bla2 = createObject(334, 0, 0, 0)
	exports.bone_attach:attachElementToBone(bla2,thePlayer,3,0,0,0,0,0,0)
end
addCommandHandler("bonetest", test)

addEventHandler( "onPlayerWeaponSwitch", getRootElement(),
	function ()
		if exports.global:hasItem(source, 115) then
			outputChatBox("You have a weapon.", source)
			-- AK 47
			if (getPedWeapon(source, 5) == 30) and (getPedWeapon(source) == 30) then
				setElementData(source, "isHolding30", 0)
				ak47 = createObject(355, 0, 0, 0)
				exports.bone_attach:attachElementToBone(ak47,source,3,0.1,0.25,0,0,45,180)
				ak47s[source] = ak47
				outputChatBox("AK is now added", source)
			elseif (getPedWeapon(source, 5) == 30) and (getPedWeapon(source) ~= 30) and (getElementData(source, "isHolding30") == 0) then
				setElementData(source, "isHolding30", 1)
				exports.bone_attach:detachElementFromBone(ak47s[source])
				destroyElement(ak47s[source])
				outputChatBox("AK is now removed", source)
			end
			-- Nightstick
			if (getPedWeapon(source, 1) == 3) and (getPedWeapon(source) == 3) then
				setElementData(source, "isHolding3", 0)
				nightstick = createObject(334, 0, 0, 0)
				exports.bone_attach:attachElementToBone(nightstick,source,3,0,0,0,0,0,0)
				nightsticks[source] = nightstick
				outputChatBox("Nightstick is now added", source)
			elseif (getPedWeapon(source, 1) == 3) and (getPedWeapon(source) ~= 3) and (getElementData(source, "isHolding3") == 0) then
				setElementData(source, "isHolding3", 1)
				exports.bone_attach:detachElementFromBone(nightsticks[source])
				destroyElement(nightsticks[source])
				outputChatBox("Nightstick is now removed",source)
			end
		end
	end
)
			