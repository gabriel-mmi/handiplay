using UnityEngine;

public class Player : Entity
{
    public KeyCode key;
    [Space]
    [Range(1, 50)] public float jumpForce;
    [Range(0, 50)] public float fallMultiplier;
    public float jumpTime; 
    [Space]
    public Transform feetPos;
    public float checkRadius; //Circle qui teste si le joueur peut enchainer un deuxieme saut
    public LayerMask groundMask;

    public delegate void PlayerDie (Player player);
    public event PlayerDie OnPlayerDie;

    [HideInInspector] public int statsIndex;
    private Rigidbody rb;
    private bool isGrounded = false; //check si le personnage touche le sol
    private float jumpTimeCounter; 
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
        isGrounded = Physics.CheckSphere(feetPos.position, checkRadius, groundMask);

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

    public override void Die()
    {
        if (OnPlayerDie != null) OnPlayerDie(this);
        Destroy(gameObject);
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawSphere(feetPos.position, checkRadius);
    }
}



