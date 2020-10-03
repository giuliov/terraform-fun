# this script creates the resources required for the demo

az --version
terraform --version

az login
az account set --subscription "Microsoft Azure Sponsorship"

az group create --name "rg-app3" --location northeurope
az network vnet create --name "vnet-app2" --resource-group "rg-app3" --location northeurope
az network vnet subnet create --name "subnet-app2-2" --vnet-name "vnet-app2" --resource-group "rg-app3" --address-prefixes "10.0.2.0/24"


aws configure
#aws ec2 describe-images --owners "amazon" --filters "Name=platform,Values=windows" "Name=state,Values=available" --query "sort_by(Images, &CreationDate)[-1].[ImageId]" --output "text" --region "eu-west-1"
#aws ec2 describe-images --owners "amazon" --filters "Name=platform,Values=windows" "Name=state,Values=available" --query "sort_by(Images, &CreationDate)[-1].[ImageId]" --output "text" --region "eu-west-1"

aws ec2 describe-vpcs --query "Vpcs[*].VpcId"
### default VPC use 172.31.0.0/16

# IE region
$vpcId = $( aws ec2 create-vpc --cidr-block "10.0.0.0/16" --region "eu-west-1" --query "Vpc.VpcId" --output "text" )
aws ec2 create-tags --resources $vpcId --tags "Key=Name,Value=vnet-app2" --region "eu-west-1"
$subnetId = $( aws ec2 create-subnet --vpc-id $vpcId --region "eu-west-1" --cidr-block "10.0.2.0/24" --query "Subnet.SubnetId" --output "text" )
aws ec2 create-tags --resources $subnetId --tags "Key=Name,Value=subnet-app2-2" --region "eu-west-1"

# UK region
$vpcId = $( aws ec2 create-vpc --cidr-block "10.1.0.0/16" --region "eu-west-2" --query "Vpc.VpcId" --output "text" )
aws ec2 create-tags --resources $vpcId --tags "Key=Name,Value=vnet-app2" --region "eu-west-2"
$subnetId = $( aws ec2 create-subnet --vpc-id $vpcId --region "eu-west-2" --cidr-block "10.1.2.0/24" --query "Subnet.SubnetId" --output "text" )
aws ec2 create-tags --resources $subnetId --tags "Key=Name,Value=subnet-app2-2" --region "eu-west-2"



# clean up after
az group delete --name "rg-app3"
aws ec2 delete-subnet --subnetId-id $subnetIdId
aws ec2 delete-vpc --vpc-id $vpcId

