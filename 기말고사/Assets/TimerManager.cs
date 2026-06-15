using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;

public class TimerManager : MonoBehaviour
{
    public float timeLimit = 60f;
    public TMP_Text timerText;

    private float currentTime;

    void Start()
    {
        currentTime = timeLimit;
    }

    void Update()
    {
        currentTime -= Time.deltaTime;

        if (currentTime < 0)
            currentTime = 0;

        timerText.text = "TIME : " + Mathf.CeilToInt(currentTime);

        if (currentTime <= 0)
        {
            SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
        }
    }
}