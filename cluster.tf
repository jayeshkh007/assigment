
data "aws_region" "this" {}

resource "aws_cloudwatch_log_group" "main" {
  name = var.cluster_name

  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.logs_kms_key

}

locals {
  default_capacity_provider_formatted = var.default_capacity_provider != "" ? [var.default_capacity_provider] : []
}

resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  capacity_providers = local.default_capacity_provider_formatted

  dynamic "default_capacity_provider_strategy" {
   iterator = capacity_provider
   for_each = local.default_capacity_provider_formatted
   content{
    capacity_provider = capacity_provider.value
   }
  }
}