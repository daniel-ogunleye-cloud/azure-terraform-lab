terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-dev"
    storage_account_name = "sttfstatelabphase2"
    container_name       = "tfstate"
    key                  = "project-2-1-dev.tfstate"
  }
}
