---------------------------------------
-- GOLDSMITH ENTERTAINMENT HOME PAGE --
---------------------------------------

-- Website owner's forum name: Exciter
-- Website owner's Character's name: Jacob Goldsmith

function www_entertainment_sa()
	
	-- Webpage Properties
	---------------------
	local page_length = 501 -- Set the total length of your webpage in px (Max page height is 765px). This will determine whether your page will have a vertical scroll bar. 
	guiSetText(internet_address_label, "Goldsmith Entertainment Co.") -- This text is displayed at the top of the browser window when the page is opened. It is the same as the <title> tag used in the meta of a real webpage. Only change the text between the quotation marks.
	guiSetText(address_bar,"www.entertainment.sa") -- The url of the page. This should be the same as the function name but with the original "."s and "/". Example www.google.com.
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,460,page_length,"websites/colours/1.png",false,internet_pane) -- You only need to change the colour ID in the following line of code. The number you need to change is the digit directly before ".png" (in this case "0").
	
	------------
	-- Header --
	------------
	local banner = guiCreateStaticImage(0,0,460,60,"websites/colours/6.png",false,bg)
	local header = guiCreateLabel(10,5,400,40,"Goldsmith Entertainment Co.",false,banner)
	guiSetFont(header, "sa-header")
	
	----------
	-- Menu --
	----------
	local menu_link1 = guiCreateStaticImage(0,60,100,30,"websites/colours/46.png",false,bg)
	local menu_link1_txt = guiCreateLabel(5,5,90,20,"Home",false,menu_link1)
	guiLabelSetColor(menu_link1_txt,255,255,255)
	guiSetFont(menu_link1_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link1_txt,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link1,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link1_txt,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	
	local menu_link2 = guiCreateStaticImage(0,90,100,30,"websites/colours/46.png",false,bg)
	local menu_link2_txt = guiCreateLabel(5,5,90,20,"About",false,menu_link2)
	guiLabelSetColor(menu_link2_txt,255,255,255)
	guiSetFont(menu_link2_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link2_txt,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link2,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link2_txt,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	
	local menu_link3 = guiCreateStaticImage(0,120,100,30,"websites/colours/46.png",false,bg)
	local menu_link3_txt = guiCreateLabel(5,5,90,20,"Events",false,menu_link3)
	guiLabelSetColor(menu_link3_txt,255,255,255)
	guiSetFont(menu_link3_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link3_txt,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link3,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link3_txt,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	
	local menu_link4 = guiCreateStaticImage(0,150,100,30,"websites/colours/46.png",false,bg)
	local menu_link4_txt = guiCreateLabel(5,5,90,20,"Contact",false,menu_link4)
	guiLabelSetColor(menu_link4_txt,255,255,255)
	guiSetFont(menu_link4_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link4_txt,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link4,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link4_txt,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	
	-------------
	-- Content --
	-------------
	local mainHeading = guiCreateLabel(105,65,350,20,"Home",false,bg)
	guiLabelSetColor(mainHeading,0,0,0)
	guiSetFont(mainHeading, "default-bold-small")
	
	local news2wrap = guiCreateStaticImage(105,85,350,285,"websites/colours/0.png",false,bg)
	local news2 = guiCreateStaticImage(1,1,348,283,"websites/colours/1.png",false,news2wrap)
	
	local news2_text1 = guiCreateLabel(5,5,340,20,	"Visibility is Essential!",false,news2)
	guiLabelSetColor(news2_text1,0,0,0)
	guiSetFont(news2_text1, "default-bold-small")
	guiLabelSetHorizontalAlign(news2_text1, "left", false)
	
	local news2_img = guiCreateStaticImage(5,20,300,210,"websites/images/theatre.png",false,news2)
	
	local news2_text2 = guiCreateLabel(5,230,340,50, "One of the most important things for each entertainment business is to be visible. See our tips and offers on how to get your entertainment business known!",false,news2)
	guiLabelSetColor(news2_text2,0,0,0)
	guiLabelSetHorizontalAlign(news2_text2, "left", true)
	
	local news2_link = guiCreateLabel(5,265,340,20, "Read more...",false,news2)
	guiLabelSetColor(news2_link,0,20,255)
	guiLabelSetHorizontalAlign(news2_link, "right", false)
	local news2_link_line = guiCreateStaticImage(275,281,65,1,"websites/colours/1.png",false,news2)
	addEventHandler("onClientMouseEnter",news2_link,function()
		guiStaticImageLoadImage(news2_link_line, "websites/colours/2.png")
	end,false)
	addEventHandler("onClientMouseLeave",news2_link,function()
		guiStaticImageLoadImage(news2_link_line, "websites/colours/1.png")
	end,false)
	addEventHandler("onClientGUIClick",news2_link,function()
		local url = tostring("www.entertainment.sa/news/002")
		get_page(url)
	end,false)
	
	
	local news1wrap = guiCreateStaticImage(105,380,350,75,"websites/colours/0.png",false,bg)
	local news1 = guiCreateStaticImage(1,1,348,73,"websites/colours/1.png",false,news1wrap)
	
	local news1_text1 = guiCreateLabel(5,5,340,20,	"Job Openings",false,news1)
	guiLabelSetColor(news1_text1,0,0,0)
	guiSetFont(news1_text1, "default-bold-small")
	guiLabelSetHorizontalAlign(news1_text1, "left", false)
	
	local news1_text2 = guiCreateLabel(5,20,340,40, "Are you experienced and hard-working, and interested in working in the entertainment industry?",false,news1)
	guiLabelSetColor(news1_text2,0,0,0)
	guiLabelSetHorizontalAlign(news1_text2, "left", true)
	
	local news1_link = guiCreateLabel(5,55,340,20, "Read more...",false,news1)
	guiLabelSetColor(news1_link,0,20,255)
	guiLabelSetHorizontalAlign(news1_link, "right", false)
	local news1_link_line = guiCreateStaticImage(275,71,65,1,"websites/colours/1.png",false,news1)
	addEventHandler("onClientMouseEnter",news1_link,function()
		guiStaticImageLoadImage(news1_link_line, "websites/colours/2.png")
	end,false)
	addEventHandler("onClientMouseLeave",news1_link,function()
		guiStaticImageLoadImage(news1_link_line, "websites/colours/1.png")
	end,false)
	addEventHandler("onClientGUIClick",news1_link,function()
		local url = tostring("www.entertainment.sa/news/001")
		get_page(url)
	end,false)
	
	------------
	-- Footer --
	------------
	local footer = guiCreateStaticImage(0,461,460,40,"websites/colours/24.png",false,bg)
	local footer_txt = guiCreateLabel(10,5,440,30,"Copyright, Goldsmith Entertainment Company.\ P.O. 141, Marina, Los Santos. goldsmith@saonline.sa.",false,footer)
	guiLabelSetColor(footer_txt,255,255,255)
	guiSetFont(footer_txt, "default-small")
	
	----------------------------------------------- End of webpage design -- Do not edit below this line. -----------------------------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,460,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end


function www_entertainment_sa_about()
	
	-- Webpage Properties
	---------------------
	local page_length = 765 
	guiSetText(internet_address_label, "Goldsmith Entertainment Co.")
	guiSetText(address_bar,"www.entertainment.sa/about")
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,460,page_length,"websites/colours/1.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local banner = guiCreateStaticImage(0,0,460,60,"websites/colours/6.png",false,bg)
	local header = guiCreateLabel(10,5,400,40,"Goldsmith Entertainment Co.",false,banner)
	guiSetFont(header, "sa-header")
	
	----------
	-- Menu --
	----------
	local menu_link1 = guiCreateStaticImage(0,60,100,30,"websites/colours/46.png",false,bg)
	local menu_link1_txt = guiCreateLabel(5,5,90,20,"Home",false,menu_link1)
	guiLabelSetColor(menu_link1_txt,255,255,255)
	guiSetFont(menu_link1_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link1_txt,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link1,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link1_txt,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	
	local menu_link2 = guiCreateStaticImage(0,90,100,30,"websites/colours/46.png",false,bg)
	local menu_link2_txt = guiCreateLabel(5,5,90,20,"About",false,menu_link2)
	guiLabelSetColor(menu_link2_txt,255,255,255)
	guiSetFont(menu_link2_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link2_txt,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link2,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link2_txt,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	
	local menu_link3 = guiCreateStaticImage(0,120,100,30,"websites/colours/46.png",false,bg)
	local menu_link3_txt = guiCreateLabel(5,5,90,20,"Events",false,menu_link3)
	guiLabelSetColor(menu_link3_txt,255,255,255)
	guiSetFont(menu_link3_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link3_txt,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link3,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link3_txt,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	
	local menu_link4 = guiCreateStaticImage(0,150,100,30,"websites/colours/46.png",false,bg)
	local menu_link4_txt = guiCreateLabel(5,5,90,20,"Contact",false,menu_link4)
	guiLabelSetColor(menu_link4_txt,255,255,255)
	guiSetFont(menu_link4_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link4_txt,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link4,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link4_txt,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	
	-------------
	-- Content --
	-------------
	local mainHeading = guiCreateLabel(105,65,350,20,"About",false,bg)
	guiLabelSetColor(mainHeading,0,0,0)
	guiSetFont(mainHeading, "default-bold-small")
	
	local mainText = guiCreateLabel(105,85,350,80,	"Goldsmith Entertainment Company is actively operating in the entertainment industry. This is done by the hosting of events, tourist activities, and our services at clubs and entertainment arenas. We provide services for the consumer audience and for the professional entertainment industry.",false,bg)
	guiLabelSetColor(mainText,0,0,0)
	guiLabelSetHorizontalAlign(mainText, "left", true)
	
	local image = guiCreateStaticImage(105,170,345,242,"websites/images/rodeo.png",false,bg)
	
	local mainText2 = guiCreateLabel(105,417,350,140, "Our main line of work is doing contractor works within the entertainment industry. Our team and contractors consists of experienced event managers, project directors, PR- and marketing agents, coordinators, drivers/transporters, technicians and security guards. This gives us the opportunity to assist your entertainment business with hosting successful and problem-free events. We also serve the tourism industry, for example by offering exiting and astonishing trips to local and distant destinations.",false,bg)
	guiLabelSetColor(mainText2,0,0,0)
	guiLabelSetHorizontalAlign(mainText2, "left", true)
	
	local mainText3 = guiCreateLabel(105,557,350,40, "Contact us today to find out how we can help your entertainment business, club or event.",false,bg)
	guiLabelSetColor(mainText3,0,0,0)
	guiLabelSetHorizontalAlign(mainText3, "left", true)
	
	local contractorLink = guiCreateLabel(105,597,350,20, "Click here for contractor information.",false,bg)
	guiLabelSetColor(contractorLink,0,20,255)
	guiLabelSetHorizontalAlign(contractorLink, "left", true)
	local contractorLink_line = guiCreateStaticImage(105,613,200,1,"websites/colours/1.png",false,bg)
	addEventHandler("onClientMouseEnter",contractorLink,function()
		guiStaticImageLoadImage(contractorLink_line, "websites/colours/2.png")
	end,false)
	addEventHandler("onClientMouseLeave",contractorLink,function()
		guiStaticImageLoadImage(contractorLink_line, "websites/colours/1.png")
	end,false)
	addEventHandler("onClientGUIClick",contractorLink,function()
		local url = tostring("www.entertainment.sa/about/contractor")
		get_page(url)
	end,false)
	
	------------
	-- Footer --
	------------
	local footer = guiCreateStaticImage(0,725,460,40,"websites/colours/24.png",false,bg)
	local footer_txt = guiCreateLabel(10,5,440,30,"Copyright, Goldsmith Entertainment Company.\ P.O. 141, Marina, Los Santos. goldsmith@saonline.sa.",false,footer)
	guiLabelSetColor(footer_txt,255,255,255)
	guiSetFont(footer_txt, "default-small")
	
	----------------------- End of page design -------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,460,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end


function www_entertainment_sa_events()
	
	-- Webpage Properties
	---------------------
	local page_length = 396 
	guiSetText(internet_address_label, "Goldsmith Entertainment Co.")
	guiSetText(address_bar,"www.entertainment.sa/events")
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,460,page_length,"websites/colours/1.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local banner = guiCreateStaticImage(0,0,460,60,"websites/colours/6.png",false,bg)
	local header = guiCreateLabel(10,5,400,40,"Goldsmith Entertainment Co.",false,banner)
	guiSetFont(header, "sa-header")
	
	----------
	-- Menu --
	----------
	local menu_link1 = guiCreateStaticImage(0,60,100,30,"websites/colours/46.png",false,bg)
	local menu_link1_txt = guiCreateLabel(5,5,90,20,"Home",false,menu_link1)
	guiLabelSetColor(menu_link1_txt,255,255,255)
	guiSetFont(menu_link1_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link1_txt,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link1,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link1_txt,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	
	local menu_link2 = guiCreateStaticImage(0,90,100,30,"websites/colours/46.png",false,bg)
	local menu_link2_txt = guiCreateLabel(5,5,90,20,"About",false,menu_link2)
	guiLabelSetColor(menu_link2_txt,255,255,255)
	guiSetFont(menu_link2_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link2_txt,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link2,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link2_txt,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	
	local menu_link3 = guiCreateStaticImage(0,120,100,30,"websites/colours/46.png",false,bg)
	local menu_link3_txt = guiCreateLabel(5,5,90,20,"Events",false,menu_link3)
	guiLabelSetColor(menu_link3_txt,255,255,255)
	guiSetFont(menu_link3_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link3_txt,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link3,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link3_txt,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	
	local menu_link4 = guiCreateStaticImage(0,150,100,30,"websites/colours/46.png",false,bg)
	local menu_link4_txt = guiCreateLabel(5,5,90,20,"Contact",false,menu_link4)
	guiLabelSetColor(menu_link4_txt,255,255,255)
	guiSetFont(menu_link4_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link4_txt,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link4,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link4_txt,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	
	-------------
	-- Content --
	-------------
	local mainHeading = guiCreateLabel(105,65,350,20,"Events",false,bg)
	guiLabelSetColor(mainHeading,0,0,0)
	guiSetFont(mainHeading, "default-bold-small")
	
	local eventTableWrap = guiCreateStaticImage(105,85,220,50,"websites/colours/114.png",false,bg)
	local eventTable = guiCreateStaticImage(5,5,210,40,"websites/colours/1.png",false,eventTableWrap)
	
	local eventTable_text1 = guiCreateLabel(5,5,200,20,	"Sorry. No events at the moment.",false,eventTable)
	guiLabelSetColor(eventTable_text1,0,0,0)
	guiLabelSetHorizontalAlign(eventTable_text1, "left", true)
	
	------------
	-- Footer --
	------------
	local footer = guiCreateStaticImage(0,357,460,40,"websites/colours/24.png",false,bg)
	local footer_txt = guiCreateLabel(10,5,440,30,"Copyright, Goldsmith Entertainment Company.\ P.O. 141, Marina, Los Santos. goldsmith@saonline.sa.",false,footer)
	guiLabelSetColor(footer_txt,255,255,255)
	guiSetFont(footer_txt, "default-small")
	
	----------------------- End of page design -------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,460,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end


function www_entertainment_sa_contact()
	
	-- Webpage Properties
	---------------------
	local page_length = 396 
	guiSetText(internet_address_label, "Goldsmith Entertainment Co.")
	guiSetText(address_bar,"www.entertainment.sa/contact")
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,460,page_length,"websites/colours/1.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local banner = guiCreateStaticImage(0,0,460,60,"websites/colours/6.png",false,bg)
	local header = guiCreateLabel(10,5,400,40,"Goldsmith Entertainment Co.",false,banner)
	guiSetFont(header, "sa-header")
	
	----------
	-- Menu --
	----------
	local menu_link1 = guiCreateStaticImage(0,60,100,30,"websites/colours/46.png",false,bg)
	local menu_link1_txt = guiCreateLabel(5,5,90,20,"Home",false,menu_link1)
	guiLabelSetColor(menu_link1_txt,255,255,255)
	guiSetFont(menu_link1_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link1_txt,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link1,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link1_txt,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	
	local menu_link2 = guiCreateStaticImage(0,90,100,30,"websites/colours/46.png",false,bg)
	local menu_link2_txt = guiCreateLabel(5,5,90,20,"About",false,menu_link2)
	guiLabelSetColor(menu_link2_txt,255,255,255)
	guiSetFont(menu_link2_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link2_txt,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link2,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link2_txt,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	
	local menu_link3 = guiCreateStaticImage(0,120,100,30,"websites/colours/46.png",false,bg)
	local menu_link3_txt = guiCreateLabel(5,5,90,20,"Events",false,menu_link3)
	guiLabelSetColor(menu_link3_txt,255,255,255)
	guiSetFont(menu_link3_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link3_txt,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link3,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link3_txt,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	
	local menu_link4 = guiCreateStaticImage(0,150,100,30,"websites/colours/46.png",false,bg)
	local menu_link4_txt = guiCreateLabel(5,5,90,20,"Contact",false,menu_link4)
	guiLabelSetColor(menu_link4_txt,255,255,255)
	guiSetFont(menu_link4_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link4_txt,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link4,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link4_txt,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	
	-------------
	-- Content --
	-------------
	local mainHeading = guiCreateLabel(105,65,350,20,"Contact",false,bg)
	guiLabelSetColor(mainHeading,0,0,0)
	guiSetFont(mainHeading, "default-bold-small")
	
	local mainText = guiCreateLabel(105,85,350,800,	"For more information about our company, our offers and for booking, feel free to contact us.\ The easiest way to contact us is by sending an e-mail to goldsmith@saonline.sa, or by contacting one of our employees.",false,bg)
	guiLabelSetHorizontalAlign(mainText, "left", true)
	guiLabelSetColor(mainText,0,0,0)
	
	
	local employee1 = guiCreateStaticImage(105,150,95,110,"websites/colours/8.png",false,bg)
	local employee1_img = guiCreateStaticImage(5,5,85,78,":account-system/img/059.png",false,employee1)
	--local employee1_img = guiCreateStaticImage(5,5,85,78,"websites/customimg/059.png",false,employee1)
	local employee1_txt = guiCreateLabel(0,82,95,15,"Jacob Goldsmith",false,employee1)
	guiLabelSetColor(employee1_txt,0,0,0)
	guiSetFont(employee1_txt, "default-bold-small")
	guiLabelSetHorizontalAlign(employee1_txt, "center", false)
	local employee1_txt2 = guiCreateLabel(0,95,95,15,"C.E.O.",false,employee1)
	guiLabelSetColor(employee1_txt2,0,0,0)
	guiSetFont(employee1_txt2, "default-small")
	guiLabelSetHorizontalAlign(employee1_txt2, "center", false)

	--addEventHandler("onClientMouseEnter",employee1,function()
	--	guiStaticImageLoadImage(employee1, "websites/colours/14.png")
	--end,false)
	--addEventHandler("onClientMouseLeave",employee1,function()
	--	guiStaticImageLoadImage(employee1, "websites/colours/8.png")
	--end,false)
	--addEventHandler("onClientMouseEnter",employee1_img,function()
	--	guiStaticImageLoadImage(employee1, "websites/colours/14.png")
	--end,false)
	--addEventHandler("onClientMouseEnter",employee1_txt,function()
	--	guiStaticImageLoadImage(employee1, "websites/colours/14.png")
	--end,false)
	--addEventHandler("onClientMouseEnter",employee1_txt2,function()
	--	guiStaticImageLoadImage(employee1, "websites/colours/14.png")
	--end,false)
	addEventHandler("onClientGUIClick",employee1,function()
		local url = tostring("www.entertainment.sa/employees/goldsmith")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",employee1_img,function()
		local url = tostring("www.entertainment.sa/employees/goldsmith")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",employee1_txt,function()
		local url = tostring("www.entertainment.sa/employees/goldsmith")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",employee1_txt2,function()
		local url = tostring("www.entertainment.sa/employees/goldsmith")
		get_page(url)
	end,false)

	local employee2 = guiCreateStaticImage(210,150,95,110,"websites/colours/8.png",false,bg)
	local employee1_img = guiCreateStaticImage(5,5,85,78,":account-system/img/211.png",false,employee2)
	--local employee2_img = guiCreateStaticImage(5,5,85,78,"websites/customimg/211.png",false,employee2)
	local employee2_txt = guiCreateLabel(0,82,95,15,"Marie Hudson",false,employee2)
	guiLabelSetColor(employee2_txt,0,0,0)
	guiSetFont(employee2_txt, "default-bold-small")
	guiLabelSetHorizontalAlign(employee2_txt, "center", false)
	local employee2_txt2 = guiCreateLabel(0,95,95,15,"Chief Assistant",false,employee2)
	guiLabelSetColor(employee2_txt2,0,0,0)
	guiSetFont(employee2_txt2, "default-small")
	guiLabelSetHorizontalAlign(employee2_txt2, "center", false)
	
	addEventHandler("onClientGUIClick",employee2,function()
		local url = tostring("www.entertainment.sa/employees/hudson")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",employee2_img,function()
		local url = tostring("www.entertainment.sa/employees/hudson")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",employee2_txt,function()
		local url = tostring("www.entertainment.sa/employees/hudson")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",employee2_txt2,function()
		local url = tostring("www.entertainment.sa/employees/hudson")
		get_page(url)
	end,false)
	
	local employee3 = guiCreateStaticImage(315,150,95,110,"websites/colours/8.png",false,bg)
	--local employee1_img = guiCreateStaticImage(5,5,85,78,":account-system/img/255.png",false,employee3)
	--local employee3_img = guiCreateStaticImage(5,5,85,78,"websites/customimg/255.png",false,employee3)
	local employee3_txt = guiCreateLabel(0,82,95,15,"Position Available",false,employee3)
	guiLabelSetColor(employee3_txt,0,0,0)
	guiSetFont(employee3_txt, "default-bold-small")
	guiLabelSetHorizontalAlign(employee3_txt, "center", false)
	local employee3_txt2 = guiCreateLabel(0,95,95,15,"Project Manager",false,employee3)
	guiLabelSetColor(employee3_txt2,0,0,0)
	guiSetFont(employee3_txt2, "default-small")
	guiLabelSetHorizontalAlign(employee3_txt2, "center", false)
	
	addEventHandler("onClientGUIClick",employee3,function()
		local url = tostring("www.entertainment.sa/news/001")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",employee3_img,function()
		local url = tostring("www.entertainment.sa/news/001")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",employee3_txt,function()
		local url = tostring("www.entertainment.sa/news/001")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",employee3_txt2,function()
		local url = tostring("www.entertainment.sa/news/001")
		get_page(url)
	end,false)
	
	------------
	-- Footer --
	------------
	local footer = guiCreateStaticImage(0,357,460,40,"websites/colours/24.png",false,bg)
	local footer_txt = guiCreateLabel(10,5,440,30,"Copyright, Goldsmith Entertainment Company.\ P.O. 141, Marina, Los Santos. goldsmith@saonline.sa.",false,footer)
	guiLabelSetColor(footer_txt,255,255,255)
	guiSetFont(footer_txt, "default-small")
	
	----------------------- End of page design -------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,460,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end


function www_entertainment_sa_about_contractor()
	
	-- Webpage Properties
	---------------------
	local page_length = 396 
	guiSetText(internet_address_label, "Goldsmith Entertainment Co.")
	guiSetText(address_bar,"www.entertainment.sa/about/contractor")
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,460,page_length,"websites/colours/1.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local banner = guiCreateStaticImage(0,0,460,60,"websites/colours/6.png",false,bg)
	local header = guiCreateLabel(10,5,400,40,"Goldsmith Entertainment Co.",false,banner)
	guiSetFont(header, "sa-header")
	
	----------
	-- Menu --
	----------
	local menu_link1 = guiCreateStaticImage(0,60,100,30,"websites/colours/46.png",false,bg)
	local menu_link1_txt = guiCreateLabel(5,5,90,20,"Home",false,menu_link1)
	guiLabelSetColor(menu_link1_txt,255,255,255)
	guiSetFont(menu_link1_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link1_txt,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link1,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link1_txt,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	
	local menu_link2 = guiCreateStaticImage(0,90,100,30,"websites/colours/46.png",false,bg)
	local menu_link2_txt = guiCreateLabel(5,5,90,20,"About",false,menu_link2)
	guiLabelSetColor(menu_link2_txt,255,255,255)
	guiSetFont(menu_link2_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link2_txt,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link2,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link2_txt,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	
	local menu_link3 = guiCreateStaticImage(0,120,100,30,"websites/colours/46.png",false,bg)
	local menu_link3_txt = guiCreateLabel(5,5,90,20,"Events",false,menu_link3)
	guiLabelSetColor(menu_link3_txt,255,255,255)
	guiSetFont(menu_link3_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link3_txt,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link3,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link3_txt,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	
	local menu_link4 = guiCreateStaticImage(0,150,100,30,"websites/colours/46.png",false,bg)
	local menu_link4_txt = guiCreateLabel(5,5,90,20,"Contact",false,menu_link4)
	guiLabelSetColor(menu_link4_txt,255,255,255)
	guiSetFont(menu_link4_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link4_txt,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link4,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link4_txt,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	
	-------------
	-- Content --
	-------------
	local mainHeading = guiCreateLabel(105,65,350,20,"Contractors",false,bg)
	guiLabelSetColor(mainHeading,0,0,0)
	guiSetFont(mainHeading, "default-bold-small")
	
	local mainText = guiCreateLabel(105,85,350,40,	"We wish to thank these contractors for contributing in various events:",false,bg)
	guiLabelSetColor(mainText,0,0,0)
	guiLabelSetHorizontalAlign(mainText, "left", true)
	
	local link1 = guiCreateLabel(105,130,350,20, "W&W Imports",false,bg)
	guiLabelSetColor(link1,0,20,255)
	guiLabelSetHorizontalAlign(link1, "left", false)
	local link1_line = guiCreateStaticImage(105,146,150,1,"websites/colours/1.png",false,bg)
	addEventHandler("onClientMouseEnter",link1,function()
		guiStaticImageLoadImage(link1_line, "websites/colours/2.png")
	end,false)
	addEventHandler("onClientMouseLeave",link1,function()
		guiStaticImageLoadImage(link1_line, "websites/colours/1.png")
	end,false)
	addEventHandler("onClientGUIClick",link1,function()
		local url = tostring("www.wwimports.sa/")
		get_page(url)
	end,false)
	
	local mainText = guiCreateLabel(105,155,350,20,	"Do you want to be a contractor? Why not contact us today?",false,bg)
	guiLabelSetColor(mainText,0,0,0)
	guiLabelSetHorizontalAlign(mainText, "left", true)
	
	------------
	-- Footer --
	------------
	local footer = guiCreateStaticImage(0,357,460,40,"websites/colours/24.png",false,bg)
	local footer_txt = guiCreateLabel(10,5,440,30,"Copyright, Goldsmith Entertainment Company.\ P.O. 141, Marina, Los Santos. goldsmith@saonline.sa.",false,footer)
	guiLabelSetColor(footer_txt,255,255,255)
	guiSetFont(footer_txt, "default-small")
	
	----------------------- End of page design -------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,460,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end


function www_entertainment_sa_news()
	
	-- Webpage Properties
	---------------------
	local page_length = 396 
	guiSetText(internet_address_label, "Goldsmith Entertainment Co.")
	guiSetText(address_bar,"www.entertainment.sa/news")
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,460,page_length,"websites/colours/1.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local banner = guiCreateStaticImage(0,0,460,60,"websites/colours/6.png",false,bg)
	local header = guiCreateLabel(10,5,400,40,"Goldsmith Entertainment Co.",false,banner)
	guiSetFont(header, "sa-header")
	
	----------
	-- Menu --
	----------
	local menu_link1 = guiCreateStaticImage(0,60,100,30,"websites/colours/46.png",false,bg)
	local menu_link1_txt = guiCreateLabel(5,5,90,20,"Home",false,menu_link1)
	guiLabelSetColor(menu_link1_txt,255,255,255)
	guiSetFont(menu_link1_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link1_txt,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link1,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link1_txt,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	
	local menu_link2 = guiCreateStaticImage(0,90,100,30,"websites/colours/46.png",false,bg)
	local menu_link2_txt = guiCreateLabel(5,5,90,20,"About",false,menu_link2)
	guiLabelSetColor(menu_link2_txt,255,255,255)
	guiSetFont(menu_link2_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link2_txt,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link2,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link2_txt,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	
	local menu_link3 = guiCreateStaticImage(0,120,100,30,"websites/colours/46.png",false,bg)
	local menu_link3_txt = guiCreateLabel(5,5,90,20,"Events",false,menu_link3)
	guiLabelSetColor(menu_link3_txt,255,255,255)
	guiSetFont(menu_link3_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link3_txt,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link3,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link3_txt,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	
	local menu_link4 = guiCreateStaticImage(0,150,100,30,"websites/colours/46.png",false,bg)
	local menu_link4_txt = guiCreateLabel(5,5,90,20,"Contact",false,menu_link4)
	guiLabelSetColor(menu_link4_txt,255,255,255)
	guiSetFont(menu_link4_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link4_txt,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link4,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link4_txt,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	
	-------------
	-- Content --
	-------------
	local mainHeading = guiCreateLabel(105,65,350,20,"News",false,bg)
	guiLabelSetColor(mainHeading,0,0,0)
	guiSetFont(mainHeading, "default-bold-small")
	
	local mainText = guiCreateLabel(105,85,350,40,	"Nothing here. Try the frontpage.",false,bg)
	guiLabelSetColor(mainText,0,0,0)
	guiLabelSetHorizontalAlign(mainText, "left", true)
	
	------------
	-- Footer --
	------------
	local footer = guiCreateStaticImage(0,357,460,40,"websites/colours/24.png",false,bg)
	local footer_txt = guiCreateLabel(10,5,440,30,"Copyright, Goldsmith Entertainment Company.\ P.O. 141, Marina, Los Santos. goldsmith@saonline.sa.",false,footer)
	guiLabelSetColor(footer_txt,255,255,255)
	guiSetFont(footer_txt, "default-small")
	
	----------------------- End of page design -------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,460,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end


function www_entertainment_sa_employees()
	
	-- Webpage Properties
	---------------------
	local page_length = 396 
	guiSetText(internet_address_label, "Goldsmith Entertainment Co.")
	guiSetText(address_bar,"www.entertainment.sa/employees")
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,460,page_length,"websites/colours/1.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local banner = guiCreateStaticImage(0,0,460,60,"websites/colours/6.png",false,bg)
	local header = guiCreateLabel(10,5,400,40,"Goldsmith Entertainment Co.",false,banner)
	guiSetFont(header, "sa-header")
	
	----------
	-- Menu --
	----------
	local menu_link1 = guiCreateStaticImage(0,60,100,30,"websites/colours/46.png",false,bg)
	local menu_link1_txt = guiCreateLabel(5,5,90,20,"Home",false,menu_link1)
	guiLabelSetColor(menu_link1_txt,255,255,255)
	guiSetFont(menu_link1_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link1_txt,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link1,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link1_txt,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	
	local menu_link2 = guiCreateStaticImage(0,90,100,30,"websites/colours/46.png",false,bg)
	local menu_link2_txt = guiCreateLabel(5,5,90,20,"About",false,menu_link2)
	guiLabelSetColor(menu_link2_txt,255,255,255)
	guiSetFont(menu_link2_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link2_txt,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link2,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link2_txt,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	
	local menu_link3 = guiCreateStaticImage(0,120,100,30,"websites/colours/46.png",false,bg)
	local menu_link3_txt = guiCreateLabel(5,5,90,20,"Events",false,menu_link3)
	guiLabelSetColor(menu_link3_txt,255,255,255)
	guiSetFont(menu_link3_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link3_txt,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link3,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link3_txt,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	
	local menu_link4 = guiCreateStaticImage(0,150,100,30,"websites/colours/46.png",false,bg)
	local menu_link4_txt = guiCreateLabel(5,5,90,20,"Contact",false,menu_link4)
	guiLabelSetColor(menu_link4_txt,255,255,255)
	guiSetFont(menu_link4_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link4_txt,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link4,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link4_txt,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	
	-------------
	-- Content --
	-------------
	local mainHeading = guiCreateLabel(105,65,350,20,"Employees",false,bg)
	guiLabelSetColor(mainHeading,0,0,0)
	guiSetFont(mainHeading, "default-bold-small")
	
	local mainText = guiCreateLabel(105,85,350,40,	"Nothing here. Try the contact-page.",false,bg)
	guiLabelSetColor(mainText,0,0,0)
	guiLabelSetHorizontalAlign(mainText, "left", true)
	
	------------
	-- Footer --
	------------
	local footer = guiCreateStaticImage(0,357,460,40,"websites/colours/24.png",false,bg)
	local footer_txt = guiCreateLabel(10,5,440,30,"Copyright, Goldsmith Entertainment Company.\ P.O. 141, Marina, Los Santos. goldsmith@saonline.sa.",false,footer)
	guiLabelSetColor(footer_txt,255,255,255)
	guiSetFont(footer_txt, "default-small")
	
	----------------------- End of page design -------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,460,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end


function www_entertainment_sa_employees_goldsmith()
	
	-- Webpage Properties
	---------------------
	local page_length = 396 
	guiSetText(internet_address_label, "Goldsmith Entertainment Co.")
	guiSetText(address_bar,"www.entertainment.sa/employees/goldsmith")
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,460,page_length,"websites/colours/1.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local banner = guiCreateStaticImage(0,0,460,60,"websites/colours/6.png",false,bg)
	local header = guiCreateLabel(10,5,400,40,"Goldsmith Entertainment Co.",false,banner)
	guiSetFont(header, "sa-header")
	
	----------
	-- Menu --
	----------
	local menu_link1 = guiCreateStaticImage(0,60,100,30,"websites/colours/46.png",false,bg)
	local menu_link1_txt = guiCreateLabel(5,5,90,20,"Home",false,menu_link1)
	guiLabelSetColor(menu_link1_txt,255,255,255)
	guiSetFont(menu_link1_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link1_txt,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link1,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link1_txt,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	
	local menu_link2 = guiCreateStaticImage(0,90,100,30,"websites/colours/46.png",false,bg)
	local menu_link2_txt = guiCreateLabel(5,5,90,20,"About",false,menu_link2)
	guiLabelSetColor(menu_link2_txt,255,255,255)
	guiSetFont(menu_link2_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link2_txt,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link2,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link2_txt,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	
	local menu_link3 = guiCreateStaticImage(0,120,100,30,"websites/colours/46.png",false,bg)
	local menu_link3_txt = guiCreateLabel(5,5,90,20,"Events",false,menu_link3)
	guiLabelSetColor(menu_link3_txt,255,255,255)
	guiSetFont(menu_link3_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link3_txt,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link3,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link3_txt,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	
	local menu_link4 = guiCreateStaticImage(0,150,100,30,"websites/colours/46.png",false,bg)
	local menu_link4_txt = guiCreateLabel(5,5,90,20,"Contact",false,menu_link4)
	guiLabelSetColor(menu_link4_txt,255,255,255)
	guiSetFont(menu_link4_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link4_txt,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link4,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link4_txt,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	
	-------------
	-- Content --
	-------------
	local mainHeading = guiCreateLabel(105,65,350,20,"Employee",false,bg)
	guiLabelSetColor(mainHeading,0,0,0)
	guiSetFont(mainHeading, "default-bold-small")
	
	local employee1 = guiCreateStaticImage(105,85,350,83,"websites/colours/8.png",false,bg)
	local employee1_img = guiCreateStaticImage(5,5,85,78,":account-system/img/059.png",false,employee1)
	--local employee1_img = guiCreateStaticImage(5,5,85,78,"websites/customimg/059.png",false,employee1)
	local employee1_txt = guiCreateLabel(90,5,95,15,"Jacob Goldsmith",false,employee1)
	guiLabelSetColor(employee1_txt,0,0,0)
	guiSetFont(employee1_txt, "default-bold-small")
	guiLabelSetHorizontalAlign(employee1_txt, "left", false)
	local employee1_txt2 = guiCreateLabel(90,20,95,15,"C.E.O.",false,employee1)
	guiLabelSetColor(employee1_txt2,0,0,0)
	guiSetFont(employee1_txt2, "default-small")
	guiLabelSetHorizontalAlign(employee1_txt2, "left", false)
	local employee1_txt3 = guiCreateLabel(90,35,95,15,"goldsmith@saonline.sa",false,employee1)
	guiLabelSetColor(employee1_txt3,0,0,0)
	guiSetFont(employee1_txt3, "default-small")
	guiLabelSetHorizontalAlign(employee1_txt3, "left", false)
	local employee1_txt4 = guiCreateLabel(90,50,95,15,"Phone: 39850",false,employee1)
	guiLabelSetColor(employee1_txt4,0,0,0)
	guiSetFont(employee1_txt4, "default-small")
	guiLabelSetHorizontalAlign(employee1_txt4, "left", false)
	
	------------
	-- Footer --
	------------
	local footer = guiCreateStaticImage(0,357,460,40,"websites/colours/24.png",false,bg)
	local footer_txt = guiCreateLabel(10,5,440,30,"Copyright, Goldsmith Entertainment Company.\ P.O. 141, Marina, Los Santos. goldsmith@saonline.sa.",false,footer)
	guiLabelSetColor(footer_txt,255,255,255)
	guiSetFont(footer_txt, "default-small")
	
	----------------------- End of page design -------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,460,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end


function www_entertainment_sa_employees_hudson()
	
	-- Webpage Properties
	---------------------
	local page_length = 396 
	guiSetText(internet_address_label, "Goldsmith Entertainment Co.")
	guiSetText(address_bar,"www.entertainment.sa/employees/hudson")
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,460,page_length,"websites/colours/1.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local banner = guiCreateStaticImage(0,0,460,60,"websites/colours/6.png",false,bg)
	local header = guiCreateLabel(10,5,400,40,"Goldsmith Entertainment Co.",false,banner)
	guiSetFont(header, "sa-header")
	
	----------
	-- Menu --
	----------
	local menu_link1 = guiCreateStaticImage(0,60,100,30,"websites/colours/46.png",false,bg)
	local menu_link1_txt = guiCreateLabel(5,5,90,20,"Home",false,menu_link1)
	guiLabelSetColor(menu_link1_txt,255,255,255)
	guiSetFont(menu_link1_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link1_txt,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link1,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link1_txt,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	
	local menu_link2 = guiCreateStaticImage(0,90,100,30,"websites/colours/46.png",false,bg)
	local menu_link2_txt = guiCreateLabel(5,5,90,20,"About",false,menu_link2)
	guiLabelSetColor(menu_link2_txt,255,255,255)
	guiSetFont(menu_link2_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link2_txt,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link2,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link2_txt,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	
	local menu_link3 = guiCreateStaticImage(0,120,100,30,"websites/colours/46.png",false,bg)
	local menu_link3_txt = guiCreateLabel(5,5,90,20,"Events",false,menu_link3)
	guiLabelSetColor(menu_link3_txt,255,255,255)
	guiSetFont(menu_link3_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link3_txt,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link3,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link3_txt,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	
	local menu_link4 = guiCreateStaticImage(0,150,100,30,"websites/colours/46.png",false,bg)
	local menu_link4_txt = guiCreateLabel(5,5,90,20,"Contact",false,menu_link4)
	guiLabelSetColor(menu_link4_txt,255,255,255)
	guiSetFont(menu_link4_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link4_txt,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link4,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link4_txt,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	
	-------------
	-- Content --
	-------------
	local mainHeading = guiCreateLabel(105,65,350,20,"Employee",false,bg)
	guiLabelSetColor(mainHeading,0,0,0)
	guiSetFont(mainHeading, "default-bold-small")
	
	local employee1 = guiCreateStaticImage(105,85,350,83,"websites/colours/8.png",false,bg)
	local employee1_img = guiCreateStaticImage(5,5,85,78,":account-system/img/211.png",false,employee1)
	--local employee1_img = guiCreateStaticImage(5,5,85,78,"websites/customimg/211.png",false,employee1)
	local employee1_txt = guiCreateLabel(90,5,95,15,"Marie Hudson",false,employee1)
	guiLabelSetColor(employee1_txt,0,0,0)
	guiSetFont(employee1_txt, "default-bold-small")
	guiLabelSetHorizontalAlign(employee1_txt, "left", false)
	local employee1_txt2 = guiCreateLabel(90,20,95,15,"Chief Assistant",false,employee1)
	guiLabelSetColor(employee1_txt2,0,0,0)
	guiSetFont(employee1_txt2, "default-small")
	guiLabelSetHorizontalAlign(employee1_txt2, "left", false)
	--local employee1_txt3 = guiCreateLabel(90,35,95,15,"goldsmith@saonline.sa",false,employee1)
	--guiLabelSetColor(employee1_txt3,0,0,0)
	--guiSetFont(employee1_txt3, "default-small")
	--guiLabelSetHorizontalAlign(employee1_txt3, "left", false)
	--local employee1_txt4 = guiCreateLabel(90,50,95,15,"Phone: 39850",false,employee1)
	--guiLabelSetColor(employee1_txt4,0,0,0)
	--guiSetFont(employee1_txt4, "default-small")
	--guiLabelSetHorizontalAlign(employee1_txt4, "left", false)
	
	------------
	-- Footer --
	------------
	local footer = guiCreateStaticImage(0,357,460,40,"websites/colours/24.png",false,bg)
	local footer_txt = guiCreateLabel(10,5,440,30,"Copyright, Goldsmith Entertainment Company.\ P.O. 141, Marina, Los Santos. goldsmith@saonline.sa.",false,footer)
	guiLabelSetColor(footer_txt,255,255,255)
	guiSetFont(footer_txt, "default-small")
	
	----------------------- End of page design -------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,460,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end


function www_entertainment_sa_news_001()
	
	-- Webpage Properties
	---------------------
	local page_length = 396 
	guiSetText(internet_address_label, "Goldsmith Entertainment Co.")
	guiSetText(address_bar,"www.entertainment.sa/news/001")
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,460,page_length,"websites/colours/1.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local banner = guiCreateStaticImage(0,0,460,60,"websites/colours/6.png",false,bg)
	local header = guiCreateLabel(10,5,400,40,"Goldsmith Entertainment Co.",false,banner)
	guiSetFont(header, "sa-header")
	
	----------
	-- Menu --
	----------
	local menu_link1 = guiCreateStaticImage(0,60,100,30,"websites/colours/46.png",false,bg)
	local menu_link1_txt = guiCreateLabel(5,5,90,20,"Home",false,menu_link1)
	guiLabelSetColor(menu_link1_txt,255,255,255)
	guiSetFont(menu_link1_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link1_txt,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link1,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link1_txt,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	
	local menu_link2 = guiCreateStaticImage(0,90,100,30,"websites/colours/46.png",false,bg)
	local menu_link2_txt = guiCreateLabel(5,5,90,20,"About",false,menu_link2)
	guiLabelSetColor(menu_link2_txt,255,255,255)
	guiSetFont(menu_link2_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link2_txt,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link2,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link2_txt,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	
	local menu_link3 = guiCreateStaticImage(0,120,100,30,"websites/colours/46.png",false,bg)
	local menu_link3_txt = guiCreateLabel(5,5,90,20,"Events",false,menu_link3)
	guiLabelSetColor(menu_link3_txt,255,255,255)
	guiSetFont(menu_link3_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link3_txt,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link3,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link3_txt,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	
	local menu_link4 = guiCreateStaticImage(0,150,100,30,"websites/colours/46.png",false,bg)
	local menu_link4_txt = guiCreateLabel(5,5,90,20,"Contact",false,menu_link4)
	guiLabelSetColor(menu_link4_txt,255,255,255)
	guiSetFont(menu_link4_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link4_txt,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link4,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link4_txt,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	
	-------------
	-- Content --
	-------------
	local mainHeading = guiCreateLabel(105,65,350,20,"Job Openings",false,bg)
	guiLabelSetColor(mainHeading,0,0,0)
	guiSetFont(mainHeading, "default-bold-small")
	
	local mainText = guiCreateLabel(105,85,350,300,	"Goldsmith Entertainment Company is looking to hire more personnel. If you find yourself suitable for this job, please write an application to goldsmith@saonline.sa with the subject '˜Job Application - Your Name'. In the e-mail, describe yourself, your skills and knowledge, tell us what makes you differ from other applicants, and tell us how you can contribute to our business. The most appealing applicants will be called in for an interview. Make sure to read about our company before applying, to get an impression of what kind of employees and positions we're interested in.",false,bg)
	guiLabelSetColor(mainText,0,0,0)
	guiLabelSetHorizontalAlign(mainText, "left", true)
	
	------------
	-- Footer --
	------------
	local footer = guiCreateStaticImage(0,357,460,40,"websites/colours/24.png",false,bg)
	local footer_txt = guiCreateLabel(10,5,440,30,"Copyright, Goldsmith Entertainment Company.\ P.O. 141, Marina, Los Santos. goldsmith@saonline.sa.",false,footer)
	guiLabelSetColor(footer_txt,255,255,255)
	guiSetFont(footer_txt, "default-small")
	
	----------------------- End of page design -------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,460,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end


function www_entertainment_sa_news_002()
	
	-- Webpage Properties
	---------------------
	local page_length = 765 
	guiSetText(internet_address_label, "Goldsmith Entertainment Co.")
	guiSetText(address_bar,"www.entertainment.sa/news/002")
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,460,page_length,"websites/colours/1.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local banner = guiCreateStaticImage(0,0,460,60,"websites/colours/6.png",false,bg)
	local header = guiCreateLabel(10,5,400,40,"Goldsmith Entertainment Co.",false,banner)
	guiSetFont(header, "sa-header")
	
	----------
	-- Menu --
	----------
	local menu_link1 = guiCreateStaticImage(0,60,100,30,"websites/colours/46.png",false,bg)
	local menu_link1_txt = guiCreateLabel(5,5,90,20,"Home",false,menu_link1)
	guiLabelSetColor(menu_link1_txt,255,255,255)
	guiSetFont(menu_link1_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link1_txt,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link1,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link1_txt,function()
		local url = tostring("www.entertainment.sa")
		get_page(url)
	end,false)
	
	local menu_link2 = guiCreateStaticImage(0,90,100,30,"websites/colours/46.png",false,bg)
	local menu_link2_txt = guiCreateLabel(5,5,90,20,"About",false,menu_link2)
	guiLabelSetColor(menu_link2_txt,255,255,255)
	guiSetFont(menu_link2_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link2_txt,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link2,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link2_txt,function()
		local url = tostring("www.entertainment.sa/about")
		get_page(url)
	end,false)
	
	local menu_link3 = guiCreateStaticImage(0,120,100,30,"websites/colours/46.png",false,bg)
	local menu_link3_txt = guiCreateLabel(5,5,90,20,"Events",false,menu_link3)
	guiLabelSetColor(menu_link3_txt,255,255,255)
	guiSetFont(menu_link3_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link3_txt,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link3,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link3_txt,function()
		local url = tostring("www.entertainment.sa/events")
		get_page(url)
	end,false)
	
	local menu_link4 = guiCreateStaticImage(0,150,100,30,"websites/colours/46.png",false,bg)
	local menu_link4_txt = guiCreateLabel(5,5,90,20,"Contact",false,menu_link4)
	guiLabelSetColor(menu_link4_txt,255,255,255)
	guiSetFont(menu_link4_txt, "default-bold-small")
	addEventHandler("onClientMouseEnter",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/46.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link4_txt,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/68.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link4,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link4_txt,function()
		local url = tostring("www.entertainment.sa/contact")
		get_page(url)
	end,false)
	
	-------------
	-- Content --
	-------------
	local mainHeading = guiCreateLabel(105,65,350,20,"Visibility is Essential!",false,bg)
	guiLabelSetColor(mainHeading,0,0,0)
	guiSetFont(mainHeading, "default-bold-small")
	
	local mainText = guiCreateLabel(105,85,350,650, "To succeed you need customers or audience. To get customers or audience, you need to let them know about you and your offer. To get known, you need to be visible. To be visible, you need to present. In our days, the presence on the internet is important. Having an appealing website brings your customers and audience close. From your website your customers can easily get the information they need about you to come to your club or event. It will also make it easier to spread the word - for both parties. Your customers can easily refer the webpage to their friends after finding it appealing. And you can use your webpage as a reference yourself. You can provide a lot more information on your webpage than you are able to give trough common advertisement channels. Therefore by referring to your website in regular advertisement channels, you are able to provide a lot more information than you would be able to otherwise. Also, if you put some effort in keeping your website up-to-date at all times, your customers might regularly check your website for any new interesting announcements. This way you get a customer network and an easy way to communicate with them; broadcasting your message to a big audience. And in addition, the majority of the big audience is even in your target group. Due to these factors, the internet has become one of the most important marketing channels. And that is why you should give priority to this, and realize that you can't be absent on the internet any longer. Put a little effort into this and you'll see results very fast.\ \ As a service provider for the entertainment industry, Goldsmith Entertainment Co. offers to help you with your marketing, and especially your online marketing. We offer you our professional designers, developers and marketing advisors to help you get a decent presentation of yourself on the web, in no time. Our team is ready, waiting to listen to your needs. Contact us today for a suggestion and price evaluation. Send us an e-mail to goldsmith@saonline.sa with a description of your business and needs.\ \ Another interesting way to advertise your webpage is by online advertising campaigns. Make deals with other relevant websites and rent or swap advertisement spaces on their pages. We in Goldsmith Entertainment Co. will be more than happy to help you with your online marketing campaigns. If you are a website owner offering advertisement spaces, or an advertiser wanting to rent new spaces, please contact us and see how we can help.\ \ Good luck with your online marketing!",false,bg)
	guiLabelSetColor(mainText,0,0,0)
	guiLabelSetHorizontalAlign(mainText, "left", true)
	
	------------
	-- Footer --
	------------
	local footer = guiCreateStaticImage(0,725,460,40,"websites/colours/24.png",false,bg)
	local footer_txt = guiCreateLabel(10,5,440,30,"Copyright, Goldsmith Entertainment Company.\ P.O. 141, Marina, Los Santos. goldsmith@saonline.sa.",false,footer)
	guiLabelSetColor(footer_txt,255,255,255)
	guiSetFont(footer_txt, "default-small")
	
	----------------------- End of page design -------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,460,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end
