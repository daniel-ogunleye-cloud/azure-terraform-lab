locals {
  name_prefix = "${var.project}-${var.env}"

  rg_name             = "${local.name_prefix}-rg-network"
  hub_vnet_name       = "${local.name_prefix}-vnet-hub"
  spoke_app_vnet_name = "${local.name_prefix}-vnet-spoke-app"

  tags = merge({
    project     = var.project
    environment = var.env
    managed_by  = "terraform"
    stack       = "network-core"
  }, var.tags)
}
