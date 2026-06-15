using UnityEngine;

public class SpeedPad : MonoBehaviour
{
    public float speedIncrease = 5f;
    public float duration = 5f;

    private void OnTriggerEnter(Collider other)
    {
        PlayerController player = other.GetComponent<PlayerController>();

        if (player != null)
        {
            player.SpeedBoost(speedIncrease, duration);
        }
    }
}