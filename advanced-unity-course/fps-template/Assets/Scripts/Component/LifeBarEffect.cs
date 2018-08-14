using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LifeBarEffect : MonoBehaviour
{
	private Transform _worldSpaceCanvas;
	private Transform _mainCamera;
	[SerializeField] private GameObject _lifeBarPrefab;
	private NotificationManager _notificationManager;

	private ActorModel _actorModel;
	private RectTransform _rectTransform;
	private Image _image;

	private void Awake ()
	{
		_worldSpaceCanvas = WorldSpaceCanvas.Instance.transform;
		_mainCamera = Camera.main.transform;
		_actorModel = GetComponent<ActorModel>();
		
		_notificationManager = GetComponent<NotificationManager>();
		_notificationManager.Listen("apply.damage", OnDamageApplied);
	}

	private void OnDamageApplied()
	{
		_image.fillAmount = _actorModel.Life / _actorModel.MaxLife;
	}

	private void Start()
	{
		var lifeBar = Instantiate(_lifeBarPrefab, _worldSpaceCanvas);
		_image = lifeBar.GetComponentsInChildren<Image>()[1];
		_rectTransform = lifeBar.GetComponent<RectTransform>();
		_rectTransform.position = transform.position;
	}

	private void LateUpdate()
	{
		_rectTransform.position = transform.position;
		_rectTransform.LookAt(_mainCamera.position);
	}

	private void OnDestroy()
	{
		Destroy(_rectTransform.gameObject);
	}
}
