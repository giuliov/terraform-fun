configuration VstsAgentConfiguration
{
    Param (
        [Parameter(Mandatory)]
        [string]    $vstsUrl,
        #[Parameter(Mandatory)]
        [string]    $PAT_AutomationCredential,
        #[Parameter(Mandatory)]
        [string]    $ServiceAccount_AutomationCredential,
        [Parameter(Mandatory)]
        [string]    $poolName,
        [Parameter(Mandatory)]
        [string]    $tag,
        # optional to use for local testing where you lack access to Automation Credential
        [PSCredential]  $PATCredential,
        [PSCredential]  $ServiceAccountCredential
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration,VSTS

    $agentDir = 'C:\vstsagent'

    if ($PATCredential -eq $null) {
        $PATCredential = Get-AutomationPSCredential $PAT_AutomationCredential
    }
    if ($ServiceAccountCredential -eq $null) {
        $ServiceAccountCredential = Get-AutomationPSCredential $ServiceAccount_AutomationCredential
    }

    node "localhost"
    {
        User AgentUser
        {
            Ensure    = "Present"
            UserName = $ServiceAccountCredential.UserName
            Password = $ServiceAccountCredential
            PasswordNeverExpires = $true
            PasswordChangeRequired = $false
            PasswordChangeNotAllowed = $true
        }
        Group Administrators
        {
            Ensure    = "Present"
            DependsOn = "[User]AgentUser"
            GroupName = "Administrators"
            MembersToInclude = $ServiceAccountCredential.UserName
        }
        cVstsAgent Agent
        {
            Ensure      = "Present"
            DependsOn   = "[User]AgentUser"
            AgentName   = "${poolName}-${tag}-${env:COMPUTERNAME}"
            PoolName    = $poolName
            ServerUrl   = $vstsUrl
            PAT         = $PATCredential.GetNetworkCredential().Password
            AgentFolder = $agentDir
            RunAsWindowsService    = $true
            ServiceAccountUser     = $ServiceAccountCredential.UserName
            ServiceAccountPassword = $ServiceAccountCredential.GetNetworkCredential().Password
        }
        
    }#node
}#configuration
