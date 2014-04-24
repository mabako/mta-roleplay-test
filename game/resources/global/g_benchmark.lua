local benches = { }

function startBenchMark()
	local benchID = #benches + 1
	benches[ benchID ] = getTickCount()
	return benchID
end

function endBenchMark( benchID )
	if (benches[ benchID] ) then
		return  getTickCount() - benches[ benchID]
	end
	return -1
end