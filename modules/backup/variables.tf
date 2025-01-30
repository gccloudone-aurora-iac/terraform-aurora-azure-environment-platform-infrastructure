variable "azure_resource_attributes" {
  description = "Attributes used to describe Azure resources"
  type = object({
    project     = string
    environment = string
    location    = optional(string, "Canada Central")
    instance    = number
  })
  nullable = false
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
