locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  prefix        = var.project_name
  unique_suffix = "${local.account_id}-${local.region}"

  artifacts_bucket_name = "${local.prefix}-${local.unique_suffix}-artifacts"
  ecr_repo_name         = "${local.prefix}-${local.account_id}-app"
  ecs_cluster_name      = "${local.prefix}-cluster"
  codedeploy_app_name   = "${local.prefix}-cd-app"

  alb_name = { for env, cfg in local.envs : env => substr("${local.prefix}-${env}-alb", 0, 32) }
}
