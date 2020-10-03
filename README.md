# terraform-fun
Hacks, notes and experiments with HashiCorp Terraform 


## Samples

- `hello-world`: Creates an Azure Resource Group.
- `vm-demo`: Creates a Windows VM in Azure and configures IIS.
- `appservice-to-vm`: An App Services using an existing database in a VM.
- `tshirt-sizes`: terraform 0.11 style for parametrizing from a table.
- `dsc-automation-vm`: use Azure Automation to install a VSTS Agent.
- `carving-subnets`: using `cidrsubnet` and `cidrhost` to statically assign IP addresses.
- `convey-params`: pushing parameters from Terraform to Powershell via `azurerm_virtual_machine_extension`.
- `uploader`: script to upload files to Azure Storage.
- `zipping`: how to use `archive_file` to create a local Zip.
- `invoke-arm`: use of `azurerm_template_deployment`.
- `appservice-to-vm`: complex Azure example that shows an App Service using a SQL Server instance hosted in a VM (scenario of green field application using a legacy database). 
- `agnostic-modules` Cloud agnostic code: how to abstract and decouple from Terraform providers.

## Files not in repo

`Set-AzureRMSecrets.ps1` sets the environment variables required by Terraform to act on Azure

```Powershell
# pro-demo / terraformfun
$env:ARM_ACCESS_KEY = "***"
# Subscription ID
$env:ARM_SUBSCRIPTION_ID = "******"
# Directory ID
$env:ARM_TENANT_ID = "******"
# Application ID (terraform-fun)
$env:ARM_CLIENT_ID = "******"
# Key $env:ComputerName exp. $(Get-Date)
$env:ARM_CLIENT_SECRET = "********"
```


## Permissions

Can use two Service Principals (aka Applications) `terraform-contrib` and  `terraform-reader`

Service Principal   | Resource            | Role / Access policy
--------------------|---------------------|---------------------
`terraform-contrib` | Subscription        | Contributor
`terraform-contrib` | `pro-demo` KeyVault | Get & List Secrets
`terraform-reader`  | Subscription        | Reader
`terraform-reader`  | `pro-demo` KeyVault | Get & List Secrets

The latter can be shared "freely", the former can do damage (planning is key).

Some example, notably _agnostic-modules_, requires additional accounts and permissions.