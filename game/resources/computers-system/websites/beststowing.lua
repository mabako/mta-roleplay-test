-----------------------------------------------------------
------------------Los Santos Towing & Recovery------------------
-----------------------------------------------------------
----------Scripted by Morgfarm1 aka Dale Greene------------
-----------------------------------------------------------

--Site Owner's Char. Name: Dale_Greene
--Site Owner's Forum Name: Morgfarm1

--------------------------------START WEBSITE-----------------------------------

-----------------Home Page-------------------

function www_beststowing_sa()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Los Santos Towing & Recovery - Home")
	guiSetText(address_bar,"www.beststowing.sa")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/53.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,0,0,192)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiLabelSetColor(jobs_link,0,0,192)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiLabelSetColor(places_link,0,0,192)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,btr_logo)
		local corporate_link = guiCreateLabel(610,52,62,22,"Contact",false,bg)
		guiLabelSetColor(corporate_link,0,0,192)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corperate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	local top_story_image2 = guiCreateStaticImage(95,500,280,189,"websites/images/btr.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/1.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"About Los Santos Towing & Recovery",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Text
	local article =  guiCreateLabel(10,318,440,410,"Welcome to LST&R's Website. Here you can learn about what LST&R is and what it does,\
	How it works and how it affects you. If you find your vehicle has been towed and impounded, you can pick it up at our impound lot\
	at our Headquarters on Saints Boulevard in East Beach, Los Santos. If you feel it has been towed and was parked legitamatly,\
	Feel free to use the report section (( or the forums outside the game )). Make sure to tell us the vehicles Make and Model, Color and license plate number\
	along with any photographs of the vehicle and a License plate number. (( Vehicle ID number )).\
	Here is exactly where our building is located",false,bg)
	guiLabelSetColor(article,38,38,38)

	guiLabelSetHorizontalAlign(article,"left",true)

	
-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/0.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LST&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About LST&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- LST&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for LST&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_5_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_5 = guiCreateLabel(490,178,142,16,"Apply at LST&R",false,bg)
		guiLabelSetColor(top_link_5,38,38,38)
		addEventHandler("onClientGUIClick",top_link_5,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
			-- Mechanics Division
		local top_link_6_bp = guiCreateStaticImage(474,201,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_6 = guiCreateLabel(490,194,142,16,"LST&R's Mechanics Division",false,bg)
		guiLabelSetColor(top_link_6,38,38,38)
		addEventHandler("onClientGUIClick",top_link_6,function()
				local url = tostring("www.beststowing.sa/mechanics")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"LST&R       2010 Los Santos Towing & Recovery. All Rights Reserved.",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
	
----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end

-------------------------------Services--------------------------------

function www_beststowing_sa_services()

	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Los Santos Towing & Recovery - Services")
	guiSetText(address_bar,"www.beststowing.sa/services")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/53.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,0,0,192)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiLabelSetColor(jobs_link,0,0,192)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiLabelSetColor(places_link,0,0,192)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,btr_logo)
		local corporate_link = guiCreateLabel(610,52,62,22,"Contact",false,bg)
		guiLabelSetColor(corporate_link,0,0,192)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corperate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/1.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"LST&R Services",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Text
	local article =  guiCreateLabel(10,318,440,410,"LST&R Offers a wide range of services for todays auto owner and commuter. Not only do we specialize in towing, we also do mechanic work.\
	All LST&R Drivers are trained mechanics. We can do anything from a minor body repair or tank top off, to extensive modifications ((Mods currently disbled server-side)). All you have to do is call our hotline at 999.\
	Our Basic Pricing is as follows:\
	\
	Body Repairs: $50-100, depending on severity.\
	\
	Full Service Repairs: $100-200, Depending on what needs done & Severity of existing damage\
	\
	Fuel: $15-20 per can (Quarter Tank) or up to $150 for a full tank, depending on how far we have to travel.\
	\
	Paint: $100-200, depending on if the vehicle has 1, 2, 3 or more color options ((ID sets))\
	\
	Modifications: All modifications differ in price, usually from $2500 to $9000 PER PART, depending on the part(s)\
	\
	SPECIAL NOTICE: Any and all Special paint jobs have a minimum charge of $7800, INCLUDING THE REMOVAL OF SUCH PAINT JOBS.\
	A Special paint job change with a regular paint change (( Changes the tone and appearance of the skin )) will cost between $7900 and $8000, No exceptions.\
	\
	Towing: There may be a $50 towing charge to Unity Garage."
	,false,bg)
	
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)

	
-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/0.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LST&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About LST&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- LST&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for LST&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_5_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_5 = guiCreateLabel(490,178,142,16,"Apply at LST&R",false,bg)
		guiLabelSetColor(top_link_5,38,38,38)
		addEventHandler("onClientGUIClick",top_link_5,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
			-- Mechanics Division
		local top_link_6_bp = guiCreateStaticImage(474,201,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_6 = guiCreateLabel(490,194,142,16,"LST&R's Mechanics Division",false,bg)
		guiLabelSetColor(top_link_6,38,38,38)
		addEventHandler("onClientGUIClick",top_link_6,function()
				local url = tostring("www.beststowing.sa/mechanics")
				get_page(url)
			end,false)
	-----------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"LST&R       2010 Los Santos Towing & Recovery. All Rights Reserved.",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
	
	----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end

-------------------Drivers-------------------

function www_beststowing_sa_drivers()

	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Los Santos Towing & Recovery - Drivers")
	guiSetText(address_bar,"www.beststowing.sa/drivers")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/53.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,0,0,192)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiLabelSetColor(jobs_link,0,0,192)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiLabelSetColor(places_link,0,0,192)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,btr_logo)
		local corporate_link = guiCreateLabel(610,52,62,22,"Contact",false,bg)
		guiLabelSetColor(corporate_link,0,0,192)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corperate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/1.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"The Bosses of LST&R",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Text
	local article =  guiCreateLabel(10,318,440,410,"Owner & CEO: Dale Greene\
	Assistant CEO: James Fields\
	Supervisor: Rachel Wood\
	Supervisor: Ashley Greene\
	Team Leader: Junior Alvarez"
	,false,bg)
	
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)

	
-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/0.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LST&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About LST&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- LST&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for LST&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_5_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_5 = guiCreateLabel(490,178,142,16,"Apply at LST&R",false,bg)
		guiLabelSetColor(top_link_5,38,38,38)
		addEventHandler("onClientGUIClick",top_link_5,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
			-- Mechanics Division
		local top_link_6_bp = guiCreateStaticImage(474,201,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_6 = guiCreateLabel(490,194,142,16,"LST&R's Mechanics Division",false,bg)
		guiLabelSetColor(top_link_6,38,38,38)
		addEventHandler("onClientGUIClick",top_link_6,function()
				local url = tostring("www.beststowing.sa/mechanics")
				get_page(url)
			end,false)
			
	-----------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"LST&R       2010 Los Santos Towing & Recovery. All Rights Reserved.",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
	-------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end	

--------------------Contact------------------

function www_beststowing_sa_contact()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Los Santos Towing & Recovery - Contact")
	guiSetText(address_bar,"www.beststowing.sa/contact")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/53.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,0,0,192)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiLabelSetColor(jobs_link,0,0,192)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiLabelSetColor(places_link,0,0,192)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,btr_logo)
		local corporate_link = guiCreateLabel(610,52,62,22,"Contact",false,bg)
		guiLabelSetColor(corporate_link,0,0,192)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corperate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/1.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"Contact",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Text
	local article =  guiCreateLabel(10,318,440,410,"How to Contact the Bosses of LST&R:\
	Owner & CEO Dale Greene: D.Greene@btr.sa\
	Assistant CEO James Fields: J.Fields@btr.sa\
	Supervisor Ashley Greene: No Contact information at this time\
	Supervisor Rachel Wood: No Contact information at this time\
	Team Leader Junior Alvarez: No contact information at this time"
 	,false,bg)
 	
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)
	
-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/1.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LST&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About LST&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- LST&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for LST&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_5_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_5 = guiCreateLabel(490,178,142,16,"Apply at LST&R",false,bg)
		guiLabelSetColor(top_link_5,38,38,38)
		addEventHandler("onClientGUIClick",top_link_5,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
			-- Mechanics Division
		local top_link_6_bp = guiCreateStaticImage(474,201,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_6 = guiCreateLabel(490,194,142,16,"LST&R's Mechanics Division",false,bg)
		guiLabelSetColor(top_link_6,38,38,38)
		addEventHandler("onClientGUIClick",top_link_6,function()
				local url = tostring("www.beststowing.sa/mechanics")
				get_page(url)
			end,false)
			
	-----------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"LST&R       2010 Los Santos Towing & Recovery. All Rights Reserved.",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
	-------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end	
			
----------------About LST&R----------------------------

function www_beststowing_sa_aboutus()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Los Santos Towing & Recovery - About")
	guiSetText(address_bar,"www.beststowing.sa/aboutus")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/53.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,0,0,192)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiLabelSetColor(jobs_link,0,0,192)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiLabelSetColor(places_link,0,0,192)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,btr_logo)
		local corporate_link = guiCreateLabel(610,52,62,22,"Contact",false,bg)
		guiLabelSetColor(corporate_link,0,0,192)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corperate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/1.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"About Los Santos Towing & Recovery",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Text
	local article =  guiCreateLabel(10,318,440,410,"Everyone at LST&R Strives to give you fast service at an affordable rate and exceptional quality.\Our Specialty is the towing of obstructive vehicles and\
	the repair of your damaged ones. We also do automotive paint, modifications and roadside assistance.\
	Visit the Services section for information about these services",false,bg)
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)

	
-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/0.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LST&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About LST&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- LST&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for LST&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_5_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_5 = guiCreateLabel(490,178,142,16,"Apply at LST&R",false,bg)
		guiLabelSetColor(top_link_5,38,38,38)
		addEventHandler("onClientGUIClick",top_link_5,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
			-- Mechanics Division
		local top_link_6_bp = guiCreateStaticImage(474,201,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_6 = guiCreateLabel(490,194,142,16,"LST&R's Mechanics Division",false,bg)
		guiLabelSetColor(top_link_6,38,38,38)
		addEventHandler("onClientGUIClick",top_link_6,function()
				local url = tostring("www.beststowing.sa/mechanics")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"LST&R       2010 Los Santos Towing & Recovery. All Rights Reserved.",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
	
----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end

--------------------Jobs Info--------------------------

function www_beststowing_sa_jobs()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Los Santos Towing & Recovery - Employment")
	guiSetText(address_bar,"www.beststowing.sa/jobs")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/53.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,0,0,192)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiLabelSetColor(jobs_link,0,0,192)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiLabelSetColor(places_link,0,0,192)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,btr_logo)
		local corporate_link = guiCreateLabel(610,52,62,22,"Contact",false,bg)
		guiLabelSetColor(corporate_link,0,0,192)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corperate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/1.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"Employment at LST&R",false,bg)
	guiSetFont(title,"default-bold-small")

	-- Article
	local article =  guiCreateLabel(10,320,440,410,"If you seek a job at LST&R, we have a few requirements you must meet. First, You must be 18 years of age or older. Second, no major criminal backround, and you must also have a Valid State of San Andreas Driver's License\
	You must also know the rules of the road, as stated in the 'Los Santos Highway Code' Driver's manual. A criminal History may or may not be a factor in your potential hiring, but is always considered.\
	To Apply,Visit the 'Apply at LST&R' Section of this website. Please leave your name, daytime and night time phone numbers, and Reasons why you think\
	You should be considered for work at Los Santos Towing and Recovery.\
	All necesarry questions are on the page (( watch the forums out-of-game )).",false,bg)
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)
	
-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/1.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LST&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About LST&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- LST&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for LST&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_5_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_5 = guiCreateLabel(490,178,142,16,"Apply at LST&R",false,bg)
		guiLabelSetColor(top_link_5,38,38,38)
		addEventHandler("onClientGUIClick",top_link_5,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
			-- Mechanics Division
		local top_link_6_bp = guiCreateStaticImage(474,201,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_6 = guiCreateLabel(490,194,142,16,"LST&R's Mechanics Division",false,bg)
		guiLabelSetColor(top_link_6,38,38,38)
		addEventHandler("onClientGUIClick",top_link_6,function()
				local url = tostring("www.beststowing.sa/mechanics")
				get_page(url)
			end,false)
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"LST&R       2010 Los Santos Towing & Recovery. All Rights Reserved.",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
	
	----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end
		
---------------------------About 999 Hotline------------------------------------------		

function www_beststowing_sa_999()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Los Santos Towing & Recovery - About Our Hotline")
	guiSetText(address_bar,"www.beststowing.sa/999")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/53.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,0,0,192)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiLabelSetColor(jobs_link,0,0,192)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiLabelSetColor(places_link,0,0,192)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,btr_logo)
		local corporate_link = guiCreateLabel(610,52,62,22,"Contact",false,bg)
		guiLabelSetColor(corporate_link,0,0,192)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corperate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/1.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"Proper Use of 999",false,bg)
	guiSetFont(title,"default-bold-small")

	-- Article
	local article =  guiCreateLabel(10,318,440,410,"999 Is used for all service calls. When you call, our operator will ask you your location, and whats wrong.\ When you call LST&R, please wait atleast 15 to 20 minutes, depending on how busy the city is. Your Response time should never be more than 20 minutes. If time exceeds 20 minutes, call again.\
	Please do not call every 5 to 10 minutes, as we will likely ignore calls from that area until further notice. we do not like pushy and impatient people. We do the best we can. DO NOT USE THE GPS SIGNAL UNLESS AUTHORIZED BY LST&R STAFF. That signal is designated for Police and Emergency Services use.\
	If you have to call more than twice, and you see our Yellow and Blue towtrucks are about, you may report it at the link to your right and it will be properly dealt with.",false,bg)
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)
	
-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/1.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LST&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About LST&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- LST&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for LST&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_5_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_5 = guiCreateLabel(490,178,142,16,"Apply at LST&R",false,bg)
		guiLabelSetColor(top_link_5,38,38,38)
		addEventHandler("onClientGUIClick",top_link_5,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
			-- Mechanics Division
		local top_link_6_bp = guiCreateStaticImage(474,201,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_6 = guiCreateLabel(490,194,142,16,"LST&R's Mechanics Division",false,bg)
		guiLabelSetColor(top_link_6,38,38,38)
		addEventHandler("onClientGUIClick",top_link_6,function()
				local url = tostring("www.beststowing.sa/mechanics")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"LST&R       2010 Los Santos Towing & Recovery. All Rights Reserved.",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
	
	----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end

-------------------------Report Incidents------------------

function www_beststowing_sa_report()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Los Santos Towing & Recovery - Report A Driver")
	guiSetText(address_bar,"www.beststowing.sa/report")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/53.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,0,0,192)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiLabelSetColor(jobs_link,0,0,192)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiLabelSetColor(places_link,0,0,192)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,btr_logo)
		local corporate_link = guiCreateLabel(610,52,62,22,"Contact",false,bg)
		guiLabelSetColor(corporate_link,0,0,192)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corperate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/1.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"About Los Santos Towing & Recovery",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Article
	local article =  guiCreateLabel(10,318,440,410,"To report unanswered calls or drivers, please e-mail one of our CEO's. Dale Greene: D.Greene@btr.sa or James Fields: J.Fields@btr.sa. Please leave your name, daytime phone number and the location of your call.\
	If you are reporting a driver, Also tell us the drivers name and the time the incident occoured. (( Or visit the forums and report a driver through there ))",false,bg)
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)
	
-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/1.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LST&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About LST&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- LST&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for LST&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_5_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_5 = guiCreateLabel(490,178,142,16,"Apply at LST&R",false,bg)
		guiLabelSetColor(top_link_5,38,38,38)
		addEventHandler("onClientGUIClick",top_link_5,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
			-- Mechanics Division
		local top_link_6_bp = guiCreateStaticImage(474,201,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_6 = guiCreateLabel(490,194,142,16,"LST&R's Mechanics Division",false,bg)
		guiLabelSetColor(top_link_6,38,38,38)
		addEventHandler("onClientGUIClick",top_link_6,function()
				local url = tostring("www.beststowing.sa/mechanics")
				get_page(url)
			end,false)
			
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"LST&R       2010 Los Santos Towing & Recovery. All Rights Reserved.",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
	
	----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end

------------------Applying Information-------------------

function www_beststowing_sa_apply()

	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Los Santos Towing & Recovery - Applications (Beta)")
	guiSetText(address_bar,"www.beststowing.sa/apply")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/53.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,0,0,192)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiLabelSetColor(jobs_link,0,0,192)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiLabelSetColor(places_link,0,0,192)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,btr_logo)
		local corporate_link = guiCreateLabel(610,52,62,22,"Contact",false,bg)
		guiLabelSetColor(corporate_link,0,0,192)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corperate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
		
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/1.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"Part 1 - IC Section",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Text
	local article =  guiCreateLabel(10,318,440,375,"(( Use the forums at www.valhallagaming.net, Go to the MTA Section>Legal Factions> Los Santos Towing & Recovery ))"
	,false,bg)
	
		
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)

	
-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/1.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LST&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About LST&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- LST&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for LST&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_5_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_5 = guiCreateLabel(490,178,142,16,"Apply at LST&R",false,bg)
		guiLabelSetColor(top_link_5,38,38,38)
		addEventHandler("onClientGUIClick",top_link_5,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
			-- Mechanics Division
		local top_link_6_bp = guiCreateStaticImage(474,201,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_6 = guiCreateLabel(490,194,142,16,"LST&R's Mechanics Division",false,bg)
		guiLabelSetColor(top_link_6,38,38,38)
		addEventHandler("onClientGUIClick",top_link_6,function()
				local url = tostring("www.beststowing.sa/mechanics")
				get_page(url)
			end,false)	
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"LST&R       2010 Los Santos Towing & Recovery. All Rights Reserved.",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
	
	----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end

---------------------Mechanics Division----------------------------

function www_beststowing_sa_mechanics()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Los Santos Towing & Recovery - Mechanics Division")
	guiSetText(address_bar,"www.beststowing.sa/mechanics")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/53.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,0,0,192)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiLabelSetColor(jobs_link,0,0,192)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiLabelSetColor(places_link,0,0,192)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,btr_logo)
		local corporate_link = guiCreateLabel(610,52,62,22,"Contact",false,bg)
		guiLabelSetColor(corporate_link,0,0,192)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corperate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/1.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"About Los Santos Towing & Recovery",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Text
	local article =  guiCreateLabel(10,318,440,410,"After the LST&R Mechanics Division died just prior to the transfer of ownership from Hans Vanderburg to Nicky Corozzo,\
	The LST&R Mechanics Team was dissolved and those members became Towtruck Drivers. Due to more and more repair service calls, We are happy to announce the return of the LST&R\
	Mechanic Team. You do nothing different to contact our mechanics; Call 999, state you need a repair, and a service truck will come examine your vehicle.\
	If the damage is to heavy to drive, Contact a towtruck and the towtruck will take you to the Unity Repair Center for service where a mechanic will be waiting, you can then drop\
	off your vehicle while its being fixed and pick it up when its finished."
	,false,bg)
	
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)

	
-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/1.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LST&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About LST&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- LST&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for LST&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_5_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_5 = guiCreateLabel(490,178,142,16,"Apply at LST&R",false,bg)
		guiLabelSetColor(top_link_5,38,38,38)
		addEventHandler("onClientGUIClick",top_link_5,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
			-- Mechanics Division
		local top_link_6_bp = guiCreateStaticImage(474,201,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_6 = guiCreateLabel(490,194,142,16,"LST&R's Mechanics Division",false,bg)
		guiLabelSetColor(top_link_6,38,38,38)
		addEventHandler("onClientGUIClick",top_link_6,function()
				local url = tostring("www.beststowing.sa/mechanics")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"LST&R       2010 Los Santos Towing & Recovery. All Rights Reserved.",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
	
	----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end

---------------END WEBSITE--------------