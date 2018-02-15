using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;

public class MouseOrbitImproved : MonoBehaviour
{
	public Transform target;
	public Vector4 speed = Vector4.one;
	public float acceleration = 0.99f;
	public float damping = 0.1f;
	
	private Vector3 orbitVelocity = Vector3.zero;
	private Vector2 rotation = Vector2.zero;
	private Vector3 targetOffset = Vector3.zero;
	private float zoom = 0f;
	private float distance;
	public bool should = false;
	private Camera cameraComponent;
	private float fov;

	void Start () 
	{
		distance = Vector3.Distance(transform.position, target.position);
		rotation.x = transform.rotation.eulerAngles.y;
		rotation.y = transform.rotation.eulerAngles.x;
		cameraComponent = GetComponent<Camera>();
		fov = cameraComponent.fieldOfView;
	}
	
	void Update () 
	{
		if (should)
		{
			if (Input.GetMouseButton(0)) {
				Rotate();
			}
			if (Input.GetMouseButton(1)) {
				Zoom();
			}
			if (Input.GetMouseButton(2)) {
				Translate();
			}

			fov = Mathf.Clamp(fov - Input.GetAxis("Mouse ScrollWheel") * 20f, 50f, 180f);

		}

		ApplyTransformation();

		cameraComponent.fieldOfView = Mathf.Lerp(cameraComponent.fieldOfView, fov, Time.deltaTime * 5f);

		Shader.SetGlobalFloat("_MouseX", rotation.x / 360f);
		Shader.SetGlobalFloat("_MouseY", rotation.y / 360f);
	}

	void Rotate ()
	{
		orbitVelocity.x = Mathf.Lerp(orbitVelocity.x, Input.GetAxis("Mouse X") * speed.x, damping);
		orbitVelocity.y = Mathf.Lerp(orbitVelocity.y, Input.GetAxis("Mouse Y") * speed.y, damping);
	}

	void Translate ()
	{
		targetOffset = Vector3.Lerp(targetOffset, Input.GetAxis("Mouse X") * transform.right * speed.w, damping);
		targetOffset = Vector3.Lerp(targetOffset, Input.GetAxis("Mouse Y") * transform.up * speed.w, damping);
	}

	void Zoom ()
	{
		zoom = Mathf.Lerp(zoom, Input.GetAxis("Mouse Y") * speed.z, damping);
	}

	void ApplyTransformation ()
	{
		rotation.x += orbitVelocity.x;
		rotation.y -= orbitVelocity.y;
		transform.rotation = Quaternion.Euler(rotation.y, rotation.x, 0);

		target.position -= targetOffset;

		distance = Mathf.Max(0f, distance + zoom);
		transform.position = transform.rotation * (Vector3.back * distance) + target.position;
		
		orbitVelocity *= acceleration;
		zoom *= acceleration;
		targetOffset *= acceleration;
	}
}
