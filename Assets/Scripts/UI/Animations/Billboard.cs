using UnityEngine;

public class Billboard : MonoBehaviour
{
    void Update()
    {
        Quaternion lookRotation = Quaternion.LookRotation(Camera.main.transform.position - transform.position, Vector3.up);
        transform.rotation = Quaternion.Euler(lookRotation.eulerAngles.x, lookRotation.eulerAngles.y + 180, lookRotation.eulerAngles.z);
    }
}
