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

# variables
variable "resource_group_name" {
  type =  list
  default =  [
      {
        "name" = "rg-mgmt-prod-westeu-001-tf"
      },
      {
        "name" = "rg-network-prod-westeu-tf"
      }
  ]
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg000" {
  name = var.resource_group_name[0].name
  location = "westeurope"
  tags = {
    "env" = "prod"
  }
}

resource "azurerm_resource_group" "rg001" {
  name = var.resource_group_name[1].name
  location = "westeurope"
  tags = {
    "env" = "prod"
  }
}