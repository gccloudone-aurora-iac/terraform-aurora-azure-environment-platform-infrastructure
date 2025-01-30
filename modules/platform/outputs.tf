######################
### Resource Group ###
######################

output "platform_resource_group_id" {
  description = "The ID of the platform resource group."
  value       = azurerm_resource_group.platform.id
}

output "platform_resource_group_name" {
  description = "The name of the platform resource group."
  value       = azurerm_resource_group.platform.name
}

####################
### Cert-manager ###
####################

output "cert_manager_identity_id" {
  description = "The Azure resource ID of the cert-manager user-assigned managed identity."
  value       = azurerm_user_assigned_identity.cert_manager.id
}

output "cert_manager_identity_client_id" {
  description = "The client ID of the cert-manager user-assigned managed identity."
  value       = azurerm_user_assigned_identity.cert_manager.client_id
}

######################
### Argo Workflows ###
######################

output "argo_workflows_storage_account_id" {
  description = "The ID of the workflows storage account."
  value       = module.argo_workflows_storage_account.id
}

output "argo_workflows_storage_account_name" {
  description = "The name of the workflows storage account."
  value       = module.argo_workflows_storage_account.name
}

output "argo_workflows_primary_access_key" {
  description = "The primary access key of the workflows storage account."
  value       = module.argo_workflows_storage_account.primary_access_key
}

output "argo_workflows_primary_blob_endpoint" {
  description = "The primary blob endpoint of the workflows storage account."
  value       = module.argo_workflows_storage_account.primary_blob_endpoint
}
