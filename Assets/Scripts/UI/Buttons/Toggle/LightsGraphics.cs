public class LightsGraphics : MenuToggle
{
    public override void Toggle(bool _value)
    {
        base.Toggle(_value);
        GameManager.instance.settings.lowQuality = _value;
    }
}
