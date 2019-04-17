locals {
  # see https://winterdom.com/2017/08/01/aiarm, used to hook up Application Insights to the app service
  linkToApplicationInsightsResource = {
    "hidden-link:${azurerm_resource_group.appsvcint_demo.id}/providers/Microsoft.Web/sites/${azurerm_app_service.appsvcint_demo.name}" = "Resource"
  }
}

resource "azurerm_app_service" "appsvcint_demo" {
  name                = "${var.env_name}-appsvc"
  location            = "${azurerm_resource_group.appsvcint_demo.location}"
  resource_group_name = "${azurerm_resource_group.appsvcint_demo.name}"
  app_service_plan_id = "${azurerm_app_service_plan.appsvcint_demo.id}"

  site_config {
    always_on                = false
    dotnet_framework_version = "v4.0"
    ftps_state               = "Disabled"
    remote_debugging_enabled = false
    virtual_network_name     = "${azurerm_virtual_network.appsvcint_demo.name}"
  }
}

resource "azurerm_app_service_plan" "appsvcint_demo" {
  name                = "${var.env_name}-plan"
  location            = "${azurerm_resource_group.appsvcint_demo.location}"
  resource_group_name = "${azurerm_resource_group.appsvcint_demo.name}"

  sku {
    tier = "Free"
    size = "F1"
  }
}
