using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaterialController : MonoBehaviour
{
    private float time = 0f;
    private bool emit = false;
    private Material mat;
    private float distance;
    private float emissionRate;
    
    public GameObject trigger;
    public float range;

    void Start()
    {
        Renderer renderer = GetComponent<Renderer>();
        mat = renderer.material;
    }
    void Update()
    {
        distance = Vector3.Distance(transform.position, trigger.transform.position);
        float percent = Mathf.InverseLerp(range, 0, distance);
        emissionRate = 25 * percent;

        if (time > emissionRate)
        {
            emit = !emit;
            if (emit)
                mat.SetFloat("_emissionopa",50f);
            else
                mat.SetFloat("_emissionopa", 0f);
            time = 0f;
        }

        time += Time.deltaTime;
    }
}
