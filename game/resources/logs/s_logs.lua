enumTypes = {
	"chat",
	"ads",
	"adminchat",
	"admincmds",
	"moneytransfers",
	"faction",
	"meactions",
	"pms",
	"vehicles",
	"san-photo",
	"kills",
	"anticheat",
	"itemspawn",
	"tow",
	"setfaction",
	"changelock",
	"moveitems",
	"news",
	"do",
	"tv",
	"adminlock",
	"weaponspawn",
	"moneyspawn",
	"sqlqueries",
	"stevie",
	"connect",
	"connectdangerous",
	"takeguns",
	"elementdata",
	"factionactions",
	"account-chars",
	"valhallashield",
	"radio"
}

local lastLogType = -1
local lastData = ""
local lastLogsource = getRootElement()

-- Log prefixes
-- ac	AccountID
-- ch	CharacterID
-- ve	Vehicle
-- fa	Faction
-- in	Interior
-- ph	Phone

-- Action ID's
-- 1 Admin chat /h			x
-- 2 Admin chat /l			x
-- 3 Admin chat /a			x
-- 4 Admin command
-- 5 Anticheat
-- 6 Vehicle related things
-- 7 Player /say			x
-- 8 Player /b				x
-- 9 Player /r				x
-- 10 Player /d				x
-- 11 Player /f				x
-- 12 Player /me's			x
-- 13 Player /destrict's		x
-- 14 Player /do's			x
-- 15 Player /pm's			x
-- 16 Player /gov			x
-- 17 Player /don			x
-- 18 Player /o				x
-- 19 Player /s				x
-- 20 Player /m				x
-- 21 Player /w				x
-- 22 Player /c				x
-- 23 Player /n				x
-- 24 Gamemaster chat /g	x
-- 25 Cash transfer			x
-- 26 vPoints				x
-- 27 Connection			x			
-- 28 Roadblocks			x		
-- 29 Phone logs			x	
-- 30 SMS logs				x
-- 31 Int/Vehicle actions (locking/unlocking)x			
-- 32 UCP logs
-- 33 Stattransfers			x
-- 34 Kill logs/Lost items	x
-- 35 Faction actions		x
-- 36 Ammunation			x
-- 37 Selling logs			x
function dbLog(logSource, actionID, affected, data)
	lastLogType = actionID
	lastData = data
	lastLogsource = logSource
	
	-- Check the source
	if logSource == nil then 
		outputDebugString("logs:dbLog: No logSource on "..tostring(actionID))
		return false
	end
	
	local sourceStr = dbLogDetectTypeSource(logSource)
	if sourceStr == false then
		outputDebugString("logs:dbLog: No sourceStr on"..tostring(actionID))
		return false
	end
	
	-- Check the action
	if actionID == nil then
		outputDebugString("logs:dbLog: No actionID")
		return false
	end
	if not tonumber(actionID) then
		outputDebugString("logs:dbLog: actionID is not numeric")
		return false
	end
	local actionStr = tostring(actionID)
	
	-- check affected people
	if affected == nil then 
		outputDebugString("logs:dbLog: No affected")
		return false
	end
	local affectedStr = dbLogDetectTypeSource(affected)
	if affectedStr == false then
		outputDebugString("logs:dbLog: No affectedStr")
		return false 
	end
	affectedStr = affectedStr .. ";"
	
	-- Check data
	if not data then
		data = "N/A"
	end
	
	local r = getRealTime()
	local timeString = ("%04d-%02d-%02d %02d:%02d:%02d"):format(r.year+1900, r.month + 1, r.monthday, r.hour,r.minute, r.second)
	exports.mysql:lazyQuery("INSERT INTO `logtable` VALUES ('"..timeString.."', '".. exports.mysql:escape_string(actionStr) .."', '".. exports.mysql:escape_string(sourceStr).."', '".. exports.mysql:escape_string(affectedStr).."', '".. exports.mysql:escape_string(data).."')")
	return true
end

function dbLogDetectTypeSource( theElement )
	local sourceType = type(theElement)
	if sourceType == 'string' then
		return theElement
	elseif sourceType == 'userdata' then -- an Element
		local possibleResult = getElementLogID( theElement )
		if not possibleResult then
			outputDebugString("logs:dbLog: Unknown element theElement on "..tostring(lastLogType) .. ":"..tostring(lastLogsource))
			outputDebugString(tostring(data))
			return
		end
		return possibleResult
	elseif sourceType == 'table' then
		local returnStr = ''
		for _, tableValue in pairs( theElement ) do
			local tableValueResult = dbLogDetectTypeSource(tableValue)
			if tableValueResult then
				if returnStr ~= '' then
					returnStr = returnStr .. ";" .. tableValueResult 
				else
					returnStr = tableValueResult 
				end
			end
		end
		if returnStr ~= '' then
			return returnStr
		end
	end
	return false
end

function getElementLogID( theElement )
	if isElement(theElement) then
		local elementType = getElementType(theElement)
		if (elementType == 'player') then
			local dbid = getElementData(theElement, "dbid")
			if dbid then
				return "ch".. tostring(dbid)
			end
		elseif (elementType == 'vehicle') then
			local dbid = getElementData(theElement, "dbid")
			if dbid then
				return "ve".. tostring(dbid)
			end
		elseif (elementType == 'team') then
			local dbid = getElementData(theElement, "id")
			if dbid then
				return "fa".. tostring(dbid)
			end
		elseif (elementType == 'ped') then
			local dbid = getElementData(theElement, "ped:type")
			if dbid then
				return "pe".. tostring(dbid)
			end
		elseif (elementType == 'interior') then
			local dbid = getElementData(theElement, "dbid")
			if dbid then
				return "in".. tostring(dbid)
			end
		else
			outputDebugString("Log type mismatch: " .. getElementType(theElement))
		end
	end
	return false
end

function logMessage(message, type)
	local filename = nil
	local r = getRealTime()
	local partialname = enumTypes[type]

	if (partialname == nil) then return end

	if partialname == "valhallashield" or partialname == "elementdata" or partialname == "admincmds" or partialname == "moneyspawn" or partialname == "weaponspawn" or partialname == "sqlqueries" or partialname == "stevie" or partialname == "connect" or partialname == "connectdangerous" then
		filename = "/hiddenlogs/" .. partialname .. ".log"
	else
		filename = "/logs/" .. partialname .. ".log"
	end
	
	
	local file = createFileIfNotExists(filename)
	local size = fileGetSize(file)
	fileSetPos(file, size)
	fileWrite(file, "[" .. ("%04d-%02d-%02d %02d:%02d"):format(r.year+1900, r.month + 1, r.monthday, r.hour,r.minute) .. "] " .. message .. "\r\n")
	fileFlush(file)
	fileClose(file)
	
	return true
end

function createFileIfNotExists(filename)
	local file = fileOpen(filename)
	
	if not (file) then
		file = fileCreate(filename)
	end
	
	return file
end