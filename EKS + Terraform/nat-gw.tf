resource "aws_eip" "nat_gw" {
    domain = "demo-vpc"
    tags = {
        Name = "${local.env}-nat-gw"
    }
}

resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.name.id
    subnet_id     = aws_subnet.public_zone1.id   #took ip in zone1
    tags = {
        Name = "${local.env}-nat-gw"
    }
    depends_on = [aws_internet_gateway.demo_igw]
}