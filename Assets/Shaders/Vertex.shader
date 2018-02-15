Shader "Unlit/Vertex"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			void rotation(inout float2 p, float a) {
				float c = cos(a), s = sin(a);
				float2x2 rot = float2x2(c,-s,s,c);
				p = mul(rot, p);
			}

			float rand (float2 seed) {
    			return frac(sin(dot(seed ,float2(12.9898,78.233))) * 43758.5453);
			}
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = v.vertex;
				//o.vertex.xyz += normalize(o.vertex.xyz) * rand(o.vertex.xz + o.vertex.yx) * .5;
				float lod = 8.;
				o.vertex.xyz = floor(o.vertex.xyz*lod)/lod;
				//o.vertex.xyz += frac(o.vertex.xyz*20.*sin(_Time.y));
				o.vertex = mul(UNITY_MATRIX_M, o.vertex);

				o.vertex = mul(UNITY_MATRIX_VP, o.vertex);

				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
