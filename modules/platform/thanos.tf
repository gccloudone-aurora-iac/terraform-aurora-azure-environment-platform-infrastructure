############
## THANOS ##
############


# Create a storage account
module "thanos_storage_account" {
  source = "git::https://github.com/gccloudone-aurora-iac/terraform-azure-storage-account.git?ref=v2.0.1"

  azure_resource_attributes = var.azure_resource_attributes
  naming_convention         = var.naming_convention
  user_defined              = "THANOS"

  resource_group_name = azurerm_resource_group.platform.name

  public_network_access_enabled = false
  private_endpoints = [
    {
      sub_resource_name   = "blob"
      subnet_id           = var.infrastructure_subnet_id
      private_dns_zone_id = var.dns_zone_ids.blob_storage
    }
  ]

  account_replication_type = "RAGZRS"
  containers               = [local.thanos_sa_container_name]
  tags                     = var.tags
}

# Creates a user assigned identity (managed identity)
# UAMI - Thanos Side Car Authenticates Using This
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity
resource "azurerm_user_assigned_identity" "thanos-id" {
  location            = azurerm_resource_group.platform.location
  name                = "${module.azure_resource_names.managed_identity_name}-id-thanos"
  resource_group_name = azurerm_resource_group.platform.name
}

# Create a trust and binds to the above UAMI to allow service account k8 tokens to use this identity
# Match on subject is required
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential
resource "azurerm_federated_identity_credential" "thanos-fed-id" {
  name      = "${module.azure_resource_names.managed_identity_name}-fed-id-thanos"
  audience  = ["api://AzureADTokenExchange"]
  issuer    = var.oidc_issuer_url
  subject   = var.fed_id_subject
  parent_id = azurerm_user_assigned_identity.thanos-id.id
}

# Role authorization
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "thanos_blob" {
  scope                = module.thanos_storage_account.id
  role_definition_name = "Blob Storage Contributor"
  principal_id         = azurerm_user_assigned_identity.thanos-id.principal_id
}
