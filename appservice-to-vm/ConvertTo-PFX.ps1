$DEBUG = $true

if ($DEBUG) { Set-Content "ConvertTo-PFX.log" "ENTERED" }

try {
    # Read stdin as string
    $jsonPayload = [Console]::In.ReadLine()
    if ($DEBUG) { Add-Content "ConvertTo-PFX.log" $jsonPayload }
    $query = ConvertFrom-Json $jsonPayload
    Set-Content -NoNewline -Encoding ascii -Force -Value $query.certificate_pem -Path "bob_cert.cert"
    Set-Content -NoNewline -Encoding ascii -Force -Value $query.private_key_pem -Path "bob_key.pem"

    openssl pkcs12 -inkey bob_key.pem -in bob_cert.cert -export -passout pass:${query.password} -out bob_pfx.pfx

    if ($DEBUG) { Add-Content "ConvertTo-PFX.log" "loading bob_pfx.pfx" }
    $pfxBlob = Get-Content -Raw "bob_pfx.pfx"
    $cert = Get-PfxCertificate -FilePath "bob_pfx.pfx"

    $pfxBase64 = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($pfxBlob))
    if ($DEBUG) { Add-Content "ConvertTo-PFX.log" 'pfxBase64', $pfxBase64 }
    # this is the same as bob_cert.cert stripped of -----BEGIN CERTIFICATE----- -----END CERTIFICATE----- tags
    $x509Base64 = [System.Convert]::ToBase64String($cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))
    if ($DEBUG) { Add-Content "ConvertTo-PFX.log" 'x509Base64', $x509Base64 }

    if (-not $DEBUG) { Remove-Item 'bob_*.*' }

    $result = @{
        cert_thumbprint = $cert.Thumbprint
        pfx_base64      = $pfxBase64
        cert_base64     = $x509Base64
    }
}
catch {
    if ($DEBUG) { Add-Content "ConvertTo-PFX.log" $_.Exception }
    Write-Error $_.Exception.Message
    exit 1
}

$jsonResult = $result | ConvertTo-Json
if ($DEBUG) { Add-Content "ConvertTo-PFX.log" "Returning $jsonResult" }
$jsonResult | Out-Default

if ($DEBUG) { Add-Content "ConvertTo-PFX.log" "exiting" }
