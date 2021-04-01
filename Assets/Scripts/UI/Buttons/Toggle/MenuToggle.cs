using UnityEngine;
using UnityEngine.UI;

public class MenuToggle : MenuButton
{
    public Animator toggle;
    private bool value;

    public override void Validate()
    {
        value = !value;
        Toggle(value);
    }

    public virtual void Toggle(bool _value)
    {
        toggle.SetBool("isActive", _value);
    }
}
