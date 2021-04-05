using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;
using TMPro;

public class InGameMenu : MonoBehaviour
{
    public AudioSource mainSource, musicSource;
    public TMP_Text startCounter;
    public Animator showGoAnimator;
    [Space]
    public AudioClip whistleClip, counterClip;

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

    private void Start()
    {
        StartCoroutine(StartCinematique());
    }
    private IEnumerator StartCinematique()
    {
        startCounter.text = "";
        startCounter.transform.parent.gameObject.SetActive(false);

        yield return new WaitForSeconds(1f);

        Camera.main.GetComponent<Animator>().SetBool("StartGame", true);

        yield return new WaitForSeconds(4f);

        startCounter.transform.parent.gameObject.SetActive(true);
        int max = 3;
        for(int i = 0; i <= max; i++)
        {
            startCounter.text = (max - i).ToString();

            if(i == max)
            {
                mainSource.PlayOneShot(whistleClip);
                showGoAnimator.SetTrigger("ShowGO");
            }
            else
            {
                mainSource.PlayOneShot(counterClip);
            }

            yield return new WaitForSeconds(1f);
        }

        startCounter.text = "";
        startCounter.transform.parent.gameObject.SetActive(false);

        musicSource.Play();
    }

    public void QuitScene()
    {
        StartCoroutine(QuitSceneCoroutine());
    }
    private IEnumerator QuitSceneCoroutine()
    {
        GetComponentInChildren<Animator>().SetTrigger("Hidden");
        yield return new WaitForSeconds(1f);
        mainSource.PlayOneShot(whistleClip);
        yield return new WaitForSeconds(2f);
        SceneManager.LoadScene(2);
    }
}
