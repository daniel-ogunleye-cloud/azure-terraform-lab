resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = local.tags
}

module "hub_vnet" {
  source              = "../modules/vnet"
  name                = local.hub_vnet_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = var.hub_address_space
  tags                = local.tags
}

module "hub_subnets" {
  source              = "../modules/subnets"
  resource_group_name = azurerm_resource_group.rg.name
  vnet_name           = module.hub_vnet.name

  subnets = {
    "AzureFirewallSubnet" = { cidr = var.hub_subnet_firewall }
    "AzureBastionSubnet"  = { cidr = var.hub_subnet_bastion }
    "GatewaySubnet"       = { cidr = var.hub_subnet_gateway }
    "shared"              = { cidr = var.hub_subnet_shared }
  }

  tags = local.tags
}

module "spoke_app_vnet" {
  source              = "../modules/vnet"
  name                = local.spoke_app_vnet_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = var.spoke_app_address_space
  tags                = local.tags
}

module "spoke_subnets" {
  source              = "../modules/subnets"
  resource_group_name = azurerm_resource_group.rg.name
  vnet_name           = module.spoke_app_vnet.name

  subnets = {
    "app"               = { cidr = var.spoke_subnet_app }
    "private-endpoints" = { cidr = var.spoke_subnet_private_endpoints }
    "mgmt"              = { cidr = var.spoke_subnet_mgmt }
  }

  tags = local.tags
}

module "nsg_spoke_app" {
  source              = "../modules/nsg"
  name                = "${local.name_prefix}-nsg-spoke-app"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags

  rules = [
    {
      name                       = "AllowVNetInBound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
      description                = "Allow inbound from within VNet"
    },
    {
      name                       = "DenyInternetInBound"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
      description                = "Block inbound from Internet"
    }
  ]
}

module "nsg_spoke_private_endpoints" {
  source              = "../modules/nsg"
  name                = "${local.name_prefix}-nsg-spoke-private-endpoints"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags

  rules = [
    {
      name                       = "AllowVNetInBound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
      description                = "Allow inbound from within VNet"
    },
    {
      name                       = "DenyInternetInBound"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
      description                = "Block inbound from Internet"
    }
  ]
}

module "nsg_spoke_mgmt" {
  source              = "../modules/nsg"
  name                = "${local.name_prefix}-nsg-spoke-mgmt"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags

  rules = [
    {
      name                       = "AllowVNetInBound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
      description                = "Allow inbound from within VNet"
    },
    {
      name                       = "DenyInternetInBound"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
      description                = "Block inbound from Internet"
    }
  ]
}

# Associate NSGs to subnets
resource "azurerm_subnet_network_security_group_association" "spoke_app" {
  subnet_id                 = module.spoke_subnets.subnet_ids["app"]
  network_security_group_id = module.nsg_spoke_app.id
}

resource "azurerm_subnet_network_security_group_association" "spoke_private_endpoints" {
  subnet_id                 = module.spoke_subnets.subnet_ids["private-endpoints"]
  network_security_group_id = module.nsg_spoke_private_endpoints.id
}

resource "azurerm_subnet_network_security_group_association" "spoke_mgmt" {
  subnet_id                 = module.spoke_subnets.subnet_ids["mgmt"]
  network_security_group_id = module.nsg_spoke_mgmt.id
}


module "hub_spoke_peering" {
  source = "../modules/peering"

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
