// TV Static Shader
// Fairly simple shader to generate static on sprites.
// Written by @DylanGedig,
// Adapted from dandeentremont at https://forum.unity.com/threads/tv-static-shader.354472/
Shader "Unlit/TVStatic"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _ColorA ("ColorA", Color) = (1,1,1,1)
        _ColorB ("ColorB", Color) = (0,0,0,0)
        _BlockSize ("BlockSize", float) = 100.0
        _SpeedControl ("SpeedControl", Range (1.0, 50.0)) = 20.0
        
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

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

            fixed4 _ColorA;
            fixed4 _ColorB;
            float _BlockSize;
            float _SpeedControl;

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
                int blockSize = _BlockSize;

				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
                float timeVal = round(_Time.y * _SpeedControl)/_SpeedControl;
                float noise = frac(
                    sin( 
                        1234.56f * (round(i.uv.x * blockSize)/blockSize) * timeVal
                        + 7890.12f * (round(i.uv.y * blockSize)/blockSize) * timeVal
                    ) * (100.0f + (timeVal))
                );
                float4 lerped = lerp(_ColorA, _ColorB, noise);
                col.rgb = float3(lerped.rgb);
				return col;
			}
			ENDCG
		}
	}
}
