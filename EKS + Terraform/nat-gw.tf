resource "aws_eip" "nat_gw" {
    domain = "vpc"
    tags = {
        Name = "${local.env}-nat-gw"
    }
}

resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_gw.id #EIP stands for Elastic IP
    subnet_id     = aws_subnet.public_zone1.id   #took ip in zone1
    tags = {
        Name = "${local.env}-nat-gw"
    }
    depends_on = [aws_internet_gateway.demo_igw]
}