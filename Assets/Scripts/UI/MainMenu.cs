using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MainMenu : MonoBehaviour
{
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

        // Update settings toggles
        settingsSection.buttons[0].GetComponent<MenuToggle>().toggle.SetBool("isActive", GameManager.instance.settings.hearingHelp);
        settingsSection.buttons[1].GetComponent<MenuToggle>().toggle.SetBool("isActive", GameManager.instance.settings.viewHelp);
        settingsSection.buttons[2].GetComponent<MenuToggle>().toggle.SetBool("isActive", GameManager.instance.settings.lowDifficulty);
    }

    void Update()
    {
        // Hold
        if (Input.GetKey(GameManager.instance.actionKey) && !hadValidateAButton)
        {
            currentHoldTime += Time.deltaTime;
            float holdValue = Mathf.Clamp(currentHoldTime / GameManager.instance.holdTime * 100, 0, 100);
            currentSection.Hold(holdValue);

            if(currentHoldTime >= GameManager.instance.holdTime)
            {
                currentSection.Validate();
                hadValidateAButton = true;
                currentHoldTime = 0;
            }
        }
        // Release
        if (Input.GetKeyUp(GameManager.instance.actionKey))
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
        if (Input.GetKeyDown(GameManager.instance.actionKey))
        {
            if (Time.time - lastTapTime > GameManager.instance.doubleTapTime)
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
        if(currentSection == configSection) currentSection.gameObject.SetActive(false);

        currentSection = newSection;

        currentSection.gameObject.SetActive(true);
        currentSection.Equip();
    }
}
