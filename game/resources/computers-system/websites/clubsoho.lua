-------------------------
-- CLUB SOHO HOME PAGE --
-------------------------

-- Website owner's forum name: Exciter
-- Website owner's Character's name: Jacob Goldsmith
-- Last update: 04/06/2011 (DD/MM/YYYY)

local content

function www_clubsoho_sa_themes_clubsoho(desiredLength)
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
	guiSetText(internet_address_label, "Club Soho") -- This text is displayed at the top of the browser window when the page is opened. It is the same as the <title> tag used in the meta of a real webpage. Only change the text between the quotation marks.
	guiSetText(address_bar,"www.clubsoho.sa/themes/clubsoho") -- The url of the page. This should be the same as the function name but with the original "."s and "/". Example www.google.com.
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,page_width,page_length,"websites/colours/3.png",false,internet_pane)
	local wrapper_width = page_width - 230
	local wrapper_length = page_length - 20
	local content_length = wrapper_length - 80
	local wrapper = guiCreateStaticImage(100,0,wrapper_width,wrapper_length,"websites/colours/1.png",false,bg)
	
	------------
	-- Header --
	------------
	local header = guiCreateStaticImage(0,0,wrapper_width,90,"websites/colours/0.png",false,wrapper)
	local nav = guiCreateStaticImage(85,60,wrapper_width - 85,20,"websites/colours/0.png",false,header) --51-8
	local logo = guiCreateStaticImage(5,5,85,85,":item-system/images/95.png",false,header)
	--local logo = guiCreateStaticImage(5,5,85,85,"websites/customimg/95.png",false,header)
	local slogan = guiCreateLabel(95,20,200,40,"Club Soho",false,header)
	guiSetFont(slogan, "sa-header")
	
	----------
	-- Menu --
	----------
	local menu_link1 = guiCreateStaticImage(0,0,44,20,"websites/colours/0.png",false,nav)
	local menu_link1_txt = guiCreateLabel(2,3,40,15,"Home",false,menu_link1)
	guiLabelSetColor(menu_link1_txt,255,255,255)
	guiSetFont(menu_link1_txt, "default-bold-small")
	guiLabelSetHorizontalAlign(menu_link1_txt, "center", false)
	
	addEventHandler("onClientMouseEnter",menu_link1_txt,function()
		guiLabelSetColor(menu_link1_txt,255,187,0)
	end,false)
	addEventHandler("onClientMouseLeave",menu_link1_txt,function()
		guiLabelSetColor(menu_link1_txt,255,255,255)
	end,false)
	addEventHandler("onClientGUIClick",menu_link1_txt,function()
		local url = tostring("www.clubsoho.sa")
		get_page(url)
	end,false)
	
	local menu_link2 = guiCreateStaticImage(54,0,54,20,"websites/colours/0.png",false,nav)
	local menu_link2_txt = guiCreateLabel(2,3,50,15,"Menu",false,menu_link2)
	guiLabelSetColor(menu_link2_txt,255,255,255)
	guiSetFont(menu_link2_txt, "default-bold-small")
	guiLabelSetHorizontalAlign(menu_link2_txt, "center", false)
	
	addEventHandler("onClientMouseEnter",menu_link2_txt,function()
		guiLabelSetColor(menu_link2_txt,255,187,0)
	end,false)
	addEventHandler("onClientMouseLeave",menu_link2_txt,function()
		guiLabelSetColor(menu_link2_txt,255,255,255)
	end,false)
	addEventHandler("onClientGUIClick",menu_link2_txt,function()
		local url = tostring("www.clubsoho.sa/menu")
		get_page(url)
	end,false)
	
	local menu_link3 = guiCreateStaticImage(118,0,44,20,"websites/colours/0.png",false,nav)
	local menu_link3_txt = guiCreateLabel(2,3,40,15,"VIP",false,menu_link3)
	guiLabelSetColor(menu_link3_txt,255,255,255)
	guiSetFont(menu_link3_txt, "default-bold-small")
	guiLabelSetHorizontalAlign(menu_link3_txt, "center", false)
	
	addEventHandler("onClientMouseEnter",menu_link3_txt,function()
		guiLabelSetColor(menu_link3_txt,255,187,0)
	end,false)
	addEventHandler("onClientMouseLeave",menu_link3_txt,function()
		guiLabelSetColor(menu_link3_txt,255,255,255)
	end,false)
	addEventHandler("onClientGUIClick",menu_link3_txt,function()
		local url = tostring("www.clubsoho.sa/vip")
		get_page(url)
	end,false)
	
	local menu_link4 = guiCreateStaticImage(172,0,73,20,"websites/colours/0.png",false,nav)
	local menu_link4_txt = guiCreateLabel(2,3,69,15,"Contact",false,menu_link4)
	guiLabelSetColor(menu_link4_txt,255,255,255)
	guiSetFont(menu_link4_txt, "default-bold-small")
	guiLabelSetHorizontalAlign(menu_link4_txt, "center", false)
	
	addEventHandler("onClientMouseEnter",menu_link4_txt,function()
		guiLabelSetColor(menu_link4_txt,255,187,0)
	end,false)
	addEventHandler("onClientMouseLeave",menu_link4_txt,function()
		guiLabelSetColor(menu_link4_txt,255,255,255)
	end,false)
	addEventHandler("onClientGUIClick",menu_link4_txt,function()
		local url = tostring("www.clubsoho.sa/contact")
		get_page(url)
	end,false)
	
	-------------
	-- Content --
	-------------
	content = guiCreateStaticImage(0,90,wrapper_width,content_length,"websites/colours/0.png",false,wrapper)
		
	------------
	-- Footer --
	------------
	local footer = guiCreateStaticImage(100,wrapper_length + 5,wrapper_width,20,"websites/colours/3.png",false,bg)
	local footer_txt = guiCreateLabel(0,0,wrapper_width,20,"Club Soho. 1, Silk Road, Rodeo. soho@saonline.sa. A subsidiary of Soho Corporation.",false,footer)
	guiSetFont(footer_txt, "default-small")
	guiLabelSetColor(footer_txt,255,255,255)
	guiLabelSetHorizontalAlign(footer_txt, "center", false)
	
	----------------------------------------------- End of webpage design -- Do not edit below this line. -----------------------------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end

function www_clubsoho_sa()
	
	www_clubsoho_sa_themes_clubsoho() -- load theme
	guiSetText(address_bar,"www.clubsoho.sa") -- correct the URL
	
	-------------
	-- Content --
	-------------	
	local front_img = guiCreateStaticImage(10,0,400,210,"websites/images/rodeo.png",false,content) --300
	local presentation = guiCreateStaticImage(10,215,400,65,"websites/colours/0.png",false,content)
	local para1 = guiCreateLabel(0,0,400,65, "Welcome to Club Soho. The classy club in the high society area of Soho. Drop by to enjoy our delicious drinks in a unique atmosphere. We're located at 1, Silk Road, Rodeo, near Hotel Soho. Party with style!",false,presentation)
	guiSetFont(para1, "clear-normal")
	guiLabelSetColor(para1,255,255,255)
	guiLabelSetHorizontalAlign(para1, "left", true)
		
	
end

function www_clubsoho_sa_menu()
	
	www_clubsoho_sa_themes_clubsoho() -- load theme
	guiSetText(address_bar,"www.clubsoho.sa/menu") -- correct the URL
	
	-------------
	-- Content --
	-------------	
	local content_title = guiCreateLabel(10,0,400,15,"Club Soho Menu",false,content)
	guiSetFont(content_title, "default-bold-small")
	guiLabelSetColor(content_title,255,255,255)
	local title_underline = guiCreateStaticImage(10,15,400,1,"websites/colours/1.png",false,content)
	
	local subtitle1 = guiCreateStaticImage(10,20,200,15,"websites/colours/6.png",false,content)
	local subti1txt = guiCreateLabel(5,0,200,15,"Drinks",false,subtitle1)
	guiSetFont(subti1txt, "default-bold-small")
	guiLabelSetColor(subti1txt,0,0,0)
	guiLabelSetHorizontalAlign(subti1txt, "left", true)
	local para1 = guiCreateLabel(15,40,200,200, "Bastradov Vodka ............. $40\nBrandy ............................. $18\nCosmopolitian .................. $15\nMartini .............................. $20\nPink Lady ......................... $18\nScottish Whiskey ............. $30\nSex on the Beach ............. $20\nSoho Special .................... $50\nZiebrand Beer .................. $15",false,content)
	guiSetFont(para1, "clear-normal")
	guiLabelSetColor(para1,255,255,255)
	guiLabelSetHorizontalAlign(para1, "left", true)
	
	local subtitle2 = guiCreateStaticImage(220,20,180,15,"websites/colours/6.png",false,content)
	local subti2txt = guiCreateLabel(5,0,180,15,"Non-Alcoholic",false,subtitle2)
	guiSetFont(subti2txt, "default-bold-small")
	guiLabelSetColor(subti2txt,0,0,0)
	guiLabelSetHorizontalAlign(subti2txt, "left", true)
	local para2 = guiCreateLabel(225,40,180,200, "Apple Juice .................... $9\nCoca-Cola ..................... $9\nCoca-Cola Light  ........... $9\nFanta ............................ $9\nMineral Water Isklar ...... $7\nMineral Water VOSS .... $38\nMountain Dew ............... $9\nOrange Juice ................. $9\nRed Bull ....................... $12\nSprite ............................ $9\nSprunk .......................... $9\nSolo .............................. $9",false,content)
	guiSetFont(para2, "clear-normal")
	guiLabelSetColor(para2,255,255,255)
	guiLabelSetHorizontalAlign(para2, "left", true)
		
	
end

function www_clubsoho_sa_vip()
	
	www_clubsoho_sa_themes_clubsoho() -- load theme
	guiSetText(address_bar,"www.clubsoho.sa/vip") -- correct the URL
	
	-------------
	-- Content --
	-------------	
	local content_title = guiCreateLabel(10,0,400,15,"Club Soho VIP",false,content)
	guiSetFont(content_title, "default-bold-small")
	guiLabelSetColor(content_title,255,255,255)
	local title_underline = guiCreateStaticImage(10,15,400,1,"websites/colours/1.png",false,content)
		
	local para1 = guiCreateLabel(10,20,400,275, "Club Soho offers its own special VIP area. The area is designated for guests of high social and economic level, being the celebrities of the city. The VIP area gives those celebrities the opportunity to party at a public club without being attacked by crazy fans. Whenever they get tired of being a celebrity out on the public dancefloor, they can simply pass through to the VIP area to be in a relaxed atmosphere where they can party with their like-minded. The VIP areas has their own operated bars with the same drinks as in the public bar. An additional service applicable for VIP pass holders is limousine pickup from your desired starting point within Los Santos, to the club. Different extra services are available at certain times. A VIP pass for Club Soho costs $25,000 per 30 days.\n\nTo apply for a VIP pass, call 33-02-33, e-mail us to soho@saonline.sa, contact VIP manager, or drop by the reception at 1, Soho Drive. For inquiries regarding the VIP service, contact VIP manager Aiko Thomas, #58-437.",false,content)
	guiSetFont(para1, "clear-normal")
	guiLabelSetColor(para1,255,255,255)
	guiLabelSetHorizontalAlign(para1, "left", true)
	
end

function www_clubsoho_sa_contact()
	
	www_clubsoho_sa_themes_clubsoho() -- load theme
	guiSetText(address_bar,"www.clubsoho.sa/contact") -- correct the URL
	
	-------------
	-- Content --
	-------------	
	local content_title = guiCreateLabel(10,0,400,15,"Contact Information",false,content)
	guiSetFont(content_title, "default-bold-small")
	guiLabelSetColor(content_title,255,255,255)
	local title_underline = guiCreateStaticImage(10,15,400,1,"websites/colours/1.png",false,content)
	
	local para1 = guiCreateLabel(10,20,400,250, "To contact us, please refer to:\n\nSoho Corporation\n1, Soho Drive,\nRodeo,\nLos Santos.\n\nPhone: 33-02-33\nE-mail:\nWeb:\n\nC.E.O. - Jacob Goldsmith, #39-850\nC.E.O. - Snow Akiwa, #54-753\nAss. Club Manager - Enigma Royce, #56-330\nVIP Manager - Aiko Thomas, #58-437",false,content)
	guiSetFont(para1, "clear-normal")
	guiLabelSetColor(para1,255,255,255)
	guiLabelSetHorizontalAlign(para1, "left", true)
	
	local link1 = guiCreateLabel(45,151,170,15, "www.sohocorp.sa",false,content)
	guiSetFont(link1, "clear-normal")
	guiLabelSetColor(link1,255,187,0)
	guiLabelSetHorizontalAlign(link1, "left", true)
	addEventHandler("onClientGUIClick",link1,function()
		local url = tostring("www.sohocorp.sa")
		get_page(url)
	end,false)
	
	local link2 = guiCreateLabel(55,137,120,15, "soho@saonline.sa",false,content)
	guiSetFont(link2, "clear-normal")
	guiLabelSetColor(link2,255,187,0)
	guiLabelSetHorizontalAlign(link2, "left", true)
	addEventHandler("onClientGUIClick",link2,function()
		compose_mail("soho@saonline.sa")	
	end,false)
	
end