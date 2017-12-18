param (
    [Parameter(Mandatory=$true)]
    [string] $StorageAccountName,
    [Parameter(Mandatory=$true)]
    [string] $Container,
    [Parameter(Mandatory=$true)]
    [string] $StorageAccountKey,
    [Parameter(Mandatory=$true)]
    [string] $SourceFolder
)

$new_files = @()
$updated_files = @()
$unchanged_files = @()

# check local state before trying to upload
$stateChangeFile = ".terraform/upload.lastchange"
$sourceChange = (Get-ChildItem $SourceFolder | sort -Property LastWriteTime -Descending | select -First 1).LastWriteTime
$stateChange = (Get-Item $stateChangeFile -ErrorAction SilentlyContinue).LastWriteTime

if ($stateChange -lt $sourceChange) {

    $ctx = New-AzureStorageContext -StorageAccountName "${StorageAccountName}" -StorageAccountKey ${StorageAccountKey}
    $alreadyThere = Get-AzureStorageBlob -Container $Container -Context $ctx

    Get-ChildItem $SourceFolder | foreach {
        $sourceFile = $_
        $blob = $alreadyThere | where { $_.Name -eq $sourceFile.Name }
        if ($blob -and ($sourceFile.LastWriteTime.ToFileTimeUtc() -gt $blob.LastModified.UtcDateTime.ToFileTimeUtc())) {
            Write-Verbose "Refreshing $( $sourceFile.Name ) in '${Container}'."
            Set-AzureStorageBlobContent -File $sourceFile.FullName -Container "${Container}" -Context $ctx -Force | Out-Null
            $updated_files += ($sourceFile | Resolve-Path -Relative)
        } elseif (!$blob) {
            Write-Verbose "Uploading $( $sourceFile.Name ) to '${Container}'."
            Set-AzureStorageBlobContent -File $sourceFile.FullName -Container "${Container}" -Context $ctx -Force | Out-Null
            $new_files += ($sourceFile | Resolve-Path -Relative)
        } else {
            Write-Verbose "$( $sourceFile.Name ) is up to date."
            $unchanged_files += ($sourceFile | Resolve-Path -Relative)
        }
    }

    Set-Content -Path $stateChangeFile -Value (Get-Date -Format 'u')
}

$result = @{
    new_files = $new_files -join ","
    updated_files = $updated_files -join ","
    unchanged_files = $unchanged_files -join ","
}
$result | ConvertTo-Json | Out-Default
