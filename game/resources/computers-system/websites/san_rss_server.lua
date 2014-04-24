rssItems = {}
function initRSS()
	updateFeed()
end
addEventHandler("onResourceStart",getResourceRootElement(getThisResource()),initRSS)

function updateFeed() -- Request an updated feed
	callRemote("http://jwvd.me/san/sanrss.php",feedReceived)
end
setTimer(updateFeed,3600000,0) -- Update the feed every hour

function feedReceived(items) -- Feed request completed
	if items ~= "ERROR" then
        rssItems = items
    end
end

function feedRequested() -- Client requested a feed, send the feed to the client
	triggerClientEvent(source,"sanReceiveFeed",getRootElement(),rssItems)
end
addEvent("sanRequestFeed",true)
addEventHandler("sanRequestFeed",getRootElement(),feedRequested)