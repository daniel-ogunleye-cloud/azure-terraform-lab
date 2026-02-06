data "terraform_remote_state" "network" {
  backend = "remote"

  config = {
    organization = "daniel-ogunleye-cloud"
    workspaces = {
      name = "network-core"
    }
  }
}


# Compute RG (separate from network RG)
resource "azurerm_resource_group" "compute" {
  name     = local.rg_compute
  location = var.location
}

# NIC in spoke app subnet (NO public IP)
resource "azurerm_network_interface" "vm_nic" {
  name                = local.nic_name
  location            = var.location
  resource_group_name = azurerm_resource_group.compute.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = data.terraform_remote_state.network.outputs.spoke_subnet_ids["app"]
    private_ip_address_allocation = "Dynamic"
  }
}

# Ubuntu 22.04 VM (private only)
resource "azurerm_linux_virtual_machine" "vm" {
  name                = local.vm_name
  location            = var.location
  resource_group_name = azurerm_resource_group.compute.name
  size                = var.vm_size

  admin_username = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id
  ]

  disable_password_authentication = true

  admin_ssh_key {
  username   = var.admin_username
  public_key = var.ssh_public_key
}


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

# Bastion in HUB (uses AzureBastionSubnet) + Public IP
resource "azurerm_public_ip" "bastion" {
  name                = local.bastion_pip
  location            = var.location
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = local.bastion_name
  location            = var.location
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = data.terraform_remote_state.network.outputs.hub_subnet_ids["AzureBastionSubnet"]
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}
