// shader_skybox.fx
// Shader Dynamic sky v0.82
// Author: Ren712/AngerMAN

texture sSkyBox;
texture sClouds;
texture sMoon;


float gDayTime=0;
float gClowdsAp=1;
float gAlpha=0;
float gZPos=0;
float gXPos=0;
float gSunSize=0;
float gBrightSca=1;
float3 sunColor=float3(1,1,0.5);
float4 gSkyBott = float4(1,0,0,1);
float3 gObjScale=(1,1,1);
float3 gRotate=(0,0,0);
float mRotate=0;
float3 sTexStretch=(0,0,0);
float sFadeStart = 235;          // Near point where distance fading will start
float sFadeEnd = 302;            // Far point where distance fading will complete (i.e. effect will not be visible past this point)
bool isFogDisabled = false;
//-- Include some common stuff
 
#include "mta-helper.fx"

//---------------------------------------------------------------------
//-- Sampler for the main texture (needed for pixel shaders)
//---------------------------------------------------------------------

samplerCUBE envMapSky = sampler_state
{
    Texture = (sSkyBox);
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    MIPMAPLODBIAS = 0.000000;
};

sampler cloudMap = sampler_state
{
    Texture = (sClouds);
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
    AddressW = Wrap;
};

sampler moonMap = sampler_state
{
    Texture = (sMoon);
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU =  Clamp;
    AddressV =  Clamp;
    AddressW =  Clamp;
};


//---------------------------------------------------------------------
//-- Structure of data sent to the vertex shader
//--------------------------------------------------------------------- 
 
 struct VSInput
{
    float4 Position : POSITION; 
    float3 TexCoord : TEXCOORD0;
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
};

//---------------------------------------------------------------------
//-- Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------

struct PSInput
{
    float4 Position : POSITION; 
    float3 TexCoord : TEXCOORD0;
    float3 NormalPos : TEXCOORD1;
    float2 TexCooFla : TEXCOORD2;
    float3 PosUnchan : TEXCOORD3;
    float3 NormalPosM : TEXCOORD4;
    float DistFade : TEXCOORD5;
    float2 Cycle : TEXCOORD6;
    float4 Diffuse : COLOR0;	
};

float3x3 eulRotate(float3 Rotate)
{
    float cosX,sinX;
    float cosY,sinY;
    float cosZ,sinZ;

    sincos(Rotate.x,sinX,cosX);
    sincos(-Rotate.y,sinY,cosY);
    sincos(Rotate.z,sinZ,cosZ);

//Euler extrinsic rotations 
//http://www.vectoralgebra.info/eulermatrix.html


		float3x3 rot = float3x3(
		cosY * cosZ + sinX * sinY * sinZ, -cosX * sinZ,  sinX * cosY * sinZ - sinY * cosZ,
		cosY * sinZ - sinX * sinY * cosZ,  cosX * cosZ, -sinY * sinZ - sinX * cosY * cosZ,
		cosX * sinY,                       sinX,         cosX * cosY
	);

return rot;	
}
	
//-----------------------------------------------------------------------------
//-- VertexShader
//-----------------------------------------------------------------------------
PSInput VertexShaderSB(VSInput VS)
{
    PSInput PS = (PSInput)0;
    float4 origPosition = float4(100*VS.Position.xyz,VS.Position.w);
	float2 xyPropMult=10*gObjScale.xy*(1+float2(gBrightSca,gBrightSca));
    VS.Position.xy*=xyPropMult;
    VS.Position.z*=10*gObjScale.z*(1+gBrightSca/1.3);
    PS.Position = mul(VS.Position, gWorldViewProjection);
    PS.TexCooFla=VS.TexCoord.xyz; 

    // compute the 4x4 tranform from tangent space to object space
    float4 worldPos = mul(VS.Position, gWorld);
    // compute the eye vector 
    float4 eyeVector = worldPos - gViewInverse[3]; 			
	
    PS.TexCoord.xyz  = mul(eulRotate(gRotate), eyeVector.xyz);
    PS.PosUnchan = VS.Position.xyz;
    PS.NormalPos = mul(eulRotate(gRotate), VS.Position.xyz);
    PS.NormalPosM = mul(eulRotate(float3(gRotate.x,mRotate,gRotate.z)), VS.Position.xyz);
    PS.Diffuse = MTACalcGTABuildingDiffuse( VS.Diffuse ); 
     // Distance fade calculation
	 
    worldPos = mul(origPosition, gWorld);   
    float DistanceFromCamera = distance( float3(worldPos.xy,1), float3(gCameraPosition.xy,1) );
    PS.DistFade = MTAUnlerp ( sFadeEnd, sFadeStart, DistanceFromCamera );
    if (worldPos.z<gCameraPosition.z) PS.DistFade = 0;
    if (isFogDisabled) PS.DistFade = 1;
    PS.Cycle = float2(fmod(gTime*(gXPos/15), 100.0), fmod(-(gZPos/500), 100.0));
    return PS;
}
 
//-----------------------------------------------------------------------------
//-- PixelShader
//-----------------------------------------------------------------------------

float4 PixelShaderSB(PSInput PS) : COLOR0
{	
    float heightPos=1;
    float4 NightBox = texCUBE(envMapSky, PS.TexCoord.xzy);
	
    float4 clouds = tex2D(cloudMap, PS.TexCooFla.xy * 2.0 + PS.Cycle);
	
    float3 NormalPos=normalize(PS.NormalPos);
    float3 NormalPosM=normalize(PS.NormalPosM);
	
    float4 moon = tex2D(moonMap,(float3(NormalPosM.x,-NormalPosM.y,NormalPosM.z)*5));
    moon.rgb=pow(moon.rgb,1.5);
	
    float3 Sun = normalize(float3(0,0,-1));
    float SunDot = dot(Sun, NormalPos)*(1.0+(0.0025*gSunSize));	
    float sunAura = dot(Sun, NormalPos);
    float3 PosUnchan=normalize(PS.PosUnchan);
    float ClearCloudsUP=pow(dot(float3(0,0,1), PosUnchan),2.5);

    clouds.rgba*=1-saturate(ClearCloudsUP);
	
    vector rays = 0.7 * pow( max(0.0, SunDot), 60 );
    rays.rgb*=sunColor;
    vector light = 0.8 * pow( max(0.0001, SunDot), 360 );
    float moonAura  = saturate(40*pow(max(0,dot(Sun, NormalPosM)),80));
	
    light.rgb*=sunColor;

    float4 MoonSky=moon*moonAura;
    float4 NightSky=float4(lerp(NightBox.rgb,MoonSky.rgb,MoonSky.a),NightBox.a);
	
    float4 background=lerp(NightSky,float4(0,0,0,0.9),gDayTime);
    clouds.rgba*=gClowdsAp;
   // background.rgb*=saturate(1-0.75*clouds.a);

    clouds.rgb*=saturate(0.1+gDayTime)*gClowdsAp;
    float4 outPut=saturate(background+clouds+rays+light);
    outPut.a*=gAlpha;
    float fadeAp=saturate(PS.DistFade+rays.a);
    outPut=lerp(gSkyBott,outPut,fadeAp);
    return outPut;
}


////////////////////////////////////////////////////////////
//////////////////////////////// TECHNIQUES ////////////////
////////////////////////////////////////////////////////////
technique dynamicSky_v082
{
    pass P0
    {
       DepthBias = -0.0003;
       AlphaRef = 1;
       AlphaBlendEnable = TRUE;
       VertexShader = compile vs_2_0 VertexShaderSB();
       PixelShader = compile ps_2_0 PixelShaderSB();
    }
}
