variable "project_name" {
  type    = string
  default = "aws-ecs-bg-cicd"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environments" {
  type        = list(string)
  description = "Environments to deploy"
  default     = ["dev", "staging", "prod"]
}

variable "codecommit_repo_name" {
  type        = string
  description = "CodeCommit repository name (created by Terraform)"
  default     = "aws-ecs-bg-cicd-source"
}

variable "codecommit_branch" {
  type    = string
  default = "main"
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "healthcheck_path" {
  type    = string
  default = "/health"
}
