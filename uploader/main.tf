variable "uploader_storage_container" {}
variable "uploader_storage_account_access_key" {}

## downside: it is executed during 'plan' not just in 'apply'
data "external" "uploader_data" {
  program = ["powershell", "${path.module}/uploader.ps1 -SourceFolder ${path.module}/data -StorageAccountName ${azurerm_storage_account.devops.name} -Container ${var.uploader_storage_container} -StorageAccountKey ${var.uploader_storage_account_access_key}"]
}

output "the_result" {
  value = "${data.external.uploader_data.result}"
}
