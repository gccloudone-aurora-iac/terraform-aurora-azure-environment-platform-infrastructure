# Manages a Resource Group.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
#
resource "azurerm_resource_group" "platform" {
  name     = "${module.azure_resource_names.resource_group_platform_name}"
  location = var.azure_resource_attributes.location
  tags     = var.tags
}
