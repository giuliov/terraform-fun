param (
    $yourArg
)

$res = @{
    prop1 = "something back"
    prop2 = "42"
    Ireceived = $yourArg
}

$res | ConvertTo-Json | Out-Default