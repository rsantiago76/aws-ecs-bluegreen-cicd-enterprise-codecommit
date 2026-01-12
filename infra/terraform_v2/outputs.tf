output "account_id" { value = local.account_id }
output "region"     { value = local.region }

output "codecommit_clone_url_https" {
  value = aws_codecommit_repository.source.clone_url_http
}

output "artifacts_bucket_name" { value = aws_s3_bucket.artifacts.bucket }
output "ecr_repo_url"          { value = aws_ecr_repository.app.repository_url }
output "alb_dns"               { value = { for env, lb in aws_lb.env : env => lb.dns_name } }
