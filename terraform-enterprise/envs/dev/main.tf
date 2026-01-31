module "network_core" {
  source = "../../../stacks/network-core"
  # ... your variables
}

module "network_spoke" {
  source = "../../../stacks/network-spoke"
  # ... your variables
}

module "security_core" {
  source = "../../../stacks/security-core"
  # ... your variables
}
