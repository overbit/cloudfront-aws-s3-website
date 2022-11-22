locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Application = var.app_name
    Environment = var.environment
    IaC         = "Terraform"
  }

  domain_name = "${var.app_name}.${var.environment}.${var.parent_domain_name}"
}
