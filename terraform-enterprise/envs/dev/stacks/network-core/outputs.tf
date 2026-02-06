output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "hub_vnet_id" {
  value = module.network_hub.hub_vnet_id
}

output "hub_subnet_ids" {
  value = module.network_hub.hub_subnet_ids
}

output "spoke_app_vnet_id" {
  value = module.network_hub.spoke_app_vnet_id
}

output "spoke_subnet_ids" {
  value = module.network_hub.spoke_subnet_ids
}
