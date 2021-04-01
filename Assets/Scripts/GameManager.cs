using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    public List<GameObject> playerSkinsPrefabs = new List<GameObject>();

    [HideInInspector] public SettingsProfile settings;
    private List<PlayerStats> playerInRoom = new List<PlayerStats>();
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
        OnLevelFinishedLoading(SceneManager.GetActiveScene(), LoadSceneMode.Single);
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
        if (Input.GetKeyDown(KeyCode.Space) && currentScene.buildIndex == 0)
        {
            // 1 : Send settings
            GameManager.instance.settings = new SettingsProfile(true, true, false);

            // 2 : Send players in room
            GameManager.instance.AddPlayerToRoom(new PlayerStats(KeyCode.Space, Random.Range(0, 2)));
            GameManager.instance.AddPlayerToRoom(new PlayerStats(KeyCode.F, Random.Range(0, 2)));
            GameManager.instance.AddPlayerToRoom(new PlayerStats(KeyCode.Z, Random.Range(0, 2)));

            // 3 : Start the game!
            GameManager.instance.StartGame();
        }
        // Left the game
        else if (Input.GetKeyDown(KeyCode.Space) && gameIsFinished == true)
        {
            gameIsFinished = false;
            QuitGame();
        }

        // On all player died
        if(GameObject.FindObjectsOfType<PlayerBehavior>().Length <= 0 && currentScene.buildIndex == 1)
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

            PlayerBehavior newPlayerBehavior = newPlayer.GetComponent<PlayerBehavior>();
            newPlayerBehavior.key = newPlayerStats.input;
        }

        startGameTime = Time.time;
    }
}
