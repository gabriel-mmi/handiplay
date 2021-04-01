using UnityEngine;

[System.Serializable]
public class PlayerStats
{
    public KeyCode input;
    public int skinId;

    public PlayerStats (KeyCode _input, int _skinId)
    {
        input = _input;
        skinId = _skinId;
    }
}
