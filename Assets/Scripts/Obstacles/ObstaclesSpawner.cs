using System.Collections;
using UnityEngine;

public class ObstaclesSpawner : MonoBehaviour
{
    public bool camSpawn = true;
    [Space]
    public GameObject obstacle;
    [Space]
    public float rateDecreaseSpeed;
    public float startRate;
    public float minRate;

    private float startWaveTime;

    void Start()
    {
        StartCoroutine(StartWave());
    }

    private IEnumerator StartWave()
    {
        startWaveTime = Time.time;
        while(camSpawn)
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
