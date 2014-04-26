local rootElement = getRootElement()

function outputConsoleR(message, toElement)
	if toElement == false or getElementType(toElement) == "console" then
		outputServerLog(message)
	else
		toElement = toElement or rootElement
		outputConsole(message, toElement)
		if toElement == rootElement then
			outputServerLog(message)
		end
	end
end

function outputChatBoxR(message, toElement)
	if toElement == false or getElementType(toElement) == "console" then
		outputServerLog(message)
	else
		toElement = toElement or rootElement
		outputChatBox(message, toElement, 250, 200, 200)
		if toElement == rootElement then
			outputServerLog(message)
		end
	end
end