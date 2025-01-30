locals {
  tags = merge(var.tags, { ModuleName = "terraform-aurora-azure-environment-platform-infrastructure" }, { ModuleVersion = "v1.0.0" })
}
