resource "azurerm_firewall_policy_rule_collection_group" "egress" {
  name               = "egress-allow"
  firewall_policy_id = azurerm_firewall_policy.fw_hub_policy.id

  priority = 100

  # -------------------------
  # Network Rules (DNS + NTP)
  # -------------------------
  network_rule_collection {
    name     = "net-allow-dns-ntp"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "allow-dns"
      protocols             = ["UDP", "TCP"]
      source_addresses      = ["10.10.1.0/24"]
      destination_addresses = ["*"]
      destination_ports     = ["53"]
    }

    rule {
      name                  = "allow-ntp"
      protocols             = ["UDP"]
      source_addresses      = ["10.10.1.0/24"]
      destination_addresses = ["*"]
      destination_ports     = ["123"]
    }
  }

  # -------------------------
  # Network Rules (HTTP/S)
  # -------------------------
  network_rule_collection {
    name     = "net-allow-web"
    priority = 110
    action   = "Allow"

    rule {
      name                  = "allow-http-https"
      protocols             = ["TCP"]
      source_addresses      = ["10.10.1.0/24"]
      destination_addresses = ["*"]
      destination_ports     = ["80", "443"]
    }
  }


  # -------------------------
  # Application Rules (HTTP/S)
  # -------------------------
  application_rule_collection {
    name     = "app-allow-web"
    priority = 200
    action   = "Allow"

    rule {
      name             = "allow-ubuntu-and-ms"
      source_addresses = ["10.10.1.0/24"]

      protocols {
        type = "Http"
        port = 80
      }

      protocols {
        type = "Https"
        port = 443
      }

      destination_fqdns = [
        "azure.archive.ubuntu.com",
        "archive.ubuntu.com",
        "security.ubuntu.com",
        "packages.microsoft.com",
        "login.microsoftonline.com",
        "management.azure.com"
      ]
    }

    # TEMP DEBUG RULE (use only if still blocked)
    # If this works, your issue is just missing FQDNs.
    #
    # rule {
    #   name             = "TEMP-allow-all-web"
    #   source_addresses = ["10.10.1.0/24"]
    #
    #   protocols { type = "Http"  port = 80 }
    #   protocols { type = "Https" port = 443 }
    #
    #   destination_fqdns = ["*"]
    # }
  }
}
