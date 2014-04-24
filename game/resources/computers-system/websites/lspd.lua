---------------------
-- www.lspd.gov --
---------------------
function www_lspd_gov()
	local page_length = 350
	
	guiSetText(internet_address_label, "Los Santos Police Department - 'Taking the law into our own hands...' - Waterwolf")
	guiSetText(address_bar,"www.lspd.gov")
	
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/10.png",false,internet_pane)
	
	local logo = guiCreateStaticImage(50,10,150,150,"websites/images/lspd-logo.png",false,bg)
	local header = guiCreateLabel(230,75,460,20,"Los Santos Police Department",false,bg)
	
	local text = guiCreateLabel(100,200,450,165,"Site currently under construction.\
											\
											Please check back soon.",false,bg)
	guiSetFont(text,"default-bold-small")
	
----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end


