locals {
  number_of_vnets = var.env_type == "prod" ? 1 : 3
}
