using UnityEngine;
using TMPro;

public class ScoreManager : MonoBehaviour
{
    public static ScoreManager Instance;

    public TMP_Text scoreText;

    private int score = 0;

    void Awake()
    {
        Instance = this;
    }

    void Start()
    {
        scoreText.text = "SCORE : 0";
    }

    public void AddScore(int amount)
    {
        score += amount;
        scoreText.text = "SCORE : " + score;
    }
}