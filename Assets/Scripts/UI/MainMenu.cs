using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MainMenu : MonoBehaviour
{
    public MenuSection landingSection;
    public MenuSection settingsSection, configSection;
    [Space]
    public AudioSource uiSource;
    public AudioClip landingClip, validateClip;

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
        settingsSection.buttons[0].GetComponent<MenuToggle>().SetValue(GameManager.instance.settings.hearingHelp);
        settingsSection.buttons[1].GetComponent<MenuToggle>().toggle.SetBool("isActive", GameManager.instance.settings.viewHelp);
        settingsSection.buttons[1].GetComponent<MenuToggle>().SetValue(GameManager.instance.settings.viewHelp);
        settingsSection.buttons[2].GetComponent<MenuToggle>().toggle.SetBool("isActive", GameManager.instance.settings.lowDifficulty);
        settingsSection.buttons[2].GetComponent<MenuToggle>().SetValue(GameManager.instance.settings.lowDifficulty);

        // Play voice over
        if (GameManager.instance.settings.hearingHelp) GetComponent<Readable>().Read();
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

                if(currentSection.buttons.Count > 0)
                {
                    uiSource.Stop();
                    uiSource.PlayOneShot(validateClip);
                }     
            }
        }
        // Release
        if (Input.GetKeyUp(GameManager.instance.actionKey))
        {
            currentSection.Hold(0);

            if (!hadValidateAButton)
            {
                if (currentSection.buttons.Count > 0)
                {
                    NextButton();
                    uiSource.Stop();
                    uiSource.PlayOneShot(landingClip);
                }
            }
            hadValidateAButton = false;
            currentHoldTime = 0;
        }
        // Double tap
        if (Input.GetKeyDown(GameManager.instance.actionKey) && !hadValidateAButton)
        {
            if (Time.time - lastTapTime > GameManager.instance.doubleTapTime)
                lastTapTime = Time.time;
            else
            {
                if (lastSection != null)
                {
                    SwitchSection(lastSection);
                    hadValidateAButton = true;
                }
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
