######################
### Argo Workflows ###
######################

# Creates an Azure service principal used for Argo Workflow SSO.
#
# https://github.com/gccloudone-aurora-iac/terraform-azure-service-principal
#
module "argo_workflow_sso_sp" {
  source = "git::https://github.com/gccloudone-aurora-iac/terraform-azure-service-principal.git?ref=v2.0.0"

  azure_resource_attributes = var.azure_resource_attributes
  naming_convention         = var.naming_convention
  user_defined              = "argo-workflow"

  owners = var.service_principal_owners

  web_redirect_uris = ["https://argo-workflows.${module.azure_resource_names.name}.cloudnative.cloud.aurora.ca/oauth2/callback"]

  group_membership_claims = ["SecurityGroup", "ApplicationGroup"]
  optional_claims = {
    access_tokens = [{
      name = "groups"
    }]
    id_tokens = [{
      name = "groups"
    }]
    saml2_tokens = [{
      name = "groups"
    }]
  }
}

################
### KubeCost ###
################

# Creates an Azure service principal used for authentication to KubeCost.
#
# https://github.com/gccloudone-aurora-iac/terraform-azure-service-principal
#
module "kubecost_sp" {
  source = "git::https://github.com/gccloudone-aurora-iac/terraform-azure-service-principal.git?ref=v2.0.0"

  azure_resource_attributes = var.azure_resource_attributes
  naming_convention         = var.naming_convention
  user_defined              = "kubecost"

  owners = var.service_principal_owners
}

# The KubecostRateCard role lets the identity access accurate Microsoft Azure billing data.
#
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
#
resource "azurerm_role_assignment" "kubecost_rate_card" {
  role_definition_name = "KubecostRateCard"
  principal_id         = module.kubecost_sp.service_principal.object_id
  scope                = data.azurerm_subscription.current.id
}

###############
### Grafana ###
###############

# Creates an Azure service principal used for Grafana authentication.
#
# https://github.com/gccloudone-aurora-iac/terraform-azure-service-principal
#
module "grafana_sso_sp" {
  source = "git::https://github.com/gccloudone-aurora-iac/terraform-azure-service-principal.git?ref=v2.0.0"

  azure_resource_attributes = var.azure_resource_attributes
  naming_convention         = var.naming_convention
  user_defined              = "grafana"

  owners = var.service_principal_owners

  web_redirect_uris = [
    "https://grafana.${module.azure_resource_names.name}.cloudnative.cloud.aurora.ca/login/azuread",
    "https://grafana.${module.azure_resource_names.name}.cloudnative.cloud.aurora.ca"
  ]

  group_membership_claims = ["SecurityGroup", "ApplicationGroup"]
  optional_claims = {
    access_tokens = [{
      name = "groups"
    }]
    id_tokens = [{
      name = "groups"
    }]
    saml2_tokens = [{
      name = "groups"
    }]
  }

  roles_and_members = {
    Grafana_Viewer = {
      description = "Grafana read only Users"
      value       = "Viewer"
      members     = var.grafana_sso_sp.members.viewer
    }
    Grafana_Editor = {
      description = "Grafana Editor Users"
      value       = "Editor"
      members     = var.grafana_sso_sp.members.editor
    }
    Grafana_Admin = {
      description = "Grafana admin Users"
      value       = "Admin"
      members     = var.grafana_sso_sp.members.admin
    }
  }
}
