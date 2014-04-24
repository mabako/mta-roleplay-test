-- This is a fix for the global resource not starting up

function resStart()
	setTimer(loadGlobal, 1000, 1)
end
addEventHandler("onResourceStart", getResourceRootElement(), resStart)


function loadGlobal()
	restartResource(getResourceFromName("global"))
end