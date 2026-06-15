using UnityEngine;

public class CollectItem : MonoBehaviour
{
    public int scoreValue = 10;

    private void OnTriggerEnter(Collider other)
    {
        if (!other.CompareTag("Player"))
            return;

        ScoreManager.Instance.AddScore(scoreValue);

        Destroy(gameObject);
    }
}