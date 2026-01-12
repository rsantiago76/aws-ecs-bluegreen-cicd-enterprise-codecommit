bucket         = "YOUR-TFSTATE-BUCKET"
key            = "state/aws-ecs-bg-cicd/ACCOUNT_ID/us-east-1/prod/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "terraform-locks"
