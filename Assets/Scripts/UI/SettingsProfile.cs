using UnityEngine;

[System.Serializable]
public class SettingsProfile
{
    public bool hearingHelp, viewHelp, lowDifficulty;

    public SettingsProfile (bool _hearingHelp, bool _viewHelp, bool _lowDifficulty)
    {
        hearingHelp = _hearingHelp;
        viewHelp = _viewHelp;
        lowDifficulty = _lowDifficulty;
    }
}
