output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "hub_vnet_id" {
  value = module.hub_vnet.id
}

output "hub_subnet_ids" {
  value = module.hub_subnets.subnet_ids
}

output "spoke_app_vnet_id" {
  value = module.spoke_app_vnet.id
}

output "spoke_subnet_ids" {
  value = module.spoke_subnets.subnet_ids
}
