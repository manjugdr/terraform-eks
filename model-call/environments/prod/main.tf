module "eks" {
  source = "../../../../modules/eks"
  environment = var.environment
  project_name = var.project_name
  map_migrated = var.map_migrated
  aws_region = var.aws_region
  eks_cluster_name = var.eks_cluster_name
  eks_cluster_version = var.eks_cluster_version  
  vpcconfig_endpoint_privateaccess = var.vpcconfig_endpoint_privateaccess
  vpcconfig_endpoint_publicaccess = var.vpcconfig_endpoint_publicaccess
  eks_cluster_rolename = var.eks_cluster_rolename
  eks_node_rolename = var.eks_node_rolename
  # Referencing VPC output from remote state
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids_for_eks_cluster = concat(data.terraform_remote_state.vpc.outputs.private_subnet_ids, data.terraform_remote_state.vpc.outputs.public_subnet_ids)
  subnet_ids_for_eks_cluster_node_group = data.terraform_remote_state.vpc.outputs.private_subnet_ids[*]
  public_subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  eks_node_launchtemplate_name     = var.eks_node_launchtemplate_name
  default_node_group_name          = var.default_node_group_name
  default_node_group_instance_type = var.default_node_group_instance_type
  default_node_disk_size           = var.default_node_disk_size
  eks_desired_size_default_node    = var.eks_desired_size_default_node
  eks_max_size_default_node        = var.eks_max_size_default_node
  eks_min_size_default_node        = var.eks_min_size_default_node

  custom_node_group_name = var.custom_node_group_name
  custom_node_group_instance_type = var.custom_node_group_instance_type
  custom_node_disk_size = var.custom_node_disk_size
  eks_desired_size_custom_node = var.eks_desired_size_custom_node
  eks_min_size_custom_node = var.eks_min_size_custom_node
  eks_max_size_custom_node = var.eks_max_size_custom_node

  ebs_rootvol_size = var.ebs_rootvol_size
  ebs_vol_type = var.ebs_vol_type

  eksclustersg_ingress_rules = var.eksclustersg_ingress_rules
  eksworkernodesg_ingress_rules = var.eksworkernodesg_ingress_rules
  
  ekslbcontroller_iamrolename = var.ekslbcontroller_iamrolename
  ekslbcontroller_iampolicyname = var.ekslbcontroller_iampolicyname
  eksclusterautoscaler_iampolicyname = var.eksclusterautoscaler_iampolicyname

  depends_on = [
    data.terraform_remote_state.vpc
  ]
}
module "rds" {
  source = "../../../../modules/rds"
  environment = var.environment
  project_name = var.project_name  
  map_migrated = var.map_migrated
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id 
  rds_subnetgroup_name = var.rds_subnetgroup_name
  rdssg_ingress_rules = var.rdssg_ingress_rules
  subnet_ids_for_rds = data.terraform_remote_state.vpc.outputs.private_subnet_ids[*]
  rds_db_count = var.rds_db_count 
  rds_db_allocated_storage = var.rds_db_allocated_storage
  rds_db_engine = var.rds_db_engine
  rds_db_engine_version = var.rds_db_engine_version
  rds_db_instancetype = var.rds_db_instancetype
  rds_db_identifier = var.rds_db_identifier
  rds_db_storagetype = var.rds_db_storagetype 
  rds_db_username = var.rds_db_username
  rds_db_password = var.rds_db_password
  rds_db_is_skipfinalsnapshot = var.rds_db_is_skipfinalsnapshot
  rds_db_is_publicaccess = var.rds_db_is_publicaccess
  rds_db_max_allocated_storage = var.rds_db_max_allocated_storage
  rds_db_is_performance_insights_enabled = var.rds_db_is_performance_insights_enabled
  rds_db_performance_insights_retention_period = var.rds_db_performance_insights_retention_period

  rds_db_backup_retention_period = var.rds_db_backup_retention_period
  rds_db_backup_window = var.rds_db_backup_window
  rds_db_storage_encrypted = var.rds_db_storage_encrypted
  rds_db_copy_tags_to_snapshot = var.rds_db_copy_tags_to_snapshot
  rds_db_enable_multi_az = var.rds_db_enable_multi_az
  rds_db_deletion_protection = var.rds_db_deletion_protection
  rds_db_enabled_cloudwatch_logs_exports = var.rds_db_enabled_cloudwatch_logs_exports

  depends_on = [
    data.terraform_remote_state.vpc
  ]  
}
module "ec2mongo" {
  source = "../../../../modules/ec2mongo"
  environment = var.environment
  project_name = var.project_name
  map_migrated = var.map_migrated
  aws_region = var.aws_region
  # Referencing VPC output from remote state
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids[*]
  associate_public_ip_address = var.associate_public_ip_address
  keypairname = var.keypairname
  instanceType = var.instanceType
  //ec2mongo_iamrole_name = var.ec2mongo_iamrole_name
  //ec2mongo_iaminstanceprofile_name = var.ec2mongo_iaminstanceprofile_name
  bastionhost_privateip = data.terraform_remote_state.ec2.outputs.bastionhost_privateip
  ec2mongosg_ingress_rules = var.ec2mongosg_ingress_rules
  ebs_rootvol_size = var.ebs_rootvol_size
  ebs_vol_type = var.ebs_vol_type
  
  depends_on = [ 
    data.terraform_remote_state.vpc,
    data.terraform_remote_state.ec2   //bastionhost to fetch private ip for ssh access
  ]
}
module "remoteprovisioner" {
  source = "../../../../modules/remoteprovisioner"
  aws_region = var.aws_region
  project_name = var.project_name  
  map_migrated = var.map_migrated
  # Referencing VPC output from remote state
  aws_access_key_id = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
  eks_cluster_name = var.eks_cluster_name
  ekslbcontroller_iamrolename = var.ekslbcontroller_iamrolename
  ekslbcontroller_serviceaccountname = var.ekslbcontroller_serviceaccountname
  ekslbcontroller_iampolicyarn = module.eks.ekslbcontroller_iampolicyarn
  bastionhost_publicip = data.terraform_remote_state.ec2.outputs.bastionhost_publicip
  argocd_clustername =data.terraform_remote_state.eks.outputs.clustername
  eks_applicationcluster_url = module.eks.eks_cluster_serverurl
  eks_cluster_arn = module.eks.cluster-arn
  eks_cluster_namespace = var.eks_cluster_namespace
  github_username = var.github_username
  github_password = var.github_password
  argocd_application_helmrepo = var.argocd_application_helmrepo
  argocd_application_helmvalues_filename = var.argocd_application_helmvalues_filename
  argocd_application_helmservicename-with-path = var.argocd_application_helmservicename-with-path
  depends_on = [
    data.terraform_remote_state.vpc,
    module.eks,
    data.terraform_remote_state.ec2,
    data.terraform_remote_state.eks,
    module.rds
  ]
}
module "ecr" {
  source = "../../../../modules/ecr"
  project_name = var.project_name  
  environment = var.environment
  map_migrated = var.map_migrated
  repository_names = var.repository_names
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "ascent-terraform-statefile"
    key    = "commonservices/prod/vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}

data "terraform_remote_state" "ec2" {
  backend = "s3"
  config = {
    bucket = "ascent-terraform-statefile"
    key    = "commonservices/prod/ec2/terraform.tfstate"
    region = "ap-south-1"
  }
}

# Commonservice-EKS Cluster
data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "ascent-terraform-statefile"
    key    = "commonservices/prod/eks/terraform.tfstate"
    region = "ap-south-1"
  }
}
