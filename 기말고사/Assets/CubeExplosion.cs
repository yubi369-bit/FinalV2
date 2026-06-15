using UnityEngine;

public class CubeExplosion : MonoBehaviour
{
    public GameObject cubePrefab;

    public int minCubeCount = 10;
    public int maxCubeCount = 30;

    public float minForce = 3f;
    public float maxForce = 8f;

    private void OnTriggerEnter(Collider other)
    {
        if (!other.CompareTag("Player"))
            return;

        int cubeCount = Random.Range(minCubeCount, maxCubeCount + 1);

        for (int i = 0; i < cubeCount; i++)
        {
            Vector3 randomPos = transform.position + Random.insideUnitSphere * 0.5f;

            GameObject cube = Instantiate(
                cubePrefab,
                randomPos,
                Random.rotation
            );

            Rigidbody rb = cube.GetComponent<Rigidbody>();

            if (rb != null)
            {
                rb.velocity = Vector3.zero;

                Vector3 randomDirection = Random.onUnitSphere;
                float randomForce = Random.Range(minForce, maxForce);

                rb.AddForce(
                    randomDirection * randomForce,
                    ForceMode.Impulse
                );

                rb.AddTorque(
                    Random.insideUnitSphere * 10f,
                    ForceMode.Impulse
                );
            }

            Destroy(cube, 2f);
        }

        Destroy(gameObject);
    }
}