using UnityEngine;

public class StartMenuButton : MenuButton
{
    public override void Validate()
    {
        MainMenu.instance.SwitchSection(MainMenu.instance.configSection);
    }
}
