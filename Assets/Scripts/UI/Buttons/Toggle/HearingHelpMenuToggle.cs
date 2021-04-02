using UnityEngine;

public class HearingHelpMenuToggle : MenuToggle
{
    public override void Toggle(bool _value)
    {
        base.Toggle(_value);
        GameManager.instance.settings.hearingHelp = _value;
    }
}
