using System.Collections;
using System.Collections.Generic;
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
    [Space]
    public Animator meshAnimator;
    public GameObject deathEffect, jumpEffect;
    public AudioClip jumpClip, destroyClip;
    public List<AudioClip> deathClips = new List<AudioClip>();
    public TextMesh keyTextMesh;

    public delegate void PlayerDie (Player player);
    public event PlayerDie OnPlayerDie;

    [HideInInspector] public int statsIndex;
    private Rigidbody rb;
    private AudioSource audioSource;
    private Vector2 nextVelocity;
    private bool isGrounded, isJumping = false; //check si le personnage touche le sol et si il saute
    private float jumpTimeCounter, lastJumpTime = -500f;
    private bool autoJump;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        audioSource = GetComponent<AudioSource>();

        keyTextMesh.text = key.ToString();
    }

    void Update()
    {
        if (!isDead)
        {
            nextVelocity = Vector2.zero;
            isGrounded = Physics.CheckSphere(feetPos.position, checkRadius, groundMask);

            // Animations
            meshAnimator.SetBool("isJumping", !isGrounded);

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
                        Instantiate(jumpEffect, feetPos.position, Quaternion.identity);
                        audioSource.PlayOneShot(jumpClip);

                        isJumping = true;
                        jumpTimeCounter = jumpTime;
                    }
                }
            }

            // End jump
            if (isJumping)
            {
                if (Input.GetKeyUp(key))
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
        isDead = true;
        if (OnPlayerDie != null) OnPlayerDie(this);
        StartCoroutine(DieCoroutine());
    }
    private IEnumerator DieCoroutine()
    {
        meshAnimator.SetTrigger("isDead");
        audioSource.PlayOneShot(deathClips[Random.Range(0, deathClips.Count - 1)]);
        yield return new WaitForSeconds(2f);
        Instantiate(deathEffect, transform.position, Quaternion.identity);
        InGameMenu.instance.mainSource.PlayOneShot(destroyClip);
        Destroy(gameObject);
    }

    void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawSphere(feetPos.position, checkRadius);
    }

    public void OnGameStart()
    {
        keyTextMesh.transform.parent.gameObject.SetActive(false);
    }
}



