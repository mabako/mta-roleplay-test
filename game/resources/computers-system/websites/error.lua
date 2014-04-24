function error_404()
	error_page("Page not found", "Error 404\n\nThe url address you have entered cannot be found.")
end

function error_9001()
	error_page("Page blocked", "Your employer blocked this page.\n\nPlease contact your network\nadministrator if in doubt.")
end

function error_page(title, text)
	local page_length = 300
	guiSetText(internet_address_label, "Error - " .. title .. " - Waterwolf")
	
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/1.png",false,internet_pane)
	
	local image = guiCreateStaticImage(130,150,64,64,":help-system/info.png",false,bg)
	local text = guiCreateLabel(220,160,330,165,text,false,bg)
	guiSetFont(text,"default-bold-small")
	guiLabelSetColor(text,28,28,28)
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end


