# AWS ECS Blue/Green CI/CD Architecture

## Architecture Overview
This project demonstrates a production-grade AWS ECS Blue/Green deployment using native AWS CI/CD services.

### Key Components
- CodeCommit – Source control
- CodePipeline – CI/CD orchestration
- CodeBuild – Docker image builds
- ECR – Container image registry
- CodeDeploy (ECS) – Blue/Green deployments
- Application Load Balancer – Traffic shifting
- ECS Fargate – Serverless containers
- CloudWatch & X-Ray – Observability

## Diagrams
### Standard Architecture
![Architecture](architecture.png)

### Cost Optimized Variant
![Cost Optimized Architecture](architecture-cost-optimized.png)
