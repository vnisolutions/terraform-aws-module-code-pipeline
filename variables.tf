variable "env" {
  description = "Enviroment for application such as prod, stg, dev"
  type        = string
}

variable "project_name" {
  description = "Project name application"
  type        = string
}

variable "service_name" {
  description = "Service fargate will be create. Such as web, api ..."
  type        = string
}

variable "codepipeline_artifact" {
  description = "S3 bucket store artifact code build and code pipeline"
  type        = string
}

variable "git_repo" {
  description = "Repo name source code comit"
  type        = string
}

variable "deploy_branch" {
  description = "Branch name code commit to deploy"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of cluster ECS"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of service ECS to deploy"
  type        = string
}


