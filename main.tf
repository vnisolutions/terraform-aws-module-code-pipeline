resource "aws_codepipeline" "codepipeline" {

  name     = "${var.env}-${var.project_name}-${var.service_name}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = var.codepipeline_artifact
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
        RepositoryName = var.git_repo
        BranchName     = var.deploy_branch
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
      input_artifacts  = ["source_out"]
      output_artifacts = ["build_out"]
      version          = "1"

      configuration = {
        ProjectName = "${var.env}-${var.project_name}-${var.service_name}-codebuild"
      }
    }
  }
  stage {
    name = "Deploy"

    action {
      name            = "DeployECS"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["build_out"]
      version         = "1"

      configuration = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.ecs_service_name
        FileName    = "image_definitions.json"
      }
    }
  }
}

module "code-build" {
  count                 = var.create_build ? 1 : 0
  source                = "./modules/code-build"
  vpc_id                = var.vpc_id
  env                   = var.env
  service_name          = var.service_name
  project_name          = var.project_name
  codepipeline_artifact = var.codepipeline_artifact
}
