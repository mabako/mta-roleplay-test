local sx, sy = guiGetScreenSize( )
local guielements = { } -- list of elements that should be deleted when leaving the current menu
local camera, cameraview = {}, 0 -- camera table and the current view id
cameraupdatetimer = nil -- timer when the camera view should be switched to the next one
local exitMenuFunc -- function called when exiting the menu

local function setCameraView( view )
	if view then
		cameraview = view
		
		if isTimer( cameraupdatetimer ) then
			killTimer( cameraupdatetimer )
			cameraupdatetimer = nil
		end
	else
		cameraview = ( cameraview % #camera ) + 1
	end
	
	-- set the camera view immediately
	local function setView( fade )
		local activeCam = camera[cameraview]
		local x, y, z = unpack( activeCam.matrix )
		setElementPosition( localPlayer, x, y, z - 2 )
		setElementInterior( localPlayer, activeCam.interior )
		setElementDimension( localPlayer, activeCam.dimension )
		
		setCameraMatrix( unpack( activeCam.matrix ) )
		setCameraInterior( activeCam.interior )
		setElementFrozen( localPlayer, true )
		
		-- optionally: fadeout
		if fade then
			fadeCamera( true, 1 )
		end
	end
	
	if view then -- if we want to switch to a specific view, use this
		setView( false )
	else -- next view
		fadeCamera( false, 1 )
		setTimer( setView, 1000, 1, true )
	end
end

local function findParent( start, node, usemultipage )
	if type( start ) == "table" then
		if start == node then
			return true
		else
			for key, value in pairs( start ) do
				local found = findParent( value, node, usemultipage )
				if found == true then
					if start.multi then
						if not usemultipage then
							return true
						else
							return start
						end
					else
						return start
					end
				elseif type( found ) == "table" then
					return found
				end
			end
		end
	end
end

function createMenu( node )
	if node and type( node ) == "table" then
		if #node == 0 and not node.window then
			outputDebugString( "Node " .. node.name .. " has no contents." )
		else
			-- add a help window if ne need one
			if node.window then
				local width = node.window.width or 350
				local height = node.window.height or 160
				local y = sy / 2 - height
				if node.window.bottom then
					y = sy - height - 20
				end
				
				local window = guiCreateWindow( ( sx - width + 160 ) / 2, y, width, height, node.name, false )
				guiWindowSetMovable( window, false )
				guiWindowSetSizable( window, false )
				
				if node.window.func then
					node.window.func( window )
				end
				if node.window.text then
					local label = guiCreateLabel( 0.1, 0.15, 0.8, 0.75, node.window.text, true, window )
					guiLabelSetHorizontalAlign( label, "center", true )
				end
				
				-- add it to the gui elements list
				table.insert( guielements, window )
			end
			
			-- buttons
			local spacer = 5
			local x = -10
			local width = 170
			local height = 45
			
			local size = 0
			for key, value in ipairs( node ) do
				if not value.requirement or value.requirement( ) then
					size = size + 1
				end
			end
			
			-- check to see if we got a multi-page help
			local parent = findParent( help_menu, node, true )
			if type( parent ) == "table" and parent.multi then
				if parent[1] ~= node then
					size = size + 1
				end
				
				if parent[#parent] ~= node then
					size = size + 1
				end
			end
			
			local y = ( sy - ( size + 1 ) * height - size * spacer ) / 2
			
			for key, value in ipairs( node ) do
				if not value.requirement or value.requirement( ) then
					local button = guiCreateButton( x, y, width, height, value.name, false )
					
					-- modify text color and alpha
					guiSetProperty( button, "NormalTextColour", "FFFFFFFF" )
					guiSetAlpha( button, 0.85 )
					
					-- add it to the gui elements list
					table.insert( guielements, button )
					
					-- add possible handlers
					if value.onClick then
						addEventHandler( "onClientGUIClick", button,
							function( button, state )
								if button == "left" and state == "up" then
									value.onClick( )
								end
							end, false )
					end
					
					if #value > 0 or value.window then
						addEventHandler( "onClientGUIClick", button,
							function( button, state )
								if button == "left" and state == "up" then
									destroyMenu( )
									
									if value.multi then
										createMenu( value[1] )
									else
										createMenu( value )
									end
								end
							end
						)
					end
					
					-- adjust the Y-position for the next element
					y = y + height + spacer
				end
			end
			
			-- previous/next buttons
			if type( parent ) == "table" and parent.multi then
				-- find the id
				local id = 0
				for key, value in ipairs( parent ) do
					if value == node then
						id = key
						break
					end
				end
				
				if id > 0 then
					if id ~= 1 then
						local button = guiCreateButton( x, y, width, height, "Previous", false )
						
						-- modify text color and alpha
						guiSetProperty( button, "NormalTextColour", "FFFFFFFF" )
						guiSetAlpha( button, 0.85 )
						
						-- add it to the gui elements list
						table.insert( guielements, button )
						
						-- event handler to go back
						addEventHandler( "onClientGUIClick", button,
							function( button, state )
								if button == "left" and state == "up" then
									destroyMenu( )
									createMenu( parent[ id - 1 ] )
								end
							end
						)
						y = y + height + spacer
					end
					
					if id ~= #parent then
						local button = guiCreateButton( x, y, width, height, "Next", false )
						
						-- modify text color and alpha
						guiSetProperty( button, "NormalTextColour", "FFFFFFFF" )
						guiSetAlpha( button, 0.85 )
						
						-- add it to the gui elements list
						table.insert( guielements, button )
						
						-- event handler to go back
						addEventHandler( "onClientGUIClick", button,
							function( button, state )
								if button == "left" and state == "up" then
									destroyMenu( )
									createMenu( parent[ id + 1 ] )
								end
							end
						)
						y = y + height + spacer
					end
				end
			end
			
			local parent = findParent( help_menu, node, false )
			if parent == true then -- we're in the main menu
				local button = guiCreateButton( x, y, width, height, "Exit", false )
				
				-- modify text color and alpha
				guiSetProperty( button, "NormalTextColour", "FFFFFFFF" )
				guiSetAlpha( button, 0.85 )
				
				-- add it to the gui elements list
				table.insert( guielements, button )
				
				-- add exit handler
				addEventHandler( "onClientGUIClick", button,
					function( button, state )
						if button == "left" and state == "up" then
							triggerServerEvent( "exitHelp", localPlayer )
						end
					end
				)
			else
				local button = guiCreateButton( x, y, width, height, "< Back\n" .. parent.name, false )
				
				-- modify text color and alpha
				guiSetProperty( button, "NormalTextColour", "FFFFFFFF" )
				guiSetAlpha( button, 0.85 )
				
				-- add it to the gui elements list
				table.insert( guielements, button )
				
				-- add exit handler
				addEventHandler( "onClientGUIClick", button,
					function( button, state )
						if button == "left" and state == "up" then
							destroyMenu( )
							createMenu( parent )
						end
					end
				)
			end
			
			-- find an applicable camera matrix
			local look = node
			while not look.camera do
				look = findParent( help_menu, look )
				if look == true then
					look = help_menu
					break
				end
			end
			
			-- port there to make sure it's streamed in
			camera = look.camera
			setCameraView( 1 )
			if #camera > 1 then
				cameraupdatetimer = setTimer( setCameraView, 10000, 0 )
			end
			
			-- call the function that'd be called when the menu is created
			if node.onInit then
				node.onInit( )
			end
			
			-- save the function that should be triggered when you leave *this* menu
			if node.onExit then
				exitMenuFunc = node.onExit
			else
				exitMenuFunc = nil
			end
		end
	else
		ouputDebugString( "Unexpected Node" )
	end
end

function destroyMenu( )
	if exitMenuFunc then
		exitMenuFunc( )
		exitMenuFunc = nil
	end
	
	for key, value in pairs( guielements ) do
		destroyElement( value )
	end
	guielements = { }
end