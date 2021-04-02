Shader "Clouds Generated"
{
    Properties
    {
        Vector4_4FE19BDB("RotateProjection", Vector) = (1, 0, 0, 0)
        Vector1_97EA0DEA("NoiseScale", Float) = 10
        Vector1_BB19229D("Noise Speed", Float) = 0.1
        Vector1_1D2D6758("Noise Height", Float) = 0.1
        Vector4_53C3CAF3("Noise Remap", Vector) = (0, 1, -1, 1)
        Color_5100B6B6("Color Peak", Color) = (1, 1, 1, 0)
        Color_9F979F9B("Color Valley", Color) = (0, 0, 0, 0)
        Vector1_8B47B562("Noise Edge 1", Float) = 1
        Vector1_DD2A7971("Noise Edge 2", Float) = 1
        Vector1_7D71E79C("Noise Power Strengh", Float) = 2
        Vector1_F4FD2233("Base Scale", Float) = 5
        Vector1_3783F0D6("Base Speed", Float) = 0.2
        Vector1_89D9BA77("Base Stregh", Float) = 2
        Vector1_8F52779E("Emission Strengh", Float) = 2
        Vector1_2B356380("Curvature Radius", Float) = 0
        Vector1_7892E05E("Fresnel Power", Float) = 1
        Vector1_4386BB13("Fresnel Opacity", Float) = 1
        Vector1_ACA8BF6B("Fade Depth", Float) = 100
        [HideInInspector]_EmissionColor("Color", Color) = (1, 1, 1, 1)
        [HideInInspector]_RenderQueueType("Vector1", Float) = 5
        [HideInInspector]_StencilRef("Vector1", Int) = 0
        [HideInInspector]_StencilWriteMask("Vector1", Int) = 6
        [HideInInspector]_StencilRefDepth("Vector1", Int) = 0
        [HideInInspector]_StencilWriteMaskDepth("Vector1", Int) = 8
        [HideInInspector]_StencilRefMV("Vector1", Int) = 32
        [HideInInspector]_StencilWriteMaskMV("Vector1", Int) = 40
        [HideInInspector]_StencilRefDistortionVec("Vector1", Int) = 4
        [HideInInspector]_StencilWriteMaskDistortionVec("Vector1", Int) = 4
        [HideInInspector]_StencilWriteMaskGBuffer("Vector1", Int) = 14
        [HideInInspector]_StencilRefGBuffer("Vector1", Int) = 2
        [HideInInspector]_ZTestGBuffer("Vector1", Int) = 4
        [HideInInspector][ToggleUI]_RequireSplitLighting("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_ReceivesSSR("Boolean", Float) = 0
        [HideInInspector]_SurfaceType("Vector1", Float) = 1
        [HideInInspector]_BlendMode("Vector1", Float) = 0
        [HideInInspector]_SrcBlend("Vector1", Float) = 1
        [HideInInspector]_DstBlend("Vector1", Float) = 0
        [HideInInspector]_AlphaSrcBlend("Vector1", Float) = 1
        [HideInInspector]_AlphaDstBlend("Vector1", Float) = 0
        [HideInInspector][ToggleUI]_ZWrite("Boolean", Float) = 1
        [HideInInspector][ToggleUI]_TransparentZWrite("Boolean", Float) = 1
        [HideInInspector]_CullMode("Vector1", Float) = 2
        [HideInInspector]_TransparentSortPriority("Vector1", Int) = 0
        [HideInInspector][ToggleUI]_EnableFogOnTransparent("Boolean", Float) = 1
        [HideInInspector]_CullModeForward("Vector1", Float) = 2
        [HideInInspector][Enum(Front, 1, Back, 2)]_TransparentCullMode("Vector1", Float) = 2
        [HideInInspector]_ZTestDepthEqualForOpaque("Vector1", Int) = 4
        [HideInInspector][Enum(UnityEngine.Rendering.CompareFunction)]_ZTestTransparent("Vector1", Float) = 4
        [HideInInspector][ToggleUI]_TransparentBackfaceEnable("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_AlphaCutoffEnable("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_UseShadowThreshold("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_DoubleSidedEnable("Boolean", Float) = 1
        [HideInInspector][Enum(Flip, 0, Mirror, 1, None, 2)]_DoubleSidedNormalMode("Vector1", Float) = 2
        [HideInInspector]_DoubleSidedConstants("Vector4", Vector) = (1, 1, -1, 0)
        [HideInInspector][ToggleUI]_TransparentDepthPrepassEnable("Boolean", Float) = 0
        [HideInInspector][ToggleUI]_TransparentDepthPostpassEnable("Boolean", Float) = 0
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="HDRenderPipeline"
            "RenderType"="HDUnlitShader"
            "Queue" = "Transparent+0"
        }
        
        Pass
        {
            // based on HDUnlitPass.template
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            
            Cull [_CullMode]
        
            
            ZWrite On
        
            ZClip [_ZClip]
        
            
            ColorMask 0
        
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            //#pragma enable_d3d11_debug_symbols
        
            #pragma multi_compile_instancing
        
            //-------------------------------------------------------------------------------------
            // Graph Defines
            //-------------------------------------------------------------------------------------
                    // Shared Graph Keywords
                #define SHADERPASS SHADERPASS_SHADOWS
                #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   AlphaFog
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.WorldSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.ObjectSpacePosition
                //   VertexDescriptionInputs.WorldSpacePosition
                //   VertexDescriptionInputs.TimeParameters
                //   SurfaceDescription.Alpha
                //   SurfaceDescription.AlphaClipThreshold
                //   features.modifyMesh
                //   VertexDescription.VertexPosition
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   FragInputs.positionRWS
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.positionOS
                //   VaryingsMeshToPS.positionRWS
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Variant
            //-------------------------------------------------------------------------------------
        
            // #pragma shader_feature_local _DOUBLESIDED_ON - We have no lighting, so no need to have this combination for shader, the option will just disable backface culling
        
            // Keyword for transparent
            #pragma shader_feature _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
            #pragma shader_feature_local _ALPHATEST_ON
        
            #pragma shader_feature_local        _ENABLE_FOG_ON_TRANSPARENT
            // #define _ADD_PRECOMPUTED_VELOCITY
            // #define _ENABLE_SHADOW_MATTE
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Shader stages
            //-------------------------------------------------------------------------------------
                    #pragma vertex Vert
                #pragma fragment Frag
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Active Field Defines
            //-------------------------------------------------------------------------------------
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            // #define ATTRIBUTES_NEED_TEXCOORD0
            // #define ATTRIBUTES_NEED_TEXCOORD1
            // #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            // #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            // #define VARYINGS_NEED_TANGENT_TO_WORLD
            // #define VARYINGS_NEED_TEXCOORD0
            // #define VARYINGS_NEED_TEXCOORD1
            // #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            // #define VARYINGS_NEED_COLOR
            // #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                #define LIGHTLOOP_DISABLE_TILE_AND_CLUSTER
                #define HAS_LIGHTLOOP
                #define SHADOW_OPTIMIZE_REGISTER_USAGE 1
        
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonLighting.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Shadow/HDShadowContext.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadow.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/PunctualLightCommon.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadowLoop.hlsl"
            #endif
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
            
        #if !defined(SHADER_STAGE_RAY_TRACING)
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracing.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracingLightLoop.hlsl"
        
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/Deferred/RaytracingIntersectonGBuffer.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingIntersection.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/NormalBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/StandardLit/StandardLit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/UnlitRaytracing.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingCommon.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #endif
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION;
                float3 positionRWS; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output = (VaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output = (VaryingsMeshToDS)0;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Vector4_4FE19BDB;
                    float Vector1_97EA0DEA;
                    float Vector1_BB19229D;
                    float Vector1_1D2D6758;
                    float4 Vector4_53C3CAF3;
                    float4 Color_5100B6B6;
                    float4 Color_9F979F9B;
                    float Vector1_8B47B562;
                    float Vector1_DD2A7971;
                    float Vector1_7D71E79C;
                    float Vector1_F4FD2233;
                    float Vector1_3783F0D6;
                    float Vector1_89D9BA77;
                    float Vector1_8F52779E;
                    float Vector1_2B356380;
                    float Vector1_7892E05E;
                    float Vector1_4386BB13;
                    float Vector1_ACA8BF6B;
                    float4 _EmissionColor;
                    float _RenderQueueType;
                    float _StencilRef;
                    float _StencilWriteMask;
                    float _StencilRefDepth;
                    float _StencilWriteMaskDepth;
                    float _StencilRefMV;
                    float _StencilWriteMaskMV;
                    float _StencilRefDistortionVec;
                    float _StencilWriteMaskDistortionVec;
                    float _StencilWriteMaskGBuffer;
                    float _StencilRefGBuffer;
                    float _ZTestGBuffer;
                    float _RequireSplitLighting;
                    float _ReceivesSSR;
                    float _SurfaceType;
                    float _BlendMode;
                    float _SrcBlend;
                    float _DstBlend;
                    float _AlphaSrcBlend;
                    float _AlphaDstBlend;
                    float _ZWrite;
                    float _TransparentZWrite;
                    float _CullMode;
                    float _TransparentSortPriority;
                    float _EnableFogOnTransparent;
                    float _CullModeForward;
                    float _TransparentCullMode;
                    float _ZTestDepthEqualForOpaque;
                    float _ZTestTransparent;
                    float _TransparentBackfaceEnable;
                    float _AlphaCutoffEnable;
                    float _UseShadowThreshold;
                    float _DoubleSidedEnable;
                    float _DoubleSidedNormalMode;
                    float4 _DoubleSidedConstants;
                    float _TransparentDepthPrepassEnable;
                    float _TransparentDepthPostpassEnable;
                    CBUFFER_END
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs
                    {
                        float3 ObjectSpaceNormal; // optional
                        float3 WorldSpaceNormal; // optional
                        float3 ObjectSpaceTangent; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 VertexPosition;
                        float3 VertexNormal;
                        float3 VertexTangent;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
                    {
                        Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }
                
                    void Unity_Saturate_float(float In, out float Out)
                    {
                        Out = saturate(In);
                    }
                
                    void Unity_Distance_float3(float3 A, float3 B, out float Out)
                    {
                        Out = distance(A, B);
                    }
                
                    void Unity_Power_float(float A, float B, out float Out)
                    {
                        Out = pow(A, B);
                    }
                
                    void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
                    {
                        Rotation = radians(Rotation);
                
                        float s = sin(Rotation);
                        float c = cos(Rotation);
                        float one_minus_c = 1.0 - c;
                        
                        Axis = normalize(Axis);
                
                        float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                                  one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                                  one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                                };
                
                        Out = mul(rot_mat,  In);
                    }
                
                    void Unity_Multiply_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
                float2 Unity_GradientNoise_Dir_float(float2 p)
                {
                    // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                    p = p % 289;
                    float x = (34 * p.x + 1) * p.x % 289 + p.y;
                    x = (34 * x + 1) * x % 289;
                    x = frac(x / 41) * 2 - 1;
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { 
                        float2 p = UV * Scale;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                    {
                        Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                    }
                
                    void Unity_Absolute_float(float In, out float Out)
                    {
                        Out = abs(In);
                    }
                
                    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                    {
                        Out = smoothstep(Edge1, Edge2, In);
                    }
                
                    void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A + B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float _Distance_4D71F33C_Out_2;
                        Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_4D71F33C_Out_2);
                        float _Property_69D7AE9F_Out_0 = Vector1_2B356380;
                        float _Divide_EE7E3F48_Out_2;
                        Unity_Divide_float(_Distance_4D71F33C_Out_2, _Property_69D7AE9F_Out_0, _Divide_EE7E3F48_Out_2);
                        float _Power_1F3BC9BE_Out_2;
                        Unity_Power_float(_Divide_EE7E3F48_Out_2, 3, _Power_1F3BC9BE_Out_2);
                        float3 _Multiply_B5442326_Out_2;
                        Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_1F3BC9BE_Out_2.xxx), _Multiply_B5442326_Out_2);
                        float _Property_F656DB82_Out_0 = Vector1_8B47B562;
                        float _Property_E6FCF144_Out_0 = Vector1_DD2A7971;
                        float4 _Property_4CE5882F_Out_0 = Vector4_4FE19BDB;
                        float _Split_6C3848B1_R_1 = _Property_4CE5882F_Out_0[0];
                        float _Split_6C3848B1_G_2 = _Property_4CE5882F_Out_0[1];
                        float _Split_6C3848B1_B_3 = _Property_4CE5882F_Out_0[2];
                        float _Split_6C3848B1_A_4 = _Property_4CE5882F_Out_0[3];
                        float3 _RotateAboutAxis_5D606F9C_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_4CE5882F_Out_0.xyz), _Split_6C3848B1_A_4, _RotateAboutAxis_5D606F9C_Out_3);
                        float _Property_D1CCB3D3_Out_0 = Vector1_BB19229D;
                        float _Multiply_C1DBBF46_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_D1CCB3D3_Out_0, _Multiply_C1DBBF46_Out_2);
                        float2 _TilingAndOffset_D9156ED9_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_C1DBBF46_Out_2.xx), _TilingAndOffset_D9156ED9_Out_3);
                        float _Property_12322142_Out_0 = Vector1_97EA0DEA;
                        float _GradientNoise_AB0C880E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_D9156ED9_Out_3, _Property_12322142_Out_0, _GradientNoise_AB0C880E_Out_2);
                        float2 _TilingAndOffset_7FBE33C6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7FBE33C6_Out_3);
                        float _GradientNoise_F3C2A41D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7FBE33C6_Out_3, _Property_12322142_Out_0, _GradientNoise_F3C2A41D_Out_2);
                        float _Add_20294542_Out_2;
                        Unity_Add_float(_GradientNoise_AB0C880E_Out_2, _GradientNoise_F3C2A41D_Out_2, _Add_20294542_Out_2);
                        float _Divide_99AB6A24_Out_2;
                        Unity_Divide_float(_Add_20294542_Out_2, 2, _Divide_99AB6A24_Out_2);
                        float _Saturate_9A75CBB3_Out_1;
                        Unity_Saturate_float(_Divide_99AB6A24_Out_2, _Saturate_9A75CBB3_Out_1);
                        float _Property_56CA339D_Out_0 = Vector1_7D71E79C;
                        float _Power_B404C8D5_Out_2;
                        Unity_Power_float(_Saturate_9A75CBB3_Out_1, _Property_56CA339D_Out_0, _Power_B404C8D5_Out_2);
                        float4 _Property_CBC31DB7_Out_0 = Vector4_53C3CAF3;
                        float _Split_738E9079_R_1 = _Property_CBC31DB7_Out_0[0];
                        float _Split_738E9079_G_2 = _Property_CBC31DB7_Out_0[1];
                        float _Split_738E9079_B_3 = _Property_CBC31DB7_Out_0[2];
                        float _Split_738E9079_A_4 = _Property_CBC31DB7_Out_0[3];
                        float4 _Combine_D4E1A601_RGBA_4;
                        float3 _Combine_D4E1A601_RGB_5;
                        float2 _Combine_D4E1A601_RG_6;
                        Unity_Combine_float(_Split_738E9079_R_1, _Split_738E9079_G_2, 0, 0, _Combine_D4E1A601_RGBA_4, _Combine_D4E1A601_RGB_5, _Combine_D4E1A601_RG_6);
                        float4 _Combine_B3F9DAE4_RGBA_4;
                        float3 _Combine_B3F9DAE4_RGB_5;
                        float2 _Combine_B3F9DAE4_RG_6;
                        Unity_Combine_float(_Split_738E9079_B_3, _Split_738E9079_A_4, 0, 0, _Combine_B3F9DAE4_RGBA_4, _Combine_B3F9DAE4_RGB_5, _Combine_B3F9DAE4_RG_6);
                        float _Remap_8141F08C_Out_3;
                        Unity_Remap_float(_Power_B404C8D5_Out_2, _Combine_D4E1A601_RG_6, _Combine_B3F9DAE4_RG_6, _Remap_8141F08C_Out_3);
                        float _Absolute_DA707E52_Out_1;
                        Unity_Absolute_float(_Remap_8141F08C_Out_3, _Absolute_DA707E52_Out_1);
                        float _Smoothstep_A9222CB5_Out_3;
                        Unity_Smoothstep_float(_Property_F656DB82_Out_0, _Property_E6FCF144_Out_0, _Absolute_DA707E52_Out_1, _Smoothstep_A9222CB5_Out_3);
                        float _Property_B22C6734_Out_0 = Vector1_3783F0D6;
                        float _Multiply_9C4F241C_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_B22C6734_Out_0, _Multiply_9C4F241C_Out_2);
                        float2 _TilingAndOffset_8D91A587_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_9C4F241C_Out_2.xx), _TilingAndOffset_8D91A587_Out_3);
                        float _Property_E409C129_Out_0 = Vector1_F4FD2233;
                        float _GradientNoise_81BAEB4A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_8D91A587_Out_3, _Property_E409C129_Out_0, _GradientNoise_81BAEB4A_Out_2);
                        float _Property_C4CE44E0_Out_0 = Vector1_89D9BA77;
                        float _Multiply_F5DA2647_Out_2;
                        Unity_Multiply_float(_GradientNoise_81BAEB4A_Out_2, _Property_C4CE44E0_Out_0, _Multiply_F5DA2647_Out_2);
                        float _Add_CAB25FE5_Out_2;
                        Unity_Add_float(_Smoothstep_A9222CB5_Out_3, _Multiply_F5DA2647_Out_2, _Add_CAB25FE5_Out_2);
                        float _Add_92F04FE1_Out_2;
                        Unity_Add_float(1, _Property_C4CE44E0_Out_0, _Add_92F04FE1_Out_2);
                        float _Divide_D05AE96_Out_2;
                        Unity_Divide_float(_Add_CAB25FE5_Out_2, _Add_92F04FE1_Out_2, _Divide_D05AE96_Out_2);
                        float3 _Multiply_7920D09A_Out_2;
                        Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_D05AE96_Out_2.xxx), _Multiply_7920D09A_Out_2);
                        float _Property_57371262_Out_0 = Vector1_1D2D6758;
                        float3 _Multiply_5EA79B0E_Out_2;
                        Unity_Multiply_float(_Multiply_7920D09A_Out_2, (_Property_57371262_Out_0.xxx), _Multiply_5EA79B0E_Out_2);
                        float3 _Add_52C55F7_Out_2;
                        Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_5EA79B0E_Out_2, _Add_52C55F7_Out_2);
                        float3 _Add_337FCD1B_Out_2;
                        Unity_Add_float3(_Multiply_B5442326_Out_2, _Add_52C55F7_Out_2, _Add_337FCD1B_Out_2);
                        description.VertexPosition = _Add_337FCD1B_Out_2;
                        description.VertexNormal = IN.ObjectSpaceNormal;
                        description.VertexTangent = IN.ObjectSpaceTangent;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float _SceneDepth_6A5D647C_Out_1;
                        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_6A5D647C_Out_1);
                        float4 _ScreenPosition_D5C0B977_Out_0 = IN.ScreenPosition;
                        float _Split_D7132622_R_1 = _ScreenPosition_D5C0B977_Out_0[0];
                        float _Split_D7132622_G_2 = _ScreenPosition_D5C0B977_Out_0[1];
                        float _Split_D7132622_B_3 = _ScreenPosition_D5C0B977_Out_0[2];
                        float _Split_D7132622_A_4 = _ScreenPosition_D5C0B977_Out_0[3];
                        float _Subtract_EDAEA22B_Out_2;
                        Unity_Subtract_float(_Split_D7132622_A_4, 1, _Subtract_EDAEA22B_Out_2);
                        float _Subtract_D2C21BA_Out_2;
                        Unity_Subtract_float(_SceneDepth_6A5D647C_Out_1, _Subtract_EDAEA22B_Out_2, _Subtract_D2C21BA_Out_2);
                        float _Property_E72E495F_Out_0 = Vector1_ACA8BF6B;
                        float _Divide_69800C63_Out_2;
                        Unity_Divide_float(_Subtract_D2C21BA_Out_2, _Property_E72E495F_Out_0, _Divide_69800C63_Out_2);
                        float _Saturate_30FCF87F_Out_1;
                        Unity_Saturate_float(_Divide_69800C63_Out_2, _Saturate_30FCF87F_Out_1);
                        surface.Alpha = _Saturate_30FCF87F_Out_1;
                        surface.AlphaClipThreshold = 0;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                // output.ViewSpaceNormal =             TransformWorldToViewDir(output.WorldSpaceNormal);
                // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.ObjectSpaceTangent =          input.tangentOS;
                // output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                // output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                // output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                // output.ViewSpacePosition =           TransformWorldToView(output.WorldSpacePosition);
                // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                // output.WorldSpaceViewDirection =     GetWorldSpaceNormalizeViewDir(output.WorldSpacePosition);
                // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                // output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(output.WorldSpacePosition), _ProjectionParams.x);
                // output.uv0 =                         input.uv0;
                // output.uv1 =                         input.uv1;
                // output.uv2 =                         input.uv2;
                // output.uv3 =                         input.uv3;
                // output.VertexColor =                 input.color;
                // output.BoneWeights =                 input.weights;
                // output.BoneIndices =                 input.indices;
            
                return output;
            }
            
            AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
            {
                // build graph inputs
                VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
                // Override time paramters with used one (This is required to correctly handle motion vector for vertex animation based on time)
                vertexDescriptionInputs.TimeParameters = timeParameters;
            
                // evaluate vertex graph
                VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
            
                // copy graph output to the results
                input.positionOS = vertexDescription.VertexPosition;
                input.normalOS = vertexDescription.VertexNormal;
                input.tangentOS.xyz = vertexDescription.VertexTangent;
            
                return input;
            }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    // output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    // output.texCoord0 = input.texCoord0;
                    // output.texCoord1 = input.texCoord1;
                    // output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    // output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    // output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            #endif
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    // output.WorldSpaceNormal =            input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
                    // output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    // output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    // output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    // output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    // output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    // output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    // output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            #endif
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                // surfaceData.color = surfaceDescription.Color;
        
        #if defined(DEBUG_DISPLAY) && !defined(SHADER_STAGE_RAY_TRACING)
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO
                }
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData RAY_TRACING_OPTIONAL_PARAMETERS)
            {
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky.
        #ifdef _ALPHATEST_ON
                // GENERIC_ALPHA_TEST(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        #endif
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                    HDShadowContext shadowContext = InitShadowContext();
                    float shadow;
                    float3 shadow3;
                    posInput = GetPositionInput(fragInputs.positionSS.xy, _ScreenSize.zw, fragInputs.positionSS.z, UNITY_MATRIX_I_VP, UNITY_MATRIX_V);
                    float3 normalWS = normalize(fragInputs.tangentToWorld[1]);
                    uint renderingLayers = _EnableLightLayers ? asuint(unity_RenderingLayer.x) : DEFAULT_LIGHT_LAYERS;
                    ShadowLoopMin(shadowContext, posInput, normalWS, asuint(_ShadowMatteFilter), renderingLayers, shadow3);
                    shadow = dot(shadow3, float3(1.0f/3.0f, 1.0f/3.0f, 1.0f/3.0f));
        
                    float4 shadowColor = (1 - shadow)*surfaceDescription.ShadowTint.rgba;
                    float  localAlpha  = saturate(shadowColor.a + surfaceDescription.Alpha);
        
                    // Keep the nested lerp
                    // With no Color (bsdfData.color.rgb, bsdfData.color.a == 0.0f), just use ShadowColor*Color to avoid a ring of "white" around the shadow
                    // And mix color to consider the Color & ShadowColor alpha (from texture or/and color picker)
                    #ifdef _SURFACE_TYPE_TRANSPARENT
                        surfaceData.color = lerp(shadowColor.rgb*surfaceData.color, lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow), surfaceDescription.Alpha);
                    #else
                        surfaceData.color = lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow);
                    #endif
                    localAlpha = ApplyBlendMode(surfaceData.color, localAlpha).a;
        
                    surfaceDescription.Alpha = localAlpha;
                #endif
        
                // Builtin Data
                ZERO_INITIALIZE(BuiltinData, builtinData); // No call to InitBuiltinData as we don't have any lighting
                builtinData.opacity = surfaceDescription.Alpha;
        
                // builtinData.emissiveColor = surfaceDescription.Emission;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #endif
                RAY_TRACING_OPTIONAL_ALPHA_TEST_PASS
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassDepthOnly.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDUnlitPass.template
            Name "META"
            Tags { "LightMode" = "META" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            
            Cull Off
        
            
            
            
            
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            //#pragma enable_d3d11_debug_symbols
        
            #pragma multi_compile_instancing
        
            //-------------------------------------------------------------------------------------
            // Graph Defines
            //-------------------------------------------------------------------------------------
                    // Shared Graph Keywords
                #define SHADERPASS SHADERPASS_LIGHT_TRANSPORT
                #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   AlphaFog
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.WorldSpaceNormal
                //   SurfaceDescriptionInputs.WorldSpaceViewDirection
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   SurfaceDescriptionInputs.TimeParameters
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.WorldSpacePosition
                //   SurfaceDescription.Color
                //   SurfaceDescription.Alpha
                //   SurfaceDescription.AlphaClipThreshold
                //   SurfaceDescription.Emission
                //   features.modifyMesh
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.uv0
                //   AttributesMesh.uv1
                //   AttributesMesh.color
                //   AttributesMesh.uv2
                //   FragInputs.tangentToWorld
                //   FragInputs.positionRWS
                //   AttributesMesh.positionOS
                //   VaryingsMeshToPS.tangentWS
                //   VaryingsMeshToPS.normalWS
                //   VaryingsMeshToPS.positionRWS
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Variant
            //-------------------------------------------------------------------------------------
        
            // #pragma shader_feature_local _DOUBLESIDED_ON - We have no lighting, so no need to have this combination for shader, the option will just disable backface culling
        
            // Keyword for transparent
            #pragma shader_feature _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
            #pragma shader_feature_local _ALPHATEST_ON
        
            #pragma shader_feature_local        _ENABLE_FOG_ON_TRANSPARENT
            // #define _ADD_PRECOMPUTED_VELOCITY
            // #define _ENABLE_SHADOW_MATTE
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Shader stages
            //-------------------------------------------------------------------------------------
                    #pragma vertex Vert
                #pragma fragment Frag
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Active Field Defines
            //-------------------------------------------------------------------------------------
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            // #define VARYINGS_NEED_TEXCOORD0
            // #define VARYINGS_NEED_TEXCOORD1
            // #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            // #define VARYINGS_NEED_COLOR
            // #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                #define LIGHTLOOP_DISABLE_TILE_AND_CLUSTER
                #define HAS_LIGHTLOOP
                #define SHADOW_OPTIMIZE_REGISTER_USAGE 1
        
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonLighting.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Shadow/HDShadowContext.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadow.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/PunctualLightCommon.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadowLoop.hlsl"
            #endif
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
            
        #if !defined(SHADER_STAGE_RAY_TRACING)
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracing.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracingLightLoop.hlsl"
        
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/Deferred/RaytracingIntersectonGBuffer.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingIntersection.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/NormalBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/StandardLit/StandardLit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/UnlitRaytracing.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingCommon.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #endif
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0; // optional
                float4 uv1 : TEXCOORD1; // optional
                float4 uv2 : TEXCOORD2; // optional
                float4 color : COLOR; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION;
                float3 positionRWS; // optional
                float3 normalWS; // optional
                float4 tangentWS; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
                float4 interp02 : TEXCOORD2; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output = (VaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output = (VaryingsMeshToDS)0;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Vector4_4FE19BDB;
                    float Vector1_97EA0DEA;
                    float Vector1_BB19229D;
                    float Vector1_1D2D6758;
                    float4 Vector4_53C3CAF3;
                    float4 Color_5100B6B6;
                    float4 Color_9F979F9B;
                    float Vector1_8B47B562;
                    float Vector1_DD2A7971;
                    float Vector1_7D71E79C;
                    float Vector1_F4FD2233;
                    float Vector1_3783F0D6;
                    float Vector1_89D9BA77;
                    float Vector1_8F52779E;
                    float Vector1_2B356380;
                    float Vector1_7892E05E;
                    float Vector1_4386BB13;
                    float Vector1_ACA8BF6B;
                    float4 _EmissionColor;
                    float _RenderQueueType;
                    float _StencilRef;
                    float _StencilWriteMask;
                    float _StencilRefDepth;
                    float _StencilWriteMaskDepth;
                    float _StencilRefMV;
                    float _StencilWriteMaskMV;
                    float _StencilRefDistortionVec;
                    float _StencilWriteMaskDistortionVec;
                    float _StencilWriteMaskGBuffer;
                    float _StencilRefGBuffer;
                    float _ZTestGBuffer;
                    float _RequireSplitLighting;
                    float _ReceivesSSR;
                    float _SurfaceType;
                    float _BlendMode;
                    float _SrcBlend;
                    float _DstBlend;
                    float _AlphaSrcBlend;
                    float _AlphaDstBlend;
                    float _ZWrite;
                    float _TransparentZWrite;
                    float _CullMode;
                    float _TransparentSortPriority;
                    float _EnableFogOnTransparent;
                    float _CullModeForward;
                    float _TransparentCullMode;
                    float _ZTestDepthEqualForOpaque;
                    float _ZTestTransparent;
                    float _TransparentBackfaceEnable;
                    float _AlphaCutoffEnable;
                    float _UseShadowThreshold;
                    float _DoubleSidedEnable;
                    float _DoubleSidedNormalMode;
                    float4 _DoubleSidedConstants;
                    float _TransparentDepthPrepassEnable;
                    float _TransparentDepthPostpassEnable;
                    CBUFFER_END
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs
                    {
                        float3 ObjectSpaceNormal; // optional
                        float3 ObjectSpaceTangent; // optional
                        float3 WorldSpacePosition; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpaceNormal; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 WorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Color;
                        float Alpha;
                        float AlphaClipThreshold;
                        float3 Emission;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
                    {
                        Rotation = radians(Rotation);
                
                        float s = sin(Rotation);
                        float c = cos(Rotation);
                        float one_minus_c = 1.0 - c;
                        
                        Axis = normalize(Axis);
                
                        float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                                  one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                                  one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                                };
                
                        Out = mul(rot_mat,  In);
                    }
                
                    void Unity_Multiply_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
                float2 Unity_GradientNoise_Dir_float(float2 p)
                {
                    // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                    p = p % 289;
                    float x = (34 * p.x + 1) * p.x % 289 + p.y;
                    x = (34 * x + 1) * x % 289;
                    x = frac(x / 41) * 2 - 1;
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { 
                        float2 p = UV * Scale;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }
                
                    void Unity_Saturate_float(float In, out float Out)
                    {
                        Out = saturate(In);
                    }
                
                    void Unity_Power_float(float A, float B, out float Out)
                    {
                        Out = pow(A, B);
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                    {
                        Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                    }
                
                    void Unity_Absolute_float(float In, out float Out)
                    {
                        Out = abs(In);
                    }
                
                    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                    {
                        Out = smoothstep(Edge1, Edge2, In);
                    }
                
                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
                    {
                        Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
                    }
                
                    void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
                    {
                        Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _Property_539FFD11_Out_0 = Color_5100B6B6;
                        float4 _Property_23C63215_Out_0 = Color_9F979F9B;
                        float _Property_F656DB82_Out_0 = Vector1_8B47B562;
                        float _Property_E6FCF144_Out_0 = Vector1_DD2A7971;
                        float4 _Property_4CE5882F_Out_0 = Vector4_4FE19BDB;
                        float _Split_6C3848B1_R_1 = _Property_4CE5882F_Out_0[0];
                        float _Split_6C3848B1_G_2 = _Property_4CE5882F_Out_0[1];
                        float _Split_6C3848B1_B_3 = _Property_4CE5882F_Out_0[2];
                        float _Split_6C3848B1_A_4 = _Property_4CE5882F_Out_0[3];
                        float3 _RotateAboutAxis_5D606F9C_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_4CE5882F_Out_0.xyz), _Split_6C3848B1_A_4, _RotateAboutAxis_5D606F9C_Out_3);
                        float _Property_D1CCB3D3_Out_0 = Vector1_BB19229D;
                        float _Multiply_C1DBBF46_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_D1CCB3D3_Out_0, _Multiply_C1DBBF46_Out_2);
                        float2 _TilingAndOffset_D9156ED9_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_C1DBBF46_Out_2.xx), _TilingAndOffset_D9156ED9_Out_3);
                        float _Property_12322142_Out_0 = Vector1_97EA0DEA;
                        float _GradientNoise_AB0C880E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_D9156ED9_Out_3, _Property_12322142_Out_0, _GradientNoise_AB0C880E_Out_2);
                        float2 _TilingAndOffset_7FBE33C6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7FBE33C6_Out_3);
                        float _GradientNoise_F3C2A41D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7FBE33C6_Out_3, _Property_12322142_Out_0, _GradientNoise_F3C2A41D_Out_2);
                        float _Add_20294542_Out_2;
                        Unity_Add_float(_GradientNoise_AB0C880E_Out_2, _GradientNoise_F3C2A41D_Out_2, _Add_20294542_Out_2);
                        float _Divide_99AB6A24_Out_2;
                        Unity_Divide_float(_Add_20294542_Out_2, 2, _Divide_99AB6A24_Out_2);
                        float _Saturate_9A75CBB3_Out_1;
                        Unity_Saturate_float(_Divide_99AB6A24_Out_2, _Saturate_9A75CBB3_Out_1);
                        float _Property_56CA339D_Out_0 = Vector1_7D71E79C;
                        float _Power_B404C8D5_Out_2;
                        Unity_Power_float(_Saturate_9A75CBB3_Out_1, _Property_56CA339D_Out_0, _Power_B404C8D5_Out_2);
                        float4 _Property_CBC31DB7_Out_0 = Vector4_53C3CAF3;
                        float _Split_738E9079_R_1 = _Property_CBC31DB7_Out_0[0];
                        float _Split_738E9079_G_2 = _Property_CBC31DB7_Out_0[1];
                        float _Split_738E9079_B_3 = _Property_CBC31DB7_Out_0[2];
                        float _Split_738E9079_A_4 = _Property_CBC31DB7_Out_0[3];
                        float4 _Combine_D4E1A601_RGBA_4;
                        float3 _Combine_D4E1A601_RGB_5;
                        float2 _Combine_D4E1A601_RG_6;
                        Unity_Combine_float(_Split_738E9079_R_1, _Split_738E9079_G_2, 0, 0, _Combine_D4E1A601_RGBA_4, _Combine_D4E1A601_RGB_5, _Combine_D4E1A601_RG_6);
                        float4 _Combine_B3F9DAE4_RGBA_4;
                        float3 _Combine_B3F9DAE4_RGB_5;
                        float2 _Combine_B3F9DAE4_RG_6;
                        Unity_Combine_float(_Split_738E9079_B_3, _Split_738E9079_A_4, 0, 0, _Combine_B3F9DAE4_RGBA_4, _Combine_B3F9DAE4_RGB_5, _Combine_B3F9DAE4_RG_6);
                        float _Remap_8141F08C_Out_3;
                        Unity_Remap_float(_Power_B404C8D5_Out_2, _Combine_D4E1A601_RG_6, _Combine_B3F9DAE4_RG_6, _Remap_8141F08C_Out_3);
                        float _Absolute_DA707E52_Out_1;
                        Unity_Absolute_float(_Remap_8141F08C_Out_3, _Absolute_DA707E52_Out_1);
                        float _Smoothstep_A9222CB5_Out_3;
                        Unity_Smoothstep_float(_Property_F656DB82_Out_0, _Property_E6FCF144_Out_0, _Absolute_DA707E52_Out_1, _Smoothstep_A9222CB5_Out_3);
                        float _Property_B22C6734_Out_0 = Vector1_3783F0D6;
                        float _Multiply_9C4F241C_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_B22C6734_Out_0, _Multiply_9C4F241C_Out_2);
                        float2 _TilingAndOffset_8D91A587_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_9C4F241C_Out_2.xx), _TilingAndOffset_8D91A587_Out_3);
                        float _Property_E409C129_Out_0 = Vector1_F4FD2233;
                        float _GradientNoise_81BAEB4A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_8D91A587_Out_3, _Property_E409C129_Out_0, _GradientNoise_81BAEB4A_Out_2);
                        float _Property_C4CE44E0_Out_0 = Vector1_89D9BA77;
                        float _Multiply_F5DA2647_Out_2;
                        Unity_Multiply_float(_GradientNoise_81BAEB4A_Out_2, _Property_C4CE44E0_Out_0, _Multiply_F5DA2647_Out_2);
                        float _Add_CAB25FE5_Out_2;
                        Unity_Add_float(_Smoothstep_A9222CB5_Out_3, _Multiply_F5DA2647_Out_2, _Add_CAB25FE5_Out_2);
                        float _Add_92F04FE1_Out_2;
                        Unity_Add_float(1, _Property_C4CE44E0_Out_0, _Add_92F04FE1_Out_2);
                        float _Divide_D05AE96_Out_2;
                        Unity_Divide_float(_Add_CAB25FE5_Out_2, _Add_92F04FE1_Out_2, _Divide_D05AE96_Out_2);
                        float4 _Lerp_608D51B5_Out_3;
                        Unity_Lerp_float4(_Property_539FFD11_Out_0, _Property_23C63215_Out_0, (_Divide_D05AE96_Out_2.xxxx), _Lerp_608D51B5_Out_3);
                        float _Property_189FD6C_Out_0 = Vector1_7892E05E;
                        float _FresnelEffect_83E7E861_Out_3;
                        Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_189FD6C_Out_0, _FresnelEffect_83E7E861_Out_3);
                        float _Multiply_377CD458_Out_2;
                        Unity_Multiply_float(_Divide_D05AE96_Out_2, _FresnelEffect_83E7E861_Out_3, _Multiply_377CD458_Out_2);
                        float _Property_AA57477D_Out_0 = Vector1_4386BB13;
                        float _Multiply_A59FF53_Out_2;
                        Unity_Multiply_float(_Multiply_377CD458_Out_2, _Property_AA57477D_Out_0, _Multiply_A59FF53_Out_2);
                        float4 _Add_13002516_Out_2;
                        Unity_Add_float4(_Lerp_608D51B5_Out_3, (_Multiply_A59FF53_Out_2.xxxx), _Add_13002516_Out_2);
                        float _SceneDepth_6A5D647C_Out_1;
                        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_6A5D647C_Out_1);
                        float4 _ScreenPosition_D5C0B977_Out_0 = IN.ScreenPosition;
                        float _Split_D7132622_R_1 = _ScreenPosition_D5C0B977_Out_0[0];
                        float _Split_D7132622_G_2 = _ScreenPosition_D5C0B977_Out_0[1];
                        float _Split_D7132622_B_3 = _ScreenPosition_D5C0B977_Out_0[2];
                        float _Split_D7132622_A_4 = _ScreenPosition_D5C0B977_Out_0[3];
                        float _Subtract_EDAEA22B_Out_2;
                        Unity_Subtract_float(_Split_D7132622_A_4, 1, _Subtract_EDAEA22B_Out_2);
                        float _Subtract_D2C21BA_Out_2;
                        Unity_Subtract_float(_SceneDepth_6A5D647C_Out_1, _Subtract_EDAEA22B_Out_2, _Subtract_D2C21BA_Out_2);
                        float _Property_E72E495F_Out_0 = Vector1_ACA8BF6B;
                        float _Divide_69800C63_Out_2;
                        Unity_Divide_float(_Subtract_D2C21BA_Out_2, _Property_E72E495F_Out_0, _Divide_69800C63_Out_2);
                        float _Saturate_30FCF87F_Out_1;
                        Unity_Saturate_float(_Divide_69800C63_Out_2, _Saturate_30FCF87F_Out_1);
                        float _Property_27256254_Out_0 = Vector1_8F52779E;
                        float4 _Multiply_D88E026_Out_2;
                        Unity_Multiply_float(_Add_13002516_Out_2, (_Property_27256254_Out_0.xxxx), _Multiply_D88E026_Out_2);
                        surface.Color = (_Add_13002516_Out_2.xyz);
                        surface.Alpha = _Saturate_30FCF87F_Out_1;
                        surface.AlphaClipThreshold = 0;
                        surface.Emission = (_Multiply_D88E026_Out_2.xyz);
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                // output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                // output.ViewSpaceNormal =             TransformWorldToViewDir(output.WorldSpaceNormal);
                // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.ObjectSpaceTangent =          input.tangentOS;
                // output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                // output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                // output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                // output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                // output.ViewSpacePosition =           TransformWorldToView(output.WorldSpacePosition);
                // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                // output.WorldSpaceViewDirection =     GetWorldSpaceNormalizeViewDir(output.WorldSpacePosition);
                // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                // output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(output.WorldSpacePosition), _ProjectionParams.x);
                // output.uv0 =                         input.uv0;
                // output.uv1 =                         input.uv1;
                // output.uv2 =                         input.uv2;
                // output.uv3 =                         input.uv3;
                // output.VertexColor =                 input.color;
                // output.BoneWeights =                 input.weights;
                // output.BoneIndices =                 input.indices;
            
                return output;
            }
            
            AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
            {
                // build graph inputs
                VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
                // Override time paramters with used one (This is required to correctly handle motion vector for vertex animation based on time)
                // vertexDescriptionInputs.TimeParameters = timeParameters;
            
                // evaluate vertex graph
                VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
            
                // copy graph output to the results
                // input.positionOS = vertexDescription.VertexPosition;
                // input.normalOS = vertexDescription.VertexNormal;
                // input.tangentOS.xyz = vertexDescription.VertexTangent;
            
                return input;
            }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    // output.texCoord0 = input.texCoord0;
                    // output.texCoord1 = input.texCoord1;
                    // output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    // output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    // output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            #endif
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    output.WorldSpaceNormal =            input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
                    // output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    // output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    // output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    // output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    // output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            #endif
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                surfaceData.color = surfaceDescription.Color;
        
        #if defined(DEBUG_DISPLAY) && !defined(SHADER_STAGE_RAY_TRACING)
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO
                }
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData RAY_TRACING_OPTIONAL_PARAMETERS)
            {
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky.
        #ifdef _ALPHATEST_ON
                // GENERIC_ALPHA_TEST(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        #endif
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                    HDShadowContext shadowContext = InitShadowContext();
                    float shadow;
                    float3 shadow3;
                    posInput = GetPositionInput(fragInputs.positionSS.xy, _ScreenSize.zw, fragInputs.positionSS.z, UNITY_MATRIX_I_VP, UNITY_MATRIX_V);
                    float3 normalWS = normalize(fragInputs.tangentToWorld[1]);
                    uint renderingLayers = _EnableLightLayers ? asuint(unity_RenderingLayer.x) : DEFAULT_LIGHT_LAYERS;
                    ShadowLoopMin(shadowContext, posInput, normalWS, asuint(_ShadowMatteFilter), renderingLayers, shadow3);
                    shadow = dot(shadow3, float3(1.0f/3.0f, 1.0f/3.0f, 1.0f/3.0f));
        
                    float4 shadowColor = (1 - shadow)*surfaceDescription.ShadowTint.rgba;
                    float  localAlpha  = saturate(shadowColor.a + surfaceDescription.Alpha);
        
                    // Keep the nested lerp
                    // With no Color (bsdfData.color.rgb, bsdfData.color.a == 0.0f), just use ShadowColor*Color to avoid a ring of "white" around the shadow
                    // And mix color to consider the Color & ShadowColor alpha (from texture or/and color picker)
                    #ifdef _SURFACE_TYPE_TRANSPARENT
                        surfaceData.color = lerp(shadowColor.rgb*surfaceData.color, lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow), surfaceDescription.Alpha);
                    #else
                        surfaceData.color = lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow);
                    #endif
                    localAlpha = ApplyBlendMode(surfaceData.color, localAlpha).a;
        
                    surfaceDescription.Alpha = localAlpha;
                #endif
        
                // Builtin Data
                ZERO_INITIALIZE(BuiltinData, builtinData); // No call to InitBuiltinData as we don't have any lighting
                builtinData.opacity = surfaceDescription.Alpha;
        
                builtinData.emissiveColor = surfaceDescription.Emission;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #endif
                RAY_TRACING_OPTIONAL_ALPHA_TEST_PASS
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassLightTransport.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDUnlitPass.template
            Name "SceneSelectionPass"
            Tags { "LightMode" = "SceneSelectionPass" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            
            Cull [_CullMode]
        
            
            ZWrite On
        
            
            
            ColorMask 0
        
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            //#pragma enable_d3d11_debug_symbols
        
            #pragma multi_compile_instancing
        
            //-------------------------------------------------------------------------------------
            // Graph Defines
            //-------------------------------------------------------------------------------------
                    // Shared Graph Keywords
                #define SHADERPASS SHADERPASS_DEPTH_ONLY
                #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
                #define SCENESELECTIONPASS
                #pragma editor_sync_compilation
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   AlphaFog
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.WorldSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.ObjectSpacePosition
                //   VertexDescriptionInputs.WorldSpacePosition
                //   VertexDescriptionInputs.TimeParameters
                //   SurfaceDescription.Alpha
                //   SurfaceDescription.AlphaClipThreshold
                //   features.modifyMesh
                //   VertexDescription.VertexPosition
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   FragInputs.positionRWS
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.positionOS
                //   VaryingsMeshToPS.positionRWS
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Variant
            //-------------------------------------------------------------------------------------
        
            // #pragma shader_feature_local _DOUBLESIDED_ON - We have no lighting, so no need to have this combination for shader, the option will just disable backface culling
        
            // Keyword for transparent
            #pragma shader_feature _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
            #pragma shader_feature_local _ALPHATEST_ON
        
            #pragma shader_feature_local        _ENABLE_FOG_ON_TRANSPARENT
            // #define _ADD_PRECOMPUTED_VELOCITY
            // #define _ENABLE_SHADOW_MATTE
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Shader stages
            //-------------------------------------------------------------------------------------
                    #pragma vertex Vert
                #pragma fragment Frag
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Active Field Defines
            //-------------------------------------------------------------------------------------
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            // #define ATTRIBUTES_NEED_TEXCOORD0
            // #define ATTRIBUTES_NEED_TEXCOORD1
            // #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            // #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            // #define VARYINGS_NEED_TANGENT_TO_WORLD
            // #define VARYINGS_NEED_TEXCOORD0
            // #define VARYINGS_NEED_TEXCOORD1
            // #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            // #define VARYINGS_NEED_COLOR
            // #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                #define LIGHTLOOP_DISABLE_TILE_AND_CLUSTER
                #define HAS_LIGHTLOOP
                #define SHADOW_OPTIMIZE_REGISTER_USAGE 1
        
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonLighting.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Shadow/HDShadowContext.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadow.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/PunctualLightCommon.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadowLoop.hlsl"
            #endif
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
            
        #if !defined(SHADER_STAGE_RAY_TRACING)
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracing.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracingLightLoop.hlsl"
        
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/Deferred/RaytracingIntersectonGBuffer.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingIntersection.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/NormalBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/StandardLit/StandardLit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/UnlitRaytracing.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingCommon.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #endif
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION;
                float3 positionRWS; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output = (VaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output = (VaryingsMeshToDS)0;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Vector4_4FE19BDB;
                    float Vector1_97EA0DEA;
                    float Vector1_BB19229D;
                    float Vector1_1D2D6758;
                    float4 Vector4_53C3CAF3;
                    float4 Color_5100B6B6;
                    float4 Color_9F979F9B;
                    float Vector1_8B47B562;
                    float Vector1_DD2A7971;
                    float Vector1_7D71E79C;
                    float Vector1_F4FD2233;
                    float Vector1_3783F0D6;
                    float Vector1_89D9BA77;
                    float Vector1_8F52779E;
                    float Vector1_2B356380;
                    float Vector1_7892E05E;
                    float Vector1_4386BB13;
                    float Vector1_ACA8BF6B;
                    float4 _EmissionColor;
                    float _RenderQueueType;
                    float _StencilRef;
                    float _StencilWriteMask;
                    float _StencilRefDepth;
                    float _StencilWriteMaskDepth;
                    float _StencilRefMV;
                    float _StencilWriteMaskMV;
                    float _StencilRefDistortionVec;
                    float _StencilWriteMaskDistortionVec;
                    float _StencilWriteMaskGBuffer;
                    float _StencilRefGBuffer;
                    float _ZTestGBuffer;
                    float _RequireSplitLighting;
                    float _ReceivesSSR;
                    float _SurfaceType;
                    float _BlendMode;
                    float _SrcBlend;
                    float _DstBlend;
                    float _AlphaSrcBlend;
                    float _AlphaDstBlend;
                    float _ZWrite;
                    float _TransparentZWrite;
                    float _CullMode;
                    float _TransparentSortPriority;
                    float _EnableFogOnTransparent;
                    float _CullModeForward;
                    float _TransparentCullMode;
                    float _ZTestDepthEqualForOpaque;
                    float _ZTestTransparent;
                    float _TransparentBackfaceEnable;
                    float _AlphaCutoffEnable;
                    float _UseShadowThreshold;
                    float _DoubleSidedEnable;
                    float _DoubleSidedNormalMode;
                    float4 _DoubleSidedConstants;
                    float _TransparentDepthPrepassEnable;
                    float _TransparentDepthPostpassEnable;
                    CBUFFER_END
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs
                    {
                        float3 ObjectSpaceNormal; // optional
                        float3 WorldSpaceNormal; // optional
                        float3 ObjectSpaceTangent; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 VertexPosition;
                        float3 VertexNormal;
                        float3 VertexTangent;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
                    {
                        Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }
                
                    void Unity_Saturate_float(float In, out float Out)
                    {
                        Out = saturate(In);
                    }
                
                    void Unity_Distance_float3(float3 A, float3 B, out float Out)
                    {
                        Out = distance(A, B);
                    }
                
                    void Unity_Power_float(float A, float B, out float Out)
                    {
                        Out = pow(A, B);
                    }
                
                    void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
                    {
                        Rotation = radians(Rotation);
                
                        float s = sin(Rotation);
                        float c = cos(Rotation);
                        float one_minus_c = 1.0 - c;
                        
                        Axis = normalize(Axis);
                
                        float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                                  one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                                  one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                                };
                
                        Out = mul(rot_mat,  In);
                    }
                
                    void Unity_Multiply_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
                float2 Unity_GradientNoise_Dir_float(float2 p)
                {
                    // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                    p = p % 289;
                    float x = (34 * p.x + 1) * p.x % 289 + p.y;
                    x = (34 * x + 1) * x % 289;
                    x = frac(x / 41) * 2 - 1;
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { 
                        float2 p = UV * Scale;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                    {
                        Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                    }
                
                    void Unity_Absolute_float(float In, out float Out)
                    {
                        Out = abs(In);
                    }
                
                    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                    {
                        Out = smoothstep(Edge1, Edge2, In);
                    }
                
                    void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A + B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float _Distance_4D71F33C_Out_2;
                        Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_4D71F33C_Out_2);
                        float _Property_69D7AE9F_Out_0 = Vector1_2B356380;
                        float _Divide_EE7E3F48_Out_2;
                        Unity_Divide_float(_Distance_4D71F33C_Out_2, _Property_69D7AE9F_Out_0, _Divide_EE7E3F48_Out_2);
                        float _Power_1F3BC9BE_Out_2;
                        Unity_Power_float(_Divide_EE7E3F48_Out_2, 3, _Power_1F3BC9BE_Out_2);
                        float3 _Multiply_B5442326_Out_2;
                        Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_1F3BC9BE_Out_2.xxx), _Multiply_B5442326_Out_2);
                        float _Property_F656DB82_Out_0 = Vector1_8B47B562;
                        float _Property_E6FCF144_Out_0 = Vector1_DD2A7971;
                        float4 _Property_4CE5882F_Out_0 = Vector4_4FE19BDB;
                        float _Split_6C3848B1_R_1 = _Property_4CE5882F_Out_0[0];
                        float _Split_6C3848B1_G_2 = _Property_4CE5882F_Out_0[1];
                        float _Split_6C3848B1_B_3 = _Property_4CE5882F_Out_0[2];
                        float _Split_6C3848B1_A_4 = _Property_4CE5882F_Out_0[3];
                        float3 _RotateAboutAxis_5D606F9C_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_4CE5882F_Out_0.xyz), _Split_6C3848B1_A_4, _RotateAboutAxis_5D606F9C_Out_3);
                        float _Property_D1CCB3D3_Out_0 = Vector1_BB19229D;
                        float _Multiply_C1DBBF46_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_D1CCB3D3_Out_0, _Multiply_C1DBBF46_Out_2);
                        float2 _TilingAndOffset_D9156ED9_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_C1DBBF46_Out_2.xx), _TilingAndOffset_D9156ED9_Out_3);
                        float _Property_12322142_Out_0 = Vector1_97EA0DEA;
                        float _GradientNoise_AB0C880E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_D9156ED9_Out_3, _Property_12322142_Out_0, _GradientNoise_AB0C880E_Out_2);
                        float2 _TilingAndOffset_7FBE33C6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7FBE33C6_Out_3);
                        float _GradientNoise_F3C2A41D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7FBE33C6_Out_3, _Property_12322142_Out_0, _GradientNoise_F3C2A41D_Out_2);
                        float _Add_20294542_Out_2;
                        Unity_Add_float(_GradientNoise_AB0C880E_Out_2, _GradientNoise_F3C2A41D_Out_2, _Add_20294542_Out_2);
                        float _Divide_99AB6A24_Out_2;
                        Unity_Divide_float(_Add_20294542_Out_2, 2, _Divide_99AB6A24_Out_2);
                        float _Saturate_9A75CBB3_Out_1;
                        Unity_Saturate_float(_Divide_99AB6A24_Out_2, _Saturate_9A75CBB3_Out_1);
                        float _Property_56CA339D_Out_0 = Vector1_7D71E79C;
                        float _Power_B404C8D5_Out_2;
                        Unity_Power_float(_Saturate_9A75CBB3_Out_1, _Property_56CA339D_Out_0, _Power_B404C8D5_Out_2);
                        float4 _Property_CBC31DB7_Out_0 = Vector4_53C3CAF3;
                        float _Split_738E9079_R_1 = _Property_CBC31DB7_Out_0[0];
                        float _Split_738E9079_G_2 = _Property_CBC31DB7_Out_0[1];
                        float _Split_738E9079_B_3 = _Property_CBC31DB7_Out_0[2];
                        float _Split_738E9079_A_4 = _Property_CBC31DB7_Out_0[3];
                        float4 _Combine_D4E1A601_RGBA_4;
                        float3 _Combine_D4E1A601_RGB_5;
                        float2 _Combine_D4E1A601_RG_6;
                        Unity_Combine_float(_Split_738E9079_R_1, _Split_738E9079_G_2, 0, 0, _Combine_D4E1A601_RGBA_4, _Combine_D4E1A601_RGB_5, _Combine_D4E1A601_RG_6);
                        float4 _Combine_B3F9DAE4_RGBA_4;
                        float3 _Combine_B3F9DAE4_RGB_5;
                        float2 _Combine_B3F9DAE4_RG_6;
                        Unity_Combine_float(_Split_738E9079_B_3, _Split_738E9079_A_4, 0, 0, _Combine_B3F9DAE4_RGBA_4, _Combine_B3F9DAE4_RGB_5, _Combine_B3F9DAE4_RG_6);
                        float _Remap_8141F08C_Out_3;
                        Unity_Remap_float(_Power_B404C8D5_Out_2, _Combine_D4E1A601_RG_6, _Combine_B3F9DAE4_RG_6, _Remap_8141F08C_Out_3);
                        float _Absolute_DA707E52_Out_1;
                        Unity_Absolute_float(_Remap_8141F08C_Out_3, _Absolute_DA707E52_Out_1);
                        float _Smoothstep_A9222CB5_Out_3;
                        Unity_Smoothstep_float(_Property_F656DB82_Out_0, _Property_E6FCF144_Out_0, _Absolute_DA707E52_Out_1, _Smoothstep_A9222CB5_Out_3);
                        float _Property_B22C6734_Out_0 = Vector1_3783F0D6;
                        float _Multiply_9C4F241C_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_B22C6734_Out_0, _Multiply_9C4F241C_Out_2);
                        float2 _TilingAndOffset_8D91A587_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_9C4F241C_Out_2.xx), _TilingAndOffset_8D91A587_Out_3);
                        float _Property_E409C129_Out_0 = Vector1_F4FD2233;
                        float _GradientNoise_81BAEB4A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_8D91A587_Out_3, _Property_E409C129_Out_0, _GradientNoise_81BAEB4A_Out_2);
                        float _Property_C4CE44E0_Out_0 = Vector1_89D9BA77;
                        float _Multiply_F5DA2647_Out_2;
                        Unity_Multiply_float(_GradientNoise_81BAEB4A_Out_2, _Property_C4CE44E0_Out_0, _Multiply_F5DA2647_Out_2);
                        float _Add_CAB25FE5_Out_2;
                        Unity_Add_float(_Smoothstep_A9222CB5_Out_3, _Multiply_F5DA2647_Out_2, _Add_CAB25FE5_Out_2);
                        float _Add_92F04FE1_Out_2;
                        Unity_Add_float(1, _Property_C4CE44E0_Out_0, _Add_92F04FE1_Out_2);
                        float _Divide_D05AE96_Out_2;
                        Unity_Divide_float(_Add_CAB25FE5_Out_2, _Add_92F04FE1_Out_2, _Divide_D05AE96_Out_2);
                        float3 _Multiply_7920D09A_Out_2;
                        Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_D05AE96_Out_2.xxx), _Multiply_7920D09A_Out_2);
                        float _Property_57371262_Out_0 = Vector1_1D2D6758;
                        float3 _Multiply_5EA79B0E_Out_2;
                        Unity_Multiply_float(_Multiply_7920D09A_Out_2, (_Property_57371262_Out_0.xxx), _Multiply_5EA79B0E_Out_2);
                        float3 _Add_52C55F7_Out_2;
                        Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_5EA79B0E_Out_2, _Add_52C55F7_Out_2);
                        float3 _Add_337FCD1B_Out_2;
                        Unity_Add_float3(_Multiply_B5442326_Out_2, _Add_52C55F7_Out_2, _Add_337FCD1B_Out_2);
                        description.VertexPosition = _Add_337FCD1B_Out_2;
                        description.VertexNormal = IN.ObjectSpaceNormal;
                        description.VertexTangent = IN.ObjectSpaceTangent;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float _SceneDepth_6A5D647C_Out_1;
                        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_6A5D647C_Out_1);
                        float4 _ScreenPosition_D5C0B977_Out_0 = IN.ScreenPosition;
                        float _Split_D7132622_R_1 = _ScreenPosition_D5C0B977_Out_0[0];
                        float _Split_D7132622_G_2 = _ScreenPosition_D5C0B977_Out_0[1];
                        float _Split_D7132622_B_3 = _ScreenPosition_D5C0B977_Out_0[2];
                        float _Split_D7132622_A_4 = _ScreenPosition_D5C0B977_Out_0[3];
                        float _Subtract_EDAEA22B_Out_2;
                        Unity_Subtract_float(_Split_D7132622_A_4, 1, _Subtract_EDAEA22B_Out_2);
                        float _Subtract_D2C21BA_Out_2;
                        Unity_Subtract_float(_SceneDepth_6A5D647C_Out_1, _Subtract_EDAEA22B_Out_2, _Subtract_D2C21BA_Out_2);
                        float _Property_E72E495F_Out_0 = Vector1_ACA8BF6B;
                        float _Divide_69800C63_Out_2;
                        Unity_Divide_float(_Subtract_D2C21BA_Out_2, _Property_E72E495F_Out_0, _Divide_69800C63_Out_2);
                        float _Saturate_30FCF87F_Out_1;
                        Unity_Saturate_float(_Divide_69800C63_Out_2, _Saturate_30FCF87F_Out_1);
                        surface.Alpha = _Saturate_30FCF87F_Out_1;
                        surface.AlphaClipThreshold = 0;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                // output.ViewSpaceNormal =             TransformWorldToViewDir(output.WorldSpaceNormal);
                // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.ObjectSpaceTangent =          input.tangentOS;
                // output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                // output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                // output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                // output.ViewSpacePosition =           TransformWorldToView(output.WorldSpacePosition);
                // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                // output.WorldSpaceViewDirection =     GetWorldSpaceNormalizeViewDir(output.WorldSpacePosition);
                // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                // output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(output.WorldSpacePosition), _ProjectionParams.x);
                // output.uv0 =                         input.uv0;
                // output.uv1 =                         input.uv1;
                // output.uv2 =                         input.uv2;
                // output.uv3 =                         input.uv3;
                // output.VertexColor =                 input.color;
                // output.BoneWeights =                 input.weights;
                // output.BoneIndices =                 input.indices;
            
                return output;
            }
            
            AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
            {
                // build graph inputs
                VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
                // Override time paramters with used one (This is required to correctly handle motion vector for vertex animation based on time)
                vertexDescriptionInputs.TimeParameters = timeParameters;
            
                // evaluate vertex graph
                VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
            
                // copy graph output to the results
                input.positionOS = vertexDescription.VertexPosition;
                input.normalOS = vertexDescription.VertexNormal;
                input.tangentOS.xyz = vertexDescription.VertexTangent;
            
                return input;
            }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    // output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    // output.texCoord0 = input.texCoord0;
                    // output.texCoord1 = input.texCoord1;
                    // output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    // output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    // output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            #endif
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    // output.WorldSpaceNormal =            input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
                    // output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    // output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    // output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    // output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    // output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    // output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    // output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            #endif
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                // surfaceData.color = surfaceDescription.Color;
        
        #if defined(DEBUG_DISPLAY) && !defined(SHADER_STAGE_RAY_TRACING)
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO
                }
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData RAY_TRACING_OPTIONAL_PARAMETERS)
            {
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky.
        #ifdef _ALPHATEST_ON
                // GENERIC_ALPHA_TEST(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        #endif
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                    HDShadowContext shadowContext = InitShadowContext();
                    float shadow;
                    float3 shadow3;
                    posInput = GetPositionInput(fragInputs.positionSS.xy, _ScreenSize.zw, fragInputs.positionSS.z, UNITY_MATRIX_I_VP, UNITY_MATRIX_V);
                    float3 normalWS = normalize(fragInputs.tangentToWorld[1]);
                    uint renderingLayers = _EnableLightLayers ? asuint(unity_RenderingLayer.x) : DEFAULT_LIGHT_LAYERS;
                    ShadowLoopMin(shadowContext, posInput, normalWS, asuint(_ShadowMatteFilter), renderingLayers, shadow3);
                    shadow = dot(shadow3, float3(1.0f/3.0f, 1.0f/3.0f, 1.0f/3.0f));
        
                    float4 shadowColor = (1 - shadow)*surfaceDescription.ShadowTint.rgba;
                    float  localAlpha  = saturate(shadowColor.a + surfaceDescription.Alpha);
        
                    // Keep the nested lerp
                    // With no Color (bsdfData.color.rgb, bsdfData.color.a == 0.0f), just use ShadowColor*Color to avoid a ring of "white" around the shadow
                    // And mix color to consider the Color & ShadowColor alpha (from texture or/and color picker)
                    #ifdef _SURFACE_TYPE_TRANSPARENT
                        surfaceData.color = lerp(shadowColor.rgb*surfaceData.color, lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow), surfaceDescription.Alpha);
                    #else
                        surfaceData.color = lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow);
                    #endif
                    localAlpha = ApplyBlendMode(surfaceData.color, localAlpha).a;
        
                    surfaceDescription.Alpha = localAlpha;
                #endif
        
                // Builtin Data
                ZERO_INITIALIZE(BuiltinData, builtinData); // No call to InitBuiltinData as we don't have any lighting
                builtinData.opacity = surfaceDescription.Alpha;
        
                // builtinData.emissiveColor = surfaceDescription.Emission;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #endif
                RAY_TRACING_OPTIONAL_ALPHA_TEST_PASS
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassDepthOnly.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDUnlitPass.template
            Name "DepthForwardOnly"
            Tags { "LightMode" = "DepthForwardOnly" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            
            Cull [_CullMode]
        
            
            ZWrite On
        
            
            // Stencil setup
        Stencil
        {
           WriteMask [_StencilWriteMaskDepth]
           Ref [_StencilRefDepth]
           Comp Always
           Pass Replace
        }
        
            ColorMask 0 0
        
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            //#pragma enable_d3d11_debug_symbols
        
            #pragma multi_compile_instancing
        
            //-------------------------------------------------------------------------------------
            // Graph Defines
            //-------------------------------------------------------------------------------------
                    // Shared Graph Keywords
                #define SHADERPASS SHADERPASS_DEPTH_ONLY
                #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
                #pragma multi_compile _ WRITE_MSAA_DEPTH
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   AlphaFog
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.WorldSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.ObjectSpacePosition
                //   VertexDescriptionInputs.WorldSpacePosition
                //   VertexDescriptionInputs.TimeParameters
                //   SurfaceDescription.Alpha
                //   SurfaceDescription.AlphaClipThreshold
                //   features.modifyMesh
                //   VertexDescription.VertexPosition
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   FragInputs.positionRWS
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.positionOS
                //   VaryingsMeshToPS.positionRWS
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Variant
            //-------------------------------------------------------------------------------------
        
            // #pragma shader_feature_local _DOUBLESIDED_ON - We have no lighting, so no need to have this combination for shader, the option will just disable backface culling
        
            // Keyword for transparent
            #pragma shader_feature _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
            #pragma shader_feature_local _ALPHATEST_ON
        
            #pragma shader_feature_local        _ENABLE_FOG_ON_TRANSPARENT
            // #define _ADD_PRECOMPUTED_VELOCITY
            // #define _ENABLE_SHADOW_MATTE
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Shader stages
            //-------------------------------------------------------------------------------------
                    #pragma vertex Vert
                #pragma fragment Frag
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Active Field Defines
            //-------------------------------------------------------------------------------------
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            // #define ATTRIBUTES_NEED_TEXCOORD0
            // #define ATTRIBUTES_NEED_TEXCOORD1
            // #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            // #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            // #define VARYINGS_NEED_TANGENT_TO_WORLD
            // #define VARYINGS_NEED_TEXCOORD0
            // #define VARYINGS_NEED_TEXCOORD1
            // #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            // #define VARYINGS_NEED_COLOR
            // #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                #define LIGHTLOOP_DISABLE_TILE_AND_CLUSTER
                #define HAS_LIGHTLOOP
                #define SHADOW_OPTIMIZE_REGISTER_USAGE 1
        
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonLighting.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Shadow/HDShadowContext.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadow.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/PunctualLightCommon.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadowLoop.hlsl"
            #endif
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
            
        #if !defined(SHADER_STAGE_RAY_TRACING)
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracing.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracingLightLoop.hlsl"
        
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/Deferred/RaytracingIntersectonGBuffer.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingIntersection.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/NormalBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/StandardLit/StandardLit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/UnlitRaytracing.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingCommon.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #endif
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION;
                float3 positionRWS; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output = (VaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output = (VaryingsMeshToDS)0;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Vector4_4FE19BDB;
                    float Vector1_97EA0DEA;
                    float Vector1_BB19229D;
                    float Vector1_1D2D6758;
                    float4 Vector4_53C3CAF3;
                    float4 Color_5100B6B6;
                    float4 Color_9F979F9B;
                    float Vector1_8B47B562;
                    float Vector1_DD2A7971;
                    float Vector1_7D71E79C;
                    float Vector1_F4FD2233;
                    float Vector1_3783F0D6;
                    float Vector1_89D9BA77;
                    float Vector1_8F52779E;
                    float Vector1_2B356380;
                    float Vector1_7892E05E;
                    float Vector1_4386BB13;
                    float Vector1_ACA8BF6B;
                    float4 _EmissionColor;
                    float _RenderQueueType;
                    float _StencilRef;
                    float _StencilWriteMask;
                    float _StencilRefDepth;
                    float _StencilWriteMaskDepth;
                    float _StencilRefMV;
                    float _StencilWriteMaskMV;
                    float _StencilRefDistortionVec;
                    float _StencilWriteMaskDistortionVec;
                    float _StencilWriteMaskGBuffer;
                    float _StencilRefGBuffer;
                    float _ZTestGBuffer;
                    float _RequireSplitLighting;
                    float _ReceivesSSR;
                    float _SurfaceType;
                    float _BlendMode;
                    float _SrcBlend;
                    float _DstBlend;
                    float _AlphaSrcBlend;
                    float _AlphaDstBlend;
                    float _ZWrite;
                    float _TransparentZWrite;
                    float _CullMode;
                    float _TransparentSortPriority;
                    float _EnableFogOnTransparent;
                    float _CullModeForward;
                    float _TransparentCullMode;
                    float _ZTestDepthEqualForOpaque;
                    float _ZTestTransparent;
                    float _TransparentBackfaceEnable;
                    float _AlphaCutoffEnable;
                    float _UseShadowThreshold;
                    float _DoubleSidedEnable;
                    float _DoubleSidedNormalMode;
                    float4 _DoubleSidedConstants;
                    float _TransparentDepthPrepassEnable;
                    float _TransparentDepthPostpassEnable;
                    CBUFFER_END
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs
                    {
                        float3 ObjectSpaceNormal; // optional
                        float3 WorldSpaceNormal; // optional
                        float3 ObjectSpaceTangent; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 VertexPosition;
                        float3 VertexNormal;
                        float3 VertexTangent;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
                    {
                        Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }
                
                    void Unity_Saturate_float(float In, out float Out)
                    {
                        Out = saturate(In);
                    }
                
                    void Unity_Distance_float3(float3 A, float3 B, out float Out)
                    {
                        Out = distance(A, B);
                    }
                
                    void Unity_Power_float(float A, float B, out float Out)
                    {
                        Out = pow(A, B);
                    }
                
                    void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
                    {
                        Rotation = radians(Rotation);
                
                        float s = sin(Rotation);
                        float c = cos(Rotation);
                        float one_minus_c = 1.0 - c;
                        
                        Axis = normalize(Axis);
                
                        float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                                  one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                                  one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                                };
                
                        Out = mul(rot_mat,  In);
                    }
                
                    void Unity_Multiply_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
                float2 Unity_GradientNoise_Dir_float(float2 p)
                {
                    // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                    p = p % 289;
                    float x = (34 * p.x + 1) * p.x % 289 + p.y;
                    x = (34 * x + 1) * x % 289;
                    x = frac(x / 41) * 2 - 1;
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { 
                        float2 p = UV * Scale;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                    {
                        Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                    }
                
                    void Unity_Absolute_float(float In, out float Out)
                    {
                        Out = abs(In);
                    }
                
                    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                    {
                        Out = smoothstep(Edge1, Edge2, In);
                    }
                
                    void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A + B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float _Distance_4D71F33C_Out_2;
                        Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_4D71F33C_Out_2);
                        float _Property_69D7AE9F_Out_0 = Vector1_2B356380;
                        float _Divide_EE7E3F48_Out_2;
                        Unity_Divide_float(_Distance_4D71F33C_Out_2, _Property_69D7AE9F_Out_0, _Divide_EE7E3F48_Out_2);
                        float _Power_1F3BC9BE_Out_2;
                        Unity_Power_float(_Divide_EE7E3F48_Out_2, 3, _Power_1F3BC9BE_Out_2);
                        float3 _Multiply_B5442326_Out_2;
                        Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_1F3BC9BE_Out_2.xxx), _Multiply_B5442326_Out_2);
                        float _Property_F656DB82_Out_0 = Vector1_8B47B562;
                        float _Property_E6FCF144_Out_0 = Vector1_DD2A7971;
                        float4 _Property_4CE5882F_Out_0 = Vector4_4FE19BDB;
                        float _Split_6C3848B1_R_1 = _Property_4CE5882F_Out_0[0];
                        float _Split_6C3848B1_G_2 = _Property_4CE5882F_Out_0[1];
                        float _Split_6C3848B1_B_3 = _Property_4CE5882F_Out_0[2];
                        float _Split_6C3848B1_A_4 = _Property_4CE5882F_Out_0[3];
                        float3 _RotateAboutAxis_5D606F9C_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_4CE5882F_Out_0.xyz), _Split_6C3848B1_A_4, _RotateAboutAxis_5D606F9C_Out_3);
                        float _Property_D1CCB3D3_Out_0 = Vector1_BB19229D;
                        float _Multiply_C1DBBF46_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_D1CCB3D3_Out_0, _Multiply_C1DBBF46_Out_2);
                        float2 _TilingAndOffset_D9156ED9_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_C1DBBF46_Out_2.xx), _TilingAndOffset_D9156ED9_Out_3);
                        float _Property_12322142_Out_0 = Vector1_97EA0DEA;
                        float _GradientNoise_AB0C880E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_D9156ED9_Out_3, _Property_12322142_Out_0, _GradientNoise_AB0C880E_Out_2);
                        float2 _TilingAndOffset_7FBE33C6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7FBE33C6_Out_3);
                        float _GradientNoise_F3C2A41D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7FBE33C6_Out_3, _Property_12322142_Out_0, _GradientNoise_F3C2A41D_Out_2);
                        float _Add_20294542_Out_2;
                        Unity_Add_float(_GradientNoise_AB0C880E_Out_2, _GradientNoise_F3C2A41D_Out_2, _Add_20294542_Out_2);
                        float _Divide_99AB6A24_Out_2;
                        Unity_Divide_float(_Add_20294542_Out_2, 2, _Divide_99AB6A24_Out_2);
                        float _Saturate_9A75CBB3_Out_1;
                        Unity_Saturate_float(_Divide_99AB6A24_Out_2, _Saturate_9A75CBB3_Out_1);
                        float _Property_56CA339D_Out_0 = Vector1_7D71E79C;
                        float _Power_B404C8D5_Out_2;
                        Unity_Power_float(_Saturate_9A75CBB3_Out_1, _Property_56CA339D_Out_0, _Power_B404C8D5_Out_2);
                        float4 _Property_CBC31DB7_Out_0 = Vector4_53C3CAF3;
                        float _Split_738E9079_R_1 = _Property_CBC31DB7_Out_0[0];
                        float _Split_738E9079_G_2 = _Property_CBC31DB7_Out_0[1];
                        float _Split_738E9079_B_3 = _Property_CBC31DB7_Out_0[2];
                        float _Split_738E9079_A_4 = _Property_CBC31DB7_Out_0[3];
                        float4 _Combine_D4E1A601_RGBA_4;
                        float3 _Combine_D4E1A601_RGB_5;
                        float2 _Combine_D4E1A601_RG_6;
                        Unity_Combine_float(_Split_738E9079_R_1, _Split_738E9079_G_2, 0, 0, _Combine_D4E1A601_RGBA_4, _Combine_D4E1A601_RGB_5, _Combine_D4E1A601_RG_6);
                        float4 _Combine_B3F9DAE4_RGBA_4;
                        float3 _Combine_B3F9DAE4_RGB_5;
                        float2 _Combine_B3F9DAE4_RG_6;
                        Unity_Combine_float(_Split_738E9079_B_3, _Split_738E9079_A_4, 0, 0, _Combine_B3F9DAE4_RGBA_4, _Combine_B3F9DAE4_RGB_5, _Combine_B3F9DAE4_RG_6);
                        float _Remap_8141F08C_Out_3;
                        Unity_Remap_float(_Power_B404C8D5_Out_2, _Combine_D4E1A601_RG_6, _Combine_B3F9DAE4_RG_6, _Remap_8141F08C_Out_3);
                        float _Absolute_DA707E52_Out_1;
                        Unity_Absolute_float(_Remap_8141F08C_Out_3, _Absolute_DA707E52_Out_1);
                        float _Smoothstep_A9222CB5_Out_3;
                        Unity_Smoothstep_float(_Property_F656DB82_Out_0, _Property_E6FCF144_Out_0, _Absolute_DA707E52_Out_1, _Smoothstep_A9222CB5_Out_3);
                        float _Property_B22C6734_Out_0 = Vector1_3783F0D6;
                        float _Multiply_9C4F241C_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_B22C6734_Out_0, _Multiply_9C4F241C_Out_2);
                        float2 _TilingAndOffset_8D91A587_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_9C4F241C_Out_2.xx), _TilingAndOffset_8D91A587_Out_3);
                        float _Property_E409C129_Out_0 = Vector1_F4FD2233;
                        float _GradientNoise_81BAEB4A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_8D91A587_Out_3, _Property_E409C129_Out_0, _GradientNoise_81BAEB4A_Out_2);
                        float _Property_C4CE44E0_Out_0 = Vector1_89D9BA77;
                        float _Multiply_F5DA2647_Out_2;
                        Unity_Multiply_float(_GradientNoise_81BAEB4A_Out_2, _Property_C4CE44E0_Out_0, _Multiply_F5DA2647_Out_2);
                        float _Add_CAB25FE5_Out_2;
                        Unity_Add_float(_Smoothstep_A9222CB5_Out_3, _Multiply_F5DA2647_Out_2, _Add_CAB25FE5_Out_2);
                        float _Add_92F04FE1_Out_2;
                        Unity_Add_float(1, _Property_C4CE44E0_Out_0, _Add_92F04FE1_Out_2);
                        float _Divide_D05AE96_Out_2;
                        Unity_Divide_float(_Add_CAB25FE5_Out_2, _Add_92F04FE1_Out_2, _Divide_D05AE96_Out_2);
                        float3 _Multiply_7920D09A_Out_2;
                        Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_D05AE96_Out_2.xxx), _Multiply_7920D09A_Out_2);
                        float _Property_57371262_Out_0 = Vector1_1D2D6758;
                        float3 _Multiply_5EA79B0E_Out_2;
                        Unity_Multiply_float(_Multiply_7920D09A_Out_2, (_Property_57371262_Out_0.xxx), _Multiply_5EA79B0E_Out_2);
                        float3 _Add_52C55F7_Out_2;
                        Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_5EA79B0E_Out_2, _Add_52C55F7_Out_2);
                        float3 _Add_337FCD1B_Out_2;
                        Unity_Add_float3(_Multiply_B5442326_Out_2, _Add_52C55F7_Out_2, _Add_337FCD1B_Out_2);
                        description.VertexPosition = _Add_337FCD1B_Out_2;
                        description.VertexNormal = IN.ObjectSpaceNormal;
                        description.VertexTangent = IN.ObjectSpaceTangent;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float _SceneDepth_6A5D647C_Out_1;
                        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_6A5D647C_Out_1);
                        float4 _ScreenPosition_D5C0B977_Out_0 = IN.ScreenPosition;
                        float _Split_D7132622_R_1 = _ScreenPosition_D5C0B977_Out_0[0];
                        float _Split_D7132622_G_2 = _ScreenPosition_D5C0B977_Out_0[1];
                        float _Split_D7132622_B_3 = _ScreenPosition_D5C0B977_Out_0[2];
                        float _Split_D7132622_A_4 = _ScreenPosition_D5C0B977_Out_0[3];
                        float _Subtract_EDAEA22B_Out_2;
                        Unity_Subtract_float(_Split_D7132622_A_4, 1, _Subtract_EDAEA22B_Out_2);
                        float _Subtract_D2C21BA_Out_2;
                        Unity_Subtract_float(_SceneDepth_6A5D647C_Out_1, _Subtract_EDAEA22B_Out_2, _Subtract_D2C21BA_Out_2);
                        float _Property_E72E495F_Out_0 = Vector1_ACA8BF6B;
                        float _Divide_69800C63_Out_2;
                        Unity_Divide_float(_Subtract_D2C21BA_Out_2, _Property_E72E495F_Out_0, _Divide_69800C63_Out_2);
                        float _Saturate_30FCF87F_Out_1;
                        Unity_Saturate_float(_Divide_69800C63_Out_2, _Saturate_30FCF87F_Out_1);
                        surface.Alpha = _Saturate_30FCF87F_Out_1;
                        surface.AlphaClipThreshold = 0;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                // output.ViewSpaceNormal =             TransformWorldToViewDir(output.WorldSpaceNormal);
                // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.ObjectSpaceTangent =          input.tangentOS;
                // output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                // output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                // output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                // output.ViewSpacePosition =           TransformWorldToView(output.WorldSpacePosition);
                // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                // output.WorldSpaceViewDirection =     GetWorldSpaceNormalizeViewDir(output.WorldSpacePosition);
                // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                // output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(output.WorldSpacePosition), _ProjectionParams.x);
                // output.uv0 =                         input.uv0;
                // output.uv1 =                         input.uv1;
                // output.uv2 =                         input.uv2;
                // output.uv3 =                         input.uv3;
                // output.VertexColor =                 input.color;
                // output.BoneWeights =                 input.weights;
                // output.BoneIndices =                 input.indices;
            
                return output;
            }
            
            AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
            {
                // build graph inputs
                VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
                // Override time paramters with used one (This is required to correctly handle motion vector for vertex animation based on time)
                vertexDescriptionInputs.TimeParameters = timeParameters;
            
                // evaluate vertex graph
                VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
            
                // copy graph output to the results
                input.positionOS = vertexDescription.VertexPosition;
                input.normalOS = vertexDescription.VertexNormal;
                input.tangentOS.xyz = vertexDescription.VertexTangent;
            
                return input;
            }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    // output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    // output.texCoord0 = input.texCoord0;
                    // output.texCoord1 = input.texCoord1;
                    // output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    // output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    // output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            #endif
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    // output.WorldSpaceNormal =            input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
                    // output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    // output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    // output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    // output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    // output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    // output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    // output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            #endif
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                // surfaceData.color = surfaceDescription.Color;
        
        #if defined(DEBUG_DISPLAY) && !defined(SHADER_STAGE_RAY_TRACING)
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO
                }
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData RAY_TRACING_OPTIONAL_PARAMETERS)
            {
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky.
        #ifdef _ALPHATEST_ON
                // GENERIC_ALPHA_TEST(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        #endif
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                    HDShadowContext shadowContext = InitShadowContext();
                    float shadow;
                    float3 shadow3;
                    posInput = GetPositionInput(fragInputs.positionSS.xy, _ScreenSize.zw, fragInputs.positionSS.z, UNITY_MATRIX_I_VP, UNITY_MATRIX_V);
                    float3 normalWS = normalize(fragInputs.tangentToWorld[1]);
                    uint renderingLayers = _EnableLightLayers ? asuint(unity_RenderingLayer.x) : DEFAULT_LIGHT_LAYERS;
                    ShadowLoopMin(shadowContext, posInput, normalWS, asuint(_ShadowMatteFilter), renderingLayers, shadow3);
                    shadow = dot(shadow3, float3(1.0f/3.0f, 1.0f/3.0f, 1.0f/3.0f));
        
                    float4 shadowColor = (1 - shadow)*surfaceDescription.ShadowTint.rgba;
                    float  localAlpha  = saturate(shadowColor.a + surfaceDescription.Alpha);
        
                    // Keep the nested lerp
                    // With no Color (bsdfData.color.rgb, bsdfData.color.a == 0.0f), just use ShadowColor*Color to avoid a ring of "white" around the shadow
                    // And mix color to consider the Color & ShadowColor alpha (from texture or/and color picker)
                    #ifdef _SURFACE_TYPE_TRANSPARENT
                        surfaceData.color = lerp(shadowColor.rgb*surfaceData.color, lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow), surfaceDescription.Alpha);
                    #else
                        surfaceData.color = lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow);
                    #endif
                    localAlpha = ApplyBlendMode(surfaceData.color, localAlpha).a;
        
                    surfaceDescription.Alpha = localAlpha;
                #endif
        
                // Builtin Data
                ZERO_INITIALIZE(BuiltinData, builtinData); // No call to InitBuiltinData as we don't have any lighting
                builtinData.opacity = surfaceDescription.Alpha;
        
                // builtinData.emissiveColor = surfaceDescription.Emission;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #endif
                RAY_TRACING_OPTIONAL_ALPHA_TEST_PASS
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassDepthOnly.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDUnlitPass.template
            Name "MotionVectors"
            Tags { "LightMode" = "MotionVectors" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            
            Cull [_CullMode]
        
            
            ZWrite On
        
            
            // Stencil setup
        Stencil
        {
           WriteMask [_StencilWriteMaskMV]
           Ref [_StencilRefMV]
           Comp Always
           Pass Replace
        }
        
            ColorMask 0 1
        
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            //#pragma enable_d3d11_debug_symbols
        
            #pragma multi_compile_instancing
        
            //-------------------------------------------------------------------------------------
            // Graph Defines
            //-------------------------------------------------------------------------------------
                    // Shared Graph Keywords
                #define SHADERPASS SHADERPASS_MOTION_VECTORS
                #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
                #pragma multi_compile _ WRITE_MSAA_DEPTH
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   AlphaFog
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.WorldSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.ObjectSpacePosition
                //   VertexDescriptionInputs.WorldSpacePosition
                //   VertexDescriptionInputs.TimeParameters
                //   SurfaceDescription.Alpha
                //   SurfaceDescription.AlphaClipThreshold
                //   features.modifyMesh
                //   VertexDescription.VertexPosition
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   FragInputs.positionRWS
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.positionOS
                //   VaryingsMeshToPS.positionRWS
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Variant
            //-------------------------------------------------------------------------------------
        
            // #pragma shader_feature_local _DOUBLESIDED_ON - We have no lighting, so no need to have this combination for shader, the option will just disable backface culling
        
            // Keyword for transparent
            #pragma shader_feature _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
            #pragma shader_feature_local _ALPHATEST_ON
        
            #pragma shader_feature_local        _ENABLE_FOG_ON_TRANSPARENT
            // #define _ADD_PRECOMPUTED_VELOCITY
            // #define _ENABLE_SHADOW_MATTE
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Shader stages
            //-------------------------------------------------------------------------------------
                    #pragma vertex Vert
                #pragma fragment Frag
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Active Field Defines
            //-------------------------------------------------------------------------------------
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            // #define ATTRIBUTES_NEED_TEXCOORD0
            // #define ATTRIBUTES_NEED_TEXCOORD1
            // #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            // #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            // #define VARYINGS_NEED_TANGENT_TO_WORLD
            // #define VARYINGS_NEED_TEXCOORD0
            // #define VARYINGS_NEED_TEXCOORD1
            // #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            // #define VARYINGS_NEED_COLOR
            // #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                #define LIGHTLOOP_DISABLE_TILE_AND_CLUSTER
                #define HAS_LIGHTLOOP
                #define SHADOW_OPTIMIZE_REGISTER_USAGE 1
        
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonLighting.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Shadow/HDShadowContext.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadow.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/PunctualLightCommon.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadowLoop.hlsl"
            #endif
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
            
        #if !defined(SHADER_STAGE_RAY_TRACING)
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracing.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracingLightLoop.hlsl"
        
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/Deferred/RaytracingIntersectonGBuffer.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingIntersection.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/NormalBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/StandardLit/StandardLit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/UnlitRaytracing.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingCommon.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #endif
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION;
                float3 positionRWS; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output = (VaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output = (VaryingsMeshToDS)0;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Vector4_4FE19BDB;
                    float Vector1_97EA0DEA;
                    float Vector1_BB19229D;
                    float Vector1_1D2D6758;
                    float4 Vector4_53C3CAF3;
                    float4 Color_5100B6B6;
                    float4 Color_9F979F9B;
                    float Vector1_8B47B562;
                    float Vector1_DD2A7971;
                    float Vector1_7D71E79C;
                    float Vector1_F4FD2233;
                    float Vector1_3783F0D6;
                    float Vector1_89D9BA77;
                    float Vector1_8F52779E;
                    float Vector1_2B356380;
                    float Vector1_7892E05E;
                    float Vector1_4386BB13;
                    float Vector1_ACA8BF6B;
                    float4 _EmissionColor;
                    float _RenderQueueType;
                    float _StencilRef;
                    float _StencilWriteMask;
                    float _StencilRefDepth;
                    float _StencilWriteMaskDepth;
                    float _StencilRefMV;
                    float _StencilWriteMaskMV;
                    float _StencilRefDistortionVec;
                    float _StencilWriteMaskDistortionVec;
                    float _StencilWriteMaskGBuffer;
                    float _StencilRefGBuffer;
                    float _ZTestGBuffer;
                    float _RequireSplitLighting;
                    float _ReceivesSSR;
                    float _SurfaceType;
                    float _BlendMode;
                    float _SrcBlend;
                    float _DstBlend;
                    float _AlphaSrcBlend;
                    float _AlphaDstBlend;
                    float _ZWrite;
                    float _TransparentZWrite;
                    float _CullMode;
                    float _TransparentSortPriority;
                    float _EnableFogOnTransparent;
                    float _CullModeForward;
                    float _TransparentCullMode;
                    float _ZTestDepthEqualForOpaque;
                    float _ZTestTransparent;
                    float _TransparentBackfaceEnable;
                    float _AlphaCutoffEnable;
                    float _UseShadowThreshold;
                    float _DoubleSidedEnable;
                    float _DoubleSidedNormalMode;
                    float4 _DoubleSidedConstants;
                    float _TransparentDepthPrepassEnable;
                    float _TransparentDepthPostpassEnable;
                    CBUFFER_END
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs
                    {
                        float3 ObjectSpaceNormal; // optional
                        float3 WorldSpaceNormal; // optional
                        float3 ObjectSpaceTangent; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 VertexPosition;
                        float3 VertexNormal;
                        float3 VertexTangent;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
                    {
                        Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }
                
                    void Unity_Saturate_float(float In, out float Out)
                    {
                        Out = saturate(In);
                    }
                
                    void Unity_Distance_float3(float3 A, float3 B, out float Out)
                    {
                        Out = distance(A, B);
                    }
                
                    void Unity_Power_float(float A, float B, out float Out)
                    {
                        Out = pow(A, B);
                    }
                
                    void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
                    {
                        Rotation = radians(Rotation);
                
                        float s = sin(Rotation);
                        float c = cos(Rotation);
                        float one_minus_c = 1.0 - c;
                        
                        Axis = normalize(Axis);
                
                        float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                                  one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                                  one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                                };
                
                        Out = mul(rot_mat,  In);
                    }
                
                    void Unity_Multiply_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
                float2 Unity_GradientNoise_Dir_float(float2 p)
                {
                    // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                    p = p % 289;
                    float x = (34 * p.x + 1) * p.x % 289 + p.y;
                    x = (34 * x + 1) * x % 289;
                    x = frac(x / 41) * 2 - 1;
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { 
                        float2 p = UV * Scale;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                    {
                        Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                    }
                
                    void Unity_Absolute_float(float In, out float Out)
                    {
                        Out = abs(In);
                    }
                
                    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                    {
                        Out = smoothstep(Edge1, Edge2, In);
                    }
                
                    void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A + B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float _Distance_4D71F33C_Out_2;
                        Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_4D71F33C_Out_2);
                        float _Property_69D7AE9F_Out_0 = Vector1_2B356380;
                        float _Divide_EE7E3F48_Out_2;
                        Unity_Divide_float(_Distance_4D71F33C_Out_2, _Property_69D7AE9F_Out_0, _Divide_EE7E3F48_Out_2);
                        float _Power_1F3BC9BE_Out_2;
                        Unity_Power_float(_Divide_EE7E3F48_Out_2, 3, _Power_1F3BC9BE_Out_2);
                        float3 _Multiply_B5442326_Out_2;
                        Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_1F3BC9BE_Out_2.xxx), _Multiply_B5442326_Out_2);
                        float _Property_F656DB82_Out_0 = Vector1_8B47B562;
                        float _Property_E6FCF144_Out_0 = Vector1_DD2A7971;
                        float4 _Property_4CE5882F_Out_0 = Vector4_4FE19BDB;
                        float _Split_6C3848B1_R_1 = _Property_4CE5882F_Out_0[0];
                        float _Split_6C3848B1_G_2 = _Property_4CE5882F_Out_0[1];
                        float _Split_6C3848B1_B_3 = _Property_4CE5882F_Out_0[2];
                        float _Split_6C3848B1_A_4 = _Property_4CE5882F_Out_0[3];
                        float3 _RotateAboutAxis_5D606F9C_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_4CE5882F_Out_0.xyz), _Split_6C3848B1_A_4, _RotateAboutAxis_5D606F9C_Out_3);
                        float _Property_D1CCB3D3_Out_0 = Vector1_BB19229D;
                        float _Multiply_C1DBBF46_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_D1CCB3D3_Out_0, _Multiply_C1DBBF46_Out_2);
                        float2 _TilingAndOffset_D9156ED9_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_C1DBBF46_Out_2.xx), _TilingAndOffset_D9156ED9_Out_3);
                        float _Property_12322142_Out_0 = Vector1_97EA0DEA;
                        float _GradientNoise_AB0C880E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_D9156ED9_Out_3, _Property_12322142_Out_0, _GradientNoise_AB0C880E_Out_2);
                        float2 _TilingAndOffset_7FBE33C6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7FBE33C6_Out_3);
                        float _GradientNoise_F3C2A41D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7FBE33C6_Out_3, _Property_12322142_Out_0, _GradientNoise_F3C2A41D_Out_2);
                        float _Add_20294542_Out_2;
                        Unity_Add_float(_GradientNoise_AB0C880E_Out_2, _GradientNoise_F3C2A41D_Out_2, _Add_20294542_Out_2);
                        float _Divide_99AB6A24_Out_2;
                        Unity_Divide_float(_Add_20294542_Out_2, 2, _Divide_99AB6A24_Out_2);
                        float _Saturate_9A75CBB3_Out_1;
                        Unity_Saturate_float(_Divide_99AB6A24_Out_2, _Saturate_9A75CBB3_Out_1);
                        float _Property_56CA339D_Out_0 = Vector1_7D71E79C;
                        float _Power_B404C8D5_Out_2;
                        Unity_Power_float(_Saturate_9A75CBB3_Out_1, _Property_56CA339D_Out_0, _Power_B404C8D5_Out_2);
                        float4 _Property_CBC31DB7_Out_0 = Vector4_53C3CAF3;
                        float _Split_738E9079_R_1 = _Property_CBC31DB7_Out_0[0];
                        float _Split_738E9079_G_2 = _Property_CBC31DB7_Out_0[1];
                        float _Split_738E9079_B_3 = _Property_CBC31DB7_Out_0[2];
                        float _Split_738E9079_A_4 = _Property_CBC31DB7_Out_0[3];
                        float4 _Combine_D4E1A601_RGBA_4;
                        float3 _Combine_D4E1A601_RGB_5;
                        float2 _Combine_D4E1A601_RG_6;
                        Unity_Combine_float(_Split_738E9079_R_1, _Split_738E9079_G_2, 0, 0, _Combine_D4E1A601_RGBA_4, _Combine_D4E1A601_RGB_5, _Combine_D4E1A601_RG_6);
                        float4 _Combine_B3F9DAE4_RGBA_4;
                        float3 _Combine_B3F9DAE4_RGB_5;
                        float2 _Combine_B3F9DAE4_RG_6;
                        Unity_Combine_float(_Split_738E9079_B_3, _Split_738E9079_A_4, 0, 0, _Combine_B3F9DAE4_RGBA_4, _Combine_B3F9DAE4_RGB_5, _Combine_B3F9DAE4_RG_6);
                        float _Remap_8141F08C_Out_3;
                        Unity_Remap_float(_Power_B404C8D5_Out_2, _Combine_D4E1A601_RG_6, _Combine_B3F9DAE4_RG_6, _Remap_8141F08C_Out_3);
                        float _Absolute_DA707E52_Out_1;
                        Unity_Absolute_float(_Remap_8141F08C_Out_3, _Absolute_DA707E52_Out_1);
                        float _Smoothstep_A9222CB5_Out_3;
                        Unity_Smoothstep_float(_Property_F656DB82_Out_0, _Property_E6FCF144_Out_0, _Absolute_DA707E52_Out_1, _Smoothstep_A9222CB5_Out_3);
                        float _Property_B22C6734_Out_0 = Vector1_3783F0D6;
                        float _Multiply_9C4F241C_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_B22C6734_Out_0, _Multiply_9C4F241C_Out_2);
                        float2 _TilingAndOffset_8D91A587_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_9C4F241C_Out_2.xx), _TilingAndOffset_8D91A587_Out_3);
                        float _Property_E409C129_Out_0 = Vector1_F4FD2233;
                        float _GradientNoise_81BAEB4A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_8D91A587_Out_3, _Property_E409C129_Out_0, _GradientNoise_81BAEB4A_Out_2);
                        float _Property_C4CE44E0_Out_0 = Vector1_89D9BA77;
                        float _Multiply_F5DA2647_Out_2;
                        Unity_Multiply_float(_GradientNoise_81BAEB4A_Out_2, _Property_C4CE44E0_Out_0, _Multiply_F5DA2647_Out_2);
                        float _Add_CAB25FE5_Out_2;
                        Unity_Add_float(_Smoothstep_A9222CB5_Out_3, _Multiply_F5DA2647_Out_2, _Add_CAB25FE5_Out_2);
                        float _Add_92F04FE1_Out_2;
                        Unity_Add_float(1, _Property_C4CE44E0_Out_0, _Add_92F04FE1_Out_2);
                        float _Divide_D05AE96_Out_2;
                        Unity_Divide_float(_Add_CAB25FE5_Out_2, _Add_92F04FE1_Out_2, _Divide_D05AE96_Out_2);
                        float3 _Multiply_7920D09A_Out_2;
                        Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_D05AE96_Out_2.xxx), _Multiply_7920D09A_Out_2);
                        float _Property_57371262_Out_0 = Vector1_1D2D6758;
                        float3 _Multiply_5EA79B0E_Out_2;
                        Unity_Multiply_float(_Multiply_7920D09A_Out_2, (_Property_57371262_Out_0.xxx), _Multiply_5EA79B0E_Out_2);
                        float3 _Add_52C55F7_Out_2;
                        Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_5EA79B0E_Out_2, _Add_52C55F7_Out_2);
                        float3 _Add_337FCD1B_Out_2;
                        Unity_Add_float3(_Multiply_B5442326_Out_2, _Add_52C55F7_Out_2, _Add_337FCD1B_Out_2);
                        description.VertexPosition = _Add_337FCD1B_Out_2;
                        description.VertexNormal = IN.ObjectSpaceNormal;
                        description.VertexTangent = IN.ObjectSpaceTangent;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float _SceneDepth_6A5D647C_Out_1;
                        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_6A5D647C_Out_1);
                        float4 _ScreenPosition_D5C0B977_Out_0 = IN.ScreenPosition;
                        float _Split_D7132622_R_1 = _ScreenPosition_D5C0B977_Out_0[0];
                        float _Split_D7132622_G_2 = _ScreenPosition_D5C0B977_Out_0[1];
                        float _Split_D7132622_B_3 = _ScreenPosition_D5C0B977_Out_0[2];
                        float _Split_D7132622_A_4 = _ScreenPosition_D5C0B977_Out_0[3];
                        float _Subtract_EDAEA22B_Out_2;
                        Unity_Subtract_float(_Split_D7132622_A_4, 1, _Subtract_EDAEA22B_Out_2);
                        float _Subtract_D2C21BA_Out_2;
                        Unity_Subtract_float(_SceneDepth_6A5D647C_Out_1, _Subtract_EDAEA22B_Out_2, _Subtract_D2C21BA_Out_2);
                        float _Property_E72E495F_Out_0 = Vector1_ACA8BF6B;
                        float _Divide_69800C63_Out_2;
                        Unity_Divide_float(_Subtract_D2C21BA_Out_2, _Property_E72E495F_Out_0, _Divide_69800C63_Out_2);
                        float _Saturate_30FCF87F_Out_1;
                        Unity_Saturate_float(_Divide_69800C63_Out_2, _Saturate_30FCF87F_Out_1);
                        surface.Alpha = _Saturate_30FCF87F_Out_1;
                        surface.AlphaClipThreshold = 0;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                // output.ViewSpaceNormal =             TransformWorldToViewDir(output.WorldSpaceNormal);
                // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.ObjectSpaceTangent =          input.tangentOS;
                // output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                // output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                // output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                // output.ViewSpacePosition =           TransformWorldToView(output.WorldSpacePosition);
                // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                // output.WorldSpaceViewDirection =     GetWorldSpaceNormalizeViewDir(output.WorldSpacePosition);
                // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                // output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(output.WorldSpacePosition), _ProjectionParams.x);
                // output.uv0 =                         input.uv0;
                // output.uv1 =                         input.uv1;
                // output.uv2 =                         input.uv2;
                // output.uv3 =                         input.uv3;
                // output.VertexColor =                 input.color;
                // output.BoneWeights =                 input.weights;
                // output.BoneIndices =                 input.indices;
            
                return output;
            }
            
            AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
            {
                // build graph inputs
                VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
                // Override time paramters with used one (This is required to correctly handle motion vector for vertex animation based on time)
                vertexDescriptionInputs.TimeParameters = timeParameters;
            
                // evaluate vertex graph
                VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
            
                // copy graph output to the results
                input.positionOS = vertexDescription.VertexPosition;
                input.normalOS = vertexDescription.VertexNormal;
                input.tangentOS.xyz = vertexDescription.VertexTangent;
            
                return input;
            }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    // output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    // output.texCoord0 = input.texCoord0;
                    // output.texCoord1 = input.texCoord1;
                    // output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    // output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    // output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            #endif
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    // output.WorldSpaceNormal =            input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
                    // output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    // output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    // output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    // output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    // output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    // output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    // output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            #endif
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                // surfaceData.color = surfaceDescription.Color;
        
        #if defined(DEBUG_DISPLAY) && !defined(SHADER_STAGE_RAY_TRACING)
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO
                }
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData RAY_TRACING_OPTIONAL_PARAMETERS)
            {
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky.
        #ifdef _ALPHATEST_ON
                // GENERIC_ALPHA_TEST(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        #endif
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                    HDShadowContext shadowContext = InitShadowContext();
                    float shadow;
                    float3 shadow3;
                    posInput = GetPositionInput(fragInputs.positionSS.xy, _ScreenSize.zw, fragInputs.positionSS.z, UNITY_MATRIX_I_VP, UNITY_MATRIX_V);
                    float3 normalWS = normalize(fragInputs.tangentToWorld[1]);
                    uint renderingLayers = _EnableLightLayers ? asuint(unity_RenderingLayer.x) : DEFAULT_LIGHT_LAYERS;
                    ShadowLoopMin(shadowContext, posInput, normalWS, asuint(_ShadowMatteFilter), renderingLayers, shadow3);
                    shadow = dot(shadow3, float3(1.0f/3.0f, 1.0f/3.0f, 1.0f/3.0f));
        
                    float4 shadowColor = (1 - shadow)*surfaceDescription.ShadowTint.rgba;
                    float  localAlpha  = saturate(shadowColor.a + surfaceDescription.Alpha);
        
                    // Keep the nested lerp
                    // With no Color (bsdfData.color.rgb, bsdfData.color.a == 0.0f), just use ShadowColor*Color to avoid a ring of "white" around the shadow
                    // And mix color to consider the Color & ShadowColor alpha (from texture or/and color picker)
                    #ifdef _SURFACE_TYPE_TRANSPARENT
                        surfaceData.color = lerp(shadowColor.rgb*surfaceData.color, lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow), surfaceDescription.Alpha);
                    #else
                        surfaceData.color = lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow);
                    #endif
                    localAlpha = ApplyBlendMode(surfaceData.color, localAlpha).a;
        
                    surfaceDescription.Alpha = localAlpha;
                #endif
        
                // Builtin Data
                ZERO_INITIALIZE(BuiltinData, builtinData); // No call to InitBuiltinData as we don't have any lighting
                builtinData.opacity = surfaceDescription.Alpha;
        
                // builtinData.emissiveColor = surfaceDescription.Emission;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #endif
                RAY_TRACING_OPTIONAL_ALPHA_TEST_PASS
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassMotionVectors.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDUnlitPass.template
            Name "ForwardOnly"
            Tags { "LightMode" = "ForwardOnly" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            Blend [_SrcBlend] [_DstBlend], [_AlphaSrcBlend] [_AlphaDstBlend]
        
            Cull [_CullMode]
        
            ZTest [_ZTestTransparent]
        
            ZWrite [_ZWrite]
        
            
            // Stencil setup
        Stencil
        {
           WriteMask [_StencilWriteMask]
           Ref [_StencilRef]
           Comp Always
           Pass Replace
        }
        
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            //#pragma enable_d3d11_debug_symbols
        
            #pragma multi_compile_instancing
        
            //-------------------------------------------------------------------------------------
            // Graph Defines
            //-------------------------------------------------------------------------------------
                    // Shared Graph Keywords
                #define SHADERPASS SHADERPASS_FORWARD_UNLIT
                #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
                #pragma multi_compile _ DEBUG_DISPLAY
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   AlphaFog
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.WorldSpaceNormal
                //   SurfaceDescriptionInputs.WorldSpaceViewDirection
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   SurfaceDescriptionInputs.TimeParameters
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.WorldSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.ObjectSpacePosition
                //   VertexDescriptionInputs.WorldSpacePosition
                //   VertexDescriptionInputs.TimeParameters
                //   SurfaceDescription.Color
                //   SurfaceDescription.Alpha
                //   SurfaceDescription.AlphaClipThreshold
                //   SurfaceDescription.Emission
                //   features.modifyMesh
                //   VertexDescription.VertexPosition
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   FragInputs.tangentToWorld
                //   FragInputs.positionRWS
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.positionOS
                //   VaryingsMeshToPS.tangentWS
                //   VaryingsMeshToPS.normalWS
                //   VaryingsMeshToPS.positionRWS
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Variant
            //-------------------------------------------------------------------------------------
        
            // #pragma shader_feature_local _DOUBLESIDED_ON - We have no lighting, so no need to have this combination for shader, the option will just disable backface culling
        
            // Keyword for transparent
            #pragma shader_feature _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
            #pragma shader_feature_local _ALPHATEST_ON
        
            #pragma shader_feature_local        _ENABLE_FOG_ON_TRANSPARENT
            // #define _ADD_PRECOMPUTED_VELOCITY
            // #define _ENABLE_SHADOW_MATTE
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Shader stages
            //-------------------------------------------------------------------------------------
                    #pragma vertex Vert
                #pragma fragment Frag
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Active Field Defines
            //-------------------------------------------------------------------------------------
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            // #define ATTRIBUTES_NEED_TEXCOORD0
            // #define ATTRIBUTES_NEED_TEXCOORD1
            // #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            // #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            // #define VARYINGS_NEED_TEXCOORD0
            // #define VARYINGS_NEED_TEXCOORD1
            // #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            // #define VARYINGS_NEED_COLOR
            // #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                #define LIGHTLOOP_DISABLE_TILE_AND_CLUSTER
                #define HAS_LIGHTLOOP
                #define SHADOW_OPTIMIZE_REGISTER_USAGE 1
        
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonLighting.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Shadow/HDShadowContext.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadow.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/PunctualLightCommon.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadowLoop.hlsl"
            #endif
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
            
        #if !defined(SHADER_STAGE_RAY_TRACING)
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracing.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracingLightLoop.hlsl"
        
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/Deferred/RaytracingIntersectonGBuffer.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingIntersection.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/NormalBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/StandardLit/StandardLit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/UnlitRaytracing.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingCommon.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #endif
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION;
                float3 positionRWS; // optional
                float3 normalWS; // optional
                float4 tangentWS; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
                float4 interp02 : TEXCOORD2; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output = (VaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output = (VaryingsMeshToDS)0;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Vector4_4FE19BDB;
                    float Vector1_97EA0DEA;
                    float Vector1_BB19229D;
                    float Vector1_1D2D6758;
                    float4 Vector4_53C3CAF3;
                    float4 Color_5100B6B6;
                    float4 Color_9F979F9B;
                    float Vector1_8B47B562;
                    float Vector1_DD2A7971;
                    float Vector1_7D71E79C;
                    float Vector1_F4FD2233;
                    float Vector1_3783F0D6;
                    float Vector1_89D9BA77;
                    float Vector1_8F52779E;
                    float Vector1_2B356380;
                    float Vector1_7892E05E;
                    float Vector1_4386BB13;
                    float Vector1_ACA8BF6B;
                    float4 _EmissionColor;
                    float _RenderQueueType;
                    float _StencilRef;
                    float _StencilWriteMask;
                    float _StencilRefDepth;
                    float _StencilWriteMaskDepth;
                    float _StencilRefMV;
                    float _StencilWriteMaskMV;
                    float _StencilRefDistortionVec;
                    float _StencilWriteMaskDistortionVec;
                    float _StencilWriteMaskGBuffer;
                    float _StencilRefGBuffer;
                    float _ZTestGBuffer;
                    float _RequireSplitLighting;
                    float _ReceivesSSR;
                    float _SurfaceType;
                    float _BlendMode;
                    float _SrcBlend;
                    float _DstBlend;
                    float _AlphaSrcBlend;
                    float _AlphaDstBlend;
                    float _ZWrite;
                    float _TransparentZWrite;
                    float _CullMode;
                    float _TransparentSortPriority;
                    float _EnableFogOnTransparent;
                    float _CullModeForward;
                    float _TransparentCullMode;
                    float _ZTestDepthEqualForOpaque;
                    float _ZTestTransparent;
                    float _TransparentBackfaceEnable;
                    float _AlphaCutoffEnable;
                    float _UseShadowThreshold;
                    float _DoubleSidedEnable;
                    float _DoubleSidedNormalMode;
                    float4 _DoubleSidedConstants;
                    float _TransparentDepthPrepassEnable;
                    float _TransparentDepthPostpassEnable;
                    CBUFFER_END
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs
                    {
                        float3 ObjectSpaceNormal; // optional
                        float3 WorldSpaceNormal; // optional
                        float3 ObjectSpaceTangent; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 VertexPosition;
                        float3 VertexNormal;
                        float3 VertexTangent;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpaceNormal; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 WorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Color;
                        float Alpha;
                        float AlphaClipThreshold;
                        float3 Emission;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
                    {
                        Rotation = radians(Rotation);
                
                        float s = sin(Rotation);
                        float c = cos(Rotation);
                        float one_minus_c = 1.0 - c;
                        
                        Axis = normalize(Axis);
                
                        float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                                  one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                                  one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                                };
                
                        Out = mul(rot_mat,  In);
                    }
                
                    void Unity_Multiply_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
                float2 Unity_GradientNoise_Dir_float(float2 p)
                {
                    // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                    p = p % 289;
                    float x = (34 * p.x + 1) * p.x % 289 + p.y;
                    x = (34 * x + 1) * x % 289;
                    x = frac(x / 41) * 2 - 1;
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { 
                        float2 p = UV * Scale;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }
                
                    void Unity_Saturate_float(float In, out float Out)
                    {
                        Out = saturate(In);
                    }
                
                    void Unity_Power_float(float A, float B, out float Out)
                    {
                        Out = pow(A, B);
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                    {
                        Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                    }
                
                    void Unity_Absolute_float(float In, out float Out)
                    {
                        Out = abs(In);
                    }
                
                    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                    {
                        Out = smoothstep(Edge1, Edge2, In);
                    }
                
                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
                    {
                        Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
                    }
                
                    void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
                    {
                        Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Distance_float3(float3 A, float3 B, out float Out)
                    {
                        Out = distance(A, B);
                    }
                
                    void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A + B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float _Distance_4D71F33C_Out_2;
                        Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_4D71F33C_Out_2);
                        float _Property_69D7AE9F_Out_0 = Vector1_2B356380;
                        float _Divide_EE7E3F48_Out_2;
                        Unity_Divide_float(_Distance_4D71F33C_Out_2, _Property_69D7AE9F_Out_0, _Divide_EE7E3F48_Out_2);
                        float _Power_1F3BC9BE_Out_2;
                        Unity_Power_float(_Divide_EE7E3F48_Out_2, 3, _Power_1F3BC9BE_Out_2);
                        float3 _Multiply_B5442326_Out_2;
                        Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_1F3BC9BE_Out_2.xxx), _Multiply_B5442326_Out_2);
                        float _Property_F656DB82_Out_0 = Vector1_8B47B562;
                        float _Property_E6FCF144_Out_0 = Vector1_DD2A7971;
                        float4 _Property_4CE5882F_Out_0 = Vector4_4FE19BDB;
                        float _Split_6C3848B1_R_1 = _Property_4CE5882F_Out_0[0];
                        float _Split_6C3848B1_G_2 = _Property_4CE5882F_Out_0[1];
                        float _Split_6C3848B1_B_3 = _Property_4CE5882F_Out_0[2];
                        float _Split_6C3848B1_A_4 = _Property_4CE5882F_Out_0[3];
                        float3 _RotateAboutAxis_5D606F9C_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_4CE5882F_Out_0.xyz), _Split_6C3848B1_A_4, _RotateAboutAxis_5D606F9C_Out_3);
                        float _Property_D1CCB3D3_Out_0 = Vector1_BB19229D;
                        float _Multiply_C1DBBF46_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_D1CCB3D3_Out_0, _Multiply_C1DBBF46_Out_2);
                        float2 _TilingAndOffset_D9156ED9_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_C1DBBF46_Out_2.xx), _TilingAndOffset_D9156ED9_Out_3);
                        float _Property_12322142_Out_0 = Vector1_97EA0DEA;
                        float _GradientNoise_AB0C880E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_D9156ED9_Out_3, _Property_12322142_Out_0, _GradientNoise_AB0C880E_Out_2);
                        float2 _TilingAndOffset_7FBE33C6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7FBE33C6_Out_3);
                        float _GradientNoise_F3C2A41D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7FBE33C6_Out_3, _Property_12322142_Out_0, _GradientNoise_F3C2A41D_Out_2);
                        float _Add_20294542_Out_2;
                        Unity_Add_float(_GradientNoise_AB0C880E_Out_2, _GradientNoise_F3C2A41D_Out_2, _Add_20294542_Out_2);
                        float _Divide_99AB6A24_Out_2;
                        Unity_Divide_float(_Add_20294542_Out_2, 2, _Divide_99AB6A24_Out_2);
                        float _Saturate_9A75CBB3_Out_1;
                        Unity_Saturate_float(_Divide_99AB6A24_Out_2, _Saturate_9A75CBB3_Out_1);
                        float _Property_56CA339D_Out_0 = Vector1_7D71E79C;
                        float _Power_B404C8D5_Out_2;
                        Unity_Power_float(_Saturate_9A75CBB3_Out_1, _Property_56CA339D_Out_0, _Power_B404C8D5_Out_2);
                        float4 _Property_CBC31DB7_Out_0 = Vector4_53C3CAF3;
                        float _Split_738E9079_R_1 = _Property_CBC31DB7_Out_0[0];
                        float _Split_738E9079_G_2 = _Property_CBC31DB7_Out_0[1];
                        float _Split_738E9079_B_3 = _Property_CBC31DB7_Out_0[2];
                        float _Split_738E9079_A_4 = _Property_CBC31DB7_Out_0[3];
                        float4 _Combine_D4E1A601_RGBA_4;
                        float3 _Combine_D4E1A601_RGB_5;
                        float2 _Combine_D4E1A601_RG_6;
                        Unity_Combine_float(_Split_738E9079_R_1, _Split_738E9079_G_2, 0, 0, _Combine_D4E1A601_RGBA_4, _Combine_D4E1A601_RGB_5, _Combine_D4E1A601_RG_6);
                        float4 _Combine_B3F9DAE4_RGBA_4;
                        float3 _Combine_B3F9DAE4_RGB_5;
                        float2 _Combine_B3F9DAE4_RG_6;
                        Unity_Combine_float(_Split_738E9079_B_3, _Split_738E9079_A_4, 0, 0, _Combine_B3F9DAE4_RGBA_4, _Combine_B3F9DAE4_RGB_5, _Combine_B3F9DAE4_RG_6);
                        float _Remap_8141F08C_Out_3;
                        Unity_Remap_float(_Power_B404C8D5_Out_2, _Combine_D4E1A601_RG_6, _Combine_B3F9DAE4_RG_6, _Remap_8141F08C_Out_3);
                        float _Absolute_DA707E52_Out_1;
                        Unity_Absolute_float(_Remap_8141F08C_Out_3, _Absolute_DA707E52_Out_1);
                        float _Smoothstep_A9222CB5_Out_3;
                        Unity_Smoothstep_float(_Property_F656DB82_Out_0, _Property_E6FCF144_Out_0, _Absolute_DA707E52_Out_1, _Smoothstep_A9222CB5_Out_3);
                        float _Property_B22C6734_Out_0 = Vector1_3783F0D6;
                        float _Multiply_9C4F241C_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_B22C6734_Out_0, _Multiply_9C4F241C_Out_2);
                        float2 _TilingAndOffset_8D91A587_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_9C4F241C_Out_2.xx), _TilingAndOffset_8D91A587_Out_3);
                        float _Property_E409C129_Out_0 = Vector1_F4FD2233;
                        float _GradientNoise_81BAEB4A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_8D91A587_Out_3, _Property_E409C129_Out_0, _GradientNoise_81BAEB4A_Out_2);
                        float _Property_C4CE44E0_Out_0 = Vector1_89D9BA77;
                        float _Multiply_F5DA2647_Out_2;
                        Unity_Multiply_float(_GradientNoise_81BAEB4A_Out_2, _Property_C4CE44E0_Out_0, _Multiply_F5DA2647_Out_2);
                        float _Add_CAB25FE5_Out_2;
                        Unity_Add_float(_Smoothstep_A9222CB5_Out_3, _Multiply_F5DA2647_Out_2, _Add_CAB25FE5_Out_2);
                        float _Add_92F04FE1_Out_2;
                        Unity_Add_float(1, _Property_C4CE44E0_Out_0, _Add_92F04FE1_Out_2);
                        float _Divide_D05AE96_Out_2;
                        Unity_Divide_float(_Add_CAB25FE5_Out_2, _Add_92F04FE1_Out_2, _Divide_D05AE96_Out_2);
                        float3 _Multiply_7920D09A_Out_2;
                        Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_D05AE96_Out_2.xxx), _Multiply_7920D09A_Out_2);
                        float _Property_57371262_Out_0 = Vector1_1D2D6758;
                        float3 _Multiply_5EA79B0E_Out_2;
                        Unity_Multiply_float(_Multiply_7920D09A_Out_2, (_Property_57371262_Out_0.xxx), _Multiply_5EA79B0E_Out_2);
                        float3 _Add_52C55F7_Out_2;
                        Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_5EA79B0E_Out_2, _Add_52C55F7_Out_2);
                        float3 _Add_337FCD1B_Out_2;
                        Unity_Add_float3(_Multiply_B5442326_Out_2, _Add_52C55F7_Out_2, _Add_337FCD1B_Out_2);
                        description.VertexPosition = _Add_337FCD1B_Out_2;
                        description.VertexNormal = IN.ObjectSpaceNormal;
                        description.VertexTangent = IN.ObjectSpaceTangent;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _Property_539FFD11_Out_0 = Color_5100B6B6;
                        float4 _Property_23C63215_Out_0 = Color_9F979F9B;
                        float _Property_F656DB82_Out_0 = Vector1_8B47B562;
                        float _Property_E6FCF144_Out_0 = Vector1_DD2A7971;
                        float4 _Property_4CE5882F_Out_0 = Vector4_4FE19BDB;
                        float _Split_6C3848B1_R_1 = _Property_4CE5882F_Out_0[0];
                        float _Split_6C3848B1_G_2 = _Property_4CE5882F_Out_0[1];
                        float _Split_6C3848B1_B_3 = _Property_4CE5882F_Out_0[2];
                        float _Split_6C3848B1_A_4 = _Property_4CE5882F_Out_0[3];
                        float3 _RotateAboutAxis_5D606F9C_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_4CE5882F_Out_0.xyz), _Split_6C3848B1_A_4, _RotateAboutAxis_5D606F9C_Out_3);
                        float _Property_D1CCB3D3_Out_0 = Vector1_BB19229D;
                        float _Multiply_C1DBBF46_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_D1CCB3D3_Out_0, _Multiply_C1DBBF46_Out_2);
                        float2 _TilingAndOffset_D9156ED9_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_C1DBBF46_Out_2.xx), _TilingAndOffset_D9156ED9_Out_3);
                        float _Property_12322142_Out_0 = Vector1_97EA0DEA;
                        float _GradientNoise_AB0C880E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_D9156ED9_Out_3, _Property_12322142_Out_0, _GradientNoise_AB0C880E_Out_2);
                        float2 _TilingAndOffset_7FBE33C6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7FBE33C6_Out_3);
                        float _GradientNoise_F3C2A41D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7FBE33C6_Out_3, _Property_12322142_Out_0, _GradientNoise_F3C2A41D_Out_2);
                        float _Add_20294542_Out_2;
                        Unity_Add_float(_GradientNoise_AB0C880E_Out_2, _GradientNoise_F3C2A41D_Out_2, _Add_20294542_Out_2);
                        float _Divide_99AB6A24_Out_2;
                        Unity_Divide_float(_Add_20294542_Out_2, 2, _Divide_99AB6A24_Out_2);
                        float _Saturate_9A75CBB3_Out_1;
                        Unity_Saturate_float(_Divide_99AB6A24_Out_2, _Saturate_9A75CBB3_Out_1);
                        float _Property_56CA339D_Out_0 = Vector1_7D71E79C;
                        float _Power_B404C8D5_Out_2;
                        Unity_Power_float(_Saturate_9A75CBB3_Out_1, _Property_56CA339D_Out_0, _Power_B404C8D5_Out_2);
                        float4 _Property_CBC31DB7_Out_0 = Vector4_53C3CAF3;
                        float _Split_738E9079_R_1 = _Property_CBC31DB7_Out_0[0];
                        float _Split_738E9079_G_2 = _Property_CBC31DB7_Out_0[1];
                        float _Split_738E9079_B_3 = _Property_CBC31DB7_Out_0[2];
                        float _Split_738E9079_A_4 = _Property_CBC31DB7_Out_0[3];
                        float4 _Combine_D4E1A601_RGBA_4;
                        float3 _Combine_D4E1A601_RGB_5;
                        float2 _Combine_D4E1A601_RG_6;
                        Unity_Combine_float(_Split_738E9079_R_1, _Split_738E9079_G_2, 0, 0, _Combine_D4E1A601_RGBA_4, _Combine_D4E1A601_RGB_5, _Combine_D4E1A601_RG_6);
                        float4 _Combine_B3F9DAE4_RGBA_4;
                        float3 _Combine_B3F9DAE4_RGB_5;
                        float2 _Combine_B3F9DAE4_RG_6;
                        Unity_Combine_float(_Split_738E9079_B_3, _Split_738E9079_A_4, 0, 0, _Combine_B3F9DAE4_RGBA_4, _Combine_B3F9DAE4_RGB_5, _Combine_B3F9DAE4_RG_6);
                        float _Remap_8141F08C_Out_3;
                        Unity_Remap_float(_Power_B404C8D5_Out_2, _Combine_D4E1A601_RG_6, _Combine_B3F9DAE4_RG_6, _Remap_8141F08C_Out_3);
                        float _Absolute_DA707E52_Out_1;
                        Unity_Absolute_float(_Remap_8141F08C_Out_3, _Absolute_DA707E52_Out_1);
                        float _Smoothstep_A9222CB5_Out_3;
                        Unity_Smoothstep_float(_Property_F656DB82_Out_0, _Property_E6FCF144_Out_0, _Absolute_DA707E52_Out_1, _Smoothstep_A9222CB5_Out_3);
                        float _Property_B22C6734_Out_0 = Vector1_3783F0D6;
                        float _Multiply_9C4F241C_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_B22C6734_Out_0, _Multiply_9C4F241C_Out_2);
                        float2 _TilingAndOffset_8D91A587_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_9C4F241C_Out_2.xx), _TilingAndOffset_8D91A587_Out_3);
                        float _Property_E409C129_Out_0 = Vector1_F4FD2233;
                        float _GradientNoise_81BAEB4A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_8D91A587_Out_3, _Property_E409C129_Out_0, _GradientNoise_81BAEB4A_Out_2);
                        float _Property_C4CE44E0_Out_0 = Vector1_89D9BA77;
                        float _Multiply_F5DA2647_Out_2;
                        Unity_Multiply_float(_GradientNoise_81BAEB4A_Out_2, _Property_C4CE44E0_Out_0, _Multiply_F5DA2647_Out_2);
                        float _Add_CAB25FE5_Out_2;
                        Unity_Add_float(_Smoothstep_A9222CB5_Out_3, _Multiply_F5DA2647_Out_2, _Add_CAB25FE5_Out_2);
                        float _Add_92F04FE1_Out_2;
                        Unity_Add_float(1, _Property_C4CE44E0_Out_0, _Add_92F04FE1_Out_2);
                        float _Divide_D05AE96_Out_2;
                        Unity_Divide_float(_Add_CAB25FE5_Out_2, _Add_92F04FE1_Out_2, _Divide_D05AE96_Out_2);
                        float4 _Lerp_608D51B5_Out_3;
                        Unity_Lerp_float4(_Property_539FFD11_Out_0, _Property_23C63215_Out_0, (_Divide_D05AE96_Out_2.xxxx), _Lerp_608D51B5_Out_3);
                        float _Property_189FD6C_Out_0 = Vector1_7892E05E;
                        float _FresnelEffect_83E7E861_Out_3;
                        Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_189FD6C_Out_0, _FresnelEffect_83E7E861_Out_3);
                        float _Multiply_377CD458_Out_2;
                        Unity_Multiply_float(_Divide_D05AE96_Out_2, _FresnelEffect_83E7E861_Out_3, _Multiply_377CD458_Out_2);
                        float _Property_AA57477D_Out_0 = Vector1_4386BB13;
                        float _Multiply_A59FF53_Out_2;
                        Unity_Multiply_float(_Multiply_377CD458_Out_2, _Property_AA57477D_Out_0, _Multiply_A59FF53_Out_2);
                        float4 _Add_13002516_Out_2;
                        Unity_Add_float4(_Lerp_608D51B5_Out_3, (_Multiply_A59FF53_Out_2.xxxx), _Add_13002516_Out_2);
                        float _SceneDepth_6A5D647C_Out_1;
                        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_6A5D647C_Out_1);
                        float4 _ScreenPosition_D5C0B977_Out_0 = IN.ScreenPosition;
                        float _Split_D7132622_R_1 = _ScreenPosition_D5C0B977_Out_0[0];
                        float _Split_D7132622_G_2 = _ScreenPosition_D5C0B977_Out_0[1];
                        float _Split_D7132622_B_3 = _ScreenPosition_D5C0B977_Out_0[2];
                        float _Split_D7132622_A_4 = _ScreenPosition_D5C0B977_Out_0[3];
                        float _Subtract_EDAEA22B_Out_2;
                        Unity_Subtract_float(_Split_D7132622_A_4, 1, _Subtract_EDAEA22B_Out_2);
                        float _Subtract_D2C21BA_Out_2;
                        Unity_Subtract_float(_SceneDepth_6A5D647C_Out_1, _Subtract_EDAEA22B_Out_2, _Subtract_D2C21BA_Out_2);
                        float _Property_E72E495F_Out_0 = Vector1_ACA8BF6B;
                        float _Divide_69800C63_Out_2;
                        Unity_Divide_float(_Subtract_D2C21BA_Out_2, _Property_E72E495F_Out_0, _Divide_69800C63_Out_2);
                        float _Saturate_30FCF87F_Out_1;
                        Unity_Saturate_float(_Divide_69800C63_Out_2, _Saturate_30FCF87F_Out_1);
                        float _Property_27256254_Out_0 = Vector1_8F52779E;
                        float4 _Multiply_D88E026_Out_2;
                        Unity_Multiply_float(_Add_13002516_Out_2, (_Property_27256254_Out_0.xxxx), _Multiply_D88E026_Out_2);
                        surface.Color = (_Add_13002516_Out_2.xyz);
                        surface.Alpha = _Saturate_30FCF87F_Out_1;
                        surface.AlphaClipThreshold = 0;
                        surface.Emission = (_Multiply_D88E026_Out_2.xyz);
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                // output.ViewSpaceNormal =             TransformWorldToViewDir(output.WorldSpaceNormal);
                // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.ObjectSpaceTangent =          input.tangentOS;
                // output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                // output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                // output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                // output.ViewSpacePosition =           TransformWorldToView(output.WorldSpacePosition);
                // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                // output.WorldSpaceViewDirection =     GetWorldSpaceNormalizeViewDir(output.WorldSpacePosition);
                // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                // output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(output.WorldSpacePosition), _ProjectionParams.x);
                // output.uv0 =                         input.uv0;
                // output.uv1 =                         input.uv1;
                // output.uv2 =                         input.uv2;
                // output.uv3 =                         input.uv3;
                // output.VertexColor =                 input.color;
                // output.BoneWeights =                 input.weights;
                // output.BoneIndices =                 input.indices;
            
                return output;
            }
            
            AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
            {
                // build graph inputs
                VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
                // Override time paramters with used one (This is required to correctly handle motion vector for vertex animation based on time)
                vertexDescriptionInputs.TimeParameters = timeParameters;
            
                // evaluate vertex graph
                VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
            
                // copy graph output to the results
                input.positionOS = vertexDescription.VertexPosition;
                input.normalOS = vertexDescription.VertexNormal;
                input.tangentOS.xyz = vertexDescription.VertexTangent;
            
                return input;
            }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    // output.texCoord0 = input.texCoord0;
                    // output.texCoord1 = input.texCoord1;
                    // output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    // output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    // output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            #endif
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    output.WorldSpaceNormal =            input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
                    // output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    // output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    // output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    // output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    // output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            #endif
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                surfaceData.color = surfaceDescription.Color;
        
        #if defined(DEBUG_DISPLAY) && !defined(SHADER_STAGE_RAY_TRACING)
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO
                }
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData RAY_TRACING_OPTIONAL_PARAMETERS)
            {
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky.
        #ifdef _ALPHATEST_ON
                // GENERIC_ALPHA_TEST(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        #endif
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                    HDShadowContext shadowContext = InitShadowContext();
                    float shadow;
                    float3 shadow3;
                    posInput = GetPositionInput(fragInputs.positionSS.xy, _ScreenSize.zw, fragInputs.positionSS.z, UNITY_MATRIX_I_VP, UNITY_MATRIX_V);
                    float3 normalWS = normalize(fragInputs.tangentToWorld[1]);
                    uint renderingLayers = _EnableLightLayers ? asuint(unity_RenderingLayer.x) : DEFAULT_LIGHT_LAYERS;
                    ShadowLoopMin(shadowContext, posInput, normalWS, asuint(_ShadowMatteFilter), renderingLayers, shadow3);
                    shadow = dot(shadow3, float3(1.0f/3.0f, 1.0f/3.0f, 1.0f/3.0f));
        
                    float4 shadowColor = (1 - shadow)*surfaceDescription.ShadowTint.rgba;
                    float  localAlpha  = saturate(shadowColor.a + surfaceDescription.Alpha);
        
                    // Keep the nested lerp
                    // With no Color (bsdfData.color.rgb, bsdfData.color.a == 0.0f), just use ShadowColor*Color to avoid a ring of "white" around the shadow
                    // And mix color to consider the Color & ShadowColor alpha (from texture or/and color picker)
                    #ifdef _SURFACE_TYPE_TRANSPARENT
                        surfaceData.color = lerp(shadowColor.rgb*surfaceData.color, lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow), surfaceDescription.Alpha);
                    #else
                        surfaceData.color = lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow);
                    #endif
                    localAlpha = ApplyBlendMode(surfaceData.color, localAlpha).a;
        
                    surfaceDescription.Alpha = localAlpha;
                #endif
        
                // Builtin Data
                ZERO_INITIALIZE(BuiltinData, builtinData); // No call to InitBuiltinData as we don't have any lighting
                builtinData.opacity = surfaceDescription.Alpha;
        
                builtinData.emissiveColor = surfaceDescription.Emission;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #endif
                RAY_TRACING_OPTIONAL_ALPHA_TEST_PASS
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassForwardUnlit.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="HDRenderPipeline"
        }
        
        Pass
        {
            // based on HDUnlitPass.template
            Name "IndirectDXR"
            Tags { "LightMode" = "IndirectDXR" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            
            
            
            
            
            
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            //#pragma enable_d3d11_debug_symbols
        
            
        
            //-------------------------------------------------------------------------------------
            // Graph Defines
            //-------------------------------------------------------------------------------------
                    // Shared Graph Keywords
                #define SHADERPASS SHADERPASS_RAYTRACING_INDIRECT
                #pragma only_renderers d3d11
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   AlphaFog
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.WorldSpaceNormal
                //   SurfaceDescriptionInputs.WorldSpaceViewDirection
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   SurfaceDescriptionInputs.TimeParameters
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.WorldSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.WorldSpaceViewDirection
                //   VertexDescriptionInputs.WorldSpacePosition
                //   VertexDescriptionInputs.TimeParameters
                //   SurfaceDescription.Color
                //   SurfaceDescription.Alpha
                //   SurfaceDescription.AlphaClipThreshold
                //   SurfaceDescription.Emission
                //   features.modifyMesh
                //   VertexDescription.Color
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   FragInputs.tangentToWorld
                //   FragInputs.positionRWS
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.positionOS
                //   VaryingsMeshToPS.tangentWS
                //   VaryingsMeshToPS.normalWS
                //   VaryingsMeshToPS.positionRWS
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Variant
            //-------------------------------------------------------------------------------------
        
            // #pragma shader_feature_local _DOUBLESIDED_ON - We have no lighting, so no need to have this combination for shader, the option will just disable backface culling
        
            // Keyword for transparent
            #pragma shader_feature _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
            #pragma shader_feature_local _ALPHATEST_ON
        
            #pragma shader_feature_local        _ENABLE_FOG_ON_TRANSPARENT
            // #define _ADD_PRECOMPUTED_VELOCITY
            // #define _ENABLE_SHADOW_MATTE
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Shader stages
            //-------------------------------------------------------------------------------------
                    #pragma raytracing surface_shader
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Active Field Defines
            //-------------------------------------------------------------------------------------
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            // #define ATTRIBUTES_NEED_TEXCOORD0
            // #define ATTRIBUTES_NEED_TEXCOORD1
            // #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            // #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            // #define VARYINGS_NEED_TEXCOORD0
            // #define VARYINGS_NEED_TEXCOORD1
            // #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            // #define VARYINGS_NEED_COLOR
            // #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                #define LIGHTLOOP_DISABLE_TILE_AND_CLUSTER
                #define HAS_LIGHTLOOP
                #define SHADOW_OPTIMIZE_REGISTER_USAGE 1
        
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonLighting.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Shadow/HDShadowContext.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadow.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/PunctualLightCommon.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadowLoop.hlsl"
            #endif
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
            
        #if !defined(SHADER_STAGE_RAY_TRACING)
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracing.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracingLightLoop.hlsl"
        
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/Deferred/RaytracingIntersectonGBuffer.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingIntersection.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/NormalBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/StandardLit/StandardLit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/UnlitRaytracing.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingCommon.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #endif
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION;
                float3 positionRWS; // optional
                float3 normalWS; // optional
                float4 tangentWS; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
                float4 interp02 : TEXCOORD2; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output = (VaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output = (VaryingsMeshToDS)0;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Vector4_4FE19BDB;
                    float Vector1_97EA0DEA;
                    float Vector1_BB19229D;
                    float Vector1_1D2D6758;
                    float4 Vector4_53C3CAF3;
                    float4 Color_5100B6B6;
                    float4 Color_9F979F9B;
                    float Vector1_8B47B562;
                    float Vector1_DD2A7971;
                    float Vector1_7D71E79C;
                    float Vector1_F4FD2233;
                    float Vector1_3783F0D6;
                    float Vector1_89D9BA77;
                    float Vector1_8F52779E;
                    float Vector1_2B356380;
                    float Vector1_7892E05E;
                    float Vector1_4386BB13;
                    float Vector1_ACA8BF6B;
                    float4 _EmissionColor;
                    float _RenderQueueType;
                    float _StencilRef;
                    float _StencilWriteMask;
                    float _StencilRefDepth;
                    float _StencilWriteMaskDepth;
                    float _StencilRefMV;
                    float _StencilWriteMaskMV;
                    float _StencilRefDistortionVec;
                    float _StencilWriteMaskDistortionVec;
                    float _StencilWriteMaskGBuffer;
                    float _StencilRefGBuffer;
                    float _ZTestGBuffer;
                    float _RequireSplitLighting;
                    float _ReceivesSSR;
                    float _SurfaceType;
                    float _BlendMode;
                    float _SrcBlend;
                    float _DstBlend;
                    float _AlphaSrcBlend;
                    float _AlphaDstBlend;
                    float _ZWrite;
                    float _TransparentZWrite;
                    float _CullMode;
                    float _TransparentSortPriority;
                    float _EnableFogOnTransparent;
                    float _CullModeForward;
                    float _TransparentCullMode;
                    float _ZTestDepthEqualForOpaque;
                    float _ZTestTransparent;
                    float _TransparentBackfaceEnable;
                    float _AlphaCutoffEnable;
                    float _UseShadowThreshold;
                    float _DoubleSidedEnable;
                    float _DoubleSidedNormalMode;
                    float4 _DoubleSidedConstants;
                    float _TransparentDepthPrepassEnable;
                    float _TransparentDepthPostpassEnable;
                    CBUFFER_END
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs
                    {
                        float3 ObjectSpaceNormal; // optional
                        float3 WorldSpaceNormal; // optional
                        float3 ObjectSpaceTangent; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 WorldSpacePosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 Color;
                        float3 VertexNormal;
                        float3 VertexTangent;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpaceNormal; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 WorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Color;
                        float Alpha;
                        float AlphaClipThreshold;
                        float3 Emission;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
                    {
                        Rotation = radians(Rotation);
                
                        float s = sin(Rotation);
                        float c = cos(Rotation);
                        float one_minus_c = 1.0 - c;
                        
                        Axis = normalize(Axis);
                
                        float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                                  one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                                  one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                                };
                
                        Out = mul(rot_mat,  In);
                    }
                
                    void Unity_Multiply_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
                float2 Unity_GradientNoise_Dir_float(float2 p)
                {
                    // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                    p = p % 289;
                    float x = (34 * p.x + 1) * p.x % 289 + p.y;
                    x = (34 * x + 1) * x % 289;
                    x = frac(x / 41) * 2 - 1;
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { 
                        float2 p = UV * Scale;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }
                
                    void Unity_Saturate_float(float In, out float Out)
                    {
                        Out = saturate(In);
                    }
                
                    void Unity_Power_float(float A, float B, out float Out)
                    {
                        Out = pow(A, B);
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                    {
                        Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                    }
                
                    void Unity_Absolute_float(float In, out float Out)
                    {
                        Out = abs(In);
                    }
                
                    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                    {
                        Out = smoothstep(Edge1, Edge2, In);
                    }
                
                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
                    {
                        Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
                    }
                
                    void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
                    {
                        Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float4 _Property_539FFD11_Out_0 = Color_5100B6B6;
                        float4 _Property_23C63215_Out_0 = Color_9F979F9B;
                        float _Property_F656DB82_Out_0 = Vector1_8B47B562;
                        float _Property_E6FCF144_Out_0 = Vector1_DD2A7971;
                        float4 _Property_4CE5882F_Out_0 = Vector4_4FE19BDB;
                        float _Split_6C3848B1_R_1 = _Property_4CE5882F_Out_0[0];
                        float _Split_6C3848B1_G_2 = _Property_4CE5882F_Out_0[1];
                        float _Split_6C3848B1_B_3 = _Property_4CE5882F_Out_0[2];
                        float _Split_6C3848B1_A_4 = _Property_4CE5882F_Out_0[3];
                        float3 _RotateAboutAxis_5D606F9C_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_4CE5882F_Out_0.xyz), _Split_6C3848B1_A_4, _RotateAboutAxis_5D606F9C_Out_3);
                        float _Property_D1CCB3D3_Out_0 = Vector1_BB19229D;
                        float _Multiply_C1DBBF46_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_D1CCB3D3_Out_0, _Multiply_C1DBBF46_Out_2);
                        float2 _TilingAndOffset_D9156ED9_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_C1DBBF46_Out_2.xx), _TilingAndOffset_D9156ED9_Out_3);
                        float _Property_12322142_Out_0 = Vector1_97EA0DEA;
                        float _GradientNoise_AB0C880E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_D9156ED9_Out_3, _Property_12322142_Out_0, _GradientNoise_AB0C880E_Out_2);
                        float2 _TilingAndOffset_7FBE33C6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7FBE33C6_Out_3);
                        float _GradientNoise_F3C2A41D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7FBE33C6_Out_3, _Property_12322142_Out_0, _GradientNoise_F3C2A41D_Out_2);
                        float _Add_20294542_Out_2;
                        Unity_Add_float(_GradientNoise_AB0C880E_Out_2, _GradientNoise_F3C2A41D_Out_2, _Add_20294542_Out_2);
                        float _Divide_99AB6A24_Out_2;
                        Unity_Divide_float(_Add_20294542_Out_2, 2, _Divide_99AB6A24_Out_2);
                        float _Saturate_9A75CBB3_Out_1;
                        Unity_Saturate_float(_Divide_99AB6A24_Out_2, _Saturate_9A75CBB3_Out_1);
                        float _Property_56CA339D_Out_0 = Vector1_7D71E79C;
                        float _Power_B404C8D5_Out_2;
                        Unity_Power_float(_Saturate_9A75CBB3_Out_1, _Property_56CA339D_Out_0, _Power_B404C8D5_Out_2);
                        float4 _Property_CBC31DB7_Out_0 = Vector4_53C3CAF3;
                        float _Split_738E9079_R_1 = _Property_CBC31DB7_Out_0[0];
                        float _Split_738E9079_G_2 = _Property_CBC31DB7_Out_0[1];
                        float _Split_738E9079_B_3 = _Property_CBC31DB7_Out_0[2];
                        float _Split_738E9079_A_4 = _Property_CBC31DB7_Out_0[3];
                        float4 _Combine_D4E1A601_RGBA_4;
                        float3 _Combine_D4E1A601_RGB_5;
                        float2 _Combine_D4E1A601_RG_6;
                        Unity_Combine_float(_Split_738E9079_R_1, _Split_738E9079_G_2, 0, 0, _Combine_D4E1A601_RGBA_4, _Combine_D4E1A601_RGB_5, _Combine_D4E1A601_RG_6);
                        float4 _Combine_B3F9DAE4_RGBA_4;
                        float3 _Combine_B3F9DAE4_RGB_5;
                        float2 _Combine_B3F9DAE4_RG_6;
                        Unity_Combine_float(_Split_738E9079_B_3, _Split_738E9079_A_4, 0, 0, _Combine_B3F9DAE4_RGBA_4, _Combine_B3F9DAE4_RGB_5, _Combine_B3F9DAE4_RG_6);
                        float _Remap_8141F08C_Out_3;
                        Unity_Remap_float(_Power_B404C8D5_Out_2, _Combine_D4E1A601_RG_6, _Combine_B3F9DAE4_RG_6, _Remap_8141F08C_Out_3);
                        float _Absolute_DA707E52_Out_1;
                        Unity_Absolute_float(_Remap_8141F08C_Out_3, _Absolute_DA707E52_Out_1);
                        float _Smoothstep_A9222CB5_Out_3;
                        Unity_Smoothstep_float(_Property_F656DB82_Out_0, _Property_E6FCF144_Out_0, _Absolute_DA707E52_Out_1, _Smoothstep_A9222CB5_Out_3);
                        float _Property_B22C6734_Out_0 = Vector1_3783F0D6;
                        float _Multiply_9C4F241C_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_B22C6734_Out_0, _Multiply_9C4F241C_Out_2);
                        float2 _TilingAndOffset_8D91A587_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_9C4F241C_Out_2.xx), _TilingAndOffset_8D91A587_Out_3);
                        float _Property_E409C129_Out_0 = Vector1_F4FD2233;
                        float _GradientNoise_81BAEB4A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_8D91A587_Out_3, _Property_E409C129_Out_0, _GradientNoise_81BAEB4A_Out_2);
                        float _Property_C4CE44E0_Out_0 = Vector1_89D9BA77;
                        float _Multiply_F5DA2647_Out_2;
                        Unity_Multiply_float(_GradientNoise_81BAEB4A_Out_2, _Property_C4CE44E0_Out_0, _Multiply_F5DA2647_Out_2);
                        float _Add_CAB25FE5_Out_2;
                        Unity_Add_float(_Smoothstep_A9222CB5_Out_3, _Multiply_F5DA2647_Out_2, _Add_CAB25FE5_Out_2);
                        float _Add_92F04FE1_Out_2;
                        Unity_Add_float(1, _Property_C4CE44E0_Out_0, _Add_92F04FE1_Out_2);
                        float _Divide_D05AE96_Out_2;
                        Unity_Divide_float(_Add_CAB25FE5_Out_2, _Add_92F04FE1_Out_2, _Divide_D05AE96_Out_2);
                        float4 _Lerp_608D51B5_Out_3;
                        Unity_Lerp_float4(_Property_539FFD11_Out_0, _Property_23C63215_Out_0, (_Divide_D05AE96_Out_2.xxxx), _Lerp_608D51B5_Out_3);
                        float _Property_189FD6C_Out_0 = Vector1_7892E05E;
                        float _FresnelEffect_83E7E861_Out_3;
                        Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_189FD6C_Out_0, _FresnelEffect_83E7E861_Out_3);
                        float _Multiply_377CD458_Out_2;
                        Unity_Multiply_float(_Divide_D05AE96_Out_2, _FresnelEffect_83E7E861_Out_3, _Multiply_377CD458_Out_2);
                        float _Property_AA57477D_Out_0 = Vector1_4386BB13;
                        float _Multiply_A59FF53_Out_2;
                        Unity_Multiply_float(_Multiply_377CD458_Out_2, _Property_AA57477D_Out_0, _Multiply_A59FF53_Out_2);
                        float4 _Add_13002516_Out_2;
                        Unity_Add_float4(_Lerp_608D51B5_Out_3, (_Multiply_A59FF53_Out_2.xxxx), _Add_13002516_Out_2);
                        description.Color = (_Add_13002516_Out_2.xyz);
                        description.VertexNormal = IN.ObjectSpaceNormal;
                        description.VertexTangent = IN.ObjectSpaceTangent;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _Property_539FFD11_Out_0 = Color_5100B6B6;
                        float4 _Property_23C63215_Out_0 = Color_9F979F9B;
                        float _Property_F656DB82_Out_0 = Vector1_8B47B562;
                        float _Property_E6FCF144_Out_0 = Vector1_DD2A7971;
                        float4 _Property_4CE5882F_Out_0 = Vector4_4FE19BDB;
                        float _Split_6C3848B1_R_1 = _Property_4CE5882F_Out_0[0];
                        float _Split_6C3848B1_G_2 = _Property_4CE5882F_Out_0[1];
                        float _Split_6C3848B1_B_3 = _Property_4CE5882F_Out_0[2];
                        float _Split_6C3848B1_A_4 = _Property_4CE5882F_Out_0[3];
                        float3 _RotateAboutAxis_5D606F9C_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_4CE5882F_Out_0.xyz), _Split_6C3848B1_A_4, _RotateAboutAxis_5D606F9C_Out_3);
                        float _Property_D1CCB3D3_Out_0 = Vector1_BB19229D;
                        float _Multiply_C1DBBF46_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_D1CCB3D3_Out_0, _Multiply_C1DBBF46_Out_2);
                        float2 _TilingAndOffset_D9156ED9_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_C1DBBF46_Out_2.xx), _TilingAndOffset_D9156ED9_Out_3);
                        float _Property_12322142_Out_0 = Vector1_97EA0DEA;
                        float _GradientNoise_AB0C880E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_D9156ED9_Out_3, _Property_12322142_Out_0, _GradientNoise_AB0C880E_Out_2);
                        float2 _TilingAndOffset_7FBE33C6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7FBE33C6_Out_3);
                        float _GradientNoise_F3C2A41D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7FBE33C6_Out_3, _Property_12322142_Out_0, _GradientNoise_F3C2A41D_Out_2);
                        float _Add_20294542_Out_2;
                        Unity_Add_float(_GradientNoise_AB0C880E_Out_2, _GradientNoise_F3C2A41D_Out_2, _Add_20294542_Out_2);
                        float _Divide_99AB6A24_Out_2;
                        Unity_Divide_float(_Add_20294542_Out_2, 2, _Divide_99AB6A24_Out_2);
                        float _Saturate_9A75CBB3_Out_1;
                        Unity_Saturate_float(_Divide_99AB6A24_Out_2, _Saturate_9A75CBB3_Out_1);
                        float _Property_56CA339D_Out_0 = Vector1_7D71E79C;
                        float _Power_B404C8D5_Out_2;
                        Unity_Power_float(_Saturate_9A75CBB3_Out_1, _Property_56CA339D_Out_0, _Power_B404C8D5_Out_2);
                        float4 _Property_CBC31DB7_Out_0 = Vector4_53C3CAF3;
                        float _Split_738E9079_R_1 = _Property_CBC31DB7_Out_0[0];
                        float _Split_738E9079_G_2 = _Property_CBC31DB7_Out_0[1];
                        float _Split_738E9079_B_3 = _Property_CBC31DB7_Out_0[2];
                        float _Split_738E9079_A_4 = _Property_CBC31DB7_Out_0[3];
                        float4 _Combine_D4E1A601_RGBA_4;
                        float3 _Combine_D4E1A601_RGB_5;
                        float2 _Combine_D4E1A601_RG_6;
                        Unity_Combine_float(_Split_738E9079_R_1, _Split_738E9079_G_2, 0, 0, _Combine_D4E1A601_RGBA_4, _Combine_D4E1A601_RGB_5, _Combine_D4E1A601_RG_6);
                        float4 _Combine_B3F9DAE4_RGBA_4;
                        float3 _Combine_B3F9DAE4_RGB_5;
                        float2 _Combine_B3F9DAE4_RG_6;
                        Unity_Combine_float(_Split_738E9079_B_3, _Split_738E9079_A_4, 0, 0, _Combine_B3F9DAE4_RGBA_4, _Combine_B3F9DAE4_RGB_5, _Combine_B3F9DAE4_RG_6);
                        float _Remap_8141F08C_Out_3;
                        Unity_Remap_float(_Power_B404C8D5_Out_2, _Combine_D4E1A601_RG_6, _Combine_B3F9DAE4_RG_6, _Remap_8141F08C_Out_3);
                        float _Absolute_DA707E52_Out_1;
                        Unity_Absolute_float(_Remap_8141F08C_Out_3, _Absolute_DA707E52_Out_1);
                        float _Smoothstep_A9222CB5_Out_3;
                        Unity_Smoothstep_float(_Property_F656DB82_Out_0, _Property_E6FCF144_Out_0, _Absolute_DA707E52_Out_1, _Smoothstep_A9222CB5_Out_3);
                        float _Property_B22C6734_Out_0 = Vector1_3783F0D6;
                        float _Multiply_9C4F241C_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_B22C6734_Out_0, _Multiply_9C4F241C_Out_2);
                        float2 _TilingAndOffset_8D91A587_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_9C4F241C_Out_2.xx), _TilingAndOffset_8D91A587_Out_3);
                        float _Property_E409C129_Out_0 = Vector1_F4FD2233;
                        float _GradientNoise_81BAEB4A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_8D91A587_Out_3, _Property_E409C129_Out_0, _GradientNoise_81BAEB4A_Out_2);
                        float _Property_C4CE44E0_Out_0 = Vector1_89D9BA77;
                        float _Multiply_F5DA2647_Out_2;
                        Unity_Multiply_float(_GradientNoise_81BAEB4A_Out_2, _Property_C4CE44E0_Out_0, _Multiply_F5DA2647_Out_2);
                        float _Add_CAB25FE5_Out_2;
                        Unity_Add_float(_Smoothstep_A9222CB5_Out_3, _Multiply_F5DA2647_Out_2, _Add_CAB25FE5_Out_2);
                        float _Add_92F04FE1_Out_2;
                        Unity_Add_float(1, _Property_C4CE44E0_Out_0, _Add_92F04FE1_Out_2);
                        float _Divide_D05AE96_Out_2;
                        Unity_Divide_float(_Add_CAB25FE5_Out_2, _Add_92F04FE1_Out_2, _Divide_D05AE96_Out_2);
                        float4 _Lerp_608D51B5_Out_3;
                        Unity_Lerp_float4(_Property_539FFD11_Out_0, _Property_23C63215_Out_0, (_Divide_D05AE96_Out_2.xxxx), _Lerp_608D51B5_Out_3);
                        float _Property_189FD6C_Out_0 = Vector1_7892E05E;
                        float _FresnelEffect_83E7E861_Out_3;
                        Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_189FD6C_Out_0, _FresnelEffect_83E7E861_Out_3);
                        float _Multiply_377CD458_Out_2;
                        Unity_Multiply_float(_Divide_D05AE96_Out_2, _FresnelEffect_83E7E861_Out_3, _Multiply_377CD458_Out_2);
                        float _Property_AA57477D_Out_0 = Vector1_4386BB13;
                        float _Multiply_A59FF53_Out_2;
                        Unity_Multiply_float(_Multiply_377CD458_Out_2, _Property_AA57477D_Out_0, _Multiply_A59FF53_Out_2);
                        float4 _Add_13002516_Out_2;
                        Unity_Add_float4(_Lerp_608D51B5_Out_3, (_Multiply_A59FF53_Out_2.xxxx), _Add_13002516_Out_2);
                        float _SceneDepth_6A5D647C_Out_1;
                        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_6A5D647C_Out_1);
                        float4 _ScreenPosition_D5C0B977_Out_0 = IN.ScreenPosition;
                        float _Split_D7132622_R_1 = _ScreenPosition_D5C0B977_Out_0[0];
                        float _Split_D7132622_G_2 = _ScreenPosition_D5C0B977_Out_0[1];
                        float _Split_D7132622_B_3 = _ScreenPosition_D5C0B977_Out_0[2];
                        float _Split_D7132622_A_4 = _ScreenPosition_D5C0B977_Out_0[3];
                        float _Subtract_EDAEA22B_Out_2;
                        Unity_Subtract_float(_Split_D7132622_A_4, 1, _Subtract_EDAEA22B_Out_2);
                        float _Subtract_D2C21BA_Out_2;
                        Unity_Subtract_float(_SceneDepth_6A5D647C_Out_1, _Subtract_EDAEA22B_Out_2, _Subtract_D2C21BA_Out_2);
                        float _Property_E72E495F_Out_0 = Vector1_ACA8BF6B;
                        float _Divide_69800C63_Out_2;
                        Unity_Divide_float(_Subtract_D2C21BA_Out_2, _Property_E72E495F_Out_0, _Divide_69800C63_Out_2);
                        float _Saturate_30FCF87F_Out_1;
                        Unity_Saturate_float(_Divide_69800C63_Out_2, _Saturate_30FCF87F_Out_1);
                        float _Property_27256254_Out_0 = Vector1_8F52779E;
                        float4 _Multiply_D88E026_Out_2;
                        Unity_Multiply_float(_Add_13002516_Out_2, (_Property_27256254_Out_0.xxxx), _Multiply_D88E026_Out_2);
                        surface.Color = (_Add_13002516_Out_2.xyz);
                        surface.Alpha = _Saturate_30FCF87F_Out_1;
                        surface.AlphaClipThreshold = 0;
                        surface.Emission = (_Multiply_D88E026_Out_2.xyz);
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                // output.ViewSpaceNormal =             TransformWorldToViewDir(output.WorldSpaceNormal);
                // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.ObjectSpaceTangent =          input.tangentOS;
                // output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                // output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                // output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                // output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                // output.ViewSpacePosition =           TransformWorldToView(output.WorldSpacePosition);
                // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                output.WorldSpaceViewDirection =     GetWorldSpaceNormalizeViewDir(output.WorldSpacePosition);
                // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                // output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(output.WorldSpacePosition), _ProjectionParams.x);
                // output.uv0 =                         input.uv0;
                // output.uv1 =                         input.uv1;
                // output.uv2 =                         input.uv2;
                // output.uv3 =                         input.uv3;
                // output.VertexColor =                 input.color;
                // output.BoneWeights =                 input.weights;
                // output.BoneIndices =                 input.indices;
            
                return output;
            }
            
            AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
            {
                // build graph inputs
                VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
                // Override time paramters with used one (This is required to correctly handle motion vector for vertex animation based on time)
                vertexDescriptionInputs.TimeParameters = timeParameters;
            
                // evaluate vertex graph
                VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
            
                // copy graph output to the results
                // input.positionOS = vertexDescription.VertexPosition;
                input.normalOS = vertexDescription.VertexNormal;
                input.tangentOS.xyz = vertexDescription.VertexTangent;
            
                return input;
            }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    // output.texCoord0 = input.texCoord0;
                    // output.texCoord1 = input.texCoord1;
                    // output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    // output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    // output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            #endif
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    output.WorldSpaceNormal =            input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
                    // output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    // output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    // output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    // output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    // output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            #endif
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                surfaceData.color = surfaceDescription.Color;
        
        #if defined(DEBUG_DISPLAY) && !defined(SHADER_STAGE_RAY_TRACING)
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO
                }
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData RAY_TRACING_OPTIONAL_PARAMETERS)
            {
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky.
        #ifdef _ALPHATEST_ON
                // GENERIC_ALPHA_TEST(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        #endif
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                    HDShadowContext shadowContext = InitShadowContext();
                    float shadow;
                    float3 shadow3;
                    posInput = GetPositionInput(fragInputs.positionSS.xy, _ScreenSize.zw, fragInputs.positionSS.z, UNITY_MATRIX_I_VP, UNITY_MATRIX_V);
                    float3 normalWS = normalize(fragInputs.tangentToWorld[1]);
                    uint renderingLayers = _EnableLightLayers ? asuint(unity_RenderingLayer.x) : DEFAULT_LIGHT_LAYERS;
                    ShadowLoopMin(shadowContext, posInput, normalWS, asuint(_ShadowMatteFilter), renderingLayers, shadow3);
                    shadow = dot(shadow3, float3(1.0f/3.0f, 1.0f/3.0f, 1.0f/3.0f));
        
                    float4 shadowColor = (1 - shadow)*surfaceDescription.ShadowTint.rgba;
                    float  localAlpha  = saturate(shadowColor.a + surfaceDescription.Alpha);
        
                    // Keep the nested lerp
                    // With no Color (bsdfData.color.rgb, bsdfData.color.a == 0.0f), just use ShadowColor*Color to avoid a ring of "white" around the shadow
                    // And mix color to consider the Color & ShadowColor alpha (from texture or/and color picker)
                    #ifdef _SURFACE_TYPE_TRANSPARENT
                        surfaceData.color = lerp(shadowColor.rgb*surfaceData.color, lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow), surfaceDescription.Alpha);
                    #else
                        surfaceData.color = lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow);
                    #endif
                    localAlpha = ApplyBlendMode(surfaceData.color, localAlpha).a;
        
                    surfaceDescription.Alpha = localAlpha;
                #endif
        
                // Builtin Data
                ZERO_INITIALIZE(BuiltinData, builtinData); // No call to InitBuiltinData as we don't have any lighting
                builtinData.opacity = surfaceDescription.Alpha;
        
                builtinData.emissiveColor = surfaceDescription.Emission;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #endif
                RAY_TRACING_OPTIONAL_ALPHA_TEST_PASS
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassRaytracingIndirect.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDUnlitPass.template
            Name "VisibilityDXR"
            Tags { "LightMode" = "VisibilityDXR" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            
            
            
            
            
            
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            //#pragma enable_d3d11_debug_symbols
        
            
        
            //-------------------------------------------------------------------------------------
            // Graph Defines
            //-------------------------------------------------------------------------------------
                    // Shared Graph Keywords
                #define SHADERPASS SHADERPASS_RAYTRACING_VISIBILITY
                #pragma only_renderers d3d11
                #pragma multi_compile _ TRANSPARENT_COLOR_SHADOW
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   AlphaFog
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.WorldSpaceNormal
                //   SurfaceDescriptionInputs.WorldSpaceViewDirection
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   SurfaceDescriptionInputs.TimeParameters
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.WorldSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.WorldSpaceViewDirection
                //   VertexDescriptionInputs.WorldSpacePosition
                //   VertexDescriptionInputs.TimeParameters
                //   SurfaceDescription.Color
                //   SurfaceDescription.Alpha
                //   SurfaceDescription.AlphaClipThreshold
                //   SurfaceDescription.Emission
                //   features.modifyMesh
                //   VertexDescription.Color
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   FragInputs.tangentToWorld
                //   FragInputs.positionRWS
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.positionOS
                //   VaryingsMeshToPS.tangentWS
                //   VaryingsMeshToPS.normalWS
                //   VaryingsMeshToPS.positionRWS
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Variant
            //-------------------------------------------------------------------------------------
        
            // #pragma shader_feature_local _DOUBLESIDED_ON - We have no lighting, so no need to have this combination for shader, the option will just disable backface culling
        
            // Keyword for transparent
            #pragma shader_feature _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
            #pragma shader_feature_local _ALPHATEST_ON
        
            #pragma shader_feature_local        _ENABLE_FOG_ON_TRANSPARENT
            // #define _ADD_PRECOMPUTED_VELOCITY
            // #define _ENABLE_SHADOW_MATTE
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Shader stages
            //-------------------------------------------------------------------------------------
                    #pragma raytracing surface_shader
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Active Field Defines
            //-------------------------------------------------------------------------------------
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            // #define ATTRIBUTES_NEED_TEXCOORD0
            // #define ATTRIBUTES_NEED_TEXCOORD1
            // #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            // #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            // #define VARYINGS_NEED_TEXCOORD0
            // #define VARYINGS_NEED_TEXCOORD1
            // #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            // #define VARYINGS_NEED_COLOR
            // #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                #define LIGHTLOOP_DISABLE_TILE_AND_CLUSTER
                #define HAS_LIGHTLOOP
                #define SHADOW_OPTIMIZE_REGISTER_USAGE 1
        
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonLighting.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Shadow/HDShadowContext.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadow.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/PunctualLightCommon.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadowLoop.hlsl"
            #endif
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
            
        #if !defined(SHADER_STAGE_RAY_TRACING)
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracing.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracingLightLoop.hlsl"
        
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/Deferred/RaytracingIntersectonGBuffer.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingIntersection.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/NormalBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/StandardLit/StandardLit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/UnlitRaytracing.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingCommon.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #endif
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION;
                float3 positionRWS; // optional
                float3 normalWS; // optional
                float4 tangentWS; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
                float4 interp02 : TEXCOORD2; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output = (VaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output = (VaryingsMeshToDS)0;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Vector4_4FE19BDB;
                    float Vector1_97EA0DEA;
                    float Vector1_BB19229D;
                    float Vector1_1D2D6758;
                    float4 Vector4_53C3CAF3;
                    float4 Color_5100B6B6;
                    float4 Color_9F979F9B;
                    float Vector1_8B47B562;
                    float Vector1_DD2A7971;
                    float Vector1_7D71E79C;
                    float Vector1_F4FD2233;
                    float Vector1_3783F0D6;
                    float Vector1_89D9BA77;
                    float Vector1_8F52779E;
                    float Vector1_2B356380;
                    float Vector1_7892E05E;
                    float Vector1_4386BB13;
                    float Vector1_ACA8BF6B;
                    float4 _EmissionColor;
                    float _RenderQueueType;
                    float _StencilRef;
                    float _StencilWriteMask;
                    float _StencilRefDepth;
                    float _StencilWriteMaskDepth;
                    float _StencilRefMV;
                    float _StencilWriteMaskMV;
                    float _StencilRefDistortionVec;
                    float _StencilWriteMaskDistortionVec;
                    float _StencilWriteMaskGBuffer;
                    float _StencilRefGBuffer;
                    float _ZTestGBuffer;
                    float _RequireSplitLighting;
                    float _ReceivesSSR;
                    float _SurfaceType;
                    float _BlendMode;
                    float _SrcBlend;
                    float _DstBlend;
                    float _AlphaSrcBlend;
                    float _AlphaDstBlend;
                    float _ZWrite;
                    float _TransparentZWrite;
                    float _CullMode;
                    float _TransparentSortPriority;
                    float _EnableFogOnTransparent;
                    float _CullModeForward;
                    float _TransparentCullMode;
                    float _ZTestDepthEqualForOpaque;
                    float _ZTestTransparent;
                    float _TransparentBackfaceEnable;
                    float _AlphaCutoffEnable;
                    float _UseShadowThreshold;
                    float _DoubleSidedEnable;
                    float _DoubleSidedNormalMode;
                    float4 _DoubleSidedConstants;
                    float _TransparentDepthPrepassEnable;
                    float _TransparentDepthPostpassEnable;
                    CBUFFER_END
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs
                    {
                        float3 ObjectSpaceNormal; // optional
                        float3 WorldSpaceNormal; // optional
                        float3 ObjectSpaceTangent; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 WorldSpacePosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 Color;
                        float3 VertexNormal;
                        float3 VertexTangent;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpaceNormal; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 WorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Color;
                        float Alpha;
                        float AlphaClipThreshold;
                        float3 Emission;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
                    {
                        Rotation = radians(Rotation);
                
                        float s = sin(Rotation);
                        float c = cos(Rotation);
                        float one_minus_c = 1.0 - c;
                        
                        Axis = normalize(Axis);
                
                        float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                                  one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                                  one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                                };
                
                        Out = mul(rot_mat,  In);
                    }
                
                    void Unity_Multiply_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
                float2 Unity_GradientNoise_Dir_float(float2 p)
                {
                    // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                    p = p % 289;
                    float x = (34 * p.x + 1) * p.x % 289 + p.y;
                    x = (34 * x + 1) * x % 289;
                    x = frac(x / 41) * 2 - 1;
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { 
                        float2 p = UV * Scale;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }
                
                    void Unity_Saturate_float(float In, out float Out)
                    {
                        Out = saturate(In);
                    }
                
                    void Unity_Power_float(float A, float B, out float Out)
                    {
                        Out = pow(A, B);
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                    {
                        Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                    }
                
                    void Unity_Absolute_float(float In, out float Out)
                    {
                        Out = abs(In);
                    }
                
                    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                    {
                        Out = smoothstep(Edge1, Edge2, In);
                    }
                
                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
                    {
                        Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
                    }
                
                    void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
                    {
                        Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float4 _Property_539FFD11_Out_0 = Color_5100B6B6;
                        float4 _Property_23C63215_Out_0 = Color_9F979F9B;
                        float _Property_F656DB82_Out_0 = Vector1_8B47B562;
                        float _Property_E6FCF144_Out_0 = Vector1_DD2A7971;
                        float4 _Property_4CE5882F_Out_0 = Vector4_4FE19BDB;
                        float _Split_6C3848B1_R_1 = _Property_4CE5882F_Out_0[0];
                        float _Split_6C3848B1_G_2 = _Property_4CE5882F_Out_0[1];
                        float _Split_6C3848B1_B_3 = _Property_4CE5882F_Out_0[2];
                        float _Split_6C3848B1_A_4 = _Property_4CE5882F_Out_0[3];
                        float3 _RotateAboutAxis_5D606F9C_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_4CE5882F_Out_0.xyz), _Split_6C3848B1_A_4, _RotateAboutAxis_5D606F9C_Out_3);
                        float _Property_D1CCB3D3_Out_0 = Vector1_BB19229D;
                        float _Multiply_C1DBBF46_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_D1CCB3D3_Out_0, _Multiply_C1DBBF46_Out_2);
                        float2 _TilingAndOffset_D9156ED9_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_C1DBBF46_Out_2.xx), _TilingAndOffset_D9156ED9_Out_3);
                        float _Property_12322142_Out_0 = Vector1_97EA0DEA;
                        float _GradientNoise_AB0C880E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_D9156ED9_Out_3, _Property_12322142_Out_0, _GradientNoise_AB0C880E_Out_2);
                        float2 _TilingAndOffset_7FBE33C6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7FBE33C6_Out_3);
                        float _GradientNoise_F3C2A41D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7FBE33C6_Out_3, _Property_12322142_Out_0, _GradientNoise_F3C2A41D_Out_2);
                        float _Add_20294542_Out_2;
                        Unity_Add_float(_GradientNoise_AB0C880E_Out_2, _GradientNoise_F3C2A41D_Out_2, _Add_20294542_Out_2);
                        float _Divide_99AB6A24_Out_2;
                        Unity_Divide_float(_Add_20294542_Out_2, 2, _Divide_99AB6A24_Out_2);
                        float _Saturate_9A75CBB3_Out_1;
                        Unity_Saturate_float(_Divide_99AB6A24_Out_2, _Saturate_9A75CBB3_Out_1);
                        float _Property_56CA339D_Out_0 = Vector1_7D71E79C;
                        float _Power_B404C8D5_Out_2;
                        Unity_Power_float(_Saturate_9A75CBB3_Out_1, _Property_56CA339D_Out_0, _Power_B404C8D5_Out_2);
                        float4 _Property_CBC31DB7_Out_0 = Vector4_53C3CAF3;
                        float _Split_738E9079_R_1 = _Property_CBC31DB7_Out_0[0];
                        float _Split_738E9079_G_2 = _Property_CBC31DB7_Out_0[1];
                        float _Split_738E9079_B_3 = _Property_CBC31DB7_Out_0[2];
                        float _Split_738E9079_A_4 = _Property_CBC31DB7_Out_0[3];
                        float4 _Combine_D4E1A601_RGBA_4;
                        float3 _Combine_D4E1A601_RGB_5;
                        float2 _Combine_D4E1A601_RG_6;
                        Unity_Combine_float(_Split_738E9079_R_1, _Split_738E9079_G_2, 0, 0, _Combine_D4E1A601_RGBA_4, _Combine_D4E1A601_RGB_5, _Combine_D4E1A601_RG_6);
                        float4 _Combine_B3F9DAE4_RGBA_4;
                        float3 _Combine_B3F9DAE4_RGB_5;
                        float2 _Combine_B3F9DAE4_RG_6;
                        Unity_Combine_float(_Split_738E9079_B_3, _Split_738E9079_A_4, 0, 0, _Combine_B3F9DAE4_RGBA_4, _Combine_B3F9DAE4_RGB_5, _Combine_B3F9DAE4_RG_6);
                        float _Remap_8141F08C_Out_3;
                        Unity_Remap_float(_Power_B404C8D5_Out_2, _Combine_D4E1A601_RG_6, _Combine_B3F9DAE4_RG_6, _Remap_8141F08C_Out_3);
                        float _Absolute_DA707E52_Out_1;
                        Unity_Absolute_float(_Remap_8141F08C_Out_3, _Absolute_DA707E52_Out_1);
                        float _Smoothstep_A9222CB5_Out_3;
                        Unity_Smoothstep_float(_Property_F656DB82_Out_0, _Property_E6FCF144_Out_0, _Absolute_DA707E52_Out_1, _Smoothstep_A9222CB5_Out_3);
                        float _Property_B22C6734_Out_0 = Vector1_3783F0D6;
                        float _Multiply_9C4F241C_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_B22C6734_Out_0, _Multiply_9C4F241C_Out_2);
                        float2 _TilingAndOffset_8D91A587_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_9C4F241C_Out_2.xx), _TilingAndOffset_8D91A587_Out_3);
                        float _Property_E409C129_Out_0 = Vector1_F4FD2233;
                        float _GradientNoise_81BAEB4A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_8D91A587_Out_3, _Property_E409C129_Out_0, _GradientNoise_81BAEB4A_Out_2);
                        float _Property_C4CE44E0_Out_0 = Vector1_89D9BA77;
                        float _Multiply_F5DA2647_Out_2;
                        Unity_Multiply_float(_GradientNoise_81BAEB4A_Out_2, _Property_C4CE44E0_Out_0, _Multiply_F5DA2647_Out_2);
                        float _Add_CAB25FE5_Out_2;
                        Unity_Add_float(_Smoothstep_A9222CB5_Out_3, _Multiply_F5DA2647_Out_2, _Add_CAB25FE5_Out_2);
                        float _Add_92F04FE1_Out_2;
                        Unity_Add_float(1, _Property_C4CE44E0_Out_0, _Add_92F04FE1_Out_2);
                        float _Divide_D05AE96_Out_2;
                        Unity_Divide_float(_Add_CAB25FE5_Out_2, _Add_92F04FE1_Out_2, _Divide_D05AE96_Out_2);
                        float4 _Lerp_608D51B5_Out_3;
                        Unity_Lerp_float4(_Property_539FFD11_Out_0, _Property_23C63215_Out_0, (_Divide_D05AE96_Out_2.xxxx), _Lerp_608D51B5_Out_3);
                        float _Property_189FD6C_Out_0 = Vector1_7892E05E;
                        float _FresnelEffect_83E7E861_Out_3;
                        Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_189FD6C_Out_0, _FresnelEffect_83E7E861_Out_3);
                        float _Multiply_377CD458_Out_2;
                        Unity_Multiply_float(_Divide_D05AE96_Out_2, _FresnelEffect_83E7E861_Out_3, _Multiply_377CD458_Out_2);
                        float _Property_AA57477D_Out_0 = Vector1_4386BB13;
                        float _Multiply_A59FF53_Out_2;
                        Unity_Multiply_float(_Multiply_377CD458_Out_2, _Property_AA57477D_Out_0, _Multiply_A59FF53_Out_2);
                        float4 _Add_13002516_Out_2;
                        Unity_Add_float4(_Lerp_608D51B5_Out_3, (_Multiply_A59FF53_Out_2.xxxx), _Add_13002516_Out_2);
                        description.Color = (_Add_13002516_Out_2.xyz);
                        description.VertexNormal = IN.ObjectSpaceNormal;
                        description.VertexTangent = IN.ObjectSpaceTangent;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _Property_539FFD11_Out_0 = Color_5100B6B6;
                        float4 _Property_23C63215_Out_0 = Color_9F979F9B;
                        float _Property_F656DB82_Out_0 = Vector1_8B47B562;
                        float _Property_E6FCF144_Out_0 = Vector1_DD2A7971;
                        float4 _Property_4CE5882F_Out_0 = Vector4_4FE19BDB;
                        float _Split_6C3848B1_R_1 = _Property_4CE5882F_Out_0[0];
                        float _Split_6C3848B1_G_2 = _Property_4CE5882F_Out_0[1];
                        float _Split_6C3848B1_B_3 = _Property_4CE5882F_Out_0[2];
                        float _Split_6C3848B1_A_4 = _Property_4CE5882F_Out_0[3];
                        float3 _RotateAboutAxis_5D606F9C_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_4CE5882F_Out_0.xyz), _Split_6C3848B1_A_4, _RotateAboutAxis_5D606F9C_Out_3);
                        float _Property_D1CCB3D3_Out_0 = Vector1_BB19229D;
                        float _Multiply_C1DBBF46_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_D1CCB3D3_Out_0, _Multiply_C1DBBF46_Out_2);
                        float2 _TilingAndOffset_D9156ED9_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_C1DBBF46_Out_2.xx), _TilingAndOffset_D9156ED9_Out_3);
                        float _Property_12322142_Out_0 = Vector1_97EA0DEA;
                        float _GradientNoise_AB0C880E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_D9156ED9_Out_3, _Property_12322142_Out_0, _GradientNoise_AB0C880E_Out_2);
                        float2 _TilingAndOffset_7FBE33C6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7FBE33C6_Out_3);
                        float _GradientNoise_F3C2A41D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7FBE33C6_Out_3, _Property_12322142_Out_0, _GradientNoise_F3C2A41D_Out_2);
                        float _Add_20294542_Out_2;
                        Unity_Add_float(_GradientNoise_AB0C880E_Out_2, _GradientNoise_F3C2A41D_Out_2, _Add_20294542_Out_2);
                        float _Divide_99AB6A24_Out_2;
                        Unity_Divide_float(_Add_20294542_Out_2, 2, _Divide_99AB6A24_Out_2);
                        float _Saturate_9A75CBB3_Out_1;
                        Unity_Saturate_float(_Divide_99AB6A24_Out_2, _Saturate_9A75CBB3_Out_1);
                        float _Property_56CA339D_Out_0 = Vector1_7D71E79C;
                        float _Power_B404C8D5_Out_2;
                        Unity_Power_float(_Saturate_9A75CBB3_Out_1, _Property_56CA339D_Out_0, _Power_B404C8D5_Out_2);
                        float4 _Property_CBC31DB7_Out_0 = Vector4_53C3CAF3;
                        float _Split_738E9079_R_1 = _Property_CBC31DB7_Out_0[0];
                        float _Split_738E9079_G_2 = _Property_CBC31DB7_Out_0[1];
                        float _Split_738E9079_B_3 = _Property_CBC31DB7_Out_0[2];
                        float _Split_738E9079_A_4 = _Property_CBC31DB7_Out_0[3];
                        float4 _Combine_D4E1A601_RGBA_4;
                        float3 _Combine_D4E1A601_RGB_5;
                        float2 _Combine_D4E1A601_RG_6;
                        Unity_Combine_float(_Split_738E9079_R_1, _Split_738E9079_G_2, 0, 0, _Combine_D4E1A601_RGBA_4, _Combine_D4E1A601_RGB_5, _Combine_D4E1A601_RG_6);
                        float4 _Combine_B3F9DAE4_RGBA_4;
                        float3 _Combine_B3F9DAE4_RGB_5;
                        float2 _Combine_B3F9DAE4_RG_6;
                        Unity_Combine_float(_Split_738E9079_B_3, _Split_738E9079_A_4, 0, 0, _Combine_B3F9DAE4_RGBA_4, _Combine_B3F9DAE4_RGB_5, _Combine_B3F9DAE4_RG_6);
                        float _Remap_8141F08C_Out_3;
                        Unity_Remap_float(_Power_B404C8D5_Out_2, _Combine_D4E1A601_RG_6, _Combine_B3F9DAE4_RG_6, _Remap_8141F08C_Out_3);
                        float _Absolute_DA707E52_Out_1;
                        Unity_Absolute_float(_Remap_8141F08C_Out_3, _Absolute_DA707E52_Out_1);
                        float _Smoothstep_A9222CB5_Out_3;
                        Unity_Smoothstep_float(_Property_F656DB82_Out_0, _Property_E6FCF144_Out_0, _Absolute_DA707E52_Out_1, _Smoothstep_A9222CB5_Out_3);
                        float _Property_B22C6734_Out_0 = Vector1_3783F0D6;
                        float _Multiply_9C4F241C_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_B22C6734_Out_0, _Multiply_9C4F241C_Out_2);
                        float2 _TilingAndOffset_8D91A587_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_9C4F241C_Out_2.xx), _TilingAndOffset_8D91A587_Out_3);
                        float _Property_E409C129_Out_0 = Vector1_F4FD2233;
                        float _GradientNoise_81BAEB4A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_8D91A587_Out_3, _Property_E409C129_Out_0, _GradientNoise_81BAEB4A_Out_2);
                        float _Property_C4CE44E0_Out_0 = Vector1_89D9BA77;
                        float _Multiply_F5DA2647_Out_2;
                        Unity_Multiply_float(_GradientNoise_81BAEB4A_Out_2, _Property_C4CE44E0_Out_0, _Multiply_F5DA2647_Out_2);
                        float _Add_CAB25FE5_Out_2;
                        Unity_Add_float(_Smoothstep_A9222CB5_Out_3, _Multiply_F5DA2647_Out_2, _Add_CAB25FE5_Out_2);
                        float _Add_92F04FE1_Out_2;
                        Unity_Add_float(1, _Property_C4CE44E0_Out_0, _Add_92F04FE1_Out_2);
                        float _Divide_D05AE96_Out_2;
                        Unity_Divide_float(_Add_CAB25FE5_Out_2, _Add_92F04FE1_Out_2, _Divide_D05AE96_Out_2);
                        float4 _Lerp_608D51B5_Out_3;
                        Unity_Lerp_float4(_Property_539FFD11_Out_0, _Property_23C63215_Out_0, (_Divide_D05AE96_Out_2.xxxx), _Lerp_608D51B5_Out_3);
                        float _Property_189FD6C_Out_0 = Vector1_7892E05E;
                        float _FresnelEffect_83E7E861_Out_3;
                        Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_189FD6C_Out_0, _FresnelEffect_83E7E861_Out_3);
                        float _Multiply_377CD458_Out_2;
                        Unity_Multiply_float(_Divide_D05AE96_Out_2, _FresnelEffect_83E7E861_Out_3, _Multiply_377CD458_Out_2);
                        float _Property_AA57477D_Out_0 = Vector1_4386BB13;
                        float _Multiply_A59FF53_Out_2;
                        Unity_Multiply_float(_Multiply_377CD458_Out_2, _Property_AA57477D_Out_0, _Multiply_A59FF53_Out_2);
                        float4 _Add_13002516_Out_2;
                        Unity_Add_float4(_Lerp_608D51B5_Out_3, (_Multiply_A59FF53_Out_2.xxxx), _Add_13002516_Out_2);
                        float _SceneDepth_6A5D647C_Out_1;
                        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_6A5D647C_Out_1);
                        float4 _ScreenPosition_D5C0B977_Out_0 = IN.ScreenPosition;
                        float _Split_D7132622_R_1 = _ScreenPosition_D5C0B977_Out_0[0];
                        float _Split_D7132622_G_2 = _ScreenPosition_D5C0B977_Out_0[1];
                        float _Split_D7132622_B_3 = _ScreenPosition_D5C0B977_Out_0[2];
                        float _Split_D7132622_A_4 = _ScreenPosition_D5C0B977_Out_0[3];
                        float _Subtract_EDAEA22B_Out_2;
                        Unity_Subtract_float(_Split_D7132622_A_4, 1, _Subtract_EDAEA22B_Out_2);
                        float _Subtract_D2C21BA_Out_2;
                        Unity_Subtract_float(_SceneDepth_6A5D647C_Out_1, _Subtract_EDAEA22B_Out_2, _Subtract_D2C21BA_Out_2);
                        float _Property_E72E495F_Out_0 = Vector1_ACA8BF6B;
                        float _Divide_69800C63_Out_2;
                        Unity_Divide_float(_Subtract_D2C21BA_Out_2, _Property_E72E495F_Out_0, _Divide_69800C63_Out_2);
                        float _Saturate_30FCF87F_Out_1;
                        Unity_Saturate_float(_Divide_69800C63_Out_2, _Saturate_30FCF87F_Out_1);
                        float _Property_27256254_Out_0 = Vector1_8F52779E;
                        float4 _Multiply_D88E026_Out_2;
                        Unity_Multiply_float(_Add_13002516_Out_2, (_Property_27256254_Out_0.xxxx), _Multiply_D88E026_Out_2);
                        surface.Color = (_Add_13002516_Out_2.xyz);
                        surface.Alpha = _Saturate_30FCF87F_Out_1;
                        surface.AlphaClipThreshold = 0;
                        surface.Emission = (_Multiply_D88E026_Out_2.xyz);
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                // output.ViewSpaceNormal =             TransformWorldToViewDir(output.WorldSpaceNormal);
                // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.ObjectSpaceTangent =          input.tangentOS;
                // output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                // output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                // output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                // output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                // output.ViewSpacePosition =           TransformWorldToView(output.WorldSpacePosition);
                // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                output.WorldSpaceViewDirection =     GetWorldSpaceNormalizeViewDir(output.WorldSpacePosition);
                // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                // output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(output.WorldSpacePosition), _ProjectionParams.x);
                // output.uv0 =                         input.uv0;
                // output.uv1 =                         input.uv1;
                // output.uv2 =                         input.uv2;
                // output.uv3 =                         input.uv3;
                // output.VertexColor =                 input.color;
                // output.BoneWeights =                 input.weights;
                // output.BoneIndices =                 input.indices;
            
                return output;
            }
            
            AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
            {
                // build graph inputs
                VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
                // Override time paramters with used one (This is required to correctly handle motion vector for vertex animation based on time)
                vertexDescriptionInputs.TimeParameters = timeParameters;
            
                // evaluate vertex graph
                VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
            
                // copy graph output to the results
                // input.positionOS = vertexDescription.VertexPosition;
                input.normalOS = vertexDescription.VertexNormal;
                input.tangentOS.xyz = vertexDescription.VertexTangent;
            
                return input;
            }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    // output.texCoord0 = input.texCoord0;
                    // output.texCoord1 = input.texCoord1;
                    // output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    // output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    // output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            #endif
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    output.WorldSpaceNormal =            input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
                    // output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    // output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    // output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    // output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    // output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            #endif
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                surfaceData.color = surfaceDescription.Color;
        
        #if defined(DEBUG_DISPLAY) && !defined(SHADER_STAGE_RAY_TRACING)
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO
                }
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData RAY_TRACING_OPTIONAL_PARAMETERS)
            {
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky.
        #ifdef _ALPHATEST_ON
                // GENERIC_ALPHA_TEST(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        #endif
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                    HDShadowContext shadowContext = InitShadowContext();
                    float shadow;
                    float3 shadow3;
                    posInput = GetPositionInput(fragInputs.positionSS.xy, _ScreenSize.zw, fragInputs.positionSS.z, UNITY_MATRIX_I_VP, UNITY_MATRIX_V);
                    float3 normalWS = normalize(fragInputs.tangentToWorld[1]);
                    uint renderingLayers = _EnableLightLayers ? asuint(unity_RenderingLayer.x) : DEFAULT_LIGHT_LAYERS;
                    ShadowLoopMin(shadowContext, posInput, normalWS, asuint(_ShadowMatteFilter), renderingLayers, shadow3);
                    shadow = dot(shadow3, float3(1.0f/3.0f, 1.0f/3.0f, 1.0f/3.0f));
        
                    float4 shadowColor = (1 - shadow)*surfaceDescription.ShadowTint.rgba;
                    float  localAlpha  = saturate(shadowColor.a + surfaceDescription.Alpha);
        
                    // Keep the nested lerp
                    // With no Color (bsdfData.color.rgb, bsdfData.color.a == 0.0f), just use ShadowColor*Color to avoid a ring of "white" around the shadow
                    // And mix color to consider the Color & ShadowColor alpha (from texture or/and color picker)
                    #ifdef _SURFACE_TYPE_TRANSPARENT
                        surfaceData.color = lerp(shadowColor.rgb*surfaceData.color, lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow), surfaceDescription.Alpha);
                    #else
                        surfaceData.color = lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow);
                    #endif
                    localAlpha = ApplyBlendMode(surfaceData.color, localAlpha).a;
        
                    surfaceDescription.Alpha = localAlpha;
                #endif
        
                // Builtin Data
                ZERO_INITIALIZE(BuiltinData, builtinData); // No call to InitBuiltinData as we don't have any lighting
                builtinData.opacity = surfaceDescription.Alpha;
        
                builtinData.emissiveColor = surfaceDescription.Emission;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #endif
                RAY_TRACING_OPTIONAL_ALPHA_TEST_PASS
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassRaytracingVisibility.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDUnlitPass.template
            Name "ForwardDXR"
            Tags { "LightMode" = "ForwardDXR" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            
            
            
            
            
            
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            //#pragma enable_d3d11_debug_symbols
        
            
        
            //-------------------------------------------------------------------------------------
            // Graph Defines
            //-------------------------------------------------------------------------------------
                    // Shared Graph Keywords
                #define SHADERPASS SHADERPASS_RAYTRACING_FORWARD
                #pragma only_renderers d3d11
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   AlphaFog
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.WorldSpaceNormal
                //   SurfaceDescriptionInputs.WorldSpaceViewDirection
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   SurfaceDescriptionInputs.TimeParameters
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.WorldSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.WorldSpaceViewDirection
                //   VertexDescriptionInputs.WorldSpacePosition
                //   VertexDescriptionInputs.TimeParameters
                //   SurfaceDescription.Color
                //   SurfaceDescription.Alpha
                //   SurfaceDescription.AlphaClipThreshold
                //   SurfaceDescription.Emission
                //   features.modifyMesh
                //   VertexDescription.Color
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   FragInputs.tangentToWorld
                //   FragInputs.positionRWS
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.positionOS
                //   VaryingsMeshToPS.tangentWS
                //   VaryingsMeshToPS.normalWS
                //   VaryingsMeshToPS.positionRWS
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Variant
            //-------------------------------------------------------------------------------------
        
            // #pragma shader_feature_local _DOUBLESIDED_ON - We have no lighting, so no need to have this combination for shader, the option will just disable backface culling
        
            // Keyword for transparent
            #pragma shader_feature _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
            #pragma shader_feature_local _ALPHATEST_ON
        
            #pragma shader_feature_local        _ENABLE_FOG_ON_TRANSPARENT
            // #define _ADD_PRECOMPUTED_VELOCITY
            // #define _ENABLE_SHADOW_MATTE
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Shader stages
            //-------------------------------------------------------------------------------------
                    #pragma raytracing surface_shader
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Active Field Defines
            //-------------------------------------------------------------------------------------
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            // #define ATTRIBUTES_NEED_TEXCOORD0
            // #define ATTRIBUTES_NEED_TEXCOORD1
            // #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            // #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            // #define VARYINGS_NEED_TEXCOORD0
            // #define VARYINGS_NEED_TEXCOORD1
            // #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            // #define VARYINGS_NEED_COLOR
            // #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                #define LIGHTLOOP_DISABLE_TILE_AND_CLUSTER
                #define HAS_LIGHTLOOP
                #define SHADOW_OPTIMIZE_REGISTER_USAGE 1
        
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonLighting.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Shadow/HDShadowContext.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadow.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/PunctualLightCommon.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadowLoop.hlsl"
            #endif
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
            
        #if !defined(SHADER_STAGE_RAY_TRACING)
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracing.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracingLightLoop.hlsl"
        
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/Deferred/RaytracingIntersectonGBuffer.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingIntersection.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/NormalBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/StandardLit/StandardLit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/UnlitRaytracing.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingCommon.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #endif
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION;
                float3 positionRWS; // optional
                float3 normalWS; // optional
                float4 tangentWS; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
                float4 interp02 : TEXCOORD2; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output = (VaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output = (VaryingsMeshToDS)0;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Vector4_4FE19BDB;
                    float Vector1_97EA0DEA;
                    float Vector1_BB19229D;
                    float Vector1_1D2D6758;
                    float4 Vector4_53C3CAF3;
                    float4 Color_5100B6B6;
                    float4 Color_9F979F9B;
                    float Vector1_8B47B562;
                    float Vector1_DD2A7971;
                    float Vector1_7D71E79C;
                    float Vector1_F4FD2233;
                    float Vector1_3783F0D6;
                    float Vector1_89D9BA77;
                    float Vector1_8F52779E;
                    float Vector1_2B356380;
                    float Vector1_7892E05E;
                    float Vector1_4386BB13;
                    float Vector1_ACA8BF6B;
                    float4 _EmissionColor;
                    float _RenderQueueType;
                    float _StencilRef;
                    float _StencilWriteMask;
                    float _StencilRefDepth;
                    float _StencilWriteMaskDepth;
                    float _StencilRefMV;
                    float _StencilWriteMaskMV;
                    float _StencilRefDistortionVec;
                    float _StencilWriteMaskDistortionVec;
                    float _StencilWriteMaskGBuffer;
                    float _StencilRefGBuffer;
                    float _ZTestGBuffer;
                    float _RequireSplitLighting;
                    float _ReceivesSSR;
                    float _SurfaceType;
                    float _BlendMode;
                    float _SrcBlend;
                    float _DstBlend;
                    float _AlphaSrcBlend;
                    float _AlphaDstBlend;
                    float _ZWrite;
                    float _TransparentZWrite;
                    float _CullMode;
                    float _TransparentSortPriority;
                    float _EnableFogOnTransparent;
                    float _CullModeForward;
                    float _TransparentCullMode;
                    float _ZTestDepthEqualForOpaque;
                    float _ZTestTransparent;
                    float _TransparentBackfaceEnable;
                    float _AlphaCutoffEnable;
                    float _UseShadowThreshold;
                    float _DoubleSidedEnable;
                    float _DoubleSidedNormalMode;
                    float4 _DoubleSidedConstants;
                    float _TransparentDepthPrepassEnable;
                    float _TransparentDepthPostpassEnable;
                    CBUFFER_END
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs
                    {
                        float3 ObjectSpaceNormal; // optional
                        float3 WorldSpaceNormal; // optional
                        float3 ObjectSpaceTangent; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 WorldSpacePosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 Color;
                        float3 VertexNormal;
                        float3 VertexTangent;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpaceNormal; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 WorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Color;
                        float Alpha;
                        float AlphaClipThreshold;
                        float3 Emission;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
                    {
                        Rotation = radians(Rotation);
                
                        float s = sin(Rotation);
                        float c = cos(Rotation);
                        float one_minus_c = 1.0 - c;
                        
                        Axis = normalize(Axis);
                
                        float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                                  one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                                  one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                                };
                
                        Out = mul(rot_mat,  In);
                    }
                
                    void Unity_Multiply_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
                float2 Unity_GradientNoise_Dir_float(float2 p)
                {
                    // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                    p = p % 289;
                    float x = (34 * p.x + 1) * p.x % 289 + p.y;
                    x = (34 * x + 1) * x % 289;
                    x = frac(x / 41) * 2 - 1;
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { 
                        float2 p = UV * Scale;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }
                
                    void Unity_Saturate_float(float In, out float Out)
                    {
                        Out = saturate(In);
                    }
                
                    void Unity_Power_float(float A, float B, out float Out)
                    {
                        Out = pow(A, B);
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                    {
                        Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                    }
                
                    void Unity_Absolute_float(float In, out float Out)
                    {
                        Out = abs(In);
                    }
                
                    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                    {
                        Out = smoothstep(Edge1, Edge2, In);
                    }
                
                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
                    {
                        Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
                    }
                
                    void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
                    {
                        Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float4 _Property_539FFD11_Out_0 = Color_5100B6B6;
                        float4 _Property_23C63215_Out_0 = Color_9F979F9B;
                        float _Property_F656DB82_Out_0 = Vector1_8B47B562;
                        float _Property_E6FCF144_Out_0 = Vector1_DD2A7971;
                        float4 _Property_4CE5882F_Out_0 = Vector4_4FE19BDB;
                        float _Split_6C3848B1_R_1 = _Property_4CE5882F_Out_0[0];
                        float _Split_6C3848B1_G_2 = _Property_4CE5882F_Out_0[1];
                        float _Split_6C3848B1_B_3 = _Property_4CE5882F_Out_0[2];
                        float _Split_6C3848B1_A_4 = _Property_4CE5882F_Out_0[3];
                        float3 _RotateAboutAxis_5D606F9C_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_4CE5882F_Out_0.xyz), _Split_6C3848B1_A_4, _RotateAboutAxis_5D606F9C_Out_3);
                        float _Property_D1CCB3D3_Out_0 = Vector1_BB19229D;
                        float _Multiply_C1DBBF46_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_D1CCB3D3_Out_0, _Multiply_C1DBBF46_Out_2);
                        float2 _TilingAndOffset_D9156ED9_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_C1DBBF46_Out_2.xx), _TilingAndOffset_D9156ED9_Out_3);
                        float _Property_12322142_Out_0 = Vector1_97EA0DEA;
                        float _GradientNoise_AB0C880E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_D9156ED9_Out_3, _Property_12322142_Out_0, _GradientNoise_AB0C880E_Out_2);
                        float2 _TilingAndOffset_7FBE33C6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7FBE33C6_Out_3);
                        float _GradientNoise_F3C2A41D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7FBE33C6_Out_3, _Property_12322142_Out_0, _GradientNoise_F3C2A41D_Out_2);
                        float _Add_20294542_Out_2;
                        Unity_Add_float(_GradientNoise_AB0C880E_Out_2, _GradientNoise_F3C2A41D_Out_2, _Add_20294542_Out_2);
                        float _Divide_99AB6A24_Out_2;
                        Unity_Divide_float(_Add_20294542_Out_2, 2, _Divide_99AB6A24_Out_2);
                        float _Saturate_9A75CBB3_Out_1;
                        Unity_Saturate_float(_Divide_99AB6A24_Out_2, _Saturate_9A75CBB3_Out_1);
                        float _Property_56CA339D_Out_0 = Vector1_7D71E79C;
                        float _Power_B404C8D5_Out_2;
                        Unity_Power_float(_Saturate_9A75CBB3_Out_1, _Property_56CA339D_Out_0, _Power_B404C8D5_Out_2);
                        float4 _Property_CBC31DB7_Out_0 = Vector4_53C3CAF3;
                        float _Split_738E9079_R_1 = _Property_CBC31DB7_Out_0[0];
                        float _Split_738E9079_G_2 = _Property_CBC31DB7_Out_0[1];
                        float _Split_738E9079_B_3 = _Property_CBC31DB7_Out_0[2];
                        float _Split_738E9079_A_4 = _Property_CBC31DB7_Out_0[3];
                        float4 _Combine_D4E1A601_RGBA_4;
                        float3 _Combine_D4E1A601_RGB_5;
                        float2 _Combine_D4E1A601_RG_6;
                        Unity_Combine_float(_Split_738E9079_R_1, _Split_738E9079_G_2, 0, 0, _Combine_D4E1A601_RGBA_4, _Combine_D4E1A601_RGB_5, _Combine_D4E1A601_RG_6);
                        float4 _Combine_B3F9DAE4_RGBA_4;
                        float3 _Combine_B3F9DAE4_RGB_5;
                        float2 _Combine_B3F9DAE4_RG_6;
                        Unity_Combine_float(_Split_738E9079_B_3, _Split_738E9079_A_4, 0, 0, _Combine_B3F9DAE4_RGBA_4, _Combine_B3F9DAE4_RGB_5, _Combine_B3F9DAE4_RG_6);
                        float _Remap_8141F08C_Out_3;
                        Unity_Remap_float(_Power_B404C8D5_Out_2, _Combine_D4E1A601_RG_6, _Combine_B3F9DAE4_RG_6, _Remap_8141F08C_Out_3);
                        float _Absolute_DA707E52_Out_1;
                        Unity_Absolute_float(_Remap_8141F08C_Out_3, _Absolute_DA707E52_Out_1);
                        float _Smoothstep_A9222CB5_Out_3;
                        Unity_Smoothstep_float(_Property_F656DB82_Out_0, _Property_E6FCF144_Out_0, _Absolute_DA707E52_Out_1, _Smoothstep_A9222CB5_Out_3);
                        float _Property_B22C6734_Out_0 = Vector1_3783F0D6;
                        float _Multiply_9C4F241C_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_B22C6734_Out_0, _Multiply_9C4F241C_Out_2);
                        float2 _TilingAndOffset_8D91A587_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_9C4F241C_Out_2.xx), _TilingAndOffset_8D91A587_Out_3);
                        float _Property_E409C129_Out_0 = Vector1_F4FD2233;
                        float _GradientNoise_81BAEB4A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_8D91A587_Out_3, _Property_E409C129_Out_0, _GradientNoise_81BAEB4A_Out_2);
                        float _Property_C4CE44E0_Out_0 = Vector1_89D9BA77;
                        float _Multiply_F5DA2647_Out_2;
                        Unity_Multiply_float(_GradientNoise_81BAEB4A_Out_2, _Property_C4CE44E0_Out_0, _Multiply_F5DA2647_Out_2);
                        float _Add_CAB25FE5_Out_2;
                        Unity_Add_float(_Smoothstep_A9222CB5_Out_3, _Multiply_F5DA2647_Out_2, _Add_CAB25FE5_Out_2);
                        float _Add_92F04FE1_Out_2;
                        Unity_Add_float(1, _Property_C4CE44E0_Out_0, _Add_92F04FE1_Out_2);
                        float _Divide_D05AE96_Out_2;
                        Unity_Divide_float(_Add_CAB25FE5_Out_2, _Add_92F04FE1_Out_2, _Divide_D05AE96_Out_2);
                        float4 _Lerp_608D51B5_Out_3;
                        Unity_Lerp_float4(_Property_539FFD11_Out_0, _Property_23C63215_Out_0, (_Divide_D05AE96_Out_2.xxxx), _Lerp_608D51B5_Out_3);
                        float _Property_189FD6C_Out_0 = Vector1_7892E05E;
                        float _FresnelEffect_83E7E861_Out_3;
                        Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_189FD6C_Out_0, _FresnelEffect_83E7E861_Out_3);
                        float _Multiply_377CD458_Out_2;
                        Unity_Multiply_float(_Divide_D05AE96_Out_2, _FresnelEffect_83E7E861_Out_3, _Multiply_377CD458_Out_2);
                        float _Property_AA57477D_Out_0 = Vector1_4386BB13;
                        float _Multiply_A59FF53_Out_2;
                        Unity_Multiply_float(_Multiply_377CD458_Out_2, _Property_AA57477D_Out_0, _Multiply_A59FF53_Out_2);
                        float4 _Add_13002516_Out_2;
                        Unity_Add_float4(_Lerp_608D51B5_Out_3, (_Multiply_A59FF53_Out_2.xxxx), _Add_13002516_Out_2);
                        description.Color = (_Add_13002516_Out_2.xyz);
                        description.VertexNormal = IN.ObjectSpaceNormal;
                        description.VertexTangent = IN.ObjectSpaceTangent;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _Property_539FFD11_Out_0 = Color_5100B6B6;
                        float4 _Property_23C63215_Out_0 = Color_9F979F9B;
                        float _Property_F656DB82_Out_0 = Vector1_8B47B562;
                        float _Property_E6FCF144_Out_0 = Vector1_DD2A7971;
                        float4 _Property_4CE5882F_Out_0 = Vector4_4FE19BDB;
                        float _Split_6C3848B1_R_1 = _Property_4CE5882F_Out_0[0];
                        float _Split_6C3848B1_G_2 = _Property_4CE5882F_Out_0[1];
                        float _Split_6C3848B1_B_3 = _Property_4CE5882F_Out_0[2];
                        float _Split_6C3848B1_A_4 = _Property_4CE5882F_Out_0[3];
                        float3 _RotateAboutAxis_5D606F9C_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_4CE5882F_Out_0.xyz), _Split_6C3848B1_A_4, _RotateAboutAxis_5D606F9C_Out_3);
                        float _Property_D1CCB3D3_Out_0 = Vector1_BB19229D;
                        float _Multiply_C1DBBF46_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_D1CCB3D3_Out_0, _Multiply_C1DBBF46_Out_2);
                        float2 _TilingAndOffset_D9156ED9_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_C1DBBF46_Out_2.xx), _TilingAndOffset_D9156ED9_Out_3);
                        float _Property_12322142_Out_0 = Vector1_97EA0DEA;
                        float _GradientNoise_AB0C880E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_D9156ED9_Out_3, _Property_12322142_Out_0, _GradientNoise_AB0C880E_Out_2);
                        float2 _TilingAndOffset_7FBE33C6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7FBE33C6_Out_3);
                        float _GradientNoise_F3C2A41D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7FBE33C6_Out_3, _Property_12322142_Out_0, _GradientNoise_F3C2A41D_Out_2);
                        float _Add_20294542_Out_2;
                        Unity_Add_float(_GradientNoise_AB0C880E_Out_2, _GradientNoise_F3C2A41D_Out_2, _Add_20294542_Out_2);
                        float _Divide_99AB6A24_Out_2;
                        Unity_Divide_float(_Add_20294542_Out_2, 2, _Divide_99AB6A24_Out_2);
                        float _Saturate_9A75CBB3_Out_1;
                        Unity_Saturate_float(_Divide_99AB6A24_Out_2, _Saturate_9A75CBB3_Out_1);
                        float _Property_56CA339D_Out_0 = Vector1_7D71E79C;
                        float _Power_B404C8D5_Out_2;
                        Unity_Power_float(_Saturate_9A75CBB3_Out_1, _Property_56CA339D_Out_0, _Power_B404C8D5_Out_2);
                        float4 _Property_CBC31DB7_Out_0 = Vector4_53C3CAF3;
                        float _Split_738E9079_R_1 = _Property_CBC31DB7_Out_0[0];
                        float _Split_738E9079_G_2 = _Property_CBC31DB7_Out_0[1];
                        float _Split_738E9079_B_3 = _Property_CBC31DB7_Out_0[2];
                        float _Split_738E9079_A_4 = _Property_CBC31DB7_Out_0[3];
                        float4 _Combine_D4E1A601_RGBA_4;
                        float3 _Combine_D4E1A601_RGB_5;
                        float2 _Combine_D4E1A601_RG_6;
                        Unity_Combine_float(_Split_738E9079_R_1, _Split_738E9079_G_2, 0, 0, _Combine_D4E1A601_RGBA_4, _Combine_D4E1A601_RGB_5, _Combine_D4E1A601_RG_6);
                        float4 _Combine_B3F9DAE4_RGBA_4;
                        float3 _Combine_B3F9DAE4_RGB_5;
                        float2 _Combine_B3F9DAE4_RG_6;
                        Unity_Combine_float(_Split_738E9079_B_3, _Split_738E9079_A_4, 0, 0, _Combine_B3F9DAE4_RGBA_4, _Combine_B3F9DAE4_RGB_5, _Combine_B3F9DAE4_RG_6);
                        float _Remap_8141F08C_Out_3;
                        Unity_Remap_float(_Power_B404C8D5_Out_2, _Combine_D4E1A601_RG_6, _Combine_B3F9DAE4_RG_6, _Remap_8141F08C_Out_3);
                        float _Absolute_DA707E52_Out_1;
                        Unity_Absolute_float(_Remap_8141F08C_Out_3, _Absolute_DA707E52_Out_1);
                        float _Smoothstep_A9222CB5_Out_3;
                        Unity_Smoothstep_float(_Property_F656DB82_Out_0, _Property_E6FCF144_Out_0, _Absolute_DA707E52_Out_1, _Smoothstep_A9222CB5_Out_3);
                        float _Property_B22C6734_Out_0 = Vector1_3783F0D6;
                        float _Multiply_9C4F241C_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_B22C6734_Out_0, _Multiply_9C4F241C_Out_2);
                        float2 _TilingAndOffset_8D91A587_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_9C4F241C_Out_2.xx), _TilingAndOffset_8D91A587_Out_3);
                        float _Property_E409C129_Out_0 = Vector1_F4FD2233;
                        float _GradientNoise_81BAEB4A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_8D91A587_Out_3, _Property_E409C129_Out_0, _GradientNoise_81BAEB4A_Out_2);
                        float _Property_C4CE44E0_Out_0 = Vector1_89D9BA77;
                        float _Multiply_F5DA2647_Out_2;
                        Unity_Multiply_float(_GradientNoise_81BAEB4A_Out_2, _Property_C4CE44E0_Out_0, _Multiply_F5DA2647_Out_2);
                        float _Add_CAB25FE5_Out_2;
                        Unity_Add_float(_Smoothstep_A9222CB5_Out_3, _Multiply_F5DA2647_Out_2, _Add_CAB25FE5_Out_2);
                        float _Add_92F04FE1_Out_2;
                        Unity_Add_float(1, _Property_C4CE44E0_Out_0, _Add_92F04FE1_Out_2);
                        float _Divide_D05AE96_Out_2;
                        Unity_Divide_float(_Add_CAB25FE5_Out_2, _Add_92F04FE1_Out_2, _Divide_D05AE96_Out_2);
                        float4 _Lerp_608D51B5_Out_3;
                        Unity_Lerp_float4(_Property_539FFD11_Out_0, _Property_23C63215_Out_0, (_Divide_D05AE96_Out_2.xxxx), _Lerp_608D51B5_Out_3);
                        float _Property_189FD6C_Out_0 = Vector1_7892E05E;
                        float _FresnelEffect_83E7E861_Out_3;
                        Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_189FD6C_Out_0, _FresnelEffect_83E7E861_Out_3);
                        float _Multiply_377CD458_Out_2;
                        Unity_Multiply_float(_Divide_D05AE96_Out_2, _FresnelEffect_83E7E861_Out_3, _Multiply_377CD458_Out_2);
                        float _Property_AA57477D_Out_0 = Vector1_4386BB13;
                        float _Multiply_A59FF53_Out_2;
                        Unity_Multiply_float(_Multiply_377CD458_Out_2, _Property_AA57477D_Out_0, _Multiply_A59FF53_Out_2);
                        float4 _Add_13002516_Out_2;
                        Unity_Add_float4(_Lerp_608D51B5_Out_3, (_Multiply_A59FF53_Out_2.xxxx), _Add_13002516_Out_2);
                        float _SceneDepth_6A5D647C_Out_1;
                        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_6A5D647C_Out_1);
                        float4 _ScreenPosition_D5C0B977_Out_0 = IN.ScreenPosition;
                        float _Split_D7132622_R_1 = _ScreenPosition_D5C0B977_Out_0[0];
                        float _Split_D7132622_G_2 = _ScreenPosition_D5C0B977_Out_0[1];
                        float _Split_D7132622_B_3 = _ScreenPosition_D5C0B977_Out_0[2];
                        float _Split_D7132622_A_4 = _ScreenPosition_D5C0B977_Out_0[3];
                        float _Subtract_EDAEA22B_Out_2;
                        Unity_Subtract_float(_Split_D7132622_A_4, 1, _Subtract_EDAEA22B_Out_2);
                        float _Subtract_D2C21BA_Out_2;
                        Unity_Subtract_float(_SceneDepth_6A5D647C_Out_1, _Subtract_EDAEA22B_Out_2, _Subtract_D2C21BA_Out_2);
                        float _Property_E72E495F_Out_0 = Vector1_ACA8BF6B;
                        float _Divide_69800C63_Out_2;
                        Unity_Divide_float(_Subtract_D2C21BA_Out_2, _Property_E72E495F_Out_0, _Divide_69800C63_Out_2);
                        float _Saturate_30FCF87F_Out_1;
                        Unity_Saturate_float(_Divide_69800C63_Out_2, _Saturate_30FCF87F_Out_1);
                        float _Property_27256254_Out_0 = Vector1_8F52779E;
                        float4 _Multiply_D88E026_Out_2;
                        Unity_Multiply_float(_Add_13002516_Out_2, (_Property_27256254_Out_0.xxxx), _Multiply_D88E026_Out_2);
                        surface.Color = (_Add_13002516_Out_2.xyz);
                        surface.Alpha = _Saturate_30FCF87F_Out_1;
                        surface.AlphaClipThreshold = 0;
                        surface.Emission = (_Multiply_D88E026_Out_2.xyz);
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                // output.ViewSpaceNormal =             TransformWorldToViewDir(output.WorldSpaceNormal);
                // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.ObjectSpaceTangent =          input.tangentOS;
                // output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                // output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                // output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                // output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                // output.ViewSpacePosition =           TransformWorldToView(output.WorldSpacePosition);
                // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                output.WorldSpaceViewDirection =     GetWorldSpaceNormalizeViewDir(output.WorldSpacePosition);
                // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                // output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(output.WorldSpacePosition), _ProjectionParams.x);
                // output.uv0 =                         input.uv0;
                // output.uv1 =                         input.uv1;
                // output.uv2 =                         input.uv2;
                // output.uv3 =                         input.uv3;
                // output.VertexColor =                 input.color;
                // output.BoneWeights =                 input.weights;
                // output.BoneIndices =                 input.indices;
            
                return output;
            }
            
            AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
            {
                // build graph inputs
                VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
                // Override time paramters with used one (This is required to correctly handle motion vector for vertex animation based on time)
                vertexDescriptionInputs.TimeParameters = timeParameters;
            
                // evaluate vertex graph
                VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
            
                // copy graph output to the results
                // input.positionOS = vertexDescription.VertexPosition;
                input.normalOS = vertexDescription.VertexNormal;
                input.tangentOS.xyz = vertexDescription.VertexTangent;
            
                return input;
            }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    // output.texCoord0 = input.texCoord0;
                    // output.texCoord1 = input.texCoord1;
                    // output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    // output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    // output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            #endif
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    output.WorldSpaceNormal =            input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
                    // output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    // output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    // output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    // output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    // output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            #endif
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                surfaceData.color = surfaceDescription.Color;
        
        #if defined(DEBUG_DISPLAY) && !defined(SHADER_STAGE_RAY_TRACING)
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO
                }
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData RAY_TRACING_OPTIONAL_PARAMETERS)
            {
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky.
        #ifdef _ALPHATEST_ON
                // GENERIC_ALPHA_TEST(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        #endif
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                    HDShadowContext shadowContext = InitShadowContext();
                    float shadow;
                    float3 shadow3;
                    posInput = GetPositionInput(fragInputs.positionSS.xy, _ScreenSize.zw, fragInputs.positionSS.z, UNITY_MATRIX_I_VP, UNITY_MATRIX_V);
                    float3 normalWS = normalize(fragInputs.tangentToWorld[1]);
                    uint renderingLayers = _EnableLightLayers ? asuint(unity_RenderingLayer.x) : DEFAULT_LIGHT_LAYERS;
                    ShadowLoopMin(shadowContext, posInput, normalWS, asuint(_ShadowMatteFilter), renderingLayers, shadow3);
                    shadow = dot(shadow3, float3(1.0f/3.0f, 1.0f/3.0f, 1.0f/3.0f));
        
                    float4 shadowColor = (1 - shadow)*surfaceDescription.ShadowTint.rgba;
                    float  localAlpha  = saturate(shadowColor.a + surfaceDescription.Alpha);
        
                    // Keep the nested lerp
                    // With no Color (bsdfData.color.rgb, bsdfData.color.a == 0.0f), just use ShadowColor*Color to avoid a ring of "white" around the shadow
                    // And mix color to consider the Color & ShadowColor alpha (from texture or/and color picker)
                    #ifdef _SURFACE_TYPE_TRANSPARENT
                        surfaceData.color = lerp(shadowColor.rgb*surfaceData.color, lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow), surfaceDescription.Alpha);
                    #else
                        surfaceData.color = lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow);
                    #endif
                    localAlpha = ApplyBlendMode(surfaceData.color, localAlpha).a;
        
                    surfaceDescription.Alpha = localAlpha;
                #endif
        
                // Builtin Data
                ZERO_INITIALIZE(BuiltinData, builtinData); // No call to InitBuiltinData as we don't have any lighting
                builtinData.opacity = surfaceDescription.Alpha;
        
                builtinData.emissiveColor = surfaceDescription.Emission;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #endif
                RAY_TRACING_OPTIONAL_ALPHA_TEST_PASS
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassRaytracingForward.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDUnlitPass.template
            Name "GBufferDXR"
            Tags { "LightMode" = "GBufferDXR" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            
            
            
            
            
            
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            //#pragma enable_d3d11_debug_symbols
        
            
        
            //-------------------------------------------------------------------------------------
            // Graph Defines
            //-------------------------------------------------------------------------------------
                    // Shared Graph Keywords
                #define SHADERPASS SHADERPASS_RAYTRACING_GBUFFER
                #pragma only_renderers d3d11
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   AlphaFog
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.WorldSpaceNormal
                //   SurfaceDescriptionInputs.WorldSpaceViewDirection
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   SurfaceDescriptionInputs.TimeParameters
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.WorldSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.WorldSpaceViewDirection
                //   VertexDescriptionInputs.WorldSpacePosition
                //   VertexDescriptionInputs.TimeParameters
                //   SurfaceDescription.Color
                //   SurfaceDescription.Alpha
                //   SurfaceDescription.AlphaClipThreshold
                //   SurfaceDescription.Emission
                //   features.modifyMesh
                //   VertexDescription.Color
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   FragInputs.tangentToWorld
                //   FragInputs.positionRWS
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.positionOS
                //   VaryingsMeshToPS.tangentWS
                //   VaryingsMeshToPS.normalWS
                //   VaryingsMeshToPS.positionRWS
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Variant
            //-------------------------------------------------------------------------------------
        
            // #pragma shader_feature_local _DOUBLESIDED_ON - We have no lighting, so no need to have this combination for shader, the option will just disable backface culling
        
            // Keyword for transparent
            #pragma shader_feature _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
            #pragma shader_feature_local _ALPHATEST_ON
        
            #pragma shader_feature_local        _ENABLE_FOG_ON_TRANSPARENT
            // #define _ADD_PRECOMPUTED_VELOCITY
            // #define _ENABLE_SHADOW_MATTE
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Shader stages
            //-------------------------------------------------------------------------------------
                    #pragma raytracing surface_shader
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Active Field Defines
            //-------------------------------------------------------------------------------------
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            // #define ATTRIBUTES_NEED_TEXCOORD0
            // #define ATTRIBUTES_NEED_TEXCOORD1
            // #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            // #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            // #define VARYINGS_NEED_TEXCOORD0
            // #define VARYINGS_NEED_TEXCOORD1
            // #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            // #define VARYINGS_NEED_COLOR
            // #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                #define LIGHTLOOP_DISABLE_TILE_AND_CLUSTER
                #define HAS_LIGHTLOOP
                #define SHADOW_OPTIMIZE_REGISTER_USAGE 1
        
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonLighting.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Shadow/HDShadowContext.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadow.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/PunctualLightCommon.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadowLoop.hlsl"
            #endif
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
            
        #if !defined(SHADER_STAGE_RAY_TRACING)
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracing.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracingLightLoop.hlsl"
        
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/Deferred/RaytracingIntersectonGBuffer.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingIntersection.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/NormalBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/StandardLit/StandardLit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/UnlitRaytracing.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingCommon.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #endif
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION;
                float3 positionRWS; // optional
                float3 normalWS; // optional
                float4 tangentWS; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
                float4 interp02 : TEXCOORD2; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output = (VaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output = (VaryingsMeshToDS)0;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Vector4_4FE19BDB;
                    float Vector1_97EA0DEA;
                    float Vector1_BB19229D;
                    float Vector1_1D2D6758;
                    float4 Vector4_53C3CAF3;
                    float4 Color_5100B6B6;
                    float4 Color_9F979F9B;
                    float Vector1_8B47B562;
                    float Vector1_DD2A7971;
                    float Vector1_7D71E79C;
                    float Vector1_F4FD2233;
                    float Vector1_3783F0D6;
                    float Vector1_89D9BA77;
                    float Vector1_8F52779E;
                    float Vector1_2B356380;
                    float Vector1_7892E05E;
                    float Vector1_4386BB13;
                    float Vector1_ACA8BF6B;
                    float4 _EmissionColor;
                    float _RenderQueueType;
                    float _StencilRef;
                    float _StencilWriteMask;
                    float _StencilRefDepth;
                    float _StencilWriteMaskDepth;
                    float _StencilRefMV;
                    float _StencilWriteMaskMV;
                    float _StencilRefDistortionVec;
                    float _StencilWriteMaskDistortionVec;
                    float _StencilWriteMaskGBuffer;
                    float _StencilRefGBuffer;
                    float _ZTestGBuffer;
                    float _RequireSplitLighting;
                    float _ReceivesSSR;
                    float _SurfaceType;
                    float _BlendMode;
                    float _SrcBlend;
                    float _DstBlend;
                    float _AlphaSrcBlend;
                    float _AlphaDstBlend;
                    float _ZWrite;
                    float _TransparentZWrite;
                    float _CullMode;
                    float _TransparentSortPriority;
                    float _EnableFogOnTransparent;
                    float _CullModeForward;
                    float _TransparentCullMode;
                    float _ZTestDepthEqualForOpaque;
                    float _ZTestTransparent;
                    float _TransparentBackfaceEnable;
                    float _AlphaCutoffEnable;
                    float _UseShadowThreshold;
                    float _DoubleSidedEnable;
                    float _DoubleSidedNormalMode;
                    float4 _DoubleSidedConstants;
                    float _TransparentDepthPrepassEnable;
                    float _TransparentDepthPostpassEnable;
                    CBUFFER_END
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs
                    {
                        float3 ObjectSpaceNormal; // optional
                        float3 WorldSpaceNormal; // optional
                        float3 ObjectSpaceTangent; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 WorldSpacePosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 Color;
                        float3 VertexNormal;
                        float3 VertexTangent;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpaceNormal; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 WorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Color;
                        float Alpha;
                        float AlphaClipThreshold;
                        float3 Emission;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
                    {
                        Rotation = radians(Rotation);
                
                        float s = sin(Rotation);
                        float c = cos(Rotation);
                        float one_minus_c = 1.0 - c;
                        
                        Axis = normalize(Axis);
                
                        float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                                  one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                                  one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                                };
                
                        Out = mul(rot_mat,  In);
                    }
                
                    void Unity_Multiply_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
                float2 Unity_GradientNoise_Dir_float(float2 p)
                {
                    // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                    p = p % 289;
                    float x = (34 * p.x + 1) * p.x % 289 + p.y;
                    x = (34 * x + 1) * x % 289;
                    x = frac(x / 41) * 2 - 1;
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { 
                        float2 p = UV * Scale;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }
                
                    void Unity_Saturate_float(float In, out float Out)
                    {
                        Out = saturate(In);
                    }
                
                    void Unity_Power_float(float A, float B, out float Out)
                    {
                        Out = pow(A, B);
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                    {
                        Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                    }
                
                    void Unity_Absolute_float(float In, out float Out)
                    {
                        Out = abs(In);
                    }
                
                    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                    {
                        Out = smoothstep(Edge1, Edge2, In);
                    }
                
                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
                    {
                        Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
                    }
                
                    void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
                    {
                        Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float4 _Property_539FFD11_Out_0 = Color_5100B6B6;
                        float4 _Property_23C63215_Out_0 = Color_9F979F9B;
                        float _Property_F656DB82_Out_0 = Vector1_8B47B562;
                        float _Property_E6FCF144_Out_0 = Vector1_DD2A7971;
                        float4 _Property_4CE5882F_Out_0 = Vector4_4FE19BDB;
                        float _Split_6C3848B1_R_1 = _Property_4CE5882F_Out_0[0];
                        float _Split_6C3848B1_G_2 = _Property_4CE5882F_Out_0[1];
                        float _Split_6C3848B1_B_3 = _Property_4CE5882F_Out_0[2];
                        float _Split_6C3848B1_A_4 = _Property_4CE5882F_Out_0[3];
                        float3 _RotateAboutAxis_5D606F9C_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_4CE5882F_Out_0.xyz), _Split_6C3848B1_A_4, _RotateAboutAxis_5D606F9C_Out_3);
                        float _Property_D1CCB3D3_Out_0 = Vector1_BB19229D;
                        float _Multiply_C1DBBF46_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_D1CCB3D3_Out_0, _Multiply_C1DBBF46_Out_2);
                        float2 _TilingAndOffset_D9156ED9_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_C1DBBF46_Out_2.xx), _TilingAndOffset_D9156ED9_Out_3);
                        float _Property_12322142_Out_0 = Vector1_97EA0DEA;
                        float _GradientNoise_AB0C880E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_D9156ED9_Out_3, _Property_12322142_Out_0, _GradientNoise_AB0C880E_Out_2);
                        float2 _TilingAndOffset_7FBE33C6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7FBE33C6_Out_3);
                        float _GradientNoise_F3C2A41D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7FBE33C6_Out_3, _Property_12322142_Out_0, _GradientNoise_F3C2A41D_Out_2);
                        float _Add_20294542_Out_2;
                        Unity_Add_float(_GradientNoise_AB0C880E_Out_2, _GradientNoise_F3C2A41D_Out_2, _Add_20294542_Out_2);
                        float _Divide_99AB6A24_Out_2;
                        Unity_Divide_float(_Add_20294542_Out_2, 2, _Divide_99AB6A24_Out_2);
                        float _Saturate_9A75CBB3_Out_1;
                        Unity_Saturate_float(_Divide_99AB6A24_Out_2, _Saturate_9A75CBB3_Out_1);
                        float _Property_56CA339D_Out_0 = Vector1_7D71E79C;
                        float _Power_B404C8D5_Out_2;
                        Unity_Power_float(_Saturate_9A75CBB3_Out_1, _Property_56CA339D_Out_0, _Power_B404C8D5_Out_2);
                        float4 _Property_CBC31DB7_Out_0 = Vector4_53C3CAF3;
                        float _Split_738E9079_R_1 = _Property_CBC31DB7_Out_0[0];
                        float _Split_738E9079_G_2 = _Property_CBC31DB7_Out_0[1];
                        float _Split_738E9079_B_3 = _Property_CBC31DB7_Out_0[2];
                        float _Split_738E9079_A_4 = _Property_CBC31DB7_Out_0[3];
                        float4 _Combine_D4E1A601_RGBA_4;
                        float3 _Combine_D4E1A601_RGB_5;
                        float2 _Combine_D4E1A601_RG_6;
                        Unity_Combine_float(_Split_738E9079_R_1, _Split_738E9079_G_2, 0, 0, _Combine_D4E1A601_RGBA_4, _Combine_D4E1A601_RGB_5, _Combine_D4E1A601_RG_6);
                        float4 _Combine_B3F9DAE4_RGBA_4;
                        float3 _Combine_B3F9DAE4_RGB_5;
                        float2 _Combine_B3F9DAE4_RG_6;
                        Unity_Combine_float(_Split_738E9079_B_3, _Split_738E9079_A_4, 0, 0, _Combine_B3F9DAE4_RGBA_4, _Combine_B3F9DAE4_RGB_5, _Combine_B3F9DAE4_RG_6);
                        float _Remap_8141F08C_Out_3;
                        Unity_Remap_float(_Power_B404C8D5_Out_2, _Combine_D4E1A601_RG_6, _Combine_B3F9DAE4_RG_6, _Remap_8141F08C_Out_3);
                        float _Absolute_DA707E52_Out_1;
                        Unity_Absolute_float(_Remap_8141F08C_Out_3, _Absolute_DA707E52_Out_1);
                        float _Smoothstep_A9222CB5_Out_3;
                        Unity_Smoothstep_float(_Property_F656DB82_Out_0, _Property_E6FCF144_Out_0, _Absolute_DA707E52_Out_1, _Smoothstep_A9222CB5_Out_3);
                        float _Property_B22C6734_Out_0 = Vector1_3783F0D6;
                        float _Multiply_9C4F241C_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_B22C6734_Out_0, _Multiply_9C4F241C_Out_2);
                        float2 _TilingAndOffset_8D91A587_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_9C4F241C_Out_2.xx), _TilingAndOffset_8D91A587_Out_3);
                        float _Property_E409C129_Out_0 = Vector1_F4FD2233;
                        float _GradientNoise_81BAEB4A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_8D91A587_Out_3, _Property_E409C129_Out_0, _GradientNoise_81BAEB4A_Out_2);
                        float _Property_C4CE44E0_Out_0 = Vector1_89D9BA77;
                        float _Multiply_F5DA2647_Out_2;
                        Unity_Multiply_float(_GradientNoise_81BAEB4A_Out_2, _Property_C4CE44E0_Out_0, _Multiply_F5DA2647_Out_2);
                        float _Add_CAB25FE5_Out_2;
                        Unity_Add_float(_Smoothstep_A9222CB5_Out_3, _Multiply_F5DA2647_Out_2, _Add_CAB25FE5_Out_2);
                        float _Add_92F04FE1_Out_2;
                        Unity_Add_float(1, _Property_C4CE44E0_Out_0, _Add_92F04FE1_Out_2);
                        float _Divide_D05AE96_Out_2;
                        Unity_Divide_float(_Add_CAB25FE5_Out_2, _Add_92F04FE1_Out_2, _Divide_D05AE96_Out_2);
                        float4 _Lerp_608D51B5_Out_3;
                        Unity_Lerp_float4(_Property_539FFD11_Out_0, _Property_23C63215_Out_0, (_Divide_D05AE96_Out_2.xxxx), _Lerp_608D51B5_Out_3);
                        float _Property_189FD6C_Out_0 = Vector1_7892E05E;
                        float _FresnelEffect_83E7E861_Out_3;
                        Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_189FD6C_Out_0, _FresnelEffect_83E7E861_Out_3);
                        float _Multiply_377CD458_Out_2;
                        Unity_Multiply_float(_Divide_D05AE96_Out_2, _FresnelEffect_83E7E861_Out_3, _Multiply_377CD458_Out_2);
                        float _Property_AA57477D_Out_0 = Vector1_4386BB13;
                        float _Multiply_A59FF53_Out_2;
                        Unity_Multiply_float(_Multiply_377CD458_Out_2, _Property_AA57477D_Out_0, _Multiply_A59FF53_Out_2);
                        float4 _Add_13002516_Out_2;
                        Unity_Add_float4(_Lerp_608D51B5_Out_3, (_Multiply_A59FF53_Out_2.xxxx), _Add_13002516_Out_2);
                        description.Color = (_Add_13002516_Out_2.xyz);
                        description.VertexNormal = IN.ObjectSpaceNormal;
                        description.VertexTangent = IN.ObjectSpaceTangent;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _Property_539FFD11_Out_0 = Color_5100B6B6;
                        float4 _Property_23C63215_Out_0 = Color_9F979F9B;
                        float _Property_F656DB82_Out_0 = Vector1_8B47B562;
                        float _Property_E6FCF144_Out_0 = Vector1_DD2A7971;
                        float4 _Property_4CE5882F_Out_0 = Vector4_4FE19BDB;
                        float _Split_6C3848B1_R_1 = _Property_4CE5882F_Out_0[0];
                        float _Split_6C3848B1_G_2 = _Property_4CE5882F_Out_0[1];
                        float _Split_6C3848B1_B_3 = _Property_4CE5882F_Out_0[2];
                        float _Split_6C3848B1_A_4 = _Property_4CE5882F_Out_0[3];
                        float3 _RotateAboutAxis_5D606F9C_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_4CE5882F_Out_0.xyz), _Split_6C3848B1_A_4, _RotateAboutAxis_5D606F9C_Out_3);
                        float _Property_D1CCB3D3_Out_0 = Vector1_BB19229D;
                        float _Multiply_C1DBBF46_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_D1CCB3D3_Out_0, _Multiply_C1DBBF46_Out_2);
                        float2 _TilingAndOffset_D9156ED9_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_C1DBBF46_Out_2.xx), _TilingAndOffset_D9156ED9_Out_3);
                        float _Property_12322142_Out_0 = Vector1_97EA0DEA;
                        float _GradientNoise_AB0C880E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_D9156ED9_Out_3, _Property_12322142_Out_0, _GradientNoise_AB0C880E_Out_2);
                        float2 _TilingAndOffset_7FBE33C6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7FBE33C6_Out_3);
                        float _GradientNoise_F3C2A41D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7FBE33C6_Out_3, _Property_12322142_Out_0, _GradientNoise_F3C2A41D_Out_2);
                        float _Add_20294542_Out_2;
                        Unity_Add_float(_GradientNoise_AB0C880E_Out_2, _GradientNoise_F3C2A41D_Out_2, _Add_20294542_Out_2);
                        float _Divide_99AB6A24_Out_2;
                        Unity_Divide_float(_Add_20294542_Out_2, 2, _Divide_99AB6A24_Out_2);
                        float _Saturate_9A75CBB3_Out_1;
                        Unity_Saturate_float(_Divide_99AB6A24_Out_2, _Saturate_9A75CBB3_Out_1);
                        float _Property_56CA339D_Out_0 = Vector1_7D71E79C;
                        float _Power_B404C8D5_Out_2;
                        Unity_Power_float(_Saturate_9A75CBB3_Out_1, _Property_56CA339D_Out_0, _Power_B404C8D5_Out_2);
                        float4 _Property_CBC31DB7_Out_0 = Vector4_53C3CAF3;
                        float _Split_738E9079_R_1 = _Property_CBC31DB7_Out_0[0];
                        float _Split_738E9079_G_2 = _Property_CBC31DB7_Out_0[1];
                        float _Split_738E9079_B_3 = _Property_CBC31DB7_Out_0[2];
                        float _Split_738E9079_A_4 = _Property_CBC31DB7_Out_0[3];
                        float4 _Combine_D4E1A601_RGBA_4;
                        float3 _Combine_D4E1A601_RGB_5;
                        float2 _Combine_D4E1A601_RG_6;
                        Unity_Combine_float(_Split_738E9079_R_1, _Split_738E9079_G_2, 0, 0, _Combine_D4E1A601_RGBA_4, _Combine_D4E1A601_RGB_5, _Combine_D4E1A601_RG_6);
                        float4 _Combine_B3F9DAE4_RGBA_4;
                        float3 _Combine_B3F9DAE4_RGB_5;
                        float2 _Combine_B3F9DAE4_RG_6;
                        Unity_Combine_float(_Split_738E9079_B_3, _Split_738E9079_A_4, 0, 0, _Combine_B3F9DAE4_RGBA_4, _Combine_B3F9DAE4_RGB_5, _Combine_B3F9DAE4_RG_6);
                        float _Remap_8141F08C_Out_3;
                        Unity_Remap_float(_Power_B404C8D5_Out_2, _Combine_D4E1A601_RG_6, _Combine_B3F9DAE4_RG_6, _Remap_8141F08C_Out_3);
                        float _Absolute_DA707E52_Out_1;
                        Unity_Absolute_float(_Remap_8141F08C_Out_3, _Absolute_DA707E52_Out_1);
                        float _Smoothstep_A9222CB5_Out_3;
                        Unity_Smoothstep_float(_Property_F656DB82_Out_0, _Property_E6FCF144_Out_0, _Absolute_DA707E52_Out_1, _Smoothstep_A9222CB5_Out_3);
                        float _Property_B22C6734_Out_0 = Vector1_3783F0D6;
                        float _Multiply_9C4F241C_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_B22C6734_Out_0, _Multiply_9C4F241C_Out_2);
                        float2 _TilingAndOffset_8D91A587_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_9C4F241C_Out_2.xx), _TilingAndOffset_8D91A587_Out_3);
                        float _Property_E409C129_Out_0 = Vector1_F4FD2233;
                        float _GradientNoise_81BAEB4A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_8D91A587_Out_3, _Property_E409C129_Out_0, _GradientNoise_81BAEB4A_Out_2);
                        float _Property_C4CE44E0_Out_0 = Vector1_89D9BA77;
                        float _Multiply_F5DA2647_Out_2;
                        Unity_Multiply_float(_GradientNoise_81BAEB4A_Out_2, _Property_C4CE44E0_Out_0, _Multiply_F5DA2647_Out_2);
                        float _Add_CAB25FE5_Out_2;
                        Unity_Add_float(_Smoothstep_A9222CB5_Out_3, _Multiply_F5DA2647_Out_2, _Add_CAB25FE5_Out_2);
                        float _Add_92F04FE1_Out_2;
                        Unity_Add_float(1, _Property_C4CE44E0_Out_0, _Add_92F04FE1_Out_2);
                        float _Divide_D05AE96_Out_2;
                        Unity_Divide_float(_Add_CAB25FE5_Out_2, _Add_92F04FE1_Out_2, _Divide_D05AE96_Out_2);
                        float4 _Lerp_608D51B5_Out_3;
                        Unity_Lerp_float4(_Property_539FFD11_Out_0, _Property_23C63215_Out_0, (_Divide_D05AE96_Out_2.xxxx), _Lerp_608D51B5_Out_3);
                        float _Property_189FD6C_Out_0 = Vector1_7892E05E;
                        float _FresnelEffect_83E7E861_Out_3;
                        Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_189FD6C_Out_0, _FresnelEffect_83E7E861_Out_3);
                        float _Multiply_377CD458_Out_2;
                        Unity_Multiply_float(_Divide_D05AE96_Out_2, _FresnelEffect_83E7E861_Out_3, _Multiply_377CD458_Out_2);
                        float _Property_AA57477D_Out_0 = Vector1_4386BB13;
                        float _Multiply_A59FF53_Out_2;
                        Unity_Multiply_float(_Multiply_377CD458_Out_2, _Property_AA57477D_Out_0, _Multiply_A59FF53_Out_2);
                        float4 _Add_13002516_Out_2;
                        Unity_Add_float4(_Lerp_608D51B5_Out_3, (_Multiply_A59FF53_Out_2.xxxx), _Add_13002516_Out_2);
                        float _SceneDepth_6A5D647C_Out_1;
                        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_6A5D647C_Out_1);
                        float4 _ScreenPosition_D5C0B977_Out_0 = IN.ScreenPosition;
                        float _Split_D7132622_R_1 = _ScreenPosition_D5C0B977_Out_0[0];
                        float _Split_D7132622_G_2 = _ScreenPosition_D5C0B977_Out_0[1];
                        float _Split_D7132622_B_3 = _ScreenPosition_D5C0B977_Out_0[2];
                        float _Split_D7132622_A_4 = _ScreenPosition_D5C0B977_Out_0[3];
                        float _Subtract_EDAEA22B_Out_2;
                        Unity_Subtract_float(_Split_D7132622_A_4, 1, _Subtract_EDAEA22B_Out_2);
                        float _Subtract_D2C21BA_Out_2;
                        Unity_Subtract_float(_SceneDepth_6A5D647C_Out_1, _Subtract_EDAEA22B_Out_2, _Subtract_D2C21BA_Out_2);
                        float _Property_E72E495F_Out_0 = Vector1_ACA8BF6B;
                        float _Divide_69800C63_Out_2;
                        Unity_Divide_float(_Subtract_D2C21BA_Out_2, _Property_E72E495F_Out_0, _Divide_69800C63_Out_2);
                        float _Saturate_30FCF87F_Out_1;
                        Unity_Saturate_float(_Divide_69800C63_Out_2, _Saturate_30FCF87F_Out_1);
                        float _Property_27256254_Out_0 = Vector1_8F52779E;
                        float4 _Multiply_D88E026_Out_2;
                        Unity_Multiply_float(_Add_13002516_Out_2, (_Property_27256254_Out_0.xxxx), _Multiply_D88E026_Out_2);
                        surface.Color = (_Add_13002516_Out_2.xyz);
                        surface.Alpha = _Saturate_30FCF87F_Out_1;
                        surface.AlphaClipThreshold = 0;
                        surface.Emission = (_Multiply_D88E026_Out_2.xyz);
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                // output.ViewSpaceNormal =             TransformWorldToViewDir(output.WorldSpaceNormal);
                // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.ObjectSpaceTangent =          input.tangentOS;
                // output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                // output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                // output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                // output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                // output.ViewSpacePosition =           TransformWorldToView(output.WorldSpacePosition);
                // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                output.WorldSpaceViewDirection =     GetWorldSpaceNormalizeViewDir(output.WorldSpacePosition);
                // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                // output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(output.WorldSpacePosition), _ProjectionParams.x);
                // output.uv0 =                         input.uv0;
                // output.uv1 =                         input.uv1;
                // output.uv2 =                         input.uv2;
                // output.uv3 =                         input.uv3;
                // output.VertexColor =                 input.color;
                // output.BoneWeights =                 input.weights;
                // output.BoneIndices =                 input.indices;
            
                return output;
            }
            
            AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
            {
                // build graph inputs
                VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
                // Override time paramters with used one (This is required to correctly handle motion vector for vertex animation based on time)
                vertexDescriptionInputs.TimeParameters = timeParameters;
            
                // evaluate vertex graph
                VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
            
                // copy graph output to the results
                // input.positionOS = vertexDescription.VertexPosition;
                input.normalOS = vertexDescription.VertexNormal;
                input.tangentOS.xyz = vertexDescription.VertexTangent;
            
                return input;
            }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    // output.texCoord0 = input.texCoord0;
                    // output.texCoord1 = input.texCoord1;
                    // output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    // output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    // output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            #endif
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    output.WorldSpaceNormal =            input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
                    // output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    // output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    // output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    // output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    // output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            #endif
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                surfaceData.color = surfaceDescription.Color;
        
        #if defined(DEBUG_DISPLAY) && !defined(SHADER_STAGE_RAY_TRACING)
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO
                }
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData RAY_TRACING_OPTIONAL_PARAMETERS)
            {
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky.
        #ifdef _ALPHATEST_ON
                // GENERIC_ALPHA_TEST(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        #endif
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                    HDShadowContext shadowContext = InitShadowContext();
                    float shadow;
                    float3 shadow3;
                    posInput = GetPositionInput(fragInputs.positionSS.xy, _ScreenSize.zw, fragInputs.positionSS.z, UNITY_MATRIX_I_VP, UNITY_MATRIX_V);
                    float3 normalWS = normalize(fragInputs.tangentToWorld[1]);
                    uint renderingLayers = _EnableLightLayers ? asuint(unity_RenderingLayer.x) : DEFAULT_LIGHT_LAYERS;
                    ShadowLoopMin(shadowContext, posInput, normalWS, asuint(_ShadowMatteFilter), renderingLayers, shadow3);
                    shadow = dot(shadow3, float3(1.0f/3.0f, 1.0f/3.0f, 1.0f/3.0f));
        
                    float4 shadowColor = (1 - shadow)*surfaceDescription.ShadowTint.rgba;
                    float  localAlpha  = saturate(shadowColor.a + surfaceDescription.Alpha);
        
                    // Keep the nested lerp
                    // With no Color (bsdfData.color.rgb, bsdfData.color.a == 0.0f), just use ShadowColor*Color to avoid a ring of "white" around the shadow
                    // And mix color to consider the Color & ShadowColor alpha (from texture or/and color picker)
                    #ifdef _SURFACE_TYPE_TRANSPARENT
                        surfaceData.color = lerp(shadowColor.rgb*surfaceData.color, lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow), surfaceDescription.Alpha);
                    #else
                        surfaceData.color = lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow);
                    #endif
                    localAlpha = ApplyBlendMode(surfaceData.color, localAlpha).a;
        
                    surfaceDescription.Alpha = localAlpha;
                #endif
        
                // Builtin Data
                ZERO_INITIALIZE(BuiltinData, builtinData); // No call to InitBuiltinData as we don't have any lighting
                builtinData.opacity = surfaceDescription.Alpha;
        
                builtinData.emissiveColor = surfaceDescription.Emission;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #endif
                RAY_TRACING_OPTIONAL_ALPHA_TEST_PASS
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderpassRaytracingGBuffer.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDUnlitPass.template
            Name "PathTracingDXR"
            Tags { "LightMode" = "PathTracingDXR" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            
            
            
            
            
            
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            //#pragma enable_d3d11_debug_symbols
        
            
        
            //-------------------------------------------------------------------------------------
            // Graph Defines
            //-------------------------------------------------------------------------------------
                    // Shared Graph Keywords
                #define SHADERPASS SHADERPASS_PATH_TRACING
                #pragma only_renderers d3d11
                #define REQUIRE_DEPTH_TEXTURE
                // ACTIVE FIELDS:
                //   AlphaFog
                //   SurfaceDescriptionInputs.ScreenPosition
                //   SurfaceDescriptionInputs.WorldSpaceNormal
                //   SurfaceDescriptionInputs.WorldSpaceViewDirection
                //   SurfaceDescriptionInputs.WorldSpacePosition
                //   SurfaceDescriptionInputs.TimeParameters
                //   VertexDescriptionInputs.ObjectSpaceNormal
                //   VertexDescriptionInputs.WorldSpaceNormal
                //   VertexDescriptionInputs.ObjectSpaceTangent
                //   VertexDescriptionInputs.WorldSpaceViewDirection
                //   VertexDescriptionInputs.WorldSpacePosition
                //   VertexDescriptionInputs.TimeParameters
                //   SurfaceDescription.Color
                //   SurfaceDescription.Alpha
                //   SurfaceDescription.AlphaClipThreshold
                //   SurfaceDescription.Emission
                //   features.modifyMesh
                //   VertexDescription.Color
                //   VertexDescription.VertexNormal
                //   VertexDescription.VertexTangent
                //   FragInputs.tangentToWorld
                //   FragInputs.positionRWS
                //   AttributesMesh.normalOS
                //   AttributesMesh.tangentOS
                //   AttributesMesh.positionOS
                //   VaryingsMeshToPS.tangentWS
                //   VaryingsMeshToPS.normalWS
                //   VaryingsMeshToPS.positionRWS
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Variant
            //-------------------------------------------------------------------------------------
        
            // #pragma shader_feature_local _DOUBLESIDED_ON - We have no lighting, so no need to have this combination for shader, the option will just disable backface culling
        
            // Keyword for transparent
            #pragma shader_feature _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local _ _BLENDMODE_ALPHA _BLENDMODE_ADD _BLENDMODE_PRE_MULTIPLY
            #pragma shader_feature_local _ALPHATEST_ON
        
            #pragma shader_feature_local        _ENABLE_FOG_ON_TRANSPARENT
            // #define _ADD_PRECOMPUTED_VELOCITY
            // #define _ENABLE_SHADOW_MATTE
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Shader stages
            //-------------------------------------------------------------------------------------
                    #pragma raytracing surface_shader
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Active Field Defines
            //-------------------------------------------------------------------------------------
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            // #define ATTRIBUTES_NEED_TEXCOORD0
            // #define ATTRIBUTES_NEED_TEXCOORD1
            // #define ATTRIBUTES_NEED_TEXCOORD2
            // #define ATTRIBUTES_NEED_TEXCOORD3
            // #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            // #define VARYINGS_NEED_TEXCOORD0
            // #define VARYINGS_NEED_TEXCOORD1
            // #define VARYINGS_NEED_TEXCOORD2
            // #define VARYINGS_NEED_TEXCOORD3
            // #define VARYINGS_NEED_COLOR
            // #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                #define LIGHTLOOP_DISABLE_TILE_AND_CLUSTER
                #define HAS_LIGHTLOOP
                #define SHADOW_OPTIMIZE_REGISTER_USAGE 1
        
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonLighting.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Shadow/HDShadowContext.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadow.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/PunctualLightCommon.hlsl"
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/HDShadowLoop.hlsl"
            #endif
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
            
        #if !defined(SHADER_STAGE_RAY_TRACING)
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingMacros.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracing.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/ShaderVariablesRaytracingLightLoop.hlsl"
        
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/Deferred/RaytracingIntersectonGBuffer.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingIntersection.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        #if (SHADERPASS == SHADERPASS_RAYTRACING_GBUFFER)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/NormalBuffer.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/StandardLit/StandardLit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/UnlitRaytracing.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/Raytracing/Shaders/RaytracingCommon.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #endif
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
            // Generated Type: AttributesMesh
            struct AttributesMesh
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            // Generated Type: VaryingsMeshToPS
            struct VaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION;
                float3 positionRWS; // optional
                float3 normalWS; // optional
                float4 tangentWS; // optional
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif // defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            };
            
            // Generated Type: PackedVaryingsMeshToPS
            struct PackedVaryingsMeshToPS
            {
                float4 positionCS : SV_POSITION; // unpacked
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
                float4 interp02 : TEXCOORD2; // auto-packed
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
                #endif // conditional
            };
            
            // Packed Type: VaryingsMeshToPS
            PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
            {
                PackedVaryingsMeshToPS output = (PackedVaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToPS
            VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
            {
                VaryingsMeshToPS output = (VaryingsMeshToPS)0;
                output.positionCS = input.positionCS;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif // conditional
                return output;
            }
            // Generated Type: VaryingsMeshToDS
            struct VaryingsMeshToDS
            {
                float3 positionRWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif // UNITY_ANY_INSTANCING_ENABLED
            };
            
            // Generated Type: PackedVaryingsMeshToDS
            struct PackedVaryingsMeshToDS
            {
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID; // unpacked
                #endif // conditional
                float3 interp00 : TEXCOORD0; // auto-packed
                float3 interp01 : TEXCOORD1; // auto-packed
            };
            
            // Packed Type: VaryingsMeshToDS
            PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
            {
                PackedVaryingsMeshToDS output = (PackedVaryingsMeshToDS)0;
                output.interp00.xyz = input.positionRWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            
            // Unpacked Type: VaryingsMeshToDS
            VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
            {
                VaryingsMeshToDS output = (VaryingsMeshToDS)0;
                output.positionRWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif // conditional
                return output;
            }
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Vector4_4FE19BDB;
                    float Vector1_97EA0DEA;
                    float Vector1_BB19229D;
                    float Vector1_1D2D6758;
                    float4 Vector4_53C3CAF3;
                    float4 Color_5100B6B6;
                    float4 Color_9F979F9B;
                    float Vector1_8B47B562;
                    float Vector1_DD2A7971;
                    float Vector1_7D71E79C;
                    float Vector1_F4FD2233;
                    float Vector1_3783F0D6;
                    float Vector1_89D9BA77;
                    float Vector1_8F52779E;
                    float Vector1_2B356380;
                    float Vector1_7892E05E;
                    float Vector1_4386BB13;
                    float Vector1_ACA8BF6B;
                    float4 _EmissionColor;
                    float _RenderQueueType;
                    float _StencilRef;
                    float _StencilWriteMask;
                    float _StencilRefDepth;
                    float _StencilWriteMaskDepth;
                    float _StencilRefMV;
                    float _StencilWriteMaskMV;
                    float _StencilRefDistortionVec;
                    float _StencilWriteMaskDistortionVec;
                    float _StencilWriteMaskGBuffer;
                    float _StencilRefGBuffer;
                    float _ZTestGBuffer;
                    float _RequireSplitLighting;
                    float _ReceivesSSR;
                    float _SurfaceType;
                    float _BlendMode;
                    float _SrcBlend;
                    float _DstBlend;
                    float _AlphaSrcBlend;
                    float _AlphaDstBlend;
                    float _ZWrite;
                    float _TransparentZWrite;
                    float _CullMode;
                    float _TransparentSortPriority;
                    float _EnableFogOnTransparent;
                    float _CullModeForward;
                    float _TransparentCullMode;
                    float _ZTestDepthEqualForOpaque;
                    float _ZTestTransparent;
                    float _TransparentBackfaceEnable;
                    float _AlphaCutoffEnable;
                    float _UseShadowThreshold;
                    float _DoubleSidedEnable;
                    float _DoubleSidedNormalMode;
                    float4 _DoubleSidedConstants;
                    float _TransparentDepthPrepassEnable;
                    float _TransparentDepthPostpassEnable;
                    CBUFFER_END
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs
                    {
                        float3 ObjectSpaceNormal; // optional
                        float3 WorldSpaceNormal; // optional
                        float3 ObjectSpaceTangent; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 WorldSpacePosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 Color;
                        float3 VertexNormal;
                        float3 VertexTangent;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpaceNormal; // optional
                        float3 WorldSpaceViewDirection; // optional
                        float3 WorldSpacePosition; // optional
                        float4 ScreenPosition; // optional
                        float3 TimeParameters; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Color;
                        float Alpha;
                        float AlphaClipThreshold;
                        float3 Emission;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
                    {
                        Rotation = radians(Rotation);
                
                        float s = sin(Rotation);
                        float c = cos(Rotation);
                        float one_minus_c = 1.0 - c;
                        
                        Axis = normalize(Axis);
                
                        float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                                  one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                                  one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                                };
                
                        Out = mul(rot_mat,  In);
                    }
                
                    void Unity_Multiply_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
                float2 Unity_GradientNoise_Dir_float(float2 p)
                {
                    // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                    p = p % 289;
                    float x = (34 * p.x + 1) * p.x % 289 + p.y;
                    x = (34 * x + 1) * x % 289;
                    x = frac(x / 41) * 2 - 1;
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }
                
                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { 
                        float2 p = UV * Scale;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }
                
                    void Unity_Saturate_float(float In, out float Out)
                    {
                        Out = saturate(In);
                    }
                
                    void Unity_Power_float(float A, float B, out float Out)
                    {
                        Out = pow(A, B);
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
                    {
                        Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
                    }
                
                    void Unity_Absolute_float(float In, out float Out)
                    {
                        Out = abs(In);
                    }
                
                    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                    {
                        Out = smoothstep(Edge1, Edge2, In);
                    }
                
                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
                    {
                        Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
                    }
                
                    void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
                    {
                        Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float4 _Property_539FFD11_Out_0 = Color_5100B6B6;
                        float4 _Property_23C63215_Out_0 = Color_9F979F9B;
                        float _Property_F656DB82_Out_0 = Vector1_8B47B562;
                        float _Property_E6FCF144_Out_0 = Vector1_DD2A7971;
                        float4 _Property_4CE5882F_Out_0 = Vector4_4FE19BDB;
                        float _Split_6C3848B1_R_1 = _Property_4CE5882F_Out_0[0];
                        float _Split_6C3848B1_G_2 = _Property_4CE5882F_Out_0[1];
                        float _Split_6C3848B1_B_3 = _Property_4CE5882F_Out_0[2];
                        float _Split_6C3848B1_A_4 = _Property_4CE5882F_Out_0[3];
                        float3 _RotateAboutAxis_5D606F9C_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_4CE5882F_Out_0.xyz), _Split_6C3848B1_A_4, _RotateAboutAxis_5D606F9C_Out_3);
                        float _Property_D1CCB3D3_Out_0 = Vector1_BB19229D;
                        float _Multiply_C1DBBF46_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_D1CCB3D3_Out_0, _Multiply_C1DBBF46_Out_2);
                        float2 _TilingAndOffset_D9156ED9_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_C1DBBF46_Out_2.xx), _TilingAndOffset_D9156ED9_Out_3);
                        float _Property_12322142_Out_0 = Vector1_97EA0DEA;
                        float _GradientNoise_AB0C880E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_D9156ED9_Out_3, _Property_12322142_Out_0, _GradientNoise_AB0C880E_Out_2);
                        float2 _TilingAndOffset_7FBE33C6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7FBE33C6_Out_3);
                        float _GradientNoise_F3C2A41D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7FBE33C6_Out_3, _Property_12322142_Out_0, _GradientNoise_F3C2A41D_Out_2);
                        float _Add_20294542_Out_2;
                        Unity_Add_float(_GradientNoise_AB0C880E_Out_2, _GradientNoise_F3C2A41D_Out_2, _Add_20294542_Out_2);
                        float _Divide_99AB6A24_Out_2;
                        Unity_Divide_float(_Add_20294542_Out_2, 2, _Divide_99AB6A24_Out_2);
                        float _Saturate_9A75CBB3_Out_1;
                        Unity_Saturate_float(_Divide_99AB6A24_Out_2, _Saturate_9A75CBB3_Out_1);
                        float _Property_56CA339D_Out_0 = Vector1_7D71E79C;
                        float _Power_B404C8D5_Out_2;
                        Unity_Power_float(_Saturate_9A75CBB3_Out_1, _Property_56CA339D_Out_0, _Power_B404C8D5_Out_2);
                        float4 _Property_CBC31DB7_Out_0 = Vector4_53C3CAF3;
                        float _Split_738E9079_R_1 = _Property_CBC31DB7_Out_0[0];
                        float _Split_738E9079_G_2 = _Property_CBC31DB7_Out_0[1];
                        float _Split_738E9079_B_3 = _Property_CBC31DB7_Out_0[2];
                        float _Split_738E9079_A_4 = _Property_CBC31DB7_Out_0[3];
                        float4 _Combine_D4E1A601_RGBA_4;
                        float3 _Combine_D4E1A601_RGB_5;
                        float2 _Combine_D4E1A601_RG_6;
                        Unity_Combine_float(_Split_738E9079_R_1, _Split_738E9079_G_2, 0, 0, _Combine_D4E1A601_RGBA_4, _Combine_D4E1A601_RGB_5, _Combine_D4E1A601_RG_6);
                        float4 _Combine_B3F9DAE4_RGBA_4;
                        float3 _Combine_B3F9DAE4_RGB_5;
                        float2 _Combine_B3F9DAE4_RG_6;
                        Unity_Combine_float(_Split_738E9079_B_3, _Split_738E9079_A_4, 0, 0, _Combine_B3F9DAE4_RGBA_4, _Combine_B3F9DAE4_RGB_5, _Combine_B3F9DAE4_RG_6);
                        float _Remap_8141F08C_Out_3;
                        Unity_Remap_float(_Power_B404C8D5_Out_2, _Combine_D4E1A601_RG_6, _Combine_B3F9DAE4_RG_6, _Remap_8141F08C_Out_3);
                        float _Absolute_DA707E52_Out_1;
                        Unity_Absolute_float(_Remap_8141F08C_Out_3, _Absolute_DA707E52_Out_1);
                        float _Smoothstep_A9222CB5_Out_3;
                        Unity_Smoothstep_float(_Property_F656DB82_Out_0, _Property_E6FCF144_Out_0, _Absolute_DA707E52_Out_1, _Smoothstep_A9222CB5_Out_3);
                        float _Property_B22C6734_Out_0 = Vector1_3783F0D6;
                        float _Multiply_9C4F241C_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_B22C6734_Out_0, _Multiply_9C4F241C_Out_2);
                        float2 _TilingAndOffset_8D91A587_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_9C4F241C_Out_2.xx), _TilingAndOffset_8D91A587_Out_3);
                        float _Property_E409C129_Out_0 = Vector1_F4FD2233;
                        float _GradientNoise_81BAEB4A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_8D91A587_Out_3, _Property_E409C129_Out_0, _GradientNoise_81BAEB4A_Out_2);
                        float _Property_C4CE44E0_Out_0 = Vector1_89D9BA77;
                        float _Multiply_F5DA2647_Out_2;
                        Unity_Multiply_float(_GradientNoise_81BAEB4A_Out_2, _Property_C4CE44E0_Out_0, _Multiply_F5DA2647_Out_2);
                        float _Add_CAB25FE5_Out_2;
                        Unity_Add_float(_Smoothstep_A9222CB5_Out_3, _Multiply_F5DA2647_Out_2, _Add_CAB25FE5_Out_2);
                        float _Add_92F04FE1_Out_2;
                        Unity_Add_float(1, _Property_C4CE44E0_Out_0, _Add_92F04FE1_Out_2);
                        float _Divide_D05AE96_Out_2;
                        Unity_Divide_float(_Add_CAB25FE5_Out_2, _Add_92F04FE1_Out_2, _Divide_D05AE96_Out_2);
                        float4 _Lerp_608D51B5_Out_3;
                        Unity_Lerp_float4(_Property_539FFD11_Out_0, _Property_23C63215_Out_0, (_Divide_D05AE96_Out_2.xxxx), _Lerp_608D51B5_Out_3);
                        float _Property_189FD6C_Out_0 = Vector1_7892E05E;
                        float _FresnelEffect_83E7E861_Out_3;
                        Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_189FD6C_Out_0, _FresnelEffect_83E7E861_Out_3);
                        float _Multiply_377CD458_Out_2;
                        Unity_Multiply_float(_Divide_D05AE96_Out_2, _FresnelEffect_83E7E861_Out_3, _Multiply_377CD458_Out_2);
                        float _Property_AA57477D_Out_0 = Vector1_4386BB13;
                        float _Multiply_A59FF53_Out_2;
                        Unity_Multiply_float(_Multiply_377CD458_Out_2, _Property_AA57477D_Out_0, _Multiply_A59FF53_Out_2);
                        float4 _Add_13002516_Out_2;
                        Unity_Add_float4(_Lerp_608D51B5_Out_3, (_Multiply_A59FF53_Out_2.xxxx), _Add_13002516_Out_2);
                        description.Color = (_Add_13002516_Out_2.xyz);
                        description.VertexNormal = IN.ObjectSpaceNormal;
                        description.VertexTangent = IN.ObjectSpaceTangent;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _Property_539FFD11_Out_0 = Color_5100B6B6;
                        float4 _Property_23C63215_Out_0 = Color_9F979F9B;
                        float _Property_F656DB82_Out_0 = Vector1_8B47B562;
                        float _Property_E6FCF144_Out_0 = Vector1_DD2A7971;
                        float4 _Property_4CE5882F_Out_0 = Vector4_4FE19BDB;
                        float _Split_6C3848B1_R_1 = _Property_4CE5882F_Out_0[0];
                        float _Split_6C3848B1_G_2 = _Property_4CE5882F_Out_0[1];
                        float _Split_6C3848B1_B_3 = _Property_4CE5882F_Out_0[2];
                        float _Split_6C3848B1_A_4 = _Property_4CE5882F_Out_0[3];
                        float3 _RotateAboutAxis_5D606F9C_Out_3;
                        Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_4CE5882F_Out_0.xyz), _Split_6C3848B1_A_4, _RotateAboutAxis_5D606F9C_Out_3);
                        float _Property_D1CCB3D3_Out_0 = Vector1_BB19229D;
                        float _Multiply_C1DBBF46_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_D1CCB3D3_Out_0, _Multiply_C1DBBF46_Out_2);
                        float2 _TilingAndOffset_D9156ED9_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_C1DBBF46_Out_2.xx), _TilingAndOffset_D9156ED9_Out_3);
                        float _Property_12322142_Out_0 = Vector1_97EA0DEA;
                        float _GradientNoise_AB0C880E_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_D9156ED9_Out_3, _Property_12322142_Out_0, _GradientNoise_AB0C880E_Out_2);
                        float2 _TilingAndOffset_7FBE33C6_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7FBE33C6_Out_3);
                        float _GradientNoise_F3C2A41D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_7FBE33C6_Out_3, _Property_12322142_Out_0, _GradientNoise_F3C2A41D_Out_2);
                        float _Add_20294542_Out_2;
                        Unity_Add_float(_GradientNoise_AB0C880E_Out_2, _GradientNoise_F3C2A41D_Out_2, _Add_20294542_Out_2);
                        float _Divide_99AB6A24_Out_2;
                        Unity_Divide_float(_Add_20294542_Out_2, 2, _Divide_99AB6A24_Out_2);
                        float _Saturate_9A75CBB3_Out_1;
                        Unity_Saturate_float(_Divide_99AB6A24_Out_2, _Saturate_9A75CBB3_Out_1);
                        float _Property_56CA339D_Out_0 = Vector1_7D71E79C;
                        float _Power_B404C8D5_Out_2;
                        Unity_Power_float(_Saturate_9A75CBB3_Out_1, _Property_56CA339D_Out_0, _Power_B404C8D5_Out_2);
                        float4 _Property_CBC31DB7_Out_0 = Vector4_53C3CAF3;
                        float _Split_738E9079_R_1 = _Property_CBC31DB7_Out_0[0];
                        float _Split_738E9079_G_2 = _Property_CBC31DB7_Out_0[1];
                        float _Split_738E9079_B_3 = _Property_CBC31DB7_Out_0[2];
                        float _Split_738E9079_A_4 = _Property_CBC31DB7_Out_0[3];
                        float4 _Combine_D4E1A601_RGBA_4;
                        float3 _Combine_D4E1A601_RGB_5;
                        float2 _Combine_D4E1A601_RG_6;
                        Unity_Combine_float(_Split_738E9079_R_1, _Split_738E9079_G_2, 0, 0, _Combine_D4E1A601_RGBA_4, _Combine_D4E1A601_RGB_5, _Combine_D4E1A601_RG_6);
                        float4 _Combine_B3F9DAE4_RGBA_4;
                        float3 _Combine_B3F9DAE4_RGB_5;
                        float2 _Combine_B3F9DAE4_RG_6;
                        Unity_Combine_float(_Split_738E9079_B_3, _Split_738E9079_A_4, 0, 0, _Combine_B3F9DAE4_RGBA_4, _Combine_B3F9DAE4_RGB_5, _Combine_B3F9DAE4_RG_6);
                        float _Remap_8141F08C_Out_3;
                        Unity_Remap_float(_Power_B404C8D5_Out_2, _Combine_D4E1A601_RG_6, _Combine_B3F9DAE4_RG_6, _Remap_8141F08C_Out_3);
                        float _Absolute_DA707E52_Out_1;
                        Unity_Absolute_float(_Remap_8141F08C_Out_3, _Absolute_DA707E52_Out_1);
                        float _Smoothstep_A9222CB5_Out_3;
                        Unity_Smoothstep_float(_Property_F656DB82_Out_0, _Property_E6FCF144_Out_0, _Absolute_DA707E52_Out_1, _Smoothstep_A9222CB5_Out_3);
                        float _Property_B22C6734_Out_0 = Vector1_3783F0D6;
                        float _Multiply_9C4F241C_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_B22C6734_Out_0, _Multiply_9C4F241C_Out_2);
                        float2 _TilingAndOffset_8D91A587_Out_3;
                        Unity_TilingAndOffset_float((_RotateAboutAxis_5D606F9C_Out_3.xy), float2 (1, 1), (_Multiply_9C4F241C_Out_2.xx), _TilingAndOffset_8D91A587_Out_3);
                        float _Property_E409C129_Out_0 = Vector1_F4FD2233;
                        float _GradientNoise_81BAEB4A_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_8D91A587_Out_3, _Property_E409C129_Out_0, _GradientNoise_81BAEB4A_Out_2);
                        float _Property_C4CE44E0_Out_0 = Vector1_89D9BA77;
                        float _Multiply_F5DA2647_Out_2;
                        Unity_Multiply_float(_GradientNoise_81BAEB4A_Out_2, _Property_C4CE44E0_Out_0, _Multiply_F5DA2647_Out_2);
                        float _Add_CAB25FE5_Out_2;
                        Unity_Add_float(_Smoothstep_A9222CB5_Out_3, _Multiply_F5DA2647_Out_2, _Add_CAB25FE5_Out_2);
                        float _Add_92F04FE1_Out_2;
                        Unity_Add_float(1, _Property_C4CE44E0_Out_0, _Add_92F04FE1_Out_2);
                        float _Divide_D05AE96_Out_2;
                        Unity_Divide_float(_Add_CAB25FE5_Out_2, _Add_92F04FE1_Out_2, _Divide_D05AE96_Out_2);
                        float4 _Lerp_608D51B5_Out_3;
                        Unity_Lerp_float4(_Property_539FFD11_Out_0, _Property_23C63215_Out_0, (_Divide_D05AE96_Out_2.xxxx), _Lerp_608D51B5_Out_3);
                        float _Property_189FD6C_Out_0 = Vector1_7892E05E;
                        float _FresnelEffect_83E7E861_Out_3;
                        Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_189FD6C_Out_0, _FresnelEffect_83E7E861_Out_3);
                        float _Multiply_377CD458_Out_2;
                        Unity_Multiply_float(_Divide_D05AE96_Out_2, _FresnelEffect_83E7E861_Out_3, _Multiply_377CD458_Out_2);
                        float _Property_AA57477D_Out_0 = Vector1_4386BB13;
                        float _Multiply_A59FF53_Out_2;
                        Unity_Multiply_float(_Multiply_377CD458_Out_2, _Property_AA57477D_Out_0, _Multiply_A59FF53_Out_2);
                        float4 _Add_13002516_Out_2;
                        Unity_Add_float4(_Lerp_608D51B5_Out_3, (_Multiply_A59FF53_Out_2.xxxx), _Add_13002516_Out_2);
                        float _SceneDepth_6A5D647C_Out_1;
                        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_6A5D647C_Out_1);
                        float4 _ScreenPosition_D5C0B977_Out_0 = IN.ScreenPosition;
                        float _Split_D7132622_R_1 = _ScreenPosition_D5C0B977_Out_0[0];
                        float _Split_D7132622_G_2 = _ScreenPosition_D5C0B977_Out_0[1];
                        float _Split_D7132622_B_3 = _ScreenPosition_D5C0B977_Out_0[2];
                        float _Split_D7132622_A_4 = _ScreenPosition_D5C0B977_Out_0[3];
                        float _Subtract_EDAEA22B_Out_2;
                        Unity_Subtract_float(_Split_D7132622_A_4, 1, _Subtract_EDAEA22B_Out_2);
                        float _Subtract_D2C21BA_Out_2;
                        Unity_Subtract_float(_SceneDepth_6A5D647C_Out_1, _Subtract_EDAEA22B_Out_2, _Subtract_D2C21BA_Out_2);
                        float _Property_E72E495F_Out_0 = Vector1_ACA8BF6B;
                        float _Divide_69800C63_Out_2;
                        Unity_Divide_float(_Subtract_D2C21BA_Out_2, _Property_E72E495F_Out_0, _Divide_69800C63_Out_2);
                        float _Saturate_30FCF87F_Out_1;
                        Unity_Saturate_float(_Divide_69800C63_Out_2, _Saturate_30FCF87F_Out_1);
                        float _Property_27256254_Out_0 = Vector1_8F52779E;
                        float4 _Multiply_D88E026_Out_2;
                        Unity_Multiply_float(_Add_13002516_Out_2, (_Property_27256254_Out_0.xxxx), _Multiply_D88E026_Out_2);
                        surface.Color = (_Add_13002516_Out_2.xyz);
                        surface.Alpha = _Saturate_30FCF87F_Out_1;
                        surface.AlphaClipThreshold = 0;
                        surface.Emission = (_Multiply_D88E026_Out_2.xyz);
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
            
            VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                // output.ViewSpaceNormal =             TransformWorldToViewDir(output.WorldSpaceNormal);
                // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.ObjectSpaceTangent =          input.tangentOS;
                // output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                // output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                // output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                // output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                // output.ViewSpacePosition =           TransformWorldToView(output.WorldSpacePosition);
                // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                output.WorldSpaceViewDirection =     GetWorldSpaceNormalizeViewDir(output.WorldSpacePosition);
                // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                // output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(output.WorldSpacePosition), _ProjectionParams.x);
                // output.uv0 =                         input.uv0;
                // output.uv1 =                         input.uv1;
                // output.uv2 =                         input.uv2;
                // output.uv3 =                         input.uv3;
                // output.VertexColor =                 input.color;
                // output.BoneWeights =                 input.weights;
                // output.BoneIndices =                 input.indices;
            
                return output;
            }
            
            AttributesMesh ApplyMeshModification(AttributesMesh input, float3 timeParameters)
            {
                // build graph inputs
                VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
                // Override time paramters with used one (This is required to correctly handle motion vector for vertex animation based on time)
                vertexDescriptionInputs.TimeParameters = timeParameters;
            
                // evaluate vertex graph
                VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
            
                // copy graph output to the results
                // input.positionOS = vertexDescription.VertexPosition;
                input.normalOS = vertexDescription.VertexNormal;
                input.tangentOS.xyz = vertexDescription.VertexTangent;
            
                return input;
            }
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
        //-------------------------------------------------------------------------------------
            // TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
                FragInputs BuildFragInputs(VaryingsMeshToPS input)
                {
                    FragInputs output;
                    ZERO_INITIALIZE(FragInputs, output);
            
                    // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                    // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                    // to compute normals which are then passed on elsewhere to compute other values...
                    output.tangentToWorld = k_identity3x3;
                    output.positionSS = input.positionCS;       // input.positionCS is SV_Position
            
                    output.positionRWS = input.positionRWS;
                    output.tangentToWorld = BuildTangentToWorld(input.tangentWS, input.normalWS);
                    // output.texCoord0 = input.texCoord0;
                    // output.texCoord1 = input.texCoord1;
                    // output.texCoord2 = input.texCoord2;
                    // output.texCoord3 = input.texCoord3;
                    // output.color = input.color;
                    #if _DOUBLESIDED_ON && SHADER_STAGE_FRAGMENT
                    output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #elif SHADER_STAGE_FRAGMENT
                    // output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);
                    #endif // SHADER_STAGE_FRAGMENT
            
                    return output;
                }
            #endif
                SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                    output.WorldSpaceNormal =            input.tangentToWorld[2].xyz;	// normal was already normalized in BuildTangentToWorld()
                    // output.ObjectSpaceNormal =           normalize(mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_M));           // transposed multiplication by inverse matrix to handle normal scale
                    // output.ViewSpaceNormal =             mul(output.WorldSpaceNormal, (float3x3) UNITY_MATRIX_I_V);         // transposed multiplication by inverse matrix to handle normal scale
                    // output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                    // output.WorldSpaceTangent =           input.tangentToWorld[0].xyz;
                    // output.ObjectSpaceTangent =          TransformWorldToObjectDir(output.WorldSpaceTangent);
                    // output.ViewSpaceTangent =            TransformWorldToViewDir(output.WorldSpaceTangent);
                    // output.TangentSpaceTangent =         float3(1.0f, 0.0f, 0.0f);
                    // output.WorldSpaceBiTangent =         input.tangentToWorld[1].xyz;
                    // output.ObjectSpaceBiTangent =        TransformWorldToObjectDir(output.WorldSpaceBiTangent);
                    // output.ViewSpaceBiTangent =          TransformWorldToViewDir(output.WorldSpaceBiTangent);
                    // output.TangentSpaceBiTangent =       float3(0.0f, 1.0f, 0.0f);
                    output.WorldSpaceViewDirection =     normalize(viewWS);
                    // output.ObjectSpaceViewDirection =    TransformWorldToObjectDir(output.WorldSpaceViewDirection);
                    // output.ViewSpaceViewDirection =      TransformWorldToViewDir(output.WorldSpaceViewDirection);
                    // float3x3 tangentSpaceTransform =     float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    // output.TangentSpaceViewDirection =   mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.WorldSpacePosition =          input.positionRWS;
                    // output.ObjectSpacePosition =         TransformWorldToObject(input.positionRWS);
                    // output.ViewSpacePosition =           TransformWorldToView(input.positionRWS);
                    // output.TangentSpacePosition =        float3(0.0f, 0.0f, 0.0f);
                    // output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionRWS);
                    output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionRWS), _ProjectionParams.x);
                    // output.uv0 =                         input.texCoord0;
                    // output.uv1 =                         input.texCoord1;
                    // output.uv2 =                         input.texCoord2;
                    // output.uv3 =                         input.texCoord3;
                    // output.VertexColor =                 input.color;
                    // output.FaceSign =                    input.isFrontFace;
                    output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            
                    return output;
                }
            
            #if !defined(SHADER_STAGE_RAY_TRACING)
            
                // existing HDRP code uses the combined function to go directly from packed to frag inputs
                FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
                {
                    UNITY_SETUP_INSTANCE_ID(input);
                    VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                    return BuildFragInputs(unpacked);
                }
            #endif
            
            //-------------------------------------------------------------------------------------
            // END TEMPLATE INCLUDE : SharedCode.template.hlsl
            //-------------------------------------------------------------------------------------
            
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                surfaceData.color = surfaceDescription.Color;
        
        #if defined(DEBUG_DISPLAY) && !defined(SHADER_STAGE_RAY_TRACING)
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO
                }
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData RAY_TRACING_OPTIONAL_PARAMETERS)
            {
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky.
        #ifdef _ALPHATEST_ON
                // GENERIC_ALPHA_TEST(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        #endif
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                #if defined(_ENABLE_SHADOW_MATTE) && SHADERPASS == SHADERPASS_FORWARD_UNLIT
                    HDShadowContext shadowContext = InitShadowContext();
                    float shadow;
                    float3 shadow3;
                    posInput = GetPositionInput(fragInputs.positionSS.xy, _ScreenSize.zw, fragInputs.positionSS.z, UNITY_MATRIX_I_VP, UNITY_MATRIX_V);
                    float3 normalWS = normalize(fragInputs.tangentToWorld[1]);
                    uint renderingLayers = _EnableLightLayers ? asuint(unity_RenderingLayer.x) : DEFAULT_LIGHT_LAYERS;
                    ShadowLoopMin(shadowContext, posInput, normalWS, asuint(_ShadowMatteFilter), renderingLayers, shadow3);
                    shadow = dot(shadow3, float3(1.0f/3.0f, 1.0f/3.0f, 1.0f/3.0f));
        
                    float4 shadowColor = (1 - shadow)*surfaceDescription.ShadowTint.rgba;
                    float  localAlpha  = saturate(shadowColor.a + surfaceDescription.Alpha);
        
                    // Keep the nested lerp
                    // With no Color (bsdfData.color.rgb, bsdfData.color.a == 0.0f), just use ShadowColor*Color to avoid a ring of "white" around the shadow
                    // And mix color to consider the Color & ShadowColor alpha (from texture or/and color picker)
                    #ifdef _SURFACE_TYPE_TRANSPARENT
                        surfaceData.color = lerp(shadowColor.rgb*surfaceData.color, lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow), surfaceDescription.Alpha);
                    #else
                        surfaceData.color = lerp(lerp(shadowColor.rgb, surfaceData.color, 1 - surfaceDescription.ShadowTint.a), surfaceData.color, shadow);
                    #endif
                    localAlpha = ApplyBlendMode(surfaceData.color, localAlpha).a;
        
                    surfaceDescription.Alpha = localAlpha;
                #endif
        
                // Builtin Data
                ZERO_INITIALIZE(BuiltinData, builtinData); // No call to InitBuiltinData as we don't have any lighting
                builtinData.opacity = surfaceDescription.Alpha;
        
                builtinData.emissiveColor = surfaceDescription.Emission;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #endif
                RAY_TRACING_OPTIONAL_ALPHA_TEST_PASS
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassPathTracing.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
    }
    CustomEditor "UnityEditor.Rendering.HighDefinition.HDUnlitGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}
