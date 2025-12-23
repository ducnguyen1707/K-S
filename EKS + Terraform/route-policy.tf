# A Route Table is a set of rules (called routes) that determine where network traffic 
# from your subnet or gateway is directed.
# Key Concepts:
#   - Routes: Define destinations (target networks) and where to send traffic
#   - Destination: The CIDR block or IP range the traffic is intended for
#   - Target: Where the traffic should be sent

#Private Route Table: Contains route to NAT Gateway (0.0.0.0/0 → NAT)
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.demo_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gw.id
    }
    tags = {
        "Name" = "${local.env}-private-route"
    }
}

#Public Route Table: Contains route to Internet Gateway (0.0.0.0/0 → IGW)
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.demo_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.demo_igw.id
    }
    tags = {
        "Name" = "${local.env}-public-route"
    }   
}

#Workflow:
#   1. Create Route Table with routing rules
#   2. Create Route Table Association to link it to a Subnet
#   3. Any instance in that subnet uses the associated route table's rules
#   4. Traffic is forwarded based on the matching route
resource "aws_route_table_association" "public_zone1" {
    subnet_id      = aws_subnet.public_zone1.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_zone2" {
    subnet_id      = aws_subnet.public_zone2.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_zone1" {
    subnet_id      = aws_subnet.private_zone1.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_zone2" {
    subnet_id      = aws_subnet.private_zone2.id
    route_table_id = aws_route_table.private.id
}