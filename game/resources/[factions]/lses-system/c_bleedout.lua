function showBlood(attacker, weapon, bodypart)
	local health = getElementHealth(source)

	if (health<=20) then
		local x, y, z = getElementPosition(source)
		fxAddBlood(x, y, z, 0, 0, 0, 1000, 1.0)
	end
	
	-- Realistic blood from bodypart
	if (attacker) and (weapon~=17) then
		if (bodypart==3) then -- torso
			local x, y, z = getPedBonePosition(source, 3)
			fxAddBlood(x, y, z, 0, 0, 0, 500, 1.0)
		elseif (bodypart==4) then -- ass
			local x, y, z = getPedBonePosition(source, 1)
			fxAddBlood(x, y, z, 0, 0, 0, 500, 1.0)
		elseif (bodypart==5) then -- left arm
			local x, y, z = getPedBonePosition(source, 32)
			fxAddBlood(x, y, z, 0, 0, 0, 500, 1.0)
		elseif (bodypart==6) then -- right arm
			local x, y, z = getPedBonePosition(source, 22)
			fxAddBlood(x, y, z, 0, 0, 0, 500, 1.0)
		elseif (bodypart==7) then -- left leg
			local x, y, z = getPedBonePosition(source, 42)
			fxAddBlood(x, y, z, 0, 0, 0, 500, 1.0)
		elseif (bodypart==8) then -- right leg
			local x, y, z = getPedBonePosition(source, 52)
			fxAddBlood(x, y, z, 0, 0, 0, 500, 1.0)
		elseif (bodypart==9) then -- head
			local x, y, z = getPedBonePosition(source, 6)
			fxAddBlood(x, y, z, 0, 0, 0, 500, 1.0)
		end
	end
end
addEventHandler("onClientPlayerDamage", getRootElement(), showBlood)