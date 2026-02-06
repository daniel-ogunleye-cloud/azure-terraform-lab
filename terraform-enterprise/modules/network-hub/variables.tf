variable "project" {
  type        = string
  description = "Project or org identifier used in naming."
  default     = "lab"
}

variable "env" {
  type        = string
  description = "Environment name (dev/test/prod)."
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.env)
    error_message = "env must be one of: dev, test, prod."
  }
}

variable "location" {
  type        = string
  description = "Azure region, e.g. canadacentral."
  default     = "canadacentral"
}

variable "hub_address_space" {
  type        = list(string)
  description = "Hub VNet CIDR(s)."
  default     = ["10.0.0.0/16"]
}

variable "spoke_app_address_space" {
  type        = list(string)
  description = "App spoke VNet CIDR(s)."
  default     = ["10.10.0.0/16"]
}

# Reserve hub subnet ranges now (even if you deploy services later)
variable "hub_subnet_firewall" {
  type    = string
  default = "10.0.0.0/24"
}

variable "hub_subnet_bastion" {
  type    = string
  default = "10.0.1.0/26"
}

variable "hub_subnet_gateway" {
  type    = string
  default = "10.0.2.0/27"
}

variable "hub_subnet_shared" {
  type    = string
  default = "10.0.3.0/24"
}

variable "tags" {
  type        = map(string)
  description = "Extra tags to apply to all resources."
  default     = {}
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "spoke_subnet_app" {
  type    = string
  default = "10.10.1.0/24"
}

variable "spoke_subnet_private_endpoints" {
  type    = string
  default = "10.10.2.0/24"
}

variable "spoke_subnet_mgmt" {
  type    = string
  default = "10.10.3.0/24"
}
