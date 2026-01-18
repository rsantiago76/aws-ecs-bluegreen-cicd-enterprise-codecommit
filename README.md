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
<img width="1600" height="1000" alt="architecture" src="https://github.com/user-attachments/assets/6536a304-9b1c-4e37-a861-c03ab827d037" />


### Cost Optimized Variant
<img width="1600" height="1000" alt="architecture-cost-optimized" src="https://github.com/user-attachments/assets/f4f1a1ad-e170-4fa7-b3a0-ed3fd1bc8c7e" />

