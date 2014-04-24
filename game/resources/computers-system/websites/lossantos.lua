--------------------------------
-- lossantos.gov (Government) --
--------------------------------

-- Website owner's forum name: Fitz
-- Website owner's Character's name: Jonathon Fitzsimmons
-- Website builder's forum name: mabako
-- Website builder's Character's name: Natalie Stafford

local height = 397
local width = 675

local colors =
{
	text_background = 14,
	text_color = { 0, 0, 0 },
	link_color = { 51, 51, 102 },
	
	page_background = 32,
	
	title_background = 125,
	title_background2 = 87,
	title_color = { 255, 255, 255 }
}

local navigation =
{
	{
		name = "Navigation",
		{ "Announcements", "www.lossantos.gov" },
		{ "City Council", "www.lossantos.gov/city-council" },
		{ "Contact us!", false, "contact@lossantos.gov" }
	},
	{
		name = "Links",
		{ "LS Police Department", "www.lspd.gov" },
		{ "LS Emergency Services", "www.lses.gov" }
	}
}

local function setLink( element, url )
	if url then
		addEventHandler( "onClientGUIClick", element,
			function( button )
				if button == "left" then
					get_page( url )
				end
			end, false
		)
	end
end

local function setMail( element, to )
	if to then
		addEventHandler( "onClientGUIClick", element,
			function( button )
				if button == "left" then
					compose_mail( to )
				end
			end, false
		)
	end
end

local sites =
{
	[""] =
		function( )
			local articles = 
			{
				{
					title = "Palomino Creek Triathlon",
					content = "The Government of Los Santos is proud to sponsor the first Palomino Creek Triathlon. Just participate and try your best in swimming, running and cycling and win a prize of $25,000.",
					size = 50
				},
				{ 
					title = "The Street Art project", 
					content = "Legally express your creativity at the Skate Park\n\nCitizens of Los Santos, you are allowed to tag, remove or paint over other tags at the skate park legally. No more vandalism fines!",
					size = 60
				},
				{
					title = "New City-wide speed limits", 
					content = "As of today, the 22nd January 2010, new speed limits are in place in town. 40mph(60km/h) on most roads, 60mph(90km/h) on larger roads and 80mph(120km/h) on highways. Please update your GPS to show the current speed limit of the street you're driving in.",
					size = 80
				}
			}
			
			local x = 178
			local y = 79
			
			-- content area
			local header = guiCreateStaticImage( x + 10, y, width - x - 15, height - y, "websites/colours/" .. colors.text_background .. ".png", false, bg )
			local sx, sy = guiGetSize( header, false )
			guiSetEnabled( header, false )
			guiLabelSetColor( guiCreateLabel( 5, 5, sx - 10, 20, "Welcome to the Government of Los Santos' Website.", false, header ), unpack( colors.text_color ) )
			
			local contact = guiCreateLabel( x + 15, y + 25, sx - 10, 20, "If you want to contact us, let's go! >", false, bg )
			guiLabelSetColor( contact, unpack( colors.link_color ) )
			setMail( contact, "contact@lossantos.gov" )
			
			y = y + 50
			for _, value in ipairs( articles ) do
				local header = guiCreateStaticImage( x, y, width - x - 5, 20, "websites/colours/" .. colors.title_background .. ".png", false, bg )
				guiSetFont( guiCreateLabel( 4, 2, 150, 16, value.title, false, header ), "default-bold-small" )
				y = y + 20
				for i = 1, 9 do
					guiSetEnabled( guiCreateStaticImage( x + i, y, 1, i, "websites/colours/" .. colors.title_background2 .. ".png", false, bg ), false )
				end
				
				y = y + 3
				
				local content = guiCreateLabel( x + 15, y, width - x - 25, value.size, value.content, false, bg )
				guiLabelSetColor( content, unpack( colors.text_color ) )
				guiLabelSetHorizontalAlign( content, "left", true )
				y = y + value.size + 10
			end
		end,
	_city_council =
		function( )
			local x = 178
			local y = 79
			
			local header = guiCreateStaticImage( x + 10, y, width - x - 15, height - y, "websites/colours/" .. colors.text_background .. ".png", false, bg )
			guiSetEnabled( header, false )
			
			--
			
			local people =
			{
				0.5,
				{
					name = "Mayor\nJonathon Fitzsimmons",
					mail = "j.fitzsimmons@lossantos.gov",
					skin = 187
				},
				{
					name = "City Manager\nGrant Thompson",
					mail = "GrantThompson@lossantos.gov",
					skin = 240
				},
				1,
				{
					name = "Public Relations Officer\nDaniella Filippi",
					mail = false,
					skin = 150
				},
				{
					name = "Head of Security\nEnzo DeLuca",
					mail = "e.deluca@lossantos.gov",
					skin = 240
				},
				0.5
			}
			
			x = x + 10
			y = y + 10
			local boxwidth = ( width - x - 45 ) / 3
			
			local inc = 0
			for count, value in ipairs( people ) do
				if value then
					if type( value ) == "number" then
						inc = inc + value
					else
						local row = math.floor( inc / 3 )
						local column = inc % 3
						
						-- draw a box
						local box = guiCreateStaticImage( x + column * ( boxwidth + 10 ) + 10, y + row * ( boxwidth + 10 ), boxwidth, boxwidth, "websites/colours/" .. colors.page_background .. ".png", false, bg )
						setMail( box, value.mail )
						
						-- skin pic
						local mx = ( boxwidth - 86 ) / 2
						local my = ( boxwidth - 90 - 40 ) / 2
						setMail( guiCreateStaticImage( 0, 0, 85, 91, ":account-system/img/" .. value.skin .. ".png", false, guiCreateStaticImage( 1, 1, 85, 90, "websites/colours/" .. colors.text_background .. ".png", false, guiCreateStaticImage( mx, my, 85 + 2, 90 + 2, "websites/colours/" .. colors.title_background .. ".png", false, box ) ) ), value.mail )
						
						-- who's it again?
						local label = guiCreateLabel( 5, boxwidth - 40, boxwidth - 10, 33, value.name, false, box )
						guiLabelSetHorizontalAlign( label, "center", true )
						guiLabelSetColor( label, unpack( colors.text_color ) )
						setMail( label, value.mail )
						
						inc = inc + 1
					end
				end
			end
		end
}

for key, value in pairs( sites ) do
	_G['www_lossantos_gov' .. key] =
		function( )
			guiSetText( internet_address_label, "The Government of Los Santos - Waterwolf" )
			
			bg = guiCreateStaticImage( 0, 0, width, height, "websites/colours/" .. colors.page_background .. ".png", false, internet_pane )

			-- left column - navigation
			local left = guiCreateStaticImage( 5, 0, 158, height, "websites/colours/" .. colors.text_background .. ".png", false, bg )
			guiSetEnabled( left, false )
			
			setLink( guiCreateStaticImage( 10, 5, 148, 143, "websites/images/city-of-ls-seal.png", false, bg ), "www.lossantos.gov" )
			
			local y = 158
			for _, category in ipairs( navigation ) do
				local header = guiCreateStaticImage( 5, y, 168, 20, "websites/colours/" .. colors.title_background .. ".png", false, bg )
				guiSetFont( guiCreateLabel( 4, 2, 150, 16, category.name, false, header ), "default-bold-small" )
				
				-- some effect
				for i = 1, 10 do
					guiSetEnabled( guiCreateStaticImage( 162 + i, y + 20, 1, 10 - i, "websites/colours/" .. colors.title_background2 .. ".png", false, bg ), false )
				end
				
				y = y + 5
				
				for _, link in ipairs( category ) do
					y = y + 18
					local element = guiCreateLabel( 10, y, 148, 20, link[1], false, bg )
					guiLabelSetColor( element, unpack( colors.link_color ) )
					if link[2] then
						setLink( element, link[2] )
					elseif link[3] then
						setMail( element, link[3] )
					end
				end
				y = y + 40
			end
			y = nil
			
			-- top menu
			local x = 178
			local top_bg = guiCreateStaticImage( x, 5, width - x - 5, 74, "websites/colours/" .. colors.title_background .. ".png", false, bg )
			guiCreateStaticImage( ( width - x - 304 - 5 ) / 2, 5, 304, 64, "websites/images/lsgov-logo.png", false, top_bg )
			y = 79
			for i = 1, 9 do
				guiSetEnabled( guiCreateStaticImage( x + i, y, 1, i, "websites/colours/" .. colors.title_background2 .. ".png", false, bg ), false )
			end
			-- content area
			value()
			
			-- misc shizzle
			guiSetSize( bg, width, height, false )
			guiScrollPaneSetScrollBars( internet_pane, false, false )
		end
end