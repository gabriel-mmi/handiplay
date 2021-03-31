using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerBehavior : MonoBehaviour
{
    public float jumpForce;

    private Rigidbody rb;

    private bool isGrounded = false;
    public Transform feetPos;
    public float checkRadius;
    public LayerMask whatisGrounded;

    private float jumpTimeCounter;
    public float jumpTime;
    private bool isJumping;



    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        isGrounded = Physics.CheckSphere(feetPos.position, checkRadius, whatisGrounded);
        
        if (isGrounded==true && Input.GetKeyDown(KeyCode.Space))
        {
            rb.velocity = Vector3.up * jumpForce;
            isJumping = true;
            jumpTimeCounter = jumpTime;
        }

        if (Input.GetKey(KeyCode.Space) && isJumping == true)
        {
            if(jumpTimeCounter > 0)
            {
                rb.velocity = Vector3.up * jumpForce;
                jumpTimeCounter -= Time.deltaTime;  
            } else
            {
                isJumping = false;
            }
        }

        if (Input.GetKeyUp(KeyCode.Space))
        {
            isJumping = false;
        }
    }

    void Jump()
    {

    }
}
