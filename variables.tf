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

variable "hub_vnets" {
  type = map(any)
  default = {
    hub_vnet_1 = {
      name          = "vnet-hub-prod-westeu-001-tf"
      address_space = ["10.0.0.0/16"]
    }

  }
}

variable "spoke_vnets" {
  type = map(any)
  default = {
    spoke_vnet_1 = {
      name           = "vnet-spoke-prod-westeu-001-tf"
      address_space  = ["10.1.0.0/16"]
      reference_name = "spoke_vnet_1"
    }
    spoke_vnet_2 = {
      name           = "vnet-spoke-prod-westeu-002-tf"
      address_space  = ["10.2.0.0/16"]
      reference_name = "spoke_vnet_2"
    }

  }
}

variable "subnet" {
  description = "Map of Azure VNET subnet configuration"
  type        = map(any)
  default = {
    app_subnet = {
      name             = "subnet1"
      address_prefixes = ["10.1.0.0/24"]
      vnet             = "vnet-spoke-prod-westeu-001-tf"
    },
    db_subnet = {
      name             = "subnet2"
      address_prefixes = ["10.2.0.0/24"]
      vnet             = "vnet-spoke-prod-westeu-002-tf"
    }
    app_subnet = {
      name             = "subnet3"
      address_prefixes = ["10.0.0.0/24"]
      vnet             = "vnet-hub-prod-westeu-001-tf"
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
