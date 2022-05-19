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

resource "azurerm_virtual_network" "hub_vnets" {
  for_each            = var.hub_vnets
  name                = each.value["name"]
  location            = var.region
  resource_group_name = var.resource_groups.network["name"]
  address_space       = each.value["address_space"]
  tags                = var.tags
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_virtual_network" "spoke_vnets" {
  for_each            = var.spoke_vnets
  name                = each.value["name"]
  location            = var.region
  resource_group_name = var.resource_groups.network["name"]
  address_space       = each.value["address_space"]
  tags                = var.tags
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnet
  name                 = each.value["name"]
  resource_group_name  = var.resource_groups.network["name"]
  virtual_network_name = each.value["vnet"]
  address_prefixes     = each.value["address_prefixes"]
  depends_on           = [azurerm_virtual_network.spoke_vnets, azurerm_virtual_network.hub_vnets]
}


resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  for_each                  = var.spoke_vnets
  name                      = "PeeringTo${each.value.name}"
  resource_group_name       = var.resource_groups.network["name"]
  virtual_network_name      = var.hub_vnets.hub_vnet_1.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_vnets[each.value.reference_name].id
  depends_on = [
    azurerm_virtual_network.spoke_vnets, azurerm_virtual_network.hub_vnets
  ]
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  for_each                  = var.spoke_vnets
  name                      = "PeeringTo${var.hub_vnets["hub_vnet_1"].name}"
  resource_group_name       = var.resource_groups.network["name"]
  virtual_network_name      = each.value.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnets["hub_vnet_1"].id
  depends_on = [
    azurerm_virtual_network.spoke_vnets, azurerm_virtual_network.hub_vnets
  ]
}
