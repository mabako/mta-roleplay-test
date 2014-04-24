--------------------------------
-- SOHO DEVELOPMENT HOME PAGE --
--------------------------------

-- Website owner's forum name: Exciter
-- Website owner's Character's name: Jacob Goldsmith
-- Last update: 04/06/2011 (DD/MM/YYYY)

local content

function www_sohocorp_sa_themes_soho(desiredLength)
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
	guiSetText(internet_address_label, "Soho Corporation") -- This text is displayed at the top of the browser window when the page is opened. It is the same as the <title> tag used in the meta of a real webpage. Only change the text between the quotation marks.
	guiSetText(address_bar,"www.sohocorp.sa/themes/soho") -- The url of the page. This should be the same as the function name but with the original "."s and "/". Example www.google.com.
	
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
	local header = guiCreateStaticImage(0,0,wrapper_width,70,"websites/colours/7.png",false,wrapper)
	local nav = guiCreateStaticImage(0,50,wrapper_width,16,"websites/colours/1.png",false,header) --51-8
	--local space = guiCreateStaticImage(0,80,wrapper_width,10,"websites/colours/0.png",false,header)	
	local slogan = guiCreateLabel(5,5,400,40,"Soho Corporation",false,header)
	guiSetFont(slogan, "sa-header")
	
	----------
	-- Menu --
	----------
	local menu_link1_txt = guiCreateLabel(85,0,40,15,"Home",false,nav)
	guiLabelSetColor(menu_link1_txt,0,0,0)
	guiSetFont(menu_link1_txt, "default-bold-small")
	guiLabelSetHorizontalAlign(menu_link1_txt, "center", false)
	
	addEventHandler("onClientGUIClick",menu_link1_txt,function()
		local url = tostring("www.sohocorp.sa")
		get_page(url)
	end,false)
	
	local menu_link2_txt = guiCreateLabel(139,0,50,15,"About",false,nav)
	guiLabelSetColor(menu_link2_txt,0,0,0)
	guiSetFont(menu_link2_txt, "default-bold-small")
	guiLabelSetHorizontalAlign(menu_link2_txt, "center", false)
	
	addEventHandler("onClientGUIClick",menu_link2_txt,function()
		local url = tostring("www.sohocorp.sa/about")
		get_page(url)
	end,false)
	
	local menu_link3_txt = guiCreateLabel(203,0,50,15,"Estate",false,nav)
	guiLabelSetColor(menu_link3_txt,0,0,0)
	guiSetFont(menu_link3_txt, "default-bold-small")
	guiLabelSetHorizontalAlign(menu_link3_txt, "center", false)
	
	addEventHandler("onClientGUIClick",menu_link3_txt,function()
		local url = tostring("www.sohocorp.sa/estate")
		get_page(url)
	end,false)
	
	local menu_link4_txt = guiCreateLabel(267,0,59,15,"Facilities",false,nav)
	guiLabelSetColor(menu_link4_txt,0,0,0)
	guiSetFont(menu_link4_txt, "default-bold-small")
	guiLabelSetHorizontalAlign(menu_link4_txt, "center", false)
	
	addEventHandler("onClientGUIClick",menu_link4_txt,function()
		local url = tostring("www.sohocorp.sa/facilities")
		get_page(url)
	end,false)
	
	local menu_link5_txt = guiCreateLabel(340,0,51,15,"Contact",false,nav)
		guiLabelSetColor(menu_link5_txt,0,0,0)
		guiSetFont(menu_link5_txt, "default-bold-small")
		guiLabelSetHorizontalAlign(menu_link5_txt, "center", false)
		
		addEventHandler("onClientGUIClick",menu_link5_txt,function()
			local url = tostring("www.sohocorp.sa/contact")
			get_page(url)
	end,false)
	
	-------------
	-- Content --
	-------------
	content = guiCreateStaticImage(0,90,wrapper_width,content_length,"websites/colours/1.png",false,wrapper)
	
	--fbox_small1 = guiCreateStaticImage(420,0,130,135,"websites/colours/3.png",false,content)
	--fbox_small2 = guiCreateStaticImage(420,145,130,135,"websites/colours/3.png",false,content)
	
	------------
	-- Footer --
	------------
	local footer = guiCreateStaticImage(50,wrapper_length + 10,wrapper_width,20,"websites/colours/111.png",false,bg)
	local footer_txt = guiCreateLabel(0,0,wrapper_width,20,"Soho Corporation, 1, Soho Drive, Rodeo. soho@saonline.sa.",false,footer)
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

function www_sohocorp_sa()
	
	www_sohocorp_sa_themes_soho() -- load theme
	guiSetText(address_bar,"www.sohocorp.sa") -- correct the URL
	
	-------------
	-- Content --
	-------------	
	local fbox1 = guiCreateStaticImage(30,10,150,120,"websites/colours/7.png",false,content)
	local fbox1i = guiCreateStaticImage(3,17,144,100,"websites/colours/1.png",false,fbox1)
	local fbox1h = guiCreateLabel(0,0,150,15, "Our Businesses",false,fbox1)
	guiSetFont(fbox1h, "clear-normal")
	guiLabelSetColor(fbox1h,255,255,255)
	guiLabelSetHorizontalAlign(fbox1h, "center", true)
	local fbox1_li1 = guiCreateLabel(3,0,138,15, "Hotel Soho",false,fbox1i)
	guiSetFont(fbox1_li1, "clear-normal")
	guiLabelSetColor(fbox1_li1,0,0,255)
	addEventHandler("onClientGUIClick",fbox1_li1,function()
		local url = tostring("www.hotelsoho.sa")
		get_page(url)
	end,false)
	local fbox1_li2 = guiCreateLabel(3,18,138,15, "Club Soho",false,fbox1i)
	guiSetFont(fbox1_li2, "clear-normal")
	guiLabelSetColor(fbox1_li2,0,0,255)
	addEventHandler("onClientGUIClick",fbox1_li2,function()
		local url = tostring("www.clubsoho.sa")
		get_page(url)
	end,false)
	--TBA
	--local fbox1_li3 = guiCreateLabel(3,36,138,15, "Blue",false,fbox1i)
	--guiSetFont(fbox1_li3, "clear-normal")
	--guiLabelSetColor(fbox1_li3,0,0,255)
	--addEventHandler("onClientGUIClick",fbox1_li3,function()
	--	local url = tostring("www.blue.sa")
	--	get_page(url)
	--end,false)
	
	
	local fbox2 = guiCreateStaticImage(200,10,150,120,"websites/colours/7.png",false,content)
	local fbox2i = guiCreateStaticImage(3,17,144,100,"websites/colours/1.png",false,fbox2)
	local fbox2h = guiCreateLabel(0,0,150,15, "Hire Premises",false,fbox2)
	guiSetFont(fbox2h, "clear-normal")
	guiLabelSetColor(fbox2h,255,255,255)
	guiLabelSetHorizontalAlign(fbox2h, "center", true)
	local fbox2_li1 = guiCreateLabel(3,0,138,15, "Soho Conference Hall",false,fbox2i)
	guiSetFont(fbox2_li1, "clear-normal")
	guiLabelSetColor(fbox2_li1,0,0,0)
	local fbox2_li2 = guiCreateLabel(3,18,138,15, "Club Soho",false,fbox2i)
	guiSetFont(fbox2_li2, "clear-normal")
	guiLabelSetColor(fbox2_li2,0,0,0)
	local fbox2_li3 = guiCreateLabel(3,36,138,15, "Meeting Rooms",false,fbox2i)
	guiSetFont(fbox2_li3, "clear-normal")
	guiLabelSetColor(fbox2_li3,0,0,0)
	
	local fbox3 = guiCreateStaticImage(370,10,150,120,"websites/colours/7.png",false,content)
	local fbox3i = guiCreateStaticImage(3,17,144,100,"websites/colours/1.png",false,fbox3)
	local fbox3h = guiCreateLabel(0,0,150,15, "Contact Us",false,fbox3)
	guiSetFont(fbox3h, "clear-normal")
	guiLabelSetColor(fbox3h,255,255,255)
	guiLabelSetHorizontalAlign(fbox3h, "center", true)
	local fbox3_li1 = guiCreateLabel(3,0,138,140, "Phone: 33-02-33 \nMail: soho@saonline.sa \nAddress: 1, Soho Drive, Rodeo, \nLos Santos. \n\nCEO Jacob Goldsmith, #39-850 \nCEO Snow Akiwa, #54-753",false,fbox3i)
	guiSetFont(fbox3_li1, "default-small")
	guiLabelSetColor(fbox3_li1,0,0,0)
	
	local para1 = guiCreateLabel(30,150,500,150, "Welcome to the Soho Corporation's homepages. Our clients use us to rent our premises (such as conference hall, meeting rooms or clubs and bars for private parties), for purchasing or renting their very own offices, or hire our architect team to design premises for their premises. Contact us today for more information about our services.",false,content)
	guiSetFont(para1, "clear-normal")
	guiLabelSetColor(para1,0,0,0)
	guiLabelSetHorizontalAlign(para1, "left", true)
		
	
end

function www_sohocorp_sa_about()
	
	www_sohocorp_sa_themes_soho(505) -- load theme
	guiSetText(address_bar,"www.sohocorp.sa/about") -- correct the URL
	
	-------------
	-- Content --
	-------------	
	local content_title = guiCreateLabel(10,0,400,15,"About",false,content)
	guiSetFont(content_title, "default-bold-small")
	guiLabelSetColor(content_title,0,0,0)
	local title_underline = guiCreateStaticImage(10,15,520,1,"websites/colours/0.png",false,content)
	
	local para1 = guiCreateLabel(10,20,540,365, "The company was founded early 2000 by Jacob Goldsmith, as Soho Development Company, with a vision of bringing life to the wonderful district of Soho, a small district within Rodeo in Los Santos. The company started out with the etablation of Hotel Soho, an old unused hotel building. After investing a lot in renovating, employment and marketing, the hotel did not take long to become a well-regarded landmark in Los Santos. \n\nToday we've changed a lot since our initial startup. We've expanded our business goals noticeably, and is today a large corporation with several different subsidiaries. Today Soho Corporation is the biggest investor in the Soho district, holding responsibility for the majority of the buildings in the district. The company's main focus is still to continiously improve the Soho district, mainly through the operation and development of business possibilities and popular public premises - both for internal use and for other companies. Yet, the company is today also offering its services - its skilled team of investors, marketers, architects and planners - to other companies as clients, regardless of location and district. \n\nAlthough we are today expanding to work on enhancing businesses all around Los Santos, the Soho Corporation hopes to continue the work for the district of Soho for many more years, with the support of the local community and investors. We would like to thank everyone contributing to making Soho the unique, bussy place it is. We could not have done it alone.",false,content)
	guiSetFont(para1, "clear-normal")
	guiLabelSetColor(para1,0,0,0)
	guiLabelSetHorizontalAlign(para1, "left", true)	
end

function www_sohocorp_sa_estate()
	
	www_sohocorp_sa_themes_soho() -- load theme
	guiSetText(address_bar,"www.sohocorp.sa/estate") -- correct the URL
	
	-------------
	-- Content --
	-------------	
	local content_title = guiCreateLabel(10,0,400,15,"Estate",false,content)
	guiSetFont(content_title, "default-bold-small")
	guiLabelSetColor(content_title,0,0,0)
	local title_underline = guiCreateStaticImage(10,15,520,1,"websites/colours/0.png",false,content)
	
	local para1 = guiCreateLabel(10,20,540,200, "Looking to buy or sell offices or other business premises? Contact us today for an offer. We offer some of the most demanded office spaces of Los Santos, and we are continiously developing and looking for new business possibilities both for ourselves and our clients. \n\nAre you planning to renovate your current premises, or perhaps build a new place? Our team of architects and planners would love to help you in the process. We will together with you solve every aspect, from start and to the point where you have hired your construction company to bring life to the plans. Contact us today for more information.",false,content)
	guiSetFont(para1, "clear-normal")
	guiLabelSetColor(para1,0,0,0)
	guiLabelSetHorizontalAlign(para1, "left", true)	
end

function www_sohocorp_sa_facilities()
	
	www_sohocorp_sa_themes_soho(595) -- load theme
	guiSetText(address_bar,"www.sohocorp.sa/facilities") -- correct the URL
	
	-------------
	-- Content --
	-------------	
	local content_title = guiCreateLabel(10,0,400,15,"Facilities",false,content)
	guiSetFont(content_title, "default-bold-small")
	guiLabelSetColor(content_title,0,0,0)
	local title_underline = guiCreateStaticImage(10,15,520,1,"websites/colours/0.png",false,content)
	
	local para1 = guiCreateLabel(10,20,540,455, "Soho Conference Hall \nOur conference hall located within the office complex at 1, Soho Drive, Rodeo, 2nd floor, is the ideal place for your business conferences, press conferences or large meetings. The hall is also ideal for showbiz, working good as a small stage for comedians, artists, or even as a movie theatre. The place can house a total of 24 guests in the audience, and is equipped with a sophisticated sound, lighting and AV rig. Outside the hall itself is a small cafe that offers a social, relaxing atmosphere. Our conference hall can be rented for $5,000 each period. One period equals 30 minutes. \n\nClub Soho \nIf you're looking for a place to host your private party, or a night out for your employees, Club Soho might be the perfect spot. Outside the regular opening hours, the club is available for hire for private events. The club is one of the most classy ones in Los Santos, being a high-society club in the luxury district of Soho. The club is located at 1, Silk Road, Rodeo, just behind the office complex and Hotel Soho. The club can be rented for $25,000 per hour, including bartenders. \n\nMeeting Rooms \nThe most important decisions in a business are usualy taken as a group in a meeting room. If your business needs a room to hold your meetings, we got the solution. Our meeting room at the office complex at 1, Soho Drive, Rodeo houses 7 participants and is equipped with TV, video player and a projector. The room can be rented for as low as $500 each period, one period equaling 30 minutes. Other meeting rooms may be made available upon request. \n\nAdditional Security \nNone of our current rental prices includes security other than installed CCTV and alarms, and reception service. If you however desires security guards for your event, our small internal security department, complimented with guards from the leading security firms on the market, will be available to your disposal. Additional security fees will apply. Contact us for a offer.",false,content)
	guiSetFont(para1, "clear-normal")
	guiLabelSetColor(para1,0,0,0)
	guiLabelSetHorizontalAlign(para1, "left", true)	
end

function www_sohocorp_sa_contact()
	
	www_sohocorp_sa_themes_soho() -- load theme
	guiSetText(address_bar,"www.sohocorp.sa/contact") -- correct the URL
	
	-------------
	-- Content --
	-------------	
	local content_title = guiCreateLabel(10,0,400,15,"Contact",false,content)
	guiSetFont(content_title, "default-bold-small")
	guiLabelSetColor(content_title,0,0,0)
	local title_underline = guiCreateStaticImage(10,15,520,1,"websites/colours/0.png",false,content)
	
	local para1 = guiCreateLabel(10,20,540,300, "Are you ready to enhance your business? Want to learn more about our services? On the look for new premises for your company? Wanting to take part as an investor? We're waiting to hear from you! \n\nContact information: \nSoho Corporation\nPhone (hotline): 33-02-33\nE-mail: soho@saonline.sa\nPostal/visiting address:\n1, Soho Drive,\nRodeo,\nLos Santos,\nUnited States.\n\nContact persons:\nC.E.O. Jacob Goldsmith, #39-850.\nC.E.O. Snow Akiwa, #54-753.",false,content)
	guiSetFont(para1, "clear-normal")
	guiLabelSetColor(para1,0,0,0)
	guiLabelSetHorizontalAlign(para1, "left", true)	
end