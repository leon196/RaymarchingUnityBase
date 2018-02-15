Shader "Hidden/Raymarching"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "Utils.cginc"

			sampler2D _MainTex;
			float3 _CameraPosition, _CameraForward, _CameraRight, _CameraUp;

			float map (float3 pos) {
				float scene = 1000.;
				amod(pos.xz, 5.);
				pos.x -= 4.;
				scene = min(scene, sphere(pos, 2.));
				return scene;
			}

			fixed4 frag (v2f_img i) : SV_Target
			{
				float2 uv = i.uv * 2. - 1.;
				uv.x *= _ScreenParams.x / _ScreenParams.y;

				float3 eye = _CameraPosition;
				float3 ray = normalize(_CameraForward + _CameraRight * uv.x + _CameraUp * uv.y);

				float3 pos = eye;
				float shade = 0.;
				for (float i = 0.; i <= 1.; i += 1./50.) {
					float dist = map(pos);
					if (dist < .001) {
						shade = 1.-i;
						break;
					}
					dist *= .9 + .1 * rand(uv);
					pos += ray * dist;
				}
				float4 color = float4(1,1,1,1);
				color *= shade;
				return color;
			}
			ENDCG
		}
	}
}
