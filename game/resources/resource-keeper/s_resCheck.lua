--Add any resources needing to be checked here
local mainRes = { "admin-system", "account-system", "global", "mysql", "pool" }

function displayAdminM(message)
	for k, arrayPlayer in ipairs(getElementsByType('player')) do
		local logged = getElementData(arrayPlayer, "loggedin")
		if (logged) then
			if getElementData(arrayPlayer, "adminlevel") >= 1 then
				outputChatBox("ResWarn: " .. message, arrayPlayer, 255, 194, 14)
			end
		end
	end
end

local attempts = { 0, 0 }
local count = 0
function checkRes(res)
	for i, res in ipairs(mainRes) do
		local resName = getResourceFromName(res)
		if (resName) then
			local cState = getResourceState(resName)
			if (cState ~= "running") then
				displayAdminM("Resource '" .. res .. "' was not running. Attempting to start missing resource.")
				local startingRes = startResource(resName, true)
				if (attempts[i] < 4) then
					if not (startingRes) then
						displayAdminM("Fail to load Resource '" .. res .. "'.")
						local nreasonRes = getResourceLoadFailureReason(resName)
						--displayAdminM("Reason: " .. nreasonRes)
						attempts[i] = attempts[i] + 1
					else
						displayAdminM("Resource '" .. res .. "' started successfully.")
					end
				end
			end
			count = count + 1

			if count == #mainRes then
				count = 0
			end
		end
	end
end
addEventHandler("onResourceStart", getResourceRootElement(),
	function()
		setTimer(checkRes, 60000, 0)
	end
)

function runResCheck(admin, command)
	if (command == "rescheck") then
		if (getElementData(admin, "adminlevel") >= 5) then
			outputChatBox("Running Resource Checker:", admin, 0, 255, 0)
			checkRes()
		end
	elseif (command == "rcs") then
		if (getElementData(admin, "adminlevel") >= 5) then
			outputChatBox("Resource Keeper is running.", admin, 0, 255, 0)
		end
	end
end
addCommandHandler("rescheck", runResCheck)
addCommandHandler("rcs", runResCheck)

function restartSingleResource(thePlayer, commandName, resourceName)
	if (getElementData(thePlayer, "adminlevel") >= 5) then
		if not (resourceName) then
			outputChatBox("SYNTAX: /resrestart [Resource Name]", thePlayer, 255, 194, 14)
		else
			local theResource = getResourceFromName(tostring(resourceName))
			if (theResource) then
				if getResourceState(theResource) == "running" then
					restartResource(theResource)
					outputChatBox("Resource " .. resourceName .. " was restarted.", thePlayer, 0, 255, 0)
					displayAdminM("AdmScript: " .. getPlayerName(thePlayer) .. " restarted the resource '" .. resourceName .. "'.")
				elseif getResourceState(theResource) == "loaded" then
					startResource(theResource, true)
					outputChatBox("Resource " .. resourceName .. " was started.", thePlayer, 0, 255, 0)
					displayAdminM("AdmScript: " .. getPlayerName(thePlayer) .. " started the resource '" .. resourceName .. "'.")
				elseif getResourceState(theResource) == "failed to load" then
					outputChatBox("Resource " .. resourceName .. " could not be loaded (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0)
				else
					outputChatBox("Resource " .. resourceName .. " could not be started (" .. getResourceState(theResource) .. ")", thePlayer, 255, 0, 0)
				end
				
			else
				outputChatBox("Resource not found.", thePlayer, 255, 0, 0)
			end
		end
	else
		outputChatBox("You are not authorised to use that command.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("resrestart", restartSingleResource)

function startSingleResource(thePlayer, commandName, resourceName)
	if (getElementData(thePlayer, "adminlevel") >= 5) then
		if not (resourceName) then
			outputChatBox("SYNTAX: /resstart [Resource Name]", thePlayer, 255, 194, 14)
		else
			local theResource = getResourceFromName(tostring(resourceName))
			if (theResource) then
				if getResourceState(theResource) == "running" then
					outputChatBox("Resource " .. resourceName .. " is already started.", thePlayer, 0, 255, 0)
				elseif getResourceState(theResource) == "loaded" then
					startResource(theResource, true)
					outputChatBox("Resource " .. resourceName .. " was started.", thePlayer, 0, 255, 0)
					displayAdminM("AdmScript: " .. getPlayerName(thePlayer) .. " started the resource '" .. resourceName .. "'.")
				elseif getResourceState(theResource) == "failed to load" then
					outputChatBox("Resource " .. resourceName .. " could not be loaded (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0)
				else
					outputChatBox("Resource " .. resourceName .. " could not be started (" .. getResourceState(theResource) .. ")", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Resource not found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("resstart", startSingleResource)