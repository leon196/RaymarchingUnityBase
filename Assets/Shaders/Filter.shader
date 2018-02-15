Shader "Hidden/Filter"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Displacement ("Displacement", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			sampler2D _MainTex, _Displacement, Result;

			float rand (float2 seed) {
    			return frac(sin(dot(seed ,float2(12.9898,78.233))) * 43758.5453);
			}

			fixed4 frag (v2f_img i) : SV_Target
			{
				float2 uv = i.uv;

				fixed4 col = tex2D(_MainTex, uv);

				float thin = .03;
				float cell = .05;
				float grid = step(thin, fmod(uv.y+sin(uv.x*10.)*.05, cell));
				float sonar = step(thin, fmod(length(uv-.5)+_Time.y,cell));

				//col = lerp(col, 1.-col, sonar);
				col = tex2D(Result, uv);
				return col;
			}
			ENDCG
		}
	}
}
