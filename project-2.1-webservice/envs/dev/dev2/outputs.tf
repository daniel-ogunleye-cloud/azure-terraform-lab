output "lb_public_ip" {
  value = module.loadbalancer.public_ip_address
}

output "lb_backend_pool_id" {
  value = module.loadbalancer.backend_pool_id
}
output "subnet_id" {
  value = module.network.app_subnet_id
}
