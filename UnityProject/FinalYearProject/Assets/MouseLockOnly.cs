using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseLockOnly : MonoBehaviour
{
    void Start()
    {
        Cursor.lockState = CursorLockMode.Locked;
    }
}
