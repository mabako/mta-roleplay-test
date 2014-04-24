-----------
-- Snake --
-----------

-- Website creator's forum name: mabako

local active = false
local lost = false
local screenX, screenY = guiGetScreenSize( )
local lastupdate = getTickCount( )
local moving = 0

local backgroundColor = tocolor( 20, 20, 20, 255 )
local lineColor = tocolor( 80, 80, 80, 255 )
local pickupColor = tocolor( 255, 255, 0, 255 )
local px = ( screenX - 30 * 21 ) / 2
local py = ( screenY - 20 * 21 ) / 2

local pickupPos = nil
repeat
	pickupPos = { x = math.random( 1, 30 ), y = math.random( 1, 20 ) }
until pickupPos.x ~= 15 or pickupPos.y ~= 10

local snake = { { x = 15, y = 10 } }

local function isOnSnake( x, y )
	for k, v in ipairs( snake ) do
		if v.x == x and v.y == y then
			return k
		end
	end
	return false
end

local function processPoint( x, y )
	if ( isOnSnake( x, y ) and ( #snake == 2 or isOnSnake( x, y ) ~= #snake ) ) or x < 1 or y < 1 or x > 30 or y > 20 then
		lost = getTickCount( )
	elseif pickupPos.x == x and pickupPos.y == y then
		local snake2 = { { x = x, y = y } }
		for k, v in ipairs( snake ) do
			snake2[ k + 1 ] = v
		end
		snake = snake2
		
		repeat
			pickupPos = { x = math.random( 1, 30 ), y = math.random( 1, 20 ) }
		until not isOnSnake( pickupPos.x, pickupPos.y )
		
	else
		local snake2 = { { x = x, y = y } }
		for i = 1, #snake - 1 do
			snake2[ i + 1 ] = snake[ i ]
		end
		snake = snake2
	end
end

local function doSnake( )
	-- process the game
	local tick = getTickCount( )
	if lost and tick - lost > 5000 then
		toggleSnake( )
		return
	elseif not lost and tick - lastupdate > 100 then
		lastupdate = tick
		if moving == 1 then -- moving up
			processPoint( snake[1].x, snake[1].y - 1 )
		elseif moving == 2 then
			processPoint( snake[1].x, snake[1].y + 1 )
		elseif moving == 3 then
			processPoint( snake[1].x - 1, snake[1].y )
		elseif moving == 4 then
			processPoint( snake[1].x + 1, snake[1].y )
		end
	end
	-- draw the board, 30x20
	for x = 1, 30 do
		for y = 1, 20 do
			local color = backgroundColor
			if pickupPos.x == x and pickupPos.y == y then
				color = pickupColor
			else
				local snakeID = isOnSnake( x, y )
				if snakeID then
					if lost then
						color = tocolor( ( #snake - snakeID + 1 ) / #snake * 127 + 127, 0, 0, 255 )
					else
						color = tocolor( 0, ( #snake - snakeID + 1 ) / #snake * 127 + 127, ( #snake - snakeID + 1 ) / #snake  * 127 + 128, 255 )
					end
				end
			end
			dxDrawRectangle( px + ( x - 1 ) * 21, py + ( y - 1 ) * 21, 20, 20, color, true )
		end
	end
	
	for x = 0, 30 do
		dxDrawLine( px - 1 + x * 21, py, px - 1 + x * 21, py + 20 * 21, lineColor, 1, true )
	end
	
	for y = 0, 20 do
		dxDrawLine( px, py - 1 + y * 21, px + 30 * 21, py - 1 + y * 21, lineColor, 1, true )
	end
end

local key1 = function( ) moving = 1 end
local key2 = function( ) moving = 2 end
local key3 = function( ) moving = 3 end
local key4 = function( ) moving = 4 end

function toggleSnake( )
	if active then
		removeEventHandler( "onClientRender", getRootElement( ), doSnake )
		active = false
		
		unbindKey( "arrow_u", "down", key1 )
		unbindKey( "arrow_d", "down", key2 )
		unbindKey( "arrow_l", "down", key3 )
		unbindKey( "arrow_r", "down", key4 )
		
		guiSetVisible( wInternet, true )
		guiSetVisible( wComputer, true )
		guiSetInputEnabled( true )
		showCursor( true )
	else
		guiSetVisible( wInternet, false )
		guiSetVisible( wComputer, false )
		guiSetInputEnabled( false )
		showCursor( true )
	
		lastupdate = getTickCount( )
		moving = 0
		repeat
			pickupPos = { x = math.random( 1, 30 ), y = math.random( 1, 20 ) }
		until pickupPos.x ~= 15 or pickupPos.y ~= 10

		snake = { { x = 15, y = 10 } }
		
		bindKey( "arrow_u", "down", key1 )
		bindKey( "arrow_d", "down", key2 )
		bindKey( "arrow_l", "down", key3 )
		bindKey( "arrow_r", "down", key4 )
		
		active = true
		lost = false
		addEventHandler( "onClientRender", getRootElement( ), doSnake )
	end
end

--

local height = 397
local width = 660
function www_snake_sa( )
	guiSetText(internet_address_label, "Snake - Waterwolf")
	guiSetText(address_bar,"www.snake.sa")
	bg = guiCreateStaticImage(0,0,width,height,"websites/colours/0.png",false,internet_pane)
	
	btn = guiCreateButton( ( width - 200 ) / 2, ( height - 50 ) / 2, 200, 50, "Play", false, bg )
	addEventHandler( "onClientGUIClick", btn,
		function( )
			if not active then
				toggleSnake( )
			end
		end,
		false
	)
end