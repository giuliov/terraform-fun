module "network" {
  source          = "../../modules/network"
  env_type        = "dev"
  env_name        = "tf-test-dev"
}
