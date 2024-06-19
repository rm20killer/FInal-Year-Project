using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Button : MonoBehaviour
{
    public void ReutrnToMenu()
    {
        //load the main menu
        UnityEngine.SceneManagement.SceneManager.LoadScene(0);
    }
    
    public void QuitGame()
    {
        //quit the game
        Application.Quit();
    }
    
    public void StartGame()
    {
        //load the game scene
        UnityEngine.SceneManagement.SceneManager.LoadScene(1);
    }
    
    public void RestartGame()
    {
        //reload the current scene
        UnityEngine.SceneManagement.SceneManager.LoadScene(UnityEngine.SceneManagement.SceneManager.GetActiveScene().buildIndex);
    }
    
    public void SampleScene()
    {
        //load the sample scene
        UnityEngine.SceneManagement.SceneManager.LoadScene(3);
    }

    public void flyabout()
    {
        //load the flyabout scene
        UnityEngine.SceneManagement.SceneManager.LoadScene(2);
    }
}
