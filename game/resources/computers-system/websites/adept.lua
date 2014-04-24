-------------------
-- WEBSITE TITLE --
-------------------

-- Website owner's forum name: Soafy
-- Website owner's Character's name: Jerry Cavaro

local design = {
	bgcol = 26,
	outline = {
		colours = { border = 92, body = 1 },
		x = 80,
		y = 0,
		border_width = 2
	},
	horline = {
		colour = 92,
		x = 72,
		y = 121,
		thickness = 24
	},
	logo = {
		name = "adeptsecurity",
		margin_left = 80,
		margin_top = 0,
		width = 200,
		height = 120,
	},
	
	header = { colour = { 24, 24, 24 }, font = "default-bold-small" },
	text = { colour = { 16, 16, 16 }, font = "default-small" },
	link = {
		active = { colour = { 30, 144, 255 }, font = "default-small"},
		this = { colour = { 30, 144, 255 }, font = "default-bold-small" }
	},
	
	pages = {
		{
			name = "Home",
			data = {
				{
					header = "",
					text =
					[[Have you ever been ROBBED or CONCERNED about your current property? Did something FRUSTRATING or INCONVIENT happen on your PROPERTY? Need some extra POWER over your items? Maybe your department is lacking NESSISCARY EQUIPMENT ? 
					
					Adept Security Systems provides a solution to your problems regarding burglaries, legal issues, self protection, and Law Enforcement assistance equipment.
					
					Our cameras can be used for evidence in a court of San Andreas, or used to identify a wanted person for the crime of Burgulary. There's a wide variety of what they can be used for. 
					
					Objective: Adept Security Systems is a small organization specialized in installing security cameras, linking the cameras to send live and recorded feed to a database, which then is sent over a secured network to the desired option to display video from the security cameras. We've been established in Los Santos since 2010. Cavaro Security Systems recently moved to Los Santos after facing a spikeout in Northern California. We are strong willed, passionate about our business, appreciate and enjoy the trading we do with paying customers.]],
					textlinepp = 0 -- just a little safeguard to see if all text is shown, rendered useless when i changed the font to a smaller one. this adds some lines to the text label. use only if text not seen, else leave 0
				},
			}
		},
		{
			name = "Security Cameras",
			data = {
				{
					header = "Step One: Choose a Protection Plan",
					text =
					[[*Skip Step One and proceed to "Other Items" or "Military Equipment" if you do not wish to purchase Security Surveillance Cameras
										
					Protection Plans
					
					Low Protection : Some walls, some rooms, some corners.No outside coverage. Set price $3,000
					
					Medium Protection : Most walls , Most rooms, Most Corners. No outside coverage. Set price $8,000
					
					Maximum Protection : ALL walls, ALL rooms, ALL corners, COMPLETE outside coverage. Set price $20,000
					__________________________________________________ ________________]],
					textlinepp = 0
				},
				{
					header = "Step Two: Decide Which equipment you wish to purchase",
					text =
					[[Surveillance Security Cameras
					
					*Note: Requires Database to view footage
					
					(These cameras can't picture out facial details, or any other small or specific details.)
					
					    * $100ea. Low Definition 360p. 10fps. Black and White. Con: Cannot make out face. Too blurry.
					    * $250ea. Med Definition 480p. 20fps. Black and White. Con: Barley make out face, slightly better than 360p
					__________________________________________________ ___________________
					
					(These cameras picture out details very well and screens are bullet-proof from from approximately 5-10 .257Cal or weaker bullets.
					
					    * $500ea. High Definition 720p. 30fps. Color. Con: Not able to read text, blinded by darkness.
					    * $1,000ea. Superb Definition. 1080p. 50fps. Night Vision Equipped. Tint around Camera to hide pointing position. Color. Con: Unable to see very tiny details.
					__________________________________________________ ______________________]],
					textlinepp = 0
				},
				{
					header = "Security System Database",
					text =
					[[*Note: Must purchase cameras to purchase a Database
					The amount of time before one's memory is filled up depends on the camera, receiver, and amout of cameras. (( Generic Item ))
					
					GB = Gigabyte TB = Terabyte
					
					    * $200 - 1GB
					    * $400 - 2GB
					    * $800 - 4GB
					    * $1,400 -8GB
					    * $1,900 -16GB
					    * $3,100 - 32GB
					    * $5000 - 64GB
					    * $8000 - 128GB
					    * $35,000 1TB = 1024GB]],
					textlinepp = 4
				}
			}
		},
		{
			name = "Other Items",
			data = {
				{
					header = "Recievers",
					text = "Things to watch Security Camera Footage on can be chosen to work on any display device that can receive RF signals, and then be set up by our employees. $750",
					textlinepp = 0
				},
				{
					header = "Car Tracking Device Kits",
					text = "$10.000 Includes Sender Node and Reciever Node, works in a 25 mile Radius.",
					textlinepp = 0
				},
				{
					header = "House Alarm Systems",
					text = "$5.000",
					textlinepp = 1
				},
				{
					header = "Suggestive Electronics",
					text = "We are able to provide any other security cameras featuring video playback, bullet proof carrying cases , private alarm systems, much more. We do not feature these items in Los Santos. If you wish to purchase any of these Systems, or if you think you need a Security System, and we haven't listed it here, please E-Mail us. There is a very high probability that we have the product in our master warehouse in Chattanooga, Tennessee. They are sent to a private plane for next day delivery, to San Fierro. Boarded on a train to Los Santos, then arrives at our warehouse.We are next day delivery, and can have orders shipped to your residence.",
					textlinepp = 0
				}
			}
		},
		{
			name = "Contact Info",
			data = {
				{
					header = "",
					text = [[If you wish to purchase equip yourself with Adept Security Systems, please,

							E-mail Jerry Cavaro at adept@whiz.sa with the format below We work Monday thru Thursday 14:45 - 0:00]],
					textlinepp = 0
				},
				{
					header = "E-mail Order Format",
					text = [[Your Full Name
							Your Phone Number
							The Location and Address of the site
							Amount/Type of Cameras needed to be installed ( Unless buying speical )
							Database: ( If buying Cameras )
							Type of Building ( House , Garage, Office Building, etc )
							Coverage Plan ( Low, Medium , Maximum )
							Other Items purchasing : ( If any )
							Total Calculated Price : ( Add up listed fees. Incorrect price will be fixed ) ]],
					textlinepp = 0
				},
				{
					header = "Example",
					text = [[Your Full Name: John Doe
							Your Phone Number : 55555
							The Location and Address of the site : 5 Apple St. Jefferson
							Amount/Type of Cameras needed to be installed: 10 Superb
							Database: 64 GB
							Type of Building : House
							Coverage Plan : Maximum
							Other Items purchasing : 2 Car Tracking Devices
							Total Price: $55,000]],
					textlinepp = 1
				}
			}
		}
	},
	
	links = {
		{
			name = "Home",
			linkto = "www.adept.sa"
		},
		{
			name = "Security Cameras",
			linkto = "www.adept.sa/cameras"
		},
		{
			name = "Other Items",
			linkto = "www.adept.sa/other"
		},
		{
			name = "Contact Info",
			linkto = "www.adept.sa/contact"
		}
	}
}

function adept_handle_page(page) 

	local page_length = 765

	guiSetText(internet_address_label, "Adept Security Systems - "..design.pages[page].name)

	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/"..design.bgcol..".png",false,internet_pane)

	local outline_border = guiCreateStaticImage(design.outline.x-design.outline.border_width, design.outline.y, design.outline.border_width*2+(660-(2*design.outline.x)), page_length, "websites/colours/"..design.outline.colours.border..".png", false, bg) guiSetEnabled(outline_border, false)
	local outline_body = guiCreateStaticImage(design.outline.x, design.outline.y, 660-(2*design.outline.x), page_length, "websites/colours/"..design.outline.colours.body..".png", false, bg) guiSetEnabled(outline_body, false)
	
	local logo = guiCreateStaticImage(design.outline.x+design.logo.margin_left, design.outline.y+design.logo.margin_top, design.logo.width, design.logo.height, "websites/images/"..design.logo.name..".png", false, bg)
	
	local horline = guiCreateStaticImage(design.horline.x, design.horline.y, 660-(2*design.horline.x), design.horline.thickness, "websites/colours/"..design.horline.colour..".png", false, bg) guiSetEnabled(horline, false)

	local link = {}

	for i = 1,#design.links do
		local tmp_width, tmp_height = 660-(2*design.outline.x)/#design.links, design.horline.thickness
		local tmp_x = i*((660-(2*design.outline.x))/#design.links)
		
		link[i] = guiCreateLabel(tmp_x, design.horline.y, tmp_width, tmp_height, design.links[i].name, false, bg)
		guiLabelSetVerticalAlign(link[i], "center")
		if page == i then guiLabelSetColor(link[i], unpack(design.link.this.colour)) guiSetFont(link[i], design.link.this.font) 
		else guiLabelSetColor(link[i], unpack(design.link.active.colour)) guiSetFont(link[i], design.link.active.font) end

		addEventHandler("onClientGUIClick",link[i],function()
			local url = tostring(design.links[i].linkto)
			get_page(url)
		end,false)
	
	end

	local gridsize = {
		x = { min = design.outline.x + 10, max = 660-(design.outline.x+10) },
		y = { min = design.horline.y+design.horline.thickness+16, max = page_length }
	}
	
	local header, text, spaceused = {}, {}, 0
	
	local lpl = math.ceil((gridsize.x.max-gridsize.x.min)/7) -- letters per line
	
	for i = 1,#design.pages[page].data do
		local linecount = math.ceil(#design.pages[page].data[i].text/lpl)+design.pages[page].data[i].textlinepp
		local tmp_height = 16*linecount
		
		header[i] = guiCreateLabel(gridsize.x.min, gridsize.y.min+spaceused, gridsize.x.max-gridsize.x.min, 16, design.pages[page].data[i].header, false, bg)
		guiLabelSetColor(header[i], unpack(design.header.colour)) guiSetFont(header[i], design.header.font) spaceused = spaceused + 16
		
		text[i] = guiCreateLabel(gridsize.x.min, gridsize.y.min+spaceused, gridsize.x.max-gridsize.x.min, tmp_height, design.pages[page].data[i].text, false, bg)
		guiLabelSetColor(text[i], unpack(design.text.colour)) guiSetFont(text[i], design.text.font) guiLabelSetHorizontalAlign (text[i], "left", true) spaceused = spaceused + tmp_height
		
	end
	
	page_length = spaceused+gridsize.y.min+16
	
	local sign = guiCreateLabel(660-75,page_length-48,70, 48, "Designed by\nCross\ncross@whiz.sa", false, bg)
	guiSetFont(sign, "default-small")
	----------------------------------------------- End of webpage design -- Do not edit below this line. -----------------------------------------------
	
	if(page_length>=397)then
		guiSetSize(bg,660,page_length,false)
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end

function www_adept_sa()
	guiSetText(address_bar,"www.adept.sa")
	adept_handle_page(1)
end

function www_adept_sa_cameras()
	guiSetText(address_bar,"www.adept.sa/cameras")
	adept_handle_page(2)
end

function www_adept_sa_other()
	guiSetText(address_bar,"www.adept.sa/other")
	adept_handle_page(3)
end

function www_adept_sa_contact()
	guiSetText(address_bar,"www.adept.sa/contact")
	adept_handle_page(4)
end