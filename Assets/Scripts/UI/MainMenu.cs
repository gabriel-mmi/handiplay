using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainMenu : MonoBehaviour
{
    public KeyCode actionKey;
    public float holdTime, doubleTapTime;
    [Space]
    public MenuSection landingSection;
    public MenuSection settingsSection;

    private MenuSection currentSection, lastSection;
    private float currentHoldTime, lastTapTime;

    #region Singleton
    public static MainMenu instance;
    void Awake()
    {
        if(instance == null)
        {
            instance = this;
        }
    }
    #endregion

    void Start()
    {
        currentSection = landingSection;
    }

    void Update()
    {
        // Hold
        if (Input.GetKey(actionKey))
        {
            currentHoldTime += Time.deltaTime;
            if(currentHoldTime >= holdTime)
            {
                currentSection.buttons[currentSection.currentButton].Validate();
                currentHoldTime = 0;
            }
        }
        // Release
        if (Input.GetKeyUp(actionKey))
        {
            currentHoldTime = 0;
            NextButton();
        }
        // Double tap
        if (Input.GetKeyDown(actionKey))
        {
            if (Time.time - lastTapTime > doubleTapTime)
                lastTapTime = Time.time;
            else
            {
                if (lastSection != null)
                    SwitchSection(lastSection);
            }
        }
    }

    public void NextButton()
    {
        currentSection.buttons[currentSection.currentButton].Exit();

        if (currentSection.currentButton == currentSection.buttons.Count - 1)
            currentSection.currentButton = 0;
        else
            currentSection.currentButton++;

        currentSection.buttons[currentSection.currentButton].Landing();
    }

    public void SwitchSection (MenuSection newSection)
    {
        currentSection.Exit();
        lastSection = currentSection;
        currentSection.gameObject.SetActive(false);

        currentSection = newSection;

        currentSection.gameObject.SetActive(true);
        currentSection.Equip();
    }
}
