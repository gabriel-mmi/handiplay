public class SettingsMenuButton : MenuButton
{
    public override void Validate()
    {
        MainMenu.instance.SwitchSection(MainMenu.instance.settingsSection);
    }
}
