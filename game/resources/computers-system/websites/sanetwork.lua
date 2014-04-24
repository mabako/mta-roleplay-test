rssItems = {}

function requestFeed() -- Request the news feed from the server
	triggerServerEvent("sanRequestFeed",getRootElement())
end

function feedReceived(feed) -- Received the feed from the server
	rssItems = feed
	sanCreateArticles()
	setTimer(clearFeed,600000,0)
end
addEvent("sanReceiveFeed",true)
addEventHandler("sanReceiveFeed",getRootElement(),feedReceived)

function clearFeed() -- Clears the feed, allowing it to be redownloaded from the server upon the next request
	rssItems = {}
end

-- www.sanetwork.sa
-- San Andreas Network
-- Website owner's forum name: Fields
-- Website owner's Character's name: Tracy Ann Davis

function sanCreateHeader()
	local header = guiCreateStaticImage(0,0,660,115,"websites/images/san-logo.png",false,bg)
	addEventHandler("onClientGUIClick",header,function()
				local url = tostring("www.sanetwork.sa")
				get_page(url)
			end,false)
end

function sanCreateMenu()
	local menuData = {
		{
		["title"] = "Top Links",
		["pages"] = {
				{ ["title"] = "Government of LS", ["location"] = "www.lossantos.gov" },
				{ ["title"] = "LSPD", ["location"] = "www.lspd.gov" },
				{ ["title"] = "LSES", ["location"] = "www.lses.gov" },
				{ ["title"] = "Bank of SA", ["location"] = "www.bankofsa.sa" },
				{ ["title"] = "LSIA", ["location"] = "www.lsia.sa" }
			}
		}
	}
	
	local menuOffset = 125
	for key, category in pairs(menuData) do
		guiCreateStaticImage(510,menuOffset,140,20,"websites/colours/7.png",false,bg)
		
		local menuLabel = guiCreateLabel(515,menuOffset + 2,130,16,category["title"],false,bg)
		guiSetFont(menuLabel,"default-bold-small")
		menuOffset = menuOffset + 20
		
		local menuBG = guiCreateStaticImage(510,menuOffset,140,0,"websites/colours/1.png",false,bg)
		menuOffset = menuOffset + 2
		local originalOffset = menuOffset
		for key, page in pairs(category["pages"]) do
			local pageLabel = guiCreateLabel(515,menuOffset,130,16,page["title"],false,bg)
			guiLabelSetColor(pageLabel,100,104,106)
			
			addEventHandler("onClientGUIClick",pageLabel,function()
				local url = tostring(page["location"])
				get_page(url)
			end,false)
			
			menuOffset = menuOffset + 18
		end
		menuOffset = menuOffset + 2
		guiSetSize(menuBG,140,menuOffset - originalOffset,false)
		menuOffset = menuOffset + 10
	end
end

function sanCreateArticles()
	if (address_bar and guiGetText(address_bar) == "www.sanetwork.sa") then
		articleID = 0
		
		local verticalOffset = 125
		
		guiCreateStaticImage(10,verticalOffset,490,20,"websites/colours/7.png",false,bg)
		local otherNewsLabel = guiCreateLabel(15,verticalOffset + 2,480,16,"Headlines",false,bg)
		guiSetFont(otherNewsLabel,"default-bold-small")
		verticalOffset = verticalOffset + 20
		
		local articlesBG = guiCreateStaticImage(10,verticalOffset,490,0,"websites/colours/1.png",false,bg)
		verticalOffset = verticalOffset + 3
		local originalOffset = verticalOffset
		for i, item in ipairs(rssItems) do
			local dateLabel = guiCreateLabel(15,verticalOffset,470,16,item["date"],false,bg)
			guiLabelSetColor(dateLabel,100,104,106)
			guiSetFont(dateLabel,"default-small")
			
			verticalOffset = verticalOffset + guiLabelGetFontHeight(dateLabel) - 3
			
			local titleLabel = guiCreateLabel(15,verticalOffset,470,16,item["title"],false,bg)
			guiLabelSetColor(titleLabel,76,117,183)
			guiSetFont(titleLabel,"default-bold-small")
			
			addEventHandler("onClientGUIClick",titleLabel,function()
				sanShowAlert(item["title"],"You can read this article by visiting the URL below.",item["url"])
			end,false)
			
			verticalOffset = verticalOffset + guiLabelGetFontHeight(titleLabel)
			
			local sublineLabel = guiCreateLabel(15,verticalOffset,470,16,"by " .. item["autor"],false,bg)
			guiLabelSetColor(sublineLabel,100,104,106)
			guiSetFont(sublineLabel,"default-small")
			
			verticalOffset = verticalOffset + guiLabelGetFontHeight(sublineLabel) + 5
		end
		guiSetSize(articlesBG,490,verticalOffset - originalOffset,false)
		
		sanCreateFooter(verticalOffset + 8)
	end
end

function sanCreateFooter(height)
	local verticalOffset = height
	if (verticalOffset < 357) then verticalOffset = 357 end
	guiCreateStaticImage(0,verticalOffset,660,40,"websites/colours/7.png",false,bg)
	guiCreateLabel(10,verticalOffset + 12,440,16,"Copyright San Andreas Network, 2011",false,bg)
	
	local page_length = verticalOffset + 40
	guiSetSize(bg,660,page_length,false)
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end

function sanShowAlert(title,message,link)
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

function www_sanetwork_sa()
	---------------------
	-- Webpage Properties
	---------------------
	guiSetText(internet_address_label, "San Andreas Network")
	guiSetText(address_bar,"www.sanetwork.sa")
	
	bg = guiCreateStaticImage(0,0,660,745,"websites/colours/14.png",false,internet_pane)
	sanCreateHeader()
	sanCreateMenu()
	
	-------------
	-- Content --
	-------------
	
	if (# rssItems > 0) then
		sanCreateArticles()
	else
		requestFeed()
		local page_length = 397
		
		if(page_length>=397)then
			guiScrollPaneSetScrollBars(bg,false,true)
		else
			guiSetSize(bg,660,397,false)
			guiScrollPaneSetScrollBars(internet_pane, false, false)
		end
	end
end