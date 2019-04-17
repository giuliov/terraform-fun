resource "null_resource" "upload_sample_app" {
  provisioner "local-exec" {
    command     = "upload-zip.ps1 -resourceGroupName '${azurerm_resource_group.appsvcint_demo.name}' -appName '${azurerm_app_service.appsvcint_demo.name}' -sourceDir '${path.module}/sample_app/' "
    interpreter = ["PowerShell", "-File"]
  }
}
