variable "environment" {
  description = "Environment -Dev/QA/Stage/Prod"
}
variable "project_name" {
  description = "ProjectName" 
}
variable "map_migrated" {
  description = "MAP migration ID"
}
variable "eks_cluster_name" {
    type = string
}
variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_additionaltags" {
  type = map(string)
}

variable "private_subnet_additionaltags" {
  type = map(string)
}
