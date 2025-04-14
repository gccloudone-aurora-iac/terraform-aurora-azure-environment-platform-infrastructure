# Manages a Resource Group.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
#
resource "azurerm_resource_group" "backup" {
  name     = "${module.azure_resource_names.resource_group_name}-backup"
  location = var.azure_resource_attributes.location
  tags     = var.tags

  lifecycle {
    ignore_changes = [tags.DateCreatedModified]
  }
}
