# terraform-fun
Hacks, notes and experiments with HashiCorp Terraform 


## Files not in repo

`Set-AzureRMSecrets.ps1` sets the environment variables required by Terraform to act on Azure
```
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