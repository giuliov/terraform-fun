resource "azurerm_app_service" "appsvcint_demo" {
  count               = "${var.num_apps}"
  name                = "${var.env_name}-${1+count.index}-appsvc"
  location            = "${azurerm_resource_group.appsvcint_demo.location}"
  resource_group_name = "${azurerm_resource_group.appsvcint_demo.name}"
  app_service_plan_id = "${azurerm_app_service_plan.appsvcint_demo.id}"
  enabled             = true
  depends_on          = ["azurerm_virtual_network_gateway.appsvcint_demo"]

  site_config {
    dotnet_framework_version  = "v4.0"
    scm_type                  = "LocalGit"
    default_documents         = ["default.html", "index.html", "default.aspx"]
    php_version               = "5.6"
    use_32_bit_worker_process = true
    virtual_network_name      = "${azurerm_virtual_network.appsvcint_demo.name}"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=${azurerm_network_interface.appsvcint_demo.private_ip_address};Database=master;Connection Timeout=3;User=sa;Password=${data.azurerm_key_vault_secret.appsvcint_demo_sa.value}"
  }
}

resource "azurerm_app_service_plan" "appsvcint_demo" {
  name                = "${var.env_name}-plan"
  location            = "${azurerm_resource_group.appsvcint_demo.location}"
  resource_group_name = "${azurerm_resource_group.appsvcint_demo.name}"
  kind                = "Windows"
  per_site_scaling    = false

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "null_resource" "add_vnet_to_appservice" {
  count = "${var.num_apps}"

  triggers = {
    app_svc = "${element(azurerm_app_service.appsvcint_demo.*.id, count.index)}"
    gw      = "${azurerm_virtual_network_gateway.appsvcint_demo.id}"
  }

  provisioner "local-exec" {
    command     = "./Update-VNetToAppService.ps1 -ResourceGroup '${azurerm_resource_group.appsvcint_demo.name}' -AppName '${element(azurerm_app_service.appsvcint_demo.*.name, count.index)}' -ExistingVnetName '${azurerm_virtual_network.appsvcint_demo.name}'"
    interpreter = ["PowerShell"]
  }
}
