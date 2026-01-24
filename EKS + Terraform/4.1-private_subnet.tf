 # Tags provide metadata for resource identification, management, and cost tracking
# Key-value pairs that help organize and filter AWS resources
# Tag Details:
    #   - Key: "Name" - AWS convention for displaying resource name in console
    #   - Value: "${local.env}-demo-vpc" - Dynamic value from local variables
    #   - Interpolation: ${local.env} substitutes "staging" from locals
    #   - Result: "staging-demo-vpc" (human-readable identifier)

resource "aws_subnet" "private_zone1" {
    vpc_id            = aws_vpc.demo_vpc.id
    cidr_block        = "192.0.0.128/26"  # 128 - 191
    availability_zone = local.zone1 
   
    tags = {
        "Name" = "${local.env}-private-${local.zone1}"
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
    }
}

resource "aws_subnet" "private_zone2" {
    vpc_id            = aws_vpc.demo_vpc.id
    cidr_block        = "192.0.0.192/26"  # 192-255
    availability_zone = local.zone2
    tags = {
        "Name" = "${local.env}-private-${local.zone2}"
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/${local.env}-${local.eks_name}" = "owned"
    }
  
}