This demo shows how to setup an App Service that connects to an existing resource, in this case a
SQL Server database running inside a VM.

See [Integrate your app with an Azure Virtual Network](https://docs.microsoft.com/en-us/azure/app-service/web-sites-integrate-with-vnet) for more details.

Manual steps:
1. The `custom_data` does not work, so complete SQL setup and start it
2. **VNet Integration** Add VNet from App Service/Networking
3. **VNet Integration** in the App Service Plan, find _Sync Network_ and run it
