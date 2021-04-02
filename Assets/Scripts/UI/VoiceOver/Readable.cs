using UnityEngine;

public class Readable : MonoBehaviour
{
    public AudioClip clip;

    public virtual void Read()
    {
        VoiceOverManager.instance.Read(clip);
    }
}
