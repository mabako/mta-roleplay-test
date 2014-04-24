-- Shader Dynamic SKY v0.82 by Ren712
-- knoblauch700@o2.pl

local sphereObjScale={10.5,10.5,8.5} -- this is high enough 
local modelID=15057  -- that's probably the best model to replace ... or not
local roll=math.rad(25) -- Sun rotation angle
local yaw=math.rad(0) -- North point direction angle
local gClowdsAp=1 -- Max clouds alpha (in the main effect)
local enableIngameClouds = false -- Enable GTA clouds
local disableCloudTextures = false -- Disable smog/clouds textures
local isFogDisabled = false -- disable the effect distance fading
local getLastTick, getLastTack, getLastToe = 0,0,0

function startShaderResource()
if dsEffectEnabled then return end

 skybox_shader, technique = dxCreateShader ( "shaders/shader_skybox.fx",0,0,true,"object" )
 shader_clear = dxCreateShader ( "shaders/shader_clear.fx" )
 
 if not skybox_shader or not shader_clear then 
  outputChatBox('Could not start Dynamic sky shader!',255,0,0)
  return 
  else
  outputDebugString('Using technique '..technique)
 end
 textureClouds= dxCreateTexture ( "textures/clouds.png" )
 dxSetShaderValue ( skybox_shader, "sClouds", textureClouds )
 textureSkybox= dxCreateTexture ( "textures/skybox.dds" )
 dxSetShaderValue ( skybox_shader, "sSkyBox", textureSkybox )
 dxSetShaderValue ( skybox_shader, "gObjScale", sphereObjScale )
 dxSetShaderValue ( skybox_shader, "gClowdsAp", gClowdsAp )
 dxSetShaderValue ( skybox_shader, "isFogDisabled", isFogDisabled )
 -- apply to texture
 engineApplyShaderToWorldTexture ( skybox_shader, "skybox_tex" ) 
 if disableCloudTextures then
	engineApplyShaderToWorldTexture ( shader_clear, "cloudmasked" )
	end
 txd_skybox = engineLoadTXD('models/skybox_model.txd')
 engineImportTXD(txd_skybox, modelID)
 dff_skybox = engineLoadDFF('models/skybox_model.dff', modelID)
 engineReplaceModel(dff_skybox, modelID)  

 local cam_x,cam_y,cam_z = getElementPosition(getLocalPlayer())
 skyBoxBoxa = createObject ( modelID, cam_x, cam_y, cam_z, 0, 0, 0, true )
 setElementAlpha(skyBoxBoxa,1)
 setCloudsEnabled(enableIngameClouds)

addEventHandler ( "onClientHUDRender", getRootElement (), renderSphere ) -- sphere
addEventHandler ( "onClientHUDRender", getRootElement (), renderTime ) -- time
addEventHandler ( "onClientHUDRender", getRootElement (), renderSun ) -- sun and night cubebox rotation
renderWeather() -- chceck the weather on start
renderMoon() -- count the moon phase on client start
dsEffectEnabled = true
end

function stopShaderResource()
if not dsEffectEnabled then return end
removeEventHandler ( "onClientHUDRender", getRootElement (), renderSphere ) -- sphere
removeEventHandler ( "onClientHUDRender", getRootElement (), renderTime ) -- time
removeEventHandler ( "onClientHUDRender", getRootElement (), renderSun ) -- sun and night cubebox rotation
killTimer(wethTimer)
wethTimer=nil
engineRemoveShaderFromWorldTexture( skybox_shader, "skybox_tex" )
engineRemoveShaderFromWorldTexture( shader_clear, "cloudmasked" )
destroyElement(skyBoxBoxa)
destroyElement(skybox_shader)
destroyElement(textureClouds)
destroyElement(textureSkybox)
skybox_shader=nil
skyBoxBoxa=nil
textureClouds=nil
textureSkybox=nil
dsEffectEnabled = false
end

lastWeather=0
function renderSphere()
 -- Updates the position of the sphere object 
 if getTickCount ( ) - getLastToe < 2  then return end
 -- Set the skybox model position accordingly to the camera position
 local cam_x, cam_y, cam_z, lx, ly, lz = getCameraMatrix()
 setElementPosition ( skyBoxBoxa, cam_x, cam_y, cam_z ,false )
 dxSetShaderValue ( skybox_shader, "gZPos", cam_z )
 if getWeather()~=lastWeather then applyWeatherInfluence() end
 lastWeather=getWeather()
 getLastToe = getTickCount ()
end


moonTimeAspect=0
last_minute,second=0,0
function renderSun()
 local hour, minute = getTime ( )
 if getTickCount ( ) - getLastTick < 10  then return end
 if last_minute==minute  then second=second+(((getTickCount ( ) - getLastTick))*getGameSpeed()) else  second=0  end
 if second>1000 then second=1000 end 
 if not skybox_shader then return end
 local timeAspect=(((hour*60)+minute)+(second/900))/1440 
 zAngle=math.rad((timeAspect)*360)   
 local msCombine=timeAspect-moonTimeAspect
 if msCombine>1 then msCombine=msCombine-1 end
 if msCombine<0 then msCombine=msCombine+1 end
 mAngle=math.rad((msCombine)*360)
 dxSetShaderValue ( skybox_shader, "gRotate",roll,zAngle,yaw) 
 dxSetShaderValue ( skybox_shader, "mRotate",mAngle) 
 getLastTick = getTickCount ()
 last_minute=minute
end

function renderMoon()
 local texName="textures/moon/"..toint(getCurrentMoonPhase())..".png"
 local textureMoon= dxCreateTexture ( texName )
 dxSetShaderValue ( skybox_shader, "sMoon", textureMoon )
 moonTimeAspect=getCurrentMoonPhase()/20
end

function renderWeather()
applyWeatherInfluence()
wethTimer = setTimer ( function()
		applyWeatherInfluence()	
		end
		,1000,0)
end

function renderTime()
 local hour, minute = getTime ( )
 if getTickCount ( ) - getLastTack < 10  then return end
 if not skybox_shader then return end
 
 if hour <= 6 then
  dawn_aspect =((hour*60+minute))/360
  dxSetShaderValue ( skybox_shader, "gDayTime", dawn_aspect)
 end
	
 if hour > 6 and hour < 20 then
  dawn_aspect=1
  dxSetShaderValue ( skybox_shader, "gDayTime", 1)
 end
 
 if hour>=20  then
  dawn_aspect=-6*((((hour-20)*60)+minute)/1440)+1
  dxSetShaderValue ( skybox_shader, "gDayTime",dawn_aspect )
 end
 getLastTack = getTickCount ()
end

----------------------------------------------------------------
-- getWeatherInfluence
--		Modify shine depending on the weather
----------------------------------------------------------------
weatherInfluenceList = {
			-- id   sun:size    :bright      night:bright  effect:alpha  		:wind
			{  0,       1,		1,			0.01, 				1,					0		},		-- Hot, Sunny, Clear 	
			{  1,       0.8,	1.3,		0.8,				1,					0.13	},		-- Sunny, Low Clouds	
			{  2,       0.3,	2,			2, 					0,					0		},		-- Sunny, Clear				
			{  3,       0.8,	1,			0.9, 				1,					0.02	},		-- Sunny, Cloudy				
			{  4,       1,		1,			0.9, 				1,					0.06	},		-- Dark Clouds				
			{  5,       2,		0.8,		0, 					1,					0.02	},		-- Sunny, More Low Clouds	
			{  6,       2,		0.22,		0.22,				1,					0		},		-- Sunny, Even More Low Clouds	
			{  7,       1,		1.9,		2.05, 				1,					0.06	},		-- Cloudy Skies			
			{  8,       1,		0.7,		0.7, 				0,					0.50	},		-- Thunderstorm			
			{  9,       1,		2,			2, 					0,					0.2		},		-- Foggy			
			{  10,      1,		1.5,		1.5, 				1,					0.02	},		-- Sunny, Cloudy (2)		
			{  11,      2,		1.6,		1.6, 				1,					0		},		-- Hot, Sunny, Clear (2)		
			{  12,      2,		1.5,		1.5, 				1,					0.03	},		-- White, Cloudy		
			{  13,      1,		2.2,		2.2, 				1,					0		},		-- Sunny, Clear (2)		
			{  14,      1,		2.2,		2.2, 				1,					0.05	},		-- Sunny, Low Clouds (2)			
			{  15,      1,		1.7,		1.6, 				1,					0.03	},		-- Dark Clouds (2)		
			{  16,      0.5,	2,			2, 					0,					0.50	},		-- Thunderstorm (2)		
			{  17,      1,		1.5,		1, 					1,					0.02	}, 		-- Hot, Cloudy		
			{  18,      1,		1.5,		1, 					1,					0.08	},		-- Hot, Cloudy (2)		
			{  19,      1,		2,			2, 					0,					0.5		},		-- Sandstorm
		}

function lerp (a, b, t)
        return a + (b - a) * t
end		
	
function countTotalBright(x,y)

	local hour, minute = getTime ( )
	local timeAspect=4*(((hour*60)+minute)/1440)
	if timeAspect<=1 then timeAspect=math.pow(timeAspect,15) else
		if timeAspect>1 and timeAspect<3.33333 then timeAspect=1  else
			if timeAspect>=3.33333 then timeAspect=-6*((((hour-20)*60)+minute)/1440)+1 timeAspect=math.pow(timeAspect,1.5) end
			end
		end
	local totalBright=lerp(y,x,timeAspect)
	return totalBright
end

function applyWeatherInfluence()
	local id = getWeather()
	id = math.min ( id, #weatherInfluenceList - 1 )
	local item = weatherInfluenceList[ id + 1 ]
	local sunSize  = item[2]
	local sunBright = item[3]
	local nightBright = item[4]
	local effectAlpha = item[5]
	local windVelocity = item[6]
	totalBright=countTotalBright(sunBright,nightBright)
	local r1, g1, b1, r2, g2, b2 = getSkyGradient()
	local skyBott = {r2/255, g2/255, b2/255, 0}	
	dxSetShaderValue ( skybox_shader, "gSkyBott", skyBott )
	dxSetShaderValue ( skybox_shader, "gBrightSca", totalBright )
	dxSetShaderValue ( skybox_shader, "gSunSize", sunSize )
	dxSetShaderValue ( skybox_shader, "gAlpha", effectAlpha )
	dxSetShaderValue ( skybox_shader, "gXPos", windVelocity )
	setSunSize (0)
	setSunColor(0, 0, 0, 0, 0, 0)
end
