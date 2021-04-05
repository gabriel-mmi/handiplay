using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaterialController : MonoBehaviour
{
    [Range(0, 100)]
    public float animSpeed;
    public float emissionStrenght;
    [Space]
    public AudioClip beepClip;

    private Material mat;
    private AudioSource source;
    private float startDistance;
    private bool sfxPlayed;

    void Start()
    {
        mat = GetComponent<Renderer>().material;
        source = GetComponent<AudioSource>();
        startDistance = Vector3.Distance(transform.position, Vector3.zero);
    }

    void Update()
    {
        if (GameManager.instance.isAGameStarted)
        {
            float triggerDistance = Vector3.Distance(transform.position, Vector3.zero);
            if (triggerDistance >= startDistance) GetComponentInParent<Obstacle>().Die();
            else
            {
                float speed = (animSpeed / Mathf.Clamp(triggerDistance, 0.001f, 100000f));

                float emissionValue = Mathf.Sin(Time.time * speed) * emissionStrenght;
                mat.SetFloat("_emissionopa", Mathf.Clamp(emissionValue, 0, 100000f));

                // Player beep sfx
                if (GameManager.instance.settings.hearingHelp)
                {
                    if (emissionValue > 0 && !sfxPlayed)
                    {
                        sfxPlayed = true;
                        source.PlayOneShot(beepClip);
                    }
                    else if (emissionValue < 0)
                    {
                        sfxPlayed = false;
                    }
                }
            }
        }
    }
}
