This demo shows how to setup an App Service that connects to an existing resource, in this case a
SQL Server database running inside a VM.

See [Integrate your app with an Azure Virtual Network](https://docs.microsoft.com/en-us/azure/app-service/web-sites-integrate-with-vnet) for more details.

Manual steps:
1. The `custom_data` does not work, so manually complete SQL Server setup and start it
    a) `sudo /opt/mssql/bin/mssql-conf set-sa-password`
    using the password from Key Vault
    b) `sudo systemctl start mssql-server`
2. **VNet Integration** Add VNet from App Service/Networking
3. **VNet Integration** in the App Service Plan, find _Sync Network_ and run it

The script [Connect an app in Azure App Service to an Azure Virtual Network](https://gallery.technet.microsoft.com/scriptcenter/Connect-an-app-in-Azure-ab7527e3) can help automate steps 2 and 3.
