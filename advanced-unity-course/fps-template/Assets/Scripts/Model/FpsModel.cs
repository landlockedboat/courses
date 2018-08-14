using UnityEngine;

public class FpsModel : Singleton<FpsModel>
{
	[SerializeField] public GameObject PlayerPrefab;
	[SerializeField] public GameObject CpuPlayerPrefab;
	[SerializeField] public Transform[] SpawnPivots;
}
