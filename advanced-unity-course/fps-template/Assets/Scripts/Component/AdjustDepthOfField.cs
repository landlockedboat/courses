using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.PostProcessing;

public class AdjustDepthOfField : MonoBehaviour
{
	private PostProcessingProfile _postProcessingProfile;
	[SerializeField] private float _lengthDamper = 1;

	private Transform _mainCamera;
	// Use this for initialization
	private void Start()
	{
		_postProcessingProfile = Camera.main.GetComponent<PostProcessingBehaviour>().profile;
		_mainCamera = Camera.main.transform;
	}
	
	void Update () {
		var ray = new Ray(_mainCamera.position, _mainCamera.forward);

		RaycastHit raycastHit;

		Physics.Raycast(ray, out raycastHit);

		if (raycastHit.collider == null)
		{
			return;
		}

		var dist = Vector3.Distance(raycastHit.point, _mainCamera.position);

		var sett = _postProcessingProfile.depthOfField.settings;
		sett.focusDistance = dist / _lengthDamper;
		_postProcessingProfile.depthOfField.settings = sett;
	}
}
