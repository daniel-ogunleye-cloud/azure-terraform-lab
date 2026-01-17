variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "centralus"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "project21"
}

