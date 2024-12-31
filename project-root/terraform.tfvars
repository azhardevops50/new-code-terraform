environment = "dev"
region      = "us-east-1"

vpc_cidr             = "10.50.0.0/16"
public_subnet_cidrs  = ["10.50.1.0/24", "10.50.2.0/24", "10.50.3.0/24"]
private_subnet_cidrs = ["10.50.4.0/24", "10.50.5.0/24", "10.50.6.0/24"]

eks_cluster_name = "ocr-eks-cluster"

kubernetes_version = "1.31"

ecr_repository_name = "ocr-django-service"

node_instance_type = "t3a.medium"
image_tag          = "1.0.0"
datadog_enabled    = true

node_group_size = {
  desired = 2
  min     = 1
  max     = 3
}

tags = {
  Environment = "Development"
  Project     = "OCR"
}