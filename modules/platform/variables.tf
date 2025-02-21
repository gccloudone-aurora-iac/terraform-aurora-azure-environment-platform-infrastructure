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

variable "cluster_identity_object_id" {
  description = "The principal ID associated with AKS's Managed Service Identity."
  type        = string
}

##################
### Networking ###
##################

variable "dns_zone_ids" {
  description = "The Azure resource ID of the public Azure DNS Zone used by the environment."
  type = object({
    blob_storage     = string
  })
}

variable "infrastructure_subnet_id" {
  description = "The Azure resource ID of the infrastructure subnet where private endpoints will exist."
  type        = string
}

##########################
### Platform Resources ###
##########################

variable "bill_of_landing_managed_identity_id" {
  description = "The members to configure on the Grafana SSO service principal"
  type        = string
  default     = null
}
