local weatherArray = {}

local weatherStartTime = 0
local currentWeather = { 1, 1000, 10 }
local weatherTimer = nil
--[[local weatherStates = {
	sunny = { 0, 1, 2, 3, 4, 5, 6, 10, 13, 14, 23, 24, 25, 26, 27, 29, 33, 34, 40, 46, 52, 302, 12800 }, --  11, 17, 18  has heat waves
	clouds = { 7, 12, 15, 31, 30, 35, 36, 37, 41, 43, 47, 48, 49, 50, 51, 53, 56, 60 },
	rainy = { 8, 16, 306 },
	fog = { 9, 20, 28, 32, 38, 42, 55, 65, 88, 800 },
	dull = { 12, 54 },
	--sandstorm = { 19 },
}]]

local weatherStates = {
 { 0, 1, 2, 3, 4, 5, 6, 10, 13, 14}, -- 23, 24, 25,  27, 29, 33, 34, 40, 46, 52, 302, 12800 }, --  11, 17, 18  has heat waves
 { 7, 12, 15 }, -- 31, 30, 35, 36, 37, 41, 43, 47, 48, 49, 50, 51, 53, 56, 60 },
 { 8, 16 }, --, 306 },
 { 9, 20, 28, 32}, -- 38, 42, 55, 65, 88, 800 },
 { 12}, --, 54 },
	--sandstorm = { 19 },
}

function changeWeather()
	if  #weatherArray < 4 then
		while (#weatherArray < 8) do
			
			table.insert(weatherArray, { 1, generateRandomTime() } ) -- generateWeatherTypes()
		end
	end
	
	if weatherArray[1] then
		weatherStartTime = getRealTime().timestamp
		currentWeather = weatherArray[1]
		table.remove(weatherArray, 1)
		
		-- Generate new weatherstyle
		--outputDebugString("wtfman")
		local weatherStyle = currentWeather[1]
		--outputDebugString(tostring(#weatherStates[weatherStyle ]))
		--outputDebugString("wtfman2")
		currentWeather[3] = weatherStates[currentWeather[1]][math.random(1, #weatherStates[currentWeather[1]])]
		--outputDebugString("wtfman3")
		exports.global:sendMessageToAdmins("Weather changing to "..currentWeather[1]..":"..currentWeather[3] .." for "..	currentWeather[2] .. "sec")
		--outputDebugString("wtfman4")
		-- Shift weather
		triggerClientEvent("weather:update", getRootElement(), currentWeather[3], true)
		
		-- Cleanup
		if weatherTimer and isTimer(weatherTimer) then
			killTimer(weatherTimer)
		end
		weatherTimer = setTimer(changeWeather, currentWeather[2]*1000, 1)
	end
end


function eta(tp)
	local timed = weatherStartTime + currentWeather[2]
	local realtime = getRealTime( timed - 3600  )
	outputChatBox("Time of change: "..realtime.hour .. ":"..realtime.minute, tp)
end
addCommandHandler("eta", eta)

function etan(tp)
	 changeWeather()
	local timed = weatherStartTime + currentWeather[2]
	local realtime = getRealTime( timed - 3600  )
	outputChatBox("Time of change: "..realtime.hour .. ":"..realtime.minute, tp)
end
addCommandHandler("etanow", etan)

function generateWeatherTypes()
	return (math.random(1, #weatherStates) < #weatherStates / 1.5 and math.random(1, 2) or math.random(1, #weatherStates))
end

function generateRandomTime()
	return ((math.random(1, 6) == 1 and math.random(10, 26) or math.random(29, 120)) * 60) -- Generate time in seconds
end

addEvent( "weather:request", true )
addEventHandler( "weather:request", getRootElement( ),
	function( )
		triggerClientEvent(client or source, "weather:update", getRootElement(), currentWeather[3], false)
	end
)

function parseWeatherDetails(condition, humidity, temperature, wind, icon)
	if condition == "ERROR" then
		return
	elseif condition == nil then
		return
	else
		if w == 'sunny' or w == 'mostly sunny' or w == 'chance of storm' then
			setWeatherEx( 'sunny' )
		elseif w == 'partly cloudy' or w == 'mostly cloudy' or w == 'smoke' or w == 'cloudy' then
			setWeatherEx( 'clouds' )
		elseif w == 'showers' or w == 'rain' or w == 'chance of rain' then
			setWeatherEx( 'rainy' )
		elseif w == 'storm' or w == 'thunderstorm' or w == 'chance of tstorm' then
			setWeatherEx( 'stormy' )
		elseif w == 'fog' or w == 'icy' or w == 'snow' or w == 'chance of snow' or w == 'flurries' or w == 'sleet' or w == 'mist' then
			setWeatherEx( 'fog' )
		elseif w == 'dust' or w == 'haze' then
			setWeatherEx( 'dull' )
		end
	end
end

 setTimer( changeWeather, 5000, 1)