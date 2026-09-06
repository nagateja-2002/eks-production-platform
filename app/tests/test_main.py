from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_health():
    response = client.get("/api/health")

    assert response.status_code == 200
    assert response.json() == {
        "status": "UP"
    }


def test_version():
    response = client.get("/api/version")

    assert response.status_code == 200
    assert response.json()["service"] == "eks-production-platform"
    assert response.json()["version"] == "1.0.0"


def test_info():
    response = client.get("/api/info")

    assert response.status_code == 200
    assert response.json()["service"] == "eks-production-platform"