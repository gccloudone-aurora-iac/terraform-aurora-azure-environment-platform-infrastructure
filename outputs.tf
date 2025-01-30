#######################
### Resource Groups ###
#######################

output "platform_resource_group_id" {
  description = "The ID of the platform resource group."
  value       = module.platform_rg.platform_resource_group_id
}

output "platform_resource_group_name" {
  description = "The name of the platform resource group."
  value       = module.platform_rg.platform_resource_group_name
}

output "backup_resource_group_id" {
  description = "The ID of the backup resource group."
  value       = module.backup_rg.backup_resource_group_id
}

output "backup_resource_group_name" {
  description = "The name of the backup resource group."
  value       = module.backup_rg.backup_resource_group_name
}

####################
### Cert-manager ###
####################

output "cert_manager_identity_id" {
  description = "The Azure resource ID of the cert-manager user-assigned managed identity."
  value       = module.platform_rg.cert_manager_identity_id
}

output "cert_manager_identity_client_id" {
  description = "The client ID of the cert-manager user-assigned managed identity."
  value       = module.platform_rg.cert_manager_identity_client_id
}

##############
### Velero ###
##############

output "velero_identity_id" {
  description = "The Azure resource ID of the velero user-assigned managed identity."
  value       = module.backup_rg.velero_identity_id
}

output "velero_identity_client_id" {
  description = "The client ID of the Velero user-assigned managed identity."
  value       = module.backup_rg.velero_identity_client_id
}

output "velero_storage_account_id" {
  description = "The ID of the Velero storage account."
  value       = module.backup_rg.velero_storage_account_id
}

output "velero_storage_account_name" {
  description = "The name of the Azure storage account used to store Velero backups."
  value       = module.backup_rg.velero_storage_account_name
}

output "velero_storage_bucket_name" {
  description = "The name the container within the Velero storage account used to store Velero backups."
  value       = module.backup_rg.velero_storage_account_name
}

######################
### Argo Workflows ###
######################

output "argo_workflows_storage_account_id" {
  description = "The ID of the workflows storage account."
  value       = module.platform_rg.argo_workflows_storage_account_id
}

output "argo_workflows_storage_account_name" {
  description = "The name of the workflows storage account."
  value       = module.platform_rg.argo_workflows_storage_account_name
}

output "argo_workflows_primary_access_key" {
  description = "The primary access key of the workflows storage account."
  value       = module.platform_rg.argo_workflows_primary_access_key
}

output "argo_workflows_primary_blob_endpoint" {
  description = "The primary blob endpoint of the workflows storage account."
  value       = module.platform_rg.argo_workflows_primary_blob_endpoint
}

output "argo_workflows_sso_sp" {
  description = "Azure service principal used for SSO when logging into Argo Workflows."
  value       = module.argo_workflow_sso_sp
}

###############
### Grafana ###
###############

output "grafana_sso_sp" {
  description = "Azure service principal used for SSO when logging into Grafana."
  value       = module.grafana_sso_sp
}

################
### Kubecost ###
################

output "kubecost_sp" {
  description = "Azure service principal used to access accurate Microsoft Azure billing data."
  value       = module.kubecost_sp
}