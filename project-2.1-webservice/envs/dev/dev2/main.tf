############################################
# Project 2.1 – Root Module (dev2)
############################################

resource "azurerm_resource_group" "rg" {
  name     = "rg-project21-dev2"
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
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  subnet_id           = module.network.app_subnet_id

  vmss_name      = "vmss-${var.project_name}-${var.environment}"
  instance_count = 2
  vmss_sku       = "Standard_D2s_v3"
  admin_username = "azureuser"
  ssh_public_key = file("C:/Users/Danie/.ssh/id_rsa.pub")
  custom_data    = base64encode(file("${path.module}/cloud-init-nginx-8080.yaml"))


  lb_backend_pool_id = module.loadbalancer.backend_pool_id
  cloud_init_path    = "${path.module}/cloud-init.yml"

  depends_on = [module.loadbalancer]
}


module "loadbalancer" {
  source              = "../modules/loadbalancer"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  project_name        = var.project_name
  environment         = var.environment

}

