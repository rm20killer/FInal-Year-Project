using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotationScript : MonoBehaviour
{
    // Start is called before the first frame update
    public float speed = 10f;
    public float x = 0f;
    public float y = 0f;
    public float z = 0f;
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        //keep rotating
        transform.Rotate(x * speed * Time.deltaTime, y * speed * Time.deltaTime, z * speed * Time.deltaTime);
    }
}
