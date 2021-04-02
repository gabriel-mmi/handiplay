using UnityEngine;

public class VoiceOverManager : MonoBehaviour
{
    #region Singleton
    public static VoiceOverManager instance;
    void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
    }
    #endregion

    AudioSource source;

    void Start()
    {
        source = GetComponent<AudioSource>();
    }

    public void Read (AudioClip clip)
    {
        if (GameManager.instance.settings.hearingHelp)
        {
            source.Stop();
            source.PlayOneShot(clip);
        }
    }
}
