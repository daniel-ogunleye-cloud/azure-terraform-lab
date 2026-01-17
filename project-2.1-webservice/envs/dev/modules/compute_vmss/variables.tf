variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vmss_name" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "admin_username" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "vmss_sku" {
  type    = string
}

variable "lb_backend_pool_id" {
  type = string
}

variable "cloud_init_path" {
  type = string
}
variable "custom_data" {
  type        = string
  default     = null
  description = "Base64-encoded cloud-init"
}
