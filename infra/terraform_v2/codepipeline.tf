resource "aws_iam_role" "codepipeline" {
  name = "${local.prefix}-codepipeline-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "codepipeline.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "codepipeline" {
  name = "${local.prefix}-codepipeline-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:GetObject","s3:GetObjectVersion","s3:PutObject","s3:ListBucket"]
        Resource = [aws_s3_bucket.artifacts.arn, "${aws_s3_bucket.artifacts.arn}/*"]
      },
      {
        Effect = "Allow"
        Action = [
          "codecommit:GetBranch","codecommit:GetCommit","codecommit:GetRepository",
          "codecommit:ListBranches","codecommit:GetUploadArchiveStatus",
          "codecommit:UploadArchive","codecommit:CancelUploadArchive"
        ]
        Resource = aws_codecommit_repository.source.arn
      },
      {
        Effect   = "Allow"
        Action   = ["codebuild:BatchGetBuilds","codebuild:StartBuild"]
        Resource = aws_codebuild_project.this.arn
      },
      {
        Effect = "Allow"
        Action = [
          "codedeploy:CreateDeployment",
          "codedeploy:GetApplication",
          "codedeploy:GetDeployment",
          "codedeploy:GetDeploymentConfig",
          "codedeploy:GetDeploymentGroup",
          "codedeploy:RegisterApplicationRevision"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = ["iam:PassRole"]
        Resource = [aws_iam_role.codebuild.arn, aws_iam_role.codedeploy.arn]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_attach" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = aws_iam_policy.codepipeline.arn
}

resource "aws_codepipeline" "env" {
  for_each = local.envs

  name     = "${local.prefix}-${each.key}-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_out"]
      configuration = {
        RepositoryName       = aws_codecommit_repository.source.repository_name
        BranchName           = var.codecommit_branch
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_out"]
      output_artifacts = ["build_out"]
      configuration = { ProjectName = aws_codebuild_project.this.name }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      version         = "1"
      input_artifacts = ["build_out"]
      configuration = {
        ApplicationName                = aws_codedeploy_app.ecs.name
        DeploymentGroupName            = aws_codedeploy_deployment_group.env[each.key].deployment_group_name
        TaskDefinitionTemplateArtifact = "build_out"
        TaskDefinitionTemplatePath     = "taskdef.json"
        AppSpecTemplateArtifact        = "build_out"
        AppSpecTemplatePath            = "appspec.yaml"
        Image1ArtifactName             = "build_out"
        Image1ContainerName            = "IMAGE1_NAME"
      }
    }
  }
}
