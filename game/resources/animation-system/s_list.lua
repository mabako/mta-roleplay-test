addEvent("AnimationSet",true)
addEventHandler("AnimationSet",getRootElement(), 
	function (block, ani, loop)
		if(source)then
			if(block)then
				if loop then
					setPedAnimation(source,block,ani,-1,loop)
				else
					setPedAnimation(source,block,ani,1,false)
				end
			else
				setPedAnimation(source)
			end
		end
	end)
	
addCommandHandler("anim",
	function (player, command, block, anim, loop)
		if(block and ani)then
			triggerEvent("AnimationSet",player, tostring(block),tostring(anim), tonumber(loop) == 1)
		else
			triggerEvent("AnimationSet",player)
		end
	end)
