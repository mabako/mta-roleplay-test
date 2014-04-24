function news_update( player )
    callRemote( newsURL,
		function( title, text, author, date )
			if title == "ERROR" then
				outputDebugString( "Fetching news failed: " .. text )
				if player then
					outputChatBox( "News failed: " .. text, player )
				end
			else
				exports['anticheat-system']:changeProtectedElementDataEx( resourceRoot, "news:title", title )
				exports['anticheat-system']:changeProtectedElementDataEx( resourceRoot, "news:text", text )
				exports['anticheat-system']:changeProtectedElementDataEx( resourceRoot, "news:sub", author .. " on " .. date )
				if player then
					outputChatBox( "News set to: " .. title, player )
				end
			end
		end
	)
end

-- Fetch news every so often
setTimer( news_update, 30 * 60000, 0 )

-- Initial update
news_update( )

addCommandHandler( "updatenews",
	function( player )
		if exports.global:isPlayerAdmin( player ) then
			news_update( player )
			outputChatBox( "Fetching news...", player )
		end
	end
)
