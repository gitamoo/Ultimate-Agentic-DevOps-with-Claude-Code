variable "region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "portfolio-site"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "domain_name" {
  description = "Custom domain name for the website (optional)"
  type        = string
  default     = ""
}
