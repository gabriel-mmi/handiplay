using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class MenuButton : MonoBehaviour
{
    public virtual void Landing(bool playVoiceOver = true)
    {
        GetComponent<Animator>().SetBool("isActive", true);
        transform.GetChild(transform.childCount - 1).GetComponent<Animator>().SetBool("isActive", true);

        if(playVoiceOver) ReadVoiceOver();
    }

    public virtual void Hold (float holdValue)
    {
        transform.GetChild(0).GetComponentInChildren<Slider>().value = holdValue;
    }

    public virtual void Validate()
    {
        // Custom actions here...
    }

    public virtual void Exit()
    {
        GetComponent<Animator>().SetBool("isActive", false);
        transform.GetChild(0).GetComponentInChildren<Slider>().value = 0;
        transform.GetChild(transform.childCount - 1).GetComponent<Animator>().SetBool("isActive", false);
    }

    public virtual void ReadVoiceOver()
    {
        if(GetComponent<Readable>()) GetComponent<Readable>().Read();
    }
}
