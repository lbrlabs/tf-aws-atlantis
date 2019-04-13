variable "name" {
  default = "atlantis"
}

variable "tags" {
  description = "A map of tags to use on all resources"
  default     = {}
}

variable "atlantis_port" {
  default = "4141"
}

variable "ecs_task_cpu" {
  description = "The number of cpu units used by the task"
  default     = 256
}

variable "ecs_task_memory" {
  description = "The amount (in MiB) of memory used by the task"
  default     = 512
}

variable "container_memory_reservation" {
  description = "The amount of memory (in MiB) to reserve for the container"
  default     = 128
}

variable "ecs_service_deployment_maximum_percent" {
  description = "The upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment"
  default     = 200
}

variable "ecs_service_deployment_minimum_healthy_percent" {
  description = "The lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment"
  default     = 50
}

variable "ecs_service_desired_count" {
  description = "The number of instances of the task definition to place and keep running"
  default     = 1
}

variable "cloudwatch_log_retention_in_days" {
  description = "Retention period of Atlantis CloudWatch logs"
  default     = 7
}

variable "policies_arn" {
  description = "A list of the ARN of the policies you want to apply"
  type        = "list"
  default     = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
}

variable "atlantis_repo_whitelist" {
  description = "List of allowed repositories Atlantis can be used with"
  type        = "list"
}

variable "atlantis_allowed_repo_names" {
  description = "Github repositories where webhook should be created"
  type        = "list"
  default     = []
}

# Github
variable "atlantis_github_user" {
  description = "GitHub username that is running the Atlantis command"
  default     = ""
}

variable "atlantis_github_user_token" {
  description = "GitHub token of the user that is running the Atlantis command"
  default     = ""
}

variable "alb_ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules of the ALB."
  type        = "list"
  default     = ["0.0.0.0/0"]
}

variable "atlantis_github_user_token_ssm_parameter_name" {
  description = "Name of SSM parameter to keep atlantis_github_user_token"
  default     = "/atlantis/github/user/token"
}

variable "route53_zone_name" {
  
}



