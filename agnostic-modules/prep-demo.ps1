az --version
terraform --version

az login
az account set --subscription "Microsoft Azure Sponsorship"

az group create --name "rg-app3" --location northeurope
az network vnet create --name "vnet-app2" --resource-group "rg-app3" --location northeurope
az network vnet subnet create --name "subnet-app2-2" --vnet-name "vnet-app2" --resource-group "rg-app3" --address-prefixes "10.0.2.0/24"


#aws ec2 describe-images --owners "amazon" --filters "Name=platform,Values=windows" "Name=state,Values=available" --query "sort_by(Images, &CreationDate)[-1].[ImageId]" --output "text" --region "eu-west-1"
#aws ec2 describe-images --owners "amazon" --filters "Name=platform,Values=windows" "Name=state,Values=available" --query "sort_by(Images, &CreationDate)[-1].[ImageId]" --output "text" --region "eu-west-1"

aws ec2 describe-vpcs --query "Vpcs[*].VpcId"

$vpcId = $( aws ec2 create-vpc --cidr-block "10.0.0.0/16" --region "eu-west-1" --query "Vpc.VpcId" --output "text" )
aws ec2 create-tags --resources $vpcId --tags "Key=Name,Value=vnet-app2"
$subnetId = $( aws ec2 create-subnet --vpc-id $vpcId --cidr-block "10.0.2.0/24" --query "Subnet.SubnetId" --output "text" )
aws ec2 create-tags --resources $subnetId --tags "Key=Name,Value=subnet-app2-2"

aws ec2 delete-subnet --subnetId-id $subnetIdId
aws ec2 delete-vpc --vpc-id $vpcId

