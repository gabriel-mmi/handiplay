using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System;

public class EndGameMenu : MonoBehaviour
{
    public MenuButton buttonRestart;
    public TMP_Text firstPlayerTimeText, secondPlayerTimeText, thirdPlayerTimeText;
    public TMP_Text firstPlayerNameText, secondPlayerNameText, thirdPlayerNameText;
    public Image firstAvatarImage, secondAvatarImage, thirdAvatarImage;
    [Space]
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
        buttonRestart.Landing();
    }

    // Inputs actiobs (restart, quit...)
    void Update()
    {
        // Hold
        if (Input.GetKey(GameManager.instance.actionKey))
        {
            currentHoldTime += Time.deltaTime;
            float holdTime = Mathf.Clamp(currentHoldTime / GameManager.instance.holdTime * 100, 0, 100);
            buttonRestart.Hold(holdTime);

            if (currentHoldTime >= GameManager.instance.holdTime)
            {
                buttonRestart.Validate();
                currentHoldTime = 0;
            }
        }
        // Release
        if (Input.GetKeyUp(GameManager.instance.actionKey))
        {
            buttonRestart.Hold(0);
            currentHoldTime = 0;
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

    // Update texts and avatars
    public void UpdateUI(List<KeyValuePair<int, float>> scoreBoard)
    {
        // First player
        int firstPlayerIndex = GameManager.instance.playerInRoom[scoreBoard[scoreBoard.Count - 1].Key].skinId;
        float firstPlayerTime = scoreBoard[scoreBoard.Count - 1].Value;
        firstPlayerTimeText.text = FromatTime(firstPlayerTime);
        firstPlayerNameText.text = GameManager.instance.majorsNames[firstPlayerIndex];
        firstAvatarImage.sprite = GameManager.instance.majorsAvatars[firstPlayerIndex];

        // Second player
        int secondPlayerIndex = GameManager.instance.playerInRoom[scoreBoard[scoreBoard.Count - 2].Key].skinId;
        float secondPlayerTime = scoreBoard[scoreBoard.Count - 2].Value;
        secondPlayerTimeText.text = FromatTime(secondPlayerTime);
        secondPlayerNameText.text = GameManager.instance.majorsNames[secondPlayerIndex];
        secondAvatarImage.sprite = GameManager.instance.majorsAvatars[secondPlayerIndex];

        // Third player
        if (scoreBoard.Count >= 3)
        {
            int thirdPlayerIndex = GameManager.instance.playerInRoom[scoreBoard[scoreBoard.Count - 3].Key].skinId;
            float thirdPlayerTime = scoreBoard[scoreBoard.Count - 3].Value;
            thirdPlayerTimeText.text = FromatTime(thirdPlayerTime);
            thirdPlayerNameText.text = GameManager.instance.majorsNames[thirdPlayerIndex];
            thirdAvatarImage.sprite = GameManager.instance.majorsAvatars[thirdPlayerIndex];
        }
        else
        {
            thirdPlayerTimeText.gameObject.SetActive(false);
            thirdPlayerNameText.gameObject.SetActive(false);
            thirdAvatarImage.gameObject.SetActive(false);
        }

        // Voice over
        VoiceOverManager.instance.Read(customsEndVoicesOver[firstPlayerIndex]);
    }

    private string FromatTime(float time)
    {
        TimeSpan timeSpan = TimeSpan.FromSeconds(time);
        return string.Format("{0:D2}:{1:D2}", timeSpan.Minutes, timeSpan.Seconds);
    }
}
