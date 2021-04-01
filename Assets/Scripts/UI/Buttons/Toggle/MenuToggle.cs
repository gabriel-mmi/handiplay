using UnityEngine.UI;

public class MenuToggle : MenuButton
{
    public Slider toggle;
    private bool value;

    public override void Validate()
    {
        value = !value;

        Toggle(value);
    }

    public virtual void Toggle(bool _value)
    {
        if (_value == true)
            toggle.value = 100;
        else
            toggle.value = 0;
    }
}
