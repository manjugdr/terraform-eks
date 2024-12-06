
output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks_cluster.certificate_authority
}

output "cluster-arn" {
  value = aws_eks_cluster.eks_cluster.arn
}
output "cluster-endpoint"{
    value = aws_eks_cluster.eks_cluster.endpoint
}
output "cluster-status" {
  value =  aws_eks_cluster.eks_cluster.status
}

output "ekslbcontroller_iampolicyarn" {
value = aws_iam_policy.aws_loadbalancer_controller_iam_policy.arn
}
output "clustername" {
  value =  aws_eks_cluster.eks_cluster.name
}
output "eks_cluster_serverurl" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.eks_cluster.endpoint
}
