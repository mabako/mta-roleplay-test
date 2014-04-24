-----------------------------
-- Web page creation notes --
-----------------------------
-- The maximum dimension of a webpage are 460px X 765px. This means any text label longer than 460px will be cut off as there is no horizontal scrolling.
-- The colours available are the same as the colours used on the vehicles in the server. Therefore you can use the car colour chart to identify colours you want to use.
-- Background colours are used by creating a static image using the colour '[id].png' file. So black would be;
								-- local black_background = guiCreateStaticImage(5,5,450,60,"websites/colours/0.png",false,internet_page)
								-- The above line of code would create a black rectangle with dimensions 450px width x 60px height and with a left margin of 5px and a top margin of 5px.
	
-- All elements must have the "bg" as it's parent except for the bg itself.
-- You are free to use all gui elements (labels, memos, edits, static images (using the provided .pngs only), grid lists, radio buttons, etc)
-- All pages must have .sa domain. This is so our websites are not confused with real websites.
-- It is recommended you use absolute positioning on all elements as it will give you greater control over your designs.


-----------------------
-- EXAMPLE HOME PAGE --
-----------------------

-- Website owner's forum name: Terra and RPG666
-- Website owner's Character's name: Daniel Baker and Mauricio Romero

function www_RandBsburialservice_sa() -- The function is named the same as your page's URL with "."s and "/"s replaced with underscores. So "www.google.com/images" would be "www_google_com_images".
	
	-- Webpage Properties
	---------------------
	local page_length = 765 -- Set the total length of your webpage in px (Max page height is 765px). This will determine whether your page will have a vertical scroll bar. 
	guiSetText(internet_address_label, "R&B's Burial Service") -- This text is displayed at the top of the browser window when the page is opened. It is the same as the <title> tag used in the meta of a real webpage. Only change the text between the quotation marks.
	guiSetText(address_bar,"www.RandBsburialservice.sa") -- The url of the page. This should be the same as the function name but with the original "."s and "/". Example www.google.com.
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,460,page_length,"websites/colours/0.png",false,internet_pane) -- You only need to change the colour ID in the following line of code. The number you need to change is the digit directly before ".png" (in this case "0").
	
	-- Everything below here can be completely removed or edited as you wish. This is the bulk of the design of your webpage. --
	
	------------
	-- Header --
	------------
	local banner = guiCreateStaticImage(5,5,450,60,"websites/colours/3.png",false,bg) -- Creates a red square with dimensions 450 X 60px.
	local header = guiCreateLabel(10,5,460,40,"R&B's Burial Service",false,bg) -- Creates a text box.
	guiSetFont(header, "sa-header") -- Sets the font of the "header" text box.
	local underline = guiCreateStaticImage(5,47,450,1,"websites/colours/1.png",false,bg) -- Creates a white square (in this case a line) 450px long and 1px high.
	
	-------------
	-- Content --
	-------------
	local mainText = guiCreateLabel(10,65,440,800,	"Welcome to Romero and Baker's Burial Service, we provide you with Excellent \
	Burial Services!! \
													\
													Romero and Bakers Burial Services are offering a part time job for you to \
													serve the society and help the gone people in their last walk towards the \
													world upon us \
													\
													Available Occupations are the following: \
													\
													-Mortician \
													-Embalmer \
													-Driver \
													-Coffin Bearer \
													-Priest/Vicar \
													-Carpenter \
													-Stone Mason \
													-Florists \
													-Groundsmen \
													-Party Planners (For Wake & such) \
													-Designers (Funeral Programs) \
													\
													To contact us, visit: \
													www.R&Bsburialservice.sa/contact",false,bg)
													-- NB: Text in a label does not automatically wordwarp so you must manually split the lines using the "\".
													

	
	----------------------------------------------- End of webpage design -- Do not edit below this line. -----------------------------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,460,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end


--------------------
-- EXAMPLE PAGE 2 --
--------------------

function www_RandBsburialservice_sa_contact() -- This is the function for the page found at www.example.sa/page2. You will _NOT_ be able to navigate to this page using the website-test resource.
	---------------------
	-- Page Properties --
	---------------------
	local page_length = 397
	guiSetText(internet_address_label, "Romero and Baker's Burial Service - Contact us")
	guiSetText(address_bar,"www.RandBsburialservice.sa/contact")
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,460,page_length,"websites/colours/0.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local banner = guiCreateStaticImage(5,5,450,60,"websites/colours/3.png",false,bg)
	local header = guiCreateLabel(10,5,460,40,"Contact us",false,bg)
	guiSetFont(header, "sa-header")
	local underline = guiCreateStaticImage(5,47,450,1,"websites/colours/1.png",false,bg)
	
	-------------
	-- Content --
	-------------
	local mainStory = guiCreateLabel(10,65,440,300,"You can contact us by the Following:\
												\
												Address - Liberty Ave, Temple \
												\
												Email - RBS@saonline.sa \
												\
												Mobile Numbers - Mauricio Romero - 45201, Daniel Baker - 45455",false,bg)


	guiSetFont(mainStory,"default-bold-small")
	
	
	----------------------- End of page design -------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,460,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
	
end