using System.Collections.Generic;
using UnityEngine;
using TMPro;
using System;

public class MenuGameConfiguration : MenuSection
{
    public Transform playerUI, playerMeshes;
    public List<GameObject> playerMeshesPrefabs = new List<GameObject>();

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
                GameManager.instance.AddPlayerToRoom(new PlayerStats(kcode, UnityEngine.Random.Range(0, 2)));
                UpdateUI();
            }
        }

    }

    public override void Validate()
    {
        GameManager.instance.StartGame();
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
                playerInformation.GetChild(0).GetChild(0).GetComponent<TMP_Text>().text = "Joueur " + (i + 1);
                playerInformation.GetChild(0).GetChild(1).GetComponent<TMP_Text>().text = GameManager.instance.playerInRoom[i].input.ToString();

                // Create mesh
                GameObject mesh = Instantiate(playerMeshesPrefabs[GameManager.instance.playerInRoom[i].skinId], playerMeshes.GetChild(i));
                mesh.transform.localPosition = Vector3.zero;
            }else
            {
                // Hide information container
                Transform playerInformation = playerUI.GetChild(i);
                playerInformation.GetChild(0).gameObject.SetActive(false);
                playerInformation.GetChild(1).gameObject.SetActive(true);

                if(playerMeshes.GetChild(i).childCount > 0)
                {
                    Destroy(playerMeshes.GetChild(i).GetChild(0).gameObject);
                }
            }
        }
    }
}
