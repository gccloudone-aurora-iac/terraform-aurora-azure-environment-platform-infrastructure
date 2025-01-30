# Assigns a given Principal (User or Group) to a given Role.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
#
resource "azurerm_role_assignment" "aad_pod_identity_bill_of_landing_operator" {
  count = var.bill_of_landing_managed_identity_id != null ? 1 : 0

  scope                = var.bill_of_landing_managed_identity_id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.cluster_identity_object_id
}
