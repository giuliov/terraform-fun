Login-AzureRMAccount

$locName="northeurope"
Get-AzureRMVMImagePublisher -Location $locName | Select PublisherName

$pubName="MicrosoftWindowsServer"
Get-AzureRMVMImageOffer -Location $locName -Publisher $pubName | Select Offer

$offerName="WindowsServer"
$offerName="WindowsServerSemiAnnual"
Get-AzureRMVMImageSku -Location $locName -Publisher $pubName -Offer $offerName | Select Skus