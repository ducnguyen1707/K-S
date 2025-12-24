# Components in this VPC
- VPC: 1 (main network container)
- Subnets: 4
- 2 Public (for load balancers, NAT gateways)
  2 Private (for EKS nodes, databases)
- Internet Gateway: 1 (for public subnet internet access)
- NAT Gateway: 2 (one per public subnet/AZ, for private subnet outbound internet)
- Route Tables: At least 2 (public and private)
  Route Table Associations: 4 (each subnet associated with a route table)

# How the Traffic Works
# Outbound Traffic (from Private Subnets)
    EKS nodes (or other resources) in private subnets cannot access the internet directly.
    When a node in a private subnet needs to reach the internet (e.g., for updates, pulling images)

    Traffic is routed to the NAT Gateway in the corresponding public subnet (via the private route table).

    The NAT Gateway forwards the traffic to the Internet Gateway.

    The response returns through the NAT Gateway to the private subnet.
# Inbound Traffic (from Internet)
    Public subnets can receive traffic from the internet via the Internet Gateway.

    Typically, only load balancers (ALB/NLB) or NAT Gateways are placed in public subnets.

    Private subnets do not accept direct inbound traffic from the internet.
    Load Balancer Traffic
    
    External users access your application via a load balancer in a public subnet.
    The load balancer forwards traffic to EKS nodes in private subnets.


# Total VPC Hourly Cost
Minimum (idle): $0.064/hour
With traffic:   $0.074-$0.10/hour (depends on data volume)