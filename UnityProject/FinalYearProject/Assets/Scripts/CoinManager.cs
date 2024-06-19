using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class CoinManager : MonoBehaviour
{
    public GameObject[] Coins;
    public int coinsCollected = 0;
    public int totalCoins;
    public TextMeshProUGUI coinText;
    public GameObject WinText;
    
    
    // Start is called before the first frame update
    void Start()
    {
        //find all that have Coin tag
        Coins = GameObject.FindGameObjectsWithTag("Coin");
        totalCoins = Coins.Length;
        
    }

    public void CollectCoin(GameObject Coin)
    {
        coinsCollected++;
        Coin.SetActive(false);
        if (coinsCollected == totalCoins)
        {
            Debug.Log("All coins collected");
        }
    
    }

    private void Update()
    {
        coinText.text = "Collect Coins: " + coinsCollected + "/" + totalCoins;
        if (coinsCollected == totalCoins)
        {
            WinText.SetActive(true);
            Cursor.lockState = CursorLockMode.None;
            //change time scale to 0
            Time.timeScale = 0;
            
        }
    }
}
