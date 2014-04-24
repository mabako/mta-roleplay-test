-------------------------------------
-- Template 3 (Grey + Pink) --
-------------------------------------

-- Website owner's forum name: Kissor
-- Website owner's Character's name: Jenny_Queen

function www_bibles_sa()
	---------------------
	-- Page Properties --
	---------------------
	local page_length = 765
	guiSetText(internet_address_label, "Bibles.sa") -- This text is displayed at the top of the browser window when the page is opened. It is the same as the <title> tag used in the meta of a real webpage.
	guiSetText(address_bar,"www.bibles.sa") -- The url of the page. This should be the same as the function name but with the original "."s and "/". Example www.google.com.
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/1.png",false,internet_pane) -- DO NOT REMOVE THE BACK GROUND.
		
	------------
	-- Header --
	------------
	local header = guiCreateStaticImage(0,0,660,20,"websites/colours/0.png",false,bg)
	local bg_2 = guiCreateStaticImage(158,20,450,745,"websites/colours/14.png",false,bg)
	
	local title_shadow = guiCreateLabel(121,24,450,45,"Bibles.sa",false,bg)
	guiLabelSetHorizontalAlign(title_shadow,"center")
	guiSetFont(title_shadow,"sa-header")
	guiLabelSetColor(title_shadow,28,28,28)
	
	local title = guiCreateLabel(120,23,450,45,"Bibles.sa",false,bg)
	guiLabelSetHorizontalAlign(title,"center")
	guiSetFont(title,"sa-header")
	guiLabelSetColor(title,128,128,128)
	
	--------------------
	-- Navigation bar --
	--------------------
	local nav_bar = guiCreateStaticImage(0,90,660,18,"websites/colours/0.png",false,bg)
	
	
	-------------
	-- Content --
	-------------
	local title_1 = guiCreateLabel(170,128,430,16,"Bibles in stock:",false,bg)
	guiLabelSetColor(title_1,153,0,102)
	local text_1 = guiCreateLabel(179,155,401,72,   "NIV Ministry/Pew Bible - 500$\
							NLT Life Application Study Bible Updated - 200$\
							Western Leather Bible Cover Large-BI133 - 1000$\
							KJV King James Study Bible - 400$\
							KJV Concord Wide-Margin Reference Bible - 410$",false,bg)
	guiLabelSetColor(text_1,28,28,28)
	guiLabelSetHorizontalAlign(text_1,"left",true)

	
	local title_2 = guiCreateLabel(170,240,430,16,"To buy a bible:",false,bg)
	local text_2 = guiCreateLabel(179,267,401,128,   "To purchase a bible, please send a e-mail to bibles@whiz.sa\
							and with the bible you want to purchase as the subject.\
							If you want to subscribe to us daily, please send a email\
							to cookiemonster@saonline.sa\
							",false,bg)
	guiLabelSetColor(title_2,153,0,102)
	guiLabelSetColor(text_2,28,28,28)
	guiLabelSetHorizontalAlign(text_2,"left",true)

	local title_3 = guiCreateLabel(170,414,430,16,"Partners:",false,bg)
	local text_3 = guiCreateLabel(179,429,401,64,   "Fields Incorporated\
							www.fields.sa",false,bg)
	guiLabelSetColor(title_3,153,0,102)
	guiLabelSetColor(text_3,28,28,28)
	guiLabelSetHorizontalAlign(text_3,"left",true)
	addEventHandler("onClientGUIClick",text_3,function()
		local url = tostring("www.fields.sa")
		get_page(url)
	end,false)
	
	local designer_link = guiCreateStaticImage(519,286,146,110, "websites/images/izanagi-black.png", false, bg)

	addEventHandler("onClientGUIClick",designer_link,function()
		local url = tostring("www.izanagi.sa")
		get_page(url)
	end,false)

	
	----------------------------------------------- End of webpage -- Do not edit below this line. -----------------------------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,460,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, true)
	end
end


