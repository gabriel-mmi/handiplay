using UnityEngine;

public abstract class Entity : MonoBehaviour
{
    protected bool isDead = false;

    public virtual void Die()
    {
        isDead = false;
    }
}
