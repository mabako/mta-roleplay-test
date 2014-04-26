addEventHandler( "onPlayerWeaponSwitch", getRootElement(),
	function ()
		if exports.global:hasItem(source, 115) then
			outputChatBox("You have a weapon.", source)
			local exists, slot, itemValue = exports.global:hasItem(source, 115)
			if itemValue:sub(1,2)=="30" and not getPedWeapon(source)==30 then --AK-47
				-- Bone attach
				outputChatBox("Now in your back", source)
			elseif itemValue==3 and not getPedWeapon(source)==3 then  --Nightstick
				-- Bone attach
			elseif itemValue==5 and not getPedWeapon(source)==5 then --Baseball bat
				-- Bone attach
			elseif itemValue==8 and not getPedWeapon(source)==8 then --Katana
				-- Bone attach
			elseif itemValue==22 and not getPedWeapon(source)==22 then --Pistol
				-- Bone attach
			elseif itemValue==23 and not getPedWeapon(source)==23 then --Silenced pistol
				-- Bone attach
			elseif itemValue==24 and not getPedWeapon(source)==24 then --Desert eagle (deagle)
				-- Bone attach
			elseif itemValue==30 and not getPedWeapon(source)==30 then --AK-47
				-- Bone attach
				outputChatBox("Now in your back", source)
			elseif itemValue==31 and not getPedWeapon(source)==31 then --M4A1
				-- Bone attach
			end
		end
	end
)
			