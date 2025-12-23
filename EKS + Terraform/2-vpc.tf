# Creates a Virtual Private Cloud (VPC)
resource "aws_vpc" "demo_vpc" {
    cidr_block = "192.0.0.0/24" # 256 IP addresses
    enable_dns_hostnames = true
    enable_dns_support = true
# Resource Tags: Applies metadata for identificatio
    tags = {
        Name = "${local.env}-demo-vpc"
    }
}