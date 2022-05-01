terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    storage_account_name = "ahockerstentfstorage"
    container_name       = "tf-state"
    key                  = "terraform.tfstate"
    subscription_id      = "673d5161-7521-43bd-b861-1838d3b62eb9"
    tenant_id            = "8fbc5cea-2448-4779-a0e9-31d74029e14d"
    resource_group_name  = "rg-ahockersten-default"
  }
}

provider "azurerm" {
  features {}
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
