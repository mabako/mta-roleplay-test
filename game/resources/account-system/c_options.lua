function options_enable()
	toggleControl("change_camera", false)
	
	keys = getBoundKeys("change_camera")
	for name, state in pairs(keys) do
		if ( name ~= "home" ) then
			bindKey(name, "down", options_cameraWorkAround)
		else
			unbindKey(name)
		end
	end
	
	addCommandHandler("home", options_showmenu)
	bindKey("F10", "down", "home")
end
addEventHandler("accounts:options",getRootElement(),options_enable)

function options_disable()
	removeCommandHandler("home", options_showmenu)
	unbindKey("home", "down", "home")
	unbindKey("F10", "down", "home")
end

local wOptions,bChangeCharacter,bStreamerSettings,bGraphicsSettings,bAccountSettings,bLogout = nil
local wGraphicsMenu,cLogsEnabled,cMotionBlur,cSkyClouds,cStreamingAudio,bGraphicsMenuClose,sVehicleStreamer,sPickupStreamer,lVehicleStreamer,lPickupStreamer,gameMenuLoaded = nil

function isCameraOnPlayer()
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if vehicle then
		return getCameraTarget( ) == vehicle
	else
		return getCameraTarget( ) == getLocalPlayer()
	end
end

function options_showmenu()
	if wOptions then
		options_closemenu()
		return
	end
	
	if getElementData(getLocalPlayer(), "exclusiveGUI") or not isCameraOnPlayer() then
		return
	end
	setElementData(getLocalPlayer(), "exclusiveGUI", true, false)
	triggerEvent("onSapphireXMBShow", getLocalPlayer())
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 254, 140
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	
	showCursor(true)
	
	wOptions = guiCreateWindow(left, top, windowWidth, windowHeight, "Options Menu", false)
	guiWindowSetSizable(wOptions, false)
	
	bChangeCharacter = guiCreateButton(10, 30, 231, 23, "Change character", false, wOptions)
	addEventHandler("onClientGUIClick", bChangeCharacter,
		function ()
			if not isPlayerDead ( getLocalPlayer() ) and isCameraOnPlayer() then
				options_logOut( )
			end
			options_closemenu()
		end, false)
	
	bGraphicsSettings = guiCreateButton(10, 65, 231, 23, "Game settings", false, wOptions)
	addEventHandler("onClientGUIClick", bGraphicsSettings, options_opengraphicsmenu, false)
	--bAccountSettings = guiCreateButton(10, 105, 231, 23, "Account settings", false, wOptions)
	--bLogout = guiCreateButton(10, 145, 231, 23, "Logout", false, wOptions)
	bClose = guiCreateButton(10, 100, 231, 23, "Close", false, wOptions)
	addEventHandler("onClientGUIClick", bClose, options_closemenu, false)
end

function options_closemenu()
	if (wGraphicsMenu) then
		options_closegraphicsmenu()
	end
	
	showCursor(false)
	if wOptions then
		destroyElement(wOptions)
		wOptions = nil
	end
	setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
end

function options_cameraWorkAround()
	setControlState("change_camera", true)
end


function options_opengraphicsmenu()
	gameMenuLoaded = false
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 200, 320
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	
	guiSetEnabled(wOptions, false)
	
	wGraphicsMenu = guiCreateWindow(left, top, windowWidth, windowHeight, "Game options", false)
	guiWindowSetSizable(wGraphicsMenu, false)
	
	cMotionBlur = guiCreateCheckBox(10, 25, 290, 17, "Enable motion blur", false, false, wGraphicsMenu)
	addEventHandler("onClientGUIClick", cMotionBlur, options_updateGameConfig)
	
	cSkyClouds = guiCreateCheckBox(10, 45, 290, 17, "Enable Sky clouds", false, false, wGraphicsMenu)
	addEventHandler("onClientGUIClick", cSkyClouds, options_updateGameConfig)
	
	cStreamingAudio = guiCreateCheckBox(10, 65, 290, 17, "Enable streaming audio", false, false, wGraphicsMenu)
	addEventHandler("onClientGUIClick", cStreamingAudio, options_updateGameConfig)
	
	lVehicleStreamer = guiCreateCheckBox ( 10, 95, 290, 17, "Vehicle streamer: Disabled", false, false, wGraphicsMenu )
	addEventHandler("onClientGUIClick", lVehicleStreamer, options_updateGameConfig)
	
	sVehicleStreamer = guiCreateScrollBar(10, 110, 290, 17, true, false, wGraphicsMenu)
	addEventHandler("onClientGUIScroll", sVehicleStreamer, options_GameConfig_updateScrollbars)
	
	lPickupStreamer = guiCreateCheckBox ( 10, 125, 290, 17, "Interior streamer: Disabled", false, false, wGraphicsMenu )
	addEventHandler("onClientGUIClick", lPickupStreamer, options_updateGameConfig)
	
	sPickupStreamer = guiCreateScrollBar(10, 140, 290, 17, true, false, wGraphicsMenu)
	addEventHandler("onClientGUIScroll", sPickupStreamer, options_GameConfig_updateScrollbars)
	
	cLogsEnabled = guiCreateCheckBox(10, 160, 290, 17, "Logging of chat", false, false, wGraphicsMenu)
	addEventHandler("onClientGUIClick", cLogsEnabled, options_updateGameConfig)
	
	cBubblesEnabled = guiCreateCheckBox(10, 180, 290, 17, "Enable Chat bubbles", false, false, wGraphicsMenu)
	addEventHandler("onClientGUIClick", cBubblesEnabled, options_updateGameConfig)
	
	cIconsEnabled = guiCreateCheckBox(10, 200, 290, 17, "Enable typing icons", false, false, wGraphicsMenu)
	addEventHandler("onClientGUIClick", cIconsEnabled, options_updateGameConfig)
	
	cEnableNametags = guiCreateCheckBox(10, 220, 290, 17, "Enable nametags", false, false, wGraphicsMenu)
	addEventHandler("onClientGUIClick", cEnableNametags, options_updateGameConfig)
	
	cEnableRShaders = guiCreateCheckBox(10, 240, 290, 17, "Enable radar shader", false, false, wGraphicsMenu)
	addEventHandler("onClientGUIClick", cEnableRShaders, options_updateGameConfig)
	
	cEnableWShaders = guiCreateCheckBox(10, 260, 290, 17, "Enable water shader", false, false, wGraphicsMenu)
	addEventHandler("onClientGUIClick", cEnableWShaders, options_updateGameConfig)
	
	bGraphicsMenuClose = guiCreateButton(10, 285, 290, 23, "Close", false, wGraphicsMenu)
	addEventHandler("onClientGUIClick", bGraphicsMenuClose, options_closegraphicsmenu, false)
	--[[
	chatbubbles
	]]

	-- Put the current settings selected/active
	
	local vehicleStreamerEnabled = tonumber( loadSavedData("streamer-vehicle-enabled", "1") )
	if (vehicleStreamerEnabled) then
		guiCheckBoxSetSelected ( lVehicleStreamer, true )
	end
	
	local pickupStreamerEnabled = tonumber( loadSavedData("streamer-pickup-enabled", "1") )
	if (pickupStreamerEnabled) then
		guiCheckBoxSetSelected ( lPickupStreamer, true )
	end
	
	local blurEnabled = tonumber( loadSavedData("motionblur", "1") )
	if (blurEnabled == 1) then
		guiCheckBoxSetSelected ( cMotionBlur, true )
	end

	
	local skyCloudsEnabled = tonumber( loadSavedData("skyclouds", "1") )
	if (skyCloudsEnabled == 1) then
		guiCheckBoxSetSelected ( cSkyClouds, true )
	end 
	
	local streamingMediaEnabled = tonumber( loadSavedData("streamingmedia", "1") )
	if (streamingMediaEnabled == 1) then
		guiCheckBoxSetSelected ( cStreamingAudio, true )
	end
	
	local logsEnabled = tonumber( loadSavedData("logsenabled", "1") )
	if (logsEnabled == 1) then
		guiCheckBoxSetSelected ( cLogsEnabled, true )
	end
	
	local vehicleStreamerStatus = tonumber( loadSavedData("streamer-vehicle", "60") )
	if (vehicleStreamerStatus) then
		guiScrollBarSetScrollPosition(sVehicleStreamer, ((vehicleStreamerStatus-40)/2))
	end
	
	local pickupStreamerStatus = tonumber( loadSavedData("streamer-pickup", "25") )
	if (pickupStreamerStatus) then
		guiScrollBarSetScrollPosition(sPickupStreamer, (pickupStreamerStatus-10))
	end
	
	local isBubblesEnabled = tonumber( loadSavedData("chatbubbles", "1") )
	if (isBubblesEnabled == 1) then
		guiCheckBoxSetSelected ( cBubblesEnabled, true )
	end 
	
	local isChatIconsEnabled = tonumber( loadSavedData("chaticons", "1") )
	if (isChatIconsEnabled == 1) then
		guiCheckBoxSetSelected ( cIconsEnabled, true )
	end 
	
	local isNameTagsEnabled = tonumber( loadSavedData("shownametags", "1") )
	if (isNameTagsEnabled == 1) then
		guiCheckBoxSetSelected ( cEnableNametags, true )
	end 
	
	local isRShaderEnabled = tonumber( loadSavedData( "enable_radar_shader", "1") )
	if isRShaderEnabled == 1 then
		guiCheckBoxSetSelected ( cEnableRShaders, true )
	end
	
	local isWShaderEnabled = tonumber( loadSavedData( "enable_water_shader", "1") )
	if isWShaderEnabled == 1 then
		guiCheckBoxSetSelected ( cEnableWShaders, true )
	end

	gameMenuLoaded = true
	options_GameConfig_updateScrollbars()
end

function options_GameConfig_updateScrollbars()
	if (gameMenuLoaded) then
		local vehicleStreamerStatus = guiScrollBarGetScrollPosition(sVehicleStreamer)
		vehicleStreamerStatus = ((vehicleStreamerStatus) * 2) + 40
		
		local pickupStreamerStatus = guiScrollBarGetScrollPosition(sPickupStreamer)
		pickupStreamerStatus = pickupStreamerStatus + 10
		
		guiSetText(lVehicleStreamer, "Vehicle streamer: "..vehicleStreamerStatus.." meter")
		guiSetText(lPickupStreamer, "Interior streamer: "..pickupStreamerStatus.." meter")
		
		appendSavedData("streamer-vehicle", tostring(vehicleStreamerStatus))
		appendSavedData("streamer-pickup", tostring(pickupStreamerStatus))
		
		triggerEvent("accounts:options:settings:updated", getLocalPlayer())
	end
end

function options_updateGameConfig()
	if (guiCheckBoxGetSelected(cMotionBlur)) then
		appendSavedData("motionblur", "1")
	else
		appendSavedData("motionblur", "0")
	end
	
	if (guiCheckBoxGetSelected(cSkyClouds)) then
		appendSavedData("skyclouds", "1")
	else
		appendSavedData("skyclouds", "0")
	end
	
	if (guiCheckBoxGetSelected(cStreamingAudio)) then
		appendSavedData("streamingmedia", "1")
	else
		appendSavedData("streamingmedia", "0")
	end
	
	if (guiCheckBoxGetSelected(cLogsEnabled)) then
		appendSavedData("logsenabled", "1")
	else
		appendSavedData("logsenabled", "0")
	end
	
	if (guiCheckBoxGetSelected(lPickupStreamer)) then
		appendSavedData("streamer-pickup-enabled", "1")
	else
		appendSavedData("streamer-pickup-enabled", "0")
	end
	
	if (guiCheckBoxGetSelected(lVehicleStreamer)) then
		appendSavedData("streamer-vehicle-enabled", "1")
	else                 
		appendSavedData("streamer-vehicle-enabled", "0")
	end
	
	if (guiCheckBoxGetSelected(cBubblesEnabled)) then
		appendSavedData("chatbubbles", "1")
	else                 
		appendSavedData("chatbubbles", "0")
	end
	
	if (guiCheckBoxGetSelected(cIconsEnabled)) then
		appendSavedData("chaticons", "1")
	else                 
		appendSavedData("chaticons", "0")
	end	
	
	if (guiCheckBoxGetSelected(cEnableNametags)) then
		appendSavedData("shownametags", "1")
	else                 
		appendSavedData("shownametags", "0")
	end
	
	appendSavedData("enable_radar_shader", guiCheckBoxGetSelected(cEnableRShaders) and "1" or "0")
	appendSavedData("enable_water_shader", guiCheckBoxGetSelected(cEnableWShaders) and "1" or "0")

	triggerEvent("accounts:options:settings:updated", getLocalPlayer())
end

function options_closegraphicsmenu()
	if wGraphicsMenu then
		destroyElement(wGraphicsMenu)
		wGraphicsMenu = nil
	end
	guiSetEnabled(wOptions, true)
end

function options_logOut( message )
	triggerServerEvent("accounts:characters:change", getLocalPlayer(), "Change Character")
	triggerEvent("onClientChangeChar", getRootElement())
	options_disable()
	Characters_showSelection()
	clearChat()
	if message then 
		LoginScreen_showWarningMessage( message )
	end
end
addEventHandler("accounts:logout", getRootElement(), options_logOut)