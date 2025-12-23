variable "azure_resource_attributes" {
  description = "Attributes used to describe Azure resources"
  type = object({
    department_code = string
    owner           = string
    project         = string
    environment     = string
    location        = optional(string, "Canada Central")
    instance        = number
  })
  nullable = false
}

variable "user_defined" {
  description = "A user-defined field that describes the Azure resource."
  type        = string
  nullable    = false

  validation {
    condition     = length(var.user_defined) >= 2 && length(var.user_defined) <= 15
    error_message = "The user-defined field must be between 2-15 characters long."
  }
}

variable "naming_convention" {
  type        = string
  default     = "oss"
  description = "Sets which naming convention to use. Accepted values: oss, gc"
  validation {
    condition     = var.naming_convention == "oss" || var.naming_convention == "gc"
    error_message = "The naming_convention field must either be 'oss' or 'gc'."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags attached to Azure resource"
  default     = {}
}

###################
### AKS Cluster ###
###################

variable "cluster_node_resource_group_id" {
  description = "The Azure resource ID of the Resource Group containing the resources for the AKS cluster."
  type        = string
}

variable "cluster_identity_object_id" {
  description = "The principal ID associated with AKS's Managed Service Identity."
  type        = string
}

##################
### Networking ###
##################

variable "blob_storage_private_dns_zone_id" {
  description = "The Azure resource ID of the blob storage Private DNS Zone that will be used to resolve private endpoints."
  type        = string
}

variable "infrastructure_subnet_id" {
  description = "The Azure resource ID of the infrastructure subnet where private endpoints will exist."
  type        = string
}


variable "oidc_issuer_url"{
  description = "The OIDC issuer URL that is associated with the cluster."
  type        = string
}