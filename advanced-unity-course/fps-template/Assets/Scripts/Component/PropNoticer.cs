using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Threading;
using UnityEngine;

public class PropNoticer : MonoBehaviour
{
    private int _prevId = -1;
    private GameObject _prevGo = null;
    private List<Color> _prevColors;

    // Use this for initialization
    private void Start()
    {
    }

    // Update is called once per frame
    private void Update()
    {
        var ray = new Ray(transform.position, transform.forward);

        RaycastHit raycastHit;

        Physics.Raycast(ray, out raycastHit);

        if (raycastHit.collider == null)
        {
            return;
        }

        var go = raycastHit.collider.gameObject;

        var id = go.GetHashCode();

        if (_prevId == id)
        {
            return;
        }

        _prevId = id;

        if (_prevGo != null)
        {
            RestoreTint(_prevGo, _prevColors);
        }

        _prevGo = go;

        var tint = new Color(0,0,0,0);

        if (go.CompareTag("Prop"))
        {
            tint = Color.white * .75f;
        }

        _prevColors = ApplyTint(go, tint);
    }

    private void RestoreTint(GameObject go, List<Color> prevColors)
    {
        Debug.Log("RestoreTint with " + prevColors.Count + " colors");

//        var mr = go.GetComponent<MeshRenderer>();
//
//        if (mr != null)
//        {
//            foreach (var mat in mr.materials)
//            {
//                mat.color = prevColors.First();
//                prevColors.RemoveAt(0);
//            }
//        }

        // Recurse with depth 1
        foreach (var childMr in go.GetComponentsInChildren<MeshRenderer>())
        {
            foreach (var mat in childMr.materials)
            {
                mat.color = prevColors.First();
                prevColors.RemoveAt(0);
            }
        }
    }

    private List<Color> ApplyTint(GameObject go, Color tint)
    {
        List<Color> prevColors = new List<Color>();

//        var mr = go.GetComponent<MeshRenderer>();
//
//        if (mr != null)
//        {
//            foreach (var mat in mr.materials)
//            {
//                prevColors.Add(mat.color);
//                mat.color = Color.white;
//            }
//        }

        // Recurse with depth 1
        foreach (var childMr in go.GetComponentsInChildren<MeshRenderer>())
        {
            foreach (var mat in childMr.materials)
            {
                prevColors.Add(mat.color);
                mat.color += tint;
            }
        }

        return prevColors;
    }
}