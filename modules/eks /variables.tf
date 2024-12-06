variable "environment" {
  description = "Environment -Dev/QA/Stage/Prod"
}
variable "project_name" {
  description = "ProjectName" 
}
variable "map_migrated" {
  description = "MAP migration ID"
}
variable "aws_region" {
    description = "aws eks cluster region"
}
#eks-cluster

variable "eks_cluster_name" {
    type = string
}
variable "eks_cluster_version" {
    type = string
}
variable "vpc_id" {
    type = string
}
variable "subnet_ids_for_eks_cluster" {
    type = list(string)
}
variable "subnet_ids_for_eks_cluster_node_group" {
    type = list(string)
}
variable "vpcconfig_endpoint_privateaccess" {
    type = string
}
variable "vpcconfig_endpoint_publicaccess" {
    type = string
}
variable "public_subnet_ids" {
  description = "vpc public subnet ID"
}
variable "private_subnet_ids" {
  description = "vpc private subnet ID"
}

# EKS-IAM info
variable "eks_cluster_rolename" {
    type = string
}
variable "eks_node_rolename" {
    type = string
}
#EKS - launch template

variable "eks_node_launchtemplate_name" {
    type = string
}

# EKS-default nodes
variable "default_node_group_name" {
    type = string
}
variable "default_node_group_instance_type" {
    type = list(string)
} 
variable "default_node_disk_size" {
    type = number
}
variable "eks_desired_size_default_node" {
    type = number
}
variable "eks_max_size_default_node" {
    type = number
}
variable "eks_min_size_default_node" {
    type = number
}

# EKS - custom nodegroups
variable "custom_node_group_name" {
    type = list(string)
}
variable "custom_node_group_instance_type" {
    type = list(string)
}
variable "custom_node_disk_size" {
    type = list(number)
}
variable "eks_desired_size_custom_node" {
    type = list(number)
}
variable "eks_min_size_custom_node" {
    type = list(number)
}
variable "eks_max_size_custom_node" {
    type = list(number)
}

#eks-ebs
variable "ebs_rootvol_size" {
  type = map
}
variable "ebs_vol_type" {
  type = map
}

#EKS-sg
variable "eksclustersg_ingress_rules" {
    type = map
}
variable "eksworkernodesg_ingress_rules" {
    type = map
}
#EKS-aws load balancer controller

variable "ekslbcontroller_iamrolename" {
    type = string
}
variable "ekslbcontroller_iampolicyname" {
    type = string
}

#EKS - aws clusterautoscaler-policyname
variable "eksclusterautoscaler_iampolicyname" {
    type = string
}

#bastionhost role to be added to eks config map
/*variable "bastionhost_iamrole_name" {
    type = string
}*/
