#######################
### Resource Group ###
#######################

output "backup_resource_group_id" {
  description = "The ID of the platform resource group."
  value       = azurerm_resource_group.backup.id
}

output "backup_resource_group_name" {
  description = "The name of the backup resource group."
  value       = azurerm_resource_group.backup.name
}

##############
### Velero ###
##############

output "velero_identity_id" {
  description = "The Azure resource ID of the velero user-assigned managed identity."
  value       = azurerm_user_assigned_identity.velero.id
}

output "velero_identity_client_id" {
  description = "The client ID of the Velero user-assigned managed identity."
  value       = azurerm_user_assigned_identity.velero.client_id
}

output "velero_storage_account_id" {
  description = "The ID of the Velero storage account."
  value       = module.velero_storage_account.id
}

output "velero_storage_account_name" {
  description = "The name of the Azure storage account used to store Velero backups."
  value       = module.velero_storage_account.name
}

output "velero_storage_bucket_name" {
  description = "The name the container within the Velero storage account used to store Velero backups."
  value       = local.velero_sa_container_name
}
