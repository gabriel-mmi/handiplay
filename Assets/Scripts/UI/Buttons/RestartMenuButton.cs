using UnityEngine.SceneManagement;

public class RestartMenuButton : MenuButton
{
    public override void Validate()
    {
        GameManager.instance.ClearScoreBoard();
        SceneManager.LoadScene(1);
    }

    public override void Hold(float holdValue)
    {
        base.Hold(holdValue);
    }
}
