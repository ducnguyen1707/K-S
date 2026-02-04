# Creates an AWS IAM user named "developer"
# This user can have access keys and login credentials
resource "aws_iam_user" "dev" {
  name = "developer"
}

//CREATE IAM POLICY
resource "aws_iam_policy" "dev_policy" {
  name        = "developer-policy"
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "eks:DescribeCluster",
          "eks:ListClusters",
        ],
        "Resource": "*"
      }
    ]
  }
POLICY
}

# Attach to the "developer" user
resource "aws_iam_user_policy_attachment" "dev_eks" {
  user       = aws_iam_user.dev.name
  policy_arn = aws_iam_policy.dev_policy.arn
}

resource "aws_eks_access_entry" "dev" {
    # Link to EKS cluster
    cluster_name = aws_eks_cluster.eks.name
    principal_arn = aws_iam_user.dev.arn

    # Assign Kubernetes group "my-viewer"
    # This group must have RBAC role binding in Kubernetes
    kubernetes_groups = ["my-viewer"]
}