using UnityEngine;

[System.Serializable]
public class SettingsProfile
{
    public bool hearingHelp, viewHelp, lowDifficulty, lowQuality;

    public SettingsProfile (bool _hearingHelp, bool _viewHelp, bool _lowDifficulty, bool _lowQUality)
    {
        hearingHelp = _hearingHelp;
        viewHelp = _viewHelp;
        lowDifficulty = _lowDifficulty;
        lowQuality = _lowDifficulty;
    }
}
