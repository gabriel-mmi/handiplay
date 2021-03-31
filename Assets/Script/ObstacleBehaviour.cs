using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObstacleBehaviour : MonoBehaviour
{

    public int speed;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    private void Awake()
    {
        speed = Random.Range(4, 10);
    }

    // Update is called once per frame
    void Update()
    {
        transform.localPosition = transform.localPosition + Time.deltaTime * speed * Vector3.right;

    }

    private void OnCollisionEnter(Collision collision)
    {
        //if (collision.gameObject.tag == "Limit")
        //{
        //    transform.Rotate(0, 180, 0);
        //}

        //if (collision.gameObject.tag == "Player")
        //{
        //    die();
        //}
    }
}
