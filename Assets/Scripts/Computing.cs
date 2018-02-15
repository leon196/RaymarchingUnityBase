using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Computing : MonoBehaviour {

	public ComputeShader computeShader;
	private int kernel;
	private RenderTexture texture;

	void Start () {
		kernel = computeShader.FindKernel ("Patate");
		texture = new RenderTexture (256, 256, 24);
		texture.enableRandomWrite = true;
		texture.Create ();
		computeShader.SetTexture (kernel, "Result", texture);
		Shader.SetGlobalTexture ("Result", texture);
	}

	void Update () {
		computeShader.Dispatch (kernel, 256 / 8, 256 / 8, 1);
	}
}
