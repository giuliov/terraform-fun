module "network" {
  source          = "../../modules/network"
  env_type        = "prod"
  env_name        = "tf-test-prod"
}
