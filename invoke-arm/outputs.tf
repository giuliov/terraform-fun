output "jenkinsURL" {
  value = azurerm_template_deployment.arm_demo.outputs["jenkinsURL"]
}
