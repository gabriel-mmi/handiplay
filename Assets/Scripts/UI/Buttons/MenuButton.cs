using UnityEngine;
using TMPro;

public class MenuButton : MonoBehaviour
{
    public virtual void Landing()
    {
        GetComponentInChildren<TMP_Text>().color = new Color32(67, 188, 205, 255);
    }

    public virtual void Hold()
    {

    }

    public virtual void Validate()
    {
        // Custom actions here...
    }

    public virtual void Exit()
    {
        GetComponentInChildren<TMP_Text>().color = new Color32(255, 255, 255, 255);
    }
}
