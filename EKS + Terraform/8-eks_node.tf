# the permissions that allow nodes to join the cluster

resource "aws_iam_role" "nodes" {
  name ="${local.env}-${local.eks_name}-eks-nodes"
    assume_role_policy = <<POLICY
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
    }
    POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role       = aws_iam_role.nodes.name
}   
# Attaches worker node policy - Grants the necessary permissions for nodes to:
# Register with the EKS cluster
# Pull container images from ECR (Elastic Container Registry)

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role       = aws_iam_role.nodes.name
}
# CNI = Container Network Interface
# It's a networking standard that allows containers/pods to communicate with each other and the outside network.

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role       = aws_iam_role.nodes.name
}
//allow nodes to pull container images from ECR

resource "aws_eks_node_group" "general" {
    cluster_name = aws_eks_cluster.eks.name
    version = local.eks_version
    node_group_name = "general"
    node_role_arn = aws_iam_role.nodes.arn

    subnet_ids =[
        aws_subnet.private_zone1.id,
        aws_subnet.private_zone2.id
    ]

    capacity_type = "ON_DEMAND"
    instance_types =    ["t3.medium"]

    scaling_config {
      desired_size = 1
      max_size = 10
      min_size = 0
    }
    update_config {
      max_unavailable = 1
    }

    labels ={
        role = "general"
    }

    depends_on = [
        aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
        aws_iam_role_policy_attachment.amazon_eks_cni_policy,
        aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
    ]

//Allow external changes without TF plan different
    lifecycle {
      ignore_changes = [scalling_config[0].desired_size]
    }
}