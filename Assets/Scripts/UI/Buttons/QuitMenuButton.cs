using UnityEngine;

public class QuitMenuButton : MenuButton
{
    public override void Validate()
    {
        Application.Quit();
    }
}
