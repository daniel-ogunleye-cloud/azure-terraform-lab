locals {
  name_prefix = "${var.project}-${var.env}"

  rg_compute = "${local.name_prefix}-rg-compute"

  vm_name  = "${local.name_prefix}-vm-app01"
  nic_name = "${local.name_prefix}-nic-app01"

  bastion_name = "${local.name_prefix}-bastion"
  bastion_pip  = "${local.name_prefix}-pip-bastion"
}
