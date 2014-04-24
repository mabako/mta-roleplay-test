-- Website owner's forum name: Eusebio
-- Website owner's Character's name: Eusebio_Fighetti
-- Website designer's forum name: Izanagi
-- Website designer's Character's name: Ryuunosuke_Yasogami

local design = 
{
	title =
	{
		"Gnocchi Ristorante - Home",
		"Gnocchi Ristorante - About Us",
		"Gnocchi Ristorante - Contact"
	},
	address =
	{
		"www.gnocchi.sa",
		"www.gnocchi.sa/about",
		"www.gnocchi.sa/contact"
	},
	background = 1,
	body = 90,
	body_shadow = 105,
	banner = "gnocchi-banner",
	navbar_color ={ 3, 1, 16 },
	link = 	{ "Home", "About Us", "Contact" },
	text_title = 
	{
		"Gnocchi Ristorante - Italian Traditions in Los Santos",
		"About the Gnocchi Ristorante",
		"How to contact us?"
	},
	text = 
	{ 
		"Gnocchi Ristorante is an High-Class italian restaurant, located in\
		Rodeo, on the street behind the Police Departament. It's a perfect \
		place to bring out your girlfriend, wife and friends or to meet your\
		business partners. We are trying bring the tradicional Italian foods\
		to Los Santos. ",
		"If you are looking for a place to have dinner or lunch, Gnocchi \
		Ristorante is the perfect place. Our bartenders, waitresses and \
		cooks are high skilled and are here to offer a high class service.",
		"For a slot reservation, renting for any event, contact us.\
		E-mail : GnocchiRistorante@saonline.sa\
		Telephone number : 1-800-40352"
	}
}
local page_width = 660

function gnocchi_showpage()
	
	-- Webpage Properties
	---------------------
	local page_length = 396
	local gnocchi_page = getElementData(getLocalPlayer(), "gnocchi.page")
	if gnocchi_page == false then gnocchi_page = 1 end
	setElementData(getLocalPlayer(), "gnocchi.page", gnocchi_page)
	
	guiSetText(internet_address_label, 	tostring(design.title[gnocchi_page]))
	guiSetText(address_bar, 			tostring(design.address[gnocchi_page]))
		
	-- Default page setup
	-------------------------
	bg = guiCreateStaticImage(0,0,page_width,page_length,"websites/colours/"..design.background..".png",false,internet_pane)
	local body_shadow = guiCreateStaticImage(95,0, page_width-190, page_length, "websites/colours/"..design.body_shadow..".png", false, bg)
	local body = guiCreateStaticImage(100,0, page_width-200, page_length, "websites/colours/"..design.body..".png", false, bg)
	local banner = guiCreateStaticImage(180,10,300,75,"websites/images/"..design.banner..".png", false, bg)
	
	local designer_link = guiCreateStaticImage(498, 53, 62, 47, "websites/images/izanagi-black.png", false, bg)
	
	addEventHandler("onClientGUIClick",designer_link,function()
		local url = tostring("www.izanagi.sa")
		get_page(url) 
		end,false)

	guiSetEnabled(body_shadow, false)
	guiSetEnabled(body, false)
	guiSetEnabled(banner, false)
	
	local shadow_navbar = {}
	local navbar = {}
	local navbar_link = {}
	for i = 1,3 do
	
		shadow_navbar[i] = guiCreateStaticImage(100+(math.floor((page_width-200)/3)*(i-1)), 100, math.floor((page_width-200)/3)+(1/3)+1, 30, "websites/colours/"..design.navbar_color[i]..".png", false, bg)
	
		navbar[i] = guiCreateStaticImage(100+(math.floor((page_width-200)/3)*(i-1)), 105, math.floor((page_width-200)/3)+(1/3)+1, 20, "websites/colours/0.png", false, bg)
	
		navbar_link[i] = guiCreateLabel(100+(math.floor((page_width-200)/3)*(i-1)), 105, math.floor((page_width-200)/3)+1, 20, design.link[i], false, bg)
		
		guiLabelSetHorizontalAlign(navbar_link[i], "center")
		guiLabelSetVerticalAlign(navbar_link[i], "top")
		guiSetFont(navbar_link[i], "clear-normal")
		
		guiSetEnabled(shadow_navbar[i], false)
		guiSetEnabled(navbar[i], false)
		guiSetEnabled(navbar_link[i], true)
		
		
	addEventHandler("onClientGUIClick",navbar_link[i],function()
		local url = tostring(design.address[i])
		get_page(url) 
		end,false)
		
	end
	-- Page-sensitive content
	local i = gnocchi_page
	
	local page_title = guiCreateLabel(120, 140,page_width-210, 20, design.text_title[i], false, bg)
	local page_text = guiCreateLabel(120, 160, page_width-210, 160, design.text[i], false, bg)
		
	guiSetFont(page_title, "default-bold-small")
	guiLabelSetHorizontalAlign(page_title, "left")
		
	guiSetFont(page_text, "clear-normal")
	guiLabelSetHorizontalAlign(page_text, "left")
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(bg, false, false)
	end
	
end

-- redirection

function www_gnocchi_sa()
	setElementData(getLocalPlayer(), "gnocchi.page", 1)
	gnocchi_showpage()
end

function www_gnocchi_sa_about()
	setElementData(getLocalPlayer(), "gnocchi.page", 2)
	gnocchi_showpage()
end

function www_gnocchi_sa_contact()
	setElementData(getLocalPlayer(), "gnocchi.page", 3)
	gnocchi_showpage()
end

--[[	"Gnocchi Ristorante is an italian restoraunt located in Rodeo. It's a perfect place for a meeting or to bring out your girlfriend or wife. We are trying to bring the delicious Italian foods to Los Santos.",
		"If you are looking for a place to have dinner or lunch, Gnocchi Ristorante is the perfect choice. Our bartenders, waitresses and cook are high skilled and are here to offer a high class service to our customers.",
		"Got questions? Unhappy with service? You can get your answers and send us your complaints by sending us an e-mail.\
		\
		You can contact us by sending an e-mail to Eusebio@saonline.sa"]]