function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$AgentName,

		[parameter(Mandatory = $true)]
		[System.String]
		$PoolName,

		[parameter(Mandatory = $true)]
		[System.String]
		$ServerUrl,

		[parameter(Mandatory = $true)]
		[System.String]
		$PAT,

		[parameter(Mandatory = $true)]
		[System.String]
		$AgentFolder,
		
		[parameter(Mandatory = $true)]
		[System.Boolean]
		$RunAsWindowsService,
		
		<#
		[parameter(Mandatory = $true)]
		[PSCredential]
		$WindowsServiceCredential
		#>
		[parameter(Mandatory = $true)]
		[System.String]
		$ServiceAccountUser,
		[parameter(Mandatory = $true)]
		[System.String]
		$ServiceAccountPassword
	)
	
	# Try to find the agent in the specified folder
	Write-Verbose "Locating agent in agent folder $AgentFolder"
	if (Test-Path $AgentFolder) {
		# Make sure that a settings.json file exists at the location
		$settingsJsonFile = Join-Path $AgentFolder "settings.json"
		if (Test-Path $settingsJsonFile) {
			# Get the settings from the file
			$settings = Get-Content -Raw $settingsJsonFile | ConvertFrom-Json
			$AgentName = $settings.AgentName
			$PoolName = $settings.PoolName
			$ServerUrl = $settings.ServerUrl
			$AgentFolder = $AgentFolder
			$RunAsWindowsService = [System.Convert]::ToBoolean($settings.RunAsWindowsService)
			$ensure = "Present"
		} else {
			# No settings.json file found, so we have no idea if there's an agent here
			Write-Verbose "No settings.json found in agent folder $AgentFolder"
			$ensure = "Absent"	
		}
	} else {
		# Agent folder wasn't found, so we're pretty sure it doesn't exist
		Write-Verbose "No agent found in agent folder $AgentFolder"
		$ensure = "Absent"
	}

	$returnValue = @{
		AgentName = $AgentName
		Ensure = $ensure
		PoolName = $PoolName
		ServerUrl = $ServerUrl
		AgentFolder = $AgentFolder
		RunAsWindowsService = $RunAsWindowsService
	}

	$returnValue
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$AgentName,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure,

		[parameter(Mandatory = $true)]
		[System.String]
		$PoolName,

		[parameter(Mandatory = $true)]
		[System.String]
		$ServerUrl,

		[parameter(Mandatory = $true)]
		[System.String]
		$PAT,

		[parameter(Mandatory = $true)]
		[System.String]
		$AgentFolder,
		
		[parameter(Mandatory = $true)]
		[System.Boolean]
		$RunAsWindowsService,
		
		<#
		[parameter(Mandatory = $true)]
		[PSCredential]
		$WindowsServiceCredential
		#>
		[parameter(Mandatory = $true)]
		[System.String]
		$ServiceAccountUser,
		[parameter(Mandatory = $true)]
		[System.String]
		$ServiceAccountPassword
	)
	
	# Check if we need to ensure the agent is present or absent
	if ($Ensure -eq "Present") {
		# Ensure that the agent folder exists
		Write-Verbose "Checking if agent folder $AgentFolder already exists..."
		if (!(Test-Path $AgentFolder)) {
			# Create the agent folder
			Write-Verbose "Creating agent folder $AgentFolder"
			md $AgentFolder
			
			# Download the agent from the server
			# HACK !!!!
			$agentDownloadUrl = 'https://go.microsoft.com/fwlink/?linkid=851123'
			Write-Verbose "Downloading agent from $agentDownloadUrl to $AgentFolder\agent.zip"
			Invoke-WebRequest $agentDownloadUrl -OutFile "$AgentFolder\agent.zip" -UseBasicParsing #-Credential $WindowsServiceCredential
			
			Write-Verbose "Unzipping agent into $AgentFolder"
			# Unzip the agent
			Expand-Archive -LiteralPath "$AgentFolder\agent.zip" -DestinationPath $AgentFolder
			
			# Delete the zip
			Remove-Item "$AgentFolder\agent.zip"
			$reconfigure = $False
		} else {
			# Agent folder already exists
			Write-Verbose "Agent folder $AgentFolder already exists. Assuming reconfiguration."
			$reconfigure = $True
		}
				
		# Run the configuration
		Push-Location $AgentFolder		
		Write-Verbose ".\config.cmd --unattended --url $ServerUrl --auth PAT --token *** --pool $poolName --agent $AgentName --runasservice --windowslogonaccount $serviceAccountUser --windowslogonpassword ***"
        .\config.cmd --unattended --url $ServerUrl --auth PAT --token $PAT --pool $poolName --agent $AgentName --runasservice --windowslogonaccount $serviceAccountUser --windowslogonpassword $serviceAccountPassword	
		Pop-Location
		
	} elseif ($Ensure -eq "Absent") {
		# Unconfigure the agent
		Write-Verbose ".\config.cmd remove"
		.\config.cmd remove
			
		# Remove the agent
		Remove-Item "$AgentFolder" 
	}	
}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$AgentName,

		[ValidateSet("Present","Absent")]
		[System.String]
		$Ensure,

		[parameter(Mandatory = $true)]
		[System.String]
		$PoolName,

		[parameter(Mandatory = $true)]
		[System.String]
		$ServerUrl,

		[parameter(Mandatory = $true)]
		[System.String]
		$PAT,

		[parameter(Mandatory = $true)]
		[System.String]
		$AgentFolder,
		
		[parameter(Mandatory = $true)]
		[System.Boolean]
		$RunAsWindowsService,
		
		<#
		[parameter(Mandatory = $true)]
		[PSCredential]
		$WindowsServiceCredential
		#>
		[parameter(Mandatory = $true)]
		[System.String]
		$ServiceAccountUser,
		[parameter(Mandatory = $true)]
		[System.String]
		$ServiceAccountPassword
	)

	# Try to find the agent in the specified folder
	Write-Verbose "Locating agent in agent folder $AgentFolder"
	if (Test-Path $AgentFolder) {
		# Make sure that a settings.json file exists at the location
		$settingsJsonFile = Join-Path $AgentFolder ".agent"
		if (Test-Path $settingsJsonFile) {
			# Get the settings from the file
			$settings = Get-Content -Raw $settingsJsonFile | ConvertFrom-Json
			$currentAgentName = $settings.AgentName
			#$currentPoolName = $settings.PoolName now it is a poolId :-(
			$currentServerUrl = $settings.ServerUrl
			$currentAgentFolder = $AgentFolder
			$currentRunAsWindowsService = Test-Path "${AgentFolder}\.service"
			$currentEnsure = "Present"
		} else {
			# No settings.json file found, so we have no idea if there's an agent here
			Write-Verbose "No .agent file found in agent folder $AgentFolder"
			$currentEnsure = "Absent"	
		}
	} else {
		# Agent folder wasn't found, so we're pretty sure it doesn't exist
		Write-Verbose "No agent found in agent folder $AgentFolder"
		$currentEnsure = "Absent"
	}

	#$result = ($currentEnsure -eq $Ensure) -And ($currentAgentName -eq $AgentName) -And ($currentPoolName -eq $PoolName) -And `
	#		  ($currentServerUrl -eq $ServerUrl) -And ($currentAgentFolder -eq $AgentFolder) -And ($currentRunAsWindowsService -eq $RunAsWindowsService)
	$result = ($currentEnsure -eq $Ensure) -And ($currentAgentName -eq $AgentName) -And `
			  ($currentServerUrl -eq $ServerUrl) -And ($currentAgentFolder -eq $AgentFolder) -And ($currentRunAsWindowsService -eq $RunAsWindowsService)
	
	$result
}


Export-ModuleMember -Function *-TargetResource

