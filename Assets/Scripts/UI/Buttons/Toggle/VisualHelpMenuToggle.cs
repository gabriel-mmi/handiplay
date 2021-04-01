public class VisualHelpMenuToggle : MenuToggle
{
    public override void Toggle(bool _value)
    {
        base.Toggle(_value);
        GameManager.instance.settings.viewHelp = _value;
    }
}
