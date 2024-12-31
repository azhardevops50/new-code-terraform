variable "region" {
  description = "AWS region where resources will be created"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  default     = "1.31"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
}

variable "node_instance_type" {
  description = "Instance type for EKS nodes"
  default     = "t3a.medium"
}

variable "node_group_size" {
  description = "Node group scaling configuration"
  type        = object({
    desired = number
    min     = number
    max     = number
  })
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
}
