using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObstacleBehaviour : MonoBehaviour
{
    public float moveSpeed, rotSpeed;
    [Space]
    public GameObject collisionEffect;

    // Start is called before the first frame update
    void Start()
    {
        // Destroy obstacle after 10 seconds (so when is not longer used)
        Destroy(gameObject, 10);

        // Create smoke at start
        StartCoroutine(CreateEffectCoroutine(0.1f));
    }

    // Update is called once per frame
    void Update()
    {
        // Move
        transform.localPosition = transform.localPosition + Time.deltaTime * moveSpeed * Vector3.right;

        // Rotation animation
        transform.GetChild(0).eulerAngles -= new Vector3(0, 0, Time.deltaTime * rotSpeed);
    }

    private void OnCollisionEnter(Collision collision)
    {
        // Apply damages to player and destroy
        //if (collision.gameObject.tag == "Player")
        //{
        //    collision.GetComponent<PlayerBehaviour>().Die();
        //    Destroy(gameObject);
        //}
    }

    // Function to create smoke effect
    IEnumerator CreateEffectCoroutine (float delay)
    {
        yield return new WaitForSeconds(delay);
        Instantiate(collisionEffect, transform.position, Quaternion.identity);
    }
}
