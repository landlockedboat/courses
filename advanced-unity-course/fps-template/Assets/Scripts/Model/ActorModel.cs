using UnityEngine;

public class ActorModel : MonoBehaviour
{
    public float MovingSpeed = 6;
    public Vector3 Position;
    
    public float JumpForce = 6;
    public float JumpDelay = 1;
    public bool CanJump = true;
    public float IsGroundedRayLength = 1.5f;
    
    public float ShootForce = 2;
    public float ShootDelay = .2f;
    public bool CanShoot = true;
    
    public float Life;
    public float MaxLife = 6;
}
