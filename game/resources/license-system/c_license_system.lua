wLicense, licenseList, bAcceptLicense, bCancel = nil
local Johnson = createPed(211, 683.41015625, -467.6689453125, -21.351913452148)
setPedRotation(Johnson, 0)
setElementDimension(Johnson, 1991)
setElementInterior(Johnson, 1)
setElementData( Johnson, "talk", 1, false )
setElementData( Johnson, "name", "Carla Cooper", false )

function doTimer(thePed)
	setElementPosition(thePed, 683.41015625, -467.6689453125, -21.351913452148)
	setPedRotation(thePed, 0)
end
setTimer(doTimer, 3000, 0, Johnson)

local localPlayer = getLocalPlayer()

function showLicenseWindow()
	triggerServerEvent("onLicenseServer", getLocalPlayer())
	
	local vehiclelicense = getElementData(getLocalPlayer(), "license.car")

	local width, height = 300, 400
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
	
	wLicense= guiCreateWindow(x, y, width, height, "Los Santos Licensing Department", false)
	
	licenseList = guiCreateGridList(0.05, 0.05, 0.9, 0.8, true, wLicense)
	local column = guiGridListAddColumn(licenseList, "License", 0.7)
	local column2 = guiGridListAddColumn(licenseList, "Cost", 0.2)
	
	if (vehiclelicense~=1) then
		local row = guiGridListAddRow(licenseList)
		guiGridListSetItemText(licenseList, row, column, "Car License", false, false)
		guiGridListSetItemText(licenseList, row, column2, "450", true, false)
	end
				
	bAcceptLicense = guiCreateButton(0.05, 0.85, 0.45, 0.1, "Buy License", true, wLicense)
	bCancel = guiCreateButton(0.5, 0.85, 0.45, 0.1, "Cancel", true, wLicense)
	
	showCursor(true)
	
	addEventHandler("onClientGUIClick", bAcceptLicense, acceptLicense)
	addEventHandler("onClientGUIClick", bCancel, cancelLicense)
end
addEvent("onLicense", true)
addEventHandler("onLicense", getRootElement(), showLicenseWindow)

function acceptLicense(button, state)
	if (source==bAcceptLicense) and (button=="left") then
		local row, col = guiGridListGetSelectedItem(jobList)
		
		if (row==-1) or (col==-1) then
			outputChatBox("Please select a license first!", 255, 0, 0)
		else
			local license = 0
			local licensetext = guiGridListGetItemText(licenseList, guiGridListGetSelectedItem(licenseList), 1)
			local licensecost = tonumber(guiGridListGetItemText(licenseList, guiGridListGetSelectedItem(licenseList), 2))
			
			if (licensetext=="Car License") then
				license = 1
			end
			
			if (license>0) then
				if not exports.global:hasMoney( getLocalPlayer(), licensecost ) then
					outputChatBox("You cannot afford this license.", 255, 0, 0)
				else
					if (license == 1) then
						if getElementData(getLocalPlayer(), "license.car") < 0 then
							outputChatBox( "You need to wait another " .. -getElementData(getLocalPlayer(), "license.car") .. " hours before being able to obtain a " .. licensetext .. ".", 255, 0, 0 )
						elseif (getElementData(getLocalPlayer(),"license.car")==0) then
							triggerServerEvent("payFee", getLocalPlayer(), 100)
							createlicenseTestIntroWindow() -- take the drivers theory test.
							destroyElement(licenseList)
							destroyElement(bAcceptLicense)
							destroyElement(bCancel)
							destroyElement(wLicense)
							wLicense, licenseList, bAcceptLicense, bCancel = nil, nil, nil, nil
							showCursor(false)
						elseif(getElementData(getLocalPlayer(),"license.car")==3) then
							initiateDrivingTest()
						end
					end
				end
			end
		end
	end
end

function cancelLicense(button, state)
	if (source==bCancel) and (button=="left") then
		destroyElement(licenseList)
		destroyElement(bAcceptLicense)
		destroyElement(bCancel)
		destroyElement(wLicense)
		wLicense, licenseList, bAcceptLicense, bCancel = nil, nil, nil, nil
		showCursor(false)
	end
end

   ------------ TUTORIAL QUIZ SECTION - SCRIPTED BY PETER GIBBONS (AKA JASON MOORE), ADAPTED BY CHAMBERLAIN --------------
   
   
   
   
questions = { 

	{"Which side of the street should you drive on?", "Left", "Right", "Either", 2},
	{"At an intersection with a four-way stop, which driver can go first?", "The driver to the left of you.", "The driver to the right of you.", "Who ever reached the intersection first.", 2}, 
	{"What would be a reason for approaching a sharp curve slowly?", "To save wear and tear on your tires.", "To be able to take in the scenery.", "To be able to stop if someone is in the roadway.", 3},
	{"When a traffic light is red you should...", "Bring the vehicle to a complete stop.", "Continue.", "Continue if nothing is coming.", 1},
	{"Drivers must yield to pedestrians:", "At all times.", "On private property.", "Only in a crosswalk. ", 1},
	{"The blind spots where trucks will not be able to see you are:", "Directly behind the body.", "The immediate left of the cab.", "All of the above." , 3},
	{"There is an emergency vehicle coming from behind you with emergency lights on and flashing. You should:", "Slow down and keep moving.", "Pull over to the right and stop.", "Maintain your speed. ", 2},
	{"On a road with two or more lanes traveling in the same direction, the driver should:", "Drive in any lane.", "Drive in the left lane.", "Drive in the right lane except to pass.", 3},
	{"In bad weather, you should make your car easier for others to see by:", "Turning on your headlights.", "Turning on your emergency flashers.", "Flash your high beams.", 1},
	{"You may not park within how many feet of a fire hydrant?", "10 feet", "15 feet", "20 feet", 2}
}

guiIntroLabel1 = nil
guiIntroProceedButton = nil
guiIntroWindow = nil
guiQuestionLabel = nil
guiQuestionAnswer1Radio = nil
guiQuestionAnswer2Radio = nil
guiQuestionAnswer3Radio = nil
guiQuestionWindow = nil
guiFinalPassTextLabel = nil
guiFinalFailTextLabel = nil
guiFinalRegisterButton = nil
guiFinalCloseButton = nil
guiFinishWindow = nil

-- variable for the max number of possible questions
local NoQuestions = 10
local NoQuestionToAnswer = 7
local correctAnswers = 0
local passPercent = 80
		
selection = {}

-- functon makes the intro window for the quiz
function createlicenseTestIntroWindow()
	
	showCursor(true)
	
	outputChatBox("You have paid the $100 fee to take the driving theory test.", source, 255, 194, 14)
	
	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	guiIntroWindow = guiCreateWindow ( X , Y , Width , Height , "Driving Theory Test" , false )
	
	guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "banner.png", true, guiIntroWindow)
	
	guiIntroLabel1 = guiCreateLabel(0, 0.3,1, 0.5, [[You will now proceed with the driving theory test. You will
be given seven questions based on basic driving theory. You must score
a minimum of 80 percent to pass.

Good luck.]], true, guiIntroWindow)
	
	guiLabelSetHorizontalAlign ( guiIntroLabel1, "center", true )
	guiSetFont ( guiIntroLabel1,"default-bold-small")
	
	guiIntroProceedButton = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Start Test" , true ,guiIntroWindow)
	
	addEventHandler ( "onClientGUIClick", guiIntroProceedButton,  function(button, state)
		if(button == "left" and state == "up") then
		
			-- start the quiz and hide the intro window
			startLicenceTest()
			guiSetVisible(guiIntroWindow, false)
		
		end
	end, false)
	
end


-- function create the question window
function createLicenseQuestionWindow(number)

	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	-- create the window
	guiQuestionWindow = guiCreateWindow ( X , Y , Width , Height , "Question "..number.." of "..NoQuestionToAnswer , false )
	
	guiQuestionLabel = guiCreateLabel(0.1, 0.2, 0.9, 0.2, selection[number][1], true, guiQuestionWindow)
	guiSetFont ( guiQuestionLabel,"default-bold-small")
	guiLabelSetHorizontalAlign ( guiQuestionLabel, "left", true)
	
	
	if not(selection[number][2]== "nil") then
		guiQuestionAnswer1Radio = guiCreateRadioButton(0.1, 0.4, 0.9,0.1, selection[number][2], true,guiQuestionWindow)
	end
	
	if not(selection[number][3] == "nil") then
		guiQuestionAnswer2Radio = guiCreateRadioButton(0.1, 0.5, 0.9,0.1, selection[number][3], true,guiQuestionWindow)
	end
	
	if not(selection[number][4]== "nil") then
		guiQuestionAnswer3Radio = guiCreateRadioButton(0.1, 0.6, 0.9,0.1, selection[number][4], true,guiQuestionWindow)
	end
	
	-- if there are more questions to go, then create a "next question" button
	if(number < NoQuestionToAnswer) then
		guiQuestionNextButton = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Next Question" , true ,guiQuestionWindow)
		
		addEventHandler ( "onClientGUIClick", guiQuestionNextButton,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
				if(guiRadioButtonGetSelected(guiQuestionAnswer1Radio)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2Radio)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3Radio)) then
					selectedAnswer = 3
				else
					selectedAnswer = 0
				end
				
				-- don't let the player continue if they havn't selected an answer
				if(selectedAnswer ~= 0) then
					
					-- if the selection is the same as the correct answer, increase correct answers by 1
					if(selectedAnswer == selection[number][5]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create a new window for the next question
					guiSetVisible(guiQuestionWindow, false)
					createLicenseQuestionWindow(number+1)
				end
			end
		end, false)
		
	else
		guiQuestionSumbitButton = guiCreateButton ( 0.4 , 0.75 , 0.3, 0.1 , "Submit Answers" , true ,guiQuestionWindow)
		
		-- handler for when the player clicks submit
		addEventHandler ( "onClientGUIClick", guiQuestionSumbitButton,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
				if(guiRadioButtonGetSelected(guiQuestionAnswer1Radio)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2Radio)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3Radio)) then
					selectedAnswer = 3
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer4Radio)) then
					selectedAnswer = 4
				else
					selectedAnswer = 0
				end
				
				-- don't let the player continue if they havn't selected an answer
				if(selectedAnswer ~= 0) then
					
					-- if the selection is the same as the correct answer, increase correct answers by 1
					if(selectedAnswer == selection[number][5]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create the finish window
					guiSetVisible(guiQuestionWindow, false)
					createTestFinishWindow()


				end
			end
		end, false)
	end
end


-- funciton create the window that tells the
function createTestFinishWindow()

	local score = math.floor((correctAnswers/NoQuestionToAnswer)*100)

	local screenwidth, screenheight = guiGetScreenSize ()
		
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
		
	-- create the window
	guiFinishWindow = guiCreateWindow ( X , Y , Width , Height , "End of test.", false )
	
	if(score >= passPercent) then
	
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "pass.png", true, guiFinishWindow)
	
		guiFinalPassLabel = guiCreateLabel(0, 0.3, 1, 0.1, "Congratulations! You have passed this section of the test.", true, guiFinishWindow)
		guiSetFont ( guiFinalPassLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalPassLabel, "center")
		guiLabelSetColor ( guiFinalPassLabel ,0, 255, 0 )
		
		guiFinalPassTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "You scored "..score.."%, and the pass mark is "..passPercent.."%. Well done!" ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalPassTextLabel, "center", true)
		
		guiFinalRegisterButton = guiCreateButton ( 0.35 , 0.8 , 0.3, 0.1 , "Continue" , true ,guiFinishWindow)
		
		-- if the player has passed the quiz and clicks on register
		addEventHandler ( "onClientGUIClick", guiFinalRegisterButton,  function(button, state)
			if(button == "left" and state == "up") then
				-- set player date to say they have passed the theory.
				

				initiateDrivingTest()
				-- reset their correct answers
				correctAnswers = 0
				toggleAllControls ( true )
				triggerEvent("onClientPlayerWeaponCheck", source)
				--cleanup
				destroyElement(guiIntroLabel1)
				destroyElement(guiIntroProceedButton)
				destroyElement(guiIntroWindow)
				destroyElement(guiQuestionLabel)
				destroyElement(guiQuestionAnswer1Radio)
				destroyElement(guiQuestionAnswer2Radio)
				destroyElement(guiQuestionAnswer3Radio)
				destroyElement(guiQuestionWindow)
				destroyElement(guiFinalPassTextLabel)
				destroyElement(guiFinalRegisterButton)
				destroyElement(guiFinishWindow)
				guiIntroLabel1 = nil
				guiIntroProceedButton = nil
				guiIntroWindow = nil
				guiQuestionLabel = nil
				guiQuestionAnswer1Radio = nil
				guiQuestionAnswer2Radio = nil
				guiQuestionAnswer3Radio = nil
				guiQuestionWindow = nil
				guiFinalPassTextLabel = nil
				guiFinalRegisterButton = nil
				guiFinishWindow = nil
				
				correctAnswers = 0
				selection = {}
				
				showCursor(false)
			end
		end, false)
		
	else -- player has failed, 
	
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "fail.png", true, guiFinishWindow)
	
		guiFinalFailLabel = guiCreateLabel(0, 0.3, 1, 0.1, "Sorry, you have not passed this time.", true, guiFinishWindow)
		guiSetFont ( guiFinalFailLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalFailLabel, "center")
		guiLabelSetColor ( guiFinalFailLabel ,255, 0, 0 )
		
		guiFinalFailTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "You scored "..math.ceil(score).."%, and the pass mark is "..passPercent.."%." ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalFailTextLabel, "center", true)
		
		guiFinalCloseButton = guiCreateButton ( 0.2 , 0.8 , 0.25, 0.1 , "Close" , true ,guiFinishWindow)
		
		-- if player click the close button
		addEventHandler ( "onClientGUIClick", guiFinalCloseButton,  function(button, state)
			if(button == "left" and state == "up") then
				destroyElement(guiIntroLabel1)
				destroyElement(guiIntroProceedButton)
				destroyElement(guiIntroWindow)
				destroyElement(guiQuestionLabel)
				destroyElement(guiQuestionAnswer1Radio)
				destroyElement(guiQuestionAnswer2Radio)
				destroyElement(guiQuestionAnswer3Radio)
				destroyElement(guiQuestionWindow)
				destroyElement(guiFinalFailTextLabel)
				destroyElement(guiFinalCloseButton)
				destroyElement(guiFinishWindow)
				guiIntroLabel1 = nil
				guiIntroProceedButton = nil
				guiIntroWindow = nil
				guiQuestionLabel = nil
				guiQuestionAnswer1Radio = nil
				guiQuestionAnswer2Radio = nil
				guiQuestionAnswer3Radio = nil
				guiQuestionWindow = nil
				guiFinalFailTextLabel = nil
				guiFinalCloseButton = nil
				guiFinishWindow = nil
				
				selection = {}
				correctAnswers = 0
				
				showCursor(false)
			end
		end, false)
	end
	
end
 
 -- function starts the quiz
 function startLicenceTest()
 
	-- choose a random set of questions
	chooseTestQuestions()
	-- create the question window with question number 1
	createLicenseQuestionWindow(1)
 
 end
 
 
 -- functions chooses the questions to be used for the quiz
 function chooseTestQuestions()
 
	-- loop through selections and make each one a random question
	for i=1, 10 do
		-- pick a random number between 1 and the max number of questions
		local number = math.random(1, NoQuestions)
		
		-- check to see if the question has already been selected
		if(testQuestionAlreadyUsed(number)) then
			repeat -- if it has, keep changing the number until it hasn't
				number = math.random(1, NoQuestions)
			until (testQuestionAlreadyUsed(number) == false)
		end
		
		-- set the question to the random one
		selection[i] = questions[number]
	end
 end
 
 
 -- function returns true if the queston is already used
 function testQuestionAlreadyUsed(number)
 
	local same = 0
 
	-- loop through all the current selected questions
	for i, j in pairs(selection) do
		-- if a selected question is the same as the new question
		if(j[1] == questions[number][1]) then
			same = 1 -- set same to 1
		end
		
	end
	
	-- if same is 1, question already selected to return true
	if(same == 1) then
		return true
	else
		return false
	end
 end

---------------------------------------
------ Practical Driving Test ---------
---------------------------------------
 
testRoute = {
	{ 1097.4912109375, -1745.3984375, 13.195998191833 },	-- Start, DMV Parking 
	{ 1172.94921875, -1757.4228515625, 13.168026924133 },	-- Constitution Ave, Corner left, heading southbound
	{ 1172.80859375, -1827.580078125, 13.165369987488 }, 	-- Constitution Ave, Traffic lights
	{ 1234.5693359375, -1855.451171875, 13.148347854614 }, 	-- Metropolitean Ave
	{ 1300.521484375, -1855.0166015625, 13.151616096497  }, -- Metropolitean Ave, turn to St. Lawrence Blvd
	{ 1314.4736328125, -1832.9658203125, 13.149471282959 }, -- St. Lawrence Blvd
	{ 1314.9423828125, -1586.283203125, 13.148844718933 }, 	-- St. Lawrence Blvd, going to Panopticon Ave
	{ 1449.943359375, -1594.4150390625, 13.151237487793 }, 	-- Panopticon Ave, 
	{ 1643.119140625, -1594.36328125, 13.190489768982 }, 	-- Panopticon Ave, Traffic lights, turn to Apple St
	{ 1660.2060546875, -1577.44921875, 13.157166481018 },	-- Apple St
	{ 1660.10546875, -1453.4814453125, 13.150456428528 },	-- Apple St, turn to Pasadena Blvd
	{ 1707.537109375, -1444.423828125, 13.151439666748 },	-- Pasadena Blvd, turn to Allerton St.
	{ 1717.265625, -1286.677734375, 13.149129867554 },		-- Allerton St.
	{ 1717.0439453125, -1173.5869140625, 23.417699813843 },	-- Allerton St, turn to East Vinewood Blvd
	{ 1646.0927734375, -1158.1796875, 23.670152664185 },	-- East Vinewood Blvd, turn to Mulholland parking
	{ 1640.599609375, -1069.271484375, 23.666637420654 },	-- Mulholland parking
	{ 1685.8232421875, -1053.0732421875, 23.673542022705 },	-- Mulholland parking
	{ 1761.8544921875, -1053.4384765625, 23.729679107666 },	-- Mulholland parking
	{ 1784.8095703125, -1043.771484375, 23.728546142578 },	-- Mulholland parking
	{ 1750.396484375, -1026.8994140625, 23.729751586914 },	-- Mulholland parking [[SLOW DOWN]]
	{ 1705.361328125, -1012.1328125, 23.672727584839 }, 	-- Mulholland parking [[Park backwards]]
	{ 1712.705078125, -1005.3759765625, 23.684209823608 }, 	-- Mulholland parking [[Parked position]]
	{ 1710.546875, -1018.6103515625, 23.673368453979 }, 	-- Mulholland parking [[Resume]]
	{ 1626.9443359375, -1021.7998046875, 23.6676197052 }, 	-- Mulholland parking
	{ 1606.50390625, -1026.0888671875, 23.673536300659 }, 	-- Mulholland parking
	{ 1635.6005859375, -1082.9912109375, 23.674060821533 }, -- Mulholland parking
	{ 1634.92578125, -1148.625, 23.670957565308 }, 			-- Mulholland parking, Turn to East Vinewood Blvd
	{ 1591.482421875, -1158.560546875, 23.672548294067 }, 	-- East Vinewood Blvd, turn to Sunset Blvd
	{ 1580.5751953125, -1135.83984375, 23.281703948975 }, 	-- Sunset Blvd
	{ 1534.314453125, -1042.6337890625, 23.407707214355 }, 	-- Sunset Blvd
	{ 1459.470703125, -1032.3251953125, 23.423526763916 }, 	-- Sunset Blvd
	{ 1381.6240234375, -1034.158203125, 25.948440551758 }, 	-- Sunset Blvd, Turn to St. Lawrence Blvd
	{ 1371.9423828125, -999.201171875, 27.997165679932 }, 	-- St. Lawrence Blvd
	{ 1396.4931640625, -950.384765625, 34.453685760498 }, 	-- St. Lawrence Blvd, turn to West Broadway
	{ 1466.6552734375, -970.4765625, 36.029048919678 }, 	-- West Broadway
	{ 1530.0947265625, -1012.1240234375, 42.392574310303 }, -- West Broadway
	{ 1587.19140625, -1094.3857421875, 57.769351959229 }, 	-- Interstate 25
	{ 1611.8828125, -1223.369140625, 50.779727935791 }, 	-- Interstate 25
	{ 1568.8779296875, -1423.783203125, 28.262964248657 }, 	-- Interstate 125
	{ 1658.7060546875, -1545.14453125, 23.759267807007 }, 	-- Interstate 125
	{ 1773.4912109375, -1521.7509765625, 10.759161949158 }, -- Interstate 125
	{ 2037.5966796875, -1519.9716796875, 3.1063504219055 }, -- Interstate 125
	{ 2374.908203125, -1621.728515625, 8.445592880249 }, 	-- Interstate 125
	{ 2703.8056640625, -1627.40625, 13.347772598267 }, 		-- Interstate 125, turn to Saints Blvd
	{ 2721.146484375, -1644.9599609375, 12.795516967773 }, 	-- Saints Blvd, turn to St Anthony St.
	{ 2730.9609375, -1660.818359375, 12.83655834198 }, 		-- St Anthony St, turn to Saints Blvd
	{ 2739.8662109375, -1640.4736328125, 12.71591758728 }, 	-- Saints Blvd
	{ 2740.2490234375, -1462.814453125, 30.047548294067 }, 	-- Saints Blvd
	{ 2739.6103515625, -1269.6728515625, 59.085384368896 }, -- Saints Blvd, turn to Caesar Rd
	{ 2729.2265625, -1256.388671875, 59.31941986084 }, 		-- mid turn
	{ 2708.2138671875, -1255.3056640625, 58.8974609375 }, 	-- Caesar Rd
	{ 2656.51171875, -1253.83984375, 49.953052520752 }, 	-- Caesar Rd
	{ 2519.16015625, -1253.490234375, 34.648132324219 }, 	-- Caesar Rd, turn to Freedom St
	{ 2509.6708984375, -1271.5068359375, 34.507858276367 }, -- Freedom St
	{ 2509.8046875, -1431.8193359375, 28.12944984436 }, 	-- Freedom St, turn to Carson St
	{ 2498.064453125, -1442.09765625, 27.659200668335 }, 	-- Carson St
	{ 2436.7958984375, -1442.078125, 23.59688949585 }, 		-- Carson St, turn to Atlantica Ave
	{ 2428.6337890625, -1457.0361328125, 23.595087051392 }, -- Atlantica Ave
	{ 2429.548828125, -1498.4423828125, 23.604333877563 }, 	-- Atlantica Ave, turn to Pilon St
	{ 2445.734375, -1504.6962890625, 23.593351364136 }, 	-- Pilon St
	{ 2552.2138671875, -1499.2392578125, 23.633754730225 }, -- Pilon St
	{ 2556.599609375, -1449.4677734375, 23.596382141113 },	-- St. Joseph St
	{ 2574.6181640625, -1415.869140625, 23.609474182129 },	-- St. Joseph St
	{ 2573.458984375, -1268.056640625, 45.778781890869 },	-- St. Joseph St
	{ 2573.4169921875, -1196.08203125, 61.039268493652 },	-- St. Joseph St, turn to Fremont St
	{ 2560.0673828125, -1181.0927734375, 61.341533660889 },	-- Fremont St, turn to Fame St
	{ 2368.376953125, -1184.9541015625, 27.194440841675 },	-- Fame St
	{ 2369.416015625, -1293.5341796875, 23.607564926147 },	-- Fame St, turn to Belview Rd
	{ 2354.26171875, -1297.4853515625, 23.659496307373 },	-- Belview Rd
	{ 2301.2939453125, -1311.044921875, 23.595907211304 },	-- Howard Blvd
	{ 2302.0078125, -1372.892578125, 23.625688552856 },		-- Howard Blvd, turn to Carson St
	{ 2279.791015625, -1380.93359375, 23.784725189209 },	-- Carson St
	{ 2089.1142578125, -1382.46484375, 23.593004226685 },	-- Carson St
	{ 2074.3408203125, -1351.5751953125, 23.586029052734 },	-- Majestic St
	{ 2073.6943359375, -1266.7666015625, 23.592498779297 },	-- Majestic St, turn to Park ave
	{ 2053.5400390625, -1258.734375, 23.586196899414 },		-- Park ave
	{ 1964.37890625, -1258.1943359375, 23.363805770874 },	-- Park ave
	{ 1863.265625, -1258.5341796875, 13.152058601379 },		-- Park ave
	{ 1801.7744140625, -1264.591796875, 13.234252929688 },	-- Park ave
	{ 1700.75, -1297.6181640625, 13.214303016663 },			-- Park ave
	{ 1575.775390625, -1298.638671875, 17.001453399658 },	-- Park ave
	{ 1467.869140625, -1297.787109375, 13.194109916687 },	-- Park ave, turn to Central ave
	{ 1453.318359375, -1310.9248046875, 13.147992134094 },	-- Central ave
	{ 1452.9951171875, -1428.609375, 13.15167427063 },		-- Central ave, turn to Pasadena Blvd
	{ 1432.9111328125, -1437.7880859375, 13.151093482971 },	-- Pasadena Blvd
	{ 1417.7021484375, -1393.98046875, 13.153037071228 },	-- Pasadena Blvd
	{ 1209.6865234375, -1393.26171875, 13.055730819702 },	-- Pasadena Blvd
	{ 899.060546875, -1392.6669921875, 13.002005577087 },	-- Pasadena Blvd
	{ 650.7197265625, -1393.5634765625, 13.207903862 },		-- Pasadena Blvd
	{ 627.9658203125, -1399.740234375, 13.07910823822 },	-- Pasadena Blvd, turn to Western Ave
	{ 625.46484375, -1420.6279296875, 13.330267906189 },	-- Western Ave
	{ 625.86328125, -1574.533203125, 15.260710716248 },		-- Western Ave
	{ 626.25390625, -1665.095703125, 15.333947181702 },		-- Western Ave, turn to Rodeo Drive
	{ 658.7236328125, -1673.572265625, 13.861406326294 },	-- Rodeo Drive
	{ 798.6552734375, -1676.9580078125, 13.136416435242 },	-- Rodeo Drive, turn to Panopticon Ave
	{ 812.7939453125, -1663.6630859375, 13.151741981506 },	-- Panopticon Ave
	{ 851.5791015625, -1602.865234375, 13.150911331177 },	-- Panopticon Ave
	{ 932.759765625, -1575.3203125, 13.149545669556 },		-- Panopticon Ave
	{ 1025.3271484375, -1574.142578125, 13.151293754578 },	-- Panopticon Ave, turn to Beverly Ave
	{ 1034.9521484375, -1585.8505859375, 13.147232055664 },	--  Beverly Ave
	{ 1034.3193359375, -1703.21875, 13.156379699707 },		--  Beverly Ave, turn to San Andreas Blvd
	{ 1054.1767578125, -1714.37890625, 13.150157928467 },	-- San Andreas Blvd
	{ 1164.9052734375, -1714.7451171875, 13.50904750824 },	-- San Andreas Blvd, turn to Constitution Ave
	{ 1173.037109375, -1727.048828125, 13.338621139526 },	-- Constitution Ave
	{ 1159.7724609375, -1738.095703125, 13.274960517883 },	-- DMV End road
	{ 1076.0205078125, -1739.310546875, 13.266344070435 },	-- DMV End road [[PARK IT BACKWARDS]]
	{ 1062.146484375, -1749.27734375, 13.216771125793 },	-- DMV End road
}

testVehicle = { [436]=true } -- Previons need to be spawned at the start point.

local blip = nil
local marker = nil

function initiateDrivingTest()
	triggerServerEvent("theoryComplete", getLocalPlayer())
	local x, y, z = testRoute[1][1], testRoute[1][2], testRoute[1][3]
	blip = createBlip(x, y, z, 0, 2, 0, 255, 0, 255)
	marker = createMarker(x, y, z, "checkpoint", 4, 0, 255, 0, 150) -- start marker.
	addEventHandler("onClientMarkerHit", marker, startDrivingTest)
	
	outputChatBox("#FF9933You are now ready to take your practical driving examination. Collect a DMV test car and begin the route.", 255, 194, 14, true)
	
end

function startDrivingTest(element)
	if element == getLocalPlayer() then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (testVehicle[id]) then
			outputChatBox("#FF9933You must be in a DMV test car when passing through the checkpoints.", 255, 0, 0, true ) -- Wrong car type.
		elseif not exports.global:hasMoney( getLocalPlayer(), 100 ) then
			outputChatBox("You can't pay the processing fee.", 255, 0, 0 )
		else
			destroyElement(blip)
			destroyElement(marker)
			
			outputChatBox("You have paid the $100 fee to take the driving practical test.", source, 255, 194, 14)
			triggerServerEvent("payFee", getLocalPlayer(), 100)
			
			local vehicle = getPedOccupiedVehicle ( getLocalPlayer() )
			setElementData(getLocalPlayer(), "drivingTest.marker", 2, false)

			local x1,y1,z1 = nil -- Setup the first checkpoint
			x1 = testRoute[2][1]
			y1 = testRoute[2][2]
			z1 = testRoute[2][3]
			setElementData(getLocalPlayer(), "drivingTest.checkmarkers", #testRoute, false)

			blip = createBlip(x1, y1 , z1, 0, 2, 255, 0, 255, 255)
			marker = createMarker( x1, y1,z1 , "checkpoint", 4, 255, 0, 255, 150)
				
			addEventHandler("onClientMarkerHit", marker, UpdateCheckpoints)
				
			outputChatBox("#FF9933You will need to complete the route without damaging the test car. Good luck and drive safe.", 255, 194, 14, true)
		end
	end
end

function UpdateCheckpoints(element)
	if (element == localPlayer) then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (testVehicle[id]) then
			outputChatBox("You must be in a DMV test car when passing through the check points.", 255, 0, 0) -- Wrong car type.
		else
			destroyElement(blip)
			destroyElement(marker)
			blip = nil
			marker = nil
				
			local m_number = getElementData(getLocalPlayer(), "drivingTest.marker")
			local max_number = getElementData(getLocalPlayer(), "drivingTest.checkmarkers")
			
			if (tonumber(max_number-1) == tonumber(m_number)) then -- if the next checkpoint is the final checkpoint.
				outputChatBox("#FF9933Park your car at the #FF66CCin the parking lot #FF9933to complete the test.", 255, 194, 14, true)
				
				local newnumber = m_number+1
				setElementData(getLocalPlayer(), "drivingTest.marker", newnumber, false)
					
				local x2, y2, z2 = nil
				x2 = testRoute[newnumber][1]
				y2 = testRoute[newnumber][2]
				z2 = testRoute[newnumber][3]
				
				marker = createMarker( x2, y2, z2, "checkpoint", 4, 255, 0, 255, 150)
				blip = createBlip( x2, y2, z2, 0, 2, 255, 0, 255, 255)
				
				
				addEventHandler("onClientMarkerHit", marker, EndTest)
			else
				local newnumber = m_number+1
				setElementData(getLocalPlayer(), "drivingTest.marker", newnumber, false)
						
				local x2, y2, z2 = nil
				x2 = testRoute[newnumber][1]
				y2 = testRoute[newnumber][2]
				z2 = testRoute[newnumber][3]
						
				marker = createMarker( x2, y2, z2, "checkpoint", 4, 255, 0, 255, 150)
				blip = createBlip( x2, y2, z2, 0, 2, 255, 0, 255, 255)
				
				addEventHandler("onClientMarkerHit", marker, UpdateCheckpoints)
			end
		end
	end
end

function EndTest(element)
	if (element == localPlayer) then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (testVehicle[id]) then
			outputChatBox("You must be in a DMV test car when passing through the check points.", 255, 0, 0)
		else
			local vehicleHealth = getElementHealth ( vehicle )
			if (vehicleHealth >= 800) then
				if not exports.global:hasMoney( getLocalPlayer(), 250 ) then
					outputChatBox("You can't afford the $250 processing fee.", 255, 0, 0)
				else
					----------
					-- PASS --
					----------
					outputChatBox("After inspecting the vehicle we can see no damage.", 255, 194, 14)
					triggerServerEvent("acceptLicense", getLocalPlayer(), 1, 250)
				end
			else
				----------
				-- Fail --
				----------
				outputChatBox("After inspecting the vehicle we can see that it's damage.", 255, 194, 14)
				outputChatBox("You have failed the practical driving test.", 255, 0, 0)
			end
			
			destroyElement(blip)
			destroyElement(marker)
			blip = nil
			marker = nil
					
			removeElementData(thePlayer, "drivingTest.vehicle")
			
			removeElementData(thePlayer, "drivingTest.vehicle")	-- cleanup data
			removeElementData ( thePlayer, "drivingTest.marker" )
			removeElementData ( thePlayer, "drivingTest.checkmarkers" )
		end
	end
end

bindKey( "accelerate", "down",
	function( )
		local veh = getPedOccupiedVehicle( getLocalPlayer( ) )
		if veh and getVehicleOccupant( veh ) == getLocalPlayer( ) then
			if isElementFrozen( veh ) and getVehicleEngineState( veh ) then
				outputChatBox( "(( Your handbrake is applied. Use /handbrake to release it. ))", 255, 194, 14 )
			elseif not getVehicleEngineState( veh ) then
				outputChatBox( "(( Your engine is off. Press 'J' to turn it on. ))", 255, 194, 14 )
			end
		end
	end
)