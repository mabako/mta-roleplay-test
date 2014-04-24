local drunktimer = nil
local alcohollevel = 0
local delayedKeys = {
	'forwards', 'backwards', 'left', 'right', 'fire', 'aim_weapon', 'previous_weapon', 'next_weapon', 'jump', 'sprint', 'crouch', 'walk', 'enter_exit', -- on foot
	'vehicle_fire', 'vehicle_secondary_fire', 'vehicle_left', 'vehicle_right', 'steer_forward', 'steer_back', 'accelerate', 'brake_reverse', 'radio_next', 'radio_previous', 'radio_user_track_skip', 'horn', 'handbrake', 'vehicle_look_left', 'vehicle_look_right', 'vehicle_look_behind', 'special_control_left', 'special_control_right', 'special_control_down', 'special_control_up' -- in vehicle
}

function delayedKeyPress( key, state )
	local time = math.max( 50, math.floor( alcohollevel * 500 ) )
	setTimer( setControlState, time, 1, key, ( state == "down" ))
end

function drunkenDataChange(name)
	if name == "alcohollevel" then
		if getElementData(source, name) then
			if getElementData(source, name) < 0 then
				setElementData(source, name, 0, false)
			elseif getElementData(source, name) == 0 then
				setElementData(source, name, false, false)
				
				-- restore all keys
				if not alcohollevel then
					return
				elseif alcohollevel == 0 then
					for k, v in pairs( delayedKeys ) do
						unbindKey( v, 'both', delayedKeyPress )
						toggleControl( v, true )
					end
				end
				if drunktimer then
					killTimer(drunktimer)
					drunktimer = nil
				end
			else
				if alcohollevel == false then
					alcohollevel = 0
				end
				
				if alcohollevel < 1 then
					-- set all keys to delayed
					for k, v in pairs( delayedKeys ) do
						toggleControl( v, false )
						bindKey( v, 'both', delayedKeyPress )
					end
					drunktimer = setTimer(function() local level = getElementData(getLocalPlayer(), "alcohollevel") setElementData(getLocalPlayer(), "alcohollevel", level - 0.005, false) end, 5000, 0)
				else
					-- random effect
					local rand = math.random(1, 10)
					if rand == 1 then
						-- press a random key
						if isPedInVehicle(getLocalPlayer()) then
							local key = { 'vehicle_left', 'vehicle_right', 'accelerate', 'steer_back' }
							key = key[math.random(1, #key)]
							setControlState( key, not getControlState( key ) )
						end
					elseif rand == 2 then
						--blackout or sth
						fadeCamera(false, 0)
						setTimer(fadeCamera, 300, 1, true, 1)
					end
				end
			end
			alcohollevel = getElementData(source, name)
			triggerServerEvent("setDrunkness", source, alcohollevel)
		end
	end
end
addEventHandler( "onClientElementDataChange", getLocalPlayer(), drunkenDataChange )

addEventHandler( "onClientPlayerWasted", getLocalPlayer(), function() setElementData(source, "alcohollevel", 0, false) end )
addEventHandler( "onClientResourceStart", getResourceRootElement(),
	function()
		source = getLocalPlayer()
		if getElementData(source, "alcohollevel") and getElementData(source, "alcohollevel") ~= 0 then
			drunkenDataChange( "alcohollevel" )
		end
	end
)
addEventHandler( "onClientResourceStop", getResourceRootElement(),
	function()
		source = getLocalPlayer()
		local level = getElementData(source, "alcohollevel")
		if level and level ~= 0 then
			setElementData(source, "alcohollevel", 0, false)
			removeEventHandler( "onClientElementDataChange", getLocalPlayer(), drunkenDataChange )
			setElementData(source, "alcohollevel", level, false)
		end
	end
)
