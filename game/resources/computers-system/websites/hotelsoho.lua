--------------------------
-- HOTEL SOHO HOME PAGE --
--------------------------

-- Website owner's forum name: Exciter
-- Website owner's Character's name: Jacob Goldsmith

local content, fbox_small1, fbox_small2

function www_hotelsoho_sa_themes_soho(desiredLength)  -- www_hotelsoho_sa_themes_soho
	local page_length
	if desiredLength then
		page_length = tonumber(desiredLength)
	else
		page_length = 396
	end
	
	-- Webpage Properties
	---------------------
	--local page_length = 396 -- Set the total length of your webpage in px (Max page height is 765px). This will determine whether your page will have a vertical scroll bar. 
	local page_width = 660
	guiSetText(internet_address_label, "Hotel Soho") -- This text is displayed at the top of the browser window when the page is opened. It is the same as the <title> tag used in the meta of a real webpage. Only change the text between the quotation marks.
	guiSetText(address_bar,"www.hotelsoho.sa/themes/soho") -- The url of the page. This should be the same as the function name but with the original "."s and "/". Example www.google.com.
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,page_width,page_length,"websites/colours/111.png",false,internet_pane)
	local wrapper_width = page_width - 100
	local wrapper_length = page_length - 20
	local content_length = wrapper_length - 90
	local wrapper = guiCreateStaticImage(50,10,wrapper_width,wrapper_length,"websites/colours/1.png",false,bg)
	
	------------
	-- Header --
	------------
	local header = guiCreateStaticImage(0,0,wrapper_width,90,"websites/colours/12.png",false,wrapper)
	local nav = guiCreateStaticImage(0,60,wrapper_width,20,"websites/colours/51.png",false,header) --51-8
	local space = guiCreateStaticImage(0,80,wrapper_width,10,"websites/colours/1.png",false,header)
	local logo = guiCreateStaticImage(5,5,85,85,":item-system/images/4.png",false,header)
	--local logo = guiCreateStaticImage(5,5,85,85,"websites/customimg/4.png",false,header)
	local slogan = guiCreateLabel(95,5,200,40,"Hotel Soho",false,header)
	guiSetFont(slogan, "sa-header")
	
	----------
	-- Menu --
	----------
	local menu_link1 = guiCreateStaticImage(85,0,44,20,"websites/colours/51.png",false,nav)
	local menu_link1_txt = guiCreateLabel(2,3,40,15,"Home",false,menu_link1)
	guiLabelSetColor(menu_link1_txt,255,255,255)
	guiSetFont(menu_link1_txt, "default-bold-small")
	guiLabelSetHorizontalAlign(menu_link1_txt, "center", false)
	
	addEventHandler("onClientMouseEnter",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/52.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link1,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/51.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link1_txt,function()
		guiStaticImageLoadImage(menu_link1, "websites/colours/52.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link1_txt,function()
		guiStaticImageLoadImage(menu_link1_txt, "websites/colours/51.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link1,function()
		local url = tostring("www.hotelsoho.sa")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link1_txt,function()
		local url = tostring("www.hotelsoho.sa")
		get_page(url)
	end,false)
	
	local menu_link2 = guiCreateStaticImage(139,0,54,20,"websites/colours/51.png",false,nav)
	local menu_link2_txt = guiCreateLabel(2,3,50,15,"Facilities",false,menu_link2)
	guiLabelSetColor(menu_link2_txt,255,255,255)
	guiSetFont(menu_link2_txt, "default-bold-small")
	guiLabelSetHorizontalAlign(menu_link2_txt, "center", false)
	
	addEventHandler("onClientMouseEnter",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/52.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link2,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/51.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link2_txt,function()
		guiStaticImageLoadImage(menu_link2, "websites/colours/52.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link2_txt,function()
		guiStaticImageLoadImage(menu_link2_txt, "websites/colours/51.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link2,function()
		local url = tostring("www.hotelsoho.sa/facilities")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link2_txt,function()
		local url = tostring("www.hotelsoho.sa/facilities")
		get_page(url)
	end,false)
	
	local menu_link3 = guiCreateStaticImage(203,0,44,20,"websites/colours/51.png",false,nav)
	local menu_link3_txt = guiCreateLabel(2,3,40,15,"Rooms",false,menu_link3)
	guiLabelSetColor(menu_link3_txt,255,255,255)
	guiSetFont(menu_link3_txt, "default-bold-small")
	guiLabelSetHorizontalAlign(menu_link3_txt, "center", false)
	
	addEventHandler("onClientMouseEnter",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/52.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link3,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/51.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link3_txt,function()
		guiStaticImageLoadImage(menu_link3, "websites/colours/52.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link3_txt,function()
		guiStaticImageLoadImage(menu_link3_txt, "websites/colours/51.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link3,function()
		local url = tostring("www.hotelsoho.sa/rooms")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link3_txt,function()
		local url = tostring("www.hotelsoho.sa/rooms")
		get_page(url)
	end,false)
	
	local menu_link4 = guiCreateStaticImage(257,0,73,20,"websites/colours/51.png",false,nav)
	local menu_link4_txt = guiCreateLabel(2,3,69,15,"Restaurant",false,menu_link4)
	guiLabelSetColor(menu_link4_txt,255,255,255)
	guiSetFont(menu_link4_txt, "default-bold-small")
	guiLabelSetHorizontalAlign(menu_link4_txt, "center", false)
	
	addEventHandler("onClientMouseEnter",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/52.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link4,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/51.png")
	end,false)
	addEventHandler("onClientMouseEnter",menu_link4_txt,function()
		guiStaticImageLoadImage(menu_link4, "websites/colours/52.png")
	end,false)
	addEventHandler("onClientMouseLeave",menu_link4_txt,function()
		guiStaticImageLoadImage(menu_link4_txt, "websites/colours/51.png")
	end,false)
	addEventHandler("onClientGUIClick",menu_link4,function()
		local url = tostring("www.hotelsoho.sa/restaurant")
		get_page(url)
	end,false)
	addEventHandler("onClientGUIClick",menu_link4_txt,function()
		local url = tostring("www.hotelsoho.sa/restaurant")
		get_page(url)
	end,false)
	
	-------------
	-- Content --
	-------------
	content = guiCreateStaticImage(0,90,wrapper_width,content_length,"websites/colours/1.png",false,wrapper)
	
	fbox_small1 = guiCreateStaticImage(420,0,130,135,"websites/colours/3.png",false,content)
	fbox_small2 = guiCreateStaticImage(420,145,130,135,"websites/colours/3.png",false,content)
	
	------------
	-- Footer --
	------------
	local footer = guiCreateStaticImage(50,wrapper_length + 10,wrapper_width,20,"websites/colours/111.png",false,bg)
	local footer_txt = guiCreateLabel(0,0,wrapper_width,20,"Hotel Soho. 2, Soho Drive, Rodeo. soho@saonline.sa.",false,footer)
	guiSetFont(footer_txt, "default-small")
	guiLabelSetColor(footer_txt,50,50,50)
	guiLabelSetHorizontalAlign(footer_txt, "center", false)
	
	----------------------------------------------- End of webpage design -- Do not edit below this line. -----------------------------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end

function www_hotelsoho_sa()
	
	www_hotelsoho_sa_themes_soho() -- load theme
	guiSetText(address_bar,"www.hotelsoho.sa") -- correct the URL

	--------------
	-- Ad boxes --
	--------------
	guiStaticImageLoadImage(fbox_small1, "websites/colours/0.png")
	local fbox_small1i = guiCreateStaticImage(1,1,128,133,"websites/colours/1.png",false,fbox_small1)
	--local box1_img = guiCreateStaticImage(5,2,100,100,"websites/customimg/-14.png",false,fbox_small1i)
	local box1_img = guiCreateStaticImage(5,2,100,100,":item-system/images/-14.png",false,fbox_small1i)
	local box1_txt = guiCreateLabel(0,105,128,20, "comfort.",false,fbox_small1i)
	guiSetFont(box1_txt, "clear-normal")
	guiLabelSetColor(box1_txt,93,126,141)
	guiLabelSetHorizontalAlign(box1_txt, "center", true)
		
	guiStaticImageLoadImage(fbox_small2, "websites/colours/0.png")
	local fbox_small2i = guiCreateStaticImage(1,1,128,133,"websites/colours/1.png",false,fbox_small2)
	--local box2_img = guiCreateStaticImage(10,2,100,100,"websites/customimg/92.png",false,fbox_small2i)
	local box2_img = guiCreateStaticImage(10,2,100,100,":item-system/images/92.png",false,fbox_small2i)
	local box2_txt = guiCreateLabel(0,105,128,20, "delicate.",false,fbox_small2i)
	guiSetFont(box2_txt, "clear-normal")
	guiLabelSetColor(box2_txt,93,126,141)
	guiLabelSetHorizontalAlign(box2_txt, "center", true)
	
	-------------
	-- Content --
	-------------	
	local front_img = guiCreateStaticImage(10,0,400,210,"websites/images/rodeo.png",false,content) --300
	local presentation = guiCreateStaticImage(10,215,400,65,"websites/colours/1.png",false,content)
	local para1 = guiCreateLabel(0,0,400,65, "Welcome to Hotel Soho, a classy hotel located in the heart of Soho, Rodeo. Surrounded by quality entertainment and dining places, Hotel Soho is the perfect place to stay for the demanding guests.",false,presentation)
	guiSetFont(para1, "clear-normal")
	guiLabelSetColor(para1,0,0,0)
	guiLabelSetHorizontalAlign(para1, "left", true)
		
	
end

function www_hotelsoho_sa_restaurant()
	
	www_hotelsoho_sa_themes_soho() -- load theme
	guiSetText(address_bar,"www.hotelsoho.sa/restaurant") -- correct the URL

	--------------
	-- Ad boxes --
	--------------
	guiStaticImageLoadImage(fbox_small1, "websites/colours/0.png")
	local fbox_small1i = guiCreateStaticImage(1,1,128,133,"websites/colours/1.png",false,fbox_small1)
	--local box1_img = guiCreateStaticImage(10,2,100,100,"websites/customimg/92.png",false,fbox_small1i)
	local box1_img = guiCreateStaticImage(10,2,100,100,":item-system/images/92.png",false,fbox_small1i)
	local box1_txt = guiCreateLabel(0,105,128,20, "delicate.",false,fbox_small1i)
	guiSetFont(box1_txt, "clear-normal")
	guiLabelSetColor(box1_txt,93,126,141)
	guiLabelSetHorizontalAlign(box1_txt, "center", true)
		
	guiStaticImageLoadImage(fbox_small2, "websites/colours/0.png")
	local fbox_small2i = guiCreateStaticImage(1,1,128,133,"websites/colours/1.png",false,fbox_small2)
	--local box2_img = guiCreateStaticImage(10,2,100,100,"websites/customimg/95.png",false,fbox_small2i)
	local box2_img = guiCreateStaticImage(10,2,100,100,":item-system/images/95.png",false,fbox_small2i)
	local box2_txt = guiCreateLabel(0,105,128,20, "refreshing.",false,fbox_small2i)
	guiSetFont(box2_txt, "clear-normal")
	guiLabelSetColor(box2_txt,93,126,141)
	guiLabelSetHorizontalAlign(box2_txt, "center", true)
	
	-------------
	-- Content --
	-------------	
	local content_title = guiCreateLabel(10,0,400,15,"Hotel Soho Bar & Restaurant",false,content)
	guiSetFont(content_title, "default-bold-small")
	guiLabelSetColor(content_title,0,0,0)
	local title_underline = guiCreateStaticImage(10,15,400,1,"websites/colours/0.png",false,content)
	
	local para1 = guiCreateLabel(10,20,400,275, "Hotel Soho offers its own bar and restaurant, with the freshest delicacies. Our premises have a classy style, calm environment, and are served by leading cooks and staff. At certain times we offer entertainment in the restaurant in form of musicians or entertainers. The bar and restaurant is open both to the hotel guests and visitors. Regular opening hours are from 12am to 2am every day, and breakfast for hotel guests exclusively from 6am. The door to the restaurant is located to the right of the reception desk in the lobby. You are welcome to come have a taste.",false,content)
	guiSetFont(para1, "clear-normal")
	guiLabelSetColor(para1,0,0,0)
	guiLabelSetHorizontalAlign(para1, "left", true)
		
	
end

function www_hotelsoho_sa_rooms()
	
	www_hotelsoho_sa_themes_soho(496) -- load theme
	guiSetText(address_bar,"www.hotelsoho.sa/rooms") -- correct the URL

	--------------
	-- Ad boxes --
	--------------
	guiStaticImageLoadImage(fbox_small1, "websites/colours/0.png")
	local fbox_small1i = guiCreateStaticImage(1,1,128,133,"websites/colours/1.png",false,fbox_small1)
	--local box1_img = guiCreateStaticImage(5,2,100,100,"websites/customimg/-14.png",false,fbox_small1i)
	local box1_img = guiCreateStaticImage(5,2,100,100,":item-system/images/-14.png",false,fbox_small1i)
	local box1_txt = guiCreateLabel(0,105,128,20, "comfort.",false,fbox_small1i)
	guiSetFont(box1_txt, "clear-normal")
	guiLabelSetColor(box1_txt,93,126,141)
	guiLabelSetHorizontalAlign(box1_txt, "center", true)
		
	guiStaticImageLoadImage(fbox_small2, "websites/colours/0.png")
	local fbox_small2i = guiCreateStaticImage(1,1,128,133,"websites/colours/1.png",false,fbox_small2)
	--local box2_img = guiCreateStaticImage(10,2,100,100,"websites/customimg/83.png",false,fbox_small2i)
	local box2_img = guiCreateStaticImage(10,2,100,100,":item-system/images/83.png",false,fbox_small2i)
	local box2_txt = guiCreateLabel(0,105,128,20, "relaxing.",false,fbox_small2i)
	guiSetFont(box2_txt, "clear-normal")
	guiLabelSetColor(box2_txt,93,126,141)
	guiLabelSetHorizontalAlign(box2_txt, "center", true)
	
	-------------
	-- Content --
	-------------	
	local content_title = guiCreateLabel(10,0,400,15,"Guest Rooms",false,content)
	guiSetFont(content_title, "default-bold-small")
	guiLabelSetColor(content_title,0,0,0)
	local title_underline = guiCreateStaticImage(10,15,400,1,"websites/colours/0.png",false,content)
	
	local para1 = guiCreateLabel(10,20,400,375, "Hotel Soho holds a total of 20 guest rooms. To book a room with us, contact the reception located in the lobby at ground floor. We have 9 double rooms located on 2nd floor, and 9 quatro rooms located on 3rd floor. We also have 2 additional master suites, accessible from 3rd floor. The double rooms contain one double bed, and are suitable for 1-2 persons. The quatro rooms contain two double beds, which makes it suitable for 2-4 persons. All rooms have the excellent Hotel Soho quality. All rooms include a private bathroom, and are accessible 24/7 with your very own key. Other facilities include TV, wardrobe, air-conditioner, fridge and lockable safe. The hotel's cleaning staff will service your room at standard times or upon request. Our two master suites are penthouses, each with two floors, and contain 2 bedrooms, a large living room and kitchen. The whole hotel, including all rooms, is highly secured with cameras and alarm systems from Adept Security Services, and is directly wired to the LSPD and LSES. Additional security guards are also operating inside the hotel's premises. Entrances to the hotel are located on street floor, Soho Drive. Alternatively a helicopter arrival, through our roof access can be appointed with the hotel administration. If you have any questions regarding the hotel, or special requirements, please contact us and we will be happy to help.",false,content)
	guiSetFont(para1, "clear-normal")
	guiLabelSetColor(para1,0,0,0)
	guiLabelSetHorizontalAlign(para1, "left", true)
	
	local link1 = guiCreateLabel(307,239,90,15,"Adept Security",false,content)
	guiSetFont(link1, "clear-normal")
	guiLabelSetColor(link1,0,0,255)
	addEventHandler("onClientGUIClick",link1,function()
		get_page("www.adept.sa")
	end,false)
	
	local link2 = guiCreateLabel(10,253,52,15,"Services",false,content)
	guiSetFont(link2, "clear-normal")
	guiLabelSetColor(link2,0,0,255)
	addEventHandler("onClientGUIClick",link2,function()
		get_page("www.adept.sa")
	end,false)
	
	local link3 = guiCreateLabel(242,253,30,15,"LSPD",false,content)
	guiSetFont(link3, "clear-normal")
	guiLabelSetColor(link3,0,0,255)
	addEventHandler("onClientGUIClick",link3,function()
		get_page("www.lspd.gov")
	end,false)
	
	local link4 = guiCreateLabel(306,253,30,15,"LSES",false,content)
	guiSetFont(link4, "clear-normal")
	guiLabelSetColor(link4,0,0,255)
	addEventHandler("onClientGUIClick",link4,function()
		get_page("www.lses.gov")
	end,false)
	
end

function www_hotelsoho_sa_facilities()
	
	www_hotelsoho_sa_themes_soho(660) -- load theme
	guiSetText(address_bar,"www.hotelsoho.sa/facilities") -- correct the URL

	--------------
	-- Ad boxes --
	--------------
	guiStaticImageLoadImage(fbox_small1, "websites/colours/0.png")
	local fbox_small1i = guiCreateStaticImage(1,1,128,133,"websites/colours/1.png",false,fbox_small1)
	local box1_img = guiCreateStaticImage(25,15,70,70,"websites/images/dots/pink_dot.png",false,fbox_small1i)
	local box1_txt = guiCreateLabel(0,105,128,20, "experiences.",false,fbox_small1i)
	guiSetFont(box1_txt, "clear-normal")
	guiLabelSetColor(box1_txt,93,126,141)
	guiLabelSetHorizontalAlign(box1_txt, "center", true)
		
	guiStaticImageLoadImage(fbox_small2, "websites/colours/0.png")
	local fbox_small2i = guiCreateStaticImage(1,1,128,133,"websites/colours/1.png",false,fbox_small2)
	local box2_img = guiCreateStaticImage(25,15,70,70,"websites/images/dots/yellow_dot.png",false,fbox_small2i)
	local box2_txt = guiCreateLabel(0,105,128,20, "entertainment.",false,fbox_small2i)
	guiSetFont(box2_txt, "clear-normal")
	guiLabelSetColor(box2_txt,93,126,141)
	guiLabelSetHorizontalAlign(box2_txt, "center", true)
	
	-------------
	-- Content --
	-------------	
	local content_title = guiCreateLabel(10,0,400,15,"Facilities",false,content)
	guiSetFont(content_title, "default-bold-small")
	guiLabelSetColor(content_title,0,0,0)
	local title_underline = guiCreateStaticImage(10,15,400,1,"websites/colours/0.png",false,content)
	
	local para1 = guiCreateLabel(10,20,400,100, "Apart from the big facility that the hotel in itself is, the central location of Hotel Soho offers many other facilities and possibilities in the near area. During your stay with us, the hotel reception will be happy to help you with your questions.",false,content)
	guiSetFont(para1, "clear-normal")
	guiLabelSetColor(para1,0,0,0)
	guiLabelSetHorizontalAlign(para1, "left", true)
	
	local subtitle1 = guiCreateStaticImage(10,90,400,15,"websites/colours/12.png",false,content)
	local subti1txt = guiCreateLabel(5,0,200,15,"Shopping",false,subtitle1)
	guiSetFont(subti1txt, "default-bold-small")
	guiLabelSetColor(subti1txt,255,255,255)
	guiLabelSetHorizontalAlign(subti1txt, "left", true)
	local para2 = guiCreateLabel(15,105,395,100, "Located around Hotel Soho there are several luxury stores featuring respected trademarks.",false,content)
	guiSetFont(para2, "clear-normal")
	guiLabelSetColor(para2,0,0,0)
	guiLabelSetHorizontalAlign(para2, "left", true)
	
	local subtitle2 = guiCreateStaticImage(10,140,400,15,"websites/colours/12.png",false,content)
	local subti2txt = guiCreateLabel(5,0,200,15,"Dining",false,subtitle2)
	guiSetFont(subti2txt, "default-bold-small")
	guiLabelSetColor(subti2txt,255,255,255)
	guiLabelSetHorizontalAlign(subti2txt, "left", true)
	local para3 = guiCreateLabel(15,155,395,100, "There are several bars and restaurants located around the hotel, in addition to the hotel's very own restaurant. We especially recomend the real italian restaurant and pizzeria, Gnocchi, which is located straight across the street from Hotel Soho. For more info",false,content)
	guiSetFont(para3, "clear-normal")
	guiLabelSetColor(para3,0,0,0)
	guiLabelSetHorizontalAlign(para3, "left", true)
	local link1 = guiCreateLabel(141,213,200,15,"www.gnocchi.sa.",false,content)
	guiSetFont(link1, "default-normal")
	guiLabelSetColor(link1,0,0,255)
	guiLabelSetHorizontalAlign(link1, "left", true)
	addEventHandler("onClientGUIClick",link1,function()
		get_page("www.gnocchi.sa")
	end,false)
	
	local subtitle3 = guiCreateStaticImage(10,240,400,15,"websites/colours/12.png",false,content)
	local subti3txt = guiCreateLabel(5,0,200,15,"Nightlife",false,subtitle3)
	guiSetFont(subti3txt, "default-bold-small")
	guiLabelSetColor(subti3txt,255,255,255)
	guiLabelSetHorizontalAlign(subti3txt, "left", true)
	local para4 = guiCreateLabel(15,255,395,100, "There are several night clubs located nearby. The huge Tableau Night Club is located straight across the street from Hotel Soho. The famous Victim Club is located on Royal Street, behind Hotel Soho.",false,content)
	guiSetFont(para4, "clear-normal")
	guiLabelSetColor(para4,0,0,0)
	guiLabelSetHorizontalAlign(para4, "left", true)
	
	local subtitle4 = guiCreateStaticImage(10,320,400,15,"websites/colours/12.png",false,content)
	local subti4txt = guiCreateLabel(5,0,200,15,"Gambling",false,subtitle4)
	guiSetFont(subti4txt, "default-bold-small")
	guiLabelSetColor(subti4txt,255,255,255)
	guiLabelSetHorizontalAlign(subti4txt, "left", true)
	local para5 = guiCreateLabel(15,335,395,100, "The famous casino Aramisha is located nearby Hotel Soho, at Royal Street, behind Hotel Soho. There is also a number of other respected casinos in Los Santos.",false,content)
	guiSetFont(para5, "clear-normal")
	guiLabelSetColor(para5,0,0,0)
	guiLabelSetHorizontalAlign(para5, "left", true)
	
	local subtitle5 = guiCreateStaticImage(10,385,400,15,"websites/colours/12.png",false,content)
	local subti5txt = guiCreateLabel(5,0,200,15,"Transportation",false,subtitle5)
	guiSetFont(subti5txt, "default-bold-small")
	guiLabelSetColor(subti5txt,255,255,255)
	guiLabelSetHorizontalAlign(subti5txt, "left", true)
	local para6 = guiCreateLabel(15,400,395,100, "The hotel reception can help you with getting a cab or limousine.",false,content)
	guiSetFont(para6, "clear-normal")
	guiLabelSetColor(para6,0,0,0)
	guiLabelSetHorizontalAlign(para6, "left", true)
	
	local subtitle5 = guiCreateStaticImage(10,440,400,15,"websites/colours/12.png",false,content)
	local subti5txt = guiCreateLabel(5,0,200,15,"Parking",false,subtitle5)
	guiSetFont(subti5txt, "default-bold-small")
	guiLabelSetColor(subti5txt,255,255,255)
	guiLabelSetHorizontalAlign(subti5txt, "left", true)
	local para6 = guiCreateLabel(15,455,395,100, "A free car park is located behind the bank of Los Santos, a 5 minute walk from Hotel Soho. Short-time parking is available in the streets around the hotel, but limited to hotel and restaurant guests, and ment for deliveries and passenger exit/entry. Unauthorized parking outside the hotel may result in a vehicle tow and/or fine.",false,content)
	guiSetFont(para6, "clear-normal")
	guiLabelSetColor(para6,0,0,0)
	guiLabelSetHorizontalAlign(para6, "left", true)
	
	
	
	
end