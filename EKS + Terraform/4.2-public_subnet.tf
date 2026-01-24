resource "aws_subnet" "public_zone1" {
    vpc_id            = aws_vpc.demo_vpc.id
    cidr_block        = "192.0.0.0/26"  # 0-63
    availability_zone = local.zone1
    map_public_ip_on_launch = true #Automatically assigns a public IP address to EC2 instances launched in this subnet
# Behavior:
    #   - When set to true: Each instance launched receives a unique public IPv4 address
    #   - When set to false: Instances only get private IPs (require manual Elastic IP assignment)

    tags = {
        "Name" = "${local.env}-public-${local.zone1}"
        "kubernetes.io/role/elb" = "1"
        "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
    }
}

resource "aws_subnet" "public_zone2" {
    vpc_id            = aws_vpc.demo_vpc.id
    cidr_block        = "192.0.0.64/26"  # 64-127
    availability_zone = local.zone2
    map_public_ip_on_launch = true

    tags = {
        "Name" = "${local.env}-public-${local.zone2}"
        "kubernetes.io/role/elb" = "1"
        "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
    }
}