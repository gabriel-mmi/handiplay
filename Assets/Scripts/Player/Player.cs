using UnityEngine;

public class Player : Entity
{
    public KeyCode key;
    [Space]
    [Range(1, 50)] public float jumpForce;
    [Range(0, 50)] public float fallMultiplier;
    public float jumpTime;
    public float jumpToleranceTime;
    [Space]
    public Transform feetPos;
    public float checkRadius; //Circle qui teste si le joueur peut enchainer un deuxieme saut
    public LayerMask groundMask;

    public delegate void PlayerDie (Player player);
    public event PlayerDie OnPlayerDie;

    [HideInInspector] public int statsIndex;
    private Rigidbody rb;
    private Vector2 nextVelocity;
    private bool isGrounded, isJumping = false; //check si le personnage touche le sol et si il saute
    private float jumpTimeCounter, lastJumpTime = -500f; 

    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    void Update()
    {
        nextVelocity = Vector2.zero;
        isGrounded = Physics.CheckSphere(feetPos.position, checkRadius, groundMask);

        // Start jump
        if (!isJumping)
        {
            if (Input.GetKeyDown(key))
            {
                lastJumpTime = Time.time;
            }
            if ((Time.time - lastJumpTime) <= jumpToleranceTime)
            {
                if (isGrounded)
                {
                    rb.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);

                    isJumping = true;
                    jumpTimeCounter = jumpTime;
                }
            }
        }

        // End jump
        if (isJumping)
        {
            if (Input.GetKeyUp(key) || isGrounded)
            {
                isJumping = false;
                jumpTimeCounter = 0;
            }
        }

        // During jump
        if (Input.GetKey(key))
        {
            if (isJumping)
            {
                if (jumpTimeCounter > 0)
                {
                    nextVelocity = Vector3.up * jumpForce;
                    jumpTimeCounter -= Time.deltaTime;
                }
                else
                {
                    isJumping = false;
                    jumpTimeCounter = 0;
                }
            }
        }

        // Add gravity on fall out
        if (rb.velocity.y < 0)
        {
            if (!isGrounded)
            {
                nextVelocity = -Vector3.up * fallMultiplier;
            }
        }
    }

    void FixedUpdate()
    {
        //rb.velocity = nextVelocity;
        rb.AddForce(nextVelocity);
    }

    public override void Die()
    {
        if (OnPlayerDie != null) OnPlayerDie(this);
        Destroy(gameObject);
    }

    void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawSphere(feetPos.position, checkRadius);
    }
}



