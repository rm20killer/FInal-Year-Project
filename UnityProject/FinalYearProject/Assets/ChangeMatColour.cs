using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeMatColour : MonoBehaviour
{
    public Material material;
    public GameObject Objects;
    public float speed = 0.02f;
     // Start is called before the first frame update
    void Start()
    {
        //get children of the object in objects
        foreach (Transform child in Objects.transform)
        {
            //set material of children to material
            child.GetComponent<Renderer>().material = material;
        }
        

        InvokeRepeating("ColourChange",0f,speed);
    }
    
    
    void ColourChange()
    {
        material.color = Color.Lerp(Color.black, Color.red, Mathf.PingPong(Time.time, 1));
    }
}
