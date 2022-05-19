# variables
variable "region" {
  type    = string
  default = "westeurope"
}
variable "resource_groups" {
  type = map(string)
  default = {
    network = {
      name = "rg-network-prod-westeu-001-tf"
    }
    mgmt = {
      name = "rg-mgmt-prod-westeu-001-tf"
    }
  }
}

variable "vnet" {
  type = map(any)
  default = {
    shared_vnet_1 = {
      name          = "vnet-shared-prod-westeu-001-tf"
      address_space = ["10.0.0.0/16"]
    }
    shared_vnet_2 = {
      name          = "vnet-shared-prod-westeu-002-tf"
      address_space = ["10.1.0.0/16"]
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
      vnet             = "vnet-shared-prod-westeu-001-tf"
    },
    db_subnet = {
      name             = "db_subnet"
      address_prefixes = ["10.0.2.0/24"]
      vnet             = "vnet-shared-prod-westeu-001-tf"
    }
    app_subnet = {
      name             = "app_subnet"
      address_prefixes = ["10.1.1.0/24"]
      vnet             = "vnet-shared-prod-westeu-002-tf"
    },
  }
}

variable "tags" {
  type = map(string)
  default = {
    "Environment"     = "Production"
    "deployment_type" = "terraform"
  }
}
