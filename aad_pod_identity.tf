# Assigns a given Principal (User or Group) to a given Role.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
#
resource "azurerm_role_assignment" "aad_pod_identity_vm_contributor" {
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = var.cluster_identity_object_id
  scope                = var.cluster_node_resource_group_id
}
