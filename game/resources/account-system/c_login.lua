addEventHandler("accounts:login:request", getRootElement(), 
	function ()
		setElementDimension ( getLocalPlayer(), 1 )
		setElementInterior( getLocalPlayer(), 0 )
		setCameraMatrix( 837.90606689453, -2066.2963867188, 16.712882995605, 0, -10000, 0)
		fadeCamera(true)
		guiSetInputEnabled(true)
		clearChat()
		LoginScreen_openLoginScreen()
	end
);

--[[ LoginScreen_openLoginScreen( ) - Open the login screen ]]--
local wLogin, lUsername, tUsername, lPassword, tPassword, chkRememberLogin, bLogin, bRegister, updateTimer = nil
function LoginScreen_openLoginScreen()
	local width, height = guiGetScreenSize()
	--wLogin = guiCreateWindow(0,0, width, height, "valhallaGaming - MTA Roleplay server", true)
	wLogin = nil
	--guiWindowSetSizable(wLogin, false)
	--guiWindowSetMovable(wLogin, false)
	lUsername = guiCreateLabel(width /6, height /4, 100, 50, "Username:", false, wLogin)
	guiSetFont(lUsername, "default-bold-small")
	
	tUsername = guiCreateEdit(width /4, height /4, 100, 17, "Username", false, wLogin)
	guiSetFont(tUsername, "default-bold-small")
	guiEditSetMaxLength(tUsername, 32)
	addEventHandler("onClientGUIAccepted", tUsername, LoginScreen_validateLogin, false)
	
	lPassword = guiCreateLabel(width /6, height /3.5, 100, 50, "Password:", false, wLogin)
	guiSetFont(lPassword, "default-bold-small")
	
	tPassword = guiCreateEdit(width /4, height /3.5, 100, 17, "Password", false, wLogin)
	guiSetFont(tPassword, "default-bold-small")
	guiEditSetMasked(tPassword, true)
	guiEditSetMaxLength(tPassword, 64)
	addEventHandler("onClientGUIAccepted", tPassword, LoginScreen_validateLogin, false)
	
	chkRememberLogin = guiCreateCheckBox(width /5, height /3.2, 175, 17, "Remember My Details", false, false, wLogin)
	guiSetFont(chkRememberLogin, "default-bold-small")
	
	bLogin = guiCreateButton(width /6, height /2.9, 75, 17, "Login", false, wLogin)
	guiSetFont(bLogin, "default-bold-small")
	addEventHandler("onClientGUIClick", bLogin, LoginScreen_validateLogin, false)
	
	bRegister = guiCreateButton(width /4, height /2.9, 75, 17, "Register", false, wLogin)
	guiSetFont(bRegister, "default-bold-small")
	addEventHandler("onClientGUIClick", bRegister, LoginScreen_startRegister, false)
	
	guiSetText(tUsername, tostring( loadSavedData("username", "") ))
	local tHash = tostring( loadSavedData("hashcode", "") )
	guiSetText(tPassword,  tHash)
	if #tHash > 1 then
		guiCheckBoxSetSelected(chkRememberLogin, true)
	end
	addEventHandler( "onClientRender", getRootElement(), LoginScreen_RunFX )
	updateTimer = setTimer(LoginScreen_RefreshIMG, 7500, 0)
	triggerEvent("accounts:options:settings:updated", getLocalPlayer())
end

local screenX, screenY = guiGetScreenSize()

local alphaAction = 3
local alphaStep = 50


local screenX, screenY = guiGetScreenSize()
local alphaAction = 3
local alphaStep = 50

local totalslides = 6
local currentslide = math.random(1, totalslides)

function LoginScreen_RunFX()
	dxDrawRectangle(0, 0, screenX, screenY, tocolor(0, 0, 0, 150), false)
    dxDrawText( "Welcome at the Valhalla Gaming MTA:Role play server", screenX/2 - 300, screenY/10, 300, 200, tocolor ( 255, 255, 255, 255 ), 2, "default-bold" )
    dxDrawText( "Please login to start playing on our server!", screenX/6, screenY/4.9, screenX, screenY, tocolor ( 255, 255, 255, 255 ), 1, "default-bold" ) 
	alphaStep = alphaStep + alphaAction
	if (alphaStep > 200) or (alphaStep < 50) then
		alphaAction = alphaAction - alphaAction - alphaAction
	end
	 
	-- Left side
	local startX, startY = screenX/15, screenY/2
	local endX = screenX/2.3 - 15
	dxDrawText( "News and such.. ", startX, startY, 2000, 2000, tocolor ( 255, 255, 255, 255 ), 1.5, "default-bold" )
	startY = startY + 40
	dxDrawText( getElementData(resourceRoot, "news:title") or "None :(", startX, startY, endX, startY + 30,  tocolor ( 255, 255, 255, 255 ), 1.2, "default-bold", "center", "top", true, false )
	startY = startY + 16
	dxDrawText( getElementData(resourceRoot, "news:sub") or "", startX, startY, endX, startY + 30, tocolor( 255, 255, 255, 200), 1, "default-bold", "center", "top", true, false )
	startY = startY + 20
	dxDrawText(getElementData(resourceRoot, "news:text") or "", startX, startY, endX, screenY,  tocolor ( 255, 255, 255, 255 ), 1, "default-bold", "left", "top", true, true )
	
	-- Right side
	local startX, startY = screenX/2.3, screenY/5
	dxDrawText( "Welcome in this world,", startX, startY, 2000, 2000, tocolor ( 255, 255, 255, 255 ), 1.3, "default-bold" )
	startY = startY + 20
	dxDrawText( "the valhalla of role play.", startX+150, startY, 2000, 2000,  tocolor ( 255, 255, 255, 255 ), 1.5, "default-bold" )
	startY = startY + 50

	dxDrawText( "Valhalla Gaming MTA Role Play is a role play gaming server using the Multi Theft Auto\nmultiplayer modification for Grand Theft Auto: San Andreas. Originally started in January\nof 2008 as MTA:RP the server has grown to 110,000+ lines of code.\n\nIf you're new here, you should know a few things. First of all, you need an account to\n play at our server. You can get one at our website, www.mta.vg and look at the right side.\nWe are aiming for an as real as possible enviorment to roleplay in, thusfar we have\nsome rules that everyone need to stick to. You can view those rules by going to our\nsite, http://mta.vg or pressing F1 ingame.\n\nIf you require any assistance in our server, hit F2 and ask your question straight away. Also\nthere it's possible to report another player if he or she doesn't follow the rules.\n\nWe hope that you have a good time at our server.\n\n- Valhalla Gaming MTA Team", startX, startY, screenX-startX, screenY-startY,  tocolor ( 255, 255, 255, 255 ), 1, "default-bold" )

	-- Upper right
	dxDrawImage(screenX - 140, 10, 131, 120, "img/valhalla1.png", 0, 0, 0, tocolor(255, 255, 255, alphaStep), false)
	dxDrawText("Version "..scriptVersion, screenX - 130, 130, 20, 120, tocolor ( 255, 255, 255, 150 ), 1, "default-bold" )
	
	-- Banner down
	dxDrawImage(startX, 500, 542, 214, "banners/".. tostring(currentslide) ..".png", 0, 0, 0, tocolor(255, 255, 255, 200), false)
end

function LoginScreen_RefreshIMG()
	currentslide =  currentslide + 1
	if currentslide > totalslides then
		currentslide = 1
	end
end

function LoginScreen_startRegister()
	LoginScreen_showWarningMessage( "You can register an account\nat http://mta.vg!" )
end

--[[ LoginScreen_closeLoginScreen() - Close the loginscreen ]]
function LoginScreen_closeLoginScreen()
	destroyElement(lUsername)
	destroyElement(tUsername)
	destroyElement(lPassword)
	destroyElement(tPassword)
	destroyElement(chkRememberLogin)
	destroyElement(bLogin)
	destroyElement(bRegister)
	--destroyElement(wLogin)
	killTimer(updateTimer)
	removeEventHandler( "onClientRender", getRootElement(), LoginScreen_RunFX )
end

--[[ LoginScreen_validateLogin() - Used to validate and send the contents of the login screen  ]]--
function LoginScreen_validateLogin()
	local username = guiGetText(tUsername)
	local password = guiGetText(tPassword)
	
	guiSetText(tPassword, "")
	appendSavedData("hashcode", "")
	
	if (string.len(username)<3) then
		outputChatBox("Your username is too short. You must enter 3 or more characters.", 255, 0, 0)
	else
		local saveInfo = guiCheckBoxGetSelected(chkRememberLogin)
		triggerServerEvent("accounts:login:attempt", getLocalPlayer(), username, password, saveInfo) 
					
		if (saveInfo) then
			appendSavedData("username", tostring(username))
		else
			appendSavedData("username", "")
		end
		
	end
end

local warningBox, warningMessage, warningOk = nil
function LoginScreen_showWarningMessage( message )

	if (isElement(warningBox)) then
		destroyElement(warningBox)
	end
	
	local x, y = guiGetScreenSize()
	warningBox = guiCreateWindow( x*.5-150, y*.5-65, 300, 120, "Attention!", false )
	guiWindowSetSizable( warningBox, false )
	warningMessage = guiCreateLabel( 40, 30, 220, 60, message, false, warningBox )
	guiLabelSetHorizontalAlign( warningMessage, "center", true )
	guiLabelSetVerticalAlign( warningMessage, "center" )
	warningOk = guiCreateButton( 130, 90, 70, 20, "Ok", false, warningBox )
	addEventHandler( "onClientGUIClick", warningOk, function() destroyElement(warningBox) end )
	guiBringToFront( warningBox )
end

addEventHandler("accounts:login:attempt", getRootElement(), 
	function (statusCode, additionalData)
		
		if (statusCode == 0) then
			LoginScreen_closeLoginScreen()
			
			if (isElement(warningBox)) then
				destroyElement(warningBox)
			end
			
			-- Succesful login
			for _, theValue in ipairs(additionalData) do
				setElementData(getLocalPlayer(), theValue[1], theValue[2], false)
			end
			
			local newAccountHash = getElementData(getLocalPlayer(), "account:newAccountHash")
			appendSavedData("hashcode", newAccountHash or "")
			
			local characterList = getElementData(getLocalPlayer(), "account:characters")
			
			if #characterList == 0 then
				newCharacter_init()
			else
				Characters_showSelection()
			end
			
		elseif (statusCode > 0) and (statusCode < 5) then
			LoginScreen_showWarningMessage( additionalData )
		elseif (statusCode == 5) then
			LoginScreen_showWarningMessage( additionalData )
			-- TODO: show make app screen?
		end
	end
)