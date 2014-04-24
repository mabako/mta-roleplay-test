--========================= TUTORIAL SCRIPT ==============================================

-- Concrete Gaming Roleplay Server - Tutorial and Quiz script for un-registerd players - written by Peter Gibbons (aka Jason Moore)

local tutorialStage = {}
	tutorialStage[1] = {1942.0830078125, -1738.974609375, 16.3828125, 1942.0830078125, -1760.5703125, 13.3828125} -- idlewood gas station//
	tutorialStage[2] = {1538.626953125, -1675.9375, 19.546875, 1553.8388671875, -1675.6708984375, 16.1953125} --LSPD//
	tutorialStage[3] = {2317.6123046875, -1664.6640625, 17.215812683105, 2317.4755859375, -1651.1640625, 17.221110343933} -- 10 green bottles//
	tutorialStage[4] = {1742.623046875, -1847.7109375, 16.579560279846, 1742.1884765625, -1861.3564453125, 13.577615737915} -- Unity Station//
	tutorialStage[5] = {1685.3681640625, -2309.9150390625, 16.546875, 1685.583984375, -2329.4443359375, 13.546875} -- Airport//
	tutorialStage[6] = {368.0419921875, -2008.1494140625, 7.671875, 383.765625, -2020.935546875, 10.8359375} -- Pier//
	tutorialStage[7] = {1411.384765625, -870.787109375, 78.552024841309, 1415.9248046875, -810.15234375, 78.552024841309} -- Vinewood sign//
	tutorialStage[8] = {1893.955078125, -1165.79296875, 27.048973083496, 1960.4404296875, -1197.3486328125, 26.849721908569} -- Glen Park//
	tutorialStage[9] = {1813.59375, -1682.1796875, 13.546875, 1834.3828125, -1682.400390625, 14.433801651001} -- Alhambra//
	tutorialStage[10] = {2421.8271484375, -1261.2265625, 25.833599090576, 2432.0537109375, -1246.919921875, 25.874616622925} -- Pig Pen//
	tutorialStage[11] = {2817.37890625, -1865.7998046875, 14.219080924988, 2858.4248046875, -1849.91796875, 14.084205627441} -- East Beach
	
local stageTime = 15000
local fadeTime = 2000
local fadeDelay = 300

local tutorialTitles = {}
	tutorialTitles[1] = "WELCOME"
	tutorialTitles[2] = "YOUR NAME"
	tutorialTitles[3] = "ROLEPLAYING"
	tutorialTitles[4] = "IC AND OOC"
	tutorialTitles[5] = "ROLEPLAY RULES"
	tutorialTitles[6] = "EXPLOITING"
	tutorialTitles[7] = "LANGUAGE"
	tutorialTitles[8] = "SERVER RULES"
	tutorialTitles[9] = "STARTING OUT"
	tutorialTitles[10] = "ADMINS"
	tutorialTitles[11] = "MORE INFORMATION"
	

local tutorialText = {}
		tutorialText[1] = {"Hello and welcome to Valhalla Gaming: MTA Roleplay Server.",
					"I see you're new here, so please give us 2 minutes to introduce you the server.",
					"Currently we are the only fully roleplay structured server on MTA, with a constantly",
					"updating script. You can visit the website at http://mta.vg for more info."}
	
	tutorialText[2] = 		{"Roleplay (RP) is a game genre where the players assume the role of a fictional",
					"character. In our server, your name is your identity, and must be in the format ",
					"Firstname Lastname. It can be anything you want, as long as it's realistic and",
					"not a celebrity name. An example of a valid name is: 'Niko Harrison'. "}
	
	tutorialText[3] = 		{"You're expected to roleplay at all times. That means acting as you would in",
					"real life. Just because it's possible in GTA, doesn't mean it's ok to do it here.",
					"Even though we have server factions, you can roleplay anything you want,",
					"providing that it follows the server rules."}
	
	tutorialText[4] = 		{"In Character (IC) and Out of Character (OOC) is fundamental to good roleplaying",
					"OOC refers to you, the player, talking about non relevant, off topic things.",
					"To talk OOC to each other, use /o, /b and /pm. IC refers your characters words",
					"being spoken to other characters - try not to confuse the two."}
	
	tutorialText[5] = 		{"There are a number of roleplay terms that you will need to understand, like 'Metagaming' (using",
					"OOC information in a IC situation), or 'Powergaming' (forcing your roleplay on other people.)",
					"For more information about these terms, press F1 in game and all the information you need",
					"to know will be there. We don't like people metagaming or powergaming, so please don't do it!"}
	
	tutorialText[6] = 		{"Gaining an unfair advantage over other players, by using cheats or abusing",
					"bugs won't be tolerated in any way, and will result in a instant ban, so watch",
					"out! ;)  If you see any exploits in the script, please report it to the admins ",
					"straight away or externally onto our forums." }
					  
	tutorialText[7] = 		{"We encourage people from all over the world to play here, but ask that",
					"you all stick to one language - English - so everyone knows whats going on,",
					"even in OOC. If you want to talk in your native language to someone, please",
					"do it over private messages. (/pm)"}
	
	tutorialText[8] = 		{"Our set of server rules are probably very different compared to other MTA servers.",
					"There is a full list available on the website, but some of the most common are:",
					"No deathmatching, advertising other servers and cheating or hacking (obviously...)",
					"No spamming the chat or commands please, and don't use full capitals, thanks!"}

	tutorialText[9] =		 {"So you've just arrived in Los Santos, what do you do? There are plenty",
					"of factions for you to become members of - just roleplay with other players",
					"and you'll soon find yourself rising up the faction ranks. Some factions, like ",
					"the LSPD require you to fill out applications on the forums before you can join."}
	
	tutorialText[10] = 	{"Our admins are here to help you should you need it. If you need help, have a quick question",
					"or wish to report someone for breaking the rules, don't be afraid to use /report  and someone ",
					"will come and help as soon as they can. For larger questions, and account issues, it might be",
					"easier to ask on our forums at http://www.mta.vg/"}
				   
	tutorialText[11] = 	{"For more information on the server, as already mentioned, press F1 during gameplay.",
					"A list of player commands can be found by doing /helpcmds, so please read through and",
					"familarise yourself with them. Alternatively ask one of the admins or players in game.",
					"This marks the end of the tutorial. Thank you for playing. "}
					
					

-- function starts the tutorial
function showTutorial()

	local thePlayer = getLocalPlayer()

	-- set the player to not logged in so they don't see any other random chat
	triggerServerEvent("player:loggedout", getLocalPlayer())
		
	-- if the player hasn't got an element data, set it to 1
	if not (getElementData(thePlayer, "tutorialStage")) then
		setElementData(thePlayer, "tutorialStage", 0, false)
	end
	
	-- ionc
	setElementData(thePlayer, "tutorialStage", getElementData(thePlayer, "tutorialStage")+1, false)

	
	-- stop the player from using any controls to move around or chat
	toggleAllControls (  false )
	-- fade the camera to black so they don't see the teleporting renders
	fadeCamera ( false, fadeTime/1000 ,0,0,0)
	
	-- timer to move the camera to the first location as soon as the screen has gone black.
	setTimer(function()
		
		-- timer to set camera position and fade in after the camera has faded out to black
		setTimer(function()
				
			local stage = getElementData(thePlayer, "tutorialStage")
			
			local camX = tutorialStage[stage][1]
			local camY = tutorialStage[stage][2]
			local camZ = tutorialStage[stage][3]
			local lookX = tutorialStage[stage][4]
			local lookY = tutorialStage[stage][5]
			local lookZ = tutorialStage[stage][6]
			
			setCameraMatrix(camX, camY, camZ, lookX, lookY, lookZ)
			
			-- set the element to outside and dimension 0 so they see th eother players
			setElementInterior(thePlayer, 0)
			setElementDimension(thePlayer, 0)
			
			-- fade the camera in
			fadeCamera( true, fadeTime/1000)
			
			-- call function to output the text
			outputTutorialText(stage)
			
			-- function to fade out after message has been displayed a read
			setTimer(function()
								
				local lastStage = getLastStage()
				
				-- if the player is on the last stage of the tutorial, fade their camera out and...
				if(stage == lastStage) then
					fadeCamera( false, fadeTime/1000, 0,0,0)
					
					setTimer(function()

						-- show the quiz after a certain time
						endTutorial()
						
						setElementData ( thePlayer, "tutorialStage", 0, false )
						
					end, fadeTime+fadeDelay,1 )
				else -- else more stages to go, show the next stage
					showTutorial(thePlayer)
				end
			end, stageTime, 1)
		end, 150, 1)
	end, fadeTime+fadeDelay , 1)
end



-- function returns the number of stages
function getLastStage()

	local lastStage = 0
	
	if(tutorialStage) then
		for i, j in pairs(tutorialStage) do
			lastStage = lastStage + 1
		end
	end
	
	return lastStage
end


-- function outputs the text during the tutorial
function outputTutorialText( stage)
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(tutorialTitles[stage],  255, 0,0, true)
	outputChatBox(" ")
	
	if(tutorialText[stage]) then
		for i, j in pairs(tutorialText[stage]) do
				outputChatBox(j)
		end
	end

end

-- function fade in the camera and sets the player to the quiz room so they can do the quiz
function endTutorial()

	local thePlayer = getLocalPlayer()
	
	-- set the player to not logged in so they don't see the chat
	triggerServerEvent("player:loggedout", getLocalPlayer())
	toggleAllControls(false)
			
	
	setTimer(function()
		setCameraMatrix(368.0419921875, -2008.1494140625, 7.671875, 383.765625, -2020.935546875, 10.8359375)
		
		-- fade the players camera in
		fadeCamera(true, 2)
		
		-- trigger the client to start showing the quiz
		setTimer(function()
			triggerEvent("onClientStartQuiz", thePlayer)
			
		end, 2000, 1)
		
		
	end, 100, 1)

end




   ------------ TUTORIAL QUIZ SECTION - SCRIPTED BY PETER GIBBONS, AKA JASON MOORE --------------
   
   
   
   questions = { }
questions[1] = {"What does the term RP stand for?", "Real Playing", "Role Playing", "Record Playing", "Route Playing", 2}
questions[2] = {"When are you allowed to advertise other servers?", "Using /ad", "In out of character chat", "Via PM's (/pm)", "Never", 4}
questions[3] = {"What should you do if you see someone hacking?", "Tell an admin using /report", "Ignore it", "/w the hacker and tell them to stop", "Report the hacker in OOC", 1}
questions[4] = {"What is the address of the website and forums?", "www.valhalla.com", "www.valhallagaming.co.uk", "www.mta.vg or www.valhallagaming.net", "www.vg.com", 3} 
questions[5] = {"I want to get to the other side of Los Santos, how should I do it?", "Ask an admin to teleport you.", "Find a roleplay way to get there, like a taxi.", "Start bunnyhopping to get there faster", "Jump in a random players car and demand them to take you.", 2}
questions[6] = {"What is the correct format for your in game name?", "Firstname", "firstname lastname", "Firstname Lastname", "There is no format", 3}
questions[7] = {"Which one of the following names would be acceptable", "David Beckham", "Niko Harrison", "Roleplayer 150", "They are all acceptable", 2}
questions[8] = {"When must you roleplay in this server?", "At all times", "Never", "When you feel like it", "Only when other people are", 1}
questions[9] = {"What should you do if you accidently drive your car off a cliff?", "Carry on driving because the car didn't blow up", "Ask an admin to move you to the top of the cliff", "Say it was an OOC accident", "Stop and roleplay a car accident", 4}
questions[10] = {"I want to join a particular gang or mafia, how should I do it?", "Ask an admin to move you into the faction", "Ask in OOC to join the faction", "Roleplay with the gang/mafia until they invite you.", "nil", 3}
questions[11] = {"What does OOC stand for?", "Out of Control", "Out of Character", "Out of Chance", "Out of Coffee", 2}
questions[12] = {"What does IC stand for?", "In Character", "In Chaos", "In Car", "nil", 1}
questions[13] = {"What is Metagaming?", "Killing someone for no reason", "Doing something that is unrealistic in real life", "Forcing your roleplay on other players", "Using Out of Character knowledge in In Character situations", 4}
questions[14] = {"What language should you use in this server?", "French", "English", "Hewbrew", "Anything", 2}
questions[15] = {"When can you talk to another player in your native language?", "In Character chat", "In any Out of Character chat", "Through private messages only.", "Never", 3}
questions[16] = {"Which ones of these is a server rule?", "No Roleplaying", "No Deathmatching", "No Driving", "No Shooting", 2}
questions[17] = {"What would you do if you wanted to contact an admin?", "Use the admin /report system", "Ask in global OOC for an admin", "Private message the admin", "Ask In Character for an admin.", 1}

-- variable for the max number of possible questions
local NoQuestions = 17
local NoQuestionToAnswer = 10
local correctAnswers = 0
local passPercent = 90
		
selection = {}


-- functon makes the intro window for the quiz
function createQuizIntroWindow()

	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	guiIntroWindow = guiCreateWindow ( X , Y , Width , Height , "Roleplay Quiz" , false )
	
	guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "banner.png", true, guiIntroWindow)
	
	guiIntroLabel1 = guiCreateLabel(0, 0.3,1, 0.5, "	You will now proceed with a short roleplay quiz. This quiz isn't\
										 hard and is only to check that you've followed the tutorial. All \
										of the answers are hidden in the tutorial, and you don't need to \
										get every question correct.\
										\
										Good luck!", true, guiIntroWindow)
	
	guiLabelSetHorizontalAlign ( guiIntroLabel1, "center")
	guiSetFont ( guiIntroLabel1,"default-bold-small")
	
	guiIntroProceedButton = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Start Quiz" , true ,guiIntroWindow)
	
	guiSetVisible(guiIntroWindow, true)
	
	addEventHandler ( "onClientGUIClick", guiIntroProceedButton,  function(button, state)
		if(button == "left" and state == "up") then
		
			-- start the quiz and hide the intro window
			startQuiz()
			guiSetVisible(guiIntroWindow, false)
		
		end
	end, false)

end


-- function create the question window
function createQuestionWindow(number)

	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	-- create the window
	guiQuestionWindow = guiCreateWindow ( X , Y , Width , Height , "Question "..number.." of "..NoQuestionToAnswer , false )
	
	guiQuestionLabel = guiCreateLabel(0.1, 0.2, 0.9, 0.1, selection[number][1], true, guiQuestionWindow)
	guiSetFont ( guiQuestionLabel,"default-bold-small")
	
	
	if not(selection[number][2]== "nil") then
		guiQuestionAnswer1Radio = guiCreateRadioButton(0.1, 0.3, 0.9,0.1, selection[number][2], true,guiQuestionWindow)
	end
	
	if not(selection[number][3] == "nil") then
		guiQuestionAnswer2Radio = guiCreateRadioButton(0.1, 0.4, 0.9,0.1, selection[number][3], true,guiQuestionWindow)
	end
	
	if not(selection[number][4]== "nil") then
		guiQuestionAnswer3Radio = guiCreateRadioButton(0.1, 0.5, 0.9,0.1, selection[number][4], true,guiQuestionWindow)
	end
	
	if not(selection[number][5] == "nil") then
		guiQuestionAnswer4Radio = guiCreateRadioButton(0.1, 0.6, 0.9,0.1, selection[number][5], true,guiQuestionWindow)
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
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer4Radio)) then
					selectedAnswer = 4
				else
					selectedAnswer = 0
				end
				
				-- don't let the player continue if they havn't selected an answer
				if(selectedAnswer ~= 0) then
					
					-- if the selection is the same as the correct answer, increase correct answers by 1
					if(selectedAnswer == selection[number][6]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create a new window for the next question
					guiSetVisible(guiQuestionWindow, false)
					createQuestionWindow(number+1)
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
					if(selectedAnswer == selection[number][6]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create the finish window
					guiSetVisible(guiQuestionWindow, false)
					createFinishQuizWindow()


				end
			end
		end, false)
	end
end


-- funciton create the window that tells the
function createFinishQuizWindow()

	local score = (correctAnswers/NoQuestionToAnswer)*100

	local screenwidth, screenheight = guiGetScreenSize ()
		
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
		
	-- create the window
	guiFinishWindow = guiCreateWindow ( X , Y , Width , Height , "End of Quiz", false )
	
	if(score >= passPercent) then
	
		local xmlRoot = xmlCreateFile("vgrptut.xml", "passedtutorial")
		xmlSaveFile(xmlRoot)
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "pass.png", true, guiFinishWindow)
	
		guiFinalPassLabel = guiCreateLabel(0, 0.3, 1, 0.1, "Congratulations! You have passed!", true, guiFinishWindow)
		guiSetFont ( guiFinalPassLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalPassLabel, "center")
		guiLabelSetColor ( guiFinalPassLabel ,0, 255, 0 )
		
		guiFinalPassTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "You scored "..score.."%, and the pass mark is "..passPercent.."%. Well done!\
											Please remember to register at the forums (www.mta.vg)\
											if you have not done so.\
											\
											Thank you for playing at Valhalla Gaming MTA!" ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalPassTextLabel, "center")
		
		guiFinalRegisterButton = guiCreateButton ( 0.35 , 0.8 , 0.3, 0.1 , "Continue" , true ,guiFinishWindow)
		
		-- if the player has passed the quiz and clicks on register
		addEventHandler ( "onClientGUIClick", guiFinalRegisterButton,  function(button, state)
			if(button == "left" and state == "up") then
				-- reset their correct answers
				correctAnswers = 0
				guiSetVisible(guiFinishWindow, false)
				toggleAllControls ( true )
				triggerClientEvent(thePlayer, "onClientPlayerWeaponCheck", thePlayer)
				if createXMB then
					createXMB()
				else
					createMainUI(getThisResource())
				end
			end
		end, false)
		
	else -- player has failed, 
	
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "fail.png", true, guiFinishWindow)
	
		guiFinalFailLabel = guiCreateLabel(0, 0.3, 1, 0.1, "Sorry, you have not passed this time.", true, guiFinishWindow)
		guiSetFont ( guiFinalFailLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalFailLabel, "center")
		guiLabelSetColor ( guiFinalFailLabel ,255, 0, 0 )
		
		guiFinalFailTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "You scored "..math.ceil(score).."%, and the pass mark is "..passPercent.."%.\
											You can retake the quiz as many times as you like, so have another shot!\
											\
											Thank you for playing at Valhalla Gaming MTA!" ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalFailTextLabel, "center")
		
		guiFinalRetakeButton = guiCreateButton ( 0.2 , 0.8 , 0.25, 0.1 , "Take Quiz Again" , true ,guiFinishWindow)
		guiFinalTutorialButton = guiCreateButton ( 0.55 , 0.8 , 0.25, 0.1 , "Show Tutorial" , true ,guiFinishWindow)
		
		-- if player click the retake button
		addEventHandler ( "onClientGUIClick", guiFinalRetakeButton,  function(button, state)
			if(button == "left" and state == "up") then
				-- reset their correct answers
				correctAnswers = 0
				guiSetVisible(guiFinishWindow, false)
				startShowQuizIntro()
			end
		end, false)
		
		-- if player click the show tutorial
		addEventHandler ( "onClientGUIClick", guiFinalTutorialButton,  function(button, state)
			if(button == "left" and state == "up") then
				-- reset their correct answers and hide the window
				correctAnswers = 0
				guiSetVisible(guiFinishWindow, false)
				guiSetInputEnabled(false)
				
				-- trigger server event to show the tutorial
				showTutorial()
			end
		end, false)
	
	
	
	end

end


-- function is triggerd by the server when it is time for the player to take the quiz
function startShowQuizIntro()
	
	clearChatBox()
	-- reset the players correct answers to 0
	correctAnswers = 0
	-- create the intro window
	createQuizIntroWindow()
	-- Set input enabled
	guiSetInputEnabled(true)

end
 addEvent("onClientStartQuiz", true)
 addEventHandler( "onClientStartQuiz", getLocalPlayer() ,  startShowQuizIntro)
 
 
 -- function starts the quiz
 function startQuiz()
 
	-- choose a random set of questions
	chooseQuizQuestions()
	-- create the question window with question number 1
	createQuestionWindow(1)
 
 end
 
 
 
 
 -- functions chooses the questions to be used for the quiz
 function chooseQuizQuestions()
 
	-- loop through selections and make each one a random question
	for i=1, 10 do
		-- pick a random number between 1 and the max number of questions
		local number = math.random(1, NoQuestions)
		
		-- check to see if the question has already been selected
		if(questionAlreadyUsed(number)) then
			repeat -- if it has, keep changing the number until it hasn't
				number = math.random(1, NoQuestions)
			until (questionAlreadyUsed(number) == false)
		end
		
		-- set the question to the random one
		selection[i] = questions[number]
	end
 end
 
 
 -- function returns true if the queston is already used
 function questionAlreadyUsed(number)
 
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