terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.114.0"
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

locals {
  tags = {
    "terraform" = "true"
  }
  rg_name = "rg-user14"
  rg_location = "polandcentral"
}

module "keyvault" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=keyvault/v1.0.0"
  keyvault_name = "user14gakv001"
  resource_group = {
    name = local.rg_name
    location = local.rg_location
  }
  network_acls = {
    bypass = "AzureServices"
    default_action = "Deny"
  }
  tags = local.tags
}

module "service_plan" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=service_plan/v2.0.0"
  app_service_plan_name = "user14spga01"
  resource_group = {
    name = local.rg_name
    location = local.rg_location
  }
  sku_name = "B1"
  tags = local.tags
}

module "app_service" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=app_service/v1.0.0"
  app_service_name = "user14spsdb34"
  app_service_plan_id = module.service_plan.app_service_plan.id
  app_settings = {}
  identity_client_id = "df693838-cb34-4e3f-9aae-d4c61c363cff"
  identity_id = "/subscriptions/4c569ea4-8bfc-4063-9557-390e4b28a153/resourceGroups/rg-user14/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-user14-actions"
  resource_group = {
    name = local.rg_name
    location = local.rg_location
  }
  
}
