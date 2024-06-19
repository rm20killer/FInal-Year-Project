using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Coins : MonoBehaviour
{
    public CoinManager coinManager;
    
    private Transform StartPos;
    private float RandomDelay;
    private void Start()
    {
        coinManager = GameObject.Find("Mangers").GetComponent<CoinManager>();
        StartPos = transform;
        RandomDelay = UnityEngine.Random.Range(0.5f, 1f);
    }

    //on collision with player
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            coinManager.CollectCoin(gameObject);
        }
    }

    private void Update()
    {
        //spin coin in y axis bounce up and down
        transform.position = new Vector3(StartPos.position.x, StartPos.position.y + (Mathf.Sin(Time.time * 1)*RandomDelay / 2)/100, StartPos.position.z);

        transform.Rotate(100 * Time.deltaTime, 0, 0);
        
    }
}
