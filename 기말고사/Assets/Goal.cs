using UnityEngine;
using TMPro;

public class Goal : MonoBehaviour
{
    public GameObject clearPanel;
    public TMP_Text clearText;

    private void OnTriggerEnter(Collider other)
    {
        if (!other.CompareTag("Player"))
            return;

        clearPanel.SetActive(true);
        clearText.text = "GAME CLEAR";

        Time.timeScale = 0f;
    }
}