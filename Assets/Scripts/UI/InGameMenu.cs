using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;

public class InGameMenu : MonoBehaviour
{
    public AudioSource mainSource;

    #region Singleton
    public static InGameMenu instance;

    void Awake()
    {
        if(instance == null)
        {
            instance = this;
        }
    }
    #endregion

    public void QuitScene()
    {
        StartCoroutine(QuitSceneCoroutine());
    }
    private IEnumerator QuitSceneCoroutine()
    {
        GetComponentInChildren<Animator>().SetTrigger("Hidden");
        yield return new WaitForSeconds(2f);
        SceneManager.LoadScene(2);
    }
}
