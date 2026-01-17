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

variable "vmss_sku" {
  type    = string
  default = "Standard_D2s_v3"
}

# For load balancer naming
variable "lb_name" {
  type    = string
  default = "lb-web"
}
