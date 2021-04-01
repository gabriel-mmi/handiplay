using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    public List<GameObject> playerSkinsPrefabs = new List<GameObject>();

    public SettingsProfile settings;
    [HideInInspector] public List<PlayerStats> playerInRoom = new List<PlayerStats>();
    private Scene currentScene;

    // In-game
    private float startGameTime;
    private bool gameIsFinished;

    #region Singleton
    public static GameManager instance;
    void Awake()
    {
        if(instance == null)
        {
            instance = this;
            DontDestroyOnLoad(gameObject);
        }else
        {
            if(instance != this)
            {
                Destroy(gameObject);
            }
        }
    }
    #endregion

    #region On scene loaded callback
    void Start()
    {
        //OnLevelFinishedLoading(SceneManager.GetActiveScene(), LoadSceneMode.Single);
    }

    void OnEnable()
    {
        SceneManager.sceneLoaded += OnLevelFinishedLoading;
    }

    void OnDisable()
    {
        SceneManager.sceneLoaded -= OnLevelFinishedLoading;
    }

    void OnLevelFinishedLoading(Scene scene, LoadSceneMode mode)
    {
        currentScene = scene;
        switch (scene.buildIndex)
        {
            case 0:
                Debug.Log("Welcome to Super Majors All Stars!");
                break;

            case 1:
                InitializeGameScene();
                break;
        }
    }
    #endregion

    void Update()
    {
        // Start a game

        // Left the game
        if (Input.GetKeyDown(KeyCode.Space) && gameIsFinished == true)
        {
            gameIsFinished = false;
            QuitGame();
        }

        // On all player died
        if(GameObject.FindObjectsOfType<Player>().Length <= 0 && currentScene.buildIndex == 1)
        {
            gameIsFinished = true;
            GameObject.FindGameObjectWithTag("EndScreen").transform.GetChild(0).gameObject.SetActive(true);
        }
    }

    #region Room methods
    public void ClearRoom()
    {
        playerInRoom.Clear();
    }

    public void AddPlayerToRoom (PlayerStats newPlayer)
    {
        playerInRoom.Add(newPlayer);
    }
    #endregion

    // Quit main menu and go to game's scene
    public void StartGame()
    {
        SceneManager.LoadScene(1);
    }

    public void QuitGame()
    {
        ClearRoom();
        SceneManager.LoadScene(0);
    }

    // On game scene is loaded...
    public void InitializeGameScene()
    {
        // Create each players
        float playersDistance = 10 / playerInRoom.Count;
        float spawnPosX = -(playerInRoom.Count / 2) * playersDistance;
        
        for(int i = 0; i < playerInRoom.Count; i++)
        {
            PlayerStats newPlayerStats = playerInRoom[i];
            GameObject newPlayer = Instantiate(playerSkinsPrefabs[newPlayerStats.skinId], new Vector3(spawnPosX, 4, 0), Quaternion.identity);
            spawnPosX += playersDistance;

            Player newPlayerBehavior = newPlayer.GetComponent<Player>();
            newPlayerBehavior.key = newPlayerStats.input;
        }

        startGameTime = Time.time;
    }
}
