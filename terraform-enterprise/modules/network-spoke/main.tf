data "azurerm_resource_group" "spoke" {
  name = var.spoke_rg_name
}

data "azurerm_virtual_network" "spoke" {
  name                = "daniel-dev-vnet-spoke-app"
  resource_group_name = "daniel-dev-rg-network"
}

data "azurerm_subnet" "app" {
  name                 = "app"
  virtual_network_name = data.azurerm_virtual_network.spoke.name
  resource_group_name  = "daniel-dev-rg-network"
}


resource "azurerm_route_table" "spoke_rt" {
  name                = "daniel-dev-spoke-fw-rt"
  location            = data.azurerm_resource_group.spoke.location
  resource_group_name = data.azurerm_resource_group.spoke.name

 bgp_route_propagation_enabled = true

}

resource "azurerm_route" "default_to_firewall" {
  name                   = "default-to-firewall"
  resource_group_name    = data.azurerm_resource_group.spoke.name
  route_table_name       = azurerm_route_table.spoke_rt.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip
}

resource "azurerm_subnet_route_table_association" "app_assoc" {
  subnet_id      = data.azurerm_subnet.app.id
  route_table_id = azurerm_route_table.spoke_rt.id
}
data "terraform_remote_state" "security" {
  backend = "local"

  config = {
    path = "../security-core/terraform.tfstate"
  }
}
output "fw_private_ip_test" {
  value = data.terraform_remote_state.security.outputs.firewall_private_ip
}

