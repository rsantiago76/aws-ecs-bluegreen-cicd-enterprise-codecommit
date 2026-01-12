param(
  [Parameter(Mandatory=$true)][string]$Profile,
  [Parameter(Mandatory=$true)][string]$Region,
  [Parameter(Mandatory=$true)][string]$BucketName,
  [Parameter(Mandatory=$true)][string]$DdbTableName
)

Write-Host "Using profile: $Profile, region: $Region"
aws sts get-caller-identity --profile $Profile --region $Region | Out-Host

Write-Host "Creating S3 bucket for Terraform state (if needed)..."
if ($Region -eq "us-east-1") {
  aws s3api create-bucket --bucket $BucketName --region $Region --profile $Profile 2>$null
} else {
  aws s3api create-bucket --bucket $BucketName --region $Region --create-bucket-configuration LocationConstraint=$Region --profile $Profile 2>$null
}

aws s3api put-bucket-versioning --bucket $BucketName --versioning-configuration Status=Enabled --region $Region --profile $Profile | Out-Host
aws s3api put-bucket-encryption --bucket $BucketName --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}' --region $Region --profile $Profile | Out-Host

Write-Host "Creating DynamoDB table for state locking (if needed)..."
aws dynamodb create-table `
  --table-name $DdbTableName `
  --attribute-definitions AttributeName=LockID,AttributeType=S `
  --key-schema AttributeName=LockID,KeyType=HASH `
  --billing-mode PAY_PER_REQUEST `
  --region $Region --profile $Profile 2>$null

Write-Host "Done."
