using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObstacleManagement : MonoBehaviour
{

    public bool spawn = true;
    [Space]
    public GameObject obstacle;
    [Space]
    public float rateDecreaseSpeed;
    public float startRate;
    public float minRate;

    float startWaveTime;

    // Start is called before the first frame update
    void Start()
    {
        //Instantiate(obstacle, startPositionLeft, Quaternion.identity);
        StartCoroutine(StartWave());
    }

    private IEnumerator StartWave()
    {
        startWaveTime = Time.time;
        while(spawn)
        {
            // Spawn obstacle
            Instantiate(obstacle, transform.position, Quaternion.Euler(0, 180, 0));

            // Then wait for the next spawn
            float x = Time.time - startWaveTime;
            float rate = -rateDecreaseSpeed * x + startRate;
            rate = Mathf.Clamp(rate, minRate, startRate);
            yield return new WaitForSeconds(rate);
        }
    }
}
