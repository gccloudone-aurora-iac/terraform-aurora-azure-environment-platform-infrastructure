# terraform-aurora-azure-environment-platform-infrastructure

Deploys Azure components required by the platform.

## Usage

Examples for this module along with various configurations can be found in the [examples/](examples/) folder.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.49.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.49.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_argo_workflow_sso_sp"></a> [argo\_workflow\_sso\_sp](#module\_argo\_workflow\_sso\_sp) | git::https://github.com/gccloudone-aurora-iac/terraform-azure-service-principal.git | v2.0.1 |
| <a name="module_azure_resource_names"></a> [azure\_resource\_names](#module\_azure\_resource\_names) | git::https://github.com/gccloudone-aurora-iac/terraform-aurora-azure-resource-names.git | v2.0.0 |
| <a name="module_backup_rg"></a> [backup\_rg](#module\_backup\_rg) | ./modules/backup | n/a |
| <a name="module_grafana_sso_sp"></a> [grafana\_sso\_sp](#module\_grafana\_sso\_sp) | git::https://github.com/gccloudone-aurora-iac/terraform-azure-service-principal.git | v2.0.1 |
| <a name="module_kubecost_sp"></a> [kubecost\_sp](#module\_kubecost\_sp) | git::https://github.com/gccloudone-aurora-iac/terraform-azure-service-principal.git | v2.0.1 |
| <a name="module_platform_rg"></a> [platform\_rg](#module\_platform\_rg) | ./modules/platform | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_role_assignment.aad_pod_identity_vm_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_azure_resource_attributes"></a> [azure\_resource\_attributes](#input\_azure\_resource\_attributes) | Attributes used to describe Azure resources | <pre>object({<br/>    department_code = string<br/>    owner           = string<br/>    project         = string<br/>    environment     = string<br/>    location        = optional(string, "Canada Central")<br/>    instance        = number<br/>  })</pre> | n/a | yes |
| <a name="input_bill_of_landing_managed_identity_id"></a> [bill\_of\_landing\_managed\_identity\_id](#input\_bill\_of\_landing\_managed\_identity\_id) | The members to configure on the Grafana SSO service principal | `string` | `null` | no |
| <a name="input_cluster_identity_object_id"></a> [cluster\_identity\_object\_id](#input\_cluster\_identity\_object\_id) | The principal ID associated with AKS's Managed Service Identity. | `string` | n/a | yes |
| <a name="input_cluster_node_resource_group_id"></a> [cluster\_node\_resource\_group\_id](#input\_cluster\_node\_resource\_group\_id) | The Azure resource ID of the Resource Group containing the resources for the AKS cluster. | `string` | n/a | yes |
| <a name="input_create_custom_role_assignment"></a> [create\_custom\_role\_assignment](#input\_create\_custom\_role\_assignment) | Set to true to create the custom role assignments. | `bool` | `true` | no |
| <a name="input_grafana_sso_sp"></a> [grafana\_sso\_sp](#input\_grafana\_sso\_sp) | The members to configure on the Grafana SSO service principal | <pre>object({<br/>    members = object({<br/>      viewer = optional(map(string))<br/>      editor = optional(map(string))<br/>      admin  = map(string)<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_naming_convention"></a> [naming\_convention](#input\_naming\_convention) | Sets which naming convention to use. Accepted values: oss, gc | `string` | `"oss"` | no |
| <a name="input_networking_ids"></a> [networking\_ids](#input\_networking\_ids) | The Azure resource IDs for DNS Zones and subnets. | <pre>object({<br/>    dns_zones = object({<br/>      cert_manager = optional(string)<br/>      blob_storage = optional(string)<br/>    })<br/>    subnets = object({<br/>      infrastructure = string<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_oidc_issuer_url"></a> [oidc\_issuer\_url](#input\_oidc\_issuer\_url) | The OIDC issuer URL that is associated with the cluster. | `string` | n/a | yes |
| <a name="input_service_principal_owners"></a> [service\_principal\_owners](#input\_service\_principal\_owners) | The Azure identities that will be configured as owners of the created Azure service principals. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags attached to Azure resource | `map(string)` | `{}` | no |
| <a name="input_user_defined"></a> [user\_defined](#input\_user\_defined) | A user-defined field that describes the Azure resource. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_argo_workflows_primary_access_key"></a> [argo\_workflows\_primary\_access\_key](#output\_argo\_workflows\_primary\_access\_key) | The primary access key of the workflows storage account. |
| <a name="output_argo_workflows_primary_blob_endpoint"></a> [argo\_workflows\_primary\_blob\_endpoint](#output\_argo\_workflows\_primary\_blob\_endpoint) | The primary blob endpoint of the workflows storage account. |
| <a name="output_argo_workflows_sso_sp"></a> [argo\_workflows\_sso\_sp](#output\_argo\_workflows\_sso\_sp) | Azure service principal used for SSO when logging into Argo Workflows. |
| <a name="output_argo_workflows_storage_account_id"></a> [argo\_workflows\_storage\_account\_id](#output\_argo\_workflows\_storage\_account\_id) | The ID of the workflows storage account. |
| <a name="output_argo_workflows_storage_account_name"></a> [argo\_workflows\_storage\_account\_name](#output\_argo\_workflows\_storage\_account\_name) | The name of the workflows storage account. |
| <a name="output_backup_resource_group_id"></a> [backup\_resource\_group\_id](#output\_backup\_resource\_group\_id) | The ID of the backup resource group. |
| <a name="output_backup_resource_group_name"></a> [backup\_resource\_group\_name](#output\_backup\_resource\_group\_name) | The name of the backup resource group. |
| <a name="output_cert_manager_identity_client_id"></a> [cert\_manager\_identity\_client\_id](#output\_cert\_manager\_identity\_client\_id) | The client ID of the cert-manager user-assigned managed identity. |
| <a name="output_cert_manager_identity_id"></a> [cert\_manager\_identity\_id](#output\_cert\_manager\_identity\_id) | The Azure resource ID of the cert-manager user-assigned managed identity. |
| <a name="output_grafana_sso_sp"></a> [grafana\_sso\_sp](#output\_grafana\_sso\_sp) | Azure service principal used for SSO when logging into Grafana. |
| <a name="output_kubecost_sp"></a> [kubecost\_sp](#output\_kubecost\_sp) | Azure service principal used to access accurate Microsoft Azure billing data. |
| <a name="output_platform_resource_group_id"></a> [platform\_resource\_group\_id](#output\_platform\_resource\_group\_id) | The ID of the platform resource group. |
| <a name="output_platform_resource_group_name"></a> [platform\_resource\_group\_name](#output\_platform\_resource\_group\_name) | The name of the platform resource group. |
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
| 2026-04-29 | v3.0.0  | Add ingress_host variable. Fix service principal web redirect URI                  |