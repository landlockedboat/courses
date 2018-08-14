using UnityEngine;

public class FpsApplication : MonoBehaviour
{
    private FpsController _fpsController;
    private FpsModel _fpsModel;

    public Transform ModelRoot;
    public Transform ViewRoot;
    public Transform ControllerRoot;

    private void Awake()
    {
        _fpsController = FpsController.Instance;
        _fpsModel = FpsModel.Instance;
        
        ModelRoot = _fpsModel.transform;
        ControllerRoot = _fpsController.transform;
        ViewRoot = FpsView.Instance.transform;
        
        _fpsController.SpawnPlayer(_fpsModel.SpawnPivots[0].position);
        _fpsController.SpawnCpuPlayer(_fpsModel.SpawnPivots[1].position);
        _fpsController.SpawnCpuPlayer(_fpsModel.SpawnPivots[2].position);
        _fpsController.SpawnCpuPlayer(_fpsModel.SpawnPivots[3].position);
    }
}