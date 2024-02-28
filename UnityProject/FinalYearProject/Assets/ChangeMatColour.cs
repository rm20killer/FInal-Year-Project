using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeMatColour : MonoBehaviour
{
    public Material material;
    public GameObject Objects;
    public float speed = 0.02f;
    private Vector4 Oldcolour;
     // Start is called before the first frame update
    void Start()
    {
        Oldcolour = material.color;
        //get children of the object in objects
        foreach (Transform child in Objects.transform)
        {
            //set material of children to material
            child.GetComponent<Renderer>().material = material;
        }
        

        InvokeRepeating("ColourChange",0f,speed);
    }

    private void OnApplicationQuit()
    {
        material.color = Oldcolour;
    }
    
    //on stop change colour back to original
    private void OnDisable()
    {
        material.color = Oldcolour;
    }

    void ColourChange()
    {
        material.color = Color.Lerp(Color.black, Color.red, Mathf.PingPong(Time.time, 1));
    }
}
