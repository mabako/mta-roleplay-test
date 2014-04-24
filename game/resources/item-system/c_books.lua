wBook, buttonClose, buttonPrev, buttonNext, page, cover, pgNumber, xml, pane = nil
pageNumber = 0
totalPages = 0

function createBook( bookName, bookTitle )
	
	-- Window variables
	local Width = 460
	local Height = 520
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2

	if not (wBook) then
		pageNumber = 0
		
		-- Create the window
		wBook = guiCreateWindow(X, Y, Width, Height, bookTitle, false)
		
		cover = guiCreateStaticImage ( 0.01, 0.05, 0.8, 0.95, "books/".. bookName ..".png", true, wBook ) -- display the cover image.
		
		-- Create close, previous and Next Button
		buttonPrev = guiCreateButton( 0.85, 0.25, 0.14, 0.05, "Prev", true, wBook)
		addEventHandler( "onClientGUIClick", buttonPrev, prevButtonClick, false )
		guiSetVisible(buttonPrev, false)

		buttonClose = guiCreateButton( 0.85, 0.45, 0.14, 0.05, "Close", true, wBook)
		addEventHandler( "onClientGUIClick", buttonClose, closeButtonClick, false )
		
		buttonNext = guiCreateButton( 0.85, 0.65, 0.14, 0.05, "Next", true, wBook)
		addEventHandler( "onClientGUIClick", buttonNext, nextButtonClick, false )

		showCursor(true)
		
		-- the pages
		pane = guiCreateScrollPane(0.01, 0.05, 0.8, 0.9, true, wBook)
		guiScrollPaneSetScrollBars(pane, false, true)
		page = guiCreateLabel(0.01, 0.05, 0.8, 2.0, "", true, pane) -- create the page but leave it blank.
		guiLabelSetHorizontalAlign (page, "left", true)
		pgNumber = guiCreateLabel(0.95, 0.0, 0.05, 1.0, "",true, wBook) -- page number at the bottom.
		guiSetVisible(pane, false)
		
		xml = xmlLoadFile( "/books/" .. bookName .. ".xml" ) 	-- load the xml.

		local numpagesNode = xmlFindChild(xml,"numPages", 0)	-- get the children of the root node "content". Should return the "page"..pageNumber nodes in a table.
		totalPages = tonumber(xmlNodeGetValue(numpagesNode))
	end
end
addEvent("showBook", true)
addEventHandler("showBook", getRootElement(), createBook)

--The "prev" button's function
function prevButtonClick( )
	
	pageNumber = pageNumber - 1
	
	if (pageNumber == 0) then
		guiSetVisible(buttonPrev, false)
		guiSetVisible(pane, false)
	else
		guiSetVisible(buttonPrev, true)
		guiSetVisible(pane, true)
	end
	
	if (pageNumber == totalPages) then
		guiSetVisible(buttonNext, false)
	else
		guiSetVisible(buttonNext, true)
	end
	
	if (pageNumber>0) then -- if the new page is not the cover
		
		local pageNode = xmlFindChild (xml, "page", pageNumber-1)
		local contents = xmlNodeGetValue( pageNode )
		
		guiSetText (page, contents)
		guiSetText (pgNumber, pageNumber)
	
	else -- if we are moving to the cover
		guiSetVisible(buttonNext, true)
		guiSetVisible(cover, true)
		guiSetText (page, "")
		guiSetText (pgNumber, "")
	end
end

--The "next" button's function
function nextButtonClick( )
	
	pageNumber = pageNumber + 1
	
	if (pageNumber == 0) then
		guiSetVisible(buttonPrev, false)
		guiSetVisible(pane, false)
	else
		guiSetVisible(buttonPrev, true)
		guiSetVisible(pane, true)
	end

	if (pageNumber == totalPages) then
		guiSetVisible(buttonNext, false)
	else
		guiSetVisible(buttonNext, true)
	end
	
	if (pageNumber-1==0) then -- If the last page was the cover page remove the cover image.
		guiSetVisible(cover, false)
	end

	local pageNode = xmlFindChild (xml, "page", pageNumber-1)
	local contents = xmlNodeGetValue( pageNode )
	guiSetText ( page, contents )
	guiSetText ( pgNumber, pageNumber )
end

-- The "close" button's function
function closeButtonClick( )
	pageNumber = 0
	totalPages = 0
	destroyElement ( page )
	destroyElement ( pane )
	destroyElement ( buttonClose )
	destroyElement ( buttonPrev )
	destroyElement ( buttonNext )
	destroyElement ( cover)
	destroyElement ( pgNumber )
	destroyElement ( wBook )
	buttonClose = nil
	buttonPrev = nil
	buttonNext = nil
	pane = nil
	page = nil
	cover = nil
	pgNumber = nil
	wBook = nil
	showCursor(false)
	xmlUnloadFile(xml)
	xml = nil
end
