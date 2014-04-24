local wPedRightClick, bTalkToPed, bClosePedMenu, closing, selectedElement = nil
local wGui = nil
local sent = false

function pedDamage()
	cancelEvent()
end
addEventHandler("onClientPedDamage", getResourceRootElement(), pedDamage)

function onQuestionShow(questionArray) 
	selectedElement = source
	local Width = 300
	local Height = 450
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	local verticalPos = 0.05
	if not (wGui) then
		wGui = guiCreateWindow(X, Y, Width, Height, "Answer the question:", false )
		
		for answerID, answerStr in ipairs(questionArray) do
			if (answerStr) then
				local option = guiCreateButton( 0.05, verticalPos, 0.9, 0.2, answerStr, true, wGui )
				setElementData(option, "option", answerID, false)
				setElementData(option, "optionstr", answerStr, false)
				addEventHandler( "onClientGUIClick", option, answerConvo, false )
			end
			verticalPos = verticalPos + 0.2
		end
		showCursor(true)
	end
end
addEvent( "fuel:convo", true )
addEventHandler( "fuel:convo", getRootElement(), onQuestionShow )

function answerConvo( mouseButton )
	if (mouseButton == "left") then
		theButton = source
		local option = getElementData(theButton, "option")
		if (option) then
			local optionstr = getElementData(theButton, "optionstr")
			triggerServerEvent("fuel:convo", selectedElement, option, optionstr)
			cleanGUI()
		end
	end
end

function cleanGUI()
	destroyElement(wGui)
	wGui = nil
	showCursor(false)
end