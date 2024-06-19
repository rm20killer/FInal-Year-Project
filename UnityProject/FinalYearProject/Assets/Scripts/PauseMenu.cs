using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PauseMenu : MonoBehaviour
{
    public GameObject pauseMenu;

    private void Start()
    {
        Time.timeScale = 1;
    }

    void Update()
    {
        //if p or else is pressed pause game
        if (Input.GetKeyDown(KeyCode.P) || Input.GetKeyDown(KeyCode.Escape))
        {
            if (Time.timeScale == 1)
            {
                Time.timeScale = 0;
                pauseMenu.SetActive(true);
                //unlock the cursor
                Cursor.lockState = CursorLockMode.None;
            }
            else
            {
                Time.timeScale = 1;
                pauseMenu.SetActive(false);
                //lock the cursor
                Cursor.lockState = CursorLockMode.Locked;
            }
        }
        
    }
}
