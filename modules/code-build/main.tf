resource "aws_security_group" "codebuild" {
  vpc_id      = var.vpc_id
  description = "Build project"

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "${var.env}-${var.project_name}-${var.service_name}-codebuild"
    Environment = "${var.env}"
    Management  = "terraform"
  }
}

resource "aws_codebuild_project" "codebuild" {
  name          = "${var.env}-${var.project_name}-${var.service_name}-codebuild"
  description   = "Build project"
  build_timeout = "30"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = var.codepipeline_artifact
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image_pull_credentials_type = "CODEBUILD"
    image                       = "aws/codebuild/standard:5.0"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "${var.env}-${var.project_name}-${var.service_name}-buildspec.yml"
  }

  source_version = "master"

  depends_on = [
    aws_iam_role_policy.codebuild_role_policy
  ]
  tags = {
    Name        = "${var.env}-${var.project_name}-${var.service_name}-codebuild"
    Environment = "${var.env}"
    Management  = "terraform"
  }
}
