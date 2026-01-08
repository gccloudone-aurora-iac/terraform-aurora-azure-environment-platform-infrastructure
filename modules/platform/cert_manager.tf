# Manages a User Assigned Identity.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity
#
resource "azurerm_user_assigned_identity" "cert_manager" {
  name                = "${module.azure_resource_names.managed_identity_name}-cert-manager"
  resource_group_name = azurerm_resource_group.platform.name
  location            = var.azure_resource_attributes.location
  tags                = var.tags
}

# Assigns a given Principal (User or Group) to a given Role.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
#
resource "azurerm_role_assignment" "cert_manager_dns" {
  scope                = var.dns_zone_ids.cert_manager
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.cert_manager.principal_id
}

# Assigns a given Principal (User or Group) to a given Role.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
#
resource "azurerm_role_assignment" "aad_pod_identity_cert_manager_operator" {
  scope                = azurerm_user_assigned_identity.cert_manager.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.cluster_identity_object_id
}

# Creates a Federate Identity Credential
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential
#
resource "azurerm_federated_identity_credential" "cert_manager" {
  name                = "${module.azure_resource_names.managed_identity_name}-cert-manager"
  resource_group_name = azurerm_resource_group.platform.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.cert_manager.id
  subject             = "system:serviceaccount:cert-manager-system:cert-manager"
}