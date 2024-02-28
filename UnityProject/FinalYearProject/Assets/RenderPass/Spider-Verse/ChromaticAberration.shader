Shader "Custom/ChromaticAberration"
{
    Properties {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Intensity ("Intensity", Range(0, 1)) = 0.1
        _Offset ("Offset", Vector) = (0.01, 0.01, 0, 0)
    }

    SubShader {
        Cull Off ZWrite Off ZTest Always

        Pass {
            Name "ChromaticEffect"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float4 _Offset;

            fixed4 frag (v2f i) : SV_Target {
                float2 offsetR = i.uv + _Offset.xy;
                float2 offsetG = i.uv + _Offset.zw;

                float4 col = tex2D(_MainTex, i.uv);
                float4 colR = tex2D(_MainTex, offsetR);
                float4 colG = tex2D(_MainTex, offsetG);

                return float4(colR.r, colG.g, col.b, col.a); 
            }
            ENDCG
        }
    }
}