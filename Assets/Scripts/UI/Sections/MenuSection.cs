using System.Collections.Generic;
using UnityEngine;

public class MenuSection : MonoBehaviour
{
    public List<MenuButton> buttons = new List<MenuButton>();
    [HideInInspector] public int currentButton = 0;

    public virtual void Equip()
    {
        GetComponent<Animator>().SetBool("isActive", true);

        currentButton = 0;
        if (buttons.Count > 0)
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
        GetComponent<Animator>().SetBool("isActive", false);
    }

    public virtual void Validate()
    {
        buttons[currentButton].Validate();
    }

    public virtual void Hold (float holdValue)
    {
        if(buttons.Count > 0) buttons[currentButton].Hold(holdValue);
    }
}
