/*
data "template_file" "upload_sample_app" {
  template = "${file("${path.module}/upload_sample_app.tpl")}"

  vars = {
    app_name         = "${azurerm_app_service.appsvcint_demo.name}"
    source_dir       = "${path.module}\\sample_app\\"
    publish_username = "${azurerm_app_service.appsvcint_demo.site_credential.username}"
    publish_password = "${azurerm_app_service.appsvcint_demo.site_credential.password}"
  }
}

resource "null_resource" "upload_sample_app" {
  provisioner "local-exec" {
    command     = "${data.template_file.upload_sample_app.rendered}"
    interpreter = ["PowerShell"]
  }
}
*/

data "external" "upload_sample_app" {
  program = ["powershell", "./upload-zip.ps1 -resourceGroupName '${azurerm_resource_group.appsvcint_demo.name}' -appName '${element(azurerm_app_service.appsvcint_demo.*.name, count.index)}' -sourceDir './sample_app/'"]
}
