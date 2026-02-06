variable "firewall_private_ip" {
  default = "10.0.0.4"
}

variable "spoke_rg_name" {
  default = "daniel-dev-rg-network"
}

variable "spoke_vnet_name" {
  default = "daniel-dev-vnet-spoke"
}

variable "spoke_subnet_name" {
  default = "app"
}
