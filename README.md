# Complete Rebuild: ECS Blue/Green CI/CD (CodeCommit)

This repo is a **from-scratch rebuild** that creates everything needed for:
**CodeCommit → CodeBuild → ECR → CodeDeploy (ECS Blue/Green) → ECS Fargate**.

## Prereqs
- AWS CLI v2 (SSO OK)
- Terraform >= 1.5
- Docker (optional for local test)

## 0) Pick a profile/account
Example:
```powershell
$env:AWS_PROFILE="dev_sso"
$env:AWS_REGION="us-east-1"
aws sts get-caller-identity
```

## 1) Bootstrap Terraform remote state (S3 + DynamoDB)
```powershell
./scripts/bootstrap-tfstate.ps1 -Profile $env:AWS_PROFILE -Region $env:AWS_REGION -BucketName "my-tfstate-<unique>" -DdbTableName "terraform-locks"
```

## 2) Update backend config
Edit `infra/terraform_v2/backend/dev.hcl`:
- bucket = your state bucket
- replace ACCOUNT_ID in key path with your AWS account id

## 3) Deploy dev first
```powershell
cd infra/terraform_v2
terraform init -reconfigure -backend-config="backend/dev.hcl"
terraform apply -var='environments=["dev"]'
```

## 4) Push code to the CodeCommit repo created by Terraform
Terraform output: `codecommit_clone_url_https`

Configure HTTPS credential helper:
```powershell
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
```

Push:
```powershell
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin <PASTE_OUTPUT_CLONE_URL>
git push -u origin main
```

## 5) Check pipeline + ALB
- CodePipeline runs on commit (you can also release change manually in console).
- ALB DNS is output as `alb_dns["dev"]`.

## Notes
- This baseline uses **public subnets** for simplicity.
- Next hardening step: private subnets + NAT + HTTPS + WAF.
