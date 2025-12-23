# Local variables for the Terraform configuration
# These values are used across multiple resources and modules
locals {
    env = "staging"
    region = "ap-southeast-1"
    zone1 = "ap-southeast-1a"
    zone2 = "ap-southeast-1b"
    eks_name = "eks-terraform-demo"
    eks_version = "1.34"
}