using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseCameraRotate : MonoBehaviour {

	
	public float SensitivityX = 15F;
	public float SensitivityY = 15F;

	public float MinimumX = -360F;
	public float MaximumX = 360F;
	public float MinimumY = -60F;
	public float MaximumY = 60F;
	
	private float _rotationX;
	private float _rotationY;

	private Quaternion _originalRotation;

	private void Start () {
		_originalRotation = transform.localRotation;
	}

	private void Update ()
	{
		Rotate();
	}
	
	private void Rotate()
	{
		_rotationY += Input.GetAxis("Mouse Y") * SensitivityY;
		_rotationX += Input.GetAxis("Mouse X") * SensitivityX;

		_rotationY = ClampAngle(_rotationY, MinimumY, MaximumY);
		_rotationX = ClampAngle(_rotationX, MinimumX, MaximumX);

		var yQuaternion = Quaternion.AngleAxis(_rotationY, Vector3.left);
		var xQuaternion = Quaternion.AngleAxis(_rotationX, Vector3.up);

		transform.localRotation = _originalRotation * xQuaternion * yQuaternion;
	}
	
	private static float ClampAngle(float angle, float min, float max)
	{
		angle = angle % 360;
		return Mathf.Clamp(angle, min, max);
	}
}
