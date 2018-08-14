using System.Collections;
using UnityEngine;


[RequireComponent(typeof(NotificationManager))]
public class ActorController : MonoBehaviour
{
    protected Rigidbody Rigidbody;
    protected ActorModel ActorModel;
    private MeshRenderer _meshRenderer;
    public NotificationManager NotificationManager;

    protected virtual void Awake()
    {
        ActorModel = GetComponent<ActorModel>();

        ActorModel.Life = ActorModel.MaxLife; 
        
        Rigidbody = GetComponent<Rigidbody>();
        _meshRenderer = GetComponent<MeshRenderer>();
        NotificationManager = GetComponent<NotificationManager>();
    }

    private void LateUpdate()
    {
        if (transform.position.y <= -10)
        {
            transform.position = Vector3.zero;
        }

        ActorModel.Position = transform.position;
    }

    private bool IsGrounded()
    {
        RaycastHit hit;

        var ray = new Ray(transform.position - Vector3.up * .5f, -Vector3.up);

        Physics.Raycast(ray, out hit, ActorModel.IsGroundedRayLength);

        return hit.transform != null && hit.transform.CompareTag("Floor");
    }

    public void TryJump()
    {
        if (!ActorModel.CanJump || !IsGrounded())
        {
            return;
        }
        
        ActorModel.CanJump = false;
        StartCoroutine(RefreshJump(ActorModel.JumpDelay));
        Jump();
    }

    protected virtual void Jump()
    {
        
    }
    
    private IEnumerator RefreshJump(float jumpDelay)
    {
        yield return new WaitForSeconds(jumpDelay);
        ActorModel.CanJump = true;
    }

    public void TryShoot()
    {
        if (!ActorModel.CanShoot)
        {
            return;
        }
        ActorModel.CanShoot = false;
        StartCoroutine(RefreshShoot(ActorModel.ShootDelay));
        Shoot();
    }

    protected virtual void Shoot()
    {
        NotificationManager.Call("shoot");
    }

    private IEnumerator RefreshShoot(float shootDelay)
    {
        yield return new WaitForSeconds(shootDelay);
        ActorModel.CanShoot = true;
    }
    

    public void ApplyDamage(float shootForce)
    {
        ActorModel.Life -= shootForce;
        if (ActorModel.Life <= 0)
        {
            Destroy(gameObject);
        }

        _meshRenderer.material.color = 
            Color.Lerp(Color.red, Color.white, ActorModel.Life/ActorModel.MaxLife);
        
        NotificationManager.Call("apply.damage");
    }
}