output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "app_subnet_id" {
  value = azurerm_subnet.app.id
}

output "appgw_subnet_id" {
  value = azurerm_subnet.appgw.id
}
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
