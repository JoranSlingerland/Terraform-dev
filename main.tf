terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
    backend "azurerm" {
        resource_group_name  = "tfstate"
        storage_account_name = "tfstate908957484"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }

}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-mgmt-pord-westeu-001-tf" {
  name     = "rg-mgmt-pord-westeu-001-tf"
  location = "westeurope"
  tags = {
    "env" = "prod"
  }
}