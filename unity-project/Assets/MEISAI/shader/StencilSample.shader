Shader "StencilSample"
{
    Properties
    {
        _MainTex ("_MainTex", 2D) = "white" {}
        _StencilTex ("_StencilTex", 2D) = "white" {}
        _DepthTex ("_DepthTex", 2D) = "white" {}
        
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _StencilTex;
            sampler2D _DepthTex;
            
            float2 GetStencilUV( float2 uv ){

                float2 stencilUV = float2(
                    1-uv.y,
                    1-uv.x
                );

                float camTexWidth = 1920;
                float camTexHeight = 1440;
                float aspect = (camTexWidth/camTexHeight) / (_ScreenParams.y/_ScreenParams.x);

                stencilUV.y = stencilUV.y * aspect + (1-aspect)/2;

                return stencilUV;

            }
            float getGrey(float3 p){ return p.x*0.299 + p.y*0.587 + p.z*0.114; }

            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 stencil = tex2D(_StencilTex, GetStencilUV(i.uv));
                fixed4 depth = tex2D(_DepthTex, GetStencilUV(i.uv));
                float d = 0.1 + 0.9*(1 - clamp(depth.r, 0, 1));
                float r = stencil.r * d;
                return float4(r, r, r, 1);
            }
            ENDCG
        }
    }
}
