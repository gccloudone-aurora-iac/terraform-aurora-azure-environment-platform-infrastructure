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

variable "service_principal_owners" {
  description = "The Azure identities that will be configured as owners of the created Azure service principals."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags attached to Azure resource"
  type        = map(string)
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

###############################
### Networking Resource IDs ###
###############################

variable "networking_ids" {
  description = "The Azure resource IDs for DNS Zones and subnets."
  type = object({
    dns_zones = object({
      cert_manager = optional(string)
      blob_storage = optional(string)
    })
    subnets = object({
      infrastructure = string
    })
  })
}

##########################
### Service principals ###
##########################

variable "grafana_sso_sp" {
  description = "The members to configure on the Grafana SSO service principal"
  type = object({
    members = object({
      viewer = optional(map(string))
      editor = optional(map(string))
      admin  = map(string)
    })
  })
}

##########################
### Platform Resources ###
##########################

variable "bill_of_landing_managed_identity_id" {
  description = "The members to configure on the Grafana SSO service principal"
  type        = string
  default     = null
}
