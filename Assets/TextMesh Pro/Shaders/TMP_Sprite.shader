Shader "TextMeshPro/Sprite"
{
	Properties
	{
<<<<<<< HEAD
		_MainTex ("Sprite Texture", 2D) = "white" {}
=======
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
>>>>>>> 436babc7fbd9a0238b3c7bac280206007670c5e6
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255
		
		_CullMode ("Cull Mode", Float) = 0
		_ColorMask ("Color Mask", Float) = 15
		_ClipRect ("Clip Rect", vector) = (-32767, -32767, 32767, 32767)

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}
		
		Stencil
		{
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp] 
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}

		Cull [_CullMode]
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		Pass
		{
<<<<<<< HEAD
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
=======
            Name "Default"
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #pragma target 2.0
>>>>>>> 436babc7fbd9a0238b3c7bac280206007670c5e6

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

<<<<<<< HEAD
			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
=======
            #pragma multi_compile __ UNITY_UI_CLIP_RECT
            #pragma multi_compile __ UNITY_UI_ALPHACLIP
>>>>>>> 436babc7fbd9a0238b3c7bac280206007670c5e6
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
<<<<<<< HEAD
=======
                UNITY_VERTEX_INPUT_INSTANCE_ID
>>>>>>> 436babc7fbd9a0238b3c7bac280206007670c5e6
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
<<<<<<< HEAD
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
			};
			
			fixed4 _Color;
			fixed4 _TextureSampleAdd;
			float4 _ClipRect;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.worldPosition = IN.vertex;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				#ifdef UNITY_HALF_TEXEL_OFFSET
				OUT.vertex.xy += (_ScreenParams.zw-1.0)*float2(-1,1);
				#endif
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			sampler2D _MainTex;

=======
                float2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
                UNITY_VERTEX_OUTPUT_STEREO
			};
			
            sampler2D _MainTex;
			fixed4 _Color;
			fixed4 _TextureSampleAdd;
			float4 _ClipRect;
            float4 _MainTex_ST;

            v2f vert(appdata_t v)
			{
				v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
                OUT.worldPosition = v.vertex;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

                OUT.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				
                OUT.color = v.color * _Color;
				return OUT;
			}

>>>>>>> 436babc7fbd9a0238b3c7bac280206007670c5e6
			fixed4 frag(v2f IN) : SV_Target
			{
				half4 color = (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd) * IN.color;
				
<<<<<<< HEAD
				#if UNITY_UI_CLIP_RECT
=======
                #ifdef UNITY_UI_CLIP_RECT
>>>>>>> 436babc7fbd9a0238b3c7bac280206007670c5e6
					color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
				#endif

				#ifdef UNITY_UI_ALPHACLIP
					clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
}
