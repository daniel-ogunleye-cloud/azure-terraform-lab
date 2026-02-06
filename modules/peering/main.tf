resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "${var.hub.name}-to-${var.spoke.name}"
  resource_group_name       = var.hub.resource_group_name
  virtual_network_name      = var.hub.name
  remote_virtual_network_id = var.spoke.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.allow_gateway_transit
  use_remote_gateways          = var.use_remote_gateways
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "${var.spoke.name}-to-${var.hub.name}"
  resource_group_name       = var.spoke.resource_group_name
  virtual_network_name      = var.spoke.name
  remote_virtual_network_id = var.hub.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = false
  use_remote_gateways          = var.use_remote_gateways
}
