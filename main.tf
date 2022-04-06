terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
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

# variables
variable "region" {
  type    = string
  default = "westeurope"
}
variable "resource_group_name" {
  type = list(any)
  default = [
    {
      "name" = "rg-mgmt-prod-westeu-001-tf"
    },
    {
      "name" = "rg-network-prod-westeu-tf"
    }
  ]
}

variable "vnet" {
  type = map(any)
  default = {
    shared_vnet = {
      name          = "vnet-shared-prod-westeu-001-tf"
      address_space = ["10.0.0.0/16"]
    }

  }
}

variable "subnet" {
  description = "Map of Azure VNET subnet configuration"
  type        = map(any)
  default = {
    app_subnet = {
      name             = "app_subnet"
      address_prefixes = ["10.0.1.0/24"]
    },
    db_subnet = {
      name             = "db_subnet"
      address_prefixes = ["10.0.2.0/24"]
    }
  }
}


# resources
resource "azurerm_resource_group" "rg000" {
  name     = var.resource_group_name[0].name
  location = var.region
  tags = {
    "env" = "prod"
  }
}

resource "azurerm_resource_group" "rg001" {
  name     = var.resource_group_name[1].name
  location = var.region
  tags = {
    "env" = "prod"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet.shared_vnet.name
  location            = var.region
  resource_group_name = var.resource_group_name[1].name
  address_space       = var.vnet.shared_vnet.address_space
  tags                = azurerm_resource_group.rg000.tags
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnet
  name                 = each.value["name"]
  resource_group_name  = var.resource_group_name[1].name
  virtual_network_name = var.vnet.shared_vnet.name
  address_prefixes     = each.value["address_prefixes"]
  depends_on           = [azurerm_virtual_network.vnet]
}