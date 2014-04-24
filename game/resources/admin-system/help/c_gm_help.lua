local myadminWindow = nil

function gmhelp (commandName)

	local sourcePlayer = getLocalPlayer()
	if exports.global:isPlayerGameMaster(sourcePlayer) or exports.global:isPlayerAdmin(sourcePlayer) then
		if (myadminWindow == nil) then
			guiSetInputEnabled(true)
			local screenx, screeny = guiGetScreenSize()
			myadminWindow = guiCreateWindow ((screenx-700)/2, (screeny-500)/2, 700, 500, "Index of GM commands", false)
			local tabPanel = guiCreateTabPanel (0, 0.1, 1, 1, true, myadminWindow)
			local lists = {}
			for level = 1, 5 do 
				local tab = guiCreateTab("Level " .. level, tabPanel)
				lists[level] = guiCreateGridList(0.02, 0.02, 0.96, 0.96, true, tab) -- commands for level one admins 
				guiGridListAddColumn (lists[level], "Command", 0.15)
				guiGridListAddColumn (lists[level], "Syntax", 0.35)
				guiGridListAddColumn (lists[level], "Explanation", 1.3)
			end
			local tlBackButton = guiCreateButton(0.8, 0.05, 0.2, 0.07, "Close", true, myadminWindow) -- close button
			
			local commands =
			{
				-- level -1: Trainee GM
				{
					-- player/*
					{ "/gmlounge", "/gmlounge", "Teleports you to the GM lounge." },
					{ "/g", "/g [Text]", "Talk in GM chat for communication with admins." },
					{ "/ar", "/ar [Report ID]", "Accept a report." },
					{ "/cr", "/cr [Report ID]", "Close a report." },
					{ "/dr", "/dr [Report ID]", "Drop a report, leaving it unanswered." },
					{ "/fr", "/fr [Report ID]", "Mark a report false" },
					{ "/gmduty", "/gmduty", "Toggles GM duty (On/off)" },
					{ "/goto", "/goto [player]", "Teleport to a player's location." },
					{ "/gotoplace", "/gotoplace [LV/SF/LS/ASH/BANK/IGS/PC]", "Teleport to a pre-determined place." },
					{ "/mark", "/mark [Mark name]", "Create a mark for you to teleport to (doing /mark without a name will create a temporary one)" },
					{ "/gotomark", "/gotomark [Mark Name]", "Teleport to a pre-made mark (/gotomark without a mark name teleports to a temporary one)" },
					{ "/resetcontract", "/resetcontract [Player]", "Resets the hours limit for the person" }
				},
				-- level -2: Game Master
				{
					{ "/freeze", "/freeze [Player]", "Freeze a player." },
					{ "/unfreeze", "/unfreeze [Player]", "Unfreeze a frozen player." },
					{ "/gethere", "/gethere [Player]", "Teleports a player to your location." },
					{ "/togpm", "/togpm", "Disables your pm's." }

					
				},
				-- level -3: Senior GameMaster
				{
					{ "/nearbyvehicles", "/nearbyvehicles", "Checks near by vehicles, their owners and ID's" },
					{ "/respawnveh", "/respawnveh [ID]", "Respawns a vehicle." },
					{ "/forceapp", "/forceapp [Player] [Reason]", "Sets the player back in the application stage." },
				},
				{ -- level 4 gms
				   { "/recon", "/recon [player]", "recons the specified player" },
				   { "/stoprecon", "/stoprecon", "incase recon bugs out" },
				},
				{ -- level 5 gms
					{ "/makeadmin", "/makeadmin [player] [rank]", "gives the player an gm rank" },
				}
			
			}
			
			for level, levelcmds in pairs( commands ) do
				if #levelcmds == 0 then
					local row = guiGridListAddRow ( lists[level] )
					guiGridListSetItemText ( lists[level], row, 1, "-", false, false)
					guiGridListSetItemText ( lists[level], row, 2, "-", false, false)
					guiGridListSetItemText ( lists[level], row, 3, "There are currently no commands specific to this level.", false, false)
				else
					for _, command in pairs( levelcmds ) do
						local row = guiGridListAddRow ( lists[level] )
						guiGridListSetItemText ( lists[level], row, 1, command[1], false, false)
						guiGridListSetItemText ( lists[level], row, 2, command[2], false, false)
						guiGridListSetItemText ( lists[level], row, 3, command[3], false, false)
					end
				end
			end
			
			addEventHandler ("onClientGUIClick", tlBackButton, function(button, state)
				if (button == "left") then
					if (state == "up") then
						guiSetVisible(myadminWindow, false)
						showCursor (false)
						guiSetInputEnabled(false)
						myadminWindow = nil
					end
				end
			end, false)
			
			guiBringToFront (tlBackButton)
			guiSetVisible (myadminWindow, true)
		else
			local visible = guiGetVisible (myadminWindow)
			if (visible == false) then
				guiSetVisible( myadminWindow, true)
				showCursor (true)
			else
				showCursor(false)
			end
		end
	end
end
addCommandHandler("gh", gmhelp)