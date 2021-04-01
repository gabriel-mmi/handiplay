using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainMenu : MonoBehaviour
{
    public KeyCode actionKey;
    public float holdTime, doubleTapTime;
    [Space]
    public MenuSection landingSection;
    public MenuSection settingsSection, configSection;

    private MenuSection currentSection, lastSection;
    private float currentHoldTime, lastTapTime;
    private bool hadValidateAButton = false;

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
        currentSection.Equip();
    }

    void Update()
    {
        // Hold
        if (Input.GetKey(actionKey))
        {
            currentHoldTime += Time.deltaTime;
            currentSection.Hold(Mathf.Clamp(currentHoldTime / holdTime * 100, 0, 100));

            if(currentHoldTime >= holdTime)
            {
                currentSection.Validate();
                hadValidateAButton = true;
                currentHoldTime = 0;
            }
        }
        // Release
        if (Input.GetKeyUp(actionKey))
        {
            if (!hadValidateAButton)
            {
                if (currentSection.buttons.Count > 0) NextButton();
            }else {
                currentSection.Hold(0);
            }
            hadValidateAButton = false;
            currentHoldTime = 0;
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
