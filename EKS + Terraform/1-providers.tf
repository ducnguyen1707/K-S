# Configures the AWS provider with the region defined in local variables
# This provider handles all AWS API calls for resource creation and management
provider "aws" {
  region = local.region
}

# Defines Terraform version constraints and required providers
terraform {
    required_version = ">=1.13"
     # AWS Provider Configuration
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = ">= 6.27.0"    # latest
        }
    }
}