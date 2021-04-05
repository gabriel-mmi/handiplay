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
    private Dictionary<KeyCode, float> doubleTapBuffer = new Dictionary<KeyCode, float>();

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
                // Remove player on double tap key if he exist
                if (doubleTapBuffer.ContainsKey(kcode))
                {
                    if ((Time.time - doubleTapBuffer[kcode]) < GameManager.instance.doubleTapTime)
                    {
                        int index = -1;
                        for (int i = 0; i < GameManager.instance.playerInRoom.Count; i++)
                        {
                            if (GameManager.instance.playerInRoom[i].input == kcode)
                            {
                                index = i;
                                break;
                            }
                        }

                        if (index >= 0)
                        {
                            GameManager.instance.playerInRoom.RemoveAt(index);
                            doubleTapBuffer.Remove(kcode);
                            UpdateUI();
                        }
                    }else
                    {
                        // Update last input
                        doubleTapBuffer[kcode] = Time.time;
                    }
                }
                // Else add new player
                else if (GameManager.instance.playerInRoom.Count < 4)
                {
                    doubleTapBuffer.Add(kcode, Time.time);

                    // Add player to GameManager's room
                    int id = UnityEngine.Random.Range(0, skinsId.Count);
                    GameManager.instance.AddPlayerToRoom(new PlayerStats(kcode, skinsId[id]));
                    skinsId.RemoveAt(id);

                    // Update UI
                    UpdateUI();

                    // Play cool sound fx
                    MainMenu.instance.uiSource.Stop();
                    MainMenu.instance.uiSource.PlayOneShot(playerJoined);

                    // Read voice over
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
                else
                {
                    // Full voice over
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
        doubleTapBuffer.Clear();
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
