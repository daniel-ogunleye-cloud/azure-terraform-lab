module "network_core" {
  source = "./stacks/network-core"
  subscription_id = var.subscription_id
}


module "network_spoke" {
  source = "./stacks/network-spoke"
  # ...
}

module "security_core" {
  source = "./stacks/security-core"
  # ...
}
