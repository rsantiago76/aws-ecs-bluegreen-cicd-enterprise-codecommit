# AWS ECS Blue/Green Deployment Architecture

![Architecture Diagram](architecture.png)

## Architecture Overview

This project implements a production-grade ECS Blue/Green deployment using native AWS CI/CD services and Terraform.

## CI/CD Flow

1. Developer pushes code to CodeCommit
2. CodePipeline orchestrates the workflow
3. CodeBuild builds and pushes Docker images to ECR
4. CodeDeploy performs Blue/Green ECS deployment
5. Application Load Balancer shifts traffic safely
6. ECS Fargate runs immutable container task sets

## Key Benefits

- Zero-downtime deployments
- Automated rollback on failure
- Immutable infrastructure
- Fully automated CI/CD

## AWS Services

- CodeCommit
- CodePipeline
- CodeBuild
- CodeDeploy (ECS Blue/Green)
- ECS Fargate
- Application Load Balancer
- Amazon ECR
- CloudWatch Logs
