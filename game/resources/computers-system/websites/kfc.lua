-------------------
-- WEBSITE TITLE --
-------------------

-- Website owner's forum name: joker877
-- Website owner's Character's name: Chen Kang

local design = {
	bgcol = 87,
	outline = {
		colours = { border = 125, body = 1 },
		x = 100,
		y = 0,
		border_width = 2
	},
	horline = {
		colour = 92,
		x = 72,
		y = 161,
		thickness = 24
	},
	logo = {
		name = "kangfishing",
		margin_left = 80,
		margin_top = 0,
		width = 150,
		height = 160,
	},
	
	header = { colour = { 0, 0, 128 }, font = "default-bold-small" },
	text = { colour = { 16, 16, 72 }, font = "default-small" },
	link = {
		active = { colour = { 16, 16, 72 }, font = "default-small"},
		this = { colour = { 0, 0, 72 }, font = "default-bold-small" }
	},
	
	pages = {
		{
			name = "Home",
			data = {
				{
					header = "A brief history",
					text =
					[[Kang Fishing Corporation has a long history in the Mekong Delta(as Kang Fish Corp.), where Chen Kang lived for 23 years. His company has been built up into a major fish provider for most parts of South East Asia and with major contracts in Japan. They operate mainly in Vietnam and Thailand, along the Mekong River, where the local waters provide a bountiful catch.
					
					Chen moved to the city of Los Santos, San Andreas in 2009 with hopes of expanding his company. He had no knowledge of English, but with study he learned it in only six months! Contacting a business partner, Chen was able to acquire a small loan and purchase the property he needed to build up what has become Kang Fishing Corporation as we know it today. Kang Fishing Corporation operates mainly around the Docks area of Los Santos, their warehouse is located on the corner of Pacific Ave and Mast Road.]],
					
					textlinepp = 0 -- just a little safeguard to see if all text is shown, rendered useless when i changed the font to a smaller one. this adds some lines to the text label. use only if text not seen, else leave 0
				}
			}
		},
		{
			name = "Application",
			data = {
				{
					header = "Copy and fill in this form.",
					text =
					[[Please send your application to kang@whiz.sa]],
					textlinepp = 0 -- just a little safeguard to see if all text is shown, rendered useless when i changed the font to a smaller one. this adds some lines to the text label. use only if text not seen, else leave 0
				}
			}
		},
		{
			name = "Contact Info",
			data = {
				{
					header ="",
					text =
					[[Chen Kang
					Kang Fishing Corporation
					kang@whiz.sa
					52480]],
					textlinepp = 3 -- just a little safeguard to see if all text is shown, rendered useless when i changed the font to a smaller one. this adds some lines to the text label. use only if text not seen, else leave 0
				}
			}
		}
	},
	
	links = {
		{
			name = "Home",
			linkto = "www.kfc.sa"
		},
		{
			name = "Job Application",
			linkto = "www.kfc.sa/application"
		},
		{
			name = "Contact Info",
			linkto = "www.kfc.sa/contact"
		}
	}
}

function kfc_handle_page(page) 

	local page_length = 765

	guiSetText(internet_address_label, "Kang's Fishing Corporation - "..design.pages[page].name)

	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/"..design.bgcol..".png",false,internet_pane)

	local outline_border = guiCreateStaticImage(design.outline.x-design.outline.border_width, design.outline.y, design.outline.border_width*2+(660-(2*design.outline.x)), page_length, "websites/colours/"..design.outline.colours.border..".png", false, bg) guiSetEnabled(outline_border, false)
	local outline_body = guiCreateStaticImage(design.outline.x, design.outline.y, 660-(2*design.outline.x), page_length, "websites/colours/"..design.outline.colours.body..".png", false, bg) guiSetEnabled(outline_body, false)
	
	local logo = guiCreateStaticImage(design.outline.x+design.logo.margin_left, design.outline.y+design.logo.margin_top, design.logo.width, design.logo.height, "websites/images/"..design.logo.name..".png", false, bg)
	
	local horline = guiCreateStaticImage(design.horline.x, design.horline.y, 660-(2*design.horline.x), design.horline.thickness, "websites/colours/"..design.horline.colour..".png", false, bg) guiSetEnabled(horline, false)

	local link = {}

	for i = 1,#design.links do
		local tmp_width, tmp_height = math.ceil(660-(2*design.outline.x)/#design.links), design.horline.thickness
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
	
	if page == 2 then
		local tmp_height = 128
		local app = guiCreateMemo(gridsize.x.min, gridsize.y.min+spaceused, gridsize.x.max-gridsize.x.min, tmp_height,
			[[Name:
			Age:
			Address:
			Phone Number:
			Reference (Supervisor, Company, Phone number):
			Do you have your drivers license? Y/N
			Have you ever been convicted of a crime that resulted in jail time? Y/N]],
			false, bg)
			spaceused = spaceused + tmp_height
	end
	
	page_length = spaceused+gridsize.y.min-48
	
	local sign = guiCreateLabel(575, 350, 70, 48, "Designed by\nCross\ncross@whiz.sa", false, bg)
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

function www_kfc_sa()
	guiSetText(address_bar,"www.kfc.sa")
	kfc_handle_page(1)
end

function www_kfc_sa_application()
	guiSetText(address_bar,"www.kfc.sa/appication")
	kfc_handle_page(2)
end

function www_kfc_sa_contact()
	guiSetText(address_bar,"www.kfc.sa/contact")
	kfc_handle_page(3)
end
