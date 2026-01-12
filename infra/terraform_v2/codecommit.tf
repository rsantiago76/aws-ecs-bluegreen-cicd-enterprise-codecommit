resource "aws_codecommit_repository" "source" {
  repository_name = var.codecommit_repo_name
  description     = "Source repo for ECS Blue/Green CI/CD (CodeCommit)"
}
