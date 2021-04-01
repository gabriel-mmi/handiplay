public class LowerDifficultyMenuToggle : MenuToggle
{
    public override void Toggle(bool _value)
    {
        base.Toggle(_value);
        GameManager.instance.settings.lowDifficulty = _value;
    }
}
