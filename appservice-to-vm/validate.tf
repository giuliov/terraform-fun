## Always run

resource "null_resource" "check_database_connection" {
  triggers = {
    build_number = timestamp()
  }

  provisioner "local-exec" {
    command     = "${var.powershell} -File ./Test-SQLConnection.ps1 'Server=${azurerm_public_ip.appsvcint_demo.fqdn};Database=master;Connection Timeout=3;User=sa;Password=${data.azurerm_key_vault_secret.appsvcint_demo_sa.value}'"
  }
}

resource "null_resource" "check_app_to_database" {
  triggers = {
    build_number = timestamp()
  }

  provisioner "local-exec" {
    command     = "${var.powershell} -File ./Test-AppPage.ps1 'http://${azurerm_app_service.appsvcint_demo.default_site_hostname}/test-db.cshtml'"
  }
}

