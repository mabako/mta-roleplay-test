function cameraEffect()
	fadeCamera(false, 0.5, 255, 255, 255)
	setTimer(fadeCamera, 300, 0.5, true)
end
addEvent("speedcam:cameraEffect", true)
addEventHandler("speedcam:cameraEffect", getRootElement(), cameraEffect)