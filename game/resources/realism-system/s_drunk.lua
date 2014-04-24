addEvent("setDrunkness", true)
addEventHandler("setDrunkness", getRootElement(),
	function( level )
		exports['anticheat-system']:changeProtectedElementDataEx( source, "alcohollevel", level or 0, false )
	end
)