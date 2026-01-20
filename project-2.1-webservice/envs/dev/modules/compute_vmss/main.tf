locals {
  custom_data = base64encode(file("${path.module}/cloud-init.yaml"))
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = var.vmss_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku       = var.vmss_sku
  instances = var.instance_count
  health_probe_id = var.lb_probe_id



  admin_username                  = var.admin_username
  disable_password_authentication = true
  custom_data                     = var.custom_data

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  network_interface {
    name    = "${var.vmss_name}-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnet_id

      load_balancer_backend_address_pool_ids = [
      var.lb_backend_pool_id
    ]
    }
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  upgrade_mode = "Manual"
}

resource "azurerm_monitor_autoscale_setting" "vmss_cpu" {
  name                = "${var.vmss_name}-autoscale-cpu"
  resource_group_name = var.resource_group_name
  location            = var.location

  target_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
  enabled            = true

  profile {
    name = "cpu-autoscale-default"

    capacity {
      minimum = tostring(var.autoscale_min)
      default = tostring(var.autoscale_default)
      maximum = tostring(var.autoscale_max)
    }

    # Scale OUT
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"

        time_grain       = "PT1M"
        statistic        = "Average"
        time_window      = "PT5M"
        time_aggregation = "Average"
        operator         = "GreaterThan"
        threshold        = var.scale_out_cpu_threshold
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    # Scale IN
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"

        time_grain       = "PT1M"
        statistic        = "Average"
        time_window      = "PT10M"
        time_aggregation = "Average"
        operator         = "LessThan"
        threshold        = var.scale_in_cpu_threshold
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT10M"
      }
    }
  }
}
