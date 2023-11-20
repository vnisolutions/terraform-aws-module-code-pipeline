variable "vpc_id" {
  description = "The ID of the VPC will be used"
  type        = string
}

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
