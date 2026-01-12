from fastapi import FastAPI
import os

app = FastAPI(title="aws-ecs-bg-cicd")

@app.get("/health")
def health():
    return {"status": "ok", "env": os.getenv("ENV", "unknown")}

@app.get("/")
def root():
    return {"message": "Hello from ECS Blue/Green CI/CD (CodeCommit)!"}
