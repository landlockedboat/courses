using System.Collections;
using UnityEngine;
using UnityEngine.UI;

public class CrosshairShootEffect : MonoBehaviour
{
    private NotificationManager _notificationManager;
    private Image _crosshairImage;

    private Vector3 _originalScale;
    private Vector3 _effectScale;


    [SerializeField] private float _effectAmmount = .2f;
    [SerializeField] private float _effectTime = .1f;

    private void Start()
    {
        _notificationManager = PlayerController.Instance.NotificationManager;
        _notificationManager.Listen("shoot", OnPlayerShoot);
        _crosshairImage = GetComponent<Image>();

        _originalScale = _crosshairImage.rectTransform.localScale;
        _effectScale = _originalScale + Vector3.one * _effectAmmount;
    }

    private void OnPlayerShoot()
    {
        StopAllCoroutines();
        StartCoroutine(ScaleCrosshair(_effectAmmount / _effectTime));
    }

    IEnumerator ScaleCrosshair(float deltaEffect)
    {
        var effectAmmount = 0f;
        while (_crosshairImage.rectTransform.localScale != _effectScale)
        {
            effectAmmount += deltaEffect;

            var oldScale = _crosshairImage.rectTransform.localScale;
            
            var newScale = Vector3.Lerp(oldScale, _effectScale, effectAmmount);
            _crosshairImage.rectTransform.localScale = newScale;

            _crosshairImage.color = Color.Lerp(Color.black, Color.red, effectAmmount);
            
            yield return null;
        }

        _crosshairImage.color = Color.black;
        _crosshairImage.rectTransform.localScale = _originalScale;
    }
}