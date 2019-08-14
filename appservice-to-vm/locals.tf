locals {
  # see https://winterdom.com/2017/08/01/aiarm, used to hook up Application Insights to the app service
  /*linkToApplicationInsightsResource = {
    "hidden-link:${azurerm_resource_group.appsvcint_demo.id}/providers/Microsoft.Web/sites/${azurerm_app_service.appsvcint_demo.name}" = "Resource"
  }*/
}