using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using System;

public class EndGameMenu : MonoBehaviour
{
    public MenuButton button;
    public TMP_Text firstTime, secondTime, thirdTime;
    public List<AudioClip> customsEndVoicesOver = new List<AudioClip>();
    private float currentHoldTime, lastTapTime;

    #region Singleton
    public static EndGameMenu instance;
    void Awake()
    {
        if (instance == null)
        {
            instance = this;
        }
    }
    #endregion

    void Start()
    {
        button.Landing();
    }

    void Update()
    {
        // Hold
        if (Input.GetKey(GameManager.instance.actionKey))
        {
            currentHoldTime += Time.deltaTime;
            float holdTime = Mathf.Clamp(currentHoldTime / GameManager.instance.holdTime * 100, 0, 100);
            button.Hold(holdTime);

            if (currentHoldTime >= GameManager.instance.holdTime)
            {
                button.Validate();
                currentHoldTime = 0;
            }
        }
        // Release
        if (Input.GetKeyUp(GameManager.instance.actionKey))
        {
            currentHoldTime = 0;
            button.Hold(0);
        }
        // Double tap
        if (Input.GetKeyDown(GameManager.instance.actionKey))
        {
            if (Time.time - lastTapTime > GameManager.instance.doubleTapTime) lastTapTime = Time.time;
            else
            {
                GameManager.instance.QuitGame();
            }
        }
    }

    public void UpdateUI(int firstPlayer, int secondPlayer, int thirdPlayer)
    {
        firstTime.text = FromatTime(GameManager.instance.GetPlayerTime(firstPlayer));
        secondTime.text = FromatTime(GameManager.instance.GetPlayerTime(secondPlayer));
        if (thirdPlayer > 0) thirdTime.text = FromatTime(GameManager.instance.GetPlayerTime(thirdPlayer));
        else thirdTime.text = "";

        VoiceOverManager.instance.Read(customsEndVoicesOver[firstPlayer]);
    }

    private string FromatTime(float time)
    {
        TimeSpan timeSpan = TimeSpan.FromSeconds(time);
        return string.Format("{0:D2}:{1:D2}", timeSpan.Minutes, timeSpan.Seconds);
    }
}
