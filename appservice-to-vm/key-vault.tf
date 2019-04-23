data "azurerm_key_vault" "giuliov_pro_demo" {
  name                = "giuliov-pro-demo"
  resource_group_name = "pro-demo"
}

data "azurerm_key_vault_secret" "appsvcint_demo_admin" {
  name         = "vm-admin-password"
  key_vault_id = "${data.azurerm_key_vault.giuliov_pro_demo.id}"
}

data "azurerm_key_vault_secret" "appsvcint_demo_sa" {
  name         = "sa-password"
  key_vault_id = "${data.azurerm_key_vault.giuliov_pro_demo.id}"
}
