from fastapi import FastAPI

app = FastAPI(
    title="EKS Production Platform API",
    description="Production-oriented application for the EKS DevOps platform",
    version="1.0.0",
)


@app.get("/api/health")
def health():
    return {
        "status": "UP"
    }


@app.get("/api/version")
def version():
    return {
        "service": "eks-production-platform",
        "version": "1.0.0"
    }


@app.get("/api/info")
def info():
    return {
        "service": "eks-production-platform",
        "description": "Cloud-native application running on AWS EKS"
    }