# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-gov-west-1"
}


variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "1"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "public.ecr.aws/pacovk/tapir:latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8080
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 2
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "vpc_id" {
  description = "ID of existing VPC"
  default = "vpc-0b6e4626452408825"
}
