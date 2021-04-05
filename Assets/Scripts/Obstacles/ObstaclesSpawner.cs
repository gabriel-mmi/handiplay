using System.Collections;
using UnityEngine;

public class ObstaclesSpawner : MonoBehaviour
{
    public bool canSpawn = true;
    [Space]
    public GameObject standardObstacle;
    public GameObject visualAssistObstacle;
    [Space]
    public float startDelay;
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
        yield return new WaitForSeconds(startDelay);
        startWaveTime = Time.time;
        while(canSpawn)
        {
            // Spawn obstacle
            if (GameManager.instance.settings.viewHelp || GameManager.instance.settings.hearingHelp)
            {
                Instantiate(visualAssistObstacle, transform.position, Quaternion.Euler(0, 180, 0));
            }
            else
            {
                Instantiate(standardObstacle, transform.position, Quaternion.Euler(0, 180, 0));
            }

            // Then wait for the next spawn
            float x = Time.time - startWaveTime;
            float rate = -rateDecreaseSpeed * x + startRate;
            rate = Mathf.Clamp(rate, minRate, startRate);
            yield return new WaitForSeconds(rate);
        }
    }
}
