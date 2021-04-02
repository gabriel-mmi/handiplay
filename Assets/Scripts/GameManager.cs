using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Rendering;

public class GameManager : MonoBehaviour
{
    public List<GameObject> playerSkinsPrefabs = new List<GameObject>();
    [Space]
    public KeyCode actionKey;
    public float holdTime, doubleTapTime;
    [Space]
    public VolumeProfile highQualitySettings;
    public VolumeProfile lowQualitySettings;
    [HideInInspector] public SettingsProfile settings;
    [HideInInspector] public List<PlayerStats> playerInRoom = new List<PlayerStats>();
    private Scene currentScene;

    // In-game
    private float startGameTime;
    private int deathCount;
    private Dictionary<int, float> scoreBoard = new Dictionary<int, float>();

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

        settings.hearingHelp = true;
    }
    #endregion

    #region On scene loaded callback
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

            case 2:
                InitializeEndGameScene();
                break;
        }
    }
    #endregion

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
        StartCoroutine(StartGameCoroutine());
    }
    private IEnumerator StartGameCoroutine()
    {
        yield return new WaitForSeconds(0.4f);
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
            newPlayerBehavior.statsIndex = i;
            newPlayerBehavior.key = newPlayerStats.input;
        }

        // Listen to player's event
        foreach (Player player in FindObjectsOfType<Player>())
        {
            player.OnPlayerDie += OnPlayerDie;
        }

        // Quality settings applying
        if (settings.lowQuality)
        {
            Volume volume = GameObject.FindGameObjectWithTag("PostProcessing").GetComponent<Volume>();
            volume.profile = lowQualitySettings;
        }

        scoreBoard.Clear();
        startGameTime = Time.time;
    }

    public void OnPlayerDie (Player player)
    {
        scoreBoard.Add(player.statsIndex, Time.time - startGameTime);
        player.OnPlayerDie -= OnPlayerDie;
        deathCount++;
        
        if(deathCount >= playerInRoom.Count)
        {
            deathCount = 0;
            SceneManager.LoadScene(2);
        }
    }

    public void InitializeEndGameScene()
    {
        // Calculate score board
        int first = -1;
        int second = -1;
        int third = -1;

        for (int i = 0; i < scoreBoard.Count; i++)
        {
            if (scoreBoard[i] > first)
            {
                third = second;
                second = first;
                first = i;
            }else if (scoreBoard[i] > second)
            {
                third = second;
                second = i;
            }else if (scoreBoard[i] > third)
            {
                third = i;
            }
        }

        EndGameMenu.instance.UpdateUI(first, second, third);
    }

    public float GetPlayerTime(int playerIndex)
    {
        return scoreBoard[playerIndex];
    }

    public void ClearScoreBoard()
    {
        scoreBoard.Clear();
    }
}
