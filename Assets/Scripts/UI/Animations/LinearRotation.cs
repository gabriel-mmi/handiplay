using UnityEngine;

public class LinearRotation : MonoBehaviour
{
    public float rotSpeed;

    void Update()
    {
        transform.eulerAngles += new Vector3(0, 0, rotSpeed * Time.deltaTime);
    }
}
