using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveCamera : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        //move object in x axis without using Vector3
        transform.position = new Vector3(transform.position.x + 0.1f, transform.position.y, transform.position.z);
        //if at 168 tp camera back to -24.56
        if (transform.position.x >= 168)
        {
            transform.position = new Vector3(-24f, transform.position.y, transform.position.z);
        }
    }
}
