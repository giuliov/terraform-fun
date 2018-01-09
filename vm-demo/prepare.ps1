Login-AzureRMAccount

$dscFolder = 'DSCWebServer'

# can't forbid Compress-Archive to add folder path, while 7zip works wonderfully
Push-Location .\$dscFolder
& 'C:\Program Files\7-Zip\7z.exe' a ..\$dscFolder.zip .
Pop-Location

$zip = Get-Item .\$dscFolder.zip
$storageAccount =  Get-AzureRmStorageAccount -ResourceGroupName pro-demo -Name terraformfun
Set-AzureStorageBlobContent -Context $storageAccount.Context -File $zip.Fullname -Container 'vm-demo-scripts' -Blob $zip.Name -Force

# try & retry
terraform taint azurerm_virtual_machine_extension.vm_demo_dsc
terraform plan -out _plan.json

# nuclear option
terraform taint azurerm_virtual_machine.vm_demo

terraform apply _plan.json
