# Creates the backup-rg Azure resource group and the nessessary platform components within it.
#
# ./modules/backup-rg
#
module "backup_rg" {
  source = "./modules/backup"

  azure_resource_attributes = var.azure_resource_attributes
  naming_convention         = var.naming_convention
  user_defined              = var.user_defined

  cluster_node_resource_group_id   = var.cluster_node_resource_group_id
  cluster_identity_object_id       = var.cluster_identity_object_id
  blob_storage_private_dns_zone_id = var.networking_ids.dns_zones.blob_storage
  infrastructure_subnet_id         = var.networking_ids.subnets.infrastructure

  oidc_issuer_url                  = var.oidc_issuer_url

}

  tags = local.tags
}

# Creates the platform-rg Azure resource group and the nessessary platform components within it.
#
# ./modules/platform-rg
#
module "platform_rg" {
  source = "./modules/platform"

  azure_resource_attributes = var.azure_resource_attributes
  naming_convention         = var.naming_convention
  user_defined              = var.user_defined

  cluster_identity_object_id = var.cluster_identity_object_id
  dns_zone_ids               = var.networking_ids.dns_zones
  infrastructure_subnet_id   = var.networking_ids.subnets.infrastructure

  # platform resources
  bill_of_landing_managed_identity_id = var.bill_of_landing_managed_identity_id

  tags = local.tags
}
