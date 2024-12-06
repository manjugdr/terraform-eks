###EKS Cluster

resource "aws_iam_role" "eks_cluster_role" {
  name = var.eks_cluster_rolename
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}


###EKS Node

resource "aws_iam_role" "eks_nodes" {
  name = var.eks_node_rolename

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

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEFSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.eks_nodes.name
}
resource "aws_iam_role_policy_attachment" "AmazonS3FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.eks_nodes.name
}
resource "aws_iam_role_policy_attachment" "AmazonElastiCacheFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonElastiCacheFullAccess"
  role       = aws_iam_role.eks_nodes.name
}
resource "aws_iam_role_policy_attachment" "SecretsManagerReadWrite" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.eks_nodes.name
}
# Create a custom IAM policy for cluster Autoscaler that needs to be attached with EKSNodeRole

data "local_file" "aws_clusterautoscaler_iam_policy_file" {
  filename = "${path.module}/aws_clusterautoscaler_iam_policy.json"  # Path to your policy.json file
}

resource "aws_iam_policy" "aws_clusterautoscaler_iam_policy" {
  name        = var.eksclusterautoscaler_iampolicyname  # AWSClusterAutoScalerIAMPolicy
  description = "Custom IAM Policy for AWS Load Balancer Controller"
  policy      = data.local_file.aws_clusterautoscaler_iam_policy_file.content
}

resource "aws_iam_role_policy_attachment" "AWSClusterAutoScalerIAMPolicy" {
  policy_arn = aws_iam_policy.aws_clusterautoscaler_iam_policy.arn
  role       = aws_iam_role.eks_nodes.name   #Attach with EKS Node Role
}

# Create a custom IAM policy - AWSLoadBalancerControllerIAMPolicy

data "local_file" "aws_loadbalancer_controller_iam_policy_file" {
  filename = "${path.module}/aws_loadbalancer_controller_iam_policy.json"  # Path to your policy.json file
}

resource "aws_iam_policy" "aws_loadbalancer_controller_iam_policy" {
  name        = var.ekslbcontroller_iampolicyname  # AWSLoadBalancerControllerIAMPolicy
  description = "Custom IAM Policy for AWS Load Balancer Controller"
  policy      = data.local_file.aws_loadbalancer_controller_iam_policy_file.content
}
