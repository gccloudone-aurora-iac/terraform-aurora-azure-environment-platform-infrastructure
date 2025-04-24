##################
# Argo Workflows #
##################

# Argo Workflows Storage Account
#
# https://github.com/gccloudone-aurora-iac/terraform-azure-storage-account
#
module "argo_workflows_storage_account" {
  source = "git::https://github.com/gccloudone-aurora-iac/terraform-azure-storage-account.git?ref=v2.0.0"

  azure_resource_attributes = var.azure_resource_attributes
  naming_convention         = var.naming_convention
  user_defined              = "ARGO"

  resource_group_name = azurerm_resource_group.platform.name

  public_network_access_enabled = false
  private_endpoints = [
    {
      sub_resource_name   = "blob"
      subnet_id           = var.infrastructure_subnet_id
      private_dns_zone_id = var.dns_zone_ids.blob_storage
    }
  ]

  tags = var.tags
}
