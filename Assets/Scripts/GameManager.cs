using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Rendering;
using System.Linq;

public class GameManager : MonoBehaviour
{
    public List<GameObject> playerSkinsPrefabs = new List<GameObject>();
    public List<Sprite> majorsAvatars = new List<Sprite>();
    public string[] majorsNames = new string[6] { "Grayo", "Gradel", "Gronico", "Graëtan", "Granis", "Grabriel" };

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
        float playersDistance = 3;
        float spawnPosX = playersDistance;
        switch (playerInRoom.Count)
        {
            case 2:
                spawnPosX *= -0.5f;
                break;
            case 3:
                spawnPosX *= -1f;
                break;
            case 4:
                spawnPosX *= -1.5f;
                break;
        }
        
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
            InGameMenu.instance.QuitScene();
        }
    }

    public void InitializeEndGameScene()
    {
        // Calculate score board
        List<KeyValuePair<int, float>> sortedScoreBoard = scoreBoard.ToList();

        sortedScoreBoard.Sort(
            delegate(KeyValuePair<int, float> pair1,
            KeyValuePair<int, float> pari2)
            {
                return pair1.Value.CompareTo(pari2.Value);
            }    
        );

        EndGameMenu.instance.UpdateUI(sortedScoreBoard);
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
