using UnityEngine;
using UnityEngine.SceneManagement;

public class StartMenuButton : MenuButton
{
    public GameObject configGame;

    public override void Validate()
    {
        configGame.SetActive(true);
        MainMenu.instance.landingSection.gameObject.SetActive(false);
        MainMenu.instance.settingsSection.gameObject.SetActive(false);
    }
}
