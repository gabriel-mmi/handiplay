using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerBehavior : MonoBehaviour
{
    [Range(1, 10)]
    public float jumpForce, fallMultiplier;
    public KeyCode key;
    [Space]
    private bool isGrounded = false; //check si le personnage touche le sol
    [Space]
    public Transform feetPos;
    public float checkRadius; //Circle qui teste si le joueur peut enchainer un deuxieme saut
    public LayerMask whatisGrounded; 

    private Rigidbody rb;
    private float jumpTimeCounter; 
    public float jumpTime; 
    private bool isJumping;


    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    void Update()
    {
        Jump();

        if (rb.velocity.y < 0)
        {
            rb.velocity += Vector3.up * Physics.gravity.y * (fallMultiplier - 1) * Time.deltaTime;
        }
    }


    //Fonction de saut
    void Jump()
    {
        isGrounded = Physics.CheckSphere(feetPos.position, checkRadius, whatisGrounded);

        if (isGrounded == true && Input.GetKeyDown(key))
        {
            rb.velocity = Vector3.up * jumpForce;
            isJumping = true;
            jumpTimeCounter = jumpTime;
        }

        if (Input.GetKey(key) && isJumping == true)
        {
            if (jumpTimeCounter > 0)
            {
                rb.velocity = Vector3.up * jumpForce;
                jumpTimeCounter -= Time.deltaTime;
            }
            else
            {
                isJumping = false;
            }
        }

        if (Input.GetKeyUp(key))
        {
            isJumping = false;
        }
    }

    public void Die()
    {
        Destroy(this.gameObject);
    }
}



