variable "environment" {
  description = "Environment or stage to which we're deploying: dev/test/staging/preprod/prod"
  type        = string
}
variable "app_name" {
  description = "Name of the application"
  type        = string
}
variable "parent_domain_name" {
  description = "Domain name of the application. i.e. mydomain.com"
  type        = string
}

