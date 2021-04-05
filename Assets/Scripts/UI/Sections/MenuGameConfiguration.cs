using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System;

public class MenuGameConfiguration : MenuSection
{
    public Transform playerUI;
    [Space]
    public Slider bgSlider;
    public GameObject youCanStartTip, youAreFullTip;
    public AudioClip onePlayer, twoPlayers, threePlayers, fourPlayers, full, fullSfx, playerJoined, startGame;

    private float startTime;
    private List<int> skinsId;

    void Start()
    {
        UpdateUI();
    }

    void Update()
    {
        // Add player to room
        foreach (KeyCode kcode in Enum.GetValues(typeof(KeyCode)))
        {
            if (Input.GetKeyDown(kcode) && kcode != KeyCode.Tab)
            {
                if (GameManager.instance.playerInRoom.Count < 4)
                {
                    bool alreadyTaken = false;
                    foreach (PlayerStats stat in GameManager.instance.playerInRoom)
                    {
                        if (stat.input == kcode) alreadyTaken = true;
                    }

                    if (!alreadyTaken)
                    {
                        int id = UnityEngine.Random.Range(0, skinsId.Count - 1);
                        GameManager.instance.AddPlayerToRoom(new PlayerStats(kcode, skinsId[id]));
                        skinsId.RemoveAt(id);

                        UpdateUI();
                        MainMenu.instance.uiSource.Stop();
                        MainMenu.instance.uiSource.PlayOneShot(playerJoined);

                        if (GameManager.instance.playerInRoom.Count == 1)
                        {
                            VoiceOverManager.instance.Read(onePlayer);
                        }
                        else if (GameManager.instance.playerInRoom.Count == 2)
                        {
                            youCanStartTip.SetActive(true);
                            youAreFullTip.SetActive(false);
                            VoiceOverManager.instance.Read(twoPlayers);
                        }
                        else if (GameManager.instance.playerInRoom.Count == 3)
                        {
                            VoiceOverManager.instance.Read(threePlayers);
                        }
                        else if (GameManager.instance.playerInRoom.Count == 4)
                        {
                            youCanStartTip.SetActive(false);
                            youAreFullTip.SetActive(true);
                            VoiceOverManager.instance.Read(fourPlayers);
                        }
                    }
                }else 
                {
                    MainMenu.instance.uiSource.PlayOneShot(fullSfx);
                    VoiceOverManager.instance.Read(full); 
                }
            }
        }

    }

    public override void Equip()
    {
        startTime = Time.time;

        skinsId = new List<int> { 0, 1, 2, 3, 4, 5 };

        if (GetComponent<Readable>() != null)
        {
            GetComponent<Readable>().Read();
        }
    }

    public override void Hold(float holdValue)
    {
        if(GameManager.instance.playerInRoom.Count >= 2)
        {
            bgSlider.value = holdValue;
        }
    }

    public override void Validate()
    {
        if(GameManager.instance.playerInRoom.Count >= 2 && (Time.time - startTime) > 2)
        {
            MainMenu.instance.uiSource.Stop();
            MainMenu.instance.uiSource.PlayOneShot(startGame);

            GetComponent<Animator>().SetTrigger("StartGame");

            GameManager.instance.StartGame();
        }
    }

    public override void Exit()
    {
        GameManager.instance.ClearRoom();
        UpdateUI();
    }

    public void UpdateUI()
    {
        for(int i = 0; i < 4; i++)
        {
            if(i < GameManager.instance.playerInRoom.Count)
            {
                // Show information container
                Transform playerInformation = playerUI.GetChild(i);
                playerInformation.GetChild(0).gameObject.SetActive(true);
                playerInformation.GetChild(1).gameObject.SetActive(false);

                // Fill texts
                PlayerStats playerStats = GameManager.instance.playerInRoom[i];
                playerInformation.GetChild(0).GetChild(0).GetComponentInChildren<TMP_Text>().text = GameManager.instance.majorsNames[playerStats.skinId] + " — " + playerStats.input.ToString();
                playerInformation.GetChild(0).GetChild(1).GetChild(0).GetComponent<Image>().sprite = GameManager.instance.majorsAvatars[playerStats.skinId];
            }else
            {
                // Hide information container
                Transform playerInformation = playerUI.GetChild(i);
                playerInformation.GetChild(0).gameObject.SetActive(false);
                playerInformation.GetChild(1).gameObject.SetActive(true);
            }
        }
    }
}
