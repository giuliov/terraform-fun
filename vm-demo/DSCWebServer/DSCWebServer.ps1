configuration DSCWebServerConfig
{ 
    param (
        [string] $IISWebSite,
        [string] $FQDNs # comma separated list of FQDNs
    )
    
    Import-DscResource -ModuleName DSC_ColinsALMCorner.com, GraniResource

    $WebPiCmdPath = "${env:ProgramFiles}\Microsoft\Web Platform Installer\WebPiCmd-x64.exe"

    node "localhost"
    { 
        WindowsFeature IIS 
        { 
            Ensure = "Present" 
            Name = "Web-Server"                       
        } 

        # SelfSigned SSL Certificate
        # cert creation and binding must be done in a single pass
        cScriptWithParams Bind_SelfSignedSSLCertificate
        {
            cParams = @{
                IISWebSite = $IISWebSite
                FQDNs = $FQDNs
                port = '443'
            }
            GetScript = {
                $FQDNs_array = $FQDNs -split ','
                $primaryFqdn = $FQDNs_array[0]
                $binding = Get-WebBinding -Name $IISWebSite -Port $port -Protocol 'https' -HostHeader $primaryFqdn
                return @{ 'Result' = $binding }
            }
            SetScript = {
                $FQDNs_array = $FQDNs -split ','
                $primaryFqdn = $FQDNs_array[0]
                $cert = New-SelfSignedCertificate -DnsName $FQDNs_array -CertStoreLocation "cert:\LocalMachine\My"
                Write-Verbose "Created Certificate $($cert.Thumbprint)"
                Move-Item -Path "cert:\LocalMachine\My\$($cert.Thumbprint)" -Destination "cert:\LocalMachine\WebHosting"
                New-WebBinding -Name $IISWebSite -Protocol 'https' -Port $port -HostHeader $primaryFqdn
                $binding = Get-WebBinding -Name $IISWebSite -Port $port -Protocol 'https' -HostHeader $primaryFqdn
                $binding.AddSslCertificate($cert.Thumbprint, "WebHosting")
            }
            TestScript = {
                $binding = Get-WebBinding -Name $IISWebSite -Port $port -Protocol 'https'
                return $binding -ne $null
            }
        }

        cWebPILauncher Installv5
        {
        }
        <#
        cWebPi WebDeploy
        {
            DependsOn = '[cWebPILauncher]Installv5'
            Name = 'WDeploy'
        }
        #>
        Package WebDeploy_Installation
        {
            Ensure = "Present"
            DependsOn = "[cWebPILauncher]Installv5"
            Name = "Microsoft Web Deploy 3.5"
            Path = $WebPiCmdPath
            ProductId = ''
            Arguments = "/install /products:WDeploy /AcceptEula"
        }
    } 
}

#****************************************************
#	Lines below are used for debugging when running
#	on the VM.
#****************************************************
<#
$splat = @{
    IISWebSite = "Default Web Site"
    FQDNs = "demo.example.com","demos.example.com"
}
DSCWebServer @splat
Start-DscConfiguration ".\DSCWebServer" -Wait -Verbose -Force
#>