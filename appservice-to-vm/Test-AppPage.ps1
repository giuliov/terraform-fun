param(
    $pageUrl
)

try {
    $restResult = Invoke-RestMethod -UseBasicParsing -Method Get -Uri $pageUrl

    $result = @{
        succeeded = $restResult.html.body.p -like '*SUCCEEDED*'
    }
}
catch {
    $result = @{
        connection_error = $_.Exception.Message
    }
}
finally {

}
$result | ConvertTo-Json | Out-Default
