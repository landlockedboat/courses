using System;
using UnityEngine;
using UnityEngine.AI;

public class CpuPlayerController : ActorController
{
    private NavMeshAgent _navMeshAgent;

    protected override void Awake()
    {
        _navMeshAgent = GetComponent<NavMeshAgent>();
        _navMeshAgent.enabled = false;
        base.Awake();
    }
    

    private void Start()
    {
        _navMeshAgent.enabled = true;
    }

    private void LateUpdate()
    {
        _navMeshAgent.SetDestination(PlayerController.Instance.transform.position);
    }
}
