resource "azurerm_firewall_policy" "fw_hub_policy" {
  name                = "daniel-dev-fw-hub-policy"
  resource_group_name = data.azurerm_resource_group.hub.name
  location            = var.location
  sku                 = "Standard"

  dns {
    proxy_enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }
}
