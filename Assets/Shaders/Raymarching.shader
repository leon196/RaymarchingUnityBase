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

			struct Shape {
				float dist;
				float3 color;
			};

			#define white float3(1,1,1)
			#define red float3(1,0,0)

			Shape map (float3 pos) {
				Shape scene;
				scene.dist = 1000.;
				scene.color = float3(1,1,1);

				float body = sphere(pos, 2.);
				float head = box(pos, 1.5);
				scene.color = lerp(white, red, step(body, head));
				scene.dist = max(-body, head);
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
				Shape scene;
				for (float i = 0.; i <= 1.; i += 1./50.) {
					scene = map(pos);
					if (scene.dist < .001) {
						shade = 1.-i;
						break;
					}
					scene.dist *= .9 + .1 * rand(uv);
					pos += ray * scene.dist;
				}
				float4 color = float4(scene.color,1);
				color *= shade;
				return color;
			}
			ENDCG
		}
	}
}
