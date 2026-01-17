variable "vnet_name" {
  description = "Virtual network name"
  type        = string
}

variable "address_space" {
  description = "VNet address space"
  type        = list(string)
}

variable "app_subnet_prefix" {
  description = "Application subnet address prefix"
  type        = string
}

variable "appgw_subnet_prefix" {
  description = "Application Gateway subnet address prefix"
  type        = string
}
variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

