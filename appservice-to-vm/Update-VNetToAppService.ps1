#Requires -Version 5.1

param(
    [Parameter(Mandatory = $true)]
    [string]
    $ResourceGroup,
    [Parameter(Mandatory = $true)]
    [string]
    $AppName,
    [Parameter(Mandatory = $true)]
    [string]
    $ExistingVnetName,
    [switch]
    $Destroy
)


function AddExistingVnet($subscriptionId, $resourceGroupName, $webAppName, $existingVnetName) {
    $ErrorActionPreference = "Stop";

    # At this point, the gateway should be able to be joined to an App, but may require some minor tweaking. We will declare to the App now to use this VNET
    Write-Host "Getting App information"
    $webApp = Get-AzureRmResource -ResourceName $webAppName -ResourceType "Microsoft.Web/sites" -ApiVersion 2015-08-01 -ResourceGroupName $resourceGroupName
    $location = $webApp.Location

    $vnet = Get-AzureRmVirtualNetwork -Name $existingVnetName -ResourceGroupName $resourceGroupName

    # We need to check if this VNET is able to be joined to a App, based on following criteria
    # If it doesn't have the right certificate, we will need to add it.
    # If it doesn't have a point-to-site range, we will need to add it.

    $gatewaySubnet = $vnet.Subnets | Where-Object { $_.Name -eq "GatewaySubnet" }

    $uriParts = $gatewaySubnet.IpConfigurations[0].Id.Split('/')
    $gatewayResourceGroup = $uriParts[4]
    $gatewayName = $uriParts[8]

    $gateway = Get-AzureRmVirtualNetworkGateway -ResourceGroupName $vnet.ResourceGroupName -Name $gatewayName

    Write-Host "(Re)creating App association to VNET"
    $propertiesObject = @{
        "vnetResourceId" = "/subscriptions/$($subscriptionId)/resourceGroups/$($vnet.ResourceGroupName)/providers/Microsoft.Network/virtualNetworks/$($vnet.Name)"
    }
    $virtualNetwork = New-AzureRmResource -Location $location -Properties $PropertiesObject -ResourceName "$($webAppName)/$($vnet.Name)" -ResourceType "Microsoft.Web/sites/virtualNetworkConnections" -ApiVersion 2015-08-01 -ResourceGroupName $resourceGroupName -Force

    # We need to check if the certificate here exists in the gateway.
    $certificates = $gateway.VpnClientConfiguration.VpnClientRootCertificates

    $certFound = $false
    foreach ($certificate in $certificates) {
        if ($certificate.PublicCertData -eq $virtualNetwork.Properties.CertBlob) {
            $certFound = $true
            break
        }
    }

    if (-not $certFound) {
        Write-Host "Adding certificate"
        Add-AzureRmVpnClientRootCertificate -VpnClientRootCertificateName "AppServiceCertificate.cer" -PublicCertData $virtualNetwork.Properties.CertBlob -VirtualNetworkGatewayName $gateway.Name
    }

    # Now finish joining by getting the VPN package and giving it to the App
    Write-Host "Retrieving VPN Package and supplying to App"
    $packageUri = Get-AzureRmVpnClientPackage -ResourceGroupName $vnet.ResourceGroupName -VirtualNetworkGatewayName $gateway.Name -ProcessorArchitecture Amd64

    # $packageUri may contain literal double-quotes at the start and the end of the URL
    if ($packageUri.Length -gt 0 -and $packageUri.Substring(0, 1) -eq '"' -and $packageUri.Substring($packageUri.Length - 1, 1) -eq '"') {
        $packageUri = $packageUri.Substring(1, $packageUri.Length - 2)
    }

    # Put the VPN client configuration package onto the App
    $PropertiesObject = @{
        "vnetName" = $vnet.Name; "vpnPackageUri" = $packageUri
    }

    New-AzureRmResource -Location $location -Properties $PropertiesObject -ResourceName "$($webAppName)/$($vnet.Name)/primary" -ResourceType "Microsoft.Web/sites/virtualNetworkConnections/gateways" -ApiVersion 2015-08-01 -ResourceGroupName $resourceGroupName -Force

    Write-Host "Finished!"
}

function RemoveVnet($resourceGroupName, $webAppName, $existingVnetName) {
    $webAppConfig = Get-AzureRmResource -ResourceName "$($webAppName)/web" -ResourceType "Microsoft.Web/sites/config" -ApiVersion 2015-08-01 -ResourceGroupName $resourceGroupName
    $currentVnet = $webAppConfig.Properties.VnetName
    if ($currentVnet -ne $null -and $currentVnet -ne "") {
        Write-Host "Currently connected to VNET $currentVnet"

        if ($currentVnet -eq $existingVnetName) {
            Remove-AzureRmResource -ResourceName "$($webAppName)/$($currentVnet)" -ResourceType "Microsoft.Web/sites/virtualNetworkConnections" -ApiVersion 2015-08-01 -ResourceGroupName $resourceGroupName -Force
        }
        else {
            Write-Host "VNET does not match, exiting."
        }
    }
    else {
        Write-Host "Not connected to a VNET."
    }
}

# connect to Azure using Terraform Service Principal environment variables
$secpasswd = ConvertTo-SecureString $env:ARM_CLIENT_SECRET -AsPlainText -Force
$ServicePrincipalCredential = New-Object System.Management.Automation.PSCredential ($env:ARM_CLIENT_ID, $secpasswd)
$azureProfile = Connect-AzureRmAccount -Credential $ServicePrincipalCredential -Tenant $env:ARM_TENANT_ID -ServicePrincipal

if ($destroy) {
    RemoveVnet $resourceGroup $appName $existingVnetName
}
else {
    AddExistingVnet $azureProfile.Subscription $resourceGroup $appName $existingVnetName
}
