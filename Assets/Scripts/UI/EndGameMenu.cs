using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System;

public class EndGameMenu : MonoBehaviour
{
    public MenuButton button;
    public TMP_Text firstTime, secondTime, thirdTime;
    public Image firstAvatar, secondAvatar, thirdAvatar;
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

    public void UpdateUI(List<KeyValuePair<int, float>> scoreBoard)
    {
        // First player
        int firstPlayerIndex = GameManager.instance.playerInRoom[scoreBoard[scoreBoard.Count - 1].Key].skinId;
        float firstPlayerTime = scoreBoard[scoreBoard.Count - 1].Value;
        firstTime.text = FromatTime(firstPlayerTime);
        firstAvatar.sprite = GameManager.instance.majorsAvatars[firstPlayerIndex];

        // Second player
        int secondPlayerIndex = GameManager.instance.playerInRoom[scoreBoard[scoreBoard.Count - 2].Key].skinId;
        float secondPlayerTime = scoreBoard[scoreBoard.Count - 2].Value;
        secondTime.text = FromatTime(secondPlayerTime);
        secondAvatar.sprite = GameManager.instance.majorsAvatars[secondPlayerIndex];

        // Third player
        if (scoreBoard.Count >= 3)
        {
            int thirdPlayerIndex = GameManager.instance.playerInRoom[scoreBoard[scoreBoard.Count - 3].Key].skinId;
            float thirdPlayerTime = scoreBoard[scoreBoard.Count - 3].Value;
            thirdTime.text = FromatTime(thirdPlayerTime);
            thirdAvatar.sprite = GameManager.instance.majorsAvatars[thirdPlayerIndex];
        }
        else
        {
            thirdTime.gameObject.SetActive(false);
            thirdAvatar.gameObject.SetActive(false);
        }

        VoiceOverManager.instance.Read(customsEndVoicesOver[firstPlayerIndex]);
    }

    private string FromatTime(float time)
    {
        TimeSpan timeSpan = TimeSpan.FromSeconds(time);
        return string.Format("{0:D2}:{1:D2}", timeSpan.Minutes, timeSpan.Seconds);
    }
}
