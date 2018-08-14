using UnityEngine;

public class PlayerView : MonoBehaviour
{
    private PlayerController _playerController;

    private void Start()
    {
        _playerController = GetComponent<PlayerController>();
        Cursor.lockState = CursorLockMode.Locked;
    }
    
    private void Update()
    {
        if (Input.GetKey(KeyCode.Escape))
        {
            Cursor.lockState = CursorLockMode.None;
        }
    }

    private void FixedUpdate()
    {
        GetShootInput();
        GetMoveInput();
        GetJumpInput();
    }

    private void GetShootInput()
    {
        if (Input.GetMouseButton(0))
        {
            _playerController.TryShoot();
        }
    }

    private void GetJumpInput()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            _playerController.TryJump();
        }
    }

    private void GetMoveInput()
    {
        if (Input.GetAxisRaw("Horizontal") > 0)
        {
            _playerController.Move(Direction.Right);
        }

        if (Input.GetAxisRaw("Horizontal") < 0)
        {
            _playerController.Move(Direction.Left);
        }

        if (Input.GetAxisRaw("Vertical") > 0)
        {
            _playerController.Move(Direction.Forwards);
        }

        if (Input.GetAxisRaw("Vertical") < 0)
        {
            _playerController.Move(Direction.Backwards);
        }
    }
}