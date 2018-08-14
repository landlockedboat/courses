using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.Experimental.Rendering;

public class GameApplication : MonoBehaviour
{

	[SerializeField] private GameObject _tilePrefab;
	[SerializeField] private string _mapPath = "map.tmx";
	private Sprite[] _sprites;
	
	void Start ()
	{
		_sprites = Resources.LoadAll<Sprite>("sheet");
		
		var tiledMapString = File.ReadAllText(Path.Combine(Application.streamingAssetsPath, _mapPath));
		int[,] map = ParseTiledMap.ParseLayer(tiledMapString, 1);
		int[,] map2 = ParseTiledMap.ParseLayer(tiledMapString, 2);

		RenderMap(map);
		RenderMap(map2);
	}

	void RenderMap(int[,] map)
	{
		GameObject mapTransform = new GameObject();
		mapTransform.name = "Map layer";
		
		for (int y = 0; y < map.GetLength(1); y++)
		{
			for (int x = 0; x < map.GetLength(0); x++)
			{
				var spriteIndex = map[y, x] - 1;
				if (spriteIndex >= 0)
				{
					var go = Instantiate(_tilePrefab, new Vector3(x, y), Quaternion.identity);
					go.name = "Tile [" + x + ", " + y + "]";
					go.GetComponent<SpriteRenderer>().sprite = _sprites[spriteIndex];
					go.transform.parent = mapTransform.transform;
				}
			}
		}
	}
	
}
