resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = local.tags
}

module "network_hub" {
  source = "../../../modules/network-hub"

  project         = var.project
  env             = var.env
  location        = var.location
  tags            = local.tags
  subscription_id = var.subscription_id

  hub_address_space           = var.hub_address_space
  spoke_app_address_space     = var.spoke_app_address_space

  hub_subnet_firewall = var.hub_subnet_firewall
  hub_subnet_bastion  = var.hub_subnet_bastion
  hub_subnet_gateway  = var.hub_subnet_gateway
  hub_subnet_shared   = var.hub_subnet_shared

  spoke_subnet_app               = var.spoke_subnet_app
  spoke_subnet_private_endpoints = var.spoke_subnet_private_endpoints
  spoke_subnet_mgmt              = var.spoke_subnet_mgmt
}
