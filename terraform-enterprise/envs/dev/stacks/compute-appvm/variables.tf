variable "subscription_id" { type = string }

variable "project" {
  type    = string
  default = "daniel"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "location" {
  type    = string
  default = "canadacentral"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key" {
  type = string
}

variable "vm_size" {
  type    = string
  default = "Standard_D2s_v3"
}
