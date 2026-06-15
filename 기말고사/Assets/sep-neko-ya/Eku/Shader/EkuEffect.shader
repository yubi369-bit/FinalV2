// Made with Amplify Shader Editor v1.9.9.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "sepnekoya/EkuEffect"
{
	Properties
	{
		_Intensity( "Intensity", Range( 0, 10 ) ) = 1
		[Toggle( _ENABLECUSTOMDATAINTENSITY_ON )] _EnableCustomDataIntensity( "Enable CustomData Intensity", Float ) = 0
		[HDR] _MainColor( "Main Color", Color ) = ( 1, 1, 1, 1 )
		_MainMap( "Main Map", 2D ) = "white" {}
		_MainMapTiling( "Main Map Tiling", Vector ) = ( 1, 1, 0, 0 )
		_MainMapScroll( "Main Map Scroll", Vector ) = ( 0, 0, 0, 0 )
		[Toggle( _ENABLEDISSOLVE_ON )] _EnableDissolve( "Enable Dissolve", Float ) = 0
		_DissolveMap( "Dissolve Map", 2D ) = "white" {}
		_DissolveTiling( "Dissolve Tiling", Vector ) = ( 1, 1, 0, 0 )
		_DissolveScroll( "Dissolve Scroll", Vector ) = ( 0, 0, 0, 0 )
		[Toggle( _ENABLECUSTOMDATADISSOLVE_ON )] _EnableCustomDataDissolve( "Enable CustomData Dissolve", Float ) = 0
		_Threshold( "Threshold", Range( 0, 1 ) ) = 0.16
		[HDR] _EdgeColor( "Edge Color", Color ) = ( 1, 0, 0, 1 )
		_EdgeWidth( "Edge Width", Range( 0, 1 ) ) = 0.03
		_EdgeSmoothness( "Edge Smoothness", Range( 0, 0.2 ) ) = 0.05
		[Toggle( _ENABLEDISSOLVEFLOW_ON )] _EnableDissolveFlow( "Enable Dissolve Flow", Float ) = 0
		_DissolveFlowMap( "Dissolve Flow Map", 2D ) = "white" {}
		_DissolveFlowTiling( "Dissolve Flow Tiling", Vector ) = ( 1, 1, 0, 0 )
		_DissolveFlowScroll( "Dissolve Flow Scroll", Vector ) = ( 0, 0, 0, 0 )
		_DissolveFlowIntensity( "Dissolve Flow Intensity", Range( 0, 1 ) ) = 0.5
		[Toggle( _ENABLEFRESNEL_ON )] _EnableFresnel( "Enable Fresnel", Float ) = 0
		_FresnelWidth( "Fresnel Width", Float ) = 3
		_FresnelIntensity( "FresnelIntensity", Float ) = 1
		[Toggle( _FRESNELINVERSE_ON )] _FresnelInverse( "Fresnel Inverse", Float ) = 0
		[Toggle( _ENABLEDIRECTIONALDISSOLVE_ON )] _EnableDirectionalDissolve( "Enable Directional Dissolve", Float ) = 0
		[Toggle( _ISCUSTOMDATADIRECTDISSOLVE_ON )] _isCustomDataDirectDissolve( "isCustomDataDirectDissolve", Float ) = 0
		[KeywordEnum( U,OneMinusU,V,OneMinusV )] _UVMode( "UV Mode", Float ) = 0
		_DirectDissolveWidth( "DirectDissolveWidth", Range( 0.3, 1 ) ) = 1
		[Toggle( _ISDIRECTPOLAR_ON )] _isDirectPolar( "isDirectPolar", Float ) = 0
		_DirectDissolveTex( "DirectDissolve Tex", 2D ) = "white" {}
		_DirectDissolveTiling( "DirectDissolve Tiling", Vector ) = ( 1, 1, 0, 0 )
		_DirectDissolvePanning( "DirectDissolve Panning", Vector ) = ( 0, 0, 0, 0 )
		_DirectDissolveThreshold( "DirectDissolveThreshold", Range( 0, 1 ) ) = 0
		[HDR] _DirectDissolveEdgeColor( "DirectDissolveEdgeColor", Color ) = ( 1, 1, 1, 1 )
		_DirectDissolveEdgeWidth( "DirectDissolveEdgeWidth", Range( 0, 0.4 ) ) = 0.1
		[Toggle( _ENABLECAMERAFADE_ON )] _EnableCameraFade( "Enable CameraFade", Float ) = 0
		_FadeStart( "Fade Start", Range( 0, 2 ) ) = 1
		_FadeEnd( "Fade End", Range( 0, 5 ) ) = 3
		[Toggle( _ENABLEUVFADE_ON )] _EnableUVFade( "Enable UV Fade", Float ) = 0
		_TopFadePos( "Top Fade Pos", Range( 0, 2 ) ) = 0
		_TopFadeWidth( "Top Fade Width", Range( 0, 10 ) ) = 1
		_BottomFadePos( "Bottom Fade Pos", Range( 0, 2 ) ) = 0
		_BottomFadeWidth( "Bottom Fade Width", Range( 0, 10 ) ) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend( "SrcBlend", Float ) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend( "DstBlend", Float ) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		

		Tags { "RenderType"="Transparent" "Queue"="Transparent" "VRCFallback"="Hidden" }

	LOD 0

		

		Blend [_SrcBlend] [_DstBlend]
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		Offset 0 , 0
		

		CGINCLUDE
			#pragma target 3.5

			float4 ComputeClipSpacePosition( float2 screenPosNorm, float deviceDepth )
			{
				float4 positionCS = float4( screenPosNorm * 2.0 - 1.0, deviceDepth, 1.0 );
			#if UNITY_UV_STARTS_AT_TOP
				positionCS.y = -positionCS.y;
			#endif
				return positionCS;
			}
		ENDCG

		
		Pass
		{
			Name "Unlit"

			CGPROGRAM
				#define ASE_VERSION 19903

				#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
					#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
				#endif
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_instancing
				#include "UnityCG.cginc"

				#include "UnityShaderVariables.cginc"
				#define ASE_NEEDS_TEXTURE_COORDINATES1
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES1
				#define ASE_NEEDS_TEXTURE_COORDINATES0
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0
				#define ASE_NEEDS_TEXTURE_COORDINATES2
				#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES2
				#define ASE_NEEDS_FRAG_COLOR
				#pragma shader_feature_local _ENABLECUSTOMDATAINTENSITY_ON
				#pragma shader_feature_local _ENABLEFRESNEL_ON
				#pragma shader_feature_local _FRESNELINVERSE_ON
				#pragma shader_feature_local _ENABLEUVFADE_ON
				#pragma shader_feature_local _ENABLECAMERAFADE_ON
				#pragma shader_feature_local _ENABLEDISSOLVE_ON
				#pragma shader_feature_local _ENABLECUSTOMDATADISSOLVE_ON
				#pragma shader_feature_local _ENABLEDISSOLVEFLOW_ON
				#pragma shader_feature_local _ENABLEDIRECTIONALDISSOLVE_ON
				#pragma shader_feature_local _UVMODE_U _UVMODE_ONEMINUSU _UVMODE_V _UVMODE_ONEMINUSV
				#pragma shader_feature_local _ISDIRECTPOLAR_ON
				#pragma shader_feature_local _ISCUSTOMDATADIRECTDISSOLVE_ON


				struct appdata
				{
					float4 vertex : POSITION;
					float4 ase_texcoord1 : TEXCOORD1;
					float3 ase_normal : NORMAL;
					float4 ase_texcoord : TEXCOORD0;
					float4 ase_texcoord2 : TEXCOORD2;
					float4 ase_color : COLOR;
					UNITY_VERTEX_INPUT_INSTANCE_ID
				};

				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 ase_texcoord : TEXCOORD0;
					float4 ase_texcoord1 : TEXCOORD1;
					float4 ase_texcoord2 : TEXCOORD2;
					float4 ase_texcoord3 : TEXCOORD3;
					float4 ase_texcoord4 : TEXCOORD4;
					float4 ase_color : COLOR;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};

				uniform float _SrcBlend;
				uniform float _DstBlend;
				uniform float _Intensity;
				uniform float4 _MainColor;
				uniform float _FresnelWidth;
				uniform float _FresnelIntensity;
				uniform float _BottomFadePos;
				uniform float _BottomFadeWidth;
				uniform float _TopFadePos;
				uniform float _TopFadeWidth;
				uniform float _FadeStart;
				uniform float _FadeEnd;
				uniform float _Threshold;
				uniform float _EdgeSmoothness;
				uniform sampler2D _DissolveMap;
				uniform float2 _DissolveScroll;
				uniform float2 _DissolveTiling;
				uniform sampler2D _DissolveFlowMap;
				uniform float2 _DissolveFlowScroll;
				uniform float2 _DissolveFlowTiling;
				uniform float _DissolveFlowIntensity;
				uniform float _DirectDissolveWidth;
				uniform float _DirectDissolveThreshold;
				uniform sampler2D _DirectDissolveTex;
				uniform float2 _DirectDissolvePanning;
				uniform float2 _DirectDissolveTiling;
				uniform float _DirectDissolveEdgeWidth;
				uniform float4 _DirectDissolveEdgeColor;
				uniform float _EdgeWidth;
				uniform float4 _EdgeColor;
				uniform sampler2D _MainMap;
				uniform float2 _MainMapScroll;
				uniform float2 _MainMapTiling;
				uniform float4 _MainMap_ST;


				
				v2f vert ( appdata v )
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID( v );
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
					UNITY_TRANSFER_INSTANCE_ID( v, o );

					float3 ase_positionWS = mul( unity_ObjectToWorld, float4( ( v.vertex ).xyz, 1 ) ).xyz;
					o.ase_texcoord1.xyz = ase_positionWS;
					float3 ase_normalWS = UnityObjectToWorldNormal( v.ase_normal );
					o.ase_texcoord2.xyz = ase_normalWS;
					
					o.ase_texcoord = v.ase_texcoord1;
					o.ase_texcoord3.xy = v.ase_texcoord.xy;
					o.ase_texcoord4 = v.ase_texcoord2;
					o.ase_color = v.ase_color;
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord1.w = 0;
					o.ase_texcoord2.w = 0;
					o.ase_texcoord3.zw = 0;

					float3 vertexValue = float3( 0, 0, 0 );
					#if ASE_ABSOLUTE_VERTEX_POS
						vertexValue = v.vertex.xyz;
					#endif
					vertexValue = vertexValue;
					#if ASE_ABSOLUTE_VERTEX_POS
						v.vertex.xyz = vertexValue;
					#else
						v.vertex.xyz += vertexValue;
					#endif

					o.pos = UnityObjectToClipPos( v.vertex );
					return o;
				}

				half4 frag( v2f IN  ) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID( IN );
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );
					half4 finalColor;

					float4 ScreenPosNorm = float4( IN.pos.xy * ( _ScreenParams.zw - 1.0 ), IN.pos.zw );
					float4 ClipPos = ComputeClipSpacePosition( ScreenPosNorm.xy, IN.pos.z ) * IN.pos.w;
					float4 ScreenPos = ComputeScreenPos( ClipPos );

					#ifdef _ENABLECUSTOMDATAINTENSITY_ON
					float staticSwitch130 = IN.ase_texcoord.xy.x;
					#else
					float staticSwitch130 = 1.0;
					#endif
					float3 ase_positionWS = IN.ase_texcoord1.xyz;
					float3 ase_viewVectorWS = ( _WorldSpaceCameraPos.xyz - ase_positionWS );
					float3 ase_viewDirWS = normalize( ase_viewVectorWS );
					float3 normalizeResult158 = normalize( ase_viewDirWS );
					float3 ase_normalWS = IN.ase_texcoord2.xyz;
					float3 normalizedWorldNormal = normalize( ase_normalWS );
					float dotResult113 = dot( normalizeResult158 , normalizedWorldNormal );
					float temp_output_114_0 = abs( dotResult113 );
					#ifdef _FRESNELINVERSE_ON
					float staticSwitch116 = temp_output_114_0;
					#else
					float staticSwitch116 = ( 1.0 - temp_output_114_0 );
					#endif
					#ifdef _ENABLEFRESNEL_ON
					float staticSwitch124 = max( ( pow( staticSwitch116 , _FresnelWidth ) * _FresnelIntensity ) , 0.0 );
					#else
					float staticSwitch124 = 1.0;
					#endif
					float fresnel122 = staticSwitch124;
					float2 texCoord284 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
					#ifdef _ENABLEUVFADE_ON
					float staticSwitch301 = saturate( ( ( saturate( ( ( texCoord284.y - _BottomFadePos ) * _BottomFadeWidth ) ) * saturate( ( ( ( 1.0 - texCoord284.y ) - _TopFadePos ) * _TopFadeWidth ) ) ) * 3.0 ) );
					#else
					float staticSwitch301 = 1.0;
					#endif
					float UV_Fade302 = staticSwitch301;
					float smoothstepResult276 = smoothstep( _FadeStart , _FadeEnd , distance( _WorldSpaceCameraPos , ase_positionWS ));
					#ifdef _ENABLECAMERAFADE_ON
					float staticSwitch278 = smoothstepResult276;
					#else
					float staticSwitch278 = 1.0;
					#endif
					float cameraFade279 = staticSwitch278;
					#ifdef _ENABLECUSTOMDATADISSOLVE_ON
					float staticSwitch45 = IN.ase_texcoord.y;
					#else
					float staticSwitch45 =  (-1.0 + ( _Threshold - 0.0 ) * ( 1.0 - -1.0 ) / ( 1.0 - 0.0 ) );
					#endif
					float StableRandom_X91 = IN.ase_texcoord4.x;
					float StableRandom_Y92 = IN.ase_texcoord4.y;
					float2 appendResult89 = (float2(StableRandom_X91 , StableRandom_Y92));
					float2 texCoord15 = IN.ase_texcoord3.xy * _DissolveTiling + appendResult89;
					float2 panner17 = ( 1.0 * _Time.y * _DissolveScroll + texCoord15);
					float2 DissolveUV18 = panner17;
					float2 appendResult70 = (float2(StableRandom_X91 , StableRandom_Y92));
					float2 texCoord75 = IN.ase_texcoord3.xy * _DissolveFlowTiling + appendResult70;
					float2 panner76 = ( 1.0 * _Time.y * _DissolveFlowScroll + texCoord75);
					float3 lerpResult83 = lerp( float3( DissolveUV18 ,  0.0 ) , tex2D( _DissolveFlowMap, panner76 ).rgb , _DissolveFlowIntensity);
					#ifdef _ENABLEDISSOLVEFLOW_ON
					float3 staticSwitch85 = lerpResult83;
					#else
					float3 staticSwitch85 = float3( DissolveUV18 ,  0.0 );
					#endif
					float3 Flowed_Dissolve_UV84 = staticSwitch85;
					float4 tex2DNode46 = tex2D( _DissolveMap, Flowed_Dissolve_UV84.xy );
					float smoothstepResult137 = smoothstep( ( staticSwitch45 - _EdgeSmoothness ) , ( staticSwitch45 + _EdgeSmoothness ) , tex2DNode46.r);
					#ifdef _ENABLEDISSOLVE_ON
					float staticSwitch126 = smoothstepResult137;
					#else
					float staticSwitch126 = 1.0;
					#endif
					float dissolve58 = staticSwitch126;
					float2 texCoord194 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
					float2 temp_output_34_0_g9 = ( IN.ase_texcoord3.xy - float2( 0.5,0.5 ) );
					float2 break39_g9 = temp_output_34_0_g9;
					float2 appendResult50_g9 = (float2(( 1.0 * ( length( temp_output_34_0_g9 ) * 2.0 ) ) , ( ( atan2( break39_g9.x , break39_g9.y ) * ( 1.0 / 6.28318548202515 ) ) * 1.0 )));
					#ifdef _ISDIRECTPOLAR_ON
					float2 staticSwitch205 = appendResult50_g9;
					#else
					float2 staticSwitch205 = texCoord194;
					#endif
					float2 break214 = staticSwitch205;
					#if defined( _UVMODE_U )
					float staticSwitch229 = ( 1.0 - break214.x );
					#elif defined( _UVMODE_ONEMINUSU )
					float staticSwitch229 = break214.x;
					#elif defined( _UVMODE_V )
					float staticSwitch229 = ( 1.0 - break214.y );
					#elif defined( _UVMODE_ONEMINUSV )
					float staticSwitch229 = break214.y;
					#else
					float staticSwitch229 = ( 1.0 - break214.x );
					#endif
					float DirectionalDissolveUV236 = staticSwitch229;
					#ifdef _ISCUSTOMDATADIRECTDISSOLVE_ON
					float staticSwitch217 = IN.ase_texcoord.z;
					#else
					float staticSwitch217 =  (-3.0 + ( _DirectDissolveThreshold - 0.0 ) * ( 3.0 - -3.0 ) / ( 1.0 - 0.0 ) );
					#endif
					float DirectDissolveThreshold226 = staticSwitch217;
					float temp_output_240_0 = ( -1.0 * DirectDissolveThreshold226 );
					float temp_output_257_0 = ( ( _DirectDissolveWidth * DirectionalDissolveUV236 ) + temp_output_240_0 );
					float2 appendResult211 = (float2(StableRandom_X91 , StableRandom_Y92));
					float2 texCoord216 = IN.ase_texcoord3.xy * _DirectDissolveTiling + appendResult211;
					float2 panner224 = ( 1.0 * _Time.y * _DirectDissolvePanning + texCoord216);
					float DirectionalDissolveNoise244 = tex2D( _DirectDissolveTex, panner224 ).r;
					#ifdef _ENABLEDIRECTIONALDISSOLVE_ON
					float staticSwitch262 = step( 0.5 , ( ( temp_output_257_0 * DirectionalDissolveNoise244 ) + temp_output_257_0 ) );
					#else
					float staticSwitch262 = 1.0;
					#endif
					float DirectionalDissolve261 = staticSwitch262;
					float3 temp_cast_3 = (0.0).xxx;
					float temp_output_247_0 = ( ( temp_output_240_0 + ( -1.0 * _DirectDissolveEdgeWidth ) ) + ( _DirectDissolveWidth * DirectionalDissolveUV236 ) );
					#ifdef _ENABLEDIRECTIONALDISSOLVE_ON
					float3 staticSwitch264 = ( ( 1.0 - step( 0.5 , ( ( temp_output_247_0 * DirectionalDissolveNoise244 ) + temp_output_247_0 ) ) ) * _DirectDissolveEdgeColor.rgb );
					#else
					float3 staticSwitch264 = temp_cast_3;
					#endif
					float3 DirectionalDissolveEdge254 = staticSwitch264;
					float3 temp_cast_4 = (0.0).xxx;
					#ifdef _ENABLEDISSOLVE_ON
					float3 staticSwitch125 = ( ( ( 1.0 - step( (  (0.0 + ( _EdgeWidth - 0.0 ) * ( 0.1 - 0.0 ) / ( 1.0 - 0.0 ) ) + staticSwitch45 ) , tex2DNode46.r ) ) * _EdgeColor.rgb ) * 5.0 );
					#else
					float3 staticSwitch125 = temp_cast_4;
					#endif
					float3 dissolveEdge55 = staticSwitch125;
					float2 texCoord95 = IN.ase_texcoord3.xy * _MainMapTiling + float2( 0,0 );
					float2 panner98 = ( 1.0 * _Time.y * _MainMapScroll + texCoord95);
					float3 appendResult147 = (float3(IN.ase_color.r , IN.ase_color.g , IN.ase_color.b));
					float2 uv_MainMap = IN.ase_texcoord3.xy * _MainMap_ST.xy + _MainMap_ST.zw;
					float4 appendResult148 = (float4(( _Intensity * ( staticSwitch130 * ( ( ( _MainColor.rgb * ( ( fresnel122 * ( UV_Fade302 * ( cameraFade279 * ( dissolve58 * ( DirectionalDissolve261 * ( DirectionalDissolveEdge254 + ( dissolveEdge55 + 1.0 ) ) ) ) ) ) ) * tex2D( _MainMap, panner98 ).rgb ) ) * appendResult147 ) * IN.ase_color.a ) ) ) , ( saturate( dissolve58 ) * saturate( fresnel122 ) * IN.ase_color.a * tex2D( _MainMap, uv_MainMap ).r * cameraFade279 * UV_Fade302 )));
					

					finalColor = appendResult148;

					return finalColor;
				}
			ENDCG
		}
	}
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
	
	Fallback "Mobile/Particles/Alpha Blended"
}
/*ASEBEGIN
Version=19903
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;93;-5120,1920;Inherit;False;708;243;Comment;1;90;StableRandom;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;159;-5120,3408;Inherit;False;5847.534;3366.703;Comment;50;261;260;259;258;257;256;255;254;253;252;251;250;249;248;247;246;245;244;243;242;241;240;238;236;235;232;230;229;226;224;222;221;217;216;214;211;210;205;204;203;197;195;194;193;181;180;262;263;264;265;Directional Dissolve;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;90;-5072,1984;Inherit;False;2;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;193;-4960,4768;Inherit;False;Polar Coordinates;-1;;9;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;3;FLOAT2;0;FLOAT;55;FLOAT;56
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;194;-4944,4608;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;92;-4656,2064;Inherit;False;StableRandom Y;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;91;-4656,1984;Inherit;False;StableRandom X;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;205;-4624,4656;Inherit;False;Property;_isDirectPolar;isDirectPolar;28;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;88;-5136,592;Inherit;False;91;StableRandom X;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;87;-5136,688;Inherit;False;92;StableRandom Y;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;69;-5088,1424;Inherit;False;91;StableRandom X;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;65;-5088,1520;Inherit;False;92;StableRandom Y;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;181;-1056,4928;Inherit;False;Property;_DirectDissolveThreshold;DirectDissolveThreshold;32;0;Create;True;0;0;0;False;0;False;0;-0.4;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;204;-4160,3680;Inherit;False;91;StableRandom X;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;203;-4160,3760;Inherit;False;92;StableRandom Y;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;214;-4192,4656;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;230;-2208,4176;Inherit;False;Property;_DirectDissolveEdgeWidth;DirectDissolveEdgeWidth;34;0;Create;True;0;0;0;False;0;False;0.1;0;0;0.4;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;89;-4848,592;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;12;-4960,432;Inherit;False;Property;_DissolveTiling;Dissolve Tiling;8;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;70;-4800,1424;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;73;-4912,1616;Inherit;False;Property;_DissolveFlowTiling;Dissolve Flow Tiling;17;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TFHCRemapNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;195;-736,4928;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-3;False;4;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;197;-752,5120;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;211;-3888,3696;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;221;-4000,4576;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;222;-4000,4752;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;180;-4064,3504;Inherit;False;Property;_DirectDissolveTiling;DirectDissolve Tiling;30;0;Create;True;0;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;39;-4302,-126;Inherit;False;Property;_EdgeWidth;Edge Width;13;0;Create;True;0;0;0;False;0;False;0.03;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;238;-1872,4160;Inherit;False;2;2;0;FLOAT;-1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;241;-2112,4432;Inherit;False;236;DirectionalDissolveUV;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;15;-4640,464;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;10;-4624,608;Inherit;False;Property;_DissolveScroll;Dissolve Scroll;9;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;75;-4560,1376;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;66;-4560,1616;Inherit;False;Property;_DissolveFlowScroll;Dissolve Flow Scroll;18;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;217;-160,5104;Inherit;False;Property;_isCustomDataDirectDissolve;isCustomDataDirectDissolve;25;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;216;-3584,3488;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;229;-3760,4592;Inherit;False;Property;_UVMode;UV Mode;26;0;Create;True;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;4;U;OneMinusU;V;OneMinusV;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;210;-3632,3664;Inherit;False;Property;_DirectDissolvePanning;DirectDissolve Panning;31;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TFHCRemapNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;44;-3998,-126;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;243;-1600,4128;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;245;-1616,4288;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;17;-4320,464;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;76;-4272,1376;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;226;192,5104;Inherit;False;DirectDissolveThreshold;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;224;-3312,3488;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;236;-3504,4592;Inherit;False;DirectionalDissolveUV;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;48;-3758,18;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;247;-1408,4256;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;18;-4064,464;Inherit;False;DissolveUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;79;-3984,1312;Inherit;True;Property;_DissolveFlowMap;Dissolve Flow Map;16;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;81;-3568,1472;Inherit;False;Property;_DissolveFlowIntensity;Dissolve Flow Intensity;19;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;235;-2272,3968;Inherit;False;226;DirectDissolveThreshold;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;232;-3040,3472;Inherit;True;Property;_DirectDissolveTex;DirectDissolve Tex;29;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;242;-2032,3712;Inherit;False;Property;_DirectDissolveWidth;DirectDissolveWidth;27;0;Create;True;0;0;0;False;0;False;1;0;0.3;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;110;-5120,2336;Inherit;False;3400.765;906.061;Comment;1;111;Fresnel;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;142;-2972.702,27.70737;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;248;-1184,3984;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;255;-2016,3824;Inherit;False;236;DirectionalDissolveUV;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;283;-1152,2048;Inherit;False;2372;707;Comment;19;302;301;300;299;298;297;296;295;294;293;292;291;290;289;288;287;286;285;284;UV Fade;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;82;-3456,1088;Inherit;False;18;DissolveUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;83;-3184,1264;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;240;-1904,3936;Inherit;False;2;2;0;FLOAT;-1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;244;-2672,3520;Inherit;False;DirectionalDissolveNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;111;-4992,2592;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;50;-2718,18;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;51;-2750,114;Inherit;False;Property;_EdgeColor;Edge Color;12;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,1;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;249;-992,4096;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;256;-1648,3792;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;284;-1104,2096;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;29;-5008,-112;Inherit;False;Property;_Threshold;Threshold;11;0;Create;True;0;0;0;False;0;False;0.16;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;85;-2848,1248;Inherit;False;Property;_EnableDissolveFlow;Enable Dissolve Flow;15;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;60;-5136,-192;Inherit;False;3844.88;1046.743;Comment;1;34;Dissolve;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;246;-1728,3600;Inherit;False;244;DirectionalDissolveNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;112;-4832,2768;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;158;-4752,2592;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;52;-2494,18;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;53;-2286,146;Inherit;False;Constant;_Float2;Float 2;22;0;Create;True;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;250;-800,4080;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;257;-1472,3792;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;285;-896,2448;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;286;-1008,2272;Inherit;False;Property;_BottomFadePos;Bottom Fade Pos;41;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;287;-992,2560;Inherit;False;Property;_TopFadePos;Top Fade Pos;39;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;35;-4688,-112;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;84;-2480,1248;Inherit;False;Flowed Dissolve UV;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;34;-4544,128;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;113;-4528,2592;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;54;-2126,18;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;128;-2103.685,-88.18533;Inherit;False;Constant;_Float1;Float 1;21;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;251;-608,4080;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;252;-912,4272;Inherit;False;Property;_DirectDissolveEdgeColor;DirectDissolveEdgeColor;33;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0,1,0.9696944,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;258;-1232,3664;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;288;-624,2448;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;289;-768,2640;Inherit;False;Property;_TopFadeWidth;Top Fade Width;40;0;Create;True;0;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;290;-656,2144;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;291;-720,2352;Inherit;False;Property;_BottomFadeWidth;Bottom Fade Width;42;0;Create;True;0;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;45;-4158,82;Inherit;False;Property;_EnableCustomDataDissolve;Enable CustomData Dissolve;10;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;42;-3776,480;Inherit;False;84;Flowed Dissolve UV;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;114;-4240,2592;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;140;-3808,304;Inherit;False;Property;_EdgeSmoothness;Edge Smoothness;14;0;Create;True;0;0;0;False;0;False;0.05;0;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;125;-1872,0;Inherit;False;Property;_EnableDissolve;Enable Dissolve;6;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;253;-400,4080;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;259;-1024,3776;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;265;-416,3952;Inherit;False;Constant;_Float7;Float 7;36;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;270;-1168,1264;Inherit;False;1608.401;643.5182;Comment;9;279;278;277;276;275;274;273;272;271;Camera Fade;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;292;-384,2144;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;293;-384,2448;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;46;-3502,450;Inherit;True;Property;_DissolveMap;Dissolve Map;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;115;-4016,2416;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;139;-3344,352;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;138;-3376,240;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;55;-1600,16;Inherit;False;dissolveEdge;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;260;-800,3744;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;109;-1168,-192;Inherit;False;5258.996;1378.466;Comment;44;0;148;306;149;307;101;305;282;156;155;153;151;157;130;152;150;132;103;131;99;147;100;106;134;144;94;303;123;98;304;280;95;97;281;107;96;268;108;269;266;267;104;105;143;Main;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;263;-768,3568;Inherit;False;Constant;_Float6;Float 6;36;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;264;-144,4064;Inherit;False;Property;_Keyword1;Keyword 1;24;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;262;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;271;-1120,1312;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;272;-1072,1520;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;294;-128,2144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;295;-128,2448;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;116;-3776,2560;Inherit;False;Property;_FresnelInverse;Fresnel Inverse;23;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;117;-3808,2848;Inherit;False;Property;_FresnelWidth;Fresnel Width;21;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;127;-2752,320;Inherit;False;Constant;_Float0;Float 0;21;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;137;-2960,496;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;262;-512,3728;Inherit;False;Property;_EnableDirectionalDissolve;Enable Directional Dissolve;24;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;254;256,4064;Inherit;False;DirectionalDissolveEdge;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;143;-1104,224;Inherit;False;Constant;_Float5;Float 5;23;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;105;-1136,80;Inherit;False;55;dissolveEdge;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DistanceOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;273;-736,1392;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;274;-720,1552;Inherit;False;Property;_FadeStart;Fade Start;36;0;Create;True;0;0;0;False;0;False;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;275;-720,1648;Inherit;False;Property;_FadeEnd;Fade End;37;0;Create;True;0;0;0;False;0;False;3;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;296;96,2288;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;297;144,2512;Inherit;False;Constant;_Float9;Float 9;41;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;118;-3488,2560;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;4.98;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;119;-3424,2816;Inherit;False;Property;_FresnelIntensity;FresnelIntensity;22;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;126;-2512,400;Inherit;False;Property;_Keyword0;Keyword 0;6;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;125;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;261;-240,3744;Inherit;False;DirectionalDissolve;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;104;-880,208;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;267;-1104,-48;Inherit;False;254;DirectionalDissolveEdge;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;276;-384,1408;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;277;-368,1328;Inherit;False;Constant;_Float8;Float 1;15;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;298;368,2288;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;120;-3168,2560;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;58;-2240,400;Inherit;False;dissolve;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;266;-736,192;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;269;-992,-128;Inherit;False;261;DirectionalDissolve;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;299;528,2288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;300;512,2192;Inherit;False;Constant;_Float10;Float 10;42;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;278;-128,1392;Inherit;False;Property;_EnableCameraFade;Enable CameraFade;35;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;121;-2944,2560;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;129;-2880,2448;Inherit;False;Constant;_Float3;Float 3;21;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;108;-640,-16;Inherit;False;58;dissolve;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;268;-608,192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;279;192,1392;Inherit;False;cameraFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;301;704,2272;Inherit;False;Property;_EnableUVFade;Enable UV Fade;38;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;124;-2640,2560;Inherit;False;Property;_EnableFresnel;Enable Fresnel;20;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;107;-448,192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;281;-384,16;Inherit;False;279;cameraFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;302;976,2288;Inherit;False;UV Fade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;96;-384,544;Inherit;False;Property;_MainMapTiling;Main Map Tiling;4;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;122;-2368,2560;Inherit;False;fresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;280;-192,176;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;304;-176,16;Inherit;False;302;UV Fade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;97;-256,752;Inherit;False;Property;_MainMapScroll;Main Map Scroll;5;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;95;-176,528;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;123;272,-16;Inherit;False;122;fresnel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;303;48,176;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;98;64,528;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;144;448,192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;94;544,512;Inherit;True;Property;_MainMap;Main Map;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.VertexColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;134;944,400;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;100;864,-80;Inherit;False;Property;_MainColor;Main Color;2;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;106;1008,192;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;147;1152,384;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;99;1216,176;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;131;1248,-144;Inherit;False;Constant;_Float4;Float 4;22;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;103;1136,-48;Inherit;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;132;1424,176;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;150;1536,320;Inherit;False;58;dissolve;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;152;1536,400;Inherit;False;122;fresnel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;130;1424,-48;Inherit;False;Property;_EnableCustomDataIntensity;Enable CustomData Intensity;1;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;157;1600,176;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;151;1760,320;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;153;1760,400;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;155;1536,496;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;156;1440,672;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;94;Auto;Texture2D;False;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;282;1536,880;Inherit;False;279;cameraFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;305;1536,976;Inherit;False;302;UV Fade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;101;1872,160;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;307;1824,16;Inherit;False;Property;_Intensity;Intensity;0;0;Create;True;0;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;149;1952,320;Inherit;False;6;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;306;2080,160;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;145;-816,-384;Inherit;False;Property;_SrcBlend;SrcBlend;43;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;146;-607.5579,-382.013;Inherit;False;Property;_DstBlend;DstBlend;44;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.BlendMode;True;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;148;2272,160;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;0;2464,144;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;5;sepnekoya/EkuEffect;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;4;1;True;_SrcBlend;1;True;_DstBlend;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;VRCFallback=Hidden;True;3;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;Mobile/Particles/Alpha Blended;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;86;-5136,1040;Inherit;False;2900;739;Comment;0;Dissolve Map Flow;1,1,1,1;0;0
WireConnection;92;0;90;2
WireConnection;91;0;90;1
WireConnection;205;1;194;0
WireConnection;205;0;193;0
WireConnection;214;0;205;0
WireConnection;89;0;88;0
WireConnection;89;1;87;0
WireConnection;70;0;69;0
WireConnection;70;1;65;0
WireConnection;195;0;181;0
WireConnection;211;0;204;0
WireConnection;211;1;203;0
WireConnection;221;0;214;0
WireConnection;222;0;214;1
WireConnection;238;1;230;0
WireConnection;15;0;12;0
WireConnection;15;1;89;0
WireConnection;75;0;73;0
WireConnection;75;1;70;0
WireConnection;217;1;195;0
WireConnection;217;0;197;3
WireConnection;216;0;180;0
WireConnection;216;1;211;0
WireConnection;229;1;221;0
WireConnection;229;0;214;0
WireConnection;229;2;222;0
WireConnection;229;3;214;1
WireConnection;44;0;39;0
WireConnection;243;0;240;0
WireConnection;243;1;238;0
WireConnection;245;0;242;0
WireConnection;245;1;241;0
WireConnection;17;0;15;0
WireConnection;17;2;10;0
WireConnection;76;0;75;0
WireConnection;76;2;66;0
WireConnection;226;0;217;0
WireConnection;224;0;216;0
WireConnection;224;2;210;0
WireConnection;236;0;229;0
WireConnection;48;0;44;0
WireConnection;48;1;45;0
WireConnection;247;0;243;0
WireConnection;247;1;245;0
WireConnection;18;0;17;0
WireConnection;79;1;76;0
WireConnection;232;1;224;0
WireConnection;142;0;48;0
WireConnection;142;1;46;1
WireConnection;248;0;247;0
WireConnection;248;1;246;0
WireConnection;83;0;82;0
WireConnection;83;1;79;5
WireConnection;83;2;81;0
WireConnection;240;1;235;0
WireConnection;244;0;232;1
WireConnection;50;0;142;0
WireConnection;249;0;248;0
WireConnection;249;1;247;0
WireConnection;256;0;242;0
WireConnection;256;1;255;0
WireConnection;85;1;82;0
WireConnection;85;0;83;0
WireConnection;158;0;111;0
WireConnection;52;0;50;0
WireConnection;52;1;51;5
WireConnection;250;1;249;0
WireConnection;257;0;256;0
WireConnection;257;1;240;0
WireConnection;285;0;284;2
WireConnection;35;0;29;0
WireConnection;84;0;85;0
WireConnection;113;0;158;0
WireConnection;113;1;112;0
WireConnection;54;0;52;0
WireConnection;54;1;53;0
WireConnection;251;0;250;0
WireConnection;258;0;257;0
WireConnection;258;1;246;0
WireConnection;288;0;285;0
WireConnection;288;1;287;0
WireConnection;290;0;284;2
WireConnection;290;1;286;0
WireConnection;45;1;35;0
WireConnection;45;0;34;2
WireConnection;114;0;113;0
WireConnection;125;1;128;0
WireConnection;125;0;54;0
WireConnection;253;0;251;0
WireConnection;253;1;252;5
WireConnection;259;0;258;0
WireConnection;259;1;257;0
WireConnection;292;0;290;0
WireConnection;292;1;291;0
WireConnection;293;0;288;0
WireConnection;293;1;289;0
WireConnection;46;1;42;0
WireConnection;115;0;114;0
WireConnection;139;0;45;0
WireConnection;139;1;140;0
WireConnection;138;0;45;0
WireConnection;138;1;140;0
WireConnection;55;0;125;0
WireConnection;260;1;259;0
WireConnection;264;1;265;0
WireConnection;264;0;253;0
WireConnection;294;0;292;0
WireConnection;295;0;293;0
WireConnection;116;1;115;0
WireConnection;116;0;114;0
WireConnection;137;0;46;1
WireConnection;137;1;138;0
WireConnection;137;2;139;0
WireConnection;262;1;263;0
WireConnection;262;0;260;0
WireConnection;254;0;264;0
WireConnection;273;0;271;0
WireConnection;273;1;272;0
WireConnection;296;0;294;0
WireConnection;296;1;295;0
WireConnection;118;0;116;0
WireConnection;118;1;117;0
WireConnection;126;1;127;0
WireConnection;126;0;137;0
WireConnection;261;0;262;0
WireConnection;104;0;105;0
WireConnection;104;1;143;0
WireConnection;276;0;273;0
WireConnection;276;1;274;0
WireConnection;276;2;275;0
WireConnection;298;0;296;0
WireConnection;298;1;297;0
WireConnection;120;0;118;0
WireConnection;120;1;119;0
WireConnection;58;0;126;0
WireConnection;266;0;267;0
WireConnection;266;1;104;0
WireConnection;299;0;298;0
WireConnection;278;1;277;0
WireConnection;278;0;276;0
WireConnection;121;0;120;0
WireConnection;268;0;269;0
WireConnection;268;1;266;0
WireConnection;279;0;278;0
WireConnection;301;1;300;0
WireConnection;301;0;299;0
WireConnection;124;1;129;0
WireConnection;124;0;121;0
WireConnection;107;0;108;0
WireConnection;107;1;268;0
WireConnection;302;0;301;0
WireConnection;122;0;124;0
WireConnection;280;0;281;0
WireConnection;280;1;107;0
WireConnection;95;0;96;0
WireConnection;303;0;304;0
WireConnection;303;1;280;0
WireConnection;98;0;95;0
WireConnection;98;2;97;0
WireConnection;144;0;123;0
WireConnection;144;1;303;0
WireConnection;94;1;98;0
WireConnection;106;0;144;0
WireConnection;106;1;94;5
WireConnection;147;0;134;1
WireConnection;147;1;134;2
WireConnection;147;2;134;3
WireConnection;99;0;100;5
WireConnection;99;1;106;0
WireConnection;132;0;99;0
WireConnection;132;1;147;0
WireConnection;130;1;131;0
WireConnection;130;0;103;1
WireConnection;157;0;132;0
WireConnection;157;1;134;4
WireConnection;151;0;150;0
WireConnection;153;0;152;0
WireConnection;101;0;130;0
WireConnection;101;1;157;0
WireConnection;149;0;151;0
WireConnection;149;1;153;0
WireConnection;149;2;155;4
WireConnection;149;3;156;1
WireConnection;149;4;282;0
WireConnection;149;5;305;0
WireConnection;306;0;307;0
WireConnection;306;1;101;0
WireConnection;148;0;306;0
WireConnection;148;3;149;0
WireConnection;0;0;148;0
ASEEND*/
//CHKSM=CCE045115E9DF3269A5ACD94E9E03B10DBA95915