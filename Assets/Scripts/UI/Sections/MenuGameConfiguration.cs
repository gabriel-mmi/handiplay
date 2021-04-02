using System.Collections.Generic;
using UnityEngine;
using TMPro;
using System;

public class MenuGameConfiguration : MenuSection
{
    public Transform playerUI;
    public GameObject youCanStartTip, youAreFullTip;
    public AudioClip onePlayer, twoPlayers, threePlayers, fourPlayers, full;

    private string[] majorsNames = new string[6] { "Grayo", "Gradel", "Gronico", "Graëtan", "Granis", "Grabriel" };
    private float startTime;

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
                        GameManager.instance.AddPlayerToRoom(new PlayerStats(kcode, UnityEngine.Random.Range(0, GameManager.instance.playerSkinsPrefabs.Count)));
                        UpdateUI();
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
                }else { VoiceOverManager.instance.Read(full); }
            }
        }

    }

    public override void Equip()
    {
        startTime = Time.time;

        if (GetComponent<Readable>() != null)
        {
            GetComponent<Readable>().Read();
        }
    }

    public override void Validate()
    {
        if(GameManager.instance.playerInRoom.Count >= 2 && (Time.time - startTime) > 2)
        {
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
                playerInformation.GetChild(0).GetChild(0).GetComponentInChildren<TMP_Text>().text = majorsNames[playerStats.skinId] + " — " + playerStats.input.ToString();
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
