function outputChatBoxR(message)
	if not getElementData(getLocalPlayer(),"runcode:hideoutput") then
		return outputChatBox(message, 200, 250, 200)
	else
		return true
	end
end
