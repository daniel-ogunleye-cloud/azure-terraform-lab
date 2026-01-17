############################################
# Project 2.1 – Root Module (dev)
############################################

resource "azurerm_resource_group" "rg" {
  name     = "rg-project21-dev"
  location = var.location

  tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }
}

module "network" {
  source              = "../modules/network"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  vnet_name           = "vnet-${var.project_name}-${var.environment}"
  address_space       = ["10.20.0.0/16"]
  app_subnet_prefix   = "10.20.1.0/24"
  appgw_subnet_prefix = "10.20.2.0/24"
}
module "compute_vmss" {
  source              = "../modules/compute_vmss"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.network.app_subnet_id

  vmss_name      = "vmss-${var.project_name}-${var.environment}"
  instance_count = 2

  admin_username = "azureuser"
  ssh_public_key = file("~/.ssh/id_rsa.pub")
  depends_on = [
  module.network
]

}


