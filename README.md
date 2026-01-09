# terraform-aurora-azure-environment-platform-infrastructure

Deploys Azure components required by the platform.

## Usage

Examples for this module along with various configurations can be found in the [examples/](examples/) folder.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.26.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.26.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backup_rg"></a> [backup\_rg](#module\_backup\_rg) | ./modules/backup | n/a |
| <a name="module_platform_rg"></a> [platform\_rg](#module\_platform\_rg) | ./modules/platform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_resource_attributes"></a> [azure\_resource\_attributes](#input\_azure\_resource\_attributes) | Attributes used to describe Azure resources | <pre>object({<br>    project     = string<br>    environment = string<br>    location    = optional(string, "Canada Central")<br>    instance    = number<br>  })</pre> | n/a | yes |
| <a name="input_cluster_identity_object_id"></a> [cluster\_identity\_object\_id](#input\_cluster\_identity\_object\_id) | The principal ID associated with AKS's Managed Service Identity. | `string` | n/a | yes |
| <a name="input_cluster_node_resource_group_id"></a> [cluster\_node\_resource\_group\_id](#input\_cluster\_node\_resource\_group\_id) | The Azure resource ID of the Resource Group containing the resources for the AKS cluster. | `string` | n/a | yes |
| <a name="input_networking_ids"></a> [networking\_ids](#input\_networking\_ids) | The Azure resource IDs for DNS Zones and subnets. | <pre>object({<br>    dns_zones = object({<br>      cloud_aurora_ca = string<br>      blob_storage     = string<br>    })<br>    subnets = object({<br>      infrastructure = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags attached to Azure resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_resource_group_id"></a> [backup\_resource\_group\_id](#output\_backup\_resource\_group\_id) | The ID of the backup resource group. |
| <a name="output_backup_resource_group_name"></a> [backup\_resource\_group\_name](#output\_backup\_resource\_group\_name) | The name of the backup resource group. |
| <a name="output_cert_manager_identity_client_id"></a> [cert\_manager\_identity\_client\_id](#output\_cert\_manager\_identity\_client\_id) | The client ID of the cert-manager user-assigned managed identity. |
| <a name="output_cert_manager_identity_id"></a> [cert\_manager\_identity\_id](#output\_cert\_manager\_identity\_id) | The Azure resource ID of the cert-manager user-assigned managed identity. |
| <a name="output_platform_resource_group_id"></a> [platform\_resource\_group\_id](#output\_platform\_resource\_group\_id) | The ID of the platform resource group. |
| <a name="output_platform_resource_group_name"></a> [platform\_resource\_group\_name](#output\_platform\_resource\_group\_name) | The name of the platform resource group. |
| <a name="output_platform_workflows_primary_access_key"></a> [platform\_workflows\_primary\_access\_key](#output\_platform\_workflows\_primary\_access\_key) | The primary access key of the workflows storage account. |
| <a name="output_platform_workflows_primary_blob_endpoint"></a> [platform\_workflows\_primary\_blob\_endpoint](#output\_platform\_workflows\_primary\_blob\_endpoint) | The primary blob endpoint of the workflows storage account. |
| <a name="output_platform_workflows_storage_account_id"></a> [platform\_workflows\_storage\_account\_id](#output\_platform\_workflows\_storage\_account\_id) | The ID of the workflows storage account. |
| <a name="output_platform_workflows_storage_account_name"></a> [platform\_workflows\_storage\_account\_name](#output\_platform\_workflows\_storage\_account\_name) | The name of the workflows storage account. |
| <a name="output_vault_identity_client_id"></a> [vault\_identity\_client\_id](#output\_vault\_identity\_client\_id) | The client ID of the Hashicorp Vault user-assigned managed identity. |
| <a name="output_vault_identity_id"></a> [vault\_identity\_id](#output\_vault\_identity\_id) | The Azure resource ID of the Hashicorp Vault user-assigned managed identity. |
| <a name="output_velero_identity_client_id"></a> [velero\_identity\_client\_id](#output\_velero\_identity\_client\_id) | The client ID of the Velero user-assigned managed identity. |
| <a name="output_velero_identity_id"></a> [velero\_identity\_id](#output\_velero\_identity\_id) | The Azure resource ID of the velero user-assigned managed identity. |
| <a name="output_velero_storage_account_id"></a> [velero\_storage\_account\_id](#output\_velero\_storage\_account\_id) | The ID of the Velero storage account. |
| <a name="output_velero_storage_account_name"></a> [velero\_storage\_account\_name](#output\_velero\_storage\_account\_name) | The name of the Azure storage account used to store Velero backups. |
| <a name="output_velero_storage_bucket_name"></a> [velero\_storage\_bucket\_name](#output\_velero\_storage\_bucket\_name) | The name the container within the Velero storage account used to store Velero backups. |
<!-- END_TF_DOCS -->

## History

| Date       | Release | Change                                                                                                              |
| ---------- | ------- | ------------------------------------------------------------------------------------------------------------------- |
| 2025-01-25 | v1.0.0  | initial commit                                                                                                      |
| 2025-10-01 | v2.0.1  | Uncomment the custom role assignments for Velero disk & snapshot management                                         |
| 2025-10-20 | v2.0.2  | Pin minimum version of azurerm to 4.49.0                                                                            |
| 2025-12-24 | v2.0.3  | Federated identity credential setup for Velero                                                                      |
| 2026-01-06 | v2.0.4  | Add additional permissions for velero operations                                                                    |
| 2026-01-08 | v2.0.5  | Federated identity credential setup for Cert Manager                                                                |
| 2026-01-09 | v2.0.6  | Define variables to pass oidc issuer url Cert Manager workload identity                                             |