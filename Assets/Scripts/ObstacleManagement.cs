using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObstacleManagement : MonoBehaviour
{

    public float spawnRate = 5f;

    public bool spawn = true;

    public GameObject obstacle;

    // Start is called before the first frame update
    void Start()
    {
        //Instantiate(obstacle, startPositionLeft, Quaternion.identity);
        StartCoroutine(StartWave());
    }
    IEnumerator StartWave()
    {
        while(spawn)
        {
            Instantiate(obstacle, transform.position, Quaternion.Euler(0, 180, 0));
            yield return new WaitForSeconds(spawnRate);
        }
    }
}
