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

# resources

resource "azurerm_resource_group" "rg" {
  for_each = var.resource_groups
  name     = each.value["name"]
  location = var.region
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet.shared_vnet.name
  location            = var.region
  resource_group_name = var.resource_groups.network["name"]
  address_space       = var.vnet.shared_vnet.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnet
  name                 = each.value["name"]
  resource_group_name  = var.resource_groups.network["name"]
  virtual_network_name = var.vnet.shared_vnet.name
  address_prefixes     = each.value["address_prefixes"]
  depends_on           = [azurerm_virtual_network.vnet]
}