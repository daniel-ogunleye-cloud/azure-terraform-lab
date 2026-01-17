resource "azurerm_subnet" "app" {
  name                 = "app-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.app_subnet_prefix]
}

resource "azurerm_subnet" "appgw" {
  name                 = "appgw-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.appgw_subnet_prefix]
}
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

# -----------------------------
# NSGs
# -----------------------------
resource "azurerm_network_security_group" "app_nsg" {
  name                = "nsg-app-${var.vnet_name}"
  location            = var.location
resource_group_name         = var.resource_group_name
}

  resource "azurerm_network_security_rule" "allow_lb_8080" {
  name                        = "allow-lb-8080"
  priority                    = 121
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"

  source_port_range           = "*"
  destination_port_range      = "8080"

  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.app_nsg.name
}

resource "azurerm_network_security_group" "appgw_nsg" {
  name                = "nsg-appgw-${var.vnet_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# -----------------------------
# NSG Rules
# -----------------------------

# Allow HTTP from App Gateway subnet -> App subnet
resource "azurerm_network_security_rule" "app_allow_http_from_appgw" {
  name                        = "allow-http-from-appgw"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = var.appgw_subnet_prefix
  destination_address_prefix  = var.app_subnet_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.app_nsg.name
}

# Allow HTTPS from App Gateway subnet -> App subnet (future-proof)
resource "azurerm_network_security_rule" "app_allow_https_from_appgw" {
  name                        = "allow-https-from-appgw"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = var.appgw_subnet_prefix
  destination_address_prefix  = var.app_subnet_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.app_nsg.name
}

# Allow inbound HTTP to App Gateway from Internet
resource "azurerm_network_security_rule" "appgw_allow_http_internet" {
  name                        = "allow-http-internet"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.appgw_nsg.name
}

# Allow inbound HTTPS to App Gateway from Internet (we’ll enable later)
resource "azurerm_network_security_rule" "appgw_allow_https_internet" {
  name                        = "allow-https-internet"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.appgw_nsg.name
}

# -----------------------------
# Associate NSGs to subnets
# -----------------------------
resource "azurerm_subnet_network_security_group_association" "app_assoc" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id

  depends_on = [
    azurerm_subnet.app,
    azurerm_network_security_group.app_nsg
  ]
}

resource "azurerm_subnet_network_security_group_association" "appgw_assoc" {
  subnet_id                 = azurerm_subnet.appgw.id
  network_security_group_id = azurerm_network_security_group.appgw_nsg.id

  depends_on = [
    azurerm_subnet.appgw,
    azurerm_network_security_group.appgw_nsg
  ]
}
