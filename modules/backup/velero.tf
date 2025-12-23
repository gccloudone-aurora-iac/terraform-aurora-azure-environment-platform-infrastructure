############
## VELERO ##
############

module "velero_storage_account" {
  source = "git::https://github.com/gccloudone-aurora-iac/terraform-azure-storage-account.git?ref=v2.0.1"

  azure_resource_attributes = var.azure_resource_attributes
  naming_convention         = var.naming_convention
  user_defined              = "BKUP"

  resource_group_name = azurerm_resource_group.backup.name

  public_network_access_enabled = false
  private_endpoints = [
    {
      sub_resource_name   = "blob"
      subnet_id           = var.infrastructure_subnet_id
      private_dns_zone_id = var.blob_storage_private_dns_zone_id
    }
  ]

  account_replication_type = "RAGZRS"
  containers               = [local.velero_sa_container_name]

  tags = var.tags
}

#######################
### Identity & RBAC ###
#######################

# Manages a User Assigned Identity.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity
#
resource "azurerm_user_assigned_identity" "velero" {
  name                = "${module.azure_resource_names.managed_identity_name}-velero"
  resource_group_name = azurerm_resource_group.backup.name
  location            = var.azure_resource_attributes.location
  tags                = var.tags
}

# Creates a Federate Identity Credential
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential
#
resource "azurerm_federated_identity_credential" "velero" {
  name                = "${module.azure_resource_names.managed_identity_name}-velero"
  resource_group_name = azurerm_resource_group.backup.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://foobar"
  parent_id           = azurerm_user_assigned_identity.velero.id
  subject             = "system:serviceaccount:velero-system:velero-server"
}



# Assigns a given Principal (User or Group) to a given Role.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
#
resource "azurerm_role_assignment" "velero_storage_key_operator" {
  scope                = module.velero_storage_account.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = azurerm_user_assigned_identity.velero.principal_id
}

# Assigns a given Principal (User or Group) to a given Role.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
#
# NOTE: You MUST create a custom role in Azure. See https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure?tab=readme-ov-file#specify-role to see what permissions the Velero Snapshot Management role requires.
#
resource "azurerm_role_assignment" "velero_snapshot_management" {
  scope                = azurerm_resource_group.backup.id
  role_definition_name = "Velero Snapshot Management"
  principal_id         = azurerm_user_assigned_identity.velero.principal_id
}

# Assigns a given Principal (User or Group) to a given Role.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
#
# NOTE: You MUST create a custom role in Azure. See https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure?tab=readme-ov-file#specify-role to see what permissions the Velero Disk Management role requires.
#
resource "azurerm_role_assignment" "velero_disk_management" {
  scope                = var.cluster_node_resource_group_id
  role_definition_name = "Velero Disk Management"
  principal_id         = azurerm_user_assigned_identity.velero.principal_id
}

# Assigns a given Principal (User or Group) to a given Role.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
#
resource "azurerm_role_assignment" "aad_pod_identity_velero_operator" {
  scope                = azurerm_user_assigned_identity.velero.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.cluster_identity_object_id
}
