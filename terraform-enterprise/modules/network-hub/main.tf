resource "azurerm_resource_group" "rg" {
  name     = "${var.project}-${var.env}-rg-network"
  location = var.location
  tags     = var.tags
}

############################
# HUB VNET
############################
module "hub_vnet" {
  source = "../../../modules/vnet"

  name                = "${var.project}-${var.env}-vnet-hub"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = var.hub_address_space
  tags                = var.tags
}

############################
# HUB SUBNETS
############################
module "hub_subnets" {
  source = "../../../modules/subnets"

  resource_group_name = azurerm_resource_group.rg.name
  vnet_name           = module.hub_vnet.name

  subnets = {
    AzureFirewallSubnet = { cidr = var.hub_subnet_firewall }
    AzureBastionSubnet  = { cidr = var.hub_subnet_bastion }
    GatewaySubnet       = { cidr = var.hub_subnet_gateway }
    shared              = { cidr = var.hub_subnet_shared }
  }

  tags = var.tags
}

############################
# SPOKE VNET
############################
module "spoke_app_vnet" {
  source = "../../../modules/vnet"

  name                = "${var.project}-${var.env}-vnet-spoke-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = var.spoke_app_address_space
  tags                = var.tags
}

############################
# SPOKE SUBNETS
############################
module "spoke_subnets" {
  source = "../../../modules/subnets"

  resource_group_name = azurerm_resource_group.rg.name
  vnet_name           = module.spoke_app_vnet.name

  subnets = {
    app               = { cidr = var.spoke_subnet_app }
    private-endpoints = { cidr = var.spoke_subnet_private_endpoints }
    mgmt              = { cidr = var.spoke_subnet_mgmt }
  }

  tags = var.tags
}

############################
# NSGs
############################
module "nsg_spoke_app" {
  source = "../../../modules/nsg"

  name                = "${var.project}-${var.env}-nsg-spoke-app"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

module "nsg_spoke_private_endpoints" {
  source = "../../../modules/nsg"

  name                = "${var.project}-${var.env}-nsg-spoke-pe"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

module "nsg_spoke_mgmt" {
  source = "../../../modules/nsg"

  name                = "${var.project}-${var.env}-nsg-spoke-mgmt"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

############################
# HUB ↔ SPOKE PEERING
############################
module "hub_spoke_peering" {
  source = "../../../modules/peering"

  hub = {
    name                = module.hub_vnet.name
    id                  = module.hub_vnet.id
    resource_group_name = azurerm_resource_group.rg.name
  }

  spoke = {
    name                = module.spoke_app_vnet.name
    id                  = module.spoke_app_vnet.id
    resource_group_name = azurerm_resource_group.rg.name
  }

  allow_forwarded_traffic = true
  allow_gateway_transit   = false
  use_remote_gateways     = false
}
