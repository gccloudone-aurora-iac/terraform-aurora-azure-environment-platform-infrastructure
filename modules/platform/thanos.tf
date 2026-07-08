############
## THANOS ##
############


# Create a storage account
module "thanos_storage_account" {
  source = "git::https://github.com/gccloudone-aurora-iac/terraform-azure-storage-account.git?ref=v2.0.1"

  azure_resource_attributes = var.azure_resource_attributes
  naming_convention         = var.naming_convention
  user_defined              = "THAN"

  resource_group_name = azurerm_resource_group.platform.name

  public_network_access_enabled = false
  private_endpoints = [
    {
      sub_resource_name   = "blob"
      subnet_id           = var.infrastructure_subnet_id
      private_dns_zone_id = var.dns_zone_ids.blob_storage
    }
  ]

  network_rules {
    default_action             = "Deny"
  }

  account_replication_type = "ZRS"
  containers               = [local.thanos_sa_container_name]
  tags                     = var.tags
}

# Creates a user assigned identity (managed identity)
# UAMI - Thanos Side Car Authenticates Using This
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity
resource "azurerm_user_assigned_identity" "thanos-id" {
  location            = azurerm_resource_group.platform.location
  name                = "${module.azure_resource_names.managed_identity_name}-thanos"
  resource_group_name = azurerm_resource_group.platform.name
}

# Create a trust and binds to the above UAMI to allow service account k8 tokens to use this identity
# Match on subject is required
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential
resource "azurerm_federated_identity_credential" "thanos-fed-id" {
  name                = "${module.azure_resource_names.managed_identity_name}-fed-thanos"
  audience = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:prometheus-system:kube-prometheus-stack-prometheus"
  parent_id           = azurerm_user_assigned_identity.thanos-id.id
  resource_group_name = azurerm_resource_group.platform.name
}

# Role authorization
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "thanos_blob" {
  scope                = module.thanos_storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.thanos-id.principal_id
}


# Thanos Compactor and Store-Gateway federated ID

# Create a trust and binds to the above UAMI to federate for the thanos compactor
# Match on subject is required
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential
resource "azurerm_federated_identity_credential" "thanos-compactor-fed-id" {
  name                = "${module.azure_resource_names.managed_identity_name}-fed-thanos-compactor"
  audience = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:thanos-system:thanos-compactor-default"
  parent_id           = azurerm_user_assigned_identity.thanos-id.id
  resource_group_name = azurerm_resource_group.platform.name
}


# Create a trust and binds to the above UAMI to federate for the thanos store gateway
# Match on subject is required
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential
resource "azurerm_federated_identity_credential" "thanos-storegateway-fed-id" {
  name                = "${module.azure_resource_names.managed_identity_name}-fed-thanos-storegateway"
  audience = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:thanos-system:thanos-storegateway-default"
  parent_id           = azurerm_user_assigned_identity.thanos-id.id
  resource_group_name = azurerm_resource_group.platform.name
}