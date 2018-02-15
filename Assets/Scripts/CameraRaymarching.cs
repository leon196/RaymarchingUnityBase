using UnityEngine;
using System.Collections;

public class CameraRaymarching : MonoBehaviour
{
	private Camera cam;

	void Start ()
	{
		cam = GetComponent<Camera>();
	}

	void Update ()
	{
		Shader.SetGlobalVector("_CameraPosition", cam.transform.position);
		Shader.SetGlobalVector("_CameraForward", cam.transform.forward);
		Shader.SetGlobalVector("_CameraUp", cam.transform.up);
		Shader.SetGlobalVector("_CameraRight", cam.transform.right);
	}
}