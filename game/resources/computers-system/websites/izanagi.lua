-------------------
-- WEBSITE TITLE --
-------------------

-- Website owner's forum name: Izanagi
-- Website owner's Character's name: Ryuunosuke_Yasogami

function www_izanagi_sa()
	
	local page_length = 396
	guiSetText(internet_address_label, "Izanagi.sa - Click on my logo to contact me")
	guiSetText(address_bar,"www.izanagi.sa")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/1.png",false,internet_pane)

	local title_shadow = guiCreateLabel(161,24,350,64,"Izanagi",false,bg)
	guiLabelSetHorizontalAlign(title_shadow,"center")
	guiSetFont(title_shadow,"sa-header")
	guiLabelSetColor(title_shadow,128,8,8)
	
	local title = guiCreateLabel(160,23,350,64,"Izanagi",false,bg)
	guiLabelSetColor(title,  0,0,0)
	guiLabelSetHorizontalAlign(title,"center")
	guiSetFont(title,"sa-header")
	
	local head1 = guiCreateLabel(160,88,350,16, "My works",false,bg)
	guiLabelSetColor(head1,  0,0,0)
	guiLabelSetHorizontalAlign(head1, "center")
	guiSetFont(head1, "default-bold-small")
	
	local list1 = guiCreateLabel(160,104,350, 16, "Gnocchi Ristorante",false,bg)
	guiLabelSetColor(list1, 0,0,0)
	guiLabelSetHorizontalAlign(list1, "center")
	guiSetFont(list1, "default-normal")
	
	local list2 = guiCreateLabel(160,120,350,16, "www.gnocchi.sa",false,bg)
	guiLabelSetColor(list2, 0,0,0)
	guiLabelSetHorizontalAlign(list2, "center")
	guiSetFont(list2, "default-small")

	local list3 = guiCreateLabel(160,152,350, 16, "Bibles",false,bg)
	guiLabelSetColor(list3, 0,0,0)
	guiLabelSetHorizontalAlign(list3, "center")
	guiSetFont(list3, "default-normal")
	
	local list4 = guiCreateLabel(160,168,350,16, "www.bibles.sa",false,bg)
	guiLabelSetColor(list4, 0,0,0)
	guiLabelSetHorizontalAlign(list4, "center")
	guiSetFont(list4, "default-small")
	
	local logo = guiCreateStaticImage(519,286,146,110, "websites/images/izanagi-black.png", false, bg)

	addEventHandler("onClientGUIClick",list1,function()
		local url = tostring("www.gnocchi.sa")
		get_page(url)
	end,false)
	
	addEventHandler("onClientGUIClick",list3,function()
		local url = tostring("www.bibles.sa")
		get_page(url)
	end,false)
	
	addEventHandler( "onClientGUIClick", logo,
	function( button )
		if button == "left" then
			compose_mail( "izanagi@whiz.sa" )
		end
	end, false)
	----------------------------------------------- End of webpage design -- Do not edit below this line. -----------------------------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end


