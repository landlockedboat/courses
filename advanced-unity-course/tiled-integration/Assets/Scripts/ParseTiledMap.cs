using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Xml;
using UnityEngine;

public class ParseTiledMap : MonoBehaviour {

	public static int[,] ParseLayer(string tiledMapString, int layerIndex)
	{
		XmlDocument xmldoc = new XmlDocument();
		xmldoc.LoadXml(tiledMapString);

		XmlNode mapXmlNode = xmldoc.ChildNodes[1];
		XmlNode layerXmlNode = mapXmlNode.ChildNodes[layerIndex];

		int width = int.Parse(layerXmlNode.Attributes[1].Value);
		int height = int.Parse(layerXmlNode.Attributes[2].Value);

		string data = layerXmlNode.FirstChild.InnerText;

		int[] nums = data.Split(',').Select(int.Parse).ToArray();

		int[,] map = new int[width, height];

		for (int y = 0; y < height; y++)
		{
			for (int x = 0; x < width; x++)
			{
				// This offset is calculates as such because in Unity the coordinates 
				// origin is the bottom left corner and in Tiled it is the top left corner
				map[y, x] = nums[((height - 1) - y) * height + x];
			}
		}
		return map;
	}
}
