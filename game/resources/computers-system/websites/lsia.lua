-- www.lsia.sa
-- Los Santos International Airport
-- Website owner's forum name: fallenmaster1
-- Website owner's Character's name: Alissa Walton

function lsiaCreateHeader()
	--local banner = guiCreateStaticImage(0,0,660,60,"websites/colours/36.png",false,bg)
	
	local logo = guiCreateStaticImage(7,5,146,50,"websites/images/lsia.png",false,bg)
	guiCreateStaticImage(152,5,1,46,"websites/colours/36.png",false,bg)
	
	lsiaCreateMenu()
end

function lsiaCreateMenu()
	local pages = {
		{ ["title"] = "Career Opportunities", ["location"] = "www.lsia.sa" },
		{ ["title"] = "Aircraft Rental", ["location"] = "www.lsia.sa/rental" },
		{ ["title"] = "Flight School", ["location"] = "www.lsia.sa/flightschool" },
		{ ["title"] = "Information & Contact", ["location"] = "www.lsia.sa/contact" }
	}
	
	local currentPage = guiGetText(address_bar)
	local pageTitle = ""
	local horizontalOffset = 160
	local verticalOffset = 11
	local verticalCount = 0
	
	for key, page in pairs(pages) do
		if verticalCount > 1 then
			verticalCount = 0
			verticalOffset = 11
			horizontalOffset = horizontalOffset + 150
		end
		local pageShadowLabel = guiCreateLabel(horizontalOffset + 13,verticalOffset + 1,200,16,page["title"],false,bg)
		guiLabelSetColor(pageShadowLabel,0,0,0)
		
		local pageLabel = guiCreateLabel(horizontalOffset + 13,verticalOffset,200,16,page["title"],false,bg)
		
		addEventHandler("onClientGUIClick",pageLabel,function()
				local url = tostring(page["location"])
				get_page(url)
			end,false)
		
		local labelWidth = guiLabelGetTextExtent(pageLabel)
		local labelHeight = guiLabelGetFontHeight(pageLabel)
		
		guiCreateStaticImage(horizontalOffset + 2,verticalOffset + labelHeight / 2 - 1,6,6,"websites/colours/0.png",false,bg)
		if page["location"] == guiGetText(address_bar) then
			pageTitle = page["title"]
			guiCreateStaticImage(horizontalOffset + 2,verticalOffset + labelHeight / 2 - 2,6,6,"websites/colours/1.png",false,bg)
			guiLabelSetColor(pageLabel,255,255,255)
		else
			guiCreateStaticImage(horizontalOffset + 2,verticalOffset + labelHeight / 2 - 2,6,6,"websites/colours/105.png",false,bg)
			guiLabelSetColor(pageLabel,100,104,106)
		end
		
		verticalOffset = verticalOffset + labelHeight + 3
		verticalCount = verticalCount + 1
	end
	
	guiCreateStaticImage(0,60,660,1,"websites/colours/105.png",false,bg)
	guiCreateStaticImage(0,61,660,1,"websites/colours/0.png",false,bg)
	guiCreateStaticImage(0,80,660,1,"websites/colours/105.png",false,bg)
	guiCreateStaticImage(0,81,660,1,"websites/colours/0.png",false,bg)
	
	local titleShadow = guiCreateLabel(5,63,650,16,pageTitle,false,bg)
	guiLabelSetColor(titleShadow,0,0,0)
	local title = guiCreateLabel(5,62,650,16,pageTitle,false,bg)
	guiLabelSetColor(title,255,255,255)
end

function showAlert(title,message,link)
	local width, height = guiGetScreenSize()
	local alertWindow = guiCreateWindow(width / 2 - 160,height / 2 - 50,320,115,title,false)
	guiWindowSetSizable(alertWindow,false)
	local alertMessage = guiCreateLabel(5,22,310,16,message,false,alertWindow)
	guiLabelSetHorizontalAlign(alertMessage,"center")
	local alertLink = guiCreateEdit(5,45,310,25,link,false,alertWindow)
	guiEditSetReadOnly(alertLink,true)
	local closeButton = guiCreateButton(125,80,75,25,"Okay",false,alertWindow)
	addEventHandler("onClientGUIClick",closeButton,function()
				destroyElement(alertWindow)
			end,false)
end

function www_lsia_sa()
	---------------------
	-- Webpage Properties
	---------------------
	guiSetText(internet_address_label, "Los Santos International Airport")
	guiSetText(address_bar,"www.lsia.sa")
	
	bg = guiCreateStaticImage(0,0,660,745,"websites/colours/36.png",false,internet_pane)
	lsiaCreateHeader()
	
	-------------
	-- Content --
	-------------
	
	local mainTextShadow = guiCreateLabel(5,86,650,145,"",false,bg)
	guiSetText(mainTextShadow,"Do you love airplanes? Flying? Then you've picked the right place to look for your perfect employement opportunity. Los Santos International Airport offers a small variety of employement positions that will get you up close and personal with aircraft and flying.\
\
Please see the list below for available positions and employement opportunites! If you feel obligated to fill out an application, there is one attached to this form. If you fill out an application, please be VERY descriptive and make sure its well thought. We want to get to know you! Make sure you express that YOU are the one for the job!")
	guiLabelSetHorizontalAlign(mainTextShadow,"center",true)
	guiLabelSetColor(mainTextShadow,0,0,0)
	
	local mainText = guiCreateLabel(5,85,650,145,guiGetText(mainTextShadow),false,bg)
	guiLabelSetHorizontalAlign(mainText,"center",true)
	guiLabelSetColor(mainText,255,255,255)
	
	local positions = {
		{ ["title"] = "Line Service", ["height"] = 60, ["description"] = "As a line service personell, you will be in charge of ensuring all operations at LSIA are done. Whether it be moving, washing, refueling, marshaling aircraft, or anything else related to airport operations, you will be the one who gets it done along with your team." },
		{ ["title"] = "Airport Security", ["height"] = 75, ["description"] = "Here at LSIA, we are dedicated to providing that feeling of security when it comes to flying and people's aircraft. As a member of our Security Team, you will be in charge of keeping the airport free of any disturbances or tresspassers. You will patrol the airport properties and work with your team to ensure that LSIA is a safe place to fly." },
		{ ["title"] = "Air Traffic Controller", ["height"] = 90, ["description"] = "As an Air Traffic Controller, your duties are pretty obvious. You are in charge of ensuring that all aircraft departing or arriving at LSIA do it in a safe manner with professional guidance. Whether it be telling an aircraft to taxi to a runway, or that they are cleared to land, you are to ensure that it is done safely. If you apply for this position, please have some sort of previous experience. A degree is preferred, but is not mandatory." },
		{ ["title"] = "Flight Instructor", ["height"] = 120, ["description"] = "As a Flight Instructor, you will be in charge of taking new students and teaching them how to fly safely. You will take them through ground school, teach them everything they need to know for that specific course, and oversee their flying experiences and advancements. There are a few different levels of Flight Instruction that we offer, so if you apply to this position, please make sure you have advanced knowledge in flying. If you are not already rated as a Flight Instructor (CFI and up), don't worry! If you have the determination, we would be happy to put your through our CFI course to get you training new students!" }
	}
	
	local verticalOffset = 245
	for key, position in pairs(positions) do
		local positionLabelShadow = guiCreateLabel(5,verticalOffset + 1,650,16,position["title"],false,bg)
		guiLabelSetColor(positionLabelShadow,0,0,0)
		guiLabelSetHorizontalAlign(positionLabelShadow,"center")
	
		local positionLabel = guiCreateLabel(5,verticalOffset,650,16,position["title"],false,bg)
		guiLabelSetColor(positionLabel,111,130,151)
		guiLabelSetHorizontalAlign(positionLabel,"center")
		verticalOffset = verticalOffset + guiLabelGetFontHeight(positionLabel) + 3
		
		local descriptionLabelShadow = guiCreateLabel(5,verticalOffset + 1,650,position["height"],position["description"],false,bg)
		guiLabelSetColor(descriptionLabelShadow,0,0,0)
		guiLabelSetHorizontalAlign(descriptionLabelShadow,"center",true)
		
		local descriptionLabel = guiCreateLabel(5,verticalOffset,650,position["height"],position["description"],false,bg)
		guiLabelSetHorizontalAlign(descriptionLabel,"center",true)
		
		verticalOffset = verticalOffset + position["height"] + 10
	end
	
	local applyButton = guiCreateButton(285,verticalOffset,75,25,"Apply now!",false,bg)
	addEventHandler("onClientGUIClick",applyButton,function()
				showAlert("Sending an application","(( You can send an application using the forums ))", "http://www.valhallagaming.net/forums/showthread.php?114343-Los-Santos-International-Airport-Career-Opportunities")
			end,false)
	
	local page_length = verticalOffset + 35
	guiSetSize(bg,660,page_length,false)

	----------------------------------------------- End of webpage design -- Do not edit below this line. -----------------------------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end

function www_lsia_sa_rental()
	---------------------
	-- Webpage Properties
	---------------------
	guiSetText(internet_address_label, "Los Santos International Airport - Aircraft Rental")
	guiSetText(address_bar,"www.lsia.sa/rental")
	
	bg = guiCreateStaticImage(0,0,660,745,"websites/colours/36.png",false,internet_pane)
	lsiaCreateHeader()
	--lsiaCreateMenu()
	
	-------------
	-- Content --
	-------------
	
	local mainTextShadow = guiCreateLabel(5,86,650,75,"",false,bg)
	guiSetText(mainTextShadow,"Here at Los Santos International Airport, we offer a small variety of aircraft for your use. All of these aircraft are used for different training courses, but you can also rent them for your personal use!\
\
NOTE: Pilot's License and proper certification required for rental.")
	guiLabelSetHorizontalAlign(mainTextShadow,"center",true)
	guiLabelSetColor(mainTextShadow,0,0,0)
	
	local mainText = guiCreateLabel(5,85,650,75,guiGetText(mainTextShadow),false,bg)
	guiLabelSetHorizontalAlign(mainText,"center",true)
	guiLabelSetColor(mainText,255,255,255)
	
	local aircraft = {
		{ ["name"] = "Cessna 152 - N114FS - Dodo", ["price"] = "$200 per/hr." },
		{ ["name"] = "BN-2 Islander - N113FS - Beagle", ["price"] = "$800 per/hr." },
		{ ["name"] = "Bell 47 - N111FS - Sparrow", ["price"] = "$400 per/hr." },
		{ ["name"] = "Bell 206 Jet Ranger - N112FS - Maverick", ["price"] = "$850 per/hr." },
		{ ["name"] = "Learjet 45 - N115FS - Shamal", ["price"] = "$2,100 per/hr." }
	}
	
	local verticalOffset = 165
	for key, vehicle in pairs(aircraft) do
		local nameLabelShadow = guiCreateLabel(5,verticalOffset + 1,650,16,vehicle["name"],false,bg)
		guiLabelSetColor(nameLabelShadow,0,0,0)
		guiLabelSetHorizontalAlign(nameLabelShadow,"center")
	
		local nameLabel = guiCreateLabel(5,verticalOffset,650,16,vehicle["name"],false,bg)
		guiLabelSetColor(nameLabel,111,130,151)
		guiLabelSetHorizontalAlign(nameLabel,"center")
		verticalOffset = verticalOffset + guiLabelGetFontHeight(nameLabel) + 3
		
		local priceLabelShadow = guiCreateLabel(5,verticalOffset + 1,650,16,vehicle["price"],false,bg)
		guiLabelSetHorizontalAlign(priceLabelShadow,"center")
		guiLabelSetColor(priceLabelShadow,0,0,0)
		
		local priceLabel = guiCreateLabel(5,verticalOffset,650,16,vehicle["price"],false,bg)
		guiLabelSetHorizontalAlign(priceLabel,"center")
		
		verticalOffset = verticalOffset + guiLabelGetFontHeight(priceLabel) + 10
	end
	
	local rentButton = guiCreateButton(270,verticalOffset,104,25,"Rent an aircraft",false,bg)
	addEventHandler("onClientGUIClick",rentButton,function()
				showAlert("Rent an aircraft","(( You can rent an aircraft using the forums ))", "http://www.valhallagaming.net/forums/showthread.php?114345-Los-Santos-International-Airport-Aircraft-Rental")
			end,false)
	
	local page_length = verticalOffset + 35
	guiSetSize(bg,660,page_length,false)

	----------------------------------------------- End of webpage design -- Do not edit below this line. -----------------------------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end

function www_lsia_sa_flightschool()
	---------------------
	-- Webpage Properties
	---------------------
	guiSetText(internet_address_label, "Los Santos International Airport - Flight School")
	guiSetText(address_bar,"www.lsia.sa/flightschool")
	
	bg = guiCreateStaticImage(0,0,660,745,"websites/colours/36.png",false,internet_pane)
	lsiaCreateHeader()
	--lsiaCreateMenu()
	
	-------------
	-- Content --
	-------------
	
	local mainTextShadow = guiCreateLabel(5,86,650,30,"",false,bg)
	guiSetText(mainTextShadow,"As of the 11/05/2011, all pilot applications have an application fee of $5,000. This will be paid before your training begins, upon meeting your flight instructor.")
	guiLabelSetHorizontalAlign(mainTextShadow,"center",true)
	guiLabelSetColor(mainTextShadow,0,0,0)
	
	local mainText = guiCreateLabel(5,85,650,30,guiGetText(mainTextShadow),false,bg)
	guiLabelSetHorizontalAlign(mainText,"center",true)
	guiLabelSetColor(mainText,255,255,255)
	
	local packages = {
		{ ["title"] = "Private Pilot's License Course (PPL)", ["description"] = "Single Engine Aircraft\
		Instrument & Commercial Rating Included.\
		\
		Package Price: $6,925 USD" },
		{ ["title"] = "Multi-Engine Rating Course", ["description"] = "Multi-Engine Aircraft\
		PPL Required to enter course.\
		\
		Package Price: $7,990 USD" },
		{ ["title"] = "Rotory License Course", ["description"] = "Turbine Engine Rating Course\
		Multi-Engine Rating Required to enter course.\
		\
		Package Price: $15,550 USD" },
		{ ["title"] = "Rotory License Course", ["description"] = "Rotor Aircraft (Helicopters)\
		\
		Package Price: $13,550 USD" }
	}
	
	local verticalOffset = 125
	for key, package in pairs(packages) do
		local titleLabelShadow = guiCreateLabel(5,verticalOffset + 1,650,16,package["title"],false,bg)
		guiLabelSetColor(titleLabelShadow,0,0,0)
		guiLabelSetHorizontalAlign(titleLabelShadow,"center")
	
		local titleLabel = guiCreateLabel(5,verticalOffset,650,16,package["title"],false,bg)
		guiLabelSetColor(titleLabel,111,130,151)
		guiLabelSetHorizontalAlign(titleLabel,"center")
		verticalOffset = verticalOffset + guiLabelGetFontHeight(titleLabel) + 3
		
		local descriptionLabelShadow = guiCreateLabel(5,verticalOffset + 1,650,200,package["description"],false,bg)
		guiLabelSetHorizontalAlign(descriptionLabelShadow,"center")
		guiLabelSetColor(descriptionLabelShadow,0,0,0)
		
		local descriptionLabel = guiCreateLabel(5,verticalOffset,650,200,package["description"],false,bg)
		guiLabelSetHorizontalAlign(descriptionLabel,"center")
		
		verticalOffset = verticalOffset + guiLabelGetFontHeight(descriptionLabel) + 60
	end
	
	local applyButton = guiCreateButton(285,verticalOffset,75,25,"Apply now!",false,bg)
	addEventHandler("onClientGUIClick",applyButton,function()
				showAlert("Sending a course application","(( You can send an application using the forums ))", "http://www.valhallagaming.net/forums/showthread.php?114354-Los-Santos-International-Airport-Course-Application")
			end,false)
	
	local page_length = verticalOffset + 35
	guiSetSize(bg,660,page_length,false)

	----------------------------------------------- End of webpage design -- Do not edit below this line. -----------------------------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end

function www_lsia_sa_contact()
	---------------------
	-- Webpage Properties
	---------------------
	guiSetText(internet_address_label, "Los Santos International Airport - Information & Contact")
	guiSetText(address_bar,"www.lsia.sa/contact")
	
	bg = guiCreateStaticImage(0,0,660,745,"websites/colours/36.png",false,internet_pane)
	lsiaCreateHeader()
	--lsiaCreateMenu()
	
	-------------
	-- Content --
	-------------
	
	local information = {
		{ ["key"] = "Airport Operation Hours", ["value"] = "07:00 - 22:00" },
		{ ["key"] = "Address", ["value"] = "1 S. Hindenburg Street, Los Santos, San Andreas" },
		{ ["key"] = "UNICOM Frequency", ["value"] = "12295" }
	}
	
	local verticalOffset = 90
	for key, data in pairs(information) do
		local keyLabelShadow = guiCreateLabel(5,verticalOffset + 1,650,16,data["key"],false,bg)
		guiLabelSetColor(keyLabelShadow,0,0,0)
		guiLabelSetHorizontalAlign(keyLabelShadow,"center")
	
		local keyLabel = guiCreateLabel(5,verticalOffset,650,16,data["key"],false,bg)
		guiLabelSetColor(keyLabel,111,130,151)
		guiLabelSetHorizontalAlign(keyLabel,"center")
		verticalOffset = verticalOffset + guiLabelGetFontHeight(keyLabel) + 3
		
		local valueLabelShadow = guiCreateLabel(5,verticalOffset + 1,650,16,data["value"],false,bg)
		guiLabelSetHorizontalAlign(valueLabelShadow,"center")
		guiLabelSetColor(valueLabelShadow,0,0,0)
		
		local valueLabel = guiCreateLabel(5,verticalOffset,650,16,data["value"],false,bg)
		guiLabelSetHorizontalAlign(valueLabel,"center")
		
		verticalOffset = verticalOffset + guiLabelGetFontHeight(valueLabel) + 10
	end
	
	local page_length = verticalOffset
	guiSetSize(bg,660,page_length,false)

	----------------------------------------------- End of webpage design -- Do not edit below this line. -----------------------------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end