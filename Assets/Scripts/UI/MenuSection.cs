using System.Collections.Generic;
using UnityEngine;

public class MenuSection : MonoBehaviour
{
    public List<MenuButton> buttons = new List<MenuButton>();
    [HideInInspector] public int currentButton = 0;

    public void Equip()
    {
        buttons[0].Landing();
    }

    public void Exit()
    {
        GameManager.instance.settings = new SettingsProfile(true, true, false);
    }
}
