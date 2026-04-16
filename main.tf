terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}
provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-user14" #change here
    storage_account_name = "stsuser14" #change here
    container_name       = "tfstate"
    key                  = "globalazure.tfstate"
  }
}
