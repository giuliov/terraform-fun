param(
    $sqlConnectionString
)

try {
    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection $sqlConnectionString
    $sqlConnection.Open()
    $sqlCommand = New-Object System.Data.SqlClient.SqlCommand "SELECT @@version"
    $sqlCommand.Connection = $sqlConnection
    $reader = $sqlCommand.ExecuteReader()
    $reader.Read() | Out-Null

    $result = @{
        sql_version = $reader.GetString(0)
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
