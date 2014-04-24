-- Displaying the increase in skill
local sx, sy, text, count, addedEvent, alpha
local langInc = 0

function increaseInSkill(language)
	local localPlayer = getLocalPlayer()
	
	local x, y, z = getPedBonePosition(localPlayer, 6)
	sx, sy = getScreenFromWorldPosition(x, y, z+0.2, 100, false)
	
	langInc = langInc + 1
	
	text = "+" .. langInc .. " " .. languages[language] .. " (" .. string.gsub(getPlayerName(source), "_", " ") .. ")"
	
	count = 0
	alpha = 255
	if not (addedEvent) then
		addedEvent = true
		addEventHandler("onClientRender", getRootElement(), renderText)
	end
end
addEvent("increaseInSkill", true)
addEventHandler("increaseInSkill", getRootElement(), increaseInSkill)

function renderText()
	if not sx or not sy then return end
	count = count + 1
	dxDrawText(text, sx-150, sy, sx+200, sy+50, tocolor(255, 255, 255, alpha), 1, "diploma", "center", "center")
	
	sy = sy - 3
	alpha = alpha - 6
	
	if (alpha<0) then alpha = 0 end
	
	if (count>50) then
		removeEventHandler("onClientRender", getRootElement(), renderText)
		addedEvent = false
		langInc = 0
	end
end

tlanguages = nil
currslot = nil
wLanguages = nil
bUnlearnLang1, bUse1, bUnlearnLang2, bUse2, bUnlearnLang3, bUse3 = nil
localPlayer = getLocalPlayer()
function displayGUI(remotelanguages, rcurrslot)
	if not (wLanguages) then
		local width, height = 600, 400
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)
		
		wLanguages = guiCreateWindow(x, y, width, height, "Languages: " .. string.gsub(getPlayerName(localPlayer), "_", " "), false)
		
		tlanguages = remotelanguages
		currslot = tonumber(rcurrslot)

		local offset = 0.06
		-- LANGUAGE 1
		if (tlanguages[1]~=nil) then
			local lang1 = tlanguages[1][1]
			local lang1skill = tlanguages[1][2]
			local imgLang1 = guiCreateStaticImage(0.05, 0.1+offset, 0.025, 0.025, ":social-system/images/flags/" .. flags[lang1] .. ".png", true, wLanguages)
			local lLang1Name = guiCreateLabel(0.1, 0.092+offset, 0.9, 0.1, languages[lang1], true, wLanguages)
			guiSetFont(lLang1Name, "default-bold-small")
			
			local pLang1Skill = guiCreateProgressBar(0.1, 0.14+offset, 0.6, 0.05, true, wLanguages)
			guiProgressBarSetProgress(pLang1Skill, lang1skill)
			
			local lLang1Skill = guiCreateLabel(0.73, 0.14+offset, 0.2, 0.1, lang1skill .. "/100", true, wLanguages)
			guiSetFont(lLang1Skill, "default-bold-small")
			
			bUse1 = guiCreateButton(0.83, 0.08+offset, 0.2, 0.05, "Use", true, wLanguages)
			bUnlearnLang1 = guiCreateButton(0.83, 0.14+offset, 0.2, 0.05, "Un-learn", true, wLanguages)
			addEventHandler("onClientGUIClick", bUnlearnLang1, unlearnLanguage, false)
			addEventHandler("onClientGUIClick", bUse1, useLanguage, false)
			offset = offset + 0.3
			
			if (currslot==1) then
				guiSetText(lLang1Name, languages[lang1] .. " (Current)")
				guiSetVisible(bUse1, false)
			end
		end
		
		-- LANGUAGE 2
		if (tlanguages[2]~=nil) then
			local lang2 = tlanguages[2][1]
			local lang2skill = tlanguages[2][2]
			local imgLang2 = guiCreateStaticImage(0.05, 0.1+offset, 0.025, 0.025, ":social-system/images/flags/" .. flags[lang2] .. ".png", true, wLanguages)
			local lLang2Name = guiCreateLabel(0.1, 0.092+offset, 0.9, 0.1, languages[lang2], true, wLanguages)
			guiSetFont(lLang2Name, "default-bold-small")
			
			local pLang2Skill = guiCreateProgressBar(0.1, 0.14+offset, 0.6, 0.05, true, wLanguages)
			guiProgressBarSetProgress(pLang2Skill, lang2skill)
			
			local lLang2Skill = guiCreateLabel(0.73, 0.14+offset, 0.2, 0.1, lang2skill .. "/100", true, wLanguages)
			guiSetFont(lLang2Skill, "default-bold-small")
			
			bUse2 = guiCreateButton(0.83, 0.08+offset, 0.2, 0.05, "Use", true, wLanguages)
			bUnlearnLang2 = guiCreateButton(0.83, 0.14+offset, 0.2, 0.05, "Un-learn", true, wLanguages)
			addEventHandler("onClientGUIClick", bUnlearnLang2, unlearnLanguage, false)
			addEventHandler("onClientGUIClick", bUse2, useLanguage, false)
			offset = offset + 0.3
			
			if (currslot==2) then
				guiSetText(lLang2Name, languages[lang2] .. " (Current)")
				guiSetVisible(bUse2, false)
			end
		end
		
		-- LANGUAGE 3
		if (tlanguages[3]~=nil) then
			local lang3 = tlanguages[3][1]
			local lang3skill = tlanguages[3][2] or 0
			local imgLang3 = guiCreateStaticImage(0.05, 0.1+offset, 0.025, 0.025, ":social-system/images/flags/" .. flags[lang3] .. ".png", true, wLanguages)
			local lLang3Name = guiCreateLabel(0.1, 0.092+offset, 0.9, 0.1, languages[lang3], true, wLanguages)
			guiSetFont(lLang3Name, "default-bold-small")
			
			local pLang3Skill = guiCreateProgressBar(0.1, 0.14+offset, 0.6, 0.05, true, wLanguages)
			guiProgressBarSetProgress(pLang3Skill, lang3skill)
			
			local lLang3Skill = guiCreateLabel(0.73, 0.14+offset, 0.2, 0.1, lang3skill .. "/100", true, wLanguages)
			guiSetFont(lLang3Skill, "default-bold-small")
			
			bUse3 = guiCreateButton(0.83, 0.08+offset, 0.2, 0.05, "Use", true, wLanguages)
			bUnlearnLang3 = guiCreateButton(0.83, 0.14+offset, 0.2, 0.05, "Un-learn", true, wLanguages)
			addEventHandler("onClientGUIClick", bUnlearnLang3, unlearnLanguage, false)
			addEventHandler("onClientGUIClick", bUse3, useLanguage, false)
			
			if (currslot==3) then
				guiSetText(lLang3Name, languages[lang3] .. " (Current)")
				guiSetVisible(bUse3, false)
			end
		end
		showCursor(true)
		local bClose = guiCreateButton(0.05, 0.92, 0.9, 0.07, "Close", true, wLanguages)
		addEventHandler("onClientGUIClick", bClose, hideGUI, false)
	else
		guiSetInputEnabled(false)
		hideGUI()
	end
end
addEvent("showLanguages", true)
addEventHandler("showLanguages", getLocalPlayer(), displayGUI)

function useLanguage(button, state)
	if (button=="left") then
		local lang = 0
		
		if (source==bUse1) then lang = tlanguages[1][1] end
		if (source==bUse2) then lang = tlanguages[2][1] end
		if (source==bUse3) then lang = tlanguages[3][1] end

		if (lang>0) then
			hideGUI()
			triggerServerEvent("useLanguage", localPlayer, lang)
		end
	end
end

function unlearnLanguage(button, state)
	if (button=="left") then
		local lang = 0
		
		if (source==bUnlearnLang1) then lang = tlanguages[1][1] end
		if (source==bUnlearnLang2) then lang = tlanguages[2][1] end
		if (source==bUnlearnLang3) then lang = tlanguages[3][1] end

		if (source==bUnlearnLang1 and bUnlearnLang2==nil and  bUnlearnLang3==nil) then
			outputChatBox("You must know atleast one language.", 255, 0, 0)
			return
		elseif (source==bUnlearnLang2 and bUnlearnLang1==nil and  bUnlearnLang3==nil) then
			outputChatBox("You must know atleast one language.", 255, 0, 0)
			return
		elseif (source==bUnlearnLang3 and bUnlearnLang1==nil and  bUnlearnLang2==nil) then
			outputChatBox("You must know atleast one language.", 255, 0, 0)
			return
		end
		
		if lang > 0 then
			local sx, sy = guiGetScreenSize() 
			wConfirmUnlearn = guiCreateWindow(sx/2 - 125,sy/2 - 50,250,100,"Leaving Confirmation", false)
			local lQuestion = guiCreateLabel(0.05,0.25,0.9,0.3,"Do you really want to forget all your knowledge of " .. getLanguageName( lang ) .. "?",true,wConfirmUnlearn)
			guiLabelSetHorizontalAlign (lQuestion,"center",true)
			local bYes = guiCreateButton(0.1,0.65,0.37,0.23,"Yes",true,wConfirmUnlearn)
			local bNo = guiCreateButton(0.53,0.65,0.37,0.23,"No",true,wConfirmUnlearn)
			addEventHandler("onClientGUIClick", getRootElement(), 
				function(button)
					if button=="left" and ( source == bYes or source == bNo ) then
						if source == bYes then
							hideGUI()
							triggerServerEvent("unlearnLanguage", localPlayer, lang)
						end
						if wConfirmUnlearn then
							destroyElement(wConfirmUnlearn)
							wConfirmUnlearn = nil
						end
					end
				end
			)
		end
	end
end

function hideGUI()
	if (wLanguages) then
		destroyElement(wLanguages)
	end
	wLanguages = nil
	
	if wConfirmUnlearn then
		destroyElement(wConfirmUnlearn)
	end
	wConfirmUnlearn = nil
	
	bUnlearnLang1 = nil
	bUnlearnLang2 = nil
	bUnlearnLang3 = nil
	
	showCursor(false)
	
end