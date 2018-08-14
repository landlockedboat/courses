using System;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : ActorController
{
    private static readonly Quaternion Deg90 = Quaternion.AngleAxis(-90f, Vector3.up);

    private PlayerModel _playerModel;

    private Transform _mainCamera;

    private static PlayerController _instance;

    public static PlayerController Instance
    {
        get
        {
            if (_instance != null)
            {
                return _instance;
            }

            var instances = FindObjectsOfType<PlayerController>();
            if (instances.Length > 1)
            {
                throw new Exception("There are more than one PlayerControllers");
            }

            _instance = instances[0];

            return _instance;
        }
    }


    protected override void Awake()
    {
        base.Awake();
        _playerModel = (PlayerModel) ActorModel;
        _mainCamera = Camera.main.transform;
    }

    protected override void Jump()
    {
        Rigidbody.AddForce(transform.up * ActorModel.JumpForce, ForceMode.Impulse);
    }

    protected override void Shoot()
    {
        base.Shoot();
        var ray = new Ray(_mainCamera.position, _mainCamera.forward);

        RaycastHit raycastHit;

        Physics.Raycast(ray, out raycastHit);

        if (raycastHit.collider == null)
        {
            return;
        }

        var raycastCollider = raycastHit.collider;

        if (raycastCollider.CompareTag("Player"))
        {
            var go = raycastCollider.gameObject;
            var controller = go.GetComponent<ActorController>();
            controller.ApplyDamage(_playerModel.ShootForce);
        }
    }

    public void Move(Direction direction)
    {
        var delta = Vector3.zero;
        switch (direction)
        {
            case Direction.Forwards:
                delta += Deg90 * _mainCamera.transform.right;
                break;
            case Direction.Backwards:
                delta -= Deg90 * _mainCamera.transform.right;
                break;
            case Direction.Left:
                delta -= _mainCamera.transform.right;
                break;
            case Direction.Right:
                delta += _mainCamera.transform.right;
                break;
            default:
                throw new ArgumentOutOfRangeException("direction", direction, null);
        }

        Rigidbody.MovePosition(
            Rigidbody.position + delta * _playerModel.MovingSpeed * Time.deltaTime);
    }
}