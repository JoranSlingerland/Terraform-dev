# variables
variable "region" {
  type    = string
  default = "westeurope"
}
variable "resource_groups" {
  type = map(any)
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

variable "tags" {
  type = map(string)
  default = {
    "Environment"     = "Production"
    "deployment_type" = "terraform"
  }
}
