using System.Collections.Generic;
using UnityEngine;

public class MenuSection : MonoBehaviour
{
    public List<MenuButton> buttons = new List<MenuButton>();
    [HideInInspector] public int currentButton = 0;

    public void Equip()
    {
        if(buttons.Count > 0)
        {
            for (int i = 0; i < buttons.Count; i++)
            {
                if (i == 0) buttons[i].Landing();
                else buttons[i].Exit();
            }
        } 
    }

    public virtual void Exit()
    {
        GameManager.instance.settings = new SettingsProfile(true, true, false);
    }

    public virtual void Validate()
    {
        buttons[currentButton].Validate();
    }
}
