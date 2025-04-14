#####################
### Prerequisites ###
#####################

provider "azurerm" {
  features {}
}

# Manages a Resource Group.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
#
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "Canada Central"
}

# Manages a virtual network including any configured subnets.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
#
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Manages a subnet.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
#
resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_private_dns_zone" "blob_storage" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.example.name
}

# Manages a User Assigned Identity.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity
#
resource "azurerm_user_assigned_identity" "bill_of_landing" {
  name                = "${module.azure_resource_names.managed_identity_name}-bill-of-landing"
  resource_group_name = azurerm_resource_group.platform.name
  location            = var.azure_resource_attributes.location
  tags                = {}
}

##########################################
### Platform Infrastructure Module #######
##########################################

# Deploys Azure resources for the in-cluster platform components.
#
# https://github.com/gccloudone-aurora-iac/terraform-aurora-azure-environment-platform-infrastructure
#
module "platform_infrastructure" {
  source = "../"

  naming_convention = "gc"
  user_defined      = "example"

  azure_resource_attributes = {
    department_code = "Gc"
    owner           = "ABC"
    project         = "aur"
    environment     = "dev"
    location        = azurerm_resource_group.example.location
    instance        = 0
  }

  cluster_node_resource_group_id = azurerm_resource_group.example.id
  cluster_identity_object_id     = "2e1abffc-60c6-4bbe-9e3c-e051fde82af5"

  grafana_sso_sp = {}

  networking_ids = {
    dns_zones = {
      cert_manager = "/subscriptions/99999999-9999-9999-9999-999999999999/resourceGroups/example-dns-rg/providers/Microsoft.Network/dnszones/example.ca"
      blob_storage = azurerm_private_dns_zone.blob_storage.id
    }
    subnets = {
      infrastructure = azurerm_subnet.example.id
    }
  }

  # platform resources
  bill_of_landing_managed_identity_id = azurerm_user_assigned_identity.bill_of_landing.id

  tags = {
    "tier" = "k8s"
  }
}
