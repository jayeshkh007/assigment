variable "cidr" {
   default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24"]
}
variable "vpc_name" {
  type = string
  default = "testing"
}
variable "cluster_name" {
  type = string
  default = "test-cluster"
}
variable "aws_key_pair" {
  type = string
  default = "test"
}
variable "env_type" {
  type = string
  default = "dev"
}
variable "region" {
  type = string
  default = "us-west-1"
}

variable "default_capacity_provider" {
  type = string
  default = ""
}

variable "application_keys" {
  type    = list(string)
  default = ["alias/applicationConfigKey"]
}

variable "backend_service_name" {
  type = string
  default = "backend"
}

variable "task_definition_cpu" {
  type = number
  default = "256"
}

variable "task_definition_memory" {
  type = number
  default = "512"
}

variable "backend_container_image" {
  type = string
  default = "817514109580.dkr.ecr.us-west-1.amazonaws.com/backend:latest"
}

variable "backend_container_port" {
  type = number
  default = 5000
}

variable "frontend_service_name" {
  type = string
  default = "frontend"
}

variable "frontend_container_image" {
  type = string
  default = "817514109580.dkr.ecr.us-west-1.amazonaws.com/frontend:latest"
}

variable "frontend_container_port" {
  type = number
  default = 8080
}

variable "task_count" {
  type = number
  default = 1
}

variable "deployment_maximum_percent" {
  type = number
  default = 200
}

variable "deployment_minimum_healthy_percent" {
  type = number
  default = 100
}

variable "healthy_threshold"{
  type = number
  default = 2
}

variable "unhealthy_threshold" {
  type = number
  default = 2
}

variable "healthcheck_timeout" {
  type = number
  default = 10
}

variable "healthcheck_protocol" {
  type = string
  default = "HTTP"
}

variable "healthcheck_path" {
  type = string
  default = "/"
}

variable "healthcheck_interval" {
  type = number
  default = 30
}

variable "healthcheck_matcher" {
  type = string
  description = "Specifies whether to enable Amazon ECS Exec for the tasks within the service."
  default     =  "200-299"
}

variable "create_repository_credentials_iam_policy" {
  default     = false
  description = "Set to true if you are specifying `repository_credentials` variable, it will attach IAM policy with necessary permissions to task role."
}

variable "repository_credentials_kms_key" {
  default     = "alias/aws/secretsmanager"
  description = "key id, key ARN, alias name or alias ARN of the key that encrypted the repository credentials"
  type        = string
}

variable "log_retention_in_days" {
  description = "Number of days the logs will be retained in CloudWatch."
  default     = 30
  type        = number
}

variable "logs_kms_key" {
  type        = string
  description = "The KMS key ARN to use to encrypt container logs."
  default     = ""
}

variable "enable_execute_command" {
  type        = bool
  description = "Specifies whether to enable Amazon ECS Exec for the tasks within the service."
  default     = true
}

variable "repository_credentials" {
  default     = ""
  description = "name or ARN of a secrets manager secret (arn:aws:secretsmanager:region:aws_account_id:secret:secret_name)"
  type        = string
}

variable "backend_host_port" {
  description = "backend host port."
  default     = 5000
  type        = number
}

variable "frontend_host_port" {
  description = "frontend host port."
  default     = 8080
  type        = number
}