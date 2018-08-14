using UnityEngine;

public class FpsController : Singleton<FpsController>
{
    private FpsModel _fpsModel;

    private void Awake()
    {
        _fpsModel = FpsModel.Instance;
    }

    public void SpawnCpuPlayer(Vector3 position)
    {
        SpawnPrefab(_fpsModel.CpuPlayerPrefab, position);
    }

    public void SpawnPlayer(Vector3 position)
    {
        SpawnPrefab(_fpsModel.PlayerPrefab, position);
    }

    void SpawnPrefab(GameObject prefab, Vector3 position)
    {
        var go = Instantiate(
            prefab,
            position,
            Quaternion.identity);

        go.transform.SetParent(FpsView.Instance.transform, true);
    }
}