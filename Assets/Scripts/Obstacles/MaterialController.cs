using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaterialController : MonoBehaviour
{
    public GameObject trigger;
    private float distance;
    void Start()
    {
        trigger = GameObject.FindGameObjectWithTag("ObstacleTrigger");
    }
    void Update()
    {
        Renderer renderer = GetComponent<Renderer>();
        Material mat = renderer.material;

        distance = Vector3.Distance(transform.position, trigger.transform.position);


        Debug.Log(transform.parent.parent.GetComponent<Rigidbody>().velocity.magnitude);

        mat.SetFloat("_emissionopa", Mathf.PingPong(Time.time * distance, 10f)) ;

    }
}
